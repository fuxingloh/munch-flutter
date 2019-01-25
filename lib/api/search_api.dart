import 'package:json_annotation/json_annotation.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/api/user_api.dart';

part 'search_api.g.dart';

@JsonSerializable()
class FilterTag extends Tag {
  FilterTag(String tagId, String name, TagType type, this.count) : super(tagId, name, type);

  int count;

  factory FilterTag.fromJson(Map<String, dynamic> json) => _$FilterTagFromJson(json);

  Map<String, dynamic> toJson() => _$FilterTagToJson(this);

  static List<FilterTag> fromJsonList(List<dynamic> list) {
    return list.map((map) => FilterTag.fromJson(map)).toList(growable: false);
  }
}

@JsonSerializable()
class FilterResult {
  FilterResult(this.count, this.tagGraph, this.priceGraph);

  int count;
  FilterTagGraph tagGraph;
  FilterPriceGraph priceGraph;

  factory FilterResult.fromJson(Map<String, dynamic> json) => _$FilterResultFromJson(json);

  Map<String, dynamic> toJson() => _$FilterResultToJson(this);
}

@JsonSerializable()
class FilterTagGraph {
  FilterTagGraph(this.tags);

  List<FilterTag> tags;

  factory FilterTagGraph.fromJson(Map<String, dynamic> json) => _$FilterTagGraphFromJson(json);

  Map<String, dynamic> toJson() => _$FilterTagGraphToJson(this);
}

@JsonSerializable()
class FilterPriceGraph {
  FilterPriceGraph(this.min, this.max, this.points, this.ranges);

  double min;
  double max;

  List<FilterPriceGraphPoint> points;
  Map<String, FilterPriceGraphRange> ranges;

  factory FilterPriceGraph.fromJson(Map<String, dynamic> json) => _$FilterPriceGraphFromJson(json);

  Map<String, dynamic> toJson() => _$FilterPriceGraphToJson(this);
}

@JsonSerializable()
class FilterPriceGraphPoint {
  FilterPriceGraphPoint(this.price, this.count);

  double price;
  double count;

  factory FilterPriceGraphPoint.fromJson(Map<String, dynamic> json) => _$FilterPriceGraphPointFromJson(json);

  Map<String, dynamic> toJson() => _$FilterPriceGraphPointToJson(this);
}

@JsonSerializable()
class FilterPriceGraphRange {
  FilterPriceGraphRange(this.min, this.max);

  double min;
  double max;

  factory FilterPriceGraphRange.fromJson(Map<String, dynamic> json) => _$FilterPriceGraphRangeFromJson(json);

  Map<String, dynamic> toJson() => _$FilterPriceGraphRangeToJson(this);
}

@JsonSerializable()
class SuggestResult {
  SuggestResult(this.suggests, this.places, this.assumptions);

  List<String> suggests;
  List<Place> places;
  List<AssumptionQueryResult> assumptions;

  factory SuggestResult.fromJson(Map<String, dynamic> json) => _$SuggestResultFromJson(json);

  Map<String, dynamic> toJson() => _$SuggestResultToJson(this);
}

@JsonSerializable()
class AssumptionQueryResult {
  AssumptionQueryResult(this.searchQuery, this.tokens, this.place, this.count);

  SearchQuery searchQuery;
  List<AssumptionToken> tokens;
  List<Place> place;
  int count;

  factory AssumptionQueryResult.fromJson(Map<String, dynamic> json) => _$AssumptionQueryResultFromJson(json);

  Map<String, dynamic> toJson() => _$AssumptionQueryResultToJson(this);
}

@JsonSerializable()
class AssumptionToken {
  AssumptionToken(this.text, this.type);

  String text;
  AssumptionType type;

  factory AssumptionToken.fromJson(Map<String, dynamic> json) => _$AssumptionTokenFromJson(json);

  Map<String, dynamic> toJson() => _$AssumptionTokenToJson(this);
}

enum AssumptionType { tag, text, others }

@JsonSerializable()
class SearchQuery {
  static const String version = "2018-11-28";

  SearchQuery(this.feature, this.collection, this.filter, this.sort);

  SearchFeature feature;
  SearchCollection collection;

  SearchFilter filter;
  SearchSort sort;

  SearchQuery.collection(SearchCollection collection)
      : this(SearchFeature.Collection, collection, SearchFilter.preference(UserSearchPreference.instance),
            SearchSort(null));

  SearchQuery.feature(SearchFeature feature)
      : this(feature, null, SearchFilter.preference(UserSearchPreference.instance), SearchSort(null));

  SearchQuery.search()
      : this(SearchFeature.Search, null, SearchFilter.preference(UserSearchPreference.instance), SearchSort(null));

  bool get isSimple {
    if (sort != null) {
      if (sort.type != null) {
        return false;
      }
    }

    if (filter != null) {
      if (filter.tags != null && filter.tags.isNotEmpty) {
        return false;
      }

      if (filter.hour != null) {
        return false;
      }

      if (filter.price != null) {
        return false;
      }

      if (filter.location?.type != null) {
        switch (filter.location.type) {
          case SearchFilterLocationType.Where:
            return false;

          case SearchFilterLocationType.Between:
            return false;

          default:
            return true;
        }
      }
    }

    return true;
  }

  factory SearchQuery.fromJson(Map<String, dynamic> json) => _$SearchQueryFromJson(json);

  Map<String, dynamic> toJson() => _$SearchQueryToJson(this);

  static String getFeatureName(SearchQuery searchQuery) {
    return _$SearchFeatureEnumMap[searchQuery.feature];
  }

  static String getLocationTypeName(SearchQuery searchQuery) {
    return _$SearchFilterLocationTypeEnumMap[searchQuery.filter.location.type];
  }

  static String getHourTypeName(SearchQuery searchQuery) {
    var type = searchQuery.filter.hour?.type;
    if (type == null) return null;

    return _$SearchFilterHourTypeEnumMap[type];
  }
}

enum SearchFeature { Home, Search, Location, Collection, Occasion }

@JsonSerializable()
class SearchCollection {
  SearchCollection(this.name, this.collectionId);

  String name;
  String collectionId;

  factory SearchCollection.fromJson(Map<String, dynamic> json) => _$SearchCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$SearchCollectionToJson(this);
}

@JsonSerializable()
class SearchFilter {
  SearchFilterPrice price;
  SearchFilterHour hour;

  List<Tag> tags = [];
  SearchFilterLocation location = SearchFilterLocation.type();

  SearchFilter(this.price, this.hour, this.tags, this.location);

  SearchFilter.preference(UserSearchPreference preference) {
    if (preference == null) return;

    preference.requirements.forEach((tag) {
      tags.add(tag);
    });
  }

  factory SearchFilter.fromJson(Map<String, dynamic> json) => _$SearchFilterFromJson(json);

  Map<String, dynamic> toJson() => _$SearchFilterToJson(this);
}

@JsonSerializable()
class SearchFilterPrice {
  SearchFilterPrice(this.name, this.min, this.max);

  String name;
  double min;
  double max;

  factory SearchFilterPrice.fromJson(Map<String, dynamic> json) => _$SearchFilterPriceFromJson(json);

  Map<String, dynamic> toJson() => _$SearchFilterPriceToJson(this);
}

@JsonSerializable()
class SearchFilterHour {
  SearchFilterHour(this.type, this.day, this.open, this.close);

  SearchFilterHourType type;
  String day;
  String open;
  String close;

  factory SearchFilterHour.fromJson(Map<String, dynamic> json) => _$SearchFilterHourFromJson(json);

  Map<String, dynamic> toJson() => _$SearchFilterHourToJson(this);
}

enum SearchFilterHourType { OpenNow, OpenDay }

@JsonSerializable()
class SearchFilterLocation {
  SearchFilterLocation(this.type, this.areas, this.points);

  SearchFilterLocation.type({SearchFilterLocationType type = SearchFilterLocationType.Anywhere});

  SearchFilterLocationType type = SearchFilterLocationType.Anywhere;
  List<Area> areas = [];
  List<SearchFilterLocationPoint> points = [];

  factory SearchFilterLocation.fromJson(Map<String, dynamic> json) => _$SearchFilterLocationFromJson(json);

  Map<String, dynamic> toJson() => _$SearchFilterLocationToJson(this);
}

@JsonSerializable()
class SearchFilterLocationPoint {
  SearchFilterLocationPoint(this.name, this.latLng);

  String name;
  String latLng;

  factory SearchFilterLocationPoint.fromJson(Map<String, dynamic> json) => _$SearchFilterLocationPointFromJson(json);

  Map<String, dynamic> toJson() => _$SearchFilterLocationPointToJson(this);

  static List<SearchFilterLocationPoint> fromJsonList(List<dynamic> list) {
    return list.map((map) => SearchFilterLocationPoint.fromJson(map)).toList(growable: false);
  }
}

enum SearchFilterLocationType { Between, Where, Nearby, Anywhere }

@JsonSerializable()
class SearchSort {
  SearchSort(this.type);

  String type;

  factory SearchSort.fromJson(Map<String, dynamic> json) => _$SearchSortFromJson(json);

  Map<String, dynamic> toJson() => _$SearchSortToJson(this);
}

class SearchCard {
  String cardId;
  String uniqueId;

  Map<String, dynamic> _body;

  SearchCard(Map<String, dynamic> body) {
    _body = body;
    this.cardId = _body['_cardId'];
    this.uniqueId = _body['_uniqueId'];
  }

  SearchCard.cardId(this.cardId, {Map<String, dynamic> body = const {}}) {
    _body = body;
  }

  dynamic operator [](String name) => _body[name];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchCard && runtimeType == other.runtimeType && cardId == other.cardId && uniqueId == other.uniqueId;

  @override
  int get hashCode => cardId.hashCode ^ uniqueId.hashCode;
}
