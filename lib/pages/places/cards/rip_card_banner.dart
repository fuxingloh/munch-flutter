import 'package:flutter/material.dart';
import 'package:munch_app/api/file_api.dart';
import 'package:munch_app/components/bottom_sheet.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/pages/places/cards/rip_card.dart';
import 'package:munch_app/pages/places/rip_page.dart';
import 'package:munch_app/styles/munch.dart';
import 'package:munch_app/utils/munch_analytic.dart';
import 'package:url_launcher/url_launcher.dart';

class RIPCardBanner extends RIPCardWidget {
  RIPCardBanner(PlaceData data, {@required this.ripState})
      : super(
          data,
          margin: const RIPCardInsets.only(left: 0, right: 0, top: 0),
        );

  final RIPPageState ripState;

  void onGallery() {
    final controller = ripState.controller;
    var max = controller.position.maxScrollExtent - 330;
    max = max < 0 ? 0 : max;
    controller.animateTo(max, duration: const Duration(milliseconds: 400), curve: Curves.easeOut);

    MunchAnalytic.logEvent("rip_click_show_images");
  }

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    CreditedImage image = ripState.focusedImage;

    if (image != null) {
      return Stack(children: [
        AspectRatio(
          aspectRatio: image.aspectRatio,
          child: ShimmerSizeImage(
            sizes: image.sizes,
          ),
        ),
        GalleryButton(
          onGallery: onGallery,
        ),
        ImageCredit(image: image),
      ]);
    }

    return Container();
  }
}

class GalleryButton extends StatelessWidget {
  final VoidCallback onGallery;

  const GalleryButton({Key key, this.onGallery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        alignment: Alignment.bottomRight,
        padding: const EdgeInsets.only(right: 24, bottom: 16),
        child: GestureDetector(
          onTap: onGallery,
          child: Container(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              color: MunchColors.white,
              border: Border.all(color: MunchColors.black10, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const Icon(MunchIcons.rip_gallery, size: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    "SHOW IMAGES",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageCredit extends StatelessWidget {
  final CreditedImage image;

  const ImageCredit({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (image.name == null) {
      return Container();
    }

    return Positioned.fill(
      child: Container(
        alignment: Alignment.bottomLeft,
        child: GestureDetector(
          onTap: () => onTap(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 16, right: 24),
            child: Text("Image by:\n${image.name}", style: MTextStyle.smallBold.copyWith(color: MunchColors.white), maxLines: 2),
          ),
        ),
      ),
    );
  }

  void _launch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void onTap(BuildContext context) {
    if (image.link == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return MunchBottomSheet(
          children: [
            MunchBottomSheetTile(
              onPressed: () {
                Navigator.pop(context);
                _launch(image.link);
              },
              icon: const Icon(Icons.person),
              child: Text("More from ${image.name}"),
            ),

            MunchBottomSheetTile(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
