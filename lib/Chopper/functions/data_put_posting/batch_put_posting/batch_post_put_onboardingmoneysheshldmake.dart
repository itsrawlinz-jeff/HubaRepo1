import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_put_onboardingMoneySheShldmake.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/JoinClasses/OnboardingmoneyshemakesJoinClass.dart';
import 'package:flutter/material.dart';

Future<bool> batch_post_put_onboardingMoneySheShldmake(
  BuildContext context,
  BuildContext snackBarBuildContext,
  Onboarding onboarding,
  NavigationDataBLoC navigationDataBLoC_ShowProgressDialog,
  List<OnboardingmoneyshemakesJoinClass> onboardingmoneyshemakesJoinClassList,
) async {
  String TAG = 'batch_post_put_onboardingMoneySheShldmake:';
  print(TAG);
  for (int i = 0; i < onboardingmoneyshemakesJoinClassList.length; i++) {
    OnboardingmoneyshemakesJoinClass onboardingmoneyshemakesJoinClass =
        onboardingmoneyshemakesJoinClassList[i];
    await post_put_onboardingMoneySheShldmake(
      context,
      snackBarBuildContext,
      onboarding,
      onboardingmoneyshemakesJoinClass,
      onboardingmoneyshemakesJoinClassList,
      navigationDataBLoC_ShowProgressDialog,
      i,
    );
  }

  return true;
}
