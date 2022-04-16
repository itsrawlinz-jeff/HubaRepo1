import 'package:json_annotation/json_annotation.dart';
part 'OnboardingUserillnessRespJModel.g.dart';

@JsonSerializable()
class OnboardingUserillnessRespJModel {
  int id;
  OnboardingUserillnessRespJModel() {}
  factory OnboardingUserillnessRespJModel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingUserillnessRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$OnboardingUserillnessRespJModelToJson(this);
}
