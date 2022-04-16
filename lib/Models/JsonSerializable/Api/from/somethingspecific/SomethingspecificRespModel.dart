import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'SomethingspecificRespModel.g.dart';

@JsonSerializable()
class SomethingspecificRespModel {
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

  SomethingspecificRespModel() {}
  SomethingspecificRespModel.fromName(this.name) {}
  factory SomethingspecificRespModel.fromJson(Map<String, dynamic> json) =>
      _$SomethingspecificRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$SomethingspecificRespModelToJson(this);
}
