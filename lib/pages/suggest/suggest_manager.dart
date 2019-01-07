import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/api/user_api.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/utils/recent_database.dart';
import 'package:rxdart/rxdart.dart';

abstract class SuggestItem {}

class SuggestItemNoResult extends SuggestItem {}

class SuggestItemText extends SuggestItem {
  SuggestItemText(this.text);

  final String text;
}

class SuggestItemAssumption extends SuggestItem {
  SuggestItemAssumption(this.assumptionQueryResult);

  final AssumptionQueryResult assumptionQueryResult;
}

class SuggestItemPlace extends SuggestItem {
  SuggestItemPlace(this.place);

  final Place place;
}

class SuggestItemQuery extends SuggestItem {
  SuggestItemQuery(this.iconData, this.searchQuery);

  final IconData iconData;
  final SearchQuery searchQuery;
}

class SuggestManager {
  static const MunchApi _api = MunchApi.instance;

  SearchQuery _searchQuery;
  bool loading = true;

  RecentSearchQueryDatabase _recent = RecentSearchQueryDatabase();

  StreamController<List<SuggestItem>> _controller;

  PublishSubject<String> _onTextChanged;

  SuggestManager(SearchQuery searchQuery) {
    this._searchQuery = searchQuery;
    _onTextChanged = PublishSubject<String>();

    _onTextChanged
        .distinct()
        .debounce(const Duration(milliseconds: 300))
        .switchMap((text) async* {
      if (text.length < 3) {
        yield await this.history;
      } else {
        yield <SuggestItem>[];
        yield await _search(text);
      }
    }).listen((list) => _controller.add(list));
  }

  Stream<List<SuggestItem>> stream(SearchQuery query) {
    _controller = StreamController<List<SuggestItem>>();
    history.then((list) => _controller.add(list));
    return _controller.stream;
  }

  void dispose() {
    _onTextChanged.close();
    _controller.close();
  }

  void onChanged(String text) {
    _onTextChanged.add(text);
  }

  Future<List<SuggestItem>> get history async {
    List<SuggestItem> list = [];

    var nearby = SearchQuery.search();
    nearby.filter.location.type = SearchFilterLocationType.Nearby;
    list.add(SuggestItemQuery(MunchIcons.suggest_nearby, nearby));

    var anywhere = SearchQuery.search();
    anywhere.filter.location.type = SearchFilterLocationType.Anywhere;
    list.add(SuggestItemQuery(MunchIcons.suggest_anywhere, anywhere));

    var recent = await _recent.get();
    recent.take(4).forEach((query) {
      list.add(SuggestItemQuery(MunchIcons.suggest_recent, query));
    });
    return list;
  }

  Future<List<SuggestItem>> _search(String text) async {
    var result = await _api.post('/suggest', body: {
      'text': text.toLowerCase(),
      'searchQuery': _searchQuery.toJson()
    }).then((res) {
      Map<String, dynamic> data = res.data;
      return SuggestResult.fromJson(data);
    });

    List<SuggestItem> items = [];

    if (result.assumptions.isNotEmpty) {
      items.add(SuggestItemAssumption(result.assumptions[0]));
    }

    result.places.take(10).forEach((place) {
      items.add(SuggestItemPlace(place));
    });

    if (items.isEmpty && result.suggests.isNotEmpty) {
      items.add(SuggestItemText(result.suggests[0]));
    }

    if (items.isEmpty) {
      items.add(SuggestItemNoResult());
    }

    return items;
  }
}
