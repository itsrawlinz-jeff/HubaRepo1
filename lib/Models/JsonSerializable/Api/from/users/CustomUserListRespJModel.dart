import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'CustomUserListRespJModel.g.dart';

@JsonSerializable()
class CustomUserListRespJModel {
  int count;
  String next;
  String previous;
  List<CustomUserRespJModel> results;

  CustomUserListRespJModel() {}
  factory CustomUserListRespJModel.fromJson(Map<String, dynamic> json) =>
      _$CustomUserListRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$CustomUserListRespJModelToJson(this);
}
