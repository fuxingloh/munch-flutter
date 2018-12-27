import 'package:json_annotation/json_annotation.dart';
import 'package:munch_app/api/file_api.dart';
import 'package:munch_app/api/munch_data.dart';

part 'collection_api.g.dart';

@JsonSerializable()
class UserPlaceCollection {
  UserPlaceCollection(
      this.collectionId,
      this.userId,
      this.sort,
      this.name,
      this.description,
      this.image,
      this.access,
      this.createdBy,
      this.createdMillis,
      this.updatedMillis,
      this.count);

  String collectionId;
  String userId;
  int sort;

  String name;
  String description;
  Image image;

  Access access;
  CreatedBy createdBy;

  int createdMillis;
  int updatedMillis;

  int count;

  factory UserPlaceCollection.fromJson(Map<String, dynamic> json) =>
      _$UserPlaceCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$UserPlaceCollectionToJson(this);
}

enum Access { Public, Private }

enum CreatedBy { User, Award, ForYou, Default }

@JsonSerializable()
class UserPlaceCollectionItem {
  UserPlaceCollectionItem(this.collectionId, this.placeId, this.sort,
      this.createdMillis, this.place, this.award);

  String collectionId;
  String placeId;

  int sort;
  int createdMillis;

  Place place;
  UserPlaceCollectionAward award;

  factory UserPlaceCollectionItem.fromJson(Map<String, dynamic> json) =>
      _$UserPlaceCollectionItemFromJson(json);

  Map<String, dynamic> toJson() => _$UserPlaceCollectionItemToJson(this);
}

@JsonSerializable()
class UserPlaceCollectionAward {
  UserPlaceCollectionAward(
      this.name, this.description, this.sort, this.collectionId);

  String name;
  String description;
  int sort;
  String collectionId;

  factory UserPlaceCollectionAward.fromJson(Map<String, dynamic> json) =>
      _$UserPlaceCollectionAwardFromJson(json);

  Map<String, dynamic> toJson() => _$UserPlaceCollectionAwardToJson(this);
}
