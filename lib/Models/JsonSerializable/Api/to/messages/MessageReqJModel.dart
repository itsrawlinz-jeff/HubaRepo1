import 'package:json_annotation/json_annotation.dart';

part 'MessageReqJModel.g.dart';

@JsonSerializable()
class MessageReqJModel {
  int id;
  bool read;
  int author;
  DateTime created_at;
  int receiver;
  String content;

  MessageReqJModel() {}
  factory MessageReqJModel.fromJson(Map<String, dynamic> json) =>
      _$MessageReqJModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageReqJModelToJson(this);
}
