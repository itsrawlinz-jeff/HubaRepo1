import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:dating_app/Serializers/Chopper/UsernameValidatorSerializer.dart';

part 'UsernameValidator.g.dart';

abstract class UsernameValidator implements Built<UsernameValidator, UsernameValidatorBuilder> {
  @nullable
  int get id;
  @nullable
  String get username;
  @nullable
  String get password;
  @nullable
  String get email;
  @nullable
  String get message;
  @nullable
  bool get success;
  @nullable
  String get title;
  @nullable
  String get body;
  @nullable
  String get birthday;

  UsernameValidator._();

  factory UsernameValidator([updates(UsernameValidatorBuilder b)]) = _$UsernameValidator;

  static Serializer<UsernameValidator> get serializer => _$usernameValidatorSerializer;
}
