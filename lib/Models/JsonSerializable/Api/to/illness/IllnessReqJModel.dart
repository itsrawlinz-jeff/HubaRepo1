import 'package:json_annotation/json_annotation.dart';
part 'IllnessReqJModel.g.dart';

@JsonSerializable()
class IllnessReqJModel {
  String name;
  bool is_chronic;
  bool active;
  String createdate;
  DateTime txndate;
  bool approved;
  int approvedby;
  DateTime approveddate;

  IllnessReqJModel() {}
  factory IllnessReqJModel.fromJson(Map<String, dynamic> json) =>
      _$IllnessReqJModelFromJson(json);
  Map<String, dynamic> toJson() => _$IllnessReqJModelToJson(this);
}
