// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'munch_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) {
  return Place(
      json['placeId'] as String,
      json['status'] == null
          ? null
          : PlaceStatus.fromJson(json['status'] as Map<String, dynamic>),
      json['name'] as String,
      (json['tags'] as List)
          ?.map(
              (e) => e == null ? null : Tag.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['phone'] as String,
      json['website'] as String,
      json['description'] as String,
      json['menu'] == null
          ? null
          : PlaceMenu.fromJson(json['menu'] as Map<String, dynamic>),
      json['price'] == null
          ? null
          : PlacePrice.fromJson(json['price'] as Map<String, dynamic>),
      json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
      (json['hours'] as List)
          ?.map((e) =>
              e == null ? null : Hour.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['images'] as List)
          ?.map((e) =>
              e == null ? null : Image.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['areas'] as List)
          ?.map((e) =>
              e == null ? null : Area.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['createdMillis'] as int);
}

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'placeId': instance.placeId,
      'status': instance.status,
      'name': instance.name,
      'tags': instance.tags,
      'phone': instance.phone,
      'website': instance.website,
      'description': instance.description,
      'menu': instance.menu,
      'price': instance.price,
      'location': instance.location,
      'hours': instance.hours,
      'images': instance.images,
      'areas': instance.areas,
      'createdMillis': instance.createdMillis
    };

PlaceStatus _$PlaceStatusFromJson(Map<String, dynamic> json) {
  return PlaceStatus(
      _$enumDecodeNullable(_$PlaceStatusTypeEnumMap, json['type']));
}

Map<String, dynamic> _$PlaceStatusToJson(PlaceStatus instance) =>
    <String, dynamic>{'type': _$PlaceStatusTypeEnumMap[instance.type]};

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

const _$PlaceStatusTypeEnumMap = <PlaceStatusType, dynamic>{
  PlaceStatusType.open: 'open',
  PlaceStatusType.renovation: 'renovation',
  PlaceStatusType.closed: 'closed',
  PlaceStatusType.moved: 'moved'
};

PlaceMenu _$PlaceMenuFromJson(Map<String, dynamic> json) {
  return PlaceMenu(json['url'] as String);
}

Map<String, dynamic> _$PlaceMenuToJson(PlaceMenu instance) =>
    <String, dynamic>{'url': instance.url};

PlacePrice _$PlacePriceFromJson(Map<String, dynamic> json) {
  return PlacePrice((json['perPax'] as num)?.toDouble());
}

Map<String, dynamic> _$PlacePriceToJson(PlacePrice instance) =>
    <String, dynamic>{'perPax': instance.perPax};

Tag _$TagFromJson(Map<String, dynamic> json) {
  return Tag(json['tagId'] as String, json['name'] as String,
      _$enumDecodeNullable(_$TagTypeEnumMap, json['type']));
}

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'tagId': instance.tagId,
      'name': instance.name,
      'type': _$TagTypeEnumMap[instance.type]
    };

const _$TagTypeEnumMap = <TagType, dynamic>{
  TagType.Food: 'Food',
  TagType.Cuisine: 'Cuisine',
  TagType.Establishment: 'Establishment',
  TagType.Amenities: 'Amenities',
  TagType.Timing: 'Timing',
  TagType.Requirement: 'Requirement'
};

Landmark _$LandmarkFromJson(Map<String, dynamic> json) {
  return Landmark(
      json['landmarkId'] as String,
      _$enumDecodeNullable(_$LandmarkTypeEnumMap, json['type']),
      json['name'] as String,
      json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>));
}

Map<String, dynamic> _$LandmarkToJson(Landmark instance) => <String, dynamic>{
      'landmarkId': instance.landmarkId,
      'type': _$LandmarkTypeEnumMap[instance.type],
      'name': instance.name,
      'location': instance.location
    };

const _$LandmarkTypeEnumMap = <LandmarkType, dynamic>{
  LandmarkType.train: 'train',
  LandmarkType.other: 'other'
};

AreaCount _$AreaCountFromJson(Map<String, dynamic> json) {
  return AreaCount(json['total'] as int);
}

Map<String, dynamic> _$AreaCountToJson(AreaCount instance) =>
    <String, dynamic>{'total': instance.total};

Area _$AreaFromJson(Map<String, dynamic> json) {
  return Area(
      json['areaId'] as String,
      _$enumDecodeNullable(_$AreaTypeEnumMap, json['type']),
      json['name'] as String,
      json['website'] as String,
      json['description'] as String,
      (json['hours'] as List)
          ?.map((e) =>
              e == null ? null : Hour.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['images'] as List)
          ?.map((e) =>
              e == null ? null : Image.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['counts'] == null
          ? null
          : AreaCount.fromJson(json['counts'] as Map<String, dynamic>),
      json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>));
}

Map<String, dynamic> _$AreaToJson(Area instance) => <String, dynamic>{
      'areaId': instance.areaId,
      'type': _$AreaTypeEnumMap[instance.type],
      'name': instance.name,
      'website': instance.website,
      'description': instance.description,
      'hours': instance.hours,
      'images': instance.images,
      'counts': instance.counts,
      'location': instance.location
    };

const _$AreaTypeEnumMap = <AreaType, dynamic>{
  AreaType.City: 'City',
  AreaType.Superset: 'Superset',
  AreaType.Region: 'Region',
  AreaType.Cluster: 'Cluster',
  AreaType.Generated: 'Generated'
};

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
      json['address'] as String,
      json['street'] as String,
      json['unitNumber'] as String,
      json['neighbourhood'] as String,
      json['city'] as String,
      json['country'] as String,
      json['postcode'] as String,
      json['latLng'] as String,
      json['polygon'] == null
          ? null
          : LocationPolygon.fromJson(json['polygon'] as Map<String, dynamic>),
      (json['landmarks'] as List)
          ?.map((e) =>
              e == null ? null : Landmark.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'address': instance.address,
      'street': instance.street,
      'unitNumber': instance.unitNumber,
      'neighbourhood': instance.neighbourhood,
      'city': instance.city,
      'country': instance.country,
      'postcode': instance.postcode,
      'latLng': instance.latLng,
      'polygon': instance.polygon,
      'landmarks': instance.landmarks
    };

LocationPolygon _$LocationPolygonFromJson(Map<String, dynamic> json) {
  return LocationPolygon(
      (json['points'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$LocationPolygonToJson(LocationPolygon instance) =>
    <String, dynamic>{'points': instance.points};

Hour _$HourFromJson(Map<String, dynamic> json) {
  return Hour(_$enumDecodeNullable(_$HourDayEnumMap, json['day']),
      json['open'] as String, json['close'] as String);
}

Map<String, dynamic> _$HourToJson(Hour instance) => <String, dynamic>{
      'day': _$HourDayEnumMap[instance.day],
      'open': instance.open,
      'close': instance.close
    };

const _$HourDayEnumMap = <HourDay, dynamic>{
  HourDay.mon: 'mon',
  HourDay.tue: 'tue',
  HourDay.wed: 'wed',
  HourDay.thu: 'thu',
  HourDay.fri: 'fri',
  HourDay.sat: 'sat',
  HourDay.sun: 'sun'
};
