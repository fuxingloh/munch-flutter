import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch_app/main.dart';
import 'package:munch_app/pages/profile/tastebud_places_page.dart';
import 'package:munch_app/pages/profile/tastebud_preferences_page.dart';
import 'package:munch_app/pages/profile/tastebud_setting_page.dart';
import 'package:munch_app/styles/icons.dart';

class ProfilePage extends StatelessWidget with TabWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _ProfileAppBar(context),
        body: TabBarView(
          children: [
            TastebudPlacePage(),
            TastebudPreferencePage(),
          ],
        ),
      ),
    );
  }

  @override
  void didTabAppear(TabParent parent) {}
}

class _ProfileAppBar extends AppBar {
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

  _ProfileAppBar(BuildContext context)
      : super(
          title: const Text(
            'Your Profile',
          ),
          bottom: _buildTabBar(context),
          actions: _buildActions(context),
          elevation: 2,
        );
}
