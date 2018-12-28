import 'package:flutter/material.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/pages/search/search_card_list.dart';
import 'package:munch_app/pages/search/search_header.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchPageState();
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
//    push(SearchQuery.feature(SearchFeature.Home));
    push(SearchQuery.search(null));
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

  void pop() {
    if (histories.length <= 1) return;

    var searchQuery = histories.last;
    _cardList.state.search(searchQuery);
    // TODO HeaderView rendering
  }

  void reset() {
    histories.clear();
    push(SearchQuery.feature(SearchFeature.Home));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchHeaderBar(),
      body: _cardList,
    );
  }
}
