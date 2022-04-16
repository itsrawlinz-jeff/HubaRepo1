import 'package:dating_app/Models/JsonSerializable/ProfileImageUIJModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'IndexAndProfileImageUIJModel.g.dart';

@JsonSerializable()
class IndexAndProfileImageUIJModel {
  ProfileImageUIJModel profileImageUIJModel;
  int index;
  String imagePath;

  IndexAndProfileImageUIJModel() {}
  factory IndexAndProfileImageUIJModel.fromJson(Map<String, dynamic> json) =>
      _$IndexAndProfileImageUIJModelFromJson(json);
  Map<String, dynamic> toJson() => _$IndexAndProfileImageUIJModelToJson(this);
}
