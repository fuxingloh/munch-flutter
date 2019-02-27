import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:munch_app/api/authentication.dart';
import 'package:munch_app/api/feed_api.dart';
import 'package:munch_app/api/file_api.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/components/bottom_sheet.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/pages/feed/feed_item_page.dart';
import 'package:munch_app/pages/places/rip_page.dart';
import 'package:munch_app/pages/profile/tastebud_saved_place_database.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/styles/texts.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:munch_app/utils/munch_analytic.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedImageView extends StatelessWidget {
  const FeedImageView({Key key, @required this.item}) : super(key: key);

  final FeedItem item;

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 16 - 16 - 16) / 2;

    return GestureDetector(
      onTap: () => onItem(context),
      child: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: item.image.aspectRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: ShimmerSizeImage(
                minWidth: width,
                sizes: item.image.sizes,
              ),
            ),
          ),
          FeedImageBottom(item: item, onItem: () => onItem(context))
        ],
      ),
    );
  }

  void onItem(BuildContext context) {
    final place = item.places?.first;
    final sizes = item.image?.sizes;
    final instagram = item.instagram;

    if (place == null) return;
    if (sizes == null) return;
    if (instagram == null) return;

    MunchAnalytic.logEvent("feed_item_click", parameters: {
      "type": FeedItem.getTypeName(item),
    });

    CreditedImage image = CreditedImage(
      sizes: sizes,
      name: instagram.username,
      link: instagram.link,
    );
    RIPPage.push(context, place, focusedImage: image);
  }
}

class FeedImageBottom extends StatelessWidget {
  final FeedItem item;
  final VoidCallback onItem;

  const FeedImageBottom({Key key, this.item, this.onItem}) : super(key: key);

  String get name {
    if (item.places.isEmpty) {
      return "";
    }
    return item.places[0].name;
  }

  Place get place {
    if (item.places.isEmpty) {
      return null;
    }

    return item.places[0];
  }

  void _launch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 6),
          child: Text(
            name,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: MunchColors.black80),
          ),
        ),
        GestureDetector(
          onTap: () => onTap(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 6, right: 2, top: 6, bottom: 6),
            child: Icon(MunchIcons.navigation_more, size: 12, color: MunchColors.black75),
          ),
        )
      ],
    );
  }

  void onTap(BuildContext context) {
    List<MunchBottomSheetTile> children = [];

    final author = item.author;
    final link = item.instagram?.link;
    if (author != null && link != null) {
      children.add(MunchBottomSheetTile(
        onPressed: () {
          Navigator.pop(context);
          MunchDialog.showConfirm(context, content: "Open Instagram?", onPressed: () {
            _launch(link);
          });
        },
        icon: const Icon(MunchIcons.navigation_more),
        child: Text("More from $author"),
      ));
    }

    children.addAll([
      MunchBottomSheetTile(
        onPressed: () {
          Navigator.pop(context);
          onItem();
        },
        icon: const Icon(MunchIcons.location_pin),
        child: const Text("View Place"),
      ),
      MunchBottomSheetTile(
        onPressed: () {
          Navigator.pop(context);
          onSave(context);
        },
        icon: const Icon(MunchIcons.rip_heart),
        child: const Text("Save Place"),
      ),
      MunchBottomSheetTile(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(MunchIcons.navigation_cancel),
        child: const Text("Cancel"),
      ),
    ]);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return MunchBottomSheet(
          children: children,
        );
      },
    );
  }

  void onSave(BuildContext context) {
    if (place == null) return;

    Authentication.instance.requireAuthentication(context).then((state) {
      if (state != AuthenticationState.loggedIn) return;

      PlaceSavedDatabase.instance.put(place.placeId).then((_) {
        MunchAnalytic.logEvent("rip_heart_saved");
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Saved "${place.name}" from your places.')),
        );
      }).catchError((error) {
        MunchDialog.showError(context, error);
      });
    });
  }
}

class FeedLoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitThreeBounce(
        color: MunchColors.secondary500,
        size: 24.0,
      ),
    );
  }
}

class FeedNoResultView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Sorry! We couldn't not find anything in the provided location.",
      textAlign: TextAlign.center,
      style: MTextStyle.h5,
    );
  }
}
