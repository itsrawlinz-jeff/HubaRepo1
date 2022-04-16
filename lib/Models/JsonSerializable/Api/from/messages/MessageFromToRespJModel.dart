import 'package:json_annotation/json_annotation.dart';

part 'MessageFromToRespJModel.g.dart';

@JsonSerializable()
class MessageFromToRespJModel {
  int id;
  int onlineid;
  String email;
  String name;


  MessageFromToRespJModel() {}
  factory MessageFromToRespJModel.fromJson(
      Map<String, dynamic> json) =>
      _$MessageFromToRespJModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$MessageFromToRespJModelToJson(this);
}
