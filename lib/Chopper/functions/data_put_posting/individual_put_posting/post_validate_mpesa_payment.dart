import 'dart:convert';
import 'dart:developer';

import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/payment/MpesaPaymentRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/validation/OnEditTextUserValidationRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/validation/UserNameValidationReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';

Future<MpesaPaymentRespJModel> validatepayment_by_mpesacode(
  BuildContext context,
  BuildContext snackBarBuildContext,
  String email,
  NavigationDataBLoC onLoginButtonClicked_NavigationDataBLoC,
) async {
  String TAG = 'validatepayment_by_mpesacode:';
  print(TAG);
  refresh_W_Data_Isshow_NavigationDataBLoC(
    onLoginButtonClicked_NavigationDataBLoC,
    true,
  );
  LoginRespModel loginRespJModel = await getSessionLoginRespModel(context);
  UserNameValidationReqJModel userNameValidationReqJModel =
      new UserNameValidationReqJModel();
  userNameValidationReqJModel.validation_text = email;

  Response response =
      await Provider.of<PostApiService>(context).validatepayment_by_mpesacode(
    DatingAppStaticParams.basicWspace + getAppCredsB64(loginRespJModel),
    userNameValidationReqJModel,
  );
  int statusCode = response.statusCode;
  //log(DatingAppStaticParams.basicWspace + getAppCredsB64(loginRespJModel));
  if (isresponseSuccessfull(statusCode)) {
    try {
      var respBody = response.body;
      log(TAG+" response=="+json.encode(respBody));
      MpesaPaymentRespJModel mpesaPaymentRespJModel =
          MpesaPaymentRespJModel.fromJson(respBody);
      showSnackbarWBgCol("Success", snackBarBuildContext, DatingAppTheme.green);
      return mpesaPaymentRespJModel;
    } catch (error) {
      print('error1==${error.toString()}');
      refresh_W_Data_Isshow_NavigationDataBLoC(
          onLoginButtonClicked_NavigationDataBLoC, false);
      showSnackbarWBgCol(
          "An error ocurred", snackBarBuildContext, DatingAppTheme.red);
      return null;
    }
  } else {
    refresh_W_Data_Isshow_NavigationDataBLoC(
        onLoginButtonClicked_NavigationDataBLoC, false);
    showSnackbarWBgCol(
        "An error ocurred", snackBarBuildContext, DatingAppTheme.red);
    return null;
  }
}
