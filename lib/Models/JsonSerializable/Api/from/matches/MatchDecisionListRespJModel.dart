import 'package:dating_app/Models/JsonSerializable/Api/from/matches/MatchDecisionRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'MatchDecisionListRespJModel.g.dart';

@JsonSerializable()
class MatchDecisionListRespJModel {
  int count;
  String next;
  String previous;
  List<MatchDecisionRespJModel> results;

  MatchDecisionListRespJModel() {}
  factory MatchDecisionListRespJModel.fromJson(Map<String, dynamic> json) =>
      _$MatchDecisionListRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$MatchDecisionListRespJModelToJson(this);
}
