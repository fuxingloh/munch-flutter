// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData(
      json['profile'] == null
          ? null
          : UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
      json['setting'] == null
          ? null
          : UserSetting.fromJson(json['setting'] as Map<String, dynamic>),
      json['searchPreference'] == null
          ? null
          : UserSearchPreference.fromJson(
              json['searchPreference'] as Map<String, dynamic>));
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'profile': instance.profile,
      'setting': instance.setting,
      'searchPreference': instance.searchPreference
    };
