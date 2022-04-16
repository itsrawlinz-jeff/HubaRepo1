import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingmoneyshemakeDao.dart';
import 'package:dating_app/Data/Database/Moor/JoinClasses/OnboardingmoneyshemakesJoinClass.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/onboardingmoneyshemake/OnboardingMoneyshemakeRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/onboardingmoneyshemake/OnboardingMoneyshemakeReqJModel.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> post_put_onboardingMoneySheShldmake(
  BuildContext context,
  BuildContext snackBarBuildContext,
  Onboarding onboarding,
  OnboardingmoneyshemakesJoinClass onboardingmoneyshemakesJoinClass,
  List<OnboardingmoneyshemakesJoinClass> onboardingmoneyshemakesJoinClassList,
  NavigationDataBLoC navigationDataBLoC_Loader,
  int list_index,
) async {
  if (navigationDataBLoC_Loader != null) {
    refreshLoader(true, navigationDataBLoC_Loader);
  }
  String TAG = 'post_put_onboardingMoneySheShldmake:';
  print(TAG);

  bool isNetConnActive = await isNetworkConnectionActive();
  if (isNetConnActive) {
    OnboardingMoneyshemakeReqJModel onboardingMoneyshemakeReqJModel =
        OnboardingMoneyshemakeReqJModel();
    onboardingMoneyshemakeReqJModel.user = onboarding.onlineid;
    onboardingMoneyshemakeReqJModel.income_range =
        onboardingmoneyshemakesJoinClass.incomerange.onlineid;
    onboardingMoneyshemakeReqJModel.approved = true;
    onboardingMoneyshemakeReqJModel.active = true;

    Map<String, dynamic> mapped_onboardingMoneyshemakeReqJModel =
        onboardingMoneyshemakeReqJModel.toJson();

    var mp_createdby =
        mapped_onboardingMoneyshemakeReqJModel[DatingAppStaticParams.createdby];
    if (mp_createdby == null) {
      mapped_onboardingMoneyshemakeReqJModel
          .remove(DatingAppStaticParams.createdby);

      var mp_approvedby = mapped_onboardingMoneyshemakeReqJModel[
          DatingAppStaticParams.approvedby];
      if (mp_approvedby == null) {
        mapped_onboardingMoneyshemakeReqJModel
            .remove(DatingAppStaticParams.approvedby);
      }

      var mp_user =
          mapped_onboardingMoneyshemakeReqJModel[DatingAppStaticParams.user];
      if (mp_user == null) {
        mapped_onboardingMoneyshemakeReqJModel
            .remove(DatingAppStaticParams.user);
      }

      var mp_approved = mapped_onboardingMoneyshemakeReqJModel[
          DatingAppStaticParams.approved];
      if (mp_approved == null) {
        mapped_onboardingMoneyshemakeReqJModel
            .remove(DatingAppStaticParams.approved);
      }

      var mp_approveddate = mapped_onboardingMoneyshemakeReqJModel[
          DatingAppStaticParams.approveddate];
      if (mp_approveddate == null) {
        mapped_onboardingMoneyshemakeReqJModel
            .remove(DatingAppStaticParams.approveddate);
      }

      var mp_active =
          mapped_onboardingMoneyshemakeReqJModel[DatingAppStaticParams.active];
      if (mp_active == null) {
        mapped_onboardingMoneyshemakeReqJModel
            .remove(DatingAppStaticParams.active);
      }

      var mp_income_range = mapped_onboardingMoneyshemakeReqJModel[
          DatingAppStaticParams.income_range];
      if (mp_income_range == null) {
        mapped_onboardingMoneyshemakeReqJModel
            .remove(DatingAppStaticParams.income_range);
      }

      Response hobbiePutresponse = null;
      if (isIntValid(
          onboardingmoneyshemakesJoinClass.onboardingmoneyshemake.onlineid)) {
        print(TAG + 'PATCH');
        hobbiePutresponse = await Provider.of<PostApiService>(context)
            .patchOnboardingMoneySheShldmake(
                onboardingmoneyshemakesJoinClass
                    .onboardingmoneyshemake.onlineid,
                mapped_onboardingMoneyshemakeReqJModel);
      } else {
        print(TAG + 'POST');
        hobbiePutresponse = await Provider.of<PostApiService>(context)
            .postOnboardingMoneySheShldmake(
                mapped_onboardingMoneyshemakeReqJModel);
      }
      int statusCode = hobbiePutresponse.statusCode;
      if (isresponseSuccessfull(statusCode)) {
        try {
          print(TAG + 'responseSuccessfull');
          var respBody = hobbiePutresponse.body;
          print(respBody);
          OnboardingMoneyshemakeRespJModel onboardingMoneyshemakeRespJModel =
              OnboardingMoneyshemakeRespJModel.fromJson(respBody);
          print(TAG +
              'onboardingMoneyshemakeRespJModel onlineid==${onboardingMoneyshemakeRespJModel.id}');
          bool issyncHobbie = await syncOnboardingMoneySheShldmake(
            context,
            onboardingMoneyshemakeRespJModel,
            onboardingmoneyshemakesJoinClass,
            navigationDataBLoC_Loader,
            onboardingmoneyshemakesJoinClassList,
            list_index,
          );
          if (issyncHobbie) {
            if (snackBarBuildContext != null) {
              displaySnackBarWithDelay(
                  'Money she should make saved', DatingAppTheme.green, snackBarBuildContext);
            }
          } else {
            if (snackBarBuildContext != null) {
              displaySnackBarWithDelay('An error occurred saving money she should make',
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

Future<bool> syncOnboardingMoneySheShldmake(
  BuildContext context,
  OnboardingMoneyshemakeRespJModel onboardingMoneyshemakeRespJModel,
  OnboardingmoneyshemakesJoinClass onboardingmoneyshemakesJoinClass,
  NavigationDataBLoC navigationDataBLoC_Loader,
  List<OnboardingmoneyshemakesJoinClass> onboardingmoneyshemakesJoinClassList,
  int list_index,
) async {
  String TAG =
      'post_put_onboardingMoneySheShldmake:syncOnboardingMoneySheShldmake:';
  print(TAG);

  AppDatabase database = Provider.of<AppDatabase>(context);
  OnboardingmoneyshemakeDao onboardingmoneyshemakeDao =
      database.onboardingmoneyshemakeDao;

  Onboardingmoneyshemake onboardingmoneyshemake =
      onboardingmoneyshemakesJoinClass.onboardingmoneyshemake;

  Onboardingmoneyshemake onboardingmoneyshemake_ToUpdate =
      onboardingmoneyshemake.copyWith(
          onlineid: onboardingMoneyshemakeRespJModel.id);

  bool isUpdated = await onboardingmoneyshemakeDao
      .updateOnboardingmoneyshemake(onboardingmoneyshemake_ToUpdate);

  if (isUpdated) {
    onboardingmoneyshemake = onboardingmoneyshemake_ToUpdate;
    if (onboardingmoneyshemakesJoinClassList != null && list_index != null) {
      onboardingmoneyshemakesJoinClassList[list_index].onboardingmoneyshemake =
          onboardingmoneyshemakesJoinClassList[list_index]
              .onboardingmoneyshemake
              .copyWith(onlineid: onboardingmoneyshemake.onlineid);
    }
  }

  if (navigationDataBLoC_Loader != null) {
    refreshLoader(false, navigationDataBLoC_Loader);
  }
  return true;
}
