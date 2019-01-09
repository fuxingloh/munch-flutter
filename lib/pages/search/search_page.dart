import 'package:flutter/material.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/api/user_api.dart';
import 'package:munch_app/main.dart';
import 'package:munch_app/pages/filter/filter_page.dart';
import 'package:munch_app/pages/search/search_card_list.dart';
import 'package:munch_app/pages/search/search_header.dart';
import 'package:munch_app/pages/suggest/suggest_page.dart';
import 'package:munch_app/utils/recent_database.dart';

class SearchPage extends StatefulWidget {
  static SearchPageState state = SearchPageState();

  @override
  State<StatefulWidget> createState() => state;
}

typedef void EditSearchQuery(SearchQuery query);

class SearchPageState extends State<SearchPage> with WidgetsBindingObserver {
  List<SearchQuery> histories = [];

  RecentSearchQueryDatabase _recentSearchQueryDatabase =
      RecentSearchQueryDatabase();

  SearchQuery get searchQuery => histories.last;
  SearchCardList _cardList = SearchCardList();
  SearchAppBar _header;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _header = SearchAppBar(
        onBack: pop,
        onSuggest: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => SuggestPage(searchQuery: searchQuery)),
          ).then((searchQuery) {
            if (searchQuery != null && searchQuery is SearchQuery) {
              push(searchQuery);
            }
          });
        },
        onFilter: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (c) => FilterPage(searchQuery: searchQuery),
            ),
          ).then((searchQuery) {
            if (searchQuery != null && searchQuery is SearchQuery) {
              push(searchQuery);
            }
          });
        });

    UserSearchPreference.get().whenComplete(() {
      push(SearchQuery.feature(SearchFeature.Home));
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (DateTime.now().millisecondsSinceEpoch -
              pausedDateTime.millisecondsSinceEpoch >
          1000 * 60 * 60) {
        this.reset();
      }
    }
  }

  void push(SearchQuery searchQuery) {
    histories.add(searchQuery);
    if (!searchQuery.isSimple) {
      _recentSearchQueryDatabase.put(searchQuery);
    }

    _cardList.search(searchQuery);
    _header.searchQuery = searchQuery;
  }

  void edit(EditSearchQuery edit) {
    var last = histories.last;
    if (last == null) return;

    edit(last);
    push(last);
  }

  bool pop() {
    if (histories.length <= 1) return false;

    histories.removeLast();
    _cardList.search(histories.last);
    _header.searchQuery = searchQuery;
    return true;
  }

  void reset() {
    histories.clear();
    push(SearchQuery.feature(SearchFeature.Home));
  }

  void scrollToTop() {
    _cardList.state.scrollToTop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(appBar: _header, body: _cardList),
      onWillPop: () async {
        return !pop();
      },
    );
  }
}
