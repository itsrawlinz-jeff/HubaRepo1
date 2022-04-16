import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'UserUserProfileReqJModel.g.dart';

@JsonSerializable()
class UserUserProfileReqJModel {
  int id;
  DateTime createdate;
  DateTime txndate;
  bool approved;
  DateTime approveddate;
  bool active;
  String picture;
  bool isprofilepicture;
  int createdby;
  int approvedby;
  int users;
  String localfilepath;
  String imagename;
  bool issettobeupdated;

  UserUserProfileReqJModel() {}
  factory UserUserProfileReqJModel.fromJson(Map<String, dynamic> json) =>
      _$UserUserProfileReqJModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserUserProfileReqJModelToJson(this);
}
