import 'package:json_annotation/json_annotation.dart';
part 'RoleRespJModel.g.dart';

@JsonSerializable()
class RoleRespJModel {
  int id;
  String name;

  RoleRespJModel() {}
  factory RoleRespJModel.fromJson(Map<String, dynamic> json) =>
      _$RoleRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoleRespJModelToJson(this);
}
