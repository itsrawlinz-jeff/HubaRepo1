import 'package:dating_app/Models/JsonSerializable/Api/from/feeds/FeedsImagesRespJModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'FeedsReqJModel.g.dart';

@JsonSerializable()
class FeedsReqJModel {
  int id;
  String createdate;
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
  List<FeedsImagesRespJModel> feedsImages;
  int userid;
  bool success;

  FeedsReqJModel() {}
  factory FeedsReqJModel.fromJson(Map<String, dynamic> json) =>
      _$FeedsReqJModelFromJson(json);
  Map<String, dynamic> toJson() => _$FeedsReqJModelToJson(this);
}
