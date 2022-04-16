import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'package:dating_app/Models/Chopper/UsernameValidator.dart';

part 'UsernameValidatorSerializer.g.dart';

@SerializersFor(const [UsernameValidator])
final Serializers serializers =
(_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

