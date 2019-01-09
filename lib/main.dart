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

final MunchTabState tabState = MunchTabState();
DateTime pausedDateTime = DateTime.now();

class MunchTabPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => tabState;
}

class MunchTabState extends State<MunchTabPage> with WidgetsBindingObserver {
  int _currentIndex = 0;

  final List<Widget> _children = [
    SearchPage(),
    FeedPage(),
    TastebudPage(),
  ];

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
              child: _children[index],
            ),
          );
        }, growable: false),
      ),
    );
  }

  void onTab(int index) {
    if (_currentIndex == index) {
      if (index == 0) {
        SearchPage.state.scrollToTop();
      }
      return;
    }

    if (index == _children.length - 1) {
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
  static const TextStyle style = TextStyle(
    fontSize: 12,
    height: 1.3,
  );

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
          const BottomNavigationBarItem(
            icon: Icon(MunchIcons.tabbar_discover),
            title: Text('Discover', style: style),
          ),
          const BottomNavigationBarItem(
            icon: Icon(MunchIcons.tabbar_feed),
            title: Text('Feed', style: style),
          ),
          const BottomNavigationBarItem(
            icon: Icon(MunchIcons.tabbar_profile),
            title: Text('Tastebud', style: style),
          ),
        ],
      ),
    );
  }
}
