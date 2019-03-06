import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/utils/munch_analytic.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_api.g.dart';

@JsonSerializable()
class UserProfile {
  UserProfile(this.userId, this.name, this.email, this.photoUrl);

  String userId;
  String name;
  String email;
  String photoUrl;

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  static Future<UserProfile> get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var string = prefs.getString("UserProfile");
    if (string == null) return null;

    return UserProfile.fromJson(jsonDecode(string));
  }

  static Future put(UserProfile profile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("UserProfile", jsonEncode(profile));

    MunchAnalytic.setUserId(profile.userId);
  }
}

@JsonSerializable()
class UserSetting {
  UserSetting(this.mailings);

  Map<String, bool> mailings;

  factory UserSetting.fromJson(Map<String, dynamic> json) => _$UserSettingFromJson(json);

  Map<String, dynamic> toJson() => _$UserSettingToJson(this);

  static Future<UserSetting> get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var string = prefs.getString("UserSetting");
    if (string == null) return null;

    return UserSetting.fromJson(jsonDecode(string));
  }

  static Future put(UserSetting setting) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("UserSetting", jsonEncode(setting));
  }
}

@JsonSerializable()
class UserSearchPreference {
  @JsonKey(ignore: true)
  static UserSearchPreference instance;

  UserSearchPreference(this.requirements, this.updatedMillis);

  List<Tag> requirements;
  int updatedMillis;

  factory UserSearchPreference.fromJson(Map<String, dynamic> json) => _$UserSearchPreferenceFromJson(json);

  Map<String, dynamic> toJson() => _$UserSearchPreferenceToJson(this);

  static Future<UserSearchPreference> get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var string = prefs.getString("UserSearchPreference");
    if (string == null) return null;

    var preference = UserSearchPreference.fromJson(jsonDecode(string));
    instance = preference;
    return preference;
  }

  static Future put(UserSearchPreference preference) async {
    instance = preference;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("UserSearchPreference", jsonEncode(preference));
  }
}

@JsonSerializable()
class UserSavedPlace {
  UserSavedPlace(this.userId, this.placeId, this.name, this.createdMillis, this.place);

  String userId;
  String placeId;
  String name;

  int createdMillis;
  Place place;

  factory UserSavedPlace.fromJson(Map<String, dynamic> json) => _$UserSavedPlaceFromJson(json);

  Map<String, dynamic> toJson() => _$UserSavedPlaceToJson(this);
}

@JsonSerializable()
class UserLocation {
  UserLocation({
    this.userId,
    this.sortId,
    this.type,
    this.input,
    this.name,
    this.latLng,
    this.address,
    this.createdMillis,
    this.updatedMillis,
  });

  String userId;
  String sortId;

  UserLocationType type;
  UserLocationInput input;

  String name;
  String latLng;
  String address;

  int createdMillis;
  int updatedMillis;

  static List<UserLocation> fromJsonList(List<dynamic> list) {
    return list.map((map) => UserLocation.fromJson(map)).toList(growable: false);
  }

  factory UserLocation.fromJson(Map<String, dynamic> json) => _$UserLocationFromJson(json);

  Map<String, dynamic> toJson() => _$UserLocationToJson(this);
}

enum UserLocationType { home, work, saved, recent }
enum UserLocationInput {
  /// User current location
  current,

  /// User searched location
  searched,

  /// User selected from history
  history,
}

@JsonSerializable()
class UserRatedPlace {
  UserRatedPlace({
    this.userId,
    this.placeId,
    this.rating,
    this.status,
    this.createdMillis,
    this.updatedMillis,
  });

  String userId;
  String placeId;

  UserRatedPlaceRating rating;
  UserRatedPlaceStatus status;

  int createdMillis;
  int updatedMillis;

  factory UserRatedPlace.fromJson(Map<String, dynamic> json) => _$UserRatedPlaceFromJson(json);

  Map<String, dynamic> toJson() => _$UserRatedPlaceToJson(this);
}

enum UserRatedPlaceStatus { draft, published, deleted }
enum UserRatedPlaceRating { star1, star2, star3, star4, star5 }

final List<Tag> possibleTagRequirements = [
  Tag("abb22d3d-7d23-4677-b4ef-a3e09f2f9ada", "Halal", TagType.Requirement),
  Tag("fdf77b3b-8f90-419f-b711-dd25f97046fe", "Vegetarian Options", TagType.Requirement),
];
