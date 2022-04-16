import 'package:json_annotation/json_annotation.dart';
part 'OnEditTextUserValidationRespJModel.g.dart';

@JsonSerializable()
class OnEditTextUserValidationRespJModel {
  bool user_exists;

  OnEditTextUserValidationRespJModel() {}
  factory OnEditTextUserValidationRespJModel.fromJson(
          Map<String, dynamic> json) =>
      _$OnEditTextUserValidationRespJModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$OnEditTextUserValidationRespJModelToJson(this);
}
