import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'RelStatusRespModel.g.dart';

@JsonSerializable()
class RelStatusRespModel {
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

  RelStatusRespModel() {}
  RelStatusRespModel.fromName(this.name) {}
  factory RelStatusRespModel.fromJson(Map<String, dynamic> json) =>
      _$RelStatusRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$RelStatusRespModelToJson(this);
}
