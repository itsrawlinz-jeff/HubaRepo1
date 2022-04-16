import 'package:dating_app/Models/JsonSerializable/Api/from/match_modes/DateMatchModeRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/RoleRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/user_profiles/UserUserProfileReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'CustomUserRespJModel.g.dart';

@JsonSerializable()
class CustomUserRespJModel {
  int id;
  String name;
  String first_name;
  String last_name;
  String email;
  String username;
  String phone_number;
  RoleRespJModel role;
  String picture;
  List<UserUserProfileReqJModel> userprofiles;
  DateTime createdate;
  DateTime txndate;
  CustomUserRespJModel createdby;
  bool approved;
  String quote;
  int age;
  String fb_link;
  String insta_link;
  DateMatchModeRespJModel date_match_mode;

  CustomUserRespJModel() {}
  factory CustomUserRespJModel.fromJson(Map<String, dynamic> json) =>
      _$CustomUserRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$CustomUserRespJModelToJson(this);
}
