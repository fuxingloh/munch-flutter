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

class RIPPage extends StatefulWidget {
  const RIPPage({Key key, this.place}) : super(key: key);

  final Place place;

  @override
  State<StatefulWidget> createState() => RIPPageState();
}

class RIPPageState extends State<RIPPage> {
  ScrollController _controller;
  RIPImageLoader _imageLoader;
  bool _clear = true;

  PlaceData placeData;
  List<Widget> widgets = RIPCardDelegator.loading;
  List<PlaceImage> images;

  @override
  void initState() {
    super.initState();
//        Crashlytics.sharedInstance().setObjectValue(placeId, forKey: "RIPController.placeId")
    MunchApi.instance
        .get('/places/${widget.place.placeId}')
        .then((res) => PlaceData.fromJson(res.data))
        .then(_start, onError: (error) {
      MunchDialog.showError(context, error);
    });

    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  _start(PlaceData placeData) {
    setState(() {
      this.placeData = placeData;
      this.images = placeData.images;
      this.widgets = RIPCardDelegator.delegate(placeData);
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
          .put('/users/recent/places${placeData.place.placeId}')
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
      final position = _controller.position;
      if (position.pixels > position.maxScrollExtent - 100) {
        _imageLoader.append();
      }
    }

    if (_controller.offset > 120) {
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

  int get _count {
    if (placeData == null) return widgets.length;
    if (images.isEmpty) return widgets.length;
    return widgets.length + images.length + 1;
  }

  @override
  Widget build(BuildContext context) {
    final count = _count;

    var gridView = StaggeredGridView.countBuilder(
      controller: _controller,
      itemCount: count,
      padding: const EdgeInsets.only(left: 24, right: 24),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemBuilder: (context, i) {
        if (widgets.length > i) return widgets[i];
        if (count - 1 == i)
          return RIPCardLoadingGallery(loading: _imageLoader.more);
        return RIPGalleryImage(image: images[i - widgets.length]);
      },
      staggeredTileBuilder: (i) {
        if (widgets.length > i) return StaggeredTile.fit(2);
        if (count - 1 == i) return StaggeredTile.fit(2);
        return StaggeredTile.fit(1);
      },
    );

    return Scaffold(
      body: Stack(children: [
        gridView,
        RIPHeader(placeData: placeData, clear: _clear),
      ]),
      bottomNavigationBar: RIPFooter(),
    );
  }
}
