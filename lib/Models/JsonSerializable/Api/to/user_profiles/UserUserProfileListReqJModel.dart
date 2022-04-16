import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/user_profiles/UserUserProfileReqJModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'UserUserProfileListReqJModel.g.dart';

@JsonSerializable()
class UserUserProfileListReqJModel {
  int count;
  String next;
  String previous;
  List<UserUserProfileReqJModel> results;

  UserUserProfileListReqJModel() {}
  factory UserUserProfileListReqJModel.fromJson(Map<String, dynamic> json) =>
      _$UserUserProfileListReqJModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserUserProfileListReqJModelToJson(this);
}
