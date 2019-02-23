import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/feed_api.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/main.dart';
import 'package:munch_app/pages/feed/feed_cell.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/utils/munch_analytic.dart';

class FeedPage extends StatefulWidget {
  static _FeedState state = _FeedState();

  FeedPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => state;
}

class _FeedState extends State<FeedPage> with WidgetsBindingObserver {
  final FeedManager manager = FeedManager();
  final ScrollController _controller = ScrollController();
  List<Object> items = [];

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
      if (DateTime
          .now()
          .millisecondsSinceEpoch - pausedDateTime.millisecondsSinceEpoch > 1000 * 60 * 60) {
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

  void reset() {
    manager.reset();
  }

  Future _onRefresh() {
    return manager.reset();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
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
              case FeedStaticCell.header:
                return FeedHeaderView();

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
              case FeedStaticCell.header:
              case FeedStaticCell.loading:
              case FeedStaticCell.noResult:
                return StaggeredTile.fit(2);

              default:
                return StaggeredTile.fit(1);
            }
          },
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          padding: const EdgeInsets.all(24),
        ),
      ),
    );
  }
}

enum FeedStaticCell { header, loading, noResult }

class FeedManager {
  final MunchApi _api = MunchApi.instance;

  List<ImageFeedItem> _items = [];
  DateTime lastEventDate;

  int _from = 0;
  bool _loading = false;

  StreamController<List<Object>> _controller;

  Stream<List<Object>> stream() {
    _controller = StreamController<List<Object>>();
    _controller.add(collect());
    this.append();
    return _controller.stream;
  }

  Future reset() {
    _items.clear();
    _from = 0;
    _loading = false;
    _controller.add(collect());
    return append();
  }

  Future append() {
    if (_from == null) return Future.value();
    if (_from > 500) return Future.value();
    if (_loading) return Future.value();

    _loading = true;

    return _api.post("/feed/query?next.from=$_from", body: {}).then((res) {
      this._loading = false;
      this._from = res.next['from'];

      var items = ImageFeedItem.fromJsonList(res.data);
      var places = Place.fromJsonMap(res['places']);
      items.forEach((item) {
        item.places = item.places.map((p) => places[p.placeId]).where((p) => p != null).toList(growable: false);

        // Only Add Items that have places to ensure non null constraints
        if (item.places.isEmpty) return;
        this._items.add(item);
      });

      _controller.add(collect());

      MunchAnalytic.logEvent("feed_query", parameters: {"count": _from ?? 0});
    }).catchError((error) => _controller.addError(error));
  }

  List<Object> collect() {
    List<Object> collected = [];
    collected.add(FeedStaticCell.header);
    collected.addAll(_items);

    if (_loading || _from != null) {
      collected.add(FeedStaticCell.loading);
    } else if (_items.isEmpty) {
      collected.add(FeedStaticCell.noResult);
    }

    return collected;
  }
}
