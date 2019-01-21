import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:munch_app/api/authentication.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/search/search_page.dart';
import 'package:munch_app/pages/feed/feed_page.dart';
import 'package:munch_app/pages/tastebud/tastebud_page.dart';
import 'package:munch_app/styles/munch.dart';

void main() => runApp(MunchApp());

final MunchTabState tabState = MunchTabState();
DateTime pausedDateTime = DateTime.now();

final ThemeData theme = ThemeData(
  brightness: Brightness.light,
  primaryColor: MunchColors.white,
  accentColor: MunchColors.secondary500,
  fontFamily: 'Roboto',
  textTheme: TextTheme(
    body1: MTextStyle.regular.copyWith(height: 1, color: Colors.black),
  ),
);

final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();

class MunchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Munch App',
      color: MunchColors.secondary500,
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (c) => MunchTabPage(),
      },
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: firebaseAnalytics),
      ],
    );
  }
}

class MunchTabPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => tabState;
}

class MunchTabState extends State<MunchTabPage> with WidgetsBindingObserver {
  int _currentIndex = 0;

  Map<int, Widget> _children = {0: SearchPage()};

  Widget getChild(int index) {
    if (_children.containsKey(index)) return _children[index];
    if (_currentIndex == index) {
      if (index == 0) _children[0] = SearchPage();
      if (index == 1) _children[1] = FeedPage();
      if (index == 2) _children[2] = TastebudPage();

      return _children[index];
    }
    return Container();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      pausedDateTime = DateTime.now();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: MunchBottomBar(
        onTab: onTab,
        currentIndex: _currentIndex,
      ),
      body: Stack(
        children: List.generate(3, (index) {
          return Offstage(
            offstage: _currentIndex != index,
            child: TickerMode(
              enabled: _currentIndex == index,
              child: getChild(index),
            ),
          );
        }, growable: false),
      ),
    );
  }

  void onTab(int index) {
    if (_currentIndex == index) {
      if (index == 0) {
        bool top = SearchPage.state.scrollToTop();
        if (top) {
          SearchPage.state.reset();
        }
      }
      return;
    }

    if (index == 2) {
      Authentication.instance.requireAuthentication(context).then((state) {
        if (state == AuthenticationState.loggedIn) {
          setState(() {
            _currentIndex = index;
          });
        }
      }).catchError((error) {
        MunchDialog.showError(context, error);
      });
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }
}

class MunchBottomBar extends StatelessWidget {
  final ValueChanged<int> onTab;
  final int currentIndex;

  const MunchBottomBar({
    Key key,
    @required this.onTab,
    @required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 16,
      color: MunchColors.white,
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTab,
        fixedColor: MunchColors.primary500,
        items: [
          MunchBottomBarItem(
            icon: MunchIcons.tabbar_discover,
            text: 'Discover',
          ),
          MunchBottomBarItem(
            icon: MunchIcons.tabbar_feed,
            text: 'Feed',
          ),
          MunchBottomBarItem(
            icon: MunchIcons.tabbar_profile,
            text: 'Tastebud',
          ),
        ],
      ),
    );
  }
}

class MunchBottomBarItem extends BottomNavigationBarItem {
  static const TextStyle style = TextStyle(
    fontSize: 12,
    height: 1.3,
  );

  MunchBottomBarItem({IconData icon, String text})
      : super(
          icon: Icon(icon),
          title: Text(text, style: style),
        );
}
