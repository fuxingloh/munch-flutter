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
