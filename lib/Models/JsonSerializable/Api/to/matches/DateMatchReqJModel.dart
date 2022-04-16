import 'package:json_annotation/json_annotation.dart';
part 'DateMatchReqJModel.g.dart';

@JsonSerializable()
class DateMatchReqJModel {
  int id;
  int createdby;
  int approvedby;
  int matching_user;
  int match_to;
  int decision;
  bool active;
  bool isuserrequested;
  //DateTime createdate;
  String createdate;
  DateTime txndate;
  int interestedin;
  int age_low;
  int age_high;
  String fb_insta_link;
  bool approved;
  DateTime approveddate;
  String mpesa_code;
  int mpesa_payment;

  DateMatchReqJModel() {}
  factory DateMatchReqJModel.fromJson(Map<String, dynamic> json) =>
      _$DateMatchReqJModelFromJson(json);
  Map<String, dynamic> toJson() => _$DateMatchReqJModelToJson(this);
}
