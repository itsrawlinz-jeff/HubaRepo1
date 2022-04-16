import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'ProfileImageUIJModel.g.dart';

@JsonSerializable()
class ProfileImageUIJModel {
  int id;
  DateTime pickeddate;
  String onlineurl;
  String localfilepath;
  String imagename;

  ProfileImageUIJModel() {}
  factory ProfileImageUIJModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileImageUIJModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileImageUIJModelToJson(this);
}
