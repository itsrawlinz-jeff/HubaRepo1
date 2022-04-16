import 'package:json_annotation/json_annotation.dart';
part 'OnboardingSomethingspecificReqJModel.g.dart';

@JsonSerializable()
class OnboardingSomethingspecificReqJModel {
  int createdby;
  int approvedby;
  int user;
  bool approved;
  DateTime approveddate;
  bool active;
  int something_specific;

  OnboardingSomethingspecificReqJModel() {}
  factory OnboardingSomethingspecificReqJModel.fromJson(
          Map<String, dynamic> json) =>
      _$OnboardingSomethingspecificReqJModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$OnboardingSomethingspecificReqJModelToJson(this);
}
