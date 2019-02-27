import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/api/user_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/places/place_card.dart';
import 'package:munch_app/main.dart';
import 'package:munch_app/pages/profile/tastebud_saved_place_database.dart';
import 'package:munch_app/styles/buttons.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/texts.dart';
import 'package:munch_app/utils/munch_analytic.dart';

class TastebudPlacePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TastebudPlaceState();
}

class TastebudPlaceState extends State<TastebudPlacePage> {
  List<UserSavedPlace> items = [];

  @override
  void initState() {
    super.initState();

    PlaceSavedDatabase.instance.observe().listen((items) {
      setState(() {
        this.items = items;
      });
    }, onError: (e, s) {
      MunchDialog.showError(context, e);
    }, onDone: () {
      print("Completed");
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [items.isEmpty ? _buildDiscover() : _buildHeader()];

    items.forEach((place) {
      children.add(_buildPlace(place.place));
    });

    children.add(SizedBox(height: 64));
    return ListView(children: children);
  }

  Container _buildDiscover() {
    return Container(
      margin: EdgeInsets.fromLTRB(24, 24, 24, 12),
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: MunchColors.whisper100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Places you add to your Tastebud will be saved here.',
            style: MTextStyle.h5,
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            alignment: Alignment.bottomRight,
            child: MunchButton.text("Discover", onPressed: () {
              tabState.onTab(1);
            }),
          )
        ],
      ),
    );
  }

  Container _buildHeader() {
    return Container(
      margin: EdgeInsets.fromLTRB(24, 32, 24, 8),
      child: const Text("Saved Places", style: MTextStyle.h2),
    );
  }

  Container _buildPlace(Place place) {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
      child: PlaceCard(
          place: place,
          onHeart: () {
            PlaceSavedDatabase.instance.delete(place.placeId).then((_) {
              MunchAnalytic.logEvent("rip_heart_deleted");
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('Deleted "${place.name}" from your places.')),
              );
            }).catchError((error) {
              MunchDialog.showError(context, error);
            });
          }),
    );
  }
}
