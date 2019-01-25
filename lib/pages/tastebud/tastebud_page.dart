import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch_app/pages/tastebud/tastebud_places_page.dart';
import 'package:munch_app/pages/tastebud/tastebud_preferences_page.dart';
import 'package:munch_app/pages/tastebud/tastebud_setting_page.dart';
import 'package:munch_app/styles/icons.dart';

class TastebudPage extends StatelessWidget {
  TastebudPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _TastebudAppBar(context),
        body: TabBarView(
          children: [
            TastebudPlacePage(),
            TastebudPreferencePage(),
          ],
        ),
      ),
    );
  }
}

class _TastebudAppBar extends AppBar {
  static TabBar _buildTabBar(BuildContext context) {
    return TabBar(
      tabs: [
        const Tab(icon: Icon(MunchIcons.tastebud_places)),
        const Tab(icon: Icon(MunchIcons.tastebud_preferences)),
      ],
    );
  }

  static List<Widget> _buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => TastebudSettingPage.push(context),
        icon: const Icon(MunchIcons.navigation_setting),
      ),
    ];
  }

  _TastebudAppBar(BuildContext context)
      : super(
          title: const Text(
            'Your Profile',
          ),
          bottom: _buildTabBar(context),
          actions: _buildActions(context),
          elevation: 2,
        );
}
