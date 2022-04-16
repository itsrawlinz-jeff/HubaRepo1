import 'package:json_annotation/json_annotation.dart';
part 'MpesactobcallbackRespJModel.g.dart';

@JsonSerializable()
class MpesactobcallbackRespJModel {
  int id;
  String result_code;
  String result_desc;
  double amount;
  String mpesa_receipt_number;
  DateTime transaction_date;
  String phone_number;
  bool approved;
  DateTime approved_date;

  MpesactobcallbackRespJModel() {}
  factory MpesactobcallbackRespJModel.fromJson(Map<String, dynamic> json) =>
      _$MpesactobcallbackRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$MpesactobcallbackRespJModelToJson(this);
}
