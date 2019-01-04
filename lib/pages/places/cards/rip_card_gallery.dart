import 'package:munch_app/api/file_api.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/pages/places/cards/rip_card.dart';
import 'package:munch_app/styles/separators.dart';

class RIPCardGalleryHeader extends RIPCardWidget {
  RIPCardGalleryHeader(PlaceData data)
      : super(data, margin: const RIPCardInsets.only(left: 0, right: 0));

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(bottom: 24),
          child: SeparatorLine(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Text('${data.place.name} Images', style: MTextStyle.h2),
        )
      ],
    );
  }

  static bool isAvailable(PlaceData data) {
    return data.images.isNotEmpty;
  }
}

class RIPGalleryImage extends StatelessWidget {
  final PlaceImage image;

  const RIPGalleryImage({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 24 - 24 - 16) / 2;

    ImageSize max = image.sizes.reduce((a, b) {
      return a.width.compareTo(b.width) >= 0 ? a : b;
    });

    return GestureDetector(
      onTap: () {
        // TODO RIP Image Page
      },
      child: AspectRatio(
        aspectRatio: max.width.toDouble() / max.height.toDouble(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: ShimmerSizeImage(
            minWidth: width,
            sizes: image.sizes,
          ),
        ),
      ),
    );
  }
}