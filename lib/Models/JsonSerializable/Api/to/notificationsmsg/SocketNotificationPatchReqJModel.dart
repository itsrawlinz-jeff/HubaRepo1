import 'package:json_annotation/json_annotation.dart';

part 'SocketNotificationPatchReqJModel.g.dart';

@JsonSerializable()
class SocketNotificationPatchReqJModel {
  bool read;
  SocketNotificationPatchReqJModel() {}
  factory SocketNotificationPatchReqJModel.fromJson(
      Map<String, dynamic> json) =>
      _$SocketNotificationPatchReqJModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$SocketNotificationPatchReqJModelToJson(this);
}
