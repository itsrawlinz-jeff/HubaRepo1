import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'MessageRespJModel.g.dart';

@JsonSerializable()
class MessageRespJModel {
  int id;
  bool read;
  CustomUserRespJModel author;
  DateTime created_at;
  CustomUserRespJModel receiver;
  String content;


  MessageRespJModel() {}
  factory MessageRespJModel.fromJson(
      Map<String, dynamic> json) =>
      _$MessageRespJModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$MessageRespJModelToJson(this);
}
