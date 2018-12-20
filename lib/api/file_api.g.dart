// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Image _$ImageFromJson(Map<String, dynamic> json) {
  return Image(
      json['imageId'] as String,
      (json['sizes'] as List)
          ?.map((e) =>
              e == null ? null : ImageSize.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ImageToJson(Image instance) =>
    <String, dynamic>{'imageId': instance.imageId, 'sizes': instance.sizes};

ImageSize _$ImageSizeFromJson(Map<String, dynamic> json) {
  return ImageSize(
      json['url'] as String, json['width'] as int, json['height'] as int);
}

Map<String, dynamic> _$ImageSizeToJson(ImageSize instance) => <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height
    };
