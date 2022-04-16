import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'ReligionRespModel.g.dart';

@JsonSerializable()
class ReligionRespModel {
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

  ReligionRespModel() {}
  ReligionRespModel.fromName(this.name) {}
  factory ReligionRespModel.fromJson(Map<String, dynamic> json) =>
      _$ReligionRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReligionRespModelToJson(this);
}
