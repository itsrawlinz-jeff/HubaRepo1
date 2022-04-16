import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/user_profiles/UserProfileListRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/user_profiles/UserUserProfileListReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/user_profiles/UserUserProfileReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';

Future<List<UserUserProfileReqJModel>> fetch_user_usersProfiles(
  BuildContext context,
  NavigationDataBLoC navigationDataBLoC_ShowProgressDialog,
  String limit,
) async {
  refreshLoader(true, navigationDataBLoC_ShowProgressDialog);
  String TAG = 'fetch_user_usersProfiles:';

  List<UserUserProfileReqJModel> userUserProfileReqJModelList = [];
  LoginRespModel loginRespModel = await getSessionLoginRespModel(context);
  print(TAG + ' loginRespModel.id==');
  print(loginRespModel.id.toString());

  Response response =
      await Provider.of<PostApiService>(context).user_usersProfiles(
    loginRespModel.id,
    limit,
  );
  int statusCode = response.statusCode;
  if (isresponseSuccessfull(statusCode)) {
    try {
      var respBody = response.body;

      UserUserProfileListReqJModel userUserProfileListReqJModel =
          UserUserProfileListReqJModel.fromJson(respBody);
      userUserProfileReqJModelList = userUserProfileListReqJModel.results;
      /*userUserProfileReqJModelList = (respBody as List)
          .map((i) => UserUserProfileReqJModel.fromJson(i))
          .toList();*/
      print(TAG +
          'tasksListRespJModel count==${userUserProfileReqJModelList.length}');
      refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
      return userUserProfileReqJModelList;
    } catch (error) {
      print(TAG + 'error==');
      print(error);
      refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
      return userUserProfileReqJModelList;
    }
  } else {
    print(TAG + 'statusCode==${statusCode.toString()}');
    print(TAG + ' taskresponse.bodyString==');
    print(response.bodyString);
    refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
    return userUserProfileReqJModelList;
  }
}

Future<List<UserProfileRespModel>> fetch_user_usersProfiles_By_UserId(
  BuildContext context,
  NavigationDataBLoC navigationDataBLoC_ShowProgressDialog,
  int userid,
  String limit,
) async {
  if (navigationDataBLoC_ShowProgressDialog != null) {
    refreshLoader(true, navigationDataBLoC_ShowProgressDialog);
  }
  String TAG = 'fetch_user_usersProfiles:';

  List<UserProfileRespModel> userUserProfileReqJModelList = [];
  LoginRespModel loginRespModel = await getSessionLoginRespModel(context);
  print(TAG + ' loginRespModel.id==');
  print(loginRespModel.id.toString());

  Response response =
      await Provider.of<PostApiService>(context).user_usersProfiles(
    userid,
    limit,
  );
  int statusCode = response.statusCode;
  if (isresponseSuccessfull(statusCode)) {
    try {
      var respBody = response.body;

      UserProfileListRespModel userUserProfileListReqJModel =
          UserProfileListRespModel.fromJson(respBody);
      userUserProfileReqJModelList = userUserProfileListReqJModel.results;

      print(TAG +
          'userUserProfileReqJModelList count==${userUserProfileReqJModelList.length}');
      if (navigationDataBLoC_ShowProgressDialog != null) {
        refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
      }
      return userUserProfileReqJModelList;
    } catch (error) {
      print(TAG + 'error==');
      print(error);
      if (navigationDataBLoC_ShowProgressDialog != null) {
        refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
      }
      return userUserProfileReqJModelList;
    }
  } else {
    print(TAG + 'statusCode==${statusCode.toString()}');
    print(TAG + ' response.bodyString==');
    print(response.bodyString);
    if (navigationDataBLoC_ShowProgressDialog != null) {
      refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
    }
    return userUserProfileReqJModelList;
  }
}

Future<List<UserUserProfileReqJModel>>
    fetch_user_usersProfiles_By_Limit_UserId_Isprofilepicture(
  BuildContext context,
  NavigationDataBLoC navigationDataBLoC_ShowProgressDialog,
  String limit,
  String isprofilepicture,
) async {
  refreshLoader(true, navigationDataBLoC_ShowProgressDialog);
  String TAG = 'fetch_user_usersProfiles_By_Limit_UserId_Isprofilepicture:';

  List<UserUserProfileReqJModel> userUserProfileReqJModelList = [];
  LoginRespModel loginRespModel = await getSessionLoginRespModel(context);
  print(TAG + ' loginRespModel.id==');
  print(loginRespModel.id.toString());

  Response response = await Provider.of<PostApiService>(context)
      .user_usersProfiles_limit_pictures(
    loginRespModel.id,
    isprofilepicture,
    limit,
  );
  int statusCode = response.statusCode;
  if (isresponseSuccessfull(statusCode)) {
    try {
      var respBody = response.body;

      UserUserProfileListReqJModel userUserProfileListReqJModel =
          UserUserProfileListReqJModel.fromJson(respBody);
      userUserProfileReqJModelList = userUserProfileListReqJModel.results;

      refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
      return userUserProfileReqJModelList;
    } catch (error) {
      print(TAG + 'error==');
      print(error);
      refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
      return userUserProfileReqJModelList;
    }
  } else {
    print(TAG + 'statusCode==${statusCode.toString()}');
    print(TAG + ' taskresponse.bodyString==');
    print(response.bodyString);
    refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
    return userUserProfileReqJModelList;
  }
}
