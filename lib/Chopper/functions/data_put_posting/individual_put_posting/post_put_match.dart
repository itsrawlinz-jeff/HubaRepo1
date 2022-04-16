import 'dart:convert';
import 'dart:developer';

import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingDao.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/DateMatchRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/matches/DateMatchReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/user_profiles/UserUserProfileReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';

Future<DateMatchRespJModel> post_put_user_Match(
  BuildContext context,
  BuildContext snackbarBuildContext,
  NavigationDataBLoC navigationDataBLoC_ShowProgressDialog,
  DateMatchReqJModel dateMatchReqJModel,bool isUserRequest
) async {
  String TAG = 'post_put_user_Match:';
  print(TAG);
  try {
    String action_performed = '';
    refreshLoader(true, navigationDataBLoC_ShowProgressDialog);
    LoginRespModel loginRespJModel = await getSessionLoginRespModel(context);

    Map<String, dynamic> mapped_DateMatchReqJModel =
        dateMatchReqJModel.toJson();

    var createdby = mapped_DateMatchReqJModel[DatingAppStaticParams.createdby];
    if (createdby == null) {
      mapped_DateMatchReqJModel[DatingAppStaticParams.createdby] =
          loginRespJModel.id;
    }

    var match_to = mapped_DateMatchReqJModel[DatingAppStaticParams.match_to];
    if (match_to == null) {
      mapped_DateMatchReqJModel.remove(DatingAppStaticParams.match_to);
    }

    var matching_user =
        mapped_DateMatchReqJModel[DatingAppStaticParams.matching_user];
    if (matching_user == null) {
      mapped_DateMatchReqJModel.remove(DatingAppStaticParams.matching_user);
    }

    var interestedin =
        mapped_DateMatchReqJModel[DatingAppStaticParams.interestedin];
    if (interestedin == null) {
      mapped_DateMatchReqJModel.remove(DatingAppStaticParams.interestedin);
    }

    var age_low = mapped_DateMatchReqJModel[DatingAppStaticParams.age_low];
    if (age_low == null) {
      mapped_DateMatchReqJModel.remove(DatingAppStaticParams.age_low);
    }

    var age_high = mapped_DateMatchReqJModel[DatingAppStaticParams.age_high];
    if (age_high == null) {
      mapped_DateMatchReqJModel.remove(DatingAppStaticParams.age_high);
    }

    var fb_insta_link =
        mapped_DateMatchReqJModel[DatingAppStaticParams.fb_insta_link];
    if (fb_insta_link == null) {
      mapped_DateMatchReqJModel.remove(DatingAppStaticParams.fb_insta_link);
    }

    var approveddate =
        mapped_DateMatchReqJModel[DatingAppStaticParams.approveddate];
    if (approveddate == null) {
      mapped_DateMatchReqJModel.remove(DatingAppStaticParams.approveddate);
    }

    var approvedby =
        mapped_DateMatchReqJModel[DatingAppStaticParams.approvedby];
    if (approvedby == null) {
      mapped_DateMatchReqJModel.remove(DatingAppStaticParams.approvedby);
    }

    var approved = mapped_DateMatchReqJModel[DatingAppStaticParams.approved];
    if (approved == null) {
      mapped_DateMatchReqJModel.remove(DatingAppStaticParams.approved);
    }

    var active = mapped_DateMatchReqJModel[DatingAppStaticParams.active];
    if (active == null) {
      mapped_DateMatchReqJModel.remove(DatingAppStaticParams.active);
    }

    var mpesa_payment = mapped_DateMatchReqJModel[DatingAppStaticParams.mpesa_payment];
    if (mpesa_payment == null) {
      mapped_DateMatchReqJModel.remove(DatingAppStaticParams.mpesa_payment);
    }

    Response response = null;
    if (isIntValid(dateMatchReqJModel.id)) {
      action_performed = 'updating';
      print(TAG + 'PATCH');
      response = await Provider.of<PostApiService>(context).patchMatch(
        DatingAppStaticParams.tokenWspace + loginRespJModel.token,
        dateMatchReqJModel.id,
        mapped_DateMatchReqJModel,
      );
    } else {
      action_performed = 'creating a';
      print(TAG + 'POST');
      response = await Provider.of<PostApiService>(context).postMatch(
        DatingAppStaticParams.tokenWspace + loginRespJModel.token,
        mapped_DateMatchReqJModel,
      );
    }
    int statusCode = response.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        var respBody = response.body;
        log(TAG + ' respBody==${respBody.toString()}');
        DateMatchRespJModel dateMatchRespJModel =
            DateMatchRespJModel.fromJson(respBody);

        refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
        if (snackbarBuildContext != null) {
          showSnackbarWBgCol('Success ${action_performed} match'+((isUserRequest?' request':'')),
              snackbarBuildContext, DatingAppTheme.green);
        }
        return dateMatchRespJModel;
      } catch (error) {
        print(TAG + 'error==');
        print(error);
        refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
        if (snackbarBuildContext != null) {
          showSnackbarWBgCol(
              'An error occurred', snackbarBuildContext, DatingAppTheme.red);
        }
        return null;
      }
    } else {
      print(TAG + 'statusCode==${statusCode.toString()}');
      print(TAG + ' taskresponse.bodyString==');
      print(response.bodyString);
      refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
      if (snackbarBuildContext != null) {
        showSnackbarWBgCol(
            'An error occurred', snackbarBuildContext, DatingAppTheme.red);
      }
      return null;
    }
  } catch (error) {
    print(TAG + ' error==');
    print(error.toString());
    refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
    if (snackbarBuildContext != null) {
      showSnackbarWBgCol(
          'An error occurred', snackbarBuildContext, DatingAppTheme.red);
    }
    return null;
  }
}
