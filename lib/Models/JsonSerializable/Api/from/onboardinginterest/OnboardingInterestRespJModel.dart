import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'OnboardingInterestRespJModel.g.dart';

@JsonSerializable()
class OnboardingInterestRespJModel {
  int id;
  OnboardingInterestRespJModel() {}
  factory OnboardingInterestRespJModel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingInterestRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$OnboardingInterestRespJModelToJson(this);
}
