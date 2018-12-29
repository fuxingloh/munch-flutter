// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterTag _$FilterTagFromJson(Map<String, dynamic> json) {
  return FilterTag(
      json['tagId'] as String,
      json['name'] as String,
      _$enumDecodeNullable(_$TagTypeEnumMap, json['type']),
      json['count'] as int);
}

Map<String, dynamic> _$FilterTagToJson(FilterTag instance) => <String, dynamic>{
      'tagId': instance.tagId,
      'name': instance.name,
      'type': _$TagTypeEnumMap[instance.type],
      'count': instance.count
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$TagTypeEnumMap = <TagType, dynamic>{
  TagType.Food: 'Food',
  TagType.Cuisine: 'Cuisine',
  TagType.Establishment: 'Establishment',
  TagType.Amenities: 'Amenities',
  TagType.Timing: 'Timing',
  TagType.Requirement: 'Requirement'
};

FilterResult _$FilterResultFromJson(Map<String, dynamic> json) {
  return FilterResult(
      json['count'] as int,
      json['tagGraph'] == null
          ? null
          : FilterTagGraph.fromJson(json['tagGraph'] as Map<String, dynamic>),
      json['priceGraph'] == null
          ? null
          : FilterPriceGraph.fromJson(
              json['priceGraph'] as Map<String, dynamic>));
}

Map<String, dynamic> _$FilterResultToJson(FilterResult instance) =>
    <String, dynamic>{
      'count': instance.count,
      'tagGraph': instance.tagGraph,
      'priceGraph': instance.priceGraph
    };

FilterTagGraph _$FilterTagGraphFromJson(Map<String, dynamic> json) {
  return FilterTagGraph((json['tags'] as List)
      ?.map((e) =>
          e == null ? null : FilterTag.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$FilterTagGraphToJson(FilterTagGraph instance) =>
    <String, dynamic>{'tags': instance.tags};

FilterPriceGraph _$FilterPriceGraphFromJson(Map<String, dynamic> json) {
  return FilterPriceGraph(
      (json['min'] as num)?.toDouble(),
      (json['max'] as num)?.toDouble(),
      (json['points'] as List)
          ?.map((e) => e == null
              ? null
              : FilterPriceGraphPoint.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['ranges'] as Map<String, dynamic>)?.map((k, e) => MapEntry(
          k,
          e == null
              ? null
              : FilterPriceGraphRange.fromJson(e as Map<String, dynamic>))));
}

Map<String, dynamic> _$FilterPriceGraphToJson(FilterPriceGraph instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
      'points': instance.points,
      'ranges': instance.ranges
    };

FilterPriceGraphPoint _$FilterPriceGraphPointFromJson(
    Map<String, dynamic> json) {
  return FilterPriceGraphPoint(
      (json['price'] as num)?.toDouble(), (json['count'] as num)?.toDouble());
}

Map<String, dynamic> _$FilterPriceGraphPointToJson(
        FilterPriceGraphPoint instance) =>
    <String, dynamic>{'price': instance.price, 'count': instance.count};

FilterPriceGraphRange _$FilterPriceGraphRangeFromJson(
    Map<String, dynamic> json) {
  return FilterPriceGraphRange(
      (json['min'] as num)?.toDouble(), (json['max'] as num)?.toDouble());
}

Map<String, dynamic> _$FilterPriceGraphRangeToJson(
        FilterPriceGraphRange instance) =>
    <String, dynamic>{'min': instance.min, 'max': instance.max};

SuggestResult _$SuggestResultFromJson(Map<String, dynamic> json) {
  return SuggestResult(
      (json['suggests'] as List)?.map((e) => e as String)?.toList(),
      (json['places'] as List)
          ?.map((e) =>
              e == null ? null : Place.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['assumptions'] as List)
          ?.map((e) => e == null
              ? null
              : AssumptionQueryResult.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$SuggestResultToJson(SuggestResult instance) =>
    <String, dynamic>{
      'suggests': instance.suggests,
      'places': instance.places,
      'assumptions': instance.assumptions
    };

AssumptionQueryResult _$AssumptionQueryResultFromJson(
    Map<String, dynamic> json) {
  return AssumptionQueryResult(
      json['searchQuery'] == null
          ? null
          : SearchQuery.fromJson(json['searchQuery'] as Map<String, dynamic>),
      (json['tokens'] as List)
          ?.map((e) => e == null
              ? null
              : AssumptionToken.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['place'] as List)
          ?.map((e) =>
              e == null ? null : Place.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['count'] as int);
}

Map<String, dynamic> _$AssumptionQueryResultToJson(
        AssumptionQueryResult instance) =>
    <String, dynamic>{
      'searchQuery': instance.searchQuery,
      'tokens': instance.tokens,
      'place': instance.place,
      'count': instance.count
    };

AssumptionToken _$AssumptionTokenFromJson(Map<String, dynamic> json) {
  return AssumptionToken(json['text'] as String,
      _$enumDecodeNullable(_$AssumptionTypeEnumMap, json['type']));
}

Map<String, dynamic> _$AssumptionTokenToJson(AssumptionToken instance) =>
    <String, dynamic>{
      'text': instance.text,
      'type': _$AssumptionTypeEnumMap[instance.type]
    };

const _$AssumptionTypeEnumMap = <AssumptionType, dynamic>{
  AssumptionType.tag: 'tag',
  AssumptionType.text: 'text',
  AssumptionType.others: 'others'
};

SearchQuery _$SearchQueryFromJson(Map<String, dynamic> json) {
  return SearchQuery(
      _$enumDecodeNullable(_$SearchFeatureEnumMap, json['feature']),
      json['collection'] == null
          ? null
          : SearchCollection.fromJson(
              json['collection'] as Map<String, dynamic>),
      json['filter'] == null
          ? null
          : SearchFilter.fromJson(json['filter'] as Map<String, dynamic>),
      json['sort'] == null
          ? null
          : SearchSort.fromJson(json['sort'] as Map<String, dynamic>));
}

Map<String, dynamic> _$SearchQueryToJson(SearchQuery instance) =>
    <String, dynamic>{
      'feature': _$SearchFeatureEnumMap[instance.feature],
      'collection': instance.collection,
      'filter': instance.filter,
      'sort': instance.sort
    };

const _$SearchFeatureEnumMap = <SearchFeature, dynamic>{
  SearchFeature.Home: 'Home',
  SearchFeature.Search: 'Search',
  SearchFeature.Location: 'Location',
  SearchFeature.Collection: 'Collection',
  SearchFeature.Occasion: 'Occasion'
};

SearchCollection _$SearchCollectionFromJson(Map<String, dynamic> json) {
  return SearchCollection(
      json['name'] as String, json['collectionId'] as String);
}

Map<String, dynamic> _$SearchCollectionToJson(SearchCollection instance) =>
    <String, dynamic>{
      'name': instance.name,
      'collectionId': instance.collectionId
    };

SearchFilter _$SearchFilterFromJson(Map<String, dynamic> json) {
  return SearchFilter(
      json['price'] == null
          ? null
          : SearchFilterPrice.fromJson(json['price'] as Map<String, dynamic>),
      json['hour'] == null
          ? null
          : SearchFilterHour.fromJson(json['hour'] as Map<String, dynamic>),
      (json['tags'] as List)
          ?.map(
              (e) => e == null ? null : Tag.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['location'] == null
          ? null
          : SearchFilterLocation.fromJson(
              json['location'] as Map<String, dynamic>));
}

Map<String, dynamic> _$SearchFilterToJson(SearchFilter instance) =>
    <String, dynamic>{
      'price': instance.price,
      'hour': instance.hour,
      'tags': instance.tags,
      'location': instance.location
    };

SearchFilterPrice _$SearchFilterPriceFromJson(Map<String, dynamic> json) {
  return SearchFilterPrice(json['name'] as String,
      (json['min'] as num)?.toDouble(), (json['max'] as num)?.toDouble());
}

Map<String, dynamic> _$SearchFilterPriceToJson(SearchFilterPrice instance) =>
    <String, dynamic>{
      'name': instance.name,
      'min': instance.min,
      'max': instance.max
    };

SearchFilterHour _$SearchFilterHourFromJson(Map<String, dynamic> json) {
  return SearchFilterHour(
      _$enumDecodeNullable(_$SearchFilterHourTypeEnumMap, json['type']),
      json['day'] as String,
      json['open'] as String,
      json['close'] as String);
}

Map<String, dynamic> _$SearchFilterHourToJson(SearchFilterHour instance) =>
    <String, dynamic>{
      'type': _$SearchFilterHourTypeEnumMap[instance.type],
      'day': instance.day,
      'open': instance.open,
      'close': instance.close
    };

const _$SearchFilterHourTypeEnumMap = <SearchFilterHourType, dynamic>{
  SearchFilterHourType.OpenNow: 'OpenNow',
  SearchFilterHourType.OpenDay: 'OpenSay'
};

SearchFilterLocation _$SearchFilterLocationFromJson(Map<String, dynamic> json) {
  return SearchFilterLocation(
      _$enumDecodeNullable(_$SearchFilterLocationTypeEnumMap, json['type']),
      (json['areas'] as List)
          ?.map((e) =>
              e == null ? null : Area.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['points'] as List)
          ?.map((e) => e == null
              ? null
              : SearchFilterLocationPoint.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$SearchFilterLocationToJson(
        SearchFilterLocation instance) =>
    <String, dynamic>{
      'type': _$SearchFilterLocationTypeEnumMap[instance.type],
      'areas': instance.areas,
      'points': instance.points
    };

const _$SearchFilterLocationTypeEnumMap = <SearchFilterLocationType, dynamic>{
  SearchFilterLocationType.Between: 'Between',
  SearchFilterLocationType.Where: 'Where',
  SearchFilterLocationType.Nearby: 'Nearby',
  SearchFilterLocationType.Anywhere: 'Anywhere'
};

SearchFilterLocationPoint _$SearchFilterLocationPointFromJson(
    Map<String, dynamic> json) {
  return SearchFilterLocationPoint(
      json['name'] as String, json['latLng'] as String);
}

Map<String, dynamic> _$SearchFilterLocationPointToJson(
        SearchFilterLocationPoint instance) =>
    <String, dynamic>{'name': instance.name, 'latLng': instance.latLng};

SearchSort _$SearchSortFromJson(Map<String, dynamic> json) {
  return SearchSort(json['type'] as String);
}

Map<String, dynamic> _$SearchSortToJson(SearchSort instance) =>
    <String, dynamic>{'type': instance.type};
