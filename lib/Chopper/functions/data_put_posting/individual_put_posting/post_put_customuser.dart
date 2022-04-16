import 'dart:developer';

import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/users/CustomUserReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';

Future<CustomUserRespJModel> post_put_customuser(
  BuildContext context,
  BuildContext snackbarBuildContext,
  NavigationDataBLoC navigationDataBLoC_ShowProgressDialog,
  CustomUserReqJModel customUserReqJModel,
) async {
  String TAG = 'post_put_customuser:';
  print(TAG);
  try {
    String action_performed = '';
    refreshLoader_with_isSaved(
        true, false, navigationDataBLoC_ShowProgressDialog);
    LoginRespModel loginRespJModel = await getSessionLoginRespModel(context);

    Map<String, dynamic> mapped_CustomUserReqJModel =
        customUserReqJModel.toJson();

    var name = mapped_CustomUserReqJModel[DatingAppStaticParams.name];
    if (name == null) {
      mapped_CustomUserReqJModel.remove(DatingAppStaticParams.name);
    }

    var first_name =
        mapped_CustomUserReqJModel[DatingAppStaticParams.first_name];
    if (first_name == null) {
      mapped_CustomUserReqJModel.remove(DatingAppStaticParams.first_name);
    }

    var last_name = mapped_CustomUserReqJModel[DatingAppStaticParams.last_name];
    if (last_name == null) {
      mapped_CustomUserReqJModel.remove(DatingAppStaticParams.last_name);
    }

    var email = mapped_CustomUserReqJModel[DatingAppStaticParams.email];
    if (email == null) {
      mapped_CustomUserReqJModel.remove(DatingAppStaticParams.email);
    }

    var username = mapped_CustomUserReqJModel[DatingAppStaticParams.username];
    if (username == null) {
      mapped_CustomUserReqJModel.remove(DatingAppStaticParams.username);
    }

    var phone_number =
        mapped_CustomUserReqJModel[DatingAppStaticParams.phone_number];
    if (phone_number == null) {
      mapped_CustomUserReqJModel.remove(DatingAppStaticParams.phone_number);
    }

    var picture = mapped_CustomUserReqJModel[DatingAppStaticParams.picture];
    if (picture == null) {
      mapped_CustomUserReqJModel.remove(DatingAppStaticParams.picture);
    }

    var createdate =
        mapped_CustomUserReqJModel[DatingAppStaticParams.createdate];
    if (createdate == null) {
      mapped_CustomUserReqJModel.remove(DatingAppStaticParams.createdate);
    }

    var txndate = mapped_CustomUserReqJModel[DatingAppStaticParams.txndate];
    if (txndate == null) {
      mapped_CustomUserReqJModel.remove(DatingAppStaticParams.txndate);
    }

    var approved = mapped_CustomUserReqJModel[DatingAppStaticParams.approved];
    if (approved == null) {
      mapped_CustomUserReqJModel.remove(DatingAppStaticParams.approved);
    }

    var quote = mapped_CustomUserReqJModel[DatingAppStaticParams.quote];
    if (quote == null) {
      mapped_CustomUserReqJModel.remove(DatingAppStaticParams.quote);
    }

    var age = mapped_CustomUserReqJModel[DatingAppStaticParams.age];
    if (age == null) {
      mapped_CustomUserReqJModel.remove(DatingAppStaticParams.age);
    }

    var fb_link = mapped_CustomUserReqJModel[DatingAppStaticParams.fb_link];
    if (fb_link == null) {
      mapped_CustomUserReqJModel.remove(DatingAppStaticParams.fb_link);
    }

    var insta_link =
        mapped_CustomUserReqJModel[DatingAppStaticParams.insta_link];
    if (insta_link == null) {
      mapped_CustomUserReqJModel.remove(DatingAppStaticParams.insta_link);
    }

    var date_match_mode =
        mapped_CustomUserReqJModel[DatingAppStaticParams.date_match_mode];
    if (date_match_mode == null) {
      mapped_CustomUserReqJModel.remove(DatingAppStaticParams.date_match_mode);
    }

    Response response = null;
    if (isIntValid(customUserReqJModel.id)) {
      action_performed = 'updating';
      print(TAG + 'PATCH');
      response = await Provider.of<PostApiService>(context).patchCustomuser(
        //DatingAppStaticParams.tokenWspace + loginRespJModel.token,
        customUserReqJModel.id,
        mapped_CustomUserReqJModel,
      );
    } else {
      action_performed = 'creating a';
      print(TAG + 'POST');
      response = await Provider.of<PostApiService>(context).postCustomuser(
        // DatingAppStaticParams.tokenWspace + loginRespJModel.token,
        mapped_CustomUserReqJModel,
      );
    }
    int statusCode = response.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        var respBody = response.body;
        CustomUserRespJModel customUserRespJModel =
            CustomUserRespJModel.fromJson(respBody);

        refreshLoader_with_isSaved(
            false, true, navigationDataBLoC_ShowProgressDialog);
        showSnackbarWBgCol_If_Context('Success ${action_performed} profile',
            snackbarBuildContext, DatingAppTheme.green);
        return customUserRespJModel;
      } catch (error) {
        print(TAG + 'error==');
        print(error);
        refreshLoader_with_isSaved(
            false, false, navigationDataBLoC_ShowProgressDialog);
        showSnackbarWBgCol_If_Context(
            'An error occurred', snackbarBuildContext, DatingAppTheme.red);
        return null;
      }
    } else {
      print(TAG + 'statusCode==${statusCode.toString()}');
      print(TAG + ' taskresponse.bodyString==');
      print(response.bodyString);
      refreshLoader_with_isSaved(
          false, false, navigationDataBLoC_ShowProgressDialog);
      showSnackbarWBgCol_If_Context(
          'An error occurred', snackbarBuildContext, DatingAppTheme.red);
      return null;
    }
  } catch (error) {
    print(TAG + ' error==');
    print(error.toString());
    refreshLoader_with_isSaved(
        false, false, navigationDataBLoC_ShowProgressDialog);
    showSnackbarWBgCol_If_Context(
        'An error occurred', snackbarBuildContext, DatingAppTheme.red);
    return null;
  }
}
