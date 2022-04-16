
import 'package:json_annotation/json_annotation.dart';
part 'ErrorRespJModel.g.dart';

@JsonSerializable()
class ErrorRespJModel {
  ErrorRespJModel errors;
  List<String>error;
  List<String> password;


  ErrorRespJModel() {}
  factory ErrorRespJModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorRespJModelToJson(this);
}
