import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:munch_app/api/file_api.dart';
import 'package:munch_app/api/munch_data.dart';

part 'content_api.g.dart';

@JsonSerializable()
class CreatorSeries {
  String creatorId;
  String seriesId;
  String sortId;
  CreatorSeriesStatus status;

  String title;
  String subtitle;
  String body;

  Image image;
  List<String> tags;

  int createdMillis;
  int updatedMillis;

  CreatorSeries({
    this.creatorId,
    this.seriesId,
    this.sortId,
    this.status,
    this.title,
    this.subtitle,
    this.body,
    this.image,
    this.tags,
    this.createdMillis,
    this.updatedMillis,
  });

  factory CreatorSeries.fromJson(Map<String, dynamic> json) => _$CreatorSeriesFromJson(json);

  Map<String, dynamic> toJson() => _$CreatorSeriesToJson(this);

  static List<CreatorSeries> fromJsonList(List<dynamic> list) {
    return list.map((map) => CreatorSeries.fromJson(map)).toList(growable: false);
  }
}

enum CreatorSeriesStatus { draft, published, archived }

@JsonSerializable()
class CreatorContent {
  String creatorId;
  String contentId;
  String sortId;
  CreatorSeriesStatus status;

  String title;
  String subtitle;
  String body;

  Image image;
  List<String> tags;
  String platform;

  int createdMillis;
  int updatedMillis;

  CreatorContent({
    this.creatorId,
    this.contentId,
    this.sortId,
    this.status,
    this.title,
    this.subtitle,
    this.body,
    this.image,
    this.tags,
    this.platform,
    this.createdMillis,
    this.updatedMillis,
  });

  factory CreatorContent.fromJson(Map<String, dynamic> json) => _$CreatorContentFromJson(json);

  Map<String, dynamic> toJson() => _$CreatorContentToJson(this);

  static List<CreatorContent> fromJsonList(List<dynamic> list) {
    return list.map((map) => CreatorContent.fromJson(map)).toList(growable: false);
  }
}

enum CreatorContentStatus { draft, published, archived }

class CreatorContentItemType {
  static const place = "place";
  static const line = "line";
  static const image = "image";

  static const title = "title";
  static const h1 = "h1";
  static const h2 = "h2";
  static const text = "text";

  static const quote = "quote";
  static const html = "html";
}

@JsonSerializable()
class CreatorContentItem {
  String contentId;
  String itemId;

  String type;
  Map<String, dynamic> body;

  String linkedId;
  String linkedSort;

  CreatorContentItem({
    this.contentId,
    this.itemId,
    this.type,
    this.body,
    this.linkedId,
    this.linkedSort,
  });

  factory CreatorContentItem.fromJson(Map<String, dynamic> json) => _$CreatorContentItemFromJson(json);

  Map<String, dynamic> toJson() => _$CreatorContentItemToJson(this);

  static List<CreatorContentItem> fromJsonList(List<dynamic> list) {
    return list.map((map) => CreatorContentItem.fromJson(map)).toList(growable: false);
  }
}