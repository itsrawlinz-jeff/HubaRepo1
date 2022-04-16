import 'package:json_annotation/json_annotation.dart';
part 'OnboardingMoneyshemakeReqJModel.g.dart';

@JsonSerializable()
class OnboardingMoneyshemakeReqJModel {
  int createdby;
  int approvedby;
  int user;
  bool approved;
  DateTime approveddate;
  bool active;
  int income_range;

  OnboardingMoneyshemakeReqJModel() {}
  factory OnboardingMoneyshemakeReqJModel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingMoneyshemakeReqJModelFromJson(json);
  Map<String, dynamic> toJson() => _$OnboardingMoneyshemakeReqJModelToJson(this);
}
