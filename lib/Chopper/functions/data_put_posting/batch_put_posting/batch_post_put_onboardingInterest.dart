import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_put_onboardingInterest.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/JoinClasses/OnboardinginterestJoinClass.dart';
import 'package:flutter/material.dart';

Future<bool> batch_post_put_onboardingInterest(
  BuildContext context,
  BuildContext snackBarBuildContext,
  Onboarding onboarding,
  NavigationDataBLoC navigationDataBLoC_ShowProgressDialog,
  List<OnboardinginterestJoinClass> onboardinginterestJoinClassList,
) async {
  String TAG = 'batch_post_put_onboardingInterest:';
  print(TAG);
  for (int i = 0; i < onboardinginterestJoinClassList.length; i++) {
    OnboardinginterestJoinClass onboardinginterestJoinClass =
        onboardinginterestJoinClassList[i];
    await post_put_onboardingInterest(
      context,
      snackBarBuildContext,
      onboarding,
      onboardinginterestJoinClass,
      onboardinginterestJoinClassList,
      navigationDataBLoC_ShowProgressDialog,
      i,
    );
  }

  return true;
}
