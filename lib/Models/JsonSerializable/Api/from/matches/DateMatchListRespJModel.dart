import 'package:dating_app/Models/JsonSerializable/Api/from/matches/DateMatchRespJModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'DateMatchListRespJModel.g.dart';

@JsonSerializable()
class DateMatchListRespJModel {
  int count;
  String next;
  String previous;
  List<DateMatchRespJModel> results;

  DateMatchListRespJModel() {}
  factory DateMatchListRespJModel.fromJson(Map<String, dynamic> json) =>
      _$DateMatchListRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$DateMatchListRespJModelToJson(this);
}
