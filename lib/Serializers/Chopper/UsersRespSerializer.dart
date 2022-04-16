import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:dating_app/Models/Chopper/UsersProfileResp.dart';
import 'package:dating_app/Models/Chopper/UsersResp.dart';
import 'package:built_collection/built_collection.dart';

part 'UsersRespSerializer.g.dart';

@SerializersFor(const [UsersResp,UsersProfileResp])
final Serializers usersResp_serializers =
(_$usersResp_serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
