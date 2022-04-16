import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_put_onboardingInterest.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_put_onboardingSomethingSpecific.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserPostPutRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/OnboardingsomethingspecificReqJModel.dart';
import 'package:flutter/material.dart';

Future<bool> batch_post_put_onboardingSomethingSpecific(
  BuildContext context,
  BuildContext snackBarBuildContext,
  Onboarding onboarding,
  NavigationDataBLoC navigationDataBLoC_ShowProgressDialog,
  List<OnboardingsomethingspecificReqJModel> onboardinginterestReqJModelList,
) async {
  String TAG = 'batch_post_put_onboardingInterest:';
  print(TAG);
  for (int i = 0; i < onboardinginterestReqJModelList.length; i++) {
    OnboardingsomethingspecificReqJModel onboardinginterestReqJModel =
        onboardinginterestReqJModelList[i];
    await post_put_onboardingSomethingSpecific(
      context,
      snackBarBuildContext,
      onboarding,
      onboardinginterestReqJModel,
      navigationDataBLoC_ShowProgressDialog,
    );
  }

  return true;
}
