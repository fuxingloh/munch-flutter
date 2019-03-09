import 'package:munch_app/api/file_api.dart' as api;
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/pages/contents/content_page.dart';
import 'package:munch_app/pages/contents/items/content_item.dart';

class ContentImage extends ContentItemWidget {
  ContentImage(CreatorContentItem item, ContentPageState state)
      : super(item, state);

  api.Image get image {
    final image = this.item.body['image'];
    if (image == null) return null;
    return api.Image.fromJson(image);
  }

  @override
  Widget buildCard(BuildContext context, ContentPageState state, CreatorContentItem item) {
    if (image == null) {
      return Container();
    }

    return AspectRatio(
      aspectRatio: image.aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: ShimmerSizeImage(
          sizes: image.sizes,
        ),
      ),
    );
  }
}
