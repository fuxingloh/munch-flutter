import 'package:json_annotation/json_annotation.dart';
import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/file_api.dart';
import 'package:munch_app/api/munch_data.dart';

part 'feed_api.g.dart';

@JsonSerializable()
class ImageFeedResult {
  ImageFeedResult(this.items, this.places);

  List<ImageFeedItem> items;
  Map<String, Place> places;

  factory ImageFeedResult.fromJson(Map<String, dynamic> json) =>
      _$ImageFeedResultFromJson(json);

  Map<String, dynamic> toJson() => _$ImageFeedResultToJson(this);
}

@JsonSerializable()
class ImageFeedItem {
  ImageFeedItem(
    this.itemId,
    this.sort,
    this.country,
    this.latLng,
    this.image,
    this.createdMillis,
    this.instagram,
    this.places,
  );

  String itemId;
  String sort;

  String country;
  String latLng;

  Image image;
  int createdMillis;

  ImageFeedItemInstagram instagram;
  List<Place> places;

  factory ImageFeedItem.fromJson(Map<String, dynamic> json) =>
      _$ImageFeedItemFromJson(json);

  Map<String, dynamic> toJson() => _$ImageFeedItemToJson(this);
}

@JsonSerializable()
class ImageFeedItemInstagram {
  ImageFeedItemInstagram(
    this.accountId,
    this.mediaId,
    this.link,
    this.type,
    this.caption,
    this.userId,
    this.username,
  );

  String accountId;
  String mediaId;
  String link;

  String type;
  String caption;

  String userId;
  String username;

  factory ImageFeedItemInstagram.fromJson(Map<String, dynamic> json) =>
      _$ImageFeedItemInstagramFromJson(json);

  Map<String, dynamic> toJson() => _$ImageFeedItemInstagramToJson(this);
}
