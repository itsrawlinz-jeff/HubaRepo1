import 'package:json_annotation/json_annotation.dart';
part 'FbLoginRespModel.g.dart';

@JsonSerializable()
class FbLoginRespModel {

  String token;
  String name;
  String first_name;
  String last_name;
  String email;
  String id;
  String local_filedownloaddir;
  String local_filename;
  String online_filepath;
  String phoneNumber;

  FbLoginRespModel() {}
  FbLoginRespModel.fromId(this.id) {}
  factory FbLoginRespModel.fromJson(Map<String, dynamic> json) =>
      _$FbLoginRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$FbLoginRespModelToJson(this);
}
