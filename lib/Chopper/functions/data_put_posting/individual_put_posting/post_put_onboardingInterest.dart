import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardinginterestDao.dart';
import 'package:dating_app/Data/Database/Moor/JoinClasses/OnboardinginterestJoinClass.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/onboardinginterest/OnboardingInterestRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/onboardinginterest/OnboardingInterestReqJModel.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> post_put_onboardingInterest(
  BuildContext context,
  BuildContext snackBarBuildContext,
  Onboarding onboarding,
  OnboardinginterestJoinClass onboardinginterestJoinClass,
  List<OnboardinginterestJoinClass> onboardinginterestJoinClassList,
  NavigationDataBLoC navigationDataBLoC_Loader,
  int list_index,
) async {
  if (navigationDataBLoC_Loader != null) {
    refreshLoader(true, navigationDataBLoC_Loader);
  }
  String TAG = 'post_put_onboardingInterest:';
  print(TAG);

  bool isNetConnActive = await isNetworkConnectionActive();
  if (isNetConnActive) {
    OnboardingInterestReqJModel onboardingInterestReqJModel =
        OnboardingInterestReqJModel();
    onboardingInterestReqJModel.user = onboarding.onlineid;
    onboardingInterestReqJModel.hobby =
        onboardinginterestJoinClass.hobbie.onlineid;
    onboardingInterestReqJModel.approved = true;
    onboardingInterestReqJModel.active = true;

    Map<String, dynamic> mapped_onboardingInterestReqJModel =
        onboardingInterestReqJModel.toJson();

    var mp_createdby =
        mapped_onboardingInterestReqJModel[DatingAppStaticParams.createdby];
    if (mp_createdby == null) {
      mapped_onboardingInterestReqJModel
          .remove(DatingAppStaticParams.createdby);

      var mp_approvedby =
          mapped_onboardingInterestReqJModel[DatingAppStaticParams.approvedby];
      if (mp_approvedby == null) {
        mapped_onboardingInterestReqJModel
            .remove(DatingAppStaticParams.approvedby);
      }

      var mp_user =
          mapped_onboardingInterestReqJModel[DatingAppStaticParams.user];
      if (mp_user == null) {
        mapped_onboardingInterestReqJModel.remove(DatingAppStaticParams.user);
      }

      var mp_approved =
          mapped_onboardingInterestReqJModel[DatingAppStaticParams.approved];
      if (mp_approved == null) {
        mapped_onboardingInterestReqJModel
            .remove(DatingAppStaticParams.approved);
      }

      var mp_approveddate = mapped_onboardingInterestReqJModel[
          DatingAppStaticParams.approveddate];
      if (mp_approveddate == null) {
        mapped_onboardingInterestReqJModel
            .remove(DatingAppStaticParams.approveddate);
      }

      var mp_active =
          mapped_onboardingInterestReqJModel[DatingAppStaticParams.active];
      if (mp_active == null) {
        mapped_onboardingInterestReqJModel.remove(DatingAppStaticParams.active);
      }

      var mp_hobby =
          mapped_onboardingInterestReqJModel[DatingAppStaticParams.hobby];
      if (mp_hobby == null) {
        mapped_onboardingInterestReqJModel.remove(DatingAppStaticParams.hobby);
      }

      Response hobbiePutresponse = null;
      if (isIntValid(onboardinginterestJoinClass.onboardinginterest.onlineid)) {
        print(TAG + 'PATCH');
        hobbiePutresponse = await Provider.of<PostApiService>(context)
            .patchOnboardingInterest(
                onboardinginterestJoinClass.onboardinginterest.onlineid,
                mapped_onboardingInterestReqJModel);
      } else {
        print(TAG + 'POST');
        hobbiePutresponse = await Provider.of<PostApiService>(context)
            .postOnboardingInterest(mapped_onboardingInterestReqJModel);
      }
      int statusCode = hobbiePutresponse.statusCode;
      if (isresponseSuccessfull(statusCode)) {
        try {
          print(TAG + 'responseSuccessfull');
          var respBody = hobbiePutresponse.body;
          print(respBody);
          OnboardingInterestRespJModel onboardingInterestRespJModel =
              OnboardingInterestRespJModel.fromJson(respBody);
          print(TAG +
              'onboardingInterestRespJModel onlineid==${onboardingInterestRespJModel.id}');
          bool issyncHobbie = await syncOnboardingInterest(
            context,
            onboardingInterestRespJModel,
            onboardinginterestJoinClass,
            navigationDataBLoC_Loader,
            onboardinginterestJoinClassList,
            list_index,
          );
          if (issyncHobbie) {
            if (snackBarBuildContext != null) {
              displaySnackBarWithDelay(
                  'Your interests saved', DatingAppTheme.green, snackBarBuildContext);
            }
          } else {
            if (snackBarBuildContext != null) {
              displaySnackBarWithDelay('An error occurred saving your interests',
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

Future<bool> syncOnboardingInterest(
  BuildContext context,
  OnboardingInterestRespJModel onboardingInterestRespJModel,
  OnboardinginterestJoinClass onboardinginterestJoinClass,
  NavigationDataBLoC navigationDataBLoC_Loader,
  List<OnboardinginterestJoinClass> onboardinginterestJoinClassList,
  int list_index,
) async {
  String TAG = 'post_put_onboardingInterest:syncOnboardingInterest:';
  print(TAG);

  AppDatabase database = Provider.of<AppDatabase>(context);
  OnboardinginterestDao onboardinginterestDao = database.onboardinginterestDao;

  Onboardinginterest onboardinginterest =
      onboardinginterestJoinClass.onboardinginterest;

  Onboardinginterest onboardinginterest_ToUpdate =
      onboardinginterest.copyWith(onlineid: onboardingInterestRespJModel.id);

  bool isUpdated = await onboardinginterestDao
      .updateOnboardinginterest(onboardinginterest_ToUpdate);

  if (isUpdated) {
    onboardinginterest = onboardinginterest_ToUpdate;
    if (onboardinginterestJoinClassList != null && list_index != null) {
      onboardinginterestJoinClassList[list_index].onboardinginterest =
          onboardinginterestJoinClassList[list_index]
              .onboardinginterest
              .copyWith(onlineid: onboardinginterest.onlineid);
    }
  }

  if (navigationDataBLoC_Loader != null) {
    refreshLoader(false, navigationDataBLoC_Loader);
  }
  return true;
}
