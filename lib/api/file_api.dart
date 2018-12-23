import 'package:json_annotation/json_annotation.dart';

part 'file_api.g.dart';

@JsonSerializable()
class Image {
  Image(this.imageId, this.sizes);

  String imageId;
  List<ImageSize> sizes;

  @JsonKey(ignore: true)
  ImageSize get maxSize {
    return sizes.reduce((a, b) {
      return a.width.compareTo(b.width) >= 0 ? a : b;
    });
  }

  @JsonKey(ignore: true)
  double get aspectRatio {
    final max = maxSize;
    return max.width.toDouble() / max.height.toDouble();
  }

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);
}

@JsonSerializable()
class ImageSize {
  ImageSize(this.url, this.width, this.height);

  String url;
  int width;
  int height;

  @JsonKey(ignore: true)
  double get heightMultiplier => height.toDouble() / width.toDouble();

  factory ImageSize.fromJson(Map<String, dynamic> json) => _$ImageSizeFromJson(json);

  Map<String, dynamic> toJson() => _$ImageSizeToJson(this);
}
