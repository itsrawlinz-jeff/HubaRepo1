import 'package:dating_app/Models/JsonSerializable/Api/from/ethnicity/EthnicityRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'EthnicityListRespModel.g.dart';

@JsonSerializable()
class EthnicityListRespModel {
  int count;
  String next;
  String previous;
  List<EthnicityRespModel> results;

  EthnicityListRespModel() {}
  factory EthnicityListRespModel.fromJson(Map<String, dynamic> json) =>
      _$EthnicityListRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$EthnicityListRespModelToJson(this);
}
