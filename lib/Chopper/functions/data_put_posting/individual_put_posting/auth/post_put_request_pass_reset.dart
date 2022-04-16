import 'dart:convert';
import 'dart:developer';

import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleEvent.dart';
import 'package:dating_app/Bloc/Streams/PageChanged/OnBoardingPageBLoC.dart';
import 'package:dating_app/Bloc/Streams/PageChanged/OnBoardingPageEvent.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingDao.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/authentication/PasswordResetRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/DateMatchRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/matches/DateMatchReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/user_profiles/UserUserProfileReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Errors/ErrorRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';

import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleBLoC.dart';

post_put_request_pass_reset(
    BuildContext contextnoScaffold,
    BuildContext context,
    PasswordResetRespJModel passwordResetRespJModel,
    OnBoardingPageBLoC loginBtnPageBLoC,
    KeyBoardVisibleBLoC resetPassBLoC) async {
  String TAG = 'post_put_request_pass_reset:';
  try {
    if (loginBtnPageBLoC != null) {
      loginBtnPageBLoC.onBoardingPage_visible_event_sink
          .add(OnBoardingPageChangedEvent(0));
    }
    Map<String, dynamic> mapped_passwordResetRespJModel =
        passwordResetRespJModel.toJson();

    var phone_number =
        mapped_passwordResetRespJModel[DatingAppStaticParams.phone_number];
    if (phone_number == null) {
      mapped_passwordResetRespJModel.remove(DatingAppStaticParams.phone_number);
    }

    var email = mapped_passwordResetRespJModel[DatingAppStaticParams.email];
    if (email == null) {
      mapped_passwordResetRespJModel.remove(DatingAppStaticParams.email);
    }

    Response resetPassResponse =
        await Provider.of<PostApiService>(contextnoScaffold).resetPassword(
            DatingAppStaticParams.application_json,
            mapped_passwordResetRespJModel);
    int statusCode = resetPassResponse.statusCode;
    var respBody = resetPassResponse.body;
    if (statusCode == 200) {
      try {
        PasswordResetRespJModel passwordResetRespJModel =
            PasswordResetRespJModel.fromJson(respBody);

        loginBtnPageBLoC.onBoardingPage_visible_event_sink
            .add(OnBoardingPageChangedEvent(1));
        showSnackbarWBgCol(
            passwordResetRespJModel.message, context, DatingAppTheme.green);
        resetPassBLoC.keyboard_visible_event_sink
            .add(ToggleKeyBoardVisEvent(false));
      } catch (error) {
        print(TAG + 'error==');
        print(error);
        loginBtnPageBLoC.onBoardingPage_visible_event_sink
            .add(OnBoardingPageChangedEvent(1));
        showSnackbarWBgCol('An Error Ocurred', context, DatingAppTheme.red);
      }
    } else {
      print(TAG + 'statusCode==');
      print(statusCode);
      if (statusCode == 400) {
        print(TAG + 'resetPassResponse.bodyString==');
        print(resetPassResponse.bodyString);
        loginBtnPageBLoC.onBoardingPage_visible_event_sink
            .add(OnBoardingPageChangedEvent(1));
        showSnackbarWBgCol('The phone/email no provided is not registered',
            context, DatingAppTheme.red);
      } else {
        loginBtnPageBLoC.onBoardingPage_visible_event_sink
            .add(OnBoardingPageChangedEvent(1));
        showSnackbarWBgCol('Connection Error', context, DatingAppTheme.red);
      }
    }
  } catch (error) {
    print(TAG + 'error==');
    print(error);
    loginBtnPageBLoC.onBoardingPage_visible_event_sink
        .add(OnBoardingPageChangedEvent(1));
    showSnackbarWBgCol('An error Occurred', context, DatingAppTheme.red);
  }
}

post_put_pass_reset_w_otp(
    BuildContext contextnoScaffold,
    BuildContext context,
    PasswordResetRespJModel passwordResetRespJModel,
    OnBoardingPageBLoC loginBtnPageBLoC,
    KeyBoardVisibleBLoC resetPassBLoC) async {
  String TAG = "post_put_pass_reset_w_otp:";
  try {
    if (loginBtnPageBLoC != null) {
      loginBtnPageBLoC.onBoardingPage_visible_event_sink
          .add(OnBoardingPageChangedEvent(0));
    }
    Map<String, dynamic> mapped_passwordResetRespJModel =
        passwordResetRespJModel.toJson();

    var phone_number =
        mapped_passwordResetRespJModel[DatingAppStaticParams.phone_number];
    if (!isStringValid(phone_number)) {
      mapped_passwordResetRespJModel.remove(DatingAppStaticParams.phone_number);
    }

    var email = mapped_passwordResetRespJModel[DatingAppStaticParams.email];
    if (email == null) {
      mapped_passwordResetRespJModel.remove(DatingAppStaticParams.email);
    }
    print(mapped_passwordResetRespJModel);

    Response resetPassResponse =
        await Provider.of<PostApiService>(contextnoScaffold).otp_verify(
      DatingAppStaticParams.application_json,
      mapped_passwordResetRespJModel,
    );
    int statusCode = resetPassResponse.statusCode;
    var respBody = resetPassResponse.body;
    if (statusCode >= 200 && statusCode < 300) {
      try {
        /*PasswordResetRespJModel passwordResetRespJModel =
            PasswordResetRespJModel.fromJson(respBody);*/

        //loginBtnPageBLoC.loginBtn_visible_event_sink.add(OnButtonClickEvent(1));
        //showSnackbar(passwordResetRespJModel.message, context);
        updatePassWithOTP(contextnoScaffold, context, passwordResetRespJModel,
            loginBtnPageBLoC, resetPassBLoC);
      } catch (error) {
        loginBtnPageBLoC.onBoardingPage_visible_event_sink
            .add(OnBoardingPageChangedEvent(1));
        showSnackbarWBgCol('An Error Ocurred', context, DatingAppTheme.red);
      }
    } else {
      if (statusCode == 400) {
        print(TAG + " 400:");
        print(resetPassResponse.bodyString);
        String errmsg = 'Invalid OTP';
        try {
          ErrorRespJModel errorRespJModel = ErrorRespJModel.fromJson(
              json.decode(resetPassResponse.bodyString));
          if (errorRespJModel.errors != null &&
              errorRespJModel.errors.error != null &&
              errorRespJModel.errors.error.length > 0) {
            String errfrmmsg = '';
            for (int i = 0; i < errorRespJModel.errors.error.length; i++) {
              String errmsg = errorRespJModel.errors.error[i];
              errfrmmsg += errmsg;
              if (i < errorRespJModel.errors.error.length - 1) {
                errfrmmsg += ', ';
              }
            }
            errmsg = errfrmmsg;
          }
        } catch (e) {
          print(TAG + " error==");
          print(e.toString());
        }
        loginBtnPageBLoC.onBoardingPage_visible_event_sink
            .add(OnBoardingPageChangedEvent(1));
        showSnackbarWBgCol(errmsg, context, DatingAppTheme.red);
      } else {
        loginBtnPageBLoC.onBoardingPage_visible_event_sink
            .add(OnBoardingPageChangedEvent(1));
        showSnackbarWBgCol('An error Occurred', context, DatingAppTheme.red);
      }
    }
  } catch (error) {
    loginBtnPageBLoC.onBoardingPage_visible_event_sink
        .add(OnBoardingPageChangedEvent(1));
    showSnackbarWBgCol('An error Occurred', context, DatingAppTheme.red);
  }
}

updatePassWithOTP(
    BuildContext contextnoScaffold,
    BuildContext context,
    PasswordResetRespJModel passwordResetRespJModel,
    OnBoardingPageBLoC loginBtnPageBLoC,
    KeyBoardVisibleBLoC resetPassBLoC) async {
  String TAG = "updatePassWithOTP:";
  try {
    if (loginBtnPageBLoC != null) {
      loginBtnPageBLoC.onBoardingPage_visible_event_sink
          .add(OnBoardingPageChangedEvent(0));
    }
    Response resetPassResponse;
    if (isStringValid(passwordResetRespJModel.phone_number)) {
      resetPassResponse = await Provider.of<PostApiService>(contextnoScaffold)
          .password_update(DatingAppStaticParams.application_json,
              passwordResetRespJModel, passwordResetRespJModel.phone_number);
    } else {
      resetPassResponse = await Provider.of<PostApiService>(contextnoScaffold)
          .password_update_email(DatingAppStaticParams.application_json,
              passwordResetRespJModel, passwordResetRespJModel.email);
    }

    int statusCode = resetPassResponse.statusCode;
    var respBody = resetPassResponse.body;
    if (statusCode >= 200 && statusCode < 300) {
      try {
        PasswordResetRespJModel passwordResetRespJModel =
            PasswordResetRespJModel.fromJson(respBody);

        loginBtnPageBLoC.onBoardingPage_visible_event_sink
            .add(OnBoardingPageChangedEvent(1));
        showSnackbarGotoLogin(
            passwordResetRespJModel.message, context, contextnoScaffold);
      } catch (error) {
        loginBtnPageBLoC.onBoardingPage_visible_event_sink
            .add(OnBoardingPageChangedEvent(1));
        showSnackbarWBgCol('An Error Ocurred', context, DatingAppTheme.red);
      }
    } else {
      if (statusCode == 400) {
        print(TAG + " 400:");
        print(resetPassResponse.bodyString);
        String errmsg = 'Error resetting password';
        try {
          ErrorRespJModel errorRespJModel = ErrorRespJModel.fromJson(
              json.decode(resetPassResponse.bodyString));
          if (errorRespJModel.errors != null &&
              errorRespJModel.errors.password != null &&
              errorRespJModel.errors.password.length > 0) {
            String errfrmmsg = '';
            for (int i = 0; i < errorRespJModel.errors.password.length; i++) {
              String errmsg = errorRespJModel.errors.password[i];
              errfrmmsg += errmsg;
              if (i < errorRespJModel.errors.password.length - 1) {
                errfrmmsg += ', ';
              }
            }
            errmsg = errfrmmsg;
          }
        } catch (e) {
          print(TAG + " error==");
          print(e.toString());
        }

        loginBtnPageBLoC.onBoardingPage_visible_event_sink
            .add(OnBoardingPageChangedEvent(1));
        showSnackbarWBgCol(errmsg, context, DatingAppTheme.red);
      } else {
        loginBtnPageBLoC.onBoardingPage_visible_event_sink
            .add(OnBoardingPageChangedEvent(1));
        showSnackbarWBgCol('Connection Error', context, DatingAppTheme.red);
      }
    }
  } catch (error) {
    loginBtnPageBLoC.onBoardingPage_visible_event_sink
        .add(OnBoardingPageChangedEvent(1));
    showSnackbarWBgCol('An error Occurred', context, DatingAppTheme.red);
  }
}

void showSnackbarGotoLogin(
    String message, BuildContext context, BuildContext contextnoScaffold) {
  showSnackbarWBgCol(message, context, DatingAppTheme.green);
  /*SnackBar snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(fontFamily: DatingAppTheme.fontName),
    ),
    action: SnackBarAction(
        label: 'OK',
        textColor: DatingAppTheme.white,
        onPressed: () {
          Navigator.pop(contextnoScaffold);
        }),
    backgroundColor: DatingAppTheme.green//HexColor('#9C0C6A'),
  );*/

  //Scaffold.of(context).showSnackBar(snackBar);
  try {
    Navigator.pop(context,message);
  }catch(e){
    print("POP ERROR");
    print(e.toString());
  }

}
