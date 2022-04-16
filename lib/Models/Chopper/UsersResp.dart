import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dating_app/Models/Chopper/UsersProfileResp.dart';

part 'UsersResp.g.dart';

abstract class UsersResp implements Built<UsersResp, UsersRespBuilder> {
  @nullable
  int get id;
  @nullable
  String get username;
  @nullable
  String get userpass;
  @nullable
  String get theme;
  @nullable
  String get createdate;
  @nullable
  String get txndate;
  @nullable
  String get approvedate;
  @nullable
  bool get approvalstatus;
  @nullable
  bool get activestatus;
  @nullable
  String get email;
  @nullable
  String get currentlogintime;
  @nullable
  String get lastlogintime;
  @nullable
  String get fullname;
  @nullable
  bool get intrash;
  @nullable
  bool get resetpass;
  @nullable
  bool get locked;
  @nullable
  bool get globaluser;
  @nullable
  String get lastpasswordchange;
  @nullable
  bool get encrypted;
  @nullable
  bool get system;
  @nullable
  bool get possupervisor;
  @nullable
  String get docno;
  @nullable
  String get directory;
  @nullable
  String get signature;
  @nullable
  String get profile_picture;
  @nullable
  int get roleid;
  @nullable
  int get createdby;
  @nullable
  int get approvedby;
  @nullable
  int get department;
  @nullable
  int get costcenter;
  @nullable
  int get company;
  @nullable
  int get supervisor;
  @nullable
  int get document;
  @nullable
  int get county;
  @nullable
  String get quote;
  @nullable
  String get birthday;
  @nullable
  int get age;

  @nullable
  BuiltList<UsersProfileResp> get usersProfile;

  UsersResp._();

  factory UsersResp([updates(UsersRespBuilder b)]) = _$UsersResp;

  static Serializer<UsersResp> get serializer => _$usersRespSerializer;
}
