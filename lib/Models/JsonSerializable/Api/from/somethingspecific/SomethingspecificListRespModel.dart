import 'package:dating_app/Models/JsonSerializable/Api/from/somethingspecific/SomethingspecificRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'SomethingspecificListRespModel.g.dart';

@JsonSerializable()
class SomethingspecificListRespModel {
  int count;
  String next;
  String previous;
  List<SomethingspecificRespModel> results;

  SomethingspecificListRespModel() {}
  factory SomethingspecificListRespModel.fromJson(Map<String, dynamic> json) =>
      _$SomethingspecificListRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$SomethingspecificListRespModelToJson(this);
}
