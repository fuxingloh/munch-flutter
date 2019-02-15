// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NamedLocation _$NamedLocationFromJson(Map<String, dynamic> json) {
  return NamedLocation(
      name: json['name'] as String, latLng: json['latLng'] as String);
}

Map<String, dynamic> _$NamedLocationToJson(NamedLocation instance) =>
    <String, dynamic>{'name': instance.name, 'latLng': instance.latLng};
