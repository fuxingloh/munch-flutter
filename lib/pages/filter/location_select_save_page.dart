import 'package:flutter/material.dart';
import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/authentication.dart';
import 'package:munch_app/api/user_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/styles/buttons.dart';
import 'package:munch_app/styles/munch.dart';

class SearchLocationSavePage extends StatefulWidget {
  const SearchLocationSavePage({Key key, this.location}) : super(key: key);

  final UserLocation location;

  @override
  SearchLocationSavePageState createState() {
    return new SearchLocationSavePageState();
  }

  static Future<T> push<T extends Object>(BuildContext context, UserLocation location) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (c) => SearchLocationSavePage(location: location),
        settings: const RouteSettings(name: '/search/locations/save'),
      ),
    );
  }
}

class SearchLocationSavePageState extends State<SearchLocationSavePage> {
  final List<UserLocationType> types = [
    UserLocationType.home,
    UserLocationType.work,
    UserLocationType.saved,
  ];

  final Map<UserLocationType, String> names = {
    UserLocationType.home: "Home",
    UserLocationType.work: "Work",
    UserLocationType.saved: "Others"
  };

  final Map<UserLocationType, IconData> icons = {
    UserLocationType.home: MunchIcons.location_home,
    UserLocationType.work: MunchIcons.location_work,
    UserLocationType.saved: MunchIcons.location_bookmark_filled,
  };

  UserLocationType type;

  Iterable<Widget> buildButtons() {
    return types.map((type) {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: SearchLocationSaveAsButton(
          text: names[type],
          icon: icons[type],
          onPressed: () => onType(type),
          selected: this.type == type,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Text(
        "Name:",
        style: MTextStyle.h4,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 16),
        child: Text(
          widget.location.name,
          style: MTextStyle.h3,
        ),
      ),
      Text(
        "Save as",
        style: MTextStyle.h4,
      ),
    ];
    children.addAll(buildButtons());

    return Scaffold(
      appBar: AppBar(title: Text("Add to Saved Locations")),
      body: ListView(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
        children: children,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 24),
        child: MunchButton.text(
          "Save Location",
          style: type != null ? MunchButtonStyle.secondaryOutline : MunchButtonStyle.disabled,
          onPressed: onPressed,
        ),
      ),
    );
  }

  void onType(UserLocationType type) {
    setState(() {
      this.type = type;
    });
  }

  void onPressed() {
    if (this.type == null) return;

    var location = UserLocation(
      type: this.type,
      input: widget.location.input,
      name: widget.location.name,
      latLng: widget.location.latLng,
    );

    MunchDialog.showProgress(context);

    Authentication.instance.isAuthenticated().then((authenticated) {
      if (authenticated) {
        MunchApi.instance.post('/users/locations', body: location).whenComplete(() {
          Navigator.of(context).pop();
        }).then((_) {
          Navigator.of(context).pop();
        }).catchError((error) {
          MunchDialog.showError(context, error);
        });
      }
    });
  }
}

class SearchLocationSaveAsButton extends StatelessWidget {
  const SearchLocationSaveAsButton({Key key, this.onPressed, this.selected, this.icon, this.text}) : super(key: key);

  final bool selected;
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? MunchColors.secondary400 : MunchColors.whisper200,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
              child: Icon(
                icon,
                size: 24,
                color: selected ? MunchColors.white : MunchColors.black,
              ),
            ),
            Text(
              text,
              style: MTextStyle.large.copyWith(color: selected ? MunchColors.white : MunchColors.black),
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }
}
