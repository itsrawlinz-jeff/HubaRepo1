import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'DateMatchModeRespJModel.g.dart';

@JsonSerializable()
class DateMatchModeRespJModel {
  int id;
  String name;
  DateTime created_at;
  DateTime updated_at;
  CustomUserRespJModel createdby;

  DateMatchModeRespJModel() {}
  factory DateMatchModeRespJModel.fromJson(Map<String, dynamic> json) =>
      _$DateMatchModeRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$DateMatchModeRespJModelToJson(this);
}
