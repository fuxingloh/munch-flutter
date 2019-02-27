// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatorSeries _$CreatorSeriesFromJson(Map<String, dynamic> json) {
  return CreatorSeries(
      creatorId: json['creatorId'] as String,
      seriesId: json['seriesId'] as String,
      sortId: json['sortId'] as String,
      status:
          _$enumDecodeNullable(_$CreatorSeriesStatusEnumMap, json['status']),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      body: json['body'] as String,
      image: json['image'] == null
          ? null
          : Image.fromJson(json['image'] as Map<String, dynamic>),
      tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
      createdMillis: json['createdMillis'] as int,
      updatedMillis: json['updatedMillis'] as int);
}

Map<String, dynamic> _$CreatorSeriesToJson(CreatorSeries instance) =>
    <String, dynamic>{
      'creatorId': instance.creatorId,
      'seriesId': instance.seriesId,
      'sortId': instance.sortId,
      'status': _$CreatorSeriesStatusEnumMap[instance.status],
      'title': instance.title,
      'subtitle': instance.subtitle,
      'body': instance.body,
      'image': instance.image,
      'tags': instance.tags,
      'createdMillis': instance.createdMillis,
      'updatedMillis': instance.updatedMillis
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

const _$CreatorSeriesStatusEnumMap = <CreatorSeriesStatus, dynamic>{
  CreatorSeriesStatus.draft: 'draft',
  CreatorSeriesStatus.published: 'published',
  CreatorSeriesStatus.archived: 'archived'
};

CreatorContent _$CreatorContentFromJson(Map<String, dynamic> json) {
  return CreatorContent(
      creatorId: json['creatorId'] as String,
      contentId: json['contentId'] as String,
      sortId: json['sortId'] as String,
      status:
          _$enumDecodeNullable(_$CreatorSeriesStatusEnumMap, json['status']),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      body: json['body'] as String,
      image: json['image'] == null
          ? null
          : Image.fromJson(json['image'] as Map<String, dynamic>),
      tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
      platform: json['platform'] as String,
      createdMillis: json['createdMillis'] as int,
      updatedMillis: json['updatedMillis'] as int);
}

Map<String, dynamic> _$CreatorContentToJson(CreatorContent instance) =>
    <String, dynamic>{
      'creatorId': instance.creatorId,
      'contentId': instance.contentId,
      'sortId': instance.sortId,
      'status': _$CreatorSeriesStatusEnumMap[instance.status],
      'title': instance.title,
      'subtitle': instance.subtitle,
      'body': instance.body,
      'image': instance.image,
      'tags': instance.tags,
      'platform': instance.platform,
      'createdMillis': instance.createdMillis,
      'updatedMillis': instance.updatedMillis
    };

CreatorContentItem _$CreatorContentItemFromJson(Map<String, dynamic> json) {
  return CreatorContentItem(
      contentId: json['contentId'] as String,
      itemId: json['itemId'] as String,
      type: json['type'] as String,
      body: json['body'] as Map<String, dynamic>,
      linkedId: json['linkedId'] as String,
      linkedSort: json['linkedSort'] as String);
}

Map<String, dynamic> _$CreatorContentItemToJson(CreatorContentItem instance) =>
    <String, dynamic>{
      'contentId': instance.contentId,
      'itemId': instance.itemId,
      'type': instance.type,
      'body': instance.body,
      'linkedId': instance.linkedId,
      'linkedSort': instance.linkedSort
    };
