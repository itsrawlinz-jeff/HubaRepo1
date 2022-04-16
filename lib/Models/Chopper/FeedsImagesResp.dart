
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'FeedsImagesResp.g.dart';

abstract class FeedsImagesResp implements Built<FeedsImagesResp, FeedsImagesRespBuilder> {

  @nullable
  int get id;
  @nullable
  String get createdate;
  @nullable
  String get txndate;
  @nullable
  int get createdby;
  @nullable
  bool get approved;
  @nullable
  int get approvedby;
  @nullable
  String get approveddate;
  @nullable
  bool get active;
  @nullable
  String get image_path;
  @nullable
  int get feeds;
  @nullable
  double get image_height;

  FeedsImagesResp._();

  factory FeedsImagesResp([updates(FeedsImagesRespBuilder b)]) = _$FeedsImagesResp;

  static Serializer<FeedsImagesResp> get serializer => _$feedsImagesRespSerializer;
}
