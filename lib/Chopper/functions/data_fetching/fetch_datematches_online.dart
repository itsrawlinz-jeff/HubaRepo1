import 'dart:developer';

import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/DateMatchListRespJModel.dart';
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

Future<DateMatchListRespJModel> fetch_datematches_online_limit(
  BuildContext context,
  String limit,
) async {
  String TAG = 'fetch_datematches_online_limit';
  print(TAG);
  LoginRespModel loginRespJModel = await getSessionLoginRespModel(context);
  try {
    Response response =
        await Provider.of<PostApiService>(context).get_Datematches_Auth_Limit(
      DatingAppStaticParams.tokenWspace + loginRespJModel.token,
      limit,
    );
    int statusCode = response.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        var respBody = response.body;
        DateMatchListRespJModel dateMatchListRespJModel =
            DateMatchListRespJModel.fromJson(respBody);
        print(TAG + ' success');
        return dateMatchListRespJModel;
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

Future<DateMatchListRespJModel>
    fetch_datematches_online_limit_by_isuserrequested(
  BuildContext context,
  String limit,
  String isuserrequested,
) async {
  String TAG = 'fetch_datematches_online_limit_by_isuserrequested';
  print(TAG);
  LoginRespModel loginRespJModel = await getSessionLoginRespModel(context);
  try {
    Response response = await Provider.of<PostApiService>(context)
        .get_Datematches_Auth_Limit_By_Isuserrequested(
      DatingAppStaticParams.tokenWspace + loginRespJModel.token,
      limit,
      isuserrequested,
    );
    int statusCode = response.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        var respBody = response.body;
        DateMatchListRespJModel dateMatchListRespJModel =
            DateMatchListRespJModel.fromJson(respBody);
        print(TAG + ' success');
        return dateMatchListRespJModel;
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

Future<DateMatchListRespJModel> fetch_datematches_online_limit_by_searchparam(
    BuildContext context, String limit, String searchparam) async {
  String TAG = 'fetch_datematches_online_limit_by_searchparam';
  print(TAG);
  LoginRespModel loginRespJModel = await getSessionLoginRespModel(context);
  try {
    Response response = await Provider.of<PostApiService>(context)
        .get_Datematches_Auth_Limit_By_Searchparam(
      DatingAppStaticParams.tokenWspace + loginRespJModel.token,
      limit,
      searchparam,
    );
    int statusCode = response.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        var respBody = response.body;
        DateMatchListRespJModel dateMatchListRespJModel =
            DateMatchListRespJModel.fromJson(respBody);
        print(TAG + ' success');
        return dateMatchListRespJModel;
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

Future<DateMatchListRespJModel>
    fetch_datematches_online_limit_by_searchparam_by_isuserrequested(
  BuildContext context,
  String limit,
  String searchparam,
  String isuserrequested,
) async {
  String TAG =
      'fetch_datematches_online_limit_by_searchparam_by_isuserrequested';
  print(TAG);
  LoginRespModel loginRespJModel = await getSessionLoginRespModel(context);
  try {
    Response response = await Provider.of<PostApiService>(context)
        .get_Datematches_Auth_Limit_By_Searchparam_By_Isuserrequested(
      DatingAppStaticParams.tokenWspace + loginRespJModel.token,
      limit,
      searchparam,
      isuserrequested,
    );
    int statusCode = response.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        var respBody = response.body;
        DateMatchListRespJModel dateMatchListRespJModel =
            DateMatchListRespJModel.fromJson(respBody);
        print(TAG + ' success');
        return dateMatchListRespJModel;
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

Future<DateMatchListRespJModel>
    fetch_datematches_online_by_isuserrequested_loadnext(
  BuildContext context,
  String nextUrl,
) async {
  String TAG = 'fetch_datematches_online_by_isuserrequested_loadnext:';
  print(TAG);
  LoginRespModel loginRespModel = await getSessionLoginRespModel(context);
  try {
    Map<String, dynamic> headers = Map();
    headers[DatingAppStaticParams.authorizationConst] =
        DatingAppStaticParams.tokenWspace + loginRespModel.token;

    dio.Response response = await Provider.of<dio.Dio>(context)
        .get(nextUrl, options: dio.Options(headers: headers));

    int statusCode = response.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        var respBody = response.data;
        DateMatchListRespJModel dateMatchListRespJModel =
            DateMatchListRespJModel.fromJson(respBody);
        return dateMatchListRespJModel;
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
    print(TAG + ' getErpTickets_Limit error==');
    print(error);
    return null;
  }
}

Future<DateMatchListRespJModel> fetch_datematches_online_by_approved_active(
  BuildContext context,
  String approved,
  String active,
) async {
  String TAG = 'fetch_datematches_online_by_approved_active';
  print(TAG);
  LoginRespModel loginRespJModel = await getSessionLoginRespModel(context);
  try {
    Response response = await Provider.of<PostApiService>(context)
        .get_Datematches_Auth_By_Active_Approved(
      DatingAppStaticParams.tokenWspace + loginRespJModel.token,
      approved,
      active,
    );
    int statusCode = response.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        var respBody = response.body;
        DateMatchListRespJModel dateMatchListRespJModel =
            DateMatchListRespJModel.fromJson(respBody);
        print(TAG + ' success');
        return dateMatchListRespJModel;
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
