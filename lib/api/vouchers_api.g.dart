// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vouchers_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Voucher _$VoucherFromJson(Map<String, dynamic> json) {
  return Voucher(
      voucherId: json['voucherId'] as String,
      image: json['image'] == null
          ? null
          : Image.fromJson(json['image'] as Map<String, dynamic>),
      description: json['description'] as String,
      terms: (json['terms'] as List)?.map((e) => e as String)?.toList(),
      remaining: json['remaining'] as int,
      claimed: json['claimed'] as bool,
      recordId: json['recordId'] as String);
}

Map<String, dynamic> _$VoucherToJson(Voucher instance) => <String, dynamic>{
      'voucherId': instance.voucherId,
      'image': instance.image,
      'description': instance.description,
      'terms': instance.terms,
      'remaining': instance.remaining,
      'claimed': instance.claimed,
      'recordId': instance.recordId
    };
