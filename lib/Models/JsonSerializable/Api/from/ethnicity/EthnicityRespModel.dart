import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'EthnicityRespModel.g.dart';

@JsonSerializable()
class EthnicityRespModel {
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

  EthnicityRespModel() {}
  EthnicityRespModel.fromName(this.name) {}
  factory EthnicityRespModel.fromJson(Map<String, dynamic> json) =>
      _$EthnicityRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$EthnicityRespModelToJson(this);
}
