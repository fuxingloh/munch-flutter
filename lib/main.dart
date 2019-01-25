import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:munch_app/api/authentication.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/search/search_page.dart';
import 'package:munch_app/pages/feed/feed_page.dart';
import 'package:munch_app/pages/tastebud/tastebud_page.dart';
import 'package:munch_app/styles/munch.dart';
import 'package:munch_app/utils/munch_analytic.dart';

void main() => runApp(MunchApp());

final MunchTabState tabState = MunchTabState();
DateTime pausedDateTime = DateTime.now();

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

final ThemeData theme = ThemeData(
  brightness: Brightness.light,
  primaryColor: MunchColors.white,
  accentColor: MunchColors.secondary500,
  fontFamily: 'Roboto',
  textTheme: TextTheme(
    body1: MTextStyle.regular.copyWith(height: 1, color: Colors.black),
  ),
);

class MunchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Munch App',
      color: MunchColors.secondary500,
      theme: theme,
      home: MunchTabPage(),
      navigatorObservers: [
        MunchAnalyticNavigatorObserver(),
        routeObserver,
      ],
    );
  }
}

class MunchTabPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => tabState;
}

class MunchTabState extends State<MunchTabPage>
    with WidgetsBindingObserver, RouteAware {
  static const search = 0;
  static const feed = 1;
  static const profile = 2;

  int _currentIndex = search;

  Map<int, Widget> _children = {search: SearchPage()};

  Widget getChild(int index) {
    if (_children.containsKey(index)) return _children[index];
    if (_currentIndex == index) {
      if (index == search) _children[search] = SearchPage();
      if (index == feed) _children[feed] = FeedPage();
      if (index == profile) _children[profile] = TastebudPage();

      return _children[index];
    }
    return Container();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    MunchAnalytic.setScreen(routeName);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      pausedDateTime = DateTime.now();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  String get routeName {
    switch (_currentIndex) {
      case search:
        return "/search";
      case feed:
        return "/feed";
      case profile:
        return "/profile";
      default:
        return null;
    }
  }

  /// Route was pushed onto navigator and is now topmost route.
  @override
  void didPush() {
    MunchAnalytic.setScreen(routeName);
  }

  /// Covering route was popped off the navigator.
  @override
  void didPopNext() {
    MunchAnalytic.setScreen(routeName);
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
      switch (index) {
        case search:
          bool top = SearchPage.state.scrollToTop();
          if (top) SearchPage.state.reset();
          break;
      }
    } else {
      switch (index) {
        case profile:
          Authentication.instance.requireAuthentication(context).then((state) {
            if (state == AuthenticationState.loggedIn) {
              updateTab(index);
            }
          }).catchError((error) {
            MunchDialog.showError(context, error);
          });
          break;

        default:
          updateTab(index);
      }
    }
  }

  void updateTab(int index) {
    setState(() {
      _currentIndex = index;
      MunchAnalytic.setScreen(routeName);
    });
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
            text: 'Profile',
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
