import 'package:json_annotation/json_annotation.dart';
part 'UserSignUpRespModel.g.dart';

@JsonSerializable()
class UserSignUpRespModel {
  
  int id;
  String username;
  String password;
  String email;
  String message;
  bool success;
  String birthday;
  String quote;

  UserSignUpRespModel() {}
  UserSignUpRespModel.fromUsername(this.username) {}
  factory UserSignUpRespModel.fromJson(Map<String, dynamic> json) =>
      _$UserSignUpRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserSignUpRespModelToJson(this);
}
