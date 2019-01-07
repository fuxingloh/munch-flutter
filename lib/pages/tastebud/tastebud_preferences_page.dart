import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/user_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/texts.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TastebudPreferencePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TastebudPreferenceState();
}

class TastebudPreferenceState extends State<TastebudPreferencePage> {
  UserSearchPreference _searchPreference;
  MunchApi _api = MunchApi.instance;

  void onChange(Tag tag, bool value) async {
    var searchPreference = await UserSearchPreference.get();

    searchPreference.requirements.removeWhere((t) => t.tagId == tag.tagId);
    if (value) {
      searchPreference.requirements.add(tag);
    }

    UserSearchPreference.put(searchPreference);

    _api.put('/users/search/preference', body: searchPreference).catchError(
      (error) {
        MunchDialog.showError(context, error);
      },
    );

    setState(() {
      _searchPreference = searchPreference;
    });

    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text('Search Preference Updated')),
    );
  }

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      String string = prefs.getString("UserSearchPreference");

      setState(() {
        _searchPreference = UserSearchPreference.fromJson(jsonDecode(string));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      _buildHeader(),
      Container(
        margin: EdgeInsets.fromLTRB(24, 12, 24, 12),
        child: const Text("Requirements", style: MTextStyle.h2),
      )
    ];

    possibleTagRequirements.forEach((tag) {
      children.add(_buildChecker(tag));
    });
    return ListView(children: children);
  }

  Container _buildHeader() {
    return Container(
      margin: EdgeInsets.fromLTRB(24, 24, 24, 12),
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: MunchColors.whisper100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tastebud Preference",
            style: MTextStyle.h2,
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: const Text(
              "Customise your Tastebud on Munch for a better experience.",
              style: MTextStyle.regular,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChecker(Tag tag) {
    if (_searchPreference == null) return Container();

    bool checked =
        _searchPreference.requirements.any((t) => t.tagId == tag.tagId);

    return SearchPreferenceTag(
      checked: checked,
      name: tag.name,
      onPressed: () => onChange(tag, !checked),
    );
  }
}

class SearchPreferenceTag extends StatelessWidget {
  final String name;
  final bool checked;

  final VoidCallback onPressed;

  const SearchPreferenceTag({Key key, this.name, this.checked, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[Text(name, style: MTextStyle.regular), _right()],
          ),
        ));
  }

  Container _right() {
    return Container(
      margin: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        shape: BoxShape.rectangle,
        color: checked ? MunchColors.primary500 : MunchColors.clear,
        border: Border.all(
            color: checked ? MunchColors.primary500 : MunchColors.black75,
            width: 2),
      ),
      child: Container(
        width: 20,
        height: 20,
        child:
            checked ? Icon(Icons.check, size: 20.0, color: Colors.white) : null,
      ),
    );
  }
}
