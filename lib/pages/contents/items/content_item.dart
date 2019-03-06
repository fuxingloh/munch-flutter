import 'package:flutter/widgets.dart';
import 'package:munch_app/api/content_api.dart';
import 'package:munch_app/pages/contents/content_page.dart';
import 'package:munch_app/pages/contents/items/content_image.dart';
import 'package:munch_app/pages/contents/items/content_line.dart';
import 'package:munch_app/pages/contents/items/content_place.dart';
import 'package:munch_app/pages/contents/items/content_text_body.dart';

export 'package:flutter/widgets.dart';
export 'package:munch_app/api/content_api.dart';
export 'package:munch_app/styles/munch.dart';

class ContentItemDelegator {
  static Widget delegate(CreatorContentItem item, ContentPageState state) {
    switch (item.type) {
      case "title":
      case "h1":
      case "h2":
      case "text":
        return ContentTextBody(item, state);

      case "image":
        return ContentImage(item, state);

      case "line":
        return ContentLine(item, state);

      case "place":
        return ContentPlace(item, state);

      default:
        return Container();
    }
  }
}

class ContentItemInsets extends EdgeInsets {
  const ContentItemInsets.only({
    double left = 24.0,
    double right = 24.0,
    double top = 12.0,
    double bottom = 12.0,
  }) : super.fromLTRB(left, top, right, bottom);
}

abstract class ContentItemWidget extends StatelessWidget {
  const ContentItemWidget(
    this.item,
    this.state, {
    this.margin = const ContentItemInsets.only(),
  });

  final CreatorContentItem item;
  final ContentPageState state;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(context, item),
      child: Container(margin: margin, child: buildCard(context, state, item)),
    );
  }

  @protected
  void onTap(BuildContext context, CreatorContentItem item) {}

  @protected
  Widget buildCard(BuildContext context, ContentPageState state, CreatorContentItem item);
}
