import 'package:json_annotation/json_annotation.dart';
part 'HobbieReqJModel.g.dart';

@JsonSerializable()
class HobbieReqJModel {
  bool approved;
  DateTime approveddate;
  bool active;
  String name;
  int createdby;
  int approvedby;

  HobbieReqJModel() {}
  factory HobbieReqJModel.fromJson(Map<String, dynamic> json) =>
      _$HobbieReqJModelFromJson(json);
  Map<String, dynamic> toJson() => _$HobbieReqJModelToJson(this);
}
