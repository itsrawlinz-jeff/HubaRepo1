import 'package:json_annotation/json_annotation.dart';
part 'CustomUserReqJModel.g.dart';

@JsonSerializable()
class CustomUserReqJModel {
  int id;
  String name;
  String first_name;
  String last_name;
  String email;
  String username;
  String phone_number;
  String picture;
  DateTime createdate;
  DateTime txndate;
  bool approved;
  String quote;
  int age;
  String fb_link;
  String insta_link;
  int date_match_mode;

  CustomUserReqJModel() {}
  factory CustomUserReqJModel.fromJson(Map<String, dynamic> json) =>
      _$CustomUserReqJModelFromJson(json);
  Map<String, dynamic> toJson() => _$CustomUserReqJModelToJson(this);
}
