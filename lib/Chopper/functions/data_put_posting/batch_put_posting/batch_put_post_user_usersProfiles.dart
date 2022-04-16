import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/put_post_user_usersProfiles.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/user_profiles/UserUserProfileReqJModel.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/material.dart';

Future<bool> batch_put_post_user_usersProfiles(
  BuildContext context,
  NavigationDataBLoC navigationDataBLoC_ShowProgressDialog,
  List<UserUserProfileReqJModel> userUserProfileReqJModelList,
) async {
  String TAG = 'batch_put_post_user_usersProfiles:';
  print(TAG);
  for (int i = 0; i < userUserProfileReqJModelList.length; i++) {
    UserUserProfileReqJModel userUserProfileReqJModel =
        userUserProfileReqJModelList[i];
    if (userUserProfileReqJModel.issettobeupdated != null &&
        userUserProfileReqJModel.issettobeupdated &&
        isStringValid(userUserProfileReqJModel.localfilepath)) {
      await put_post_user_usersProfiles(
        context,
        navigationDataBLoC_ShowProgressDialog,
        userUserProfileReqJModel,
        userUserProfileReqJModelList,
        i,
        null,
      );
    }
  }

  return true;
}
