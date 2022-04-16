import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingDao.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserPostPutRespJModel.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<bool> post_put_onboardings(
  BuildContext context,
  BuildContext snackBarBuildContext,
  Onboarding onboarding,
  NavigationDataBLoC navigationDataBLoC_Loader,
  Gender iamObj,
  Gender searchingforObj,
  Smokestatuse do_you_smokeObj,
  Educationlevel education_levelObj,
  Wantchildrenstatuse want_childrenObj,
  Drinkstatuse often_you_drinkObj,
  Ethnicitie ethnicityObj,
  Religion religionObj,
  Drinkstatuse want_date_to_drinkObj,
  Educationlevel picky_abt_her_educationObj,
  Relationshipstatuse relationshipstatusObj,
) async {
  if (navigationDataBLoC_Loader != null) {
    refreshLoader(true, navigationDataBLoC_Loader);
  }
  String TAG = 'post_put_onboardings:';
  print(TAG);
  DateFormat dff = DateFormat('yyyy-MM-dd');
  DateFormat df_dmy = DateFormat('dd/MM/yyyy');

  bool isNetConnActive = await isNetworkConnectionActive();
  if (isNetConnActive) {
    AppDatabase database = Provider.of<AppDatabase>(context);
    Response onboardingPutpostResponse = null;
    print(onboarding.birthday);
    if (isIntValid(onboarding.onlineid)) {
      print(TAG + 'PATCH');
      onboardingPutpostResponse =
          await Provider.of<PostApiService>(context).patchcustomusers(
        onboarding.onlineid,
        onboarding.username,
        onboarding.password,
        onboarding.password,
        onboarding.email,
        ((onboarding.birthday != null
            ? dff.format(df_dmy.parse(onboarding.birthday))
            : null)),
        onboarding.little_about_self,
        onboarding.profpicpath,
        iamObj.onlineid,
        searchingforObj.onlineid,
        relationshipstatusObj.onlineid,
        do_you_smokeObj.onlineid,
        education_levelObj.onlineid,
        want_childrenObj.onlineid,
        often_you_drinkObj.onlineid,
        ethnicityObj.onlineid,
        religionObj.onlineid,
        want_date_to_drinkObj.onlineid,
        picky_abt_her_educationObj.onlineid,
        onboarding.herage_low,
        onboarding.herage_high,
        onboarding.firstname,
        onboarding.lastname,
        onboarding.phone_number,
        onboarding.fb_link,
        onboarding.insta_link,
      );
    } else {
      print(TAG + 'POST');
      onboardingPutpostResponse =
          await Provider.of<PostApiService>(context).customusers(
        onboarding.username,
        onboarding.password,
        onboarding.password,
        onboarding.email,
        ((onboarding.birthday != null
            ? dff.format(df_dmy.parse(onboarding.birthday))
            : null)),
        onboarding.little_about_self,
        onboarding.profpicpath,
        iamObj.onlineid,
        searchingforObj.onlineid,
        relationshipstatusObj.onlineid,
        do_you_smokeObj.onlineid,
        education_levelObj.onlineid,
        want_childrenObj.onlineid,
        often_you_drinkObj.onlineid,
        ethnicityObj.onlineid,
        religionObj.onlineid,
        want_date_to_drinkObj.onlineid,
        picky_abt_her_educationObj.onlineid,
        onboarding.herage_low,
        onboarding.herage_high,
        onboarding.firstname,
        onboarding.lastname,
        onboarding.phone_number,
        onboarding.fb_link,
        onboarding.insta_link,
      );
    }
    int statusCode = onboardingPutpostResponse.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        print(TAG + 'responseSuccessfull');
        var respBody = onboardingPutpostResponse.body;
        print(respBody);
        CustomUserPostPutRespJModel customUserPostPutRespJModel =
            CustomUserPostPutRespJModel.fromJson(respBody);
        print(TAG +
            'customUserPostPutRespJModel onlineid==${customUserPostPutRespJModel.id}');
        bool issyncHobbie = await syncOnboarding(
          context,
          onboarding,
          customUserPostPutRespJModel,
          navigationDataBLoC_Loader,
          database,
        );
        if (issyncHobbie) {
          if (snackBarBuildContext != null) {
            displaySnackBarWithDelay(
                'Onboarding saved', DatingAppTheme.green, snackBarBuildContext);
          }
        } else {
          if (snackBarBuildContext != null) {
            displaySnackBarWithDelay('An error occurred registering',
                DatingAppTheme.green, snackBarBuildContext);
          }
        }
        return issyncHobbie;
      } catch (error) {
        print(TAG + 'error==');
        print(error.toString());
        if (navigationDataBLoC_Loader != null) {
          refreshLoader(false, navigationDataBLoC_Loader);
        }
        if (snackBarBuildContext != null) {
          if (snackBarBuildContext != null) {
            displaySnackBarWithDelay(
                'An error occurred', DatingAppTheme.red, snackBarBuildContext);
          }
        }
        return false;
      }
    } else {
      print(TAG + 'statusCode==${statusCode}');
      print(onboardingPutpostResponse.bodyString);

      if (navigationDataBLoC_Loader != null) {
        refreshLoader(false, navigationDataBLoC_Loader);
      }
      if (isresponse400(statusCode)) {
        if (snackBarBuildContext != null) {
          displaySnackBarWithDelay(
              'An error ocurred', DatingAppTheme.red, snackBarBuildContext);
        }
      } else {
        if (snackBarBuildContext != null) {
          displaySnackBarWithDelay(
              'Connection error', DatingAppTheme.red, snackBarBuildContext);
        }
      }

      return false;
    }
  } else {
    print(TAG + 'INTERNET CONNECTION NOT ACTIVE');
    if (navigationDataBLoC_Loader != null) {
      refreshLoader(false, navigationDataBLoC_Loader);
    }
    if (snackBarBuildContext != null) {
      displaySnackBarWithDelay(
          'No internet connection', DatingAppTheme.red, snackBarBuildContext);
    }
    return false;
  }
}

Future<bool> syncOnboarding(
  BuildContext context,
  Onboarding onboarding,
  CustomUserPostPutRespJModel customUserPostPutRespJModel,
  NavigationDataBLoC navigationDataBLoC_Loader,
  AppDatabase database,
) async {
  String TAG = 'post_put_onboardings:syncOnboarding:';
  print(TAG);

  OnboardingDao onboardingDao = database.onboardingDao;
  onboarding = onboarding.copyWith(onlineid: customUserPostPutRespJModel.id);
  bool is_onboarding_updated = await onboardingDao.updateOnboarding(onboarding);
  onboarding = await onboardingDao.getOnboardingById(onboarding.id);
  if (navigationDataBLoC_Loader != null) {
    refreshLoader(false, navigationDataBLoC_Loader);
  }
  return true;
}
