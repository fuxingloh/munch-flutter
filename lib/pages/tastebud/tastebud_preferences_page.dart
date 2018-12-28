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
  State<StatefulWidget> createState() {
    return TastebudPreferenceState();
  }
}

class TastebudPreferenceState extends State<TastebudPreferencePage> {
  UserSearchPreference _searchPreference;
  MunchApi _api = MunchApi.instance;

  void onChange(Tag tag, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var string = prefs.getString("UserSearchPreference");
    var searchPreference = UserSearchPreference.fromJson(jsonDecode(string));

    searchPreference.requirements.removeWhere((t) => t.tagId == tag.tagId);
    if (value) {
      searchPreference.requirements.add(tag);
    }

    var body = searchPreference.toJson();
    prefs.setString("UserSearchPreference", jsonEncode(body));

    _api.put('/users/search/preference', body: body).catchError((error) {
      MunchDialog.showError(context, error);
    });

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
              style: MTextStyle.h5,
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

    return GestureDetector(
      onTap: () => onChange(tag, !checked),
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
        color: MunchColors.clear,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(tag.name, style: MTextStyle.h4.copyWith(height: 1)),
            Checkbox(value: checked, onChanged: (v) => onChange(tag, v))
          ],
        ),
      ),
    );
  }
}
