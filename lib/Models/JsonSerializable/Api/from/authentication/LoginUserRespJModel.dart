import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'LoginUserRespJModel.g.dart';

@JsonSerializable()
class LoginUserRespJModel {
  LoginRespModel user;

  LoginUserRespJModel() {}
  factory LoginUserRespJModel.fromJson(Map<String, dynamic> json) =>
      _$LoginUserRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginUserRespJModelToJson(this);
}
