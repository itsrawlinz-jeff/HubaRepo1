import 'package:json_annotation/json_annotation.dart';
part 'UserNameValidationReqJModel.g.dart';

@JsonSerializable()
class UserNameValidationReqJModel {
  String validation_text;

  UserNameValidationReqJModel() {}
  factory UserNameValidationReqJModel.fromJson(Map<String, dynamic> json) =>
      _$UserNameValidationReqJModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserNameValidationReqJModelToJson(this);
}
