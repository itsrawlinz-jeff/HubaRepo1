import 'package:dating_app/Models/JsonSerializable/Api/from/relationshipstatus/RelStatusRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'RelStatusListRespModel.g.dart';

@JsonSerializable()
class RelStatusListRespModel {
  int count;
  String next;
  String previous;
  List<RelStatusRespModel> results;

  RelStatusListRespModel() {}
  factory RelStatusListRespModel.fromJson(Map<String, dynamic> json) =>
      _$RelStatusListRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$RelStatusListRespModelToJson(this);
}
