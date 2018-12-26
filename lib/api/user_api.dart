import 'package:json_annotation/json_annotation.dart';
import 'package:munch_app/api/munch_data.dart';

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
}

List<Tag> possibleTagRequirements = [
  Tag("abb22d3d-7d23-4677-b4ef-a3e09f2f9ada", "Halal", TagType.Requirement),
  Tag("fdf77b3b-8f90-419f-b711-dd25f97046fe", "Vegetarian Options", TagType.Requirement),
];
