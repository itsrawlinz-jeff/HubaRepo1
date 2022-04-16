import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'WantchildrenstatuseRespModel.g.dart';

@JsonSerializable()
class WantchildrenstatuseRespModel {
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

  WantchildrenstatuseRespModel() {}
  WantchildrenstatuseRespModel.fromName(this.name) {}
  factory WantchildrenstatuseRespModel.fromJson(Map<String, dynamic> json) =>
      _$WantchildrenstatuseRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$WantchildrenstatuseRespModelToJson(this);
}
