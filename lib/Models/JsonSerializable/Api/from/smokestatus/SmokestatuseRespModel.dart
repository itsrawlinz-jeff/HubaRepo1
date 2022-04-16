import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'SmokestatuseRespModel.g.dart';

@JsonSerializable()
class SmokestatuseRespModel {
  int id;
  String createdate;
  String txndate;
  bool approved;
  String approveddate;
  bool active;
  String name;
  int createdby;
  int approvedby;

  List<UserProfileRespModel> usersProfile;

  SmokestatuseRespModel() {}
  SmokestatuseRespModel.fromName(this.name) {}
  factory SmokestatuseRespModel.fromJson(Map<String, dynamic> json) =>
      _$SmokestatuseRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$SmokestatuseRespModelToJson(this);
}
