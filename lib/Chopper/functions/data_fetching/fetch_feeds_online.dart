import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/FeedsListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/MatchDecisionListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';
import 'package:dio/dio.dart' as dio;

Future<FeedsListRespJModel> fetch_feeds_online_by_userid_limit(
  BuildContext context,
  String limit,
  int userdid,
) async {
  String TAG = 'fetch_feeds_online_by_userid_limit';
  print(TAG);
  LoginRespModel loginRespJModel = await getSessionLoginRespModel(context);
  try {
    Response response =
        await Provider.of<PostApiService>(context).getfeeds_by_userid_limit(
      DatingAppStaticParams.tokenWspace + loginRespJModel.token,
      limit,
      userdid,
    );
    int statusCode = response.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        var respBody = response.body;
        FeedsListRespJModel feedsListRespJModel =
            FeedsListRespJModel.fromJson(respBody);
        print(TAG + ' success');
        return feedsListRespJModel;
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


Future<FeedsListRespJModel> fetch_feeds_load_next(
    BuildContext context, String nextUrl
    ) async {
  String TAG = 'fetch_feeds_load_next';
  print(TAG);
  LoginRespModel loginRespJModel = await getSessionLoginRespModel(context);
  try {
    Map<String, dynamic> headers = Map();
    headers[DatingAppStaticParams.authorizationConst] =
        DatingAppStaticParams.tokenWspace + loginRespJModel.token;

    dio.Response response = await Provider.of<dio.Dio>(context)
        .get(nextUrl, options: dio.Options(headers: headers));

    int statusCode = response.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        var respBody = response.data;
        FeedsListRespJModel feedsListRespJModel =
        FeedsListRespJModel.fromJson(respBody);
        return feedsListRespJModel;
      } catch (error) {
        print(TAG + ' error==');
        print(error);
        return null;
      }
    } else {
      print(TAG + ' statusCode==${statusCode}');
      print(TAG + ' response bodyString==${response.data.toString()}');
      return null;
    }
  } catch (error) {
    print(TAG + ' error==');
    print(error);
    return null;
  }
}