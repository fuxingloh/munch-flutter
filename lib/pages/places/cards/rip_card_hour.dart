import 'package:flutter/material.dart';
import 'package:munch_app/pages/places/cards/rip_card.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/utils/munch_analytic.dart';

class RIPCardHour extends RIPCardWidget {
  RIPCardHour(PlaceData data) : super(data);

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    List<Widget> children = [];

    HourGrouped grouped = HourGrouped(hours: data.place.hours);
    const base = TextStyle(fontWeight: FontWeight.w600, fontSize: 19);

    switch (grouped.isOpen()) {
      case HourOpen.open:
        children.add(
          Text("Open Now", style: base.copyWith(color: MunchColors.open)),
        );
        break;

      case HourOpen.opening:
        children.add(
          Text("Opening Soon", style: base.copyWith(color: MunchColors.open)),
        );
        break;

      case HourOpen.closed:
        children.add(
          Text("Closed Now", style: base.copyWith(color: MunchColors.close)),
        );
        break;

      case HourOpen.closing:
        children.add(
          Text("Closing Soon", style: base.copyWith(color: MunchColors.close)),
        );
        break;

      default:
        break;
    }

    children.add(Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        grouped.todayTime,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
        const Icon(MunchIcons.rip_expand),
      ],
    );
  }

  @override
  void onTap(BuildContext context, PlaceData data) {
    MunchAnalytic.logEvent("rip_click_hour");

    showModalBottomSheet(
      context: context,
      builder: (context) => _HourListModal(data: data),
    );
  }

  static bool isAvailable(PlaceData data) {
    return data.place.hours.isNotEmpty;
  }
}

class _HourListModal extends StatelessWidget {
  final PlaceData data;

  const _HourListModal({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HourGrouped grouped = HourGrouped(hours: data.place.hours);
    Widget _hourLine(HourDay day, String text) {
      List<Widget> children = [
        Text(text, style: TextStyle(fontWeight: FontWeight.w600)),
      ];

      if (grouped.isToday(day)) {
        switch (grouped.isOpen()) {
          case HourOpen.open:
          case HourOpen.opening:
          case HourOpen.closing:
            children.add(Text(grouped[day], style: const TextStyle(color: MunchColors.open)));
            break;

          case HourOpen.none:
          case HourOpen.closed:
            children.add(Text(grouped[day], style: const TextStyle(color: MunchColors.close)));
            break;
        }
      } else {
        children.add(Text(grouped[day]));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    }

    List<Widget> hours = [
      _hourLine(HourDay.mon, "Monday"),
      _hourLine(HourDay.tue, "Tuesday"),
      _hourLine(HourDay.wed, "Wednesday"),
      _hourLine(HourDay.thu, "Thursday"),
      _hourLine(HourDay.fri, "Friday"),
      _hourLine(HourDay.sat, "Saturday"),
      _hourLine(HourDay.sun, "Sunday"),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
          child: Text("${data.place.name} Hours", style: MTextStyle.h2),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              itemBuilder: (c, i) => hours[i],
              separatorBuilder: (c, i) => SizedBox(height: 12),
              itemCount: hours.length,
            ),
          ),
        )
      ],
    );
  }
}
