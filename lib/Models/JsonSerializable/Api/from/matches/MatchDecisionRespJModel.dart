import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'MatchDecisionRespJModel.g.dart';

@JsonSerializable()
class MatchDecisionRespJModel {
  int id;
  String name;
  DateTime created_at;
  DateTime updated_at;
  CustomUserRespJModel createdby;

  MatchDecisionRespJModel() {}
  factory MatchDecisionRespJModel.fromJson(Map<String, dynamic> json) =>
      _$MatchDecisionRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$MatchDecisionRespJModelToJson(this);
}
