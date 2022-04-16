import 'package:json_annotation/json_annotation.dart';
part 'DonationReqJModel.g.dart';

@JsonSerializable()
class DonationReqJModel {
 String phone_no;
 int amount;

  DonationReqJModel() {}
  factory DonationReqJModel.fromJson(Map<String, dynamic> json) =>
      _$DonationReqJModelFromJson(json);
  Map<String, dynamic> toJson() => _$DonationReqJModelToJson(this);
}
