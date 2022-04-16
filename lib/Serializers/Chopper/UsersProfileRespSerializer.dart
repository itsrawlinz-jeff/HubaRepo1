import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:dating_app/Models/Chopper/UsersProfileResp.dart';

part 'UsersProfileRespSerializer.g.dart';

@SerializersFor(const [UsersProfileResp])
final Serializers usersProfileResp_serializers =
(_$usersProfileResp_serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
