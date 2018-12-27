import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch_app/api/authentication.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/search/search_page.dart';

import 'package:munch_app/styles/colors.dart';

import 'package:munch_app/pages/feed/feed_page.dart';
import 'package:munch_app/pages/tastebud/tastebud_page.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/styles/texts.dart';

void main() => runApp(MunchApp());

ThemeData _buildTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: MunchColors.white,
    accentColor: MunchColors.secondary500,
    fontFamily: 'Roboto',

    textTheme: TextTheme(
      body1: MTextStyle.regular
          .copyWith(height: 1, color: Colors.black)
    )
  );
}

/// MunchApp: The Root Application
class MunchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Munch App',
      color: MunchColors.secondary500,
      theme: _buildTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => MunchTabPage(),
      },
    );
  }
}

final MunchTabState tabState = MunchTabState();

class MunchTabPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => tabState;
}

class MunchTabState extends State<MunchTabPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    SearchPage(),
    FeedPage(),
    TastebudPage(),
  ];

  void onTab(int index) {
    if (index == _children.length - 1) {
      Authentication.instance.requireAuthentication(context).then((state) {
        if (state == AuthenticationState.loggedIn) {
          setState(() {
            _currentIndex = index;
          });
        }
      }).catchError((error) {
        return showDialog(
          context: context,
          builder: (context) => MunchDialog.error(context,
              title: 'Authentication Error', content: error),
        );
      });
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  BottomAppBar _buildBottom() {
    const style = TextStyle(
      fontSize: 12,
      height: 1.3,
    );

    return BottomAppBar(
      elevation: 16,
      color: MunchColors.white,
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTab,
        fixedColor: MunchColors.primary500,
        items: [
          BottomNavigationBarItem(
            icon: Icon(MunchIcons.tabbar_discover),
            title: Text('Discover', style: style),
          ),
          BottomNavigationBarItem(
            icon: Icon(MunchIcons.tabbar_feed),
            title: Text('Feed', style: style),
          ),
          BottomNavigationBarItem(
            icon: Icon(MunchIcons.tabbar_profile),
            title: Text('Tastebud', style: style),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottom(),
      body: Stack(
        children: List.generate(3, (index) {
          return Offstage(
            offstage: _currentIndex != index,
            child: TickerMode(
              enabled: _currentIndex == index,
              child: _children[index],
            ),
          );
        }, growable: false),
      ),
    );
  }
}
