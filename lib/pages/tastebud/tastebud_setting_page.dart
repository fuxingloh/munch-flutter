import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch_app/api/authentication.dart';
import 'package:munch_app/main.dart';
import 'package:munch_app/pages/search/cards/home/search_card_home_dtje.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/separators.dart';
import 'package:munch_app/styles/texts.dart';

import 'package:url_launcher/url_launcher.dart';

class TastebudSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: MTextStyle.navHeader,
        ),
        elevation: 2,
      ),
      body: Container(
        color: MunchColors.voided,
        child: ListView(children: _list(context)),
      ),
    );
  }

  List<Widget> _list(BuildContext context) {
    return [
      Container(height: 32),
      _SettingTile(
        "Instagram Partner",
        onPressed: () => _launch('https://partner.munch.app'),
      ),
      Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: const SeparatorLine(),
      ),
      _SettingTile(
        "Send Feedback",
        onPressed: () => _launch('mailto:feedback@munch.app'),
      ),
      Container(height: 32),
      _SettingTile("Notification: Don't Think, Just Eat", onPressed: () {
        showModalBottomSheet(context: context, builder: (_) {
          return DTJEInfoPage();
        });
      }),
      Container(height: 32),
      _SettingTile("Logout", onPressed: () {
        Authentication.instance.logout().then((v) {
          Navigator.of(context).pop();
          tabState.onTab(0);
        });
      }),
      Container(height: 32),
    ];
  }

  void _launch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}

class _SettingTile extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  _SettingTile(this.text, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 18, 24, 18),
        color: Colors.white,
        child: Text(text, style: MTextStyle.regular),
      ),
    );
  }
}
