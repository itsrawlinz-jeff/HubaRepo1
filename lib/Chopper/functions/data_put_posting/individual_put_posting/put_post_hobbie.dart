import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataEvent.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/HobbyDao.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/hobbie/HobbieReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/hobby/HobbyRespModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> put_post_hobbie(
  BuildContext context,
  BuildContext snackBarBuildContext,
  Hobbie hobbie,
  NavigationDataBLoC navigationDataBLoC_Loader,
  NavigationDataBLoC hobbieSavedNavigationDataBLoC,
) async {
  if (navigationDataBLoC_Loader != null) {
    refreshLoader(true, navigationDataBLoC_Loader);
  }
  String TAG = 'put_post_hobbie:';
  print(TAG);

  bool isNetConnActive = await isNetworkConnectionActive();
  if (isNetConnActive) {
    HobbieReqJModel hobbieReqJModel = HobbieReqJModel();
    hobbieReqJModel.name = hobbie.name;
    hobbieReqJModel.approved = true;
    hobbieReqJModel.active = true;

    Map<String, dynamic> mapped_hobbieReqJModel = hobbieReqJModel.toJson();

    var mp_name = mapped_hobbieReqJModel['name'];
    if (mp_name == null) {
      mapped_hobbieReqJModel.remove('name');
    }

    var mp_approved = mapped_hobbieReqJModel['approved'];
    if (mp_approved == null) {
      mapped_hobbieReqJModel.remove('approved');
    }

    var mp_approveddate = mapped_hobbieReqJModel['approveddate'];
    if (mp_approveddate == null) {
      mapped_hobbieReqJModel.remove('approveddate');
    }

    var mp_active = mapped_hobbieReqJModel['active'];
    if (mp_active == null) {
      mapped_hobbieReqJModel.remove('active');
    }

    var mp_createdby = mapped_hobbieReqJModel['createdby'];
    if (mp_createdby == null) {
      mapped_hobbieReqJModel.remove('createdby');
    }

    var mp_approvedby = mapped_hobbieReqJModel['approvedby'];
    if (mp_approvedby == null) {
      mapped_hobbieReqJModel.remove('approvedby');
    }

    Response hobbiePutresponse = null;
    if (isIntValid(hobbie.onlineid)) {
      print(TAG + 'PUT');
      hobbiePutresponse =
          await Provider.of<PostApiService>(context).putHobbie(
              //DatingAppStaticParams.tokenWspace + loginRespJModel.user.token,
              hobbie.onlineid,
              mapped_hobbieReqJModel);
    } else {
      print(TAG + 'POST');
      hobbiePutresponse =
          await Provider.of<PostApiService>(context).postHobbie(
              //AdrianErpAppStaticParams.tokenWspace + loginRespJModel.user.token,
              mapped_hobbieReqJModel);
    }
    int statusCode = hobbiePutresponse.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      try {
        print(TAG + 'responseSuccessfull');
        var respBody = hobbiePutresponse.body;
        print(respBody);
        HobbyRespModel hobbyRespModel = HobbyRespModel.fromJson(respBody);
        print(TAG + 'hobbyRespModel onlineid==${hobbyRespModel.id}');
        bool issyncHobbie = await syncHobbie(
          context,
          hobbyRespModel,
          hobbie,
          navigationDataBLoC_Loader,
          hobbieSavedNavigationDataBLoC,
        );
        if (issyncHobbie) {
          if (snackBarBuildContext != null) {
            displaySnackBarWithDelay(
                'Hobbie saved', DatingAppTheme.green, snackBarBuildContext);
          }
        } else {
          if (snackBarBuildContext != null) {
            displaySnackBarWithDelay('An error occurred saving hobbie',
                DatingAppTheme.green, snackBarBuildContext);
          }
        }
        return issyncHobbie;
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
      print(hobbiePutresponse.bodyString);

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

Future<bool> syncHobbie(
  BuildContext context,
  HobbyRespModel hobbyRespModel,
  Hobbie hobbie,
  NavigationDataBLoC navigationDataBLoC_Loader,
  NavigationDataBLoC hobbieSavedNavigationDataBLoC,
) async {
  String TAG = 'put_post_hobbie:syncHobbie:';
  print(TAG);
  AppDatabase database = Provider.of<AppDatabase>(context);
  HobbyDao hobbieDao = database.hobbyDao;

  Hobbie hobbieToUpdate = hobbie.copyWith(
    onlineid: hobbyRespModel.id,
    issettobeupdated: false,
    name: hobbyRespModel.name,
    active: hobbyRespModel.active,
  );

  if (!isIntValid(hobbie.id)) {
    int savedObjId = await hobbieDao.insertHobbie(hobbieToUpdate);
    hobbie = await hobbieDao.getHobbieById(savedObjId);
    refresh_hobbieSavedNavigationDataBLoC(
        hobbieSavedNavigationDataBLoC, hobbie);
  } else {
    bool isUpdated = await hobbieDao.updateHobbie(hobbieToUpdate);
    hobbie = await hobbieDao.getHobbieById(hobbie.id);
    refresh_hobbieSavedNavigationDataBLoC(
        hobbieSavedNavigationDataBLoC, hobbie);
  }
  if (navigationDataBLoC_Loader != null) {
    refreshLoader(false, navigationDataBLoC_Loader);
  }
  return true;
}

refresh_hobbieSavedNavigationDataBLoC(
  NavigationDataBLoC hobbieSavedNavigationDataBLoC,
  Hobbie hobbie,
) async {
  NavigationData navigationData = NavigationData();
  navigationData.hobbie = hobbie;
  hobbieSavedNavigationDataBLoC.dailySubTaskimages_event_sink
      .add(NavigationDataAddedEvent(navigationData));
}
