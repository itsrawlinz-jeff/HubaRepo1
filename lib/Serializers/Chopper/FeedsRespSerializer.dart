import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:dating_app/Models/Chopper/FeedsImagesResp.dart';
import 'package:dating_app/Models/Chopper/FeedsResp.dart';
import 'package:built_collection/built_collection.dart';

part 'FeedsRespSerializer.g.dart';

@SerializersFor(const [FeedsResp,FeedsImagesResp])
final Serializers feedsResp_serializers =
(_$feedsResp_serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
