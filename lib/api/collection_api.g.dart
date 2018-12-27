// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPlaceCollection _$UserPlaceCollectionFromJson(Map<String, dynamic> json) {
  return UserPlaceCollection(
      json['collectionId'] as String,
      json['userId'] as String,
      json['sort'] as int,
      json['name'] as String,
      json['description'] as String,
      json['image'] == null
          ? null
          : Image.fromJson(json['image'] as Map<String, dynamic>),
      _$enumDecodeNullable(_$AccessEnumMap, json['access']),
      _$enumDecodeNullable(_$CreatedByEnumMap, json['createdBy']),
      json['createdMillis'] as int,
      json['updatedMillis'] as int,
      json['count'] as int);
}

Map<String, dynamic> _$UserPlaceCollectionToJson(
        UserPlaceCollection instance) =>
    <String, dynamic>{
      'collectionId': instance.collectionId,
      'userId': instance.userId,
      'sort': instance.sort,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'access': _$AccessEnumMap[instance.access],
      'createdBy': _$CreatedByEnumMap[instance.createdBy],
      'createdMillis': instance.createdMillis,
      'updatedMillis': instance.updatedMillis,
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

const _$AccessEnumMap = <Access, dynamic>{
  Access.Public: 'Public',
  Access.Private: 'Private'
};

const _$CreatedByEnumMap = <CreatedBy, dynamic>{
  CreatedBy.User: 'User',
  CreatedBy.Award: 'Award',
  CreatedBy.ForYou: 'ForYou',
  CreatedBy.Default: 'Default'
};

UserPlaceCollectionItem _$UserPlaceCollectionItemFromJson(
    Map<String, dynamic> json) {
  return UserPlaceCollectionItem(
      json['collectionId'] as String,
      json['placeId'] as String,
      json['sort'] as int,
      json['createdMillis'] as int,
      json['place'] == null
          ? null
          : Place.fromJson(json['place'] as Map<String, dynamic>),
      json['award'] == null
          ? null
          : UserPlaceCollectionAward.fromJson(
              json['award'] as Map<String, dynamic>));
}

Map<String, dynamic> _$UserPlaceCollectionItemToJson(
        UserPlaceCollectionItem instance) =>
    <String, dynamic>{
      'collectionId': instance.collectionId,
      'placeId': instance.placeId,
      'sort': instance.sort,
      'createdMillis': instance.createdMillis,
      'place': instance.place,
      'award': instance.award
    };

UserPlaceCollectionAward _$UserPlaceCollectionAwardFromJson(
    Map<String, dynamic> json) {
  return UserPlaceCollectionAward(
      json['name'] as String,
      json['description'] as String,
      json['sort'] as int,
      json['collectionId'] as String);
}

Map<String, dynamic> _$UserPlaceCollectionAwardToJson(
        UserPlaceCollectionAward instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'sort': instance.sort,
      'collectionId': instance.collectionId
    };
