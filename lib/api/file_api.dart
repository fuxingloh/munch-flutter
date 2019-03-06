import 'package:json_annotation/json_annotation.dart';

part 'file_api.g.dart';

ImageSize maxSize(List<ImageSize> sizes) {
  return sizes.reduce((a, b) {
    return a.width.compareTo(b.width) >= 0 ? a : b;
  });
}

class CreditedImage {
  List<ImageSize> sizes;
  String name;
  String link;

  CreditedImage({this.sizes, this.name, this.link});

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
}

@JsonSerializable()
class Image {
  Image(this.imageId, this.profile, this.sizes);

  String imageId;
  ImageProfile profile;
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
class ImageProfile {
  String type;
  String id;
  String name;

  ImageProfile(this.type, this.id, this.name);

  factory ImageProfile.fromJson(Map<String, dynamic> json) => _$ImageProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ImageProfileToJson(this);
}

@JsonSerializable()
class ImageSize {
  ImageSize(this.url, this.width, this.height);

  String url;
  int width;
  int height;

  @JsonKey(ignore: true)
  double get aspectRatio {
    return width.toDouble() / height.toDouble();
  }

  factory ImageSize.fromJson(Map<String, dynamic> json) => _$ImageSizeFromJson(json);

  Map<String, dynamic> toJson() => _$ImageSizeToJson(this);
}
