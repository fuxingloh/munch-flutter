import 'package:flutter/material.dart';
import 'package:munch_app/api/search_api.dart';
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

// TODO: Detect Background to Foreground transition, 60 min
typedef void EditSearchQuery(SearchQuery query);

class SearchPageState extends State<SearchPage> {
  List<SearchQuery> histories = [];

  RecentSearchQueryDatabase _recentSearchQueryDatabase = RecentSearchQueryDatabase();

  SearchQuery get searchQuery => histories.last;
  SearchCardList _cardList = SearchCardList();
  SearchHeaderBar _header;

  @override
  void initState() {
    super.initState();
    _header = SearchHeaderBar(
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
                builder: (c) => FilterPage(searchQuery: searchQuery)),
          ).then((searchQuery) {
            if (searchQuery != null && searchQuery is SearchQuery) {
              push(searchQuery);
            }
          });
        });
    push(SearchQuery.feature(SearchFeature.Home));
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
