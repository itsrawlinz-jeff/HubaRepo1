import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'HobbyRespModel.g.dart';

@JsonSerializable()
class HobbyRespModel {
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

  HobbyRespModel() {}
  HobbyRespModel.fromName(this.name) {}
  factory HobbyRespModel.fromJson(Map<String, dynamic> json) =>
      _$HobbyRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$HobbyRespModelToJson(this);
}
