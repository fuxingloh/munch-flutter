import 'package:flutter/material.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/api/user_api.dart';
import 'package:munch_app/main.dart';
import 'package:munch_app/pages/search/search_card_list.dart';
import 'package:munch_app/pages/search/search_header.dart';
import 'package:munch_app/utils/munch_analytic.dart';
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

  SearchQuery get searchQuery {
    if (histories.isEmpty) return SearchQuery.feature(SearchFeature.Home);
    return histories.last;
  }

  SearchCardList _cardList = SearchCardList();

  bool hasHeader = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

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

    _search(searchQuery);
  }

  void edit(EditSearchQuery _edit) {
    var last = histories.last;
    if (last == null) return;

    _edit(last);
    push(last);
  }

  bool pop() {
    if (histories.length <= 1) return false;

    histories.removeLast();
    _search(searchQuery);
    return true;
  }

  void _search(SearchQuery searchQuery) {
    if (searchQuery.feature == SearchFeature.Home) {
      setState(() => hasHeader = false);
    } else {
      setState(() => hasHeader = true);
    }

    _cardList.search(histories.last);
    MunchAnalytic.logSearchQuery(searchQuery: searchQuery);
  }

  void reset() {
    histories.clear();
    push(SearchQuery.feature(SearchFeature.Home));
  }

  /// Whether it is already on top
  bool scrollToTop() {
    return _cardList.state.scrollToTop();
  }

  /// Scroll to a uniqueId
  void scrollTo(String uniqueId) {
    _cardList.state.scrollTo(uniqueId);
  }

  String get qid => _cardList.state.manager?.qid;

  @override
  Widget build(BuildContext context) {
    final header = hasHeader ? SearchAppBar(searchQuery) : null;
    final body = SafeArea(child: _cardList);

    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: header,
        body: body,
      ),
      onWillPop: () async {
        return !pop();
      },
    );
  }
}
