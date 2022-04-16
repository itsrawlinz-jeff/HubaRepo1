
import 'package:dating_app/Models/JsonSerializable/Api/from/religion/ReligionRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'ReligionListRespModel.g.dart';

@JsonSerializable()
class ReligionListRespModel {
  int count;
  String next;
  String previous;
  List<ReligionRespModel> results;

  ReligionListRespModel() {}
  factory ReligionListRespModel.fromJson(Map<String, dynamic> json) =>
      _$ReligionListRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReligionListRespModelToJson(this);
}
