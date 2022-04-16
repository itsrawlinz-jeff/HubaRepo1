
import 'package:dating_app/Models/JsonSerializable/Api/from/wantchildren/WantchildrenstatuseRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'WantchildrenstatuseListRespModel.g.dart';

@JsonSerializable()
class WantchildrenstatuseListRespModel {
  int count;
  String next;
  String previous;
  List<WantchildrenstatuseRespModel> results;

  WantchildrenstatuseListRespModel() {}
  factory WantchildrenstatuseListRespModel.fromJson(Map<String, dynamic> json) =>
      _$WantchildrenstatuseListRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$WantchildrenstatuseListRespModelToJson(this);
}
