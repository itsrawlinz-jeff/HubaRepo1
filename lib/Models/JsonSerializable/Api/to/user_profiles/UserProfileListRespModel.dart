import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'UserProfileListRespModel.g.dart';

@JsonSerializable()
class UserProfileListRespModel {
  int count;
  String next;
  String previous;
  List<UserProfileRespModel> results;

  UserProfileListRespModel() {}
  factory UserProfileListRespModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileListRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileListRespModelToJson(this);
}
