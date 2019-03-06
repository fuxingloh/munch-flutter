import 'package:munch_app/pages/contents/content_page.dart';
import 'package:munch_app/pages/contents/items/content_item.dart';

class ContentLine extends ContentItemWidget {
  const ContentLine(CreatorContentItem item, ContentPageState state) : super(item, state);

  @override
  Widget buildCard(BuildContext context, ContentPageState state, CreatorContentItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const _ContentLineDot(),
        const _ContentLineDot(),
        const _ContentLineDot(),
        const _ContentLineDot(),
      ],
    );
  }
}

class _ContentLineDot extends StatelessWidget {
  const _ContentLineDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: MunchColors.black50,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
    );
  }
}
