import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'DrinkStatusRespModel.g.dart';

@JsonSerializable()
class DrinkStatusRespModel {
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

  DrinkStatusRespModel() {}
  DrinkStatusRespModel.fromName(this.name) {}
  factory DrinkStatusRespModel.fromJson(Map<String, dynamic> json) =>
      _$DrinkStatusRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$DrinkStatusRespModelToJson(this);
}
