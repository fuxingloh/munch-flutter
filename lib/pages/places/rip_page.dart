import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/authentication.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/places/cards/rip_card.dart';
import 'package:munch_app/pages/places/cards/rip_card_gallery.dart';
import 'package:munch_app/pages/places/cards/rip_card_loading.dart';
import 'package:munch_app/pages/places/rip_footer.dart';
import 'package:munch_app/pages/places/rip_header.dart';
import 'package:munch_app/pages/places/rip_image_loader.dart';
import 'package:munch_app/pages/places/rip_image_page.dart';

class RIPPage extends StatefulWidget {
  const RIPPage({Key key, this.place}) : super(key: key);

  final Place place;

  @override
  State<StatefulWidget> createState() => RIPPageState();
}

class RIPPageState extends State<RIPPage> {
  ScrollController controller;
  RIPImageLoader _imageLoader;
  bool _clear = true;

  PlaceData placeData;
  List<Widget> widgets = RIPCardDelegator.loading;
  List<PlaceImage> images;

  @override
  void initState() {
    super.initState();
//  Crashlytics.sharedInstance().setObjectValue(placeId, forKey: "RIPController.placeId")
    MunchApi.instance
        .get('/places/${widget.place.placeId}')
        .then((res) => PlaceData.fromJson(res.data))
        .then(_start, onError: (error) {
      MunchDialog.showError(context, error);
    });

    controller = ScrollController();
    controller.addListener(_scrollListener);
  }

  _start(PlaceData placeData) {
    setState(() {
      this.placeData = placeData;
      this.images = placeData.images;
      this.widgets = RIPCardDelegator.delegate(placeData, this);
    });

    _imageLoader = RIPImageLoader();
    _imageLoader.start(placeData.place.placeId, placeData.images).listen(
      (images) {
        setState(() {
          this.images = images;
        });
      },
      onError: (error) {
        MunchDialog.showError(context, error);
      },
    );

    Authentication.instance.isAuthenticated().then((auth) {
      if (!auth) return;
      MunchApi.instance
          .put('/users/recent/places/${placeData.place.placeId}')
          .catchError(
        (error) {
          MunchDialog.showError(context, error);
        },
      );
    });
  }

  _scrollListener() {
    // Check if to Load More
    if (_imageLoader.more) {
      final position = controller.position;
      if (position.pixels > position.maxScrollExtent - 100) {
        _imageLoader.append();
      }
    }

    if (controller.offset > 120) {
      if (!_clear) return;
      setState(() {
        _clear = false;
      });
    } else {
      if (_clear) return;
      setState(() {
        _clear = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> slivers = [];

    widgets.forEach((widget) {
      slivers.add(SliverToBoxAdapter(child: widget));
    });

    // If Images is loaded
    if (_imageLoader != null) {
      slivers.add(SliverPadding(
        padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
        sliver: SliverStaggeredGrid.countBuilder(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          staggeredTileBuilder: (i) => StaggeredTile.fit(1),
          itemBuilder: (context, i) =>
              RIPGalleryImage(image: images[i], onPressed: () => onImage(i)),
          itemCount: images.length,
        ),
      ));

      slivers.add(SliverToBoxAdapter(
        child: RIPCardLoadingGallery(loading: _imageLoader?.more ?? false),
      ));
    }

    return Scaffold(
      body: Stack(children: [
        CustomScrollView(
          controller: controller,
          slivers: slivers,
        ),
        RIPHeader(placeData: placeData, clear: _clear),
      ]),
      bottomNavigationBar: RIPFooter(placeData: placeData),
    );
  }

  void onImage(int i) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => RIPImagePage(
              index: i,
              imageLoader: _imageLoader,
              place: placeData.place,
            ),
      ),
    );
  }
}
