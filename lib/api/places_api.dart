import 'package:json_annotation/json_annotation.dart';
import 'package:munch_app/api/collection_api.dart';
import 'package:munch_app/api/file_api.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/api/user_api.dart';

part 'places_api.g.dart';

@JsonSerializable()
class PlaceData {
  PlaceData(this.place, this.awards, this.articles, this.images, this.user);

  Place place;

  List<UserPlaceCollectionItem> awards;
  List<Article> articles;
  List<PlaceImage> images;
  PlaceDataUser user;

  factory PlaceData.fromJson(Map<String, dynamic> json) =>
      _$PlaceDataFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceDataToJson(this);
}

@JsonSerializable()
class PlaceDataUser {
  PlaceDataUser(this.savedPlace);

  UserSavedPlace savedPlace;

  factory PlaceDataUser.fromJson(Map<String, dynamic> json) =>
      _$PlaceDataUserFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceDataUserToJson(this);
}

@JsonSerializable()
class Article {
  Article(this.articleId, this.sort, this.domainId, this.domain, this.url,
      this.title, this.description, this.thumbnail, this.createdMillis);

  String articleId;
  String sort;

  String domainId;
  ArticleDomain domain;

  String url;
  String title;
  String description;

  Image thumbnail;
  int createdMillis;

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}

@JsonSerializable()
class ArticleDomain {
  ArticleDomain(this.name, this.url);

  String name;
  String url;

  factory ArticleDomain.fromJson(Map<String, dynamic> json) =>
      _$ArticleDomainFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleDomainToJson(this);
}

@JsonSerializable()
class PlaceImage {
  PlaceImage(this.imageId, this.sort, this.sizes, this.title, this.caption,
      this.article, this.instagram, this.createdMillis);

  String imageId;
  String sort;
  List<ImageSize> sizes;

  String title;
  String caption;

  Article article;
  Instagram instagram;
  int createdMillis;

  factory PlaceImage.fromJson(Map<String, dynamic> json) =>
      _$PlaceImageFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceImageToJson(this);
}

@JsonSerializable()
class Instagram {
  Instagram(this.accountId, this.mediaId, this.link, this.username);

  String accountId;
  String mediaId;

  String link;
  String username;

  factory Instagram.fromJson(Map<String, dynamic> json) =>
      _$InstagramFromJson(json);

  Map<String, dynamic> toJson() => _$InstagramToJson(this);
}

