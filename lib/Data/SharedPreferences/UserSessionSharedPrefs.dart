import 'dart:convert';

import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSessionSharedPrefs {

  final String _userSessionPrefs = "userSession";
  final String _isDarkMode = "isDarkMode";


  Future<String> getUserSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.get(_userSessionPrefs) ?? null;
  }

  Future<LoginRespModel> getUserSessionLoginRespModel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedUserSession = prefs.get(_userSessionPrefs);
    LoginRespModel loginRespModel = null;
    if (savedUserSession != null) {
      loginRespModel = LoginRespModel.fromJson(json.decode(savedUserSession));
    }
    return loginRespModel;
  }

  Future<bool> setUserSession(String loginRespModelStr) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_userSessionPrefs, loginRespModelStr);
  }

  Future<bool> setCurrentTheme(
      bool isDarkMode, BuildContext buildContext) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Future<bool> isSetBoolFuture = prefs.setBool(_isDarkMode, isDarkMode);
  }

  Future<bool> getFutureBoolCurrentTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkMode) ?? false;
  }
}
