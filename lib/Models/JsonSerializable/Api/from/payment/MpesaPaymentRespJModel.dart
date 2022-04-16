import 'package:dating_app/Models/JsonSerializable/Api/from/payment/MpesactobcallbackRespJModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'MpesaPaymentRespJModel.g.dart';

@JsonSerializable()
class MpesaPaymentRespJModel {
  bool is_found;
  bool already_used;
  MpesactobcallbackRespJModel mpesa_payment;

  MpesaPaymentRespJModel() {}
  factory MpesaPaymentRespJModel.fromJson(Map<String, dynamic> json) =>
      _$MpesaPaymentRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$MpesaPaymentRespJModelToJson(this);
}
