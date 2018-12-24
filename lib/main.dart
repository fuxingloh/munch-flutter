import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch_app/api/authentication.dart';

import 'package:munch_app/styles/colors.dart';

import 'package:munch_app/pages/discover/discover_page.dart';
import 'package:munch_app/pages/feed/feed_page.dart';
import 'package:munch_app/pages/tastebud/tastebud_page.dart';
import 'package:munch_app/styles/icons.dart';

void main() => runApp(MunchApp());

/// MunchApp: The Root Application
class MunchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Munch App',
      color: MColors.secondary500,
      initialRoute: '/',
      routes: {
        '/': (context) => MunchTabPage(),
      },
    );
  }
}

class MunchTabPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MunchTabState();
}

class _MunchTabState extends State<MunchTabPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    DiscoverPage(),
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
      color: MColors.white,
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTab,
        fixedColor: MColors.primary600,
        items: [
          BottomNavigationBarItem(
            icon: Icon(MIcons.tabbar_discover),
            title: Text('Discover', style: style),
          ),
          BottomNavigationBarItem(
            icon: Icon(MIcons.tabbar_feed),
            title: Text('Feed', style: style),
          ),
          BottomNavigationBarItem(
            icon: Icon(MIcons.tabbar_profile),
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
