
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'UsersProfileResp.g.dart';

abstract class UsersProfileResp implements Built<UsersProfileResp, UsersProfileRespBuilder> {

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
  String get picture;
  @nullable
  bool get isprofilepicture;
  @nullable
  int get users;


  UsersProfileResp._();

  factory UsersProfileResp([updates(UsersProfileRespBuilder b)]) = _$UsersProfileResp;

  static Serializer<UsersProfileResp> get serializer => _$usersProfileRespSerializer;
}
