import 'package:flutter/widgets.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/pages/filter/filter_manager.dart';
import 'package:munch_app/styles/texts.dart';


String _tagAsText(TagType type) {
  switch (type) {
    case TagType.Cuisine:
      return "Cuisine";
    case TagType.Amenities:
      return "Amenities";
    case TagType.Establishment:
      return "Establishment";
    case TagType.Requirement:
      return "Requirement";

    default:
      return "tag.header";
  }
}

class FilterCellTagHeader extends StatelessWidget {
  FilterCellTagHeader(this.item);

  final FilterItemTagHeader item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 10),
      child: Text(_tagAsText(item.type), style: MTextStyle.h2),
    );
  }
}

class FilterCellTag extends StatelessWidget {
  FilterCellTag(this.item);

  final FilterItemTag item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
      child: Text(
        item.tag.name,
        style: MTextStyle.large,
      ),
    );
  }
}

class FilterCellTagMore extends StatelessWidget {
  FilterCellTagMore(this.item);

  final FilterItemTagMore item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12),
      child: Text(
        _tagAsText(item.type),
        style: MTextStyle.regular,
      ),
    );
  }
}
