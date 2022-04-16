import 'package:json_annotation/json_annotation.dart';

part 'SocketNotificationRespJModel.g.dart';

@JsonSerializable()
class SocketNotificationRespJModel {
  int id;
  bool read;
  String action;
  String message;

  SocketNotificationRespJModel() {}
  factory SocketNotificationRespJModel.fromJson(Map<String, dynamic> json) =>
      _$SocketNotificationRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$SocketNotificationRespJModelToJson(this);
}
