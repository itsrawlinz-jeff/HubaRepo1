import 'package:dating_app/Chopper/data/post_api_service.dart';
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

Future<MatchDecisionListRespJModel> fetch_datematchdecisions_online_limit(
  BuildContext context,
  String limit,
) async {
  String TAG = 'fetch_datematchdecisions_online_limit';
  print(TAG);
  LoginRespModel loginRespJModel = await getSessionLoginRespModel(context);
  try {
    Response response = await Provider.of<PostApiService>(context)
        .get_DatematchDecisions_Auth_Limit(
      DatingAppStaticParams.tokenWspace + loginRespJModel.token,
      limit,
    );
    int statusCode = response.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        var respBody = response.body;
        MatchDecisionListRespJModel matchDecisionListRespJModel =
            MatchDecisionListRespJModel.fromJson(respBody);
        print(TAG + ' success');
        return matchDecisionListRespJModel;
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

Future<MatchDecisionListRespJModel>
    fetch_datematchdecisions_online_limit_without_nope(
  BuildContext context,
  String limit,
  String excludenope,
) async {
  String TAG = 'fetch_datematchdecisions_online_limit_without_nope';
  print(TAG);
  LoginRespModel loginRespJModel = await getSessionLoginRespModel(context);
  try {
    Response response = await Provider.of<PostApiService>(context)
        .get_DatematchDecisions_Auth_Limit_WithoutNope(
      DatingAppStaticParams.tokenWspace + loginRespJModel.token,
      limit,
      excludenope,
    );
    int statusCode = response.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        var respBody = response.body;
        MatchDecisionListRespJModel matchDecisionListRespJModel =
            MatchDecisionListRespJModel.fromJson(respBody);
        print(TAG + ' success');
        return matchDecisionListRespJModel;
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
