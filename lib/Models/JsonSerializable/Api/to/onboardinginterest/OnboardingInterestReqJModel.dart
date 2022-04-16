import 'package:json_annotation/json_annotation.dart';
part 'OnboardingInterestReqJModel.g.dart';

@JsonSerializable()
class OnboardingInterestReqJModel {
  int createdby;
  int approvedby;
  int user;
  bool approved;
  DateTime approveddate;
  bool active;
  int hobby;

  OnboardingInterestReqJModel() {}
  factory OnboardingInterestReqJModel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingInterestReqJModelFromJson(json);
  Map<String, dynamic> toJson() => _$OnboardingInterestReqJModelToJson(this);
}
