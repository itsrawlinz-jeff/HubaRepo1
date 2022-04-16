import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingDao.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/user_profiles/UserUserProfileReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';

Future<UserUserProfileReqJModel> put_post_user_usersProfiles(
  BuildContext context,
  NavigationDataBLoC navigationDataBLoC_ShowProgressDialog,
  UserUserProfileReqJModel userUserProfileReqJModel,
  List<UserUserProfileReqJModel> userUserProfileReqJModelList,
  int index,
  bool isprofilepicture,
) async {
  String TAG = 'put_post_user_usersProfiles:';
  print(TAG);
  try {
    refreshLoader(true, navigationDataBLoC_ShowProgressDialog);
    LoginRespModel loginRespModel = await getSessionLoginRespModel(context);
    Response response = null;
    if (isIntValid(userUserProfileReqJModel.id)) {
      print(TAG + 'PATCH');
      print(userUserProfileReqJModel.id.toString());

      if (isprofilepicture != null) {
        response =
            await Provider.of<PostApiService>(context).patchUsersProfiles(
          userUserProfileReqJModel.id,
          true,
          userUserProfileReqJModel.localfilepath,
          isprofilepicture,
          ((loginRespModel != null && loginRespModel.id != null
              ? loginRespModel.id
              : userUserProfileReqJModel != null
                  ? userUserProfileReqJModel.users
                  : null)),
          ((loginRespModel != null && loginRespModel.id != null
              ? loginRespModel.id
              : userUserProfileReqJModel != null
                  ? userUserProfileReqJModel.users
                  : null)),
        );
      } else {
        response = await Provider.of<PostApiService>(context)
            .patchUsersProfiles_WO_isprofilepicture(
          userUserProfileReqJModel.id,
          true,
          userUserProfileReqJModel.localfilepath,
          ((loginRespModel != null && loginRespModel.id != null
              ? loginRespModel.id
              : userUserProfileReqJModel != null
                  ? userUserProfileReqJModel.users
                  : null)),
          ((loginRespModel != null && loginRespModel.id != null
              ? loginRespModel.id
              : userUserProfileReqJModel != null
                  ? userUserProfileReqJModel.users
                  : null)),
        );
      }
    } else {
      print(TAG + 'POST');
      if (isprofilepicture != null) {
        response = await Provider.of<PostApiService>(context).postUsersProfiles(
          true,
          userUserProfileReqJModel.localfilepath,
          isprofilepicture,
          ((loginRespModel != null && loginRespModel.id != null
              ? loginRespModel.id
              : userUserProfileReqJModel != null
                  ? userUserProfileReqJModel.users
                  : null)),
          ((loginRespModel != null && loginRespModel.id != null
              ? loginRespModel.id
              : userUserProfileReqJModel != null
                  ? userUserProfileReqJModel.users
                  : null)),
        );
      } else {
        response = await Provider.of<PostApiService>(context)
            .postUsersProfiles_WO_isprofilepicture(
          true,
          userUserProfileReqJModel.localfilepath,
          ((loginRespModel != null && loginRespModel.id != null
              ? loginRespModel.id
              : userUserProfileReqJModel != null
                  ? userUserProfileReqJModel.users
                  : null)),
          ((loginRespModel != null && loginRespModel.id != null
              ? loginRespModel.id
              : userUserProfileReqJModel != null
                  ? userUserProfileReqJModel.users
                  : null)),
        );
      }
    }
    int statusCode = response.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        var respBody = response.body;
        print(TAG + ' respBody==${respBody.toString()}');
        UserUserProfileReqJModel userUserProfileReqJModel_frmServer =
            UserUserProfileReqJModel.fromJson(respBody);
        userUserProfileReqJModel.id = userUserProfileReqJModel_frmServer.id;
        userUserProfileReqJModel.createdate =
            userUserProfileReqJModel_frmServer.createdate;
        userUserProfileReqJModel.txndate =
            userUserProfileReqJModel_frmServer.txndate;
        userUserProfileReqJModel.approved =
            userUserProfileReqJModel_frmServer.approved;
        userUserProfileReqJModel.approveddate =
            userUserProfileReqJModel_frmServer.approveddate;
        userUserProfileReqJModel.active =
            userUserProfileReqJModel_frmServer.active;
        userUserProfileReqJModel.picture =
            userUserProfileReqJModel_frmServer.picture;
        userUserProfileReqJModel.isprofilepicture =
            userUserProfileReqJModel_frmServer.isprofilepicture;
        userUserProfileReqJModel.createdby =
            userUserProfileReqJModel_frmServer.createdby;
        userUserProfileReqJModel.approvedby =
            userUserProfileReqJModel_frmServer.approvedby;
        userUserProfileReqJModel.users =
            userUserProfileReqJModel_frmServer.users;
        userUserProfileReqJModel.issettobeupdated = false;

        if (userUserProfileReqJModelList != null) {
          userUserProfileReqJModelList[index] = userUserProfileReqJModel;
        }
        refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
        return userUserProfileReqJModel;
      } catch (error) {
        print(TAG + 'error==');
        print(error);
        refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
        return userUserProfileReqJModel;
      }
    } else {
      print(TAG + 'statusCode==${statusCode.toString()}');
      print(TAG + ' taskresponse.bodyString==');
      print(response.bodyString);
      refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
      return userUserProfileReqJModel;
    }
  } catch (error) {
    print(TAG + ' error==');
    print(error.toString());
    return userUserProfileReqJModel;
  }
}
