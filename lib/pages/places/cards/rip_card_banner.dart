import 'package:munch_app/api/file_api.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/pages/places/cards/rip_card.dart';
import 'package:munch_app/pages/places/rip_page.dart';
import 'package:munch_app/styles/munch.dart';
import 'package:munch_app/utils/munch_analytic.dart';

class RIPCardBanner extends RIPCardWidget {
  RIPCardBanner(PlaceData data, {@required this.ripState})
      : super(
          data,
          margin: const RIPCardInsets.only(left: 0, right: 0, top: 0),
        );

  final RIPPageState ripState;

  List<ImageSize> buildImages(PlaceData data) {
    if (data.place.images.isNotEmpty) {
      return data.place.images[0]?.sizes;
    }

    if (data.images.isNotEmpty) {
      return data.images[0]?.sizes;
    }

    return [];
  }

  void onGallery() {
    final controller = ripState.controller;
    var max = controller.position.maxScrollExtent - 330;
    max = max < 0 ? 0 : max;
    controller.animateTo(max, duration: const Duration(milliseconds: 400), curve: Curves.easeOut);

    MunchAnalytic.logEvent("rip_click_show_images");
  }

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    final height = (MediaQuery.of(context).size.height) * 0.38;

    final sizes = buildImages(data);

    List<Widget> children = [
      Container(
        height: height,
        width: double.infinity,
        child: ShimmerSizeImage(
          minHeight: height,
          sizes: sizes,
        ),
      )
    ];

    if (sizes.isNotEmpty) {
      children.add(Container(
        height: height,
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
      ));
    }

    return Stack(children: children);
  }
}
