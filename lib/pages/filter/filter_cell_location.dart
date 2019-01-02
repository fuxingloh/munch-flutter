import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:munch_app/pages/filter/filter_area_page.dart';
import 'package:munch_app/pages/filter/filter_manager.dart';
import 'package:munch_app/styles/buttons.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/styles/texts.dart';

const MunchButtonStyle _searchStyle = MunchButtonStyle(
  textColor: MunchColors.black75,
  background: Color(0xFFFCFCFC),
  borderColor: MunchColors.black15,
  borderWidth: 1,
  height: 30,
  padding: 0,
  textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
);

class FilterCellLocation extends StatelessWidget {
  const FilterCellLocation({this.item, this.manager});

  final FilterItemLocation item;
  final FilterManager manager;

  @override
  Widget build(BuildContext context) {
    SearchFilterLocationType type = manager.searchQuery?.filter?.location?.type;

    List<Widget> children = [
      Padding(
        padding:
            const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Where", style: MTextStyle.h2),
            MunchButton.text("Search",
                onPressed: () => _onSearch(context), style: _searchStyle)
          ],
        ),
      )
    ];

    if (type == SearchFilterLocationType.Where) {
      var areas = manager.searchQuery?.filter?.location?.areas;
      if (areas != null && areas.length > 0)
        children.add(Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
          child: WhereButton(
            area: areas[0],
            onPressed: () {
              manager.selectLocationType(SearchFilterLocationType.Anywhere);
            },
          ),
        ));
    }

    children.add(Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 16),
      child: Row(
        children: [
          _FilterLocationButton(
              icon: MunchIcons.filter_between,
              selected: type == SearchFilterLocationType.Between,
              text: "EatBetween",
              onPressed: () {
                // TODO
              }),
          _FilterLocationButton(
              icon: MunchIcons.filter_nearby,
              selected: type == SearchFilterLocationType.Nearby,
              text: "Nearby",
              onPressed: () {
                manager.selectLocationType(SearchFilterLocationType.Nearby);
              }),
          _FilterLocationButton(
              icon: MunchIcons.filter_anywhere,
              selected: type == SearchFilterLocationType.Anywhere,
              text: "Anywhere",
              onPressed: () {
                manager.selectLocationType(SearchFilterLocationType.Anywhere);
              }),
        ],
      ),
    ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  void _onSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FilterAreaPage()),
    ).then((area) {
      if (area == null) return;
      manager.selectArea(area);
    });
  }
}

class _FilterLocationButton extends StatelessWidget {
  const _FilterLocationButton({
    Key key,
    this.selected,
    this.onPressed,
    this.text,
    this.icon,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    var gesture = GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(left: 9, right: 9),
        decoration: BoxDecoration(
          color: selected ? MunchColors.primary500 : MunchColors.whisper100,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              size: 32,
              color: selected ? MunchColors.white : MunchColors.black75,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: selected ? MunchColors.white : MunchColors.black75,
            ),
          ),
        ]),
      ),
    );

    return Expanded(child: AspectRatio(aspectRatio: 1.4, child: gesture));
  }
}

class WhereButton extends StatelessWidget {
  const WhereButton({Key key, this.onPressed, this.area}) : super(key: key);

  final VoidCallback onPressed;
  final Area area;

  @override
  Widget build(BuildContext context) {
    // TOOD Cancel
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: MunchColors.primary500,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                area.name,
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: MunchColors.white),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 12),
              child: Icon(MunchIcons.filter_cancel, color: MunchColors.white,),
            )
          ],
        ),
      ),
    );
  }
}
