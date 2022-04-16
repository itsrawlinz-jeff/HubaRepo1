import 'package:json_annotation/json_annotation.dart';
part 'FeedsImagesRespJModel.g.dart';

@JsonSerializable()
class FeedsImagesRespJModel {


  
  int  id;
  
  String  createdate;
  
  String  txndate;
  
  int  createdby;
  
  bool  approved;
  
  int  approvedby;
  
  String  approveddate;
  
  bool  active;
  
  String  image_path;
  
  int  feeds;
  
  double  image_height;

  FeedsImagesRespJModel() {}
  factory FeedsImagesRespJModel.fromJson(Map<String, dynamic> json) =>
      _$FeedsImagesRespJModelFromJson(json);
  Map<String, dynamic> toJson() => _$FeedsImagesRespJModelToJson(this);
}
