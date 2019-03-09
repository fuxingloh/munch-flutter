import 'package:munch_app/pages/contents/content_page.dart';
import 'package:munch_app/pages/contents/items/content_item.dart';

class ContentTextBody extends ContentItemWidget {
  ContentTextBody(CreatorContentItem item, ContentPageState state)
      : super(item, state, margin: const ContentItemInsets.only(top: 0, bottom: 0));

  @override
  Widget buildCard(BuildContext context, ContentPageState state, CreatorContentItem item) {
    return Padding(
      padding: insets,
      child: RichText(
        text: TextSpan(text: "", style: style, children: children),
      ),
    );
  }

  EdgeInsets get insets {
    switch (item.type) {
      case "title":
        return const EdgeInsets.only(top: 24, bottom: 12);
      case "h1":
        return const EdgeInsets.only(top: 12, bottom: 12);
      case "h2":
        return const EdgeInsets.only(top: 12, bottom: 12);
      default:
        return const EdgeInsets.only(top: 0, bottom: 12);
    }
  }

  TextStyle get style {
    switch (item.type) {
      case "title":
      case "h1":
        return MTextStyle.h2;
      case "h2":
        return MTextStyle.h3;
      default:
        return TextStyle(
          fontSize: 16,
          height: 1.4,
          color: MunchColors.black80,
        );
    }
  }

  List<TextSpan> get children {
    List<dynamic> list = item.body['content'];
    return list.map((span) {
      return TextSpan(text: span['text']);
    }).toList(growable: false);
  }
}
