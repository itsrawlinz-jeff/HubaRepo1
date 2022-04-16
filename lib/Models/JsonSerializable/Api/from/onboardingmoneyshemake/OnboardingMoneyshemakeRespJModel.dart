import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'OnboardingMoneyshemakeRespJModel.g.dart';

@JsonSerializable()
class OnboardingMoneyshemakeRespJModel {
  int id;
  OnboardingMoneyshemakeRespJModel() {}
  factory OnboardingMoneyshemakeRespJModel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingMoneyshemakeRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$OnboardingMoneyshemakeRespJModelToJson(this);
}
