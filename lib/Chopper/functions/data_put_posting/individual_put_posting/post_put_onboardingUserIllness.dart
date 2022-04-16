import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardinguserillnessDao.dart';
import 'package:dating_app/Data/Database/Moor/JoinClasses/OnboardinguserillnessJoinClass.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/onboardingmoneyshemake/OnboardingUserillnessRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/onboardingmoneyshemake/OnboardingUserIllnessReqJModel.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> post_put_onboardingUserIllness(
  BuildContext context,
  BuildContext snackBarBuildContext,
  Onboarding onboarding,
  OnboardinguserillnessJoinClass onboardinguserillnessJoinClass,
  List<OnboardinguserillnessJoinClass> onboardinguserillnessJoinClassList,
  NavigationDataBLoC navigationDataBLoC_Loader,
  int list_index,
) async {
  if (navigationDataBLoC_Loader != null) {
    refreshLoader(true, navigationDataBLoC_Loader);
  }
  String TAG = 'post_put_onboardingUserIllness:';
  print(TAG);

  bool isNetConnActive = await isNetworkConnectionActive();
  if (isNetConnActive) {
    OnboardingUserIllnessReqJModel onboardingUserIllnessReqJModel =
        OnboardingUserIllnessReqJModel();
    onboardingUserIllnessReqJModel.user = onboarding.onlineid;
    onboardingUserIllnessReqJModel.illness =
        onboardinguserillnessJoinClass.illness.onlineid;
    onboardingUserIllnessReqJModel.approved = true;
    onboardingUserIllnessReqJModel.active = true;

    Map<String, dynamic> mapped_onboardingUserIllnessReqJModel =
        onboardingUserIllnessReqJModel.toJson();

    var mp_createdby =
        mapped_onboardingUserIllnessReqJModel[DatingAppStaticParams.createdby];
    if (mp_createdby == null) {
      mapped_onboardingUserIllnessReqJModel
          .remove(DatingAppStaticParams.createdby);

      var mp_approvedby = mapped_onboardingUserIllnessReqJModel[
          DatingAppStaticParams.approvedby];
      if (mp_approvedby == null) {
        mapped_onboardingUserIllnessReqJModel
            .remove(DatingAppStaticParams.approvedby);
      }

      var mp_user =
          mapped_onboardingUserIllnessReqJModel[DatingAppStaticParams.user];
      if (mp_user == null) {
        mapped_onboardingUserIllnessReqJModel
            .remove(DatingAppStaticParams.user);
      }

      var mp_approved =
          mapped_onboardingUserIllnessReqJModel[DatingAppStaticParams.approved];
      if (mp_approved == null) {
        mapped_onboardingUserIllnessReqJModel
            .remove(DatingAppStaticParams.approved);
      }

      var mp_approveddate = mapped_onboardingUserIllnessReqJModel[
          DatingAppStaticParams.approveddate];
      if (mp_approveddate == null) {
        mapped_onboardingUserIllnessReqJModel
            .remove(DatingAppStaticParams.approveddate);
      }

      var mp_active =
          mapped_onboardingUserIllnessReqJModel[DatingAppStaticParams.active];
      if (mp_active == null) {
        mapped_onboardingUserIllnessReqJModel
            .remove(DatingAppStaticParams.active);
      }

      var mp_income_range = mapped_onboardingUserIllnessReqJModel[
          DatingAppStaticParams.income_range];
      if (mp_income_range == null) {
        mapped_onboardingUserIllnessReqJModel
            .remove(DatingAppStaticParams.income_range);
      }

      Response hobbiePutresponse = null;
      if (isIntValid(
          onboardinguserillnessJoinClass.onboardinguserillness.onlineid)) {
        print(TAG + 'PATCH');
        hobbiePutresponse = await Provider.of<PostApiService>(context)
            .patchOnboardingUserIllnesses(
                onboardinguserillnessJoinClass.onboardinguserillness.onlineid,
                mapped_onboardingUserIllnessReqJModel);
      } else {
        print(TAG + 'POST');
        hobbiePutresponse = await Provider.of<PostApiService>(context)
            .postOnboardingUserIllnesses(
                mapped_onboardingUserIllnessReqJModel);
      }
      int statusCode = hobbiePutresponse.statusCode;
      if (isresponseSuccessfull(statusCode)) {
        try {
          print(TAG + 'responseSuccessfull');
          var respBody = hobbiePutresponse.body;
          print(respBody);
          OnboardingUserillnessRespJModel onboardingUserillnessRespJModel =
              OnboardingUserillnessRespJModel.fromJson(respBody);
          print(TAG +
              'onboardingUserillnessRespJModel onlineid==${onboardingUserillnessRespJModel.id}');
          bool issyncHobbie = await syncOnboardingUserIllness(
            context,
            onboardingUserillnessRespJModel,
            onboardinguserillnessJoinClass,
            navigationDataBLoC_Loader,
            onboardinguserillnessJoinClassList,
            list_index,
          );
          if (issyncHobbie) {
            if (snackBarBuildContext != null) {
              displaySnackBarWithDelay('Money she should make saved',
                  DatingAppTheme.green, snackBarBuildContext);
            }
          } else {
            if (snackBarBuildContext != null) {
              displaySnackBarWithDelay(
                  'An error occurred saving money she should make',
                  DatingAppTheme.green,
                  snackBarBuildContext);
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

Future<bool> syncOnboardingUserIllness(
  BuildContext context,
  OnboardingUserillnessRespJModel onboardingUserillnessRespJModel,
  OnboardinguserillnessJoinClass onboardinguserillnessJoinClass,
  NavigationDataBLoC navigationDataBLoC_Loader,
  List<OnboardinguserillnessJoinClass> onboardinguserillnessJoinClassList,
  int list_index,
) async {
  String TAG = 'post_put_onboardingUserIllness:syncOnboardingUserIllness:';
  print(TAG);

  AppDatabase database = Provider.of<AppDatabase>(context);
  OnboardinguserillnessDao onboardinguserillnessDao =
      database.onboardinguserillnessDao;

  Onboardinguserillness onboardinguserillness =
      onboardinguserillnessJoinClass.onboardinguserillness;

  Onboardinguserillness onboardinguserillness_ToUpdate = onboardinguserillness
      .copyWith(onlineid: onboardingUserillnessRespJModel.id);

  bool isUpdated = await onboardinguserillnessDao
      .updateOnboardinguserillness(onboardinguserillness_ToUpdate);

  if (isUpdated) {
    onboardinguserillness = onboardinguserillness_ToUpdate;
    if (onboardinguserillnessJoinClassList != null && list_index != null) {
      onboardinguserillnessJoinClassList[list_index].onboardinguserillness =
          onboardinguserillnessJoinClassList[list_index]
              .onboardinguserillness
              .copyWith(onlineid: onboardinguserillness.onlineid);
    }
  }

  if (navigationDataBLoC_Loader != null) {
    refreshLoader(false, navigationDataBLoC_Loader);
  }
  return true;
}
