
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:dating_app/Models/Chopper/FeedsImagesResp.dart';
import 'package:built_collection/built_collection.dart';

part 'FeedsResp.g.dart';

abstract class FeedsResp implements Built<FeedsResp, FeedsRespBuilder> {
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
  String get description;
  @nullable
  bool get foreveryone;
  @nullable
  String get message;
  @nullable
  int get feeds_type;
  @nullable
  BuiltList<FeedsImagesResp> get feedsImages;

  @nullable
  int get userid;
  @nullable
  bool get success;

  FeedsResp._();

  factory FeedsResp([updates(FeedsRespBuilder b)]) = _$FeedsResp;

  static Serializer<FeedsResp> get serializer => _$feedsRespSerializer;
}
