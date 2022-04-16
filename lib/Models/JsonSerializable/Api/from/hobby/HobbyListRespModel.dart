
import 'package:dating_app/Models/JsonSerializable/Api/from/hobby/HobbyRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'HobbyListRespModel.g.dart';

@JsonSerializable()
class HobbyListRespModel {
  int count;
  String next;
  String previous;
  List<HobbyRespModel> results;

  HobbyListRespModel() {}
  factory HobbyListRespModel.fromJson(Map<String, dynamic> json) =>
      _$HobbyListRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$HobbyListRespModelToJson(this);
}
