
import 'package:json_annotation/json_annotation.dart';
part 'OnboardingsomethingspecificReqJModel.g.dart';

@JsonSerializable()
class OnboardingsomethingspecificReqJModel {
  int onlineid;
  int onboardingid;
  int somethingspecificid;

  OnboardingsomethingspecificReqJModel() {}
  factory OnboardingsomethingspecificReqJModel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingsomethingspecificReqJModelFromJson(json);
  Map<String, dynamic> toJson() => _$OnboardingsomethingspecificReqJModelToJson(this);
}
