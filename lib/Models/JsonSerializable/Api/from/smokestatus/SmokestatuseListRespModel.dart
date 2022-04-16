
import 'package:dating_app/Models/JsonSerializable/Api/from/smokestatus/SmokestatuseRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'SmokestatuseListRespModel.g.dart';

@JsonSerializable()
class SmokestatuseListRespModel {
  int count;
  String next;
  String previous;
  List<SmokestatuseRespModel> results;

  SmokestatuseListRespModel() {}
  factory SmokestatuseListRespModel.fromJson(Map<String, dynamic> json) =>
      _$SmokestatuseListRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$SmokestatuseListRespModelToJson(this);
}
