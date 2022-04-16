import 'package:dating_app/Models/JsonSerializable/Api/to/user_profiles/UserUserProfileReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/ProfileImageUIJModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'IndexAndUserUserProfileReqJModel.g.dart';

@JsonSerializable()
class IndexAndUserUserProfileReqJModel {
  UserUserProfileReqJModel userUserProfileReqJModel;
  int index;
  String imagePath;

  IndexAndUserUserProfileReqJModel() {}
  factory IndexAndUserUserProfileReqJModel.fromJson(Map<String, dynamic> json) =>
      _$IndexAndUserUserProfileReqJModelFromJson(json);
  Map<String, dynamic> toJson() => _$IndexAndUserUserProfileReqJModelToJson(this);
}
