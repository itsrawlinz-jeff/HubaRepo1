import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/validation/OnEditTextUserValidationRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/validation/UserNameValidationReqJModel.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';

Future<bool> post_validate_phone_no(
  BuildContext context,
  BuildContext snackBarBuildContext,
  String phone_no,
  NavigationDataBLoC onLoginButtonClicked_NavigationDataBLoC,
) async {
  String TAG = 'post_validate_phone_no:';
  print(TAG);
  refresh_W_Data_Isshow_NavigationDataBLoC(
    onLoginButtonClicked_NavigationDataBLoC,
    true,
  );

  UserNameValidationReqJModel userNameValidationReqJModel =
      new UserNameValidationReqJModel();
  userNameValidationReqJModel.validation_text = phone_no;

  Response response = await Provider.of<PostApiService>(context)
      .validatecustomuser_by_phone_no(userNameValidationReqJModel);
  int statusCode = response.statusCode;
  if (isresponseSuccessfull(statusCode)) {
    try {
      var respBody = response.body;
      OnEditTextUserValidationRespJModel onEditTextUserValidationRespJModel =
          OnEditTextUserValidationRespJModel.fromJson(respBody);
      if (snackBarBuildContext != null) {
        showSnackbarWBgCol(
            "Success", snackBarBuildContext, DatingAppTheme.green);
      }
      return onEditTextUserValidationRespJModel.user_exists;
    } catch (error) {
      print('error1==${error.toString()}');
      refresh_W_Data_Isshow_NavigationDataBLoC(
          onLoginButtonClicked_NavigationDataBLoC, false);
      if (snackBarBuildContext != null) {
        showSnackbarWBgCol(
            "An error ocurred", snackBarBuildContext, DatingAppTheme.red);
      }
      return false;
    }
  } else {
    refresh_W_Data_Isshow_NavigationDataBLoC(
        onLoginButtonClicked_NavigationDataBLoC, false);
    if (snackBarBuildContext != null) {
      showSnackbarWBgCol(
          "An error ocurred", snackBarBuildContext, DatingAppTheme.red);
    }
    return false;
  }
}
