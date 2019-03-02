import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/feed_api.dart';
import 'package:munch_app/api/location.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/main.dart';
import 'package:munch_app/pages/feed/feed_cell.dart';
import 'package:munch_app/pages/feed/feed_header_view.dart';
import 'package:munch_app/pages/feed/feed_manager.dart';
import 'package:munch_app/pages/filter/location_select_page.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/munch_bottom_dialog.dart';
import 'package:munch_app/utils/munch_analytic.dart';
import 'package:munch_app/utils/user_defaults_key.dart';

class FeedPage extends StatefulWidget with TabWidget {
  static FeedPageState state = FeedPageState();

  FeedPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => state;

  @override
  void didTabAppear(TabParent parent) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      final context = state?.context;
      if (context == null) return;
      if (parent.tab != MunchTab.feed) return;

      UserDefaults.instance.notify(UserDefaultsKey.notifyFeedWelcome, () {
        showBottomDialog(
          context: context,
          title: "Welcome to the Munch Feed!",
          message: "See something you like? Click on any image to find out more.",
        );
      });
    });
  }
}

class FeedPageState extends State<FeedPage> with WidgetsBindingObserver {
  final FeedManager manager = FeedManager();
  final ScrollController _controller = ScrollController();
  List<Object> items = [];
  NamedLocation location;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    manager.stream().listen((items) {
      setState(() {
        this.items = items;
      });
    }, onError: (e, s) {
      MunchDialog.showError(context, e);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (DateTime.now().millisecondsSinceEpoch - pausedDateTime.millisecondsSinceEpoch > 1000 * 60 * 60) {
        manager.reset();
      }
    }
  }

  bool scrollToTop() {
    if (_controller.offset == 0) return true;

    if (this.items.isNotEmpty) {
      _controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    return false;
  }

  void onLocation() {
    SearchLocationPage.push(context).then((location) {
      if (location == null) return;

      setState(() {
        this.location = location;
      });
      manager.reset(latLng: location.latLng);
    });
  }

  void clearLocation() {
    setState(() {
      location = null;
    });
    manager.reset();
  }

  void reset() {
    if (location != null) {
      setState(() => location = null);
    }
    manager.reset();
  }

  Future _onRefresh() {
    return manager.reset();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: MunchColors.white,
        child: Stack(
          children: [
            RefreshIndicator(
              color: MunchColors.secondary500,
              backgroundColor: MunchColors.white,
              onRefresh: _onRefresh,
              child: StaggeredGridView.countBuilder(
                controller: _controller,
                crossAxisCount: 2,
                itemCount: this.items.length,
                itemBuilder: (BuildContext context, int index) {
                  Object item = this.items[index];
                  switch (item) {
                    case FeedStaticCell.loading:
                      manager.append();
                      return FeedLoadingView();

                    case FeedStaticCell.noResult:
                      return FeedNoResultView();

                    default:
                      return FeedImageView(item: item);
                  }
                },
                staggeredTileBuilder: (int index) {
                  Object item = this.items[index];
                  switch (item) {
                    case FeedStaticCell.loading:
                    case FeedStaticCell.noResult:
                      return StaggeredTile.fit(2);

                    default:
                      return StaggeredTile.fit(1);
                  }
                },
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 72),
              ),
            ),
            FeedHeaderBar(
              name: location?.name,
              onDiscover: onLocation,
              onCancel: clearLocation,
            ),
          ],
        ),
      ),
    );
  }
}
