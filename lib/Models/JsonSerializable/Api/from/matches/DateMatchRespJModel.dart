import 'package:dating_app/Models/JsonSerializable/Api/from/gender/GenderRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/MatchDecisionRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/messages/MessageRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/payment/MpesactobcallbackRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'DateMatchRespJModel.g.dart';

@JsonSerializable()
class DateMatchRespJModel {
  int id;
  CustomUserRespJModel createdby;
  DateTime createdate;
  DateTime txndate;
  bool active;
  bool isuserrequested;
  bool approved;
  DateTime approveddate;
  CustomUserRespJModel matching_user;
  CustomUserRespJModel match_to;
  CustomUserRespJModel approvedby;
  GenderRespModel interestedin;
  MatchDecisionRespJModel decision;
  int age_low;
  int age_high;
  String fb_insta_link;

  int unread_messages_no;
  MessageRespJModel last_message;

  MpesactobcallbackRespJModel mpesa_payment;

  DateMatchRespJModel() {}
  factory DateMatchRespJModel.fromJson(Map<String, dynamic> json) =>
      _$DateMatchRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$DateMatchRespJModelToJson(this);
}
