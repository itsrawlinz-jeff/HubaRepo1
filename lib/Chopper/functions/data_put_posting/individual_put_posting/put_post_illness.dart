import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataEvent.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/IllnessDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/IllnessDao.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/illness/IllnessRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/illness/IllnessReqJModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> put_post_illness(
  BuildContext context,
  BuildContext snackBarBuildContext,
  Illness illness,
  NavigationDataBLoC navigationDataBLoC_Loader,
  NavigationDataBLoC illnessSavedNavigationDataBLoC,
) async {
  if (navigationDataBLoC_Loader != null) {
    refreshLoader(true, navigationDataBLoC_Loader);
  }
  String TAG = 'put_post_illness:';
  print(TAG);

  bool isNetConnActive = await isNetworkConnectionActive();
  if (isNetConnActive) {
    IllnessReqJModel illnessReqJModel = IllnessReqJModel();
    illnessReqJModel.name = illness.name;
    illnessReqJModel.approved = true;
    illnessReqJModel.active = true;
    illnessReqJModel.is_chronic = true;
    DateTime today_DateTime = DateTime.now();
    illnessReqJModel.createdate =
        getDateFormat_yyyymmdd().format(today_DateTime);
    illnessReqJModel.txndate = today_DateTime;

    Map<String, dynamic> mapped_illnessReqJModel = illnessReqJModel.toJson();

    var mp_name = mapped_illnessReqJModel[DatingAppStaticParams.name];
    if (mp_name == null) {
      mapped_illnessReqJModel.remove(DatingAppStaticParams.name);
    }

    var mp_approved = mapped_illnessReqJModel[DatingAppStaticParams.approved];
    if (mp_approved == null) {
      mapped_illnessReqJModel.remove(DatingAppStaticParams.approved);
    }

    var mp_approveddate =
        mapped_illnessReqJModel[DatingAppStaticParams.approveddate];
    if (mp_approveddate == null) {
      mapped_illnessReqJModel.remove(DatingAppStaticParams.approveddate);
    }

    var mp_active = mapped_illnessReqJModel[DatingAppStaticParams.active];
    if (mp_active == null) {
      mapped_illnessReqJModel.remove(DatingAppStaticParams.active);
    }

    var mp_createdby = mapped_illnessReqJModel[DatingAppStaticParams.createdby];
    if (mp_createdby == null) {
      mapped_illnessReqJModel.remove(DatingAppStaticParams.createdby);
    }

    var mp_approvedby =
        mapped_illnessReqJModel[DatingAppStaticParams.approvedby];
    if (mp_approvedby == null) {
      mapped_illnessReqJModel.remove(DatingAppStaticParams.approvedby);
    }

    print(TAG + ' POSTING==');
    print(mapped_illnessReqJModel.toString());

    Response illnessPutresponse = null;
    if (isIntValid(illness.onlineid)) {
      print(TAG + 'PATCH');
      illnessPutresponse = await Provider.of<PostApiService>(context)
          .patchIllness(illness.onlineid, mapped_illnessReqJModel);
    } else {
      print(TAG + 'POST');
      illnessPutresponse = await Provider.of<PostApiService>(context)
          .postIllness(mapped_illnessReqJModel);
    }
    int statusCode = illnessPutresponse.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        print(TAG + 'responseSuccessfull');
        var respBody = illnessPutresponse.body;
        print(respBody);

        IllnessRespJModel illnessRespJModel =
            IllnessRespJModel.fromJson(respBody);
        print(TAG + 'illnessRespJModel onlineid==${illnessRespJModel.id}');
        bool issyncIllness = await syncIllness(
          context,
          illnessRespJModel,
          illness,
          navigationDataBLoC_Loader,
          illnessSavedNavigationDataBLoC,
        );
        if (issyncIllness) {
          if (snackBarBuildContext != null) {
            displaySnackBarWithDelay(
                'Illness saved', DatingAppTheme.green, snackBarBuildContext);
          }
        } else {
          if (snackBarBuildContext != null) {
            displaySnackBarWithDelay('An error occurred saving illness',
                DatingAppTheme.green, snackBarBuildContext);
          }
        }
        return issyncIllness;
      } catch (error) {
        print(TAG + 'error==');
        print(error.toString());
        if (navigationDataBLoC_Loader != null) {
          refreshLoader(false, navigationDataBLoC_Loader);
        }
        if (snackBarBuildContext != null) {
          if (snackBarBuildContext != null) {
            displaySnackBarWithDelay(
                'An error occurred', DatingAppTheme.red, snackBarBuildContext);
          }
        }
        return false;
      }
    } else {
      print(TAG + 'statusCode==${statusCode}');
      print(illnessPutresponse.bodyString);

      if (navigationDataBLoC_Loader != null) {
        refreshLoader(false, navigationDataBLoC_Loader);
      }
      if (isresponse400(statusCode)) {
        if (snackBarBuildContext != null) {
          displaySnackBarWithDelay(
              'An error ocurred', DatingAppTheme.red, snackBarBuildContext);
        }
      } else {
        if (snackBarBuildContext != null) {
          displaySnackBarWithDelay(
              'Connection error', DatingAppTheme.red, snackBarBuildContext);
        }
      }

      return false;
    }
  } else {
    print(TAG + 'INTERNET CONNECTION NOT ACTIVE');
    if (navigationDataBLoC_Loader != null) {
      refreshLoader(false, navigationDataBLoC_Loader);
    }
    if (snackBarBuildContext != null) {
      displaySnackBarWithDelay(
          'No internet connection', DatingAppTheme.red, snackBarBuildContext);
    }
  }
  return false;
}

Future<bool> syncIllness(
  BuildContext context,
  IllnessRespJModel illnessRespJModel,
  Illness illness,
  NavigationDataBLoC navigationDataBLoC_Loader,
  NavigationDataBLoC illnessSavedNavigationDataBLoC,
) async {
  String TAG = 'put_post_illness:syncIllness:';
  print(TAG);
  AppDatabase database = Provider.of<AppDatabase>(context);
  IllnessDao illnessDao = database.illnessDao;

  Illness illnessToUpdate = illness.copyWith(
    onlineid: illnessRespJModel.id,
    issettobeupdated: false,
    name: illnessRespJModel.name,
    active: illnessRespJModel.active,
  );

  if (!isIntValid(illness.id)) {
    int savedObjId = await illnessDao.insertIllness(illnessToUpdate);
    illness = await illnessDao.getIllnessById(savedObjId);
    refresh_illnessSavedNavigationDataBLoC(
        illnessSavedNavigationDataBLoC, illness);
  } else {
    bool isUpdated = await illnessDao.updateIllness(illnessToUpdate);
    illness = await illnessDao.getIllnessById(illness.id);
    refresh_illnessSavedNavigationDataBLoC(
        illnessSavedNavigationDataBLoC, illness);
  }
  if (navigationDataBLoC_Loader != null) {
    refreshLoader(false, navigationDataBLoC_Loader);
  }
  return true;
}

refresh_illnessSavedNavigationDataBLoC(
  NavigationDataBLoC illnessSavedNavigationDataBLoC,
  Illness illness,
) async {
  NavigationData navigationData = NavigationData();
  navigationData.illness = illness;
  illnessSavedNavigationDataBLoC.dailySubTaskimages_event_sink
      .add(NavigationDataAddedEvent(navigationData));
}
