import 'dart:convert';
import 'dart:io';

import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataEvent.dart';
import 'package:dating_app/Data/SharedPreferences/UserSessionSharedPrefs.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/DateMatchRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/token/TokenDecodedJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/matches/DateMatchReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/users/CustomUserReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

bool getPermissionStatusBool(PermissionStatus permissionStatus) {
  switch (permissionStatus) {
    case PermissionStatus.denied:
      return false;
    case PermissionStatus.granted:
      return true;
    default:
      return false;
  }
}

String extractFilenamefromPath(String filePath) {
  String TAG = 'extractFilenamefromPath:';
  String fileName = null;
  if (filePath != null) {
    try {
      List<String> filePathSplitList = filePath.split("/");
      fileName = filePathSplitList[filePathSplitList.length - 1];
    } catch (error) {
      print(TAG + 'error==');
      print(error);
    }
  }
  return fileName;
}

refreshLoader(bool status, NavigationDataBLoC navigationDataBLoC) {
  if (navigationDataBLoC != null) {
    NavigationData navigationData = NavigationData();
    navigationData.isShow = status;
    navigationDataBLoC.dailySubTaskimages_event_sink
        .add(NavigationDataAddedEvent(navigationData));
  }
}

refreshLoader_with_isSaved(
    bool isShow, bool isSaved, NavigationDataBLoC navigationDataBLoC) {
  if (navigationDataBLoC != null) {
    NavigationData navigationData = NavigationData();
    navigationData.isShow = isShow;
    navigationData.isSaved = isSaved;
    navigationDataBLoC.dailySubTaskimages_event_sink
        .add(NavigationDataAddedEvent(navigationData));
  }
}

Future<LoginRespModel> getSessionLoginRespModel(BuildContext context) async {
  String TAG = 'getSessionLoginRespModel';
  UserSessionSharedPrefs userSessionSharedPrefs = UserSessionSharedPrefs();
  LoginRespModel loginRespModel =
      await userSessionSharedPrefs.getUserSessionLoginRespModel();
  return loginRespModel;
}

bool isAdult(DateTime birthDate) {
  DateTime today = DateTime.now();
  DateTime adultDate = DateTime(
    birthDate.year + 18,
    birthDate.month,
    birthDate.day,
  );

  return adultDate.isBefore(today);
}

refresh_wd_validator_NavigationDataBLoC(bool isValid, String msg,
    NavigationDataBLoC wd_validator_NavigationDataBLoC) {
  NavigationData navigationData = NavigationData();
  navigationData.isValid = isValid;
  navigationData.message = msg;
  wd_validator_NavigationDataBLoC.dailySubTaskimages_event_sink
      .add(NavigationDataAddedEvent(navigationData));
}

refresh_Isvalid_NavigationDataBLoC(
    bool isValid, NavigationDataBLoC wd_validator_NavigationDataBLoC) {
  NavigationData navigationData = NavigationData();
  navigationData.isValid = isValid;
  wd_validator_NavigationDataBLoC.dailySubTaskimages_event_sink
      .add(NavigationDataAddedEvent(navigationData));
}

refresh_WO_Data_NavigationDataBLoC(NavigationDataBLoC navigationDataBLoC) {
  NavigationData navigationData = NavigationData();
  navigationDataBLoC.dailySubTaskimages_event_sink
      .add(NavigationDataAddedEvent(navigationData));
}

refresh_W_Data_NavigationDataBLoC(
    NavigationDataBLoC navigationDataBLoC, NavigationData navigationData) {
  navigationDataBLoC.dailySubTaskimages_event_sink
      .add(NavigationDataAddedEvent(navigationData));
}

refresh_W_Data_Isshow_NavigationDataBLoC(
    NavigationDataBLoC navigationDataBLoC, bool isShow) {
  if (navigationDataBLoC != null) {
    NavigationData navigationData = NavigationData();
    navigationData.isShow = isShow;
    navigationDataBLoC.dailySubTaskimages_event_sink
        .add(NavigationDataAddedEvent(navigationData));
  }
}

refresh_W_Data_IsSelected_NavigationDataBLoC(
    NavigationDataBLoC navigationDataBLoC, bool isSelected) {
  if (navigationDataBLoC != null) {
    NavigationData navigationData = NavigationData();
    navigationData.isSelected = isSelected;
    navigationDataBLoC.dailySubTaskimages_event_sink
        .add(NavigationDataAddedEvent(navigationData));
  }
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

Pattern get_Email_Pattern() {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  return pattern;
}

Pattern get_Url_Pattern() {
  Pattern pattern =
      //r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)';
      r'(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})';
  return pattern;
}

Pattern get_PhoneNo_Pattern() {
  Pattern pnonenoPattern = r'^[0-9]{9}$';
  return pnonenoPattern;
}

Pattern get_Password_Pattern() {
  Pattern pnonenoPattern = r'^[0-9a-zA-Z]+$';
  return pnonenoPattern;
}

Future<bool> common_getData() async {
  await Future<dynamic>.delayed(Duration(milliseconds: 50));
  return true;
}

DateFormat getDateFormat_yyyymmdd() {
  DateFormat dateDateFormat = DateFormat('yyyy-MM-dd');
  return dateDateFormat;
}

DateFormat getDateFormat_MMMddcmyyyy() {
  DateFormat dateDateFormat = DateFormat('MMM dd, yyyy');
  return dateDateFormat;
}

DateFormat getDateFormat_yyyymmmdd() {
  DateFormat dtFormat = DateFormat('dd/MMM/yyyy');
  return dtFormat;
}

DateFormat getDateFormat_ddMMyy() {
  DateFormat dtFormat = DateFormat('dd/MM/yy');
  return dtFormat;
}

//URLS
String getBaseUrlStr() {
  //String baseUrlStr = 'http://138.68.89.29:8000/';
  //String baseUrlStr = 'http://192.168.0.103:8000/';
  String baseUrlStr = 'http://192.168.1.57:8000/';
  return baseUrlStr;
}

//END OF URLS

DateMatchReqJModel dateMatchReqJModelFromDateMatchRespJModel(
    DateMatchRespJModel dateMatchRespJModel) {
  DateMatchReqJModel dateMatchReqJModel = DateMatchReqJModel();
  dateMatchReqJModel.id = dateMatchRespJModel.id;
  dateMatchReqJModel.createdby = ((dateMatchRespJModel.createdby != null
      ? dateMatchRespJModel.createdby.id
      : null));
  dateMatchReqJModel.match_to = ((dateMatchRespJModel.match_to != null
      ? dateMatchRespJModel.match_to.id
      : null));
  dateMatchReqJModel.matching_user = ((dateMatchRespJModel.matching_user != null
      ? dateMatchRespJModel.matching_user.id
      : null));
  dateMatchReqJModel.decision = ((dateMatchRespJModel.decision != null
      ? dateMatchRespJModel.decision.id
      : null));
  dateMatchReqJModel.active = dateMatchRespJModel.active;
  dateMatchReqJModel.createdate = ((dateMatchRespJModel.createdate != null
      ? getDateFormat_yyyymmdd().format(dateMatchRespJModel.createdate)
      : null));
  dateMatchReqJModel.txndate = dateMatchRespJModel.txndate;
  dateMatchReqJModel.isuserrequested = dateMatchRespJModel.isuserrequested;
  dateMatchReqJModel.age_high = ((dateMatchRespJModel.age_high != null
      ? dateMatchRespJModel.age_high
      : 100));
  dateMatchReqJModel.age_low = ((dateMatchRespJModel.age_low != null
      ? dateMatchRespJModel.age_low
      : 18));
  dateMatchReqJModel.interestedin = ((dateMatchRespJModel.interestedin != null
      ? dateMatchRespJModel.interestedin.id
      : null));
  dateMatchReqJModel.fb_insta_link = dateMatchRespJModel.fb_insta_link;
  dateMatchReqJModel.approved = ((dateMatchRespJModel.approved != null
      ? dateMatchRespJModel.approved
      : false));
  dateMatchReqJModel.approvedby = ((dateMatchRespJModel.approvedby != null
      ? dateMatchRespJModel.approvedby.id
      : null));
  dateMatchReqJModel.approveddate = ((dateMatchRespJModel.approveddate != null
      ? dateMatchRespJModel.approveddate
      : null));
  dateMatchReqJModel.mpesa_payment = ((dateMatchRespJModel.mpesa_payment != null
      ? dateMatchRespJModel.mpesa_payment.id
      : null));
  dateMatchReqJModel.mpesa_code = ((dateMatchRespJModel.mpesa_payment != null
      ? dateMatchRespJModel.mpesa_payment.mpesa_receipt_number
      : null));
  return dateMatchReqJModel;
}

Future<bool> initial_AfterFirstLayout_OnlineFetch(
    RefreshController _refreshController) async {
  String TAG = 'initial_AfterFirstLayout_OnlineFetch:';
  print(TAG);
  await Future.delayed(Duration(
      milliseconds:
          DatingAppStaticParams.default_Future_delayed_to_initial_query));
  try {
    _refreshController.requestRefresh();
  } catch (error) {
    print(TAG + ' error=');
    print(error.toString());
    await Future.delayed(Duration(
        milliseconds:
            DatingAppStaticParams.default_Future_delayed_to_initial_query));
    _refreshController.requestRefresh();
  }
  return true;
}

TokenDecodedJModel decodeToken(String token) {
  String TAG = 'decodeToken';
  TokenDecodedJModel tokenDecodedJModel = null;
  try {
    List<String> strList = token.split('.');
    String normalizedString = base64Url.normalize(strList[1]);
    String respString = utf8.decode(base64Url.decode(normalizedString));
    tokenDecodedJModel = TokenDecodedJModel.fromJson(json.decode(respString));
    print(TAG + ' json.decode(respString)=${json.decode(respString)}');
  } catch (error) {
    print(TAG + ' error==');
    print(error.toString());
  }
  return tokenDecodedJModel;
}

CustomUserRespJModel customUserRespJModelFromLoginRespModel(
    LoginRespModel loginRespModel) {
  CustomUserRespJModel customUserRespJModel = CustomUserRespJModel();
  customUserRespJModel.id = loginRespModel.id;
  customUserRespJModel.name = loginRespModel.fullname;
  customUserRespJModel.first_name = loginRespModel.first_name;
  customUserRespJModel.last_name = loginRespModel.last_name;
  customUserRespJModel.email = loginRespModel.tokenDecodedJModel.email;
  customUserRespJModel.username = loginRespModel.tokenDecodedJModel.username;
  customUserRespJModel.phone_number = loginRespModel.phone_number;
  //customUserRespJModel.role=loginRespModel.tokenDecodedJModel.role;
  customUserRespJModel.picture = loginRespModel.profile_picture;
  //customUserRespJModel.createdate=loginRespModel.createdate;
  //customUserRespJModel.txndate=loginRespModel.txndate;
  //customUserRespJModel.createdby=loginRespModel.createdby;
  //customUserRespJModel.approved=loginRespModel.approved;
  customUserRespJModel.quote = loginRespModel.quote;
  customUserRespJModel.age = loginRespModel.age;

  return customUserRespJModel;
}

refresh_wd_ValidationField_Container_NavigationDataBLoC(
    NavigationDataBLoC wd_ValidationField_Container_NavigationDataBLoC,
    bool isValid,
    String msg) {
  if (wd_ValidationField_Container_NavigationDataBLoC != null) {
    NavigationData navigationData = NavigationData();
    navigationData.isValid = isValid;
    navigationData.message = msg;
    wd_ValidationField_Container_NavigationDataBLoC
        .dailySubTaskimages_event_sink
        .add(NavigationDataAddedEvent(navigationData));
  }
}

double get_default_loader_distance() {
  return 30.0;
}

double get_default_loader_height() {
  return 80;
}

Future<bool> show_loading_indicator(
  bool is_readyToRefresh,
  AnimationController _positionController,
  double loader_distance,
  double loader_height,
  AnimationController _scaleFactor,
) async {
  if (!is_readyToRefresh) {
    _positionController.animateTo(
      loader_distance / loader_height,
      curve: Curves.bounceOut,
      duration: Duration(milliseconds: 1),
    );
    is_readyToRefresh = true;
    return is_readyToRefresh;
  } else {
    _scaleFactor.animateTo(1.0);
    return null;
  }
}

dismiss_loading_indicator(AnimationController _scaleFactor) {
  String TAG = 'dismiss_loading_indicator:';
  try {
    _scaleFactor.animateTo(0.0);
  } catch (error) {
    print(TAG + ' error==');
    print(error.toString());
  }
}

Widget placeholder_image_Container() {
  return Container(
    decoration: BoxDecoration(
        image: DecorationImage(
            image: Image.asset('assets/images/image_placeholder.png').image,
            fit: BoxFit.cover)),
  );
}

bool isSystemRole(String role_name) {
  return isStringValid(role_name) && role_name == DatingAppStaticParams.SYSTEM;
}

Future<bool> getData_common() async {
  await Future<dynamic>.delayed(const Duration(milliseconds: 200));
  return true;
}

CustomUserReqJModel profile_edit_customUserReqJModelFromCustomUserRespJModel(
  CustomUserRespJModel customUserRespJModel,
) {
  CustomUserReqJModel customUserReqJModel = CustomUserReqJModel();
  customUserReqJModel.id = customUserRespJModel.id;
  customUserReqJModel.fb_link = customUserRespJModel.fb_link;
  customUserReqJModel.insta_link = customUserRespJModel.insta_link;
  return customUserReqJModel;
}

bool is_Link_Valid(String linkStr) {
  if (!isStringValid(linkStr)) {
    return false;
  } else {
    //IS VALID
    RegExp regex = new RegExp(get_Url_Pattern());
    if (!regex.hasMatch(linkStr)) {
      return false;
    }
  }
  return true;
}

common_show_hide_loader(
  bool isShow,
  NavigationDataBLoC loginBtnPageBLoC,
) {
  if (loginBtnPageBLoC != null) {
    NavigationData navigationData = NavigationData();
    navigationData.isShow = isShow;
    refresh_W_Data_NavigationDataBLoC(loginBtnPageBLoC, navigationData);
  }
}

Future<bool> isInternetConnectedCheckFunction() async {
  bool result = false;
  try {
    final list = await InternetAddress.lookup('google.com');
    if (list.isNotEmpty && list[0].rawAddress.isNotEmpty) {
      result = true;
      print('CONNECTED!');
    }
  } catch (error) {
    print('isInternetConnected error==');
    print(error.toString());
    result = false;
    return result;
  }

  return result;
}

/*String get_OnlineUserRespJModel_Fullname(
    OnlineUserRespJModel onlineUserRespJModel,
    ) {
  String fullname = '';
  if (onlineUserRespJModel != null) {
    if (isStringValid(onlineUserRespJModel.name)) {
      fullname = onlineUserRespJModel.name;
    } else if (isStringValid(onlineUserRespJModel.first_name) ||
        isStringValid(onlineUserRespJModel.last_name)) {
      fullname = ((onlineUserRespJModel.first_name != null
          ? onlineUserRespJModel.first_name
          : '')) +
          ((isStringValid(onlineUserRespJModel.last_name)
              ? '${((onlineUserRespJModel.first_name != null ? ' ' : ''))}${onlineUserRespJModel.last_name}'
              : ''));
    } else if (isStringValid(onlineUserRespJModel.username)) {
      fullname = onlineUserRespJModel.username;
    }
  } else {}

  return fullname;
}*/

String get_CustomUserRespJModel_Fullname(
  CustomUserRespJModel onlineUserRespJModel,
) {
  String fullname = '';
  if (onlineUserRespJModel != null) {
    if (isStringValid(onlineUserRespJModel.name)) {
      fullname = onlineUserRespJModel.name;
    } else if (isStringValid(onlineUserRespJModel.first_name) ||
        isStringValid(onlineUserRespJModel.last_name)) {
      fullname = ((onlineUserRespJModel.first_name != null
              ? onlineUserRespJModel.first_name
              : '')) +
          ((isStringValid(onlineUserRespJModel.last_name)
              ? '${((onlineUserRespJModel.first_name != null ? ' ' : ''))}${onlineUserRespJModel.last_name}'
              : ''));
    } else if (isStringValid(onlineUserRespJModel.username)) {
      fullname = onlineUserRespJModel.username;
    }
  } else {}

  return fullname;
}

Pattern get_Phone_Pattern() {
  String patttern = r'^(?:254)?(7(?:(?:[0-9][0-9]))[0-9]{6})$';
  return patttern;
}

String getAppCredsB64(LoginRespModel loginRespJModel) {
  String creds =
      ((loginRespJModel != null ? loginRespJModel.email : env['APPUNAME'])) +
          ':' +
          ((loginRespJModel != null
              ? loginRespJModel.field_password
              : env['APPPASS']));
  //String creds=KeSoundcloudAppStaticParams.sys_un+':'+KeSoundcloudAppStaticParams.sys_pw;
  String encoded = base64.encode(utf8.encode(creds));
  return encoded;
}
