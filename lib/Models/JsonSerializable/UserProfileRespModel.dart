import 'package:json_annotation/json_annotation.dart';
part 'UserProfileRespModel.g.dart';

@JsonSerializable()
class UserProfileRespModel {
  int id;
  String createdate;
  String txndate;
  bool approved;
  String approveddate;
  bool active;
  String picture;
  bool isprofilepicture;
  int createdby;
  int approvedby;
  int users;
  String localfilepath;
  String imagename;
  bool issettobeupdated;

  UserProfileRespModel() {}
  UserProfileRespModel.fromId(this.id) {}
  factory UserProfileRespModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileRespModelToJson(this);
}
