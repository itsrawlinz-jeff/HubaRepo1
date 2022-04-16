import 'package:json_annotation/json_annotation.dart';

part 'NotificationRespJModel.g.dart';

@JsonSerializable()
class NotificationRespJModel {
  int id;
  bool read;
  String action;
  String message;
  DateTime created_at;

  NotificationRespJModel() {}
  factory NotificationRespJModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationRespJModelToJson(this);
}
