import 'package:json_annotation/json_annotation.dart';
import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/file_api.dart';
import 'package:munch_app/api/munch_data.dart';

part 'feed_api.g.dart';

@JsonSerializable()
class FeedQuery {
  FeedQueryLocation location;

  FeedQuery({this.location});

  FeedQuery.created({String latLng}) {
    this.location = FeedQueryLocation(latLng: latLng);
  }

  factory FeedQuery.fromJson(Map<String, dynamic> json) => _$FeedQueryFromJson(json);

  Map<String, dynamic> toJson() => _$FeedQueryToJson(this);
}

@JsonSerializable()
class FeedQueryLocation {
  String latLng;

  FeedQueryLocation({this.latLng});

  factory FeedQueryLocation.fromJson(Map<String, dynamic> json) => _$FeedQueryLocationFromJson(json);

  Map<String, dynamic> toJson() => _$FeedQueryLocationToJson(this);
}

@JsonSerializable()
class FeedItem {
  FeedItem({
    this.itemId,
    this.type,
    this.sort,
    this.country,
    this.latLng,
    this.author,
    this.title,
    this.places,
    this.createdMillis,
    this.image,
    this.instagram,
  });

  String itemId;
  FeedItemType type;
  String sort;

  String country;
  String latLng;

  String author;
  String title;

  List<Place> places;
  int createdMillis;

  Image image;
  ImageFeedItemInstagram instagram;

  factory FeedItem.fromJson(Map<String, dynamic> json) => _$FeedItemFromJson(json);

  Map<String, dynamic> toJson() => _$FeedItemToJson(this);

  static List<FeedItem> fromJsonList(List<dynamic> list) {
    return list.map((map) => FeedItem.fromJson(map)).toList(growable: false);
  }

  static String getTypeName(FeedItem item) {
    var type = item.type;
    if (type == null) return null;

    return _$FeedItemTypeEnumMap[type];
  }
}

enum FeedItemType { Article, InstagramMedia }

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

  factory ImageFeedItemInstagram.fromJson(Map<String, dynamic> json) => _$ImageFeedItemInstagramFromJson(json);

  Map<String, dynamic> toJson() => _$ImageFeedItemInstagramToJson(this);
}
