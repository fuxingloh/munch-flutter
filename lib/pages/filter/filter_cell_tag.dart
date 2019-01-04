import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/pages/filter/filter_manager.dart';
import 'package:munch_app/styles/colors.dart';
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
  FilterCellTag({this.item, this.manager});

  final FilterItemTag item;
  final FilterManager manager;

  FilterTag get tag => item.tag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => manager.selectTag(tag),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(tag.name, style: MTextStyle.regular),
              _right()
            ],
          ),
        ));
  }

  Row _right() {
    bool selected = manager.isSelectedTag(tag);
    String count =
        FilterManager.countTitle(count: tag.count, prefix: "", postfix: "");

    return Row(
      children: <Widget>[
        Text(
          count,
          style: MTextStyle.regular.copyWith(
            fontWeight: FontWeight.w500,
            color: MunchColors.black75,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            shape: BoxShape.rectangle,
            color: selected ? MunchColors.primary500 : MunchColors.clear,
            border: Border.all(
                color: selected ? MunchColors.primary500 : MunchColors.black75,
                width: 2),
          ),
          child: Container(
            width: 20,
            height: 20,
            child: selected
                ? Icon(Icons.check, size: 20.0, color: Colors.white)
                : null,
          ),
        )
      ],
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
        "${item.count} hidden with 0 results",
        style: MTextStyle.regular.copyWith(color: MunchColors.secondary500),
      ),
    );
  }
}
