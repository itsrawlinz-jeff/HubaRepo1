import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/messages/MessageRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/messages/MessageReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool> post_put_chat(
  MessageRespJModel messageRespJModel,
  List<MessageRespJModel> messageRespJModelList,
  int index,
  NavigationDataBLoC loginBtnPageBLoC,
  BuildContext context,
  ScrollController listviewScrollController,
  TextEditingController textFieldController,
  bool isInLayout,
  NavigationDataBLoC dailyImagesBLoC,
) async {
  String TAG = 'post_put_chat:';
  print(TAG);
  show_hide_loader(true,loginBtnPageBLoC);
  bool isNetConnActive = await isNetworkConnectionActive();
  if (isNetConnActive) {
    LoginRespModel loginRespJModel = await getSessionLoginRespModel(context);
    Response putPostresponse = null;

    MessageReqJModel messageReqJModel = MessageReqJModel();
    messageReqJModel.id = messageRespJModel.id;
    messageReqJModel.receiver = messageRespJModel.receiver.id;
    messageReqJModel.author = messageRespJModel.author.id;
    messageReqJModel.read = messageRespJModel.read;
    messageReqJModel.content = messageRespJModel.content;
    messageReqJModel.created_at = messageRespJModel.created_at;

    if (isIntValid(messageRespJModel.id)) {
      print(TAG + 'PATCH');
      putPostresponse =
          await Provider.of<PostApiService>(context).patchMessageRespJModels(
        DatingAppStaticParams.tokenWspace + loginRespJModel.token,
        messageRespJModel.id,
        messageReqJModel,
      );
    } else {
      print(TAG + 'POST');
      putPostresponse =
          await Provider.of<PostApiService>(context).postMessageRespJModels(
        DatingAppStaticParams.tokenWspace + loginRespJModel.token,
        messageReqJModel,
      );
    }
    int statusCode = putPostresponse.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        print(TAG + 'responseSuccessfull');
        var respBody = putPostresponse.body;
        print(respBody);
        MessageRespJModel messageRespJModelResp =
            MessageRespJModel.fromJson(respBody);
        bool issyncMessageRespJModel = await syncMessageRespJModel(
          context,
          messageRespJModel,
          messageRespJModelList,
          messageRespJModelResp,
          index,
          loginBtnPageBLoC,
          listviewScrollController,
          textFieldController,
          isInLayout,
          dailyImagesBLoC,
        );

        return issyncMessageRespJModel;
      } catch (error) {
        show_hide_loader(false,loginBtnPageBLoC);
        print(TAG + 'error==');
        print(error);
        if (isInLayout) {
          showMessageIfInLayout('An error occurred');
        }
        return false;
      }
    } else {
      print(TAG + 'statusCode==${statusCode}');
      print(putPostresponse.body);
      print(putPostresponse.bodyString);
      show_hide_loader(false,loginBtnPageBLoC);
      if (isresponse400(statusCode)) {
        if (isInLayout) {
          showMessageIfInLayout('Connection error');
        }
      } else {
        if (isInLayout) {
          showMessageIfInLayout('Connection error');
        }
      }
      return false;
    }
  } else {
    show_hide_loader(false,loginBtnPageBLoC);
    print(TAG + 'INTERNET CONNECTION NOT ACTIVE');
    if (isInLayout) {
      showMessageIfInLayout('Connection error');
    }
  }
}

Future<bool> syncMessageRespJModel(
  BuildContext context,
  MessageRespJModel messageRespJModel,
  List<MessageRespJModel> messageRespJModelList,
  MessageRespJModel messageRespJModelResp,
  int index,
    NavigationDataBLoC loginBtnPageBLoC,
  ScrollController listviewScrollController,
  TextEditingController textFieldController,
  bool isInLayout,
  NavigationDataBLoC dailyImagesBLoC,
) async {
  String TAG = 'syncMessageRespJModels:';
  messageRespJModel.id = messageRespJModelResp.id;
  messageRespJModel.created_at = messageRespJModelResp.created_at;

  try {
    if (messageRespJModelList != null && messageRespJModelList.length > 0) {
      messageRespJModelList[index] = messageRespJModel;
    }
  } catch (error) {
    print(syncMessageRespJModel);
    print(error);
  }

  if (listviewScrollController != null) {
    listviewScrollController.animateTo(
        listviewScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut);
  }

  if (textFieldController != null) {
    textFieldController.text = '';
  }

  if (dailyImagesBLoC != null) {
    refresh_WO_Data_NavigationDataBLoC(dailyImagesBLoC);
  }

  show_hide_loader(false, loginBtnPageBLoC);

  return true;
}

showMessageIfInLayout(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
  );
}

show_hide_loader(
  bool isShow,
  NavigationDataBLoC loginBtnPageBLoC,
) {
  if (loginBtnPageBLoC != null) {
    NavigationData navigationData = NavigationData();
    navigationData.isShow = isShow;
    refresh_W_Data_NavigationDataBLoC(loginBtnPageBLoC, navigationData);
  }
}
