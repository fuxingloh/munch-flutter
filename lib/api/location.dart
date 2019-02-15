import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class NamedLocation {
  String name;
  String latLng;

  NamedLocation({this.name, this.latLng});

  static List<NamedLocation> fromJsonList(List<dynamic> list) {
    return list.map((map) => NamedLocation.fromJson(map)).toList(growable: false);
  }

  factory NamedLocation.fromJson(Map<String, dynamic> json) => _$NamedLocationFromJson(json);

  Map<String, dynamic> toJson() => _$NamedLocationToJson(this);
}
