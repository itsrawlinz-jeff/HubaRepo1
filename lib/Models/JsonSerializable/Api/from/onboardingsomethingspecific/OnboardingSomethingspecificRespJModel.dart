import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'OnboardingSomethingspecificRespJModel.g.dart';

@JsonSerializable()
class OnboardingSomethingspecificRespJModel {
  int id;
  OnboardingSomethingspecificRespJModel() {}
  factory OnboardingSomethingspecificRespJModel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingSomethingspecificRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$OnboardingSomethingspecificRespJModelToJson(this);
}
