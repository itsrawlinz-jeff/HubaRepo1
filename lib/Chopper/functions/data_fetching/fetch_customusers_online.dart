import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';

Future<CustomUserListRespJModel> fetch_customusers_online_limit(
  BuildContext context,
  String limit,
) async {
  String TAG = 'fetch_customusers_online_limit';
  print(TAG);
  LoginRespModel loginRespJModel = await getSessionLoginRespModel(context);
  try {
    Response response =
        await Provider.of<PostApiService>(context).getCustomusers_WO_Auth_Limit(
      //DatingAppStaticParams.tokenWspace + loginRespJModel.token,
      limit,
    );
    int statusCode = response.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        var respBody = response.body;
        CustomUserListRespJModel customUserListRespJModel =
            CustomUserListRespJModel.fromJson(respBody);
        print(TAG + ' success');
        return customUserListRespJModel;
      } catch (error) {
        print(TAG + ' error==');
        print(error);
        return null;
      }
    } else {
      print(TAG + ' statusCode==${statusCode}');
      print(TAG + ' response bodyString==${response.bodyString}');
      return null;
    }
  } catch (error) {
    print(TAG + ' getOnlineUsers error==');
    print(error);
    return null;
  }
}

Future<CustomUserRespJModel> fetch_customuser_online_by_id(
  BuildContext context,
  int id,
) async {
  String TAG = 'fetch_customuser_online_by_id';
  print(TAG);
  try {
    Response response =
        await Provider.of<PostApiService>(context).getCustomuser_WO_Auth_By_Id(
      id,
    );
    int statusCode = response.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        var respBody = response.body;
        CustomUserRespJModel customUserRespJModel =
            CustomUserRespJModel.fromJson(respBody);
        print(TAG + ' success');
        return customUserRespJModel;
      } catch (error) {
        print(TAG + ' error==');
        print(error);
        return null;
      }
    } else {
      print(TAG + ' statusCode==${statusCode}');
      print(TAG + ' response bodyString==${response.bodyString}');
      return null;
    }
  } catch (error) {
    print(TAG + ' getOnlineUsers error==');
    print(error);
    return null;
  }
}
