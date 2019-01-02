import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:munch_app/pages/filter/filter_manager.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/styles/texts.dart';

DateFormat _timeFormat = DateFormat("HH:MM");
DateFormat _dayFormat = DateFormat("EEE");

List<Tag> _timings = [
  Tag("f749ab1a-358c-4ba2-adb8-04a3accf46cb", "Breakfast", TagType.Timing),
  Tag("1be094a8-b9f5-43ca-9af7-f0ae2d87afb2", "Lunch", TagType.Timing),
  Tag("32d11ac3-afb2-4e1e-a798-97771958294c", "Dinner", TagType.Timing),
  Tag("97c3121f-7947-4950-8a63-027ef1d6337a", "Supper", TagType.Amenities),
];

class FilterCellHour extends StatelessWidget {
  const FilterCellHour({Key key, this.item, this.manager}) : super(key: key);

  final FilterItemTiming item;
  final FilterManager manager;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      _FilterHourCell(
        icon: MunchIcons.filter_timing,
        name: "Open Now",
        selected: manager.isSelectedHour(SearchFilterHourType.OpenNow),
        onPressed: onPressedNow,
      ),
    ];

    _timings.forEach((tag) {
      var selected = manager.isSelectedTag(tag);
      children.add(_FilterHourCell(
        name: tag.name,
        selected: selected,
        onPressed: () => onPressedTag(tag),
      ));
    });

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
            child: Text("Timing", style: MTextStyle.h2),
          ),
          Container(
            height: 36,
            margin: EdgeInsets.only(bottom: 16),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 24, right: 24),
              itemBuilder: (c, i) => children[i],
              separatorBuilder: (c, i) => SizedBox(width: 16),
              itemCount: children.length,
            ),
          ),
        ],
      ),
    );
  }

  void onPressedNow() {
    if (manager.isSelectedHour(SearchFilterHourType.OpenNow)) {
      manager.selectHour(null);
    } else {
      DateTime dateTime = DateTime.now();
      String day = _dayFormat.format(dateTime).toLowerCase();
      String open = _timeFormat.format(dateTime);
      String close = '23:59';

      if (dateTime.hour != 23) {
        dateTime.add(Duration(minutes: 30));
        close = _timeFormat.format(dateTime);
      }

      manager.selectHour(
          SearchFilterHour(SearchFilterHourType.OpenNow, day, open, close));
    }
  }

  void onPressedTag(Tag tag) {
    manager.selectTag(tag);
  }
}

class _FilterHourCell extends StatelessWidget {
  const _FilterHourCell(
      {Key key, this.name, this.icon, this.selected, this.onPressed})
      : super(key: key);

  final String name;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    if (icon != null) {
      children.add(Icon(icon));
    }

    children.add(Text(
      name,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 15,
        color: selected ? MunchColors.white : MunchColors.black75,
      ),
    ));

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: icon != null ? 128 : 104,
        height: 36,
        decoration: BoxDecoration(
          color: selected ? MunchColors.primary500 : MunchColors.whisper100,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: children,
        ),
      ),
    );
  }
}
