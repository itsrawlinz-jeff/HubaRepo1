import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/gender/GenderListRespModel.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';

Future<GenderListRespModel> fetch_genders_online_limit(
  BuildContext context,
  String limit,
  String excludeprefernottosay,
) async {
  String TAG = 'fetch_genders_online_limit';
  print(TAG);

  try {
    Response response = await Provider.of<PostApiService>(context).gender(
      limit,
    );
    int statusCode = response.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        var respBody = response.body;
        GenderListRespModel genderListRespModel =
            GenderListRespModel.fromJson(respBody);
        print(TAG + ' success');
        return genderListRespModel;
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

Future<GenderListRespModel> fetch_genders_online_limit_without_prefernottosay(
  BuildContext context,
  String limit,
  String excludeprefernottosay,
) async {
  String TAG = 'fetch_genders_online_limit_without_prefernottosay';
  print(TAG);

  try {
    Response response =
        await Provider.of<PostApiService>(context).gender_excludeprefernotsay(
      limit,
      excludeprefernottosay,
    );
    int statusCode = response.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        var respBody = response.body;
        GenderListRespModel genderListRespModel =
            GenderListRespModel.fromJson(respBody);
        print(TAG + ' success');
        return genderListRespModel;
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
