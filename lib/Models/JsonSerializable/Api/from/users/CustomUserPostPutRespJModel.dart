import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'CustomUserPostPutRespJModel.g.dart';

@JsonSerializable()
class CustomUserPostPutRespJModel {
  int id;
  CustomUserPostPutRespJModel() {}
  factory CustomUserPostPutRespJModel.fromJson(Map<String, dynamic> json) =>
      _$CustomUserPostPutRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$CustomUserPostPutRespJModelToJson(this);
}
