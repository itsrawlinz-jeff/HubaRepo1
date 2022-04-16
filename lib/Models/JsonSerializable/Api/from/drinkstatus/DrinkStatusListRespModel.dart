import 'package:dating_app/Models/JsonSerializable/Api/from/drinkstatus/DrinkStatusRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'DrinkStatusListRespModel.g.dart';

@JsonSerializable()
class DrinkStatusListRespModel {
  int count;
  String next;
  String previous;
  List<DrinkStatusRespModel> results;

  DrinkStatusListRespModel() {}
  factory DrinkStatusListRespModel.fromJson(Map<String, dynamic> json) =>
      _$DrinkStatusListRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$DrinkStatusListRespModelToJson(this);
}
