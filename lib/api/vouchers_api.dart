import 'package:json_annotation/json_annotation.dart';
import 'package:munch_app/api/file_api.dart';

part 'vouchers_api.g.dart';

@JsonSerializable()
class Voucher {
  String voucherId;

  Image image;
  String description;
  List<String> terms;

  int remaining;
  bool claimed;

  String recordId;

  Voucher({
    this.voucherId,
    this.image,
    this.description,
    this.terms,
    this.remaining,
    this.claimed,
    this.recordId,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) => _$VoucherFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherToJson(this);
}
