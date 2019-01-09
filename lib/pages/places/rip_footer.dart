import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/api/places_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/elevations.dart';
import 'package:munch_app/styles/icons.dart';

import 'package:munch_app/pages/tastebud/tastebud_saved_place_database.dart';

class RIPFooter extends StatefulWidget {
  const RIPFooter({Key key, this.placeData}) : super(key: key);

  final PlaceData placeData;

  @override
  RIPFooterState createState() => RIPFooterState();
}

class RIPFooterState extends State<RIPFooter> {
  void onHeart() {
    Place place = widget.placeData.place;

    if (isHeart) {
      PlaceSavedDatabase.instance.delete(place.placeId).then((_) {
        setState(() => localHeart = false);
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Deleted "${place.name}" from your places.')),
        );
      }).catchError((error) {
        MunchDialog.showError(context, error);
      });
    } else {
      PlaceSavedDatabase.instance.put(place.placeId).then((_) {
        setState(() => localHeart = true);
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Saved "${place.name}" from your places.')),
        );
      }).catchError((error) {
        MunchDialog.showError(context, error);
      });
    }
  }

  bool localHeart;

  bool get isHeart {
    if (localHeart != null) return localHeart;
    return widget.placeData?.user?.savedPlace != null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.placeData == null) {
      return Container(
        height: 56,
        decoration: const BoxDecoration(
            color: MunchColors.white, boxShadow: elevation2),
        padding: const EdgeInsets.only(left: 24, right: 24),
      );
    }

    return Container(
      height: 56,
      decoration:
          const BoxDecoration(color: MunchColors.white, boxShadow: elevation2),
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onHeart,
            child: Icon(
                isHeart ? MunchIcons.rip_heart_filled : MunchIcons.rip_heart,
                size: 26),
          )
        ],
      ),
    );
  }
}
