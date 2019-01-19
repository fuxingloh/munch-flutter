import 'package:flutter/material.dart';
import 'package:munch_app/api/authentication.dart';
import 'package:munch_app/api/user_api.dart';
import 'package:munch_app/pages/filter/filter_area_page.dart';
import 'package:munch_app/pages/filter/filter_between_page.dart';
import 'package:munch_app/pages/filter/filter_page.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/pages/suggest/suggest_page.dart';
import 'package:munch_app/styles/icons.dart';

class SearchCardHomeTab extends SearchCardWidget {
  SearchCardHomeTab(SearchCard card)
      : super(card, margin: SearchCardInsets.only(left: 0, right: 0));

  @override
  Widget buildCard(BuildContext context) {
    return _SearchCardHomeTabChild();
  }
}

class _SearchCardHomeTabChild extends StatefulWidget {
  @override
  _SearchCardHomeTabChildState createState() => _SearchCardHomeTabChildState();
}

String _salutation() {
  var date = DateTime.now();
  var total = (date.hour * 60) + date.minute;

  if (total >= 300 && total < 720) {
    return "Good Morning";
  } else if (total >= 720 && total < 1020) {
    return "Good Afternoon";
  } else {
    return "Good Evening";
  }
}

Future<String> _title() async {
  final profile = await UserProfile.get();
  final name = profile?.name ?? "Samantha";

  return "${_salutation()}, $name. Feeling hungry?";
}

class _SearchCardHomeTabChildState extends State<_SearchCardHomeTabChild> {
  static const List<_HomeTab> tabs = [
    _HomeTab.between,
    _HomeTab.search,
    _HomeTab.location,
  ];

  _HomeTab tab = tabs[0];

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: FutureBuilder(
          future: _title(),
          builder: (context, snapshot) {
            final style = MTextStyle.h2.copyWith(color: Colors.white);

            if (snapshot.connectionState == ConnectionState.done) {
              return Text(snapshot.data, style: style);
            } else {
              return Text(_salutation(), style: style);
            }
          },
        ),
      )
    ];

    children.add(FutureBuilder(
      future: UserProfile.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data == null) {
          return GestureDetector(
            onTap: _onLogin,
            child: Padding(
              padding: const EdgeInsets.only(top: 4, left: 24, right: 24),
              child: Text(
                "(Not Samantha? Create an account here.)",
                style: MTextStyle.h6.copyWith(color: Colors.white),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    ));

    children.add(Container(
      height: 40,
      margin: const EdgeInsets.only(top: 16),
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 24, right: 24),
        scrollDirection: Axis.horizontal,
        itemBuilder: (c, i) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => tab = tabs[i]),
            child: SearchHomeTabCell(tabs[i].title, tab == tabs[i]),
          );
        },
        separatorBuilder: (c, i) => SizedBox(width: 32),
        itemCount: tabs.length,
      ),
    ));

    children.add(Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Text(
        tab.message,
        style: MTextStyle.h5.copyWith(color: Colors.white),
      ),
    ));

    children.add(SearchHomeActionBar(
      tab: tab,
      onBar: _onBar,
      onRight: _onRight,
    ));

    return Stack(
      alignment: Alignment.topCenter,
      overflow: Overflow.visible,
      children: <Widget>[
        Positioned(
          left: 0,
          right: 0,
          top: -36,
          bottom: 0,
          child: Container(
            child: Image(
              fit: BoxFit.cover,
              color: MunchColors.black40,
              colorBlendMode: BlendMode.srcOver,
              image: AssetImage('assets/img/${tab.image}'),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ],
    );
  }

  void _onLogin() {
    Authentication.instance.requireAuthentication(context).then((state) {
      if (state != AuthenticationState.loggedIn) {
        return;
      }

      SearchPage.state.reset();
    });
  }

  void _onBar() {
    final searchQuery = SearchPage.state.searchQuery;
    Future<SearchQuery> future;

    if (tab == _HomeTab.between) {
      future = Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (c) => FilterBetweenPage(searchQuery: searchQuery),
      ));
    } else if (tab == _HomeTab.search) {
      future = Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (c) => SuggestPage(searchQuery: searchQuery),
      ));
    } else if (tab == _HomeTab.location) {
      future = Navigator.of(context)
          .push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (c) => FilterAreaPage(),
      ))
          .then((area) {
        if (area == null) return null;

        var query = SearchQuery.search();
        query.filter.location.type = SearchFilterLocationType.Where;
        query.filter.location.areas = [area];
        return query;
      });
    }

    if (future == null) return;

    // With Future of SearchQuery execute SearchQuery
    future.then((searchQuery) {
      if (searchQuery == null) return;

      SearchPage.state.push(searchQuery);
    });
  }

  void _onRight() {
    final searchQuery = SearchPage.state.searchQuery;

    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (c) => FilterPage(searchQuery: searchQuery),
      ),
    ).then((searchQuery) {
      if (searchQuery != null && searchQuery is SearchQuery) {
        SearchPage.state.push(searchQuery);
      }
    });
  }
}

class SearchHomeTabCell extends StatelessWidget {
  SearchHomeTabCell(this.text, this.selected);

  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 3,
          height: 3,
          child: Container(
            height: 3,
            color: selected ? MunchColors.white : MunchColors.clear,
          ),
        ),
      ],
    );
  }
}

class SearchHomeActionBar extends StatelessWidget {
  const SearchHomeActionBar({
    Key key,
    this.tab,
    this.onBar,
    this.onRight,
  }) : super(key: key);

  final _HomeTab tab;
  final VoidCallback onBar;
  final VoidCallback onRight;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 12, right: 10),
        child: Icon(tab.leftIcon, size: 20),
      ),
      Expanded(
        child: Text(
          tab.hint,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: MunchColors.black75,
          ),
        ),
      ),
    ];

    if (tab.rightIcon != null) {
      children.add(Container(
        width: 1,
        color: MunchColors.black20,
      ));

      children.add(GestureDetector(
        onTap: onRight,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
          child: Icon(tab.rightIcon, size: 24),
        ),
      ));
    }

    return GestureDetector(
      onTap: onBar,
      child: Container(
        height: 40,
        margin: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        child: Row(children: children),
      ),
    );
  }
}

class _HomeTab {
  static const between = _HomeTab(
    title: 'EatBetween',
    image: 'search_card_home_tab_between.jpg',
    leftIcon: MunchIcons.filter_between,
    hint: 'Enter Locations',
    message:
        'Enter everyone’s location and we’ll find the most ideal spot for a meal together.',
  );

  static const search = _HomeTab(
    title: 'Search',
    image: 'search_card_home_tab_search.jpg',
    leftIcon: MunchIcons.search_header_search,
    rightIcon: MunchIcons.search_header_filter,
    hint: 'Search e.g. Italian in Orchard',
    message:
        'Search anything on Munch and we’ll give you the best recommendations.',
  );
  static const location = _HomeTab(
    title: 'Neighbourhoods',
    image: 'search_card_home_tab_location.jpg',
    leftIcon: MunchIcons.search_header_search,
    hint: 'Search Location',
    message: 'Enter a location and we’ll tell you what’s delicious around.',
  );

  const _HomeTab({
    this.title,
    this.image,
    this.leftIcon,
    this.rightIcon,
    this.hint,
    this.message,
  });

  final String title;
  final String image;
  final IconData leftIcon;
  final IconData rightIcon;
  final String hint;
  final String message;
}
