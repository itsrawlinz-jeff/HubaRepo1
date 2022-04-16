import 'package:dating_app/Models/JsonSerializable/Api/from/token/TokenDecodedJModel.dart';
import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'LoginRespModel.g.dart';

@JsonSerializable()
class LoginRespModel {
  int id;
  String username;
  String userpass;
  String theme;
  String createdate;
  String txndate;
  String approvedate;
  bool approvalstatus;
  bool activestatus;
  String email;
  String currentlogintime;
  String lastlogintime;
  String fullname;
  bool intrash;
  bool resetpass;
  bool locked;
  bool globaluser;
  String lastpasswordchange;
  bool encrypted;
  bool system;
  bool possupervisor;
  String docno;
  String directory;
  String signature;
  String profile_picture;
  String local_profile_picture_path;
  String local_profile_picture_filename;
  int roleid;
  int createdby;
  int approvedby;
  int department;
  int costcenter;
  int company;
  int supervisor;
  int document;
  int county;
  String quote;
  String birthday;
  int age;
  bool isinsignupprocess;
  String phone_number;
  String first_name;
  String last_name;
  String token;
  String field_password;

  TokenDecodedJModel tokenDecodedJModel;

  List<UserProfileRespModel> usersProfile;

  LoginRespModel() {}
  factory LoginRespModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRespModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRespModelToJson(this);
}
