import 'package:dating_app/Models/JsonSerializable/Api/from/match_modes/DateMatchModeRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/MatchDecisionRespJModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'DateMatchModeListRespJModel.g.dart';

@JsonSerializable()
class DateMatchModeListRespJModel {
  int count;
  String next;
  String previous;
  List<DateMatchModeRespJModel> results;

  DateMatchModeListRespJModel() {}
  factory DateMatchModeListRespJModel.fromJson(Map<String, dynamic> json) =>
      _$DateMatchModeListRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$DateMatchModeListRespJModelToJson(this);
}
