import 'package:json_annotation/json_annotation.dart';
part 'OnboardingUserIllnessReqJModel.g.dart';

@JsonSerializable()
class OnboardingUserIllnessReqJModel {
  int created_by;
  int approvedby;
  int user;
  bool approved;
  DateTime approveddate;
  bool active;
  int illness;

  OnboardingUserIllnessReqJModel() {}
  factory OnboardingUserIllnessReqJModel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingUserIllnessReqJModelFromJson(json);
  Map<String, dynamic> toJson() => _$OnboardingUserIllnessReqJModelToJson(this);
}
