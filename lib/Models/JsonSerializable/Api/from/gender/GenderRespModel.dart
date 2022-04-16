import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'GenderRespModel.g.dart';

@JsonSerializable()
class GenderRespModel {
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

  GenderRespModel() {}
  GenderRespModel.fromName(this.name) {}
  factory GenderRespModel.fromJson(Map<String, dynamic> json) =>
      _$GenderRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$GenderRespModelToJson(this);
}
