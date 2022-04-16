import 'dart:developer';

import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Data/SharedPreferences/UserSessionSharedPrefs.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/authentication/LoginUserRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/token/TokenDecodedJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/UserSignUpRespModel.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/tabs/Index.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';

import 'dart:convert';

Future<bool> post_User_Login(
  BuildContext context,
  BuildContext snackBarBuildContext,
  String username,
  String password,
  NavigationDataBLoC onLoginButtonClicked_NavigationDataBLoC,
) async {
  refresh_W_Data_Isshow_NavigationDataBLoC(
    onLoginButtonClicked_NavigationDataBLoC,
    true,
  );
  String subm_username = "Null";
  String subm_password = "Null";
  if (ifStringValid(username)) {
    subm_username = username;
  }
  if (ifStringValid(password)) {
    subm_password = password;
  }

  UserSignUpRespModel usernameValidator = new UserSignUpRespModel();
  usernameValidator.username = subm_username;
  usernameValidator.password = subm_password;
  usernameValidator.success = false;
  usernameValidator.message = "None";
  usernameValidator.email = "None";
  usernameValidator.birthday = "None";
  usernameValidator.quote = "None";

  Response response = await Provider.of<PostApiService>(context)
      .loginwtoken(usernameValidator);
  int statusCode = response.statusCode;
  if (isresponseSuccessfull(statusCode)) {
    try {
      var respBody = response.body;
      LoginUserRespJModel loginUserRespJModel =
          LoginUserRespJModel.fromJson(respBody);
      LoginRespModel loginRespModel = loginUserRespJModel.user;
      loginRespModel.isinsignupprocess = false;
      loginRespModel.field_password = subm_password;
      if (!loginRespModel.activestatus) {
        refresh_W_Data_Isshow_NavigationDataBLoC(
            onLoginButtonClicked_NavigationDataBLoC, false);
        if (snackBarBuildContext != null) {
          showSnackbarWBgCol(
              'User not found', snackBarBuildContext, DatingAppTheme.red);
        }
      } else {
        TokenDecodedJModel tokenDecodedJModel =
            decodeToken(loginRespModel.token);
        loginRespModel.tokenDecodedJModel = tokenDecodedJModel;
        UserSessionSharedPrefs userSessionSharedPrefs =
            new UserSessionSharedPrefs();
        userSessionSharedPrefs.setUserSession(json.encode(loginRespModel)).then(
            (onValue) {
          print('SIGN UP SUCCESS');
          refresh_W_Data_Isshow_NavigationDataBLoC(
              onLoginButtonClicked_NavigationDataBLoC, false);
          if (snackBarBuildContext != null) {
            showSnackbarWBgCol(
                "Welcome", snackBarBuildContext, DatingAppTheme.green);
          }
          openHomePage(context);
        }, onError: (error) {
          print('error== $error');
          refresh_W_Data_Isshow_NavigationDataBLoC(
              onLoginButtonClicked_NavigationDataBLoC, false);
          if (snackBarBuildContext != null) {
            showSnackbarWBgCol(
                "An error ocurred", snackBarBuildContext, DatingAppTheme.red);
          }
        });
      }
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

void openHomePage(BuildContext context) {
  Navigator.pushReplacement(
      context, new MaterialPageRoute(builder: (context) => new Index()));
}
