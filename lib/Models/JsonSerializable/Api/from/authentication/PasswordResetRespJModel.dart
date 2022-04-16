import 'package:json_annotation/json_annotation.dart';
part 'PasswordResetRespJModel.g.dart';

@JsonSerializable()
class PasswordResetRespJModel {
  String message;
  String phone_number;
  String email;
  String otp;
  String password;
  String confirm_password;

  PasswordResetRespJModel() {}
  factory PasswordResetRespJModel.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$PasswordResetRespJModelToJson(this);
}
