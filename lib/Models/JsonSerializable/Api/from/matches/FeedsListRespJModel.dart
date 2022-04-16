import 'package:dating_app/Models/JsonSerializable/Api/from/feeds/FeedsRespJModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'FeedsListRespJModel.g.dart';

@JsonSerializable()
class FeedsListRespJModel {
  int count;
  String next;
  String previous;
  List<FeedsRespJModel> results;

  FeedsListRespJModel() {}
  factory FeedsListRespJModel.fromJson(Map<String, dynamic> json) =>
      _$FeedsListRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$FeedsListRespJModelToJson(this);
}
