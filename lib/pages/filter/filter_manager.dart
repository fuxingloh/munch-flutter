import 'dart:async';

import 'package:meta/meta.dart';
import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/api/user_api.dart';

export 'package:munch_app/api/munch_data.dart';
export 'package:munch_app/api/search_api.dart';

abstract class FilterItem {}

class FilterItemLocation extends FilterItem {}

class FilterItemPrice extends FilterItem {}

class FilterItemTiming extends FilterItem {}

class FilterItemTagHeader extends FilterItem {
  FilterItemTagHeader(this.type);

  final TagType type;
}

class FilterItemTag extends FilterItem {
  FilterItemTag(this.tag);

  final FilterTag tag;
}

class FilterItemTagMore extends FilterItem {
  FilterItemTagMore(this.count, this.type);

  final int count;
  final TagType type;
}

class FilterManager {
  static const _api = MunchApi.instance;

  SearchQuery _searchQuery;
  FilterResult _result;
  bool _loading = true;

  bool get loading => _loading;

  StreamController<List<FilterItem>> _controller;

  FilterManager(this._searchQuery) {
    _searchQuery.feature = SearchFeature.Search;
  }

  Stream<List<FilterItem>> stream() {
    _controller = StreamController<List<FilterItem>>();
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }

  //    func dispatch(delay: RxTimeInterval = 0.2) {
  void dispatch() {
    _result = null;
    _loading = true;

    _controller.add(<FilterItem>[]);

    _api.post('/search/filter', body: _searchQuery.toJson()).then((res) {
      Map<String, dynamic> data = res.data;
      return FilterResult.fromJson(data);
    }).then((result) {
      this._result = result;
      this._loading = false;
      this._controller.add(collect());
    }, onError: (error) {
      _controller.addError(error);
    });
  }

  List<FilterItem> collect() {
    List<FilterItem> items = [];

    items.add(FilterItemLocation());
    items.add(FilterItemPrice());
    items.add(FilterItemTiming());

    items.addAll(collectTag(TagType.Cuisine));
    items.addAll(collectTag(TagType.Requirement));
    items.addAll(collectTag(TagType.Amenities));
    items.addAll(collectTag(TagType.Establishment));

    return items;
  }

  List<FilterItem> collectTag(TagType type) {
    List<FilterTag> tags = _result?.tagGraph?.tags;

    List<FilterItem> items = [];
    items.add(FilterItemTagHeader(type));

    int empty = 0;
    tags.where((t) => t.type == type).forEach((tag) {
      if (tag.count > 0) {
        items.add(FilterItemTag(tag));
      } else {
        empty += 1;
      }
    });

    if (empty > 0) {
      items.add(FilterItemTagMore(empty, type));
    }

    return items;
  }

  Future reset() async {
    var preference = await UserSearchPreference.get();
    this._searchQuery = SearchQuery.search(preference);
    dispose();
  }

  void selectSearchQuery(SearchQuery searchQuery) {
    this._searchQuery = searchQuery;
    dispose();
  }

  void selectTag(Tag tag) {
    if (isSelectedTag(tag)) {
      _searchQuery.filter.tags.removeWhere((t) => t.tagId == tag.tagId);
    } else {
      _searchQuery.filter.tags.add(tag);
    }

    dispatch();
  }

  void selectPrice(SearchFilterPrice price) {
    _searchQuery.filter.price = price;
    dispatch();
  }

  void selectHour(SearchFilterHour hour) {
    _searchQuery.filter.hour = hour;
    dispatch();
  }

  void selectLocationType(SearchFilterLocationType type) {
    _searchQuery.filter.location.type = type;
    _searchQuery.filter.location.areas = [];
    _searchQuery.filter.location.points = [];
    dispatch();
  }

  void selectLocation(SearchFilterLocation location) {
    _searchQuery.filter.location = location;
    dispatch();
  }

  void selectArea(Area area) {
    _searchQuery.filter.location.type = SearchFilterLocationType.Where;
    _searchQuery.filter.location.areas = [area];
    _searchQuery.filter.location.points = [];
    dispatch();
  }

  bool isSelectedTag(Tag tag) {
    return _searchQuery.filter.tags.any((t) => t.tagId == tag.tagId);
  }

  bool isSelectedHour(SearchFilterHourType type) {
    return _searchQuery.filter.hour?.type == type;
  }

  bool isSelectedPrice(SearchFilterPrice price) {
    return _searchQuery.filter.price?.name == price?.name;
  }

  static String countTitle({
    @required int count,
    String empty = "No Results",
    String prefix = "See",
    String postfix = "Restaurants",
  }) {
    if (count == 0) {
      return empty;
    } else if (count >= 100) {
      return "$prefix 100+ $postfix";
    } else if (count <= 10) {
      return "$prefix $count $postfix";
    } else {
      int rounded = ((count / 10) * 10).round();
      return "$prefix $rounded+ $postfix";
    }
  }
}