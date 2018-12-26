import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:munch_app/api/authentication.dart';
import 'package:munch_app/main.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/separators.dart';

import 'package:url_launcher/url_launcher.dart';

class TastebudSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
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
      _text("Instagram Partner", () => _launch('https://partner.munch.app')),
      Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: const SeparatorLine(),
      ),
      _text("Send Feedback", () => _launch('mailto:feedback@munch.app')),
      Container(height: 32),
      _text("Logout", () {
        Authentication.instance.logout().then((v) {
          Navigator.of(context).pop();
          tabState.onTab(0);
        });
      }),
      Container(height: 32),
    ];
  }

  Widget _text(String text, VoidCallback onTap) {
    const padding = EdgeInsets.fromLTRB(24, 16, 24, 16);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        color: Colors.white,
        child: Text(text, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  void _launch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
