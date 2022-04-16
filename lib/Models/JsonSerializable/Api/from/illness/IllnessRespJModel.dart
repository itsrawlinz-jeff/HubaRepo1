import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'IllnessRespJModel.g.dart';

@JsonSerializable()
class IllnessRespJModel {
  int id;
  String createdate;
  String txndate;
  bool approved;
  String approveddate;
  bool active;
  String name;
  CustomUserRespJModel created_by;
  CustomUserRespJModel approvedby;

  IllnessRespJModel() {}
  IllnessRespJModel.fromName(this.name) {}
  factory IllnessRespJModel.fromJson(Map<String, dynamic> json) =>
      _$IllnessRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$IllnessRespJModelToJson(this);
}
