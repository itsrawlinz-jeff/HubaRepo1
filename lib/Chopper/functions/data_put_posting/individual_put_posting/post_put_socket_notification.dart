import 'dart:convert';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/notificationsmsg/SocketNotificationRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/notificationsmsg/SocketNotificationPatchReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> post_put_socket_notification(
    SocketNotificationRespJModel socketNotificationRespJModel,
    List<SocketNotificationRespJModel> socketNotificationRespJModelList,
    int index,
    NavigationDataBLoC navigationDataBLoC_ShowProgressDialog,
    BuildContext context) async {
  String TAG = 'postputSocketNotificationRespJModels:';
  print(TAG);
  refreshLoader(true, navigationDataBLoC_ShowProgressDialog);
  bool isNetConnActive = await isNetworkConnectionActive();
  if (isNetConnActive) {
    LoginRespModel loginRespJModel = await getSessionLoginRespModel(context);
    Response putPostresponse = null;

    if (isIntValid(socketNotificationRespJModel.id)) {
      print(TAG + 'PATCH');
      SocketNotificationPatchReqJModel socketNotificationPatchReqJModel =
          SocketNotificationPatchReqJModel();
      socketNotificationPatchReqJModel.read = socketNotificationRespJModel.read;

      print(TAG + ' SENDING${json.encode(socketNotificationPatchReqJModel)}');
      putPostresponse = await Provider.of<PostApiService>(context)
          .patchSocketNotificationRespJModels(
        DatingAppStaticParams.tokenWspace + loginRespJModel.token,
        socketNotificationRespJModel.id,
        //socketNotificationRespJModel,
        socketNotificationPatchReqJModel,
      );
    } else {
      print(TAG + 'POST');
      putPostresponse = await Provider.of<PostApiService>(context)
          .postSocketNotificationRespJModels(
        DatingAppStaticParams.tokenWspace + loginRespJModel.token,
        socketNotificationRespJModel,
      );
    }
    int statusCode = putPostresponse.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        print(TAG + 'responseSuccessfull');
        var respBody = putPostresponse.body;
        print(respBody);
        SocketNotificationRespJModel socketNotificationRespJModel =
            SocketNotificationRespJModel.fromJson(respBody);
        print(socketNotificationRespJModel);
        return true;
      } catch (error) {
        refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
        print(TAG + 'error==');
        print(error);
        return false;
      }
    } else {
      refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
      print(TAG + 'statusCode==${statusCode}');
      print(putPostresponse.body);
      print(putPostresponse.bodyString);
      return false;
    }
  } else {
    refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
    print(TAG + 'INTERNET CONNECTION NOT ACTIVE');
  }
}
