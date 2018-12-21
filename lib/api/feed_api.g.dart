// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageFeedResult _$ImageFeedResultFromJson(Map<String, dynamic> json) {
  return ImageFeedResult(
      (json['items'] as List)
          ?.map((e) => e == null
              ? null
              : ImageFeedItem.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['places'] as Map<String, dynamic>)?.map((k, e) => MapEntry(
          k, e == null ? null : Place.fromJson(e as Map<String, dynamic>))));
}

Map<String, dynamic> _$ImageFeedResultToJson(ImageFeedResult instance) =>
    <String, dynamic>{'items': instance.items, 'places': instance.places};

ImageFeedItem _$ImageFeedItemFromJson(Map<String, dynamic> json) {
  return ImageFeedItem(
      json['itemId'] as String,
      json['sort'] as String,
      json['country'] as String,
      json['latLng'] as String,
      json['image'] == null
          ? null
          : Image.fromJson(json['image'] as Map<String, dynamic>),
      json['createdMillis'] as int,
      json['instagram'] == null
          ? null
          : ImageFeedItemInstagram.fromJson(
              json['instagram'] as Map<String, dynamic>),
      (json['places'] as List)
          ?.map((e) =>
              e == null ? null : Place.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ImageFeedItemToJson(ImageFeedItem instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'sort': instance.sort,
      'country': instance.country,
      'latLng': instance.latLng,
      'image': instance.image,
      'createdMillis': instance.createdMillis,
      'instagram': instance.instagram,
      'places': instance.places
    };

ImageFeedItemInstagram _$ImageFeedItemInstagramFromJson(
    Map<String, dynamic> json) {
  return ImageFeedItemInstagram(
      json['accountId'] as String,
      json['mediaId'] as String,
      json['link'] as String,
      json['type'] as String,
      json['caption'] as String,
      json['userId'] as String,
      json['username'] as String);
}

Map<String, dynamic> _$ImageFeedItemInstagramToJson(
        ImageFeedItemInstagram instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'mediaId': instance.mediaId,
      'link': instance.link,
      'type': instance.type,
      'caption': instance.caption,
      'userId': instance.userId,
      'username': instance.username
    };
