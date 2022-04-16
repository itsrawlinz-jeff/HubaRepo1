import 'package:dating_app/Models/JsonSerializable/Api/from/messages/MessageRespJModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'SocketMessageListRespJModel.g.dart';

@JsonSerializable()
class SocketMessageListRespJModel {
  String status;
  String message;
  List<MessageRespJModel> messages;

  SocketMessageListRespJModel() {}
  factory SocketMessageListRespJModel.fromJson(Map<String, dynamic> json) =>
      _$SocketMessageListRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$SocketMessageListRespJModelToJson(this);
}
