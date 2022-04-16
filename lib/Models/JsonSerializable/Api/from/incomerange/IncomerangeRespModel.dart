
import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'IncomerangeRespModel.g.dart';

@JsonSerializable()
class IncomerangeRespModel {
  int id;
  String createdate;
  String txndate;
  bool approved;
  String approveddate;
  bool active;
  double lowerlimit;
  double upperlimit;
  int createdby;
  int approvedby;
  String name;

  List<UserProfileRespModel> usersProfile;

  IncomerangeRespModel() {}
  IncomerangeRespModel.fromName(this.lowerlimit) {}
  factory IncomerangeRespModel.fromJson(Map<String, dynamic> json) =>
      _$IncomerangeRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$IncomerangeRespModelToJson(this);
}
