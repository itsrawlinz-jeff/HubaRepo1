
import 'package:dating_app/Models/JsonSerializable/Api/from/gender/GenderRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'GenderListRespModel.g.dart';

@JsonSerializable()
class GenderListRespModel {
  int count;
  String next;
  String previous;
  List<GenderRespModel> results;

  GenderListRespModel() {}
  factory GenderListRespModel.fromJson(Map<String, dynamic> json) =>
      _$GenderListRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$GenderListRespModelToJson(this);
}
