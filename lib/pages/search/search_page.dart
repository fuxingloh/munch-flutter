import 'package:flutter/material.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/pages/search/search_card_list.dart';
import 'package:munch_app/pages/search/search_header.dart';

class SearchPage extends StatefulWidget {
  static SearchPageState state = SearchPageState();

  @override
  State<StatefulWidget> createState() => state;
}

// TODO: Detect Background to Foreground transition, 60 min

typedef void EditSearchQuery(SearchQuery query);

class SearchPageState extends State<SearchPage> {
  List<SearchQuery> histories = [];

  SearchQuery get searchQuery => histories.last;
  SearchCardList _cardList = SearchCardList();

  @override
  void initState() {
    super.initState();
    push(SearchQuery.feature(SearchFeature.Home));
  }

  void push(SearchQuery searchQuery) {
    histories.add(searchQuery);
    if (!searchQuery.isSimple) {
      // TODO: Recent Database
    }

    _cardList.state.search(searchQuery);
    // TODO HeaderView rendering
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
    _cardList.state.search(histories.last);
    // TODO HeaderView rendering
    return true;
  }

  void reset() {
    histories.clear();
    push(SearchQuery.feature(SearchFeature.Home));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: SearchHeaderBar(),
      body: _cardList,
    ), onWillPop: ()  async {
      return !pop();
    });
  }
}
