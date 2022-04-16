import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_put_onboardingUserIllness.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/JoinClasses/OnboardinguserillnessJoinClass.dart';
import 'package:flutter/material.dart';

Future<bool> batch_post_put_onboardingUserIllness(
  BuildContext context,
  BuildContext snackBarBuildContext,
  Onboarding onboarding,
  NavigationDataBLoC navigationDataBLoC_ShowProgressDialog,
  List<OnboardinguserillnessJoinClass> onboardinguserillnessJoinClassList,
) async {
  String TAG = 'batch_post_put_onboardingUserIllness:';
  print(TAG);
  for (int i = 0; i < onboardinguserillnessJoinClassList.length; i++) {
    OnboardinguserillnessJoinClass onboardinguserillnessJoinClass =
        onboardinguserillnessJoinClassList[i];
    await post_put_onboardingUserIllness(
      context,
      snackBarBuildContext,
      onboarding,
      onboardinguserillnessJoinClass,
      onboardinguserillnessJoinClassList,
      navigationDataBLoC_ShowProgressDialog,
      i,
    );
  }

  return true;
}
