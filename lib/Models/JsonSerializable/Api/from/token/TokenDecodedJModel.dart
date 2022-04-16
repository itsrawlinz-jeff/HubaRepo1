
import 'package:json_annotation/json_annotation.dart';
part 'TokenDecodedJModel.g.dart';

@JsonSerializable()
class TokenDecodedJModel {
  int id;
  String email;
  String username;
  int role;
  String role_name;
  double exp;
  String session_id;

  TokenDecodedJModel() {}
  TokenDecodedJModel.fromId(this.id) {}
  factory TokenDecodedJModel.fromJson(Map<String, dynamic> json) =>
      _$TokenDecodedJModelFromJson(json);
  Map<String, dynamic> toJson() => _$TokenDecodedJModelToJson(this);
}
