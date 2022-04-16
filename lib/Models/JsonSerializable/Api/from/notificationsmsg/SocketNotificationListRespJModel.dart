import 'package:dating_app/Models/JsonSerializable/Api/from/notificationsmsg/NotificationRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/notificationsmsg/SocketNotificationRespJModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'SocketNotificationListRespJModel.g.dart';

@JsonSerializable()
class SocketNotificationListRespJModel {
  String status;
  String message;
  int count;
  String next;
  String previous;
  List<SocketNotificationRespJModel> notifications;
  List<NotificationRespJModel> results;

  SocketNotificationListRespJModel() {}
  factory SocketNotificationListRespJModel.fromJson(
          Map<String, dynamic> json) =>
      _$SocketNotificationListRespJModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$SocketNotificationListRespJModelToJson(this);
}
