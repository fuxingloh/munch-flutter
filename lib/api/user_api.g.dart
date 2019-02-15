// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return UserProfile(json['userId'] as String, json['name'] as String,
      json['email'] as String, json['photoUrl'] as String);
}

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'photoUrl': instance.photoUrl
    };

UserSetting _$UserSettingFromJson(Map<String, dynamic> json) {
  return UserSetting((json['mailings'] as Map<String, dynamic>)
      ?.map((k, e) => MapEntry(k, e as bool)));
}

Map<String, dynamic> _$UserSettingToJson(UserSetting instance) =>
    <String, dynamic>{'mailings': instance.mailings};

UserSearchPreference _$UserSearchPreferenceFromJson(Map<String, dynamic> json) {
  return UserSearchPreference(
      (json['requirements'] as List)
          ?.map(
              (e) => e == null ? null : Tag.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['updatedMillis'] as int);
}

Map<String, dynamic> _$UserSearchPreferenceToJson(
        UserSearchPreference instance) =>
    <String, dynamic>{
      'requirements': instance.requirements,
      'updatedMillis': instance.updatedMillis
    };

UserSavedPlace _$UserSavedPlaceFromJson(Map<String, dynamic> json) {
  return UserSavedPlace(
      json['userId'] as String,
      json['placeId'] as String,
      json['name'] as String,
      json['createdMillis'] as int,
      json['place'] == null
          ? null
          : Place.fromJson(json['place'] as Map<String, dynamic>));
}

Map<String, dynamic> _$UserSavedPlaceToJson(UserSavedPlace instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'placeId': instance.placeId,
      'name': instance.name,
      'createdMillis': instance.createdMillis,
      'place': instance.place
    };

UserLocation _$UserLocationFromJson(Map<String, dynamic> json) {
  return UserLocation(
      userId: json['userId'] as String,
      sortId: json['sortId'] as String,
      type: _$enumDecodeNullable(_$UserLocationTypeEnumMap, json['type']),
      input: _$enumDecodeNullable(_$UserLocationInputEnumMap, json['input']),
      name: json['name'] as String,
      latLng: json['latLng'] as String,
      address: json['address'] as String,
      createdMillis: json['createdMillis'] as int,
      updatedMillis: json['updatedMillis'] as int);
}

Map<String, dynamic> _$UserLocationToJson(UserLocation instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'sortId': instance.sortId,
      'type': _$UserLocationTypeEnumMap[instance.type],
      'input': _$UserLocationInputEnumMap[instance.input],
      'name': instance.name,
      'latLng': instance.latLng,
      'address': instance.address,
      'createdMillis': instance.createdMillis,
      'updatedMillis': instance.updatedMillis
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

const _$UserLocationTypeEnumMap = <UserLocationType, dynamic>{
  UserLocationType.home: 'home',
  UserLocationType.work: 'work',
  UserLocationType.saved: 'saved',
  UserLocationType.recent: 'recent'
};

const _$UserLocationInputEnumMap = <UserLocationInput, dynamic>{
  UserLocationInput.current: 'current',
  UserLocationInput.searched: 'searched',
  UserLocationInput.history: 'history'
};

UserRatedPlace _$UserRatedPlaceFromJson(Map<String, dynamic> json) {
  return UserRatedPlace(
      json['userId'] as String,
      json['placeId'] as String,
      _$enumDecodeNullable(_$UserRatedPlaceRatingEnumMap, json['rating']),
      _$enumDecodeNullable(_$UserRatedPlaceStatusEnumMap, json['status']),
      json['createdMillis'] as int,
      json['updatedMillis'] as int);
}

Map<String, dynamic> _$UserRatedPlaceToJson(UserRatedPlace instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'placeId': instance.placeId,
      'rating': _$UserRatedPlaceRatingEnumMap[instance.rating],
      'status': _$UserRatedPlaceStatusEnumMap[instance.status],
      'createdMillis': instance.createdMillis,
      'updatedMillis': instance.updatedMillis
    };

const _$UserRatedPlaceRatingEnumMap = <UserRatedPlaceRating, dynamic>{
  UserRatedPlaceRating.star1: 'star1',
  UserRatedPlaceRating.star2: 'star2',
  UserRatedPlaceRating.star3: 'star3',
  UserRatedPlaceRating.star4: 'star4',
  UserRatedPlaceRating.star5: 'star5'
};

const _$UserRatedPlaceStatusEnumMap = <UserRatedPlaceStatus, dynamic>{
  UserRatedPlaceStatus.draft: 'draft',
  UserRatedPlaceStatus.published: 'published',
  UserRatedPlaceStatus.deleted: 'deleted'
};
