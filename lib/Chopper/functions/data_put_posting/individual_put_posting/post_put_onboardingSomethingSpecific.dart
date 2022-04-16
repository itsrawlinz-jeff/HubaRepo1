import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/onboardingsomethingspecific/OnboardingSomethingspecificRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserPostPutRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/OnboardingsomethingspecificReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/onboardingsomethingspecific/OnboardingSomethingspecificReqJModel.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> post_put_onboardingSomethingSpecific(
  BuildContext context,
  BuildContext snackBarBuildContext,
  Onboarding onboarding,
  OnboardingsomethingspecificReqJModel onboardingsomethingspecificReqJModel,
  NavigationDataBLoC navigationDataBLoC_Loader,
) async {
  if (navigationDataBLoC_Loader != null) {
    refreshLoader(true, navigationDataBLoC_Loader);
  }
  String TAG = 'post_put_onboardingSomethingSpecific:';
  print(TAG);

  bool isNetConnActive = await isNetworkConnectionActive();
  if (isNetConnActive) {
    OnboardingSomethingspecificReqJModel onboardingSomethingspecificReqJModel =
        OnboardingSomethingspecificReqJModel();
    onboardingSomethingspecificReqJModel.user = onboarding.onlineid;
    onboardingSomethingspecificReqJModel.something_specific =
        onboardingsomethingspecificReqJModel.somethingspecificid;
    onboardingSomethingspecificReqJModel.approved = true;
    onboardingSomethingspecificReqJModel.active = true;

    Map<String, dynamic> mapped_onboardingSomethingspecificReqJModel =
        onboardingSomethingspecificReqJModel.toJson();

    var mp_createdby = mapped_onboardingSomethingspecificReqJModel[
        DatingAppStaticParams.createdby];
    if (mp_createdby == null) {
      mapped_onboardingSomethingspecificReqJModel
          .remove(DatingAppStaticParams.createdby);

      var mp_approvedby = mapped_onboardingSomethingspecificReqJModel[
          DatingAppStaticParams.approvedby];
      if (mp_approvedby == null) {
        mapped_onboardingSomethingspecificReqJModel
            .remove(DatingAppStaticParams.approvedby);
      }

      var mp_user = mapped_onboardingSomethingspecificReqJModel[
          DatingAppStaticParams.user];
      if (mp_user == null) {
        mapped_onboardingSomethingspecificReqJModel
            .remove(DatingAppStaticParams.user);
      }

      var mp_approved = mapped_onboardingSomethingspecificReqJModel[
          DatingAppStaticParams.approved];
      if (mp_approved == null) {
        mapped_onboardingSomethingspecificReqJModel
            .remove(DatingAppStaticParams.approved);
      }

      var mp_approveddate = mapped_onboardingSomethingspecificReqJModel[
          DatingAppStaticParams.approveddate];
      if (mp_approveddate == null) {
        mapped_onboardingSomethingspecificReqJModel
            .remove(DatingAppStaticParams.approveddate);
      }

      var mp_active = mapped_onboardingSomethingspecificReqJModel[
          DatingAppStaticParams.active];
      if (mp_active == null) {
        mapped_onboardingSomethingspecificReqJModel
            .remove(DatingAppStaticParams.active);
      }

      var mp_hobby = mapped_onboardingSomethingspecificReqJModel[
          DatingAppStaticParams.hobby];
      if (mp_hobby == null) {
        mapped_onboardingSomethingspecificReqJModel
            .remove(DatingAppStaticParams.hobby);
      }

      Response hobbiePutresponse = null;
      if (isIntValid(onboardingsomethingspecificReqJModel.onlineid)) {
        print(TAG + 'PATCH');
        hobbiePutresponse = await Provider.of<PostApiService>(context)
            .patchOnboardingSomethingSpecific(
                //DatingAppStaticParams.tokenWspace + loginRespJModel.user.token,
                onboardingsomethingspecificReqJModel.onlineid,
                mapped_onboardingSomethingspecificReqJModel);
      } else {
        print(TAG + 'POST');
        hobbiePutresponse = await Provider.of<PostApiService>(context)
            .postOnboardingSomethingSpecific(
                //AdrianErpAppStaticParams.tokenWspace + loginRespJModel.user.token,
                mapped_onboardingSomethingspecificReqJModel);
      }
      int statusCode = hobbiePutresponse.statusCode;
      if (isresponseSuccessfull(statusCode)) {
        try {
          print(TAG + 'responseSuccessfull');
          var respBody = hobbiePutresponse.body;
          print(respBody);
          OnboardingSomethingspecificRespJModel
              onboardingSomethingspecificRespJModel =
              OnboardingSomethingspecificRespJModel.fromJson(respBody);
          print(TAG +
              'onboardingSomethingspecificRespJModel onlineid==${onboardingSomethingspecificRespJModel.id}');
          bool issyncHobbie = await syncOnboardingSomethingSpecific(
            context,
            onboardingSomethingspecificRespJModel,
            onboardingsomethingspecificReqJModel,
            navigationDataBLoC_Loader,
          );
          if (issyncHobbie) {
            if (snackBarBuildContext != null) {
              displaySnackBarWithDelay(
                  'Hobbie saved', DatingAppTheme.green, snackBarBuildContext);
            }
          } else {
            if (snackBarBuildContext != null) {
              displaySnackBarWithDelay('An error occurred saving hobbie',
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
              displaySnackBarWithDelay('An error occurred', DatingAppTheme.red,
                  snackBarBuildContext);
            }
          }
          return false;
        }
      } else {
        print(TAG + 'statusCode==${statusCode}');
        print(hobbiePutresponse.bodyString);

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
    }
    return false;
  }
}

Future<bool> syncOnboardingSomethingSpecific(
    BuildContext context,
    OnboardingSomethingspecificRespJModel onboardingSomethingspecificRespJModel,
    OnboardingsomethingspecificReqJModel onboardingsomethingspecificReqJModel,
    NavigationDataBLoC navigationDataBLoC_Loader) async {
  String TAG =
      'post_put_onboardingSomethingSpecific:syncOnboardingSomethingSpecific:';
  print(TAG);
  onboardingsomethingspecificReqJModel.onlineid =
      onboardingSomethingspecificRespJModel.id;
  if (navigationDataBLoC_Loader != null) {
    refreshLoader(false, navigationDataBLoC_Loader);
  }
  return true;
}
