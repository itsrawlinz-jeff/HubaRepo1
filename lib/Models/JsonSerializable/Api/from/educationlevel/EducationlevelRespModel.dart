import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'EducationlevelRespModel.g.dart';

@JsonSerializable()
class EducationlevelRespModel {
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

  EducationlevelRespModel() {}
  EducationlevelRespModel.fromName(this.name) {}
  factory EducationlevelRespModel.fromJson(Map<String, dynamic> json) =>
      _$EducationlevelRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$EducationlevelRespModelToJson(this);
}
