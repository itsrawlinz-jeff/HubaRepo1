import 'package:dating_app/Models/JsonSerializable/Api/from/educationlevel/EducationlevelRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'EducationlevelListRespModel.g.dart';

@JsonSerializable()
class EducationlevelListRespModel {
  int count;
  String next;
  String previous;
  List<EducationlevelRespModel> results;

  EducationlevelListRespModel() {}
  factory EducationlevelListRespModel.fromJson(Map<String, dynamic> json) =>
      _$EducationlevelListRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$EducationlevelListRespModelToJson(this);
}
