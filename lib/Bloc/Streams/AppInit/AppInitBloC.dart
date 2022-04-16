import 'dart:async';
import 'dart:convert';

import 'package:dating_app/Bloc/Streams/AppInit/AppInitEvent.dart';
import 'package:dating_app/Data/SharedPreferences/UserSessionSharedPrefs.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class AppInitBloC {
  final _appInitStreamController = StreamController<NavigationData>.broadcast();
  StreamSink<NavigationData> get appInit_sink => _appInitStreamController.sink;

  Stream<NavigationData> get stream_counter => _appInitStreamController.stream;

  final _appInitEventController = StreamController<AppInitEvent>();
  Sink<AppInitEvent> get switch_changed_event_sink =>
      _appInitEventController.sink;

  AppInitBloC() {
    _appInitEventController.stream.listen(_appInit);
  }

  _appInit(AppInitEvent event) async {
    if (event is AppInitializedEvent) {
      BuildContext buildContext = event.buildContext;

      UserSessionSharedPrefs userSessionSharedPrefs =
          new UserSessionSharedPrefs();

      LoginRespModel loginRespJModel =
          await userSessionSharedPrefs.getUserSessionLoginRespModel();

      bool isDarkTheme =
          await userSessionSharedPrefs.getFutureBoolCurrentTheme();

      if (buildContext != null) {
        ParentSelectedThemeData parentSelectedThemeData =
            Provider.of<ParentSelectedThemeData>(buildContext, listen: true);
        parentSelectedThemeData.isDarkMode = isDarkTheme;
        parentSelectedThemeData.isFromToggle = false;
      }
      NavigationData navigationData = NavigationData();
      navigationData.isDarkMode = isDarkTheme;
      navigationData.loginRespModel = loginRespJModel;

      appInit_sink.add(navigationData);
      /*userSessionSharedPrefs.getUserSession().then((onValue) {
        if (onValue != null) {
          LoginRespModel loginRespModel =
              LoginRespModel.fromJson(json.decode(onValue));
          print('username== ${loginRespModel.username}');
          appInit_sink.add(loginRespModel);
        } else {
          print('value null');
          LoginRespModel loginRespModel = new LoginRespModel();
          appInit_sink.add(loginRespModel);
        }
      }, onError: (error) {
        print('error== $error');
        LoginRespModel loginRespModel = new LoginRespModel();
        appInit_sink.add(loginRespModel);
      });*/
    }
  }

  dispose() {
    _appInitStreamController.close();
    _appInitEventController.close();
  }
}
