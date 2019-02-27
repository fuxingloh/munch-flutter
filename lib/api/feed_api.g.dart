// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedQuery _$FeedQueryFromJson(Map<String, dynamic> json) {
  return FeedQuery(
      location: json['location'] == null
          ? null
          : FeedQueryLocation.fromJson(
              json['location'] as Map<String, dynamic>));
}

Map<String, dynamic> _$FeedQueryToJson(FeedQuery instance) =>
    <String, dynamic>{'location': instance.location};

FeedQueryLocation _$FeedQueryLocationFromJson(Map<String, dynamic> json) {
  return FeedQueryLocation(latLng: json['latLng'] as String);
}

Map<String, dynamic> _$FeedQueryLocationToJson(FeedQueryLocation instance) =>
    <String, dynamic>{'latLng': instance.latLng};

FeedItem _$FeedItemFromJson(Map<String, dynamic> json) {
  return FeedItem(
      itemId: json['itemId'] as String,
      type: _$enumDecodeNullable(_$FeedItemTypeEnumMap, json['type']),
      sort: json['sort'] as String,
      country: json['country'] as String,
      latLng: json['latLng'] as String,
      author: json['author'] as String,
      title: json['title'] as String,
      places: (json['places'] as List)
          ?.map((e) =>
              e == null ? null : Place.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      createdMillis: json['createdMillis'] as int,
      image: json['image'] == null
          ? null
          : Image.fromJson(json['image'] as Map<String, dynamic>),
      instagram: json['instagram'] == null
          ? null
          : ImageFeedItemInstagram.fromJson(
              json['instagram'] as Map<String, dynamic>));
}

Map<String, dynamic> _$FeedItemToJson(FeedItem instance) => <String, dynamic>{
      'itemId': instance.itemId,
      'type': _$FeedItemTypeEnumMap[instance.type],
      'sort': instance.sort,
      'country': instance.country,
      'latLng': instance.latLng,
      'author': instance.author,
      'title': instance.title,
      'places': instance.places,
      'createdMillis': instance.createdMillis,
      'image': instance.image,
      'instagram': instance.instagram
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$FeedItemTypeEnumMap = <FeedItemType, dynamic>{
  FeedItemType.Article: 'Article',
  FeedItemType.InstagramMedia: 'InstagramMedia'
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
