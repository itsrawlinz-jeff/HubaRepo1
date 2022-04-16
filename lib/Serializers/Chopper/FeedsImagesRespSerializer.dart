import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'package:dating_app/Models/Chopper/FeedsImagesResp.dart';

part 'FeedsImagesRespSerializer.g.dart';

@SerializersFor(const [FeedsImagesResp])
final Serializers feedsImagesResp_serializers =
(_$feedsImagesResp_serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
