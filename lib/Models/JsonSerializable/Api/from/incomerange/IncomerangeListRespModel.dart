import 'package:dating_app/Models/JsonSerializable/Api/from/incomerange/IncomerangeRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'IncomerangeListRespModel.g.dart';

@JsonSerializable()
class IncomerangeListRespModel {
  int count;
  String next;
  String previous;
  List<IncomerangeRespModel> results;

  IncomerangeListRespModel() {}
  factory IncomerangeListRespModel.fromJson(Map<String, dynamic> json) =>
      _$IncomerangeListRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$IncomerangeListRespModelToJson(this);
}
