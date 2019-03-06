import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:munch_app/api/file_api.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:uuid/uuid.dart';

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

  @JsonKey(ignore: true)
  String get slug {
    String slug = (title ?? "").toLowerCase();
    slug = slug.replaceAll(RegExp(r' '), '-');
    slug = slug.replaceAll(RegExp(r'[^0-9a-z-]'), '');
    return slug;
  }

  static const Map<String, String> _b2d = {
    'A': '.',
    'B': '0',
    'C': '1',
    'D': '2',
    'E': '3',
    'F': '4',
    'G': '5',
    'H': '6',
    'I': '7',
    'J': '8',
    'K': '9',
    'L': 'A',
    'M': 'B',
    'N': 'C',
    'O': 'D',
    'P': 'E',
    'Q': 'F',
    'R': 'G',
    'S': 'H',
    'T': 'I',
    'U': 'J',
    'V': 'K',
    'W': 'L',
    'X': 'M',
    'Y': 'N',
    'Z': 'O',
    'a': 'P',
    'b': 'Q',
    'c': 'R',
    'd': 'S',
    'e': 'T',
    'f': 'U',
    'g': 'V',
    'h': 'W',
    'i': 'X',
    'j': 'Y',
    'k': 'Z',
    'l': '_',
    'm': 'a',
    'n': 'b',
    'o': 'c',
    'p': 'd',
    'q': 'e',
    'r': 'f',
    's': 'g',
    't': 'h',
    'u': 'i',
    'v': 'j',
    'w': 'k',
    'x': 'l',
    'y': 'm',
    'z': 'n',
    '0': 'o',
    '1': 'p',
    '2': 'q',
    '3': 'r',
    '4': 's',
    '5': 't',
    '6': 'u',
    '7': 'v',
    '8': 'w',
    '9': 'x',
    '+': 'y',
    '/': 'z',
  };

  static final _uuid = Uuid();

  @JsonKey(ignore: true)
  String get cid {
    final b64 = base64.encode(_uuid.parse(contentId));
    return b64.split("").map((b64) => _b2d[b64]).where((t) => t != null).join("");
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
