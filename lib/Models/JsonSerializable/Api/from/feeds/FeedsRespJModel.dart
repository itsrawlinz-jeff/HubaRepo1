import 'package:dating_app/Models/JsonSerializable/Api/from/feeds/FeedsImagesRespJModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'FeedsRespJModel.g.dart';

@JsonSerializable()
class FeedsRespJModel {
  int id;
  DateTime created_at;
  String txndate;
  int createdby;
  bool approved;
  int approvedby;
  String approveddate;
  bool active;
  String description;
  bool foreveryone;
  String message;
  int feeds_type;
  List<FeedsImagesRespJModel> feeds_images;
  int userid;
  bool success;

  FeedsRespJModel() {}
  factory FeedsRespJModel.fromJson(Map<String, dynamic> json) =>
      _$FeedsRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$FeedsRespJModelToJson(this);
}
