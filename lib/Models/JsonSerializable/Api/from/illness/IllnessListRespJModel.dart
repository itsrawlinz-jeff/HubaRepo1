import 'package:dating_app/Models/JsonSerializable/Api/from/illness/IllnessRespJModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'IllnessListRespJModel.g.dart';

@JsonSerializable()
class IllnessListRespJModel {
  int count;
  String next;
  String previous;
  List<IllnessRespJModel> results;

  IllnessListRespJModel() {}
  factory IllnessListRespJModel.fromJson(Map<String, dynamic> json) =>
      _$IllnessListRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$IllnessListRespJModelToJson(this);
}
