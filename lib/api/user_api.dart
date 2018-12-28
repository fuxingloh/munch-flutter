import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_api.g.dart';

@JsonSerializable()
class UserProfile {
  UserProfile(this.userId, this.name, this.email, this.photoUrl);

  String userId;
  String name;
  String email;
  String photoUrl;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

@JsonSerializable()
class UserSetting {
  UserSetting(this.mailings);

  Map<String, bool> mailings;

  factory UserSetting.fromJson(Map<String, dynamic> json) =>
      _$UserSettingFromJson(json);

  Map<String, dynamic> toJson() => _$UserSettingToJson(this);
}

@JsonSerializable()
class UserSearchPreference {
  UserSearchPreference(this.requirements, this.updatedMillis);

  List<Tag> requirements;
  int updatedMillis;

  factory UserSearchPreference.fromJson(Map<String, dynamic> json) =>
      _$UserSearchPreferenceFromJson(json);

  Map<String, dynamic> toJson() => _$UserSearchPreferenceToJson(this);

  static Future<UserSearchPreference> get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var string = prefs.getString("UserSearchPreference");
    if (string == null) return null;

    return UserSearchPreference.fromJson(jsonDecode(string));
  }
}

@JsonSerializable()
class UserSavedPlace {
  UserSavedPlace(this.userId, this.placeId, this.name, this.createdMillis,
      this.place);

  String userId;
  String placeId;
  String name;

  int createdMillis;
  Place place;

  factory UserSavedPlace.fromJson(Map<String, dynamic> json) =>
      _$UserSavedPlaceFromJson(json);

  Map<String, dynamic> toJson() => _$UserSavedPlaceToJson(this);
}

final List<Tag> possibleTagRequirements = [
  Tag("abb22d3d-7d23-4677-b4ef-a3e09f2f9ada", "Halal", TagType.Requirement),
  Tag("fdf77b3b-8f90-419f-b711-dd25f97046fe", "Vegetarian Options", TagType.Requirement),
];
