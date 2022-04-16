import 'package:dating_app/Activities/OnBoardingConcept.dart';
import 'package:dating_app/Bloc/Streams/Fetch/OnFetchFinishedBLoC.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_user_login.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingDao.dart';
import 'package:dating_app/Data/SharedPreferences/UserSessionSharedPrefs.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/authentication/LoginUserRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/FbLoginRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/UserSignUpRespModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/Services/Fetch/OnboardingDataFetch.dart'
    as onboardingDataFetch;
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'LogInPage.dart';
import 'PasswordResetPage.dart';

import 'package:dating_app/tabs/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'dart:convert';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:after_layout/after_layout.dart';
import 'package:moor_flutter/moor_flutter.dart' as flutterMoor;
import 'package:dio/dio.dart';

class LoginSignUpOptionsPage extends StatefulWidget {
  final IntindexCallback navigate;

  LoginSignUpOptionsPage({
    Key key,
    this.navigate,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginSignUpOptionsPageState();
  }
}

class _LinkTextSpan extends TextSpan {
  _LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(url, forceSafariVC: false);
              });
}

class _LoginSignUpOptionsPageState extends State<LoginSignUpOptionsPage>
    with AfterLayoutMixin<LoginSignUpOptionsPage> {
  ProgressDialog pr;
  ProgressDialog prInitProgressDialog;
  bool _autoValidate = false;
  final GlobalKey<FormState> _liformKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  bool password1Visible = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  OnFetchFinishedBLoC onFetchFinishedBLoC = OnFetchFinishedBLoC();

  AppDatabase database;
  OnboardingDao onboardingDao;
  NavigationDataBLoC onLoginButtonClicked_NavigationDataBLoC =
      NavigationDataBLoC();

  @override
  void initState() {
    super.initState();
    //initFlutterDownloader();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    initDbVariables();
    initDataFetch(context, onFetchFinishedBLoC);
    clearSignUprPreferences();
  }

  initDataFetch(BuildContext context, OnFetchFinishedBLoC onFetchFinishedBLoC) {
    onboardingDataFetch.runOnboardingDataFetch(context, onFetchFinishedBLoC);
  }

  initDbVariables() {
    database = Provider.of<AppDatabase>(context);
    onboardingDao = database.onboardingDao;
  }

  clearSignUprPreferences() {
    UserSessionSharedPrefs userSessionSharedPrefs =
        new UserSessionSharedPrefs();
    userSessionSharedPrefs.setUserSession(null);
  }

  @override
  void dispose() {
    onFetchFinishedBLoC.dispose();
    super.dispose();
  }

  initFlutterDownloader() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      var flutterDownloaderInitialize = await FlutterDownloader.initialize();
    } catch (error) {
      print('initFlutterDownloader error=${error}');
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    pr.style(
      message: 'Logging In...',
      borderRadius: 10.0,
      backgroundColor: Colors.transparent,
      progressWidget: CircularProgressIndicator(
        backgroundColor: Colors.pink,
      ),
      elevation: 0.0,
      //10
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: TextStyle(
          color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    prInitProgressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    prInitProgressDialog.style(
      message: 'Initializing...',
      borderRadius: 10.0,
      backgroundColor: Colors.transparent,
      progressWidget: CircularProgressIndicator(
        backgroundColor: Colors.pink,
      ),
      elevation: 0.0,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: TextStyle(
          color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return buildLoginSignUpUI(context, datingAppThemeChanger);
      },
    );
    /*StreamBuilder(
        stream: onFetchFinishedBLoC.stream_counter,
        initialData: false,
        builder: (context, snapshot) {
          print('snapshot==${snapshot.data}');
          if (snapshot.hasError) return buildLoginWithoutSignUpUI();
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              print('ConnectionState.none');
              return getloadingPlaceHolder();
            case ConnectionState.waiting:
              print('ConnectionState.waiting');
              return getloadingPlaceHolder();
            case ConnectionState.active:
              print('ConnectionState.active');
              Widget returnedWidget = getloadingPlaceHolder();
              if (snapshot.data) {
                returnedWidget = buildLoginSignUpUI();
              } else {
                returnedWidget = buildLoginWithoutSignUpUI();
              }
              return returnedWidget;
            case ConnectionState.done:
              print('ConnectionState.done');
              Widget returnedWidget = getloadingPlaceHolder();
              if (snapshot.data) {
                returnedWidget = buildLoginSignUpUI();
              } else {
                returnedWidget = buildLoginWithoutSignUpUI();
              }
              return returnedWidget;
          }
        });*/
  }

  Widget buildLoginSignUpUI(BuildContext mainBuildContext,
      DatingAppThemeChanger datingAppThemeChanger) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background-tinder.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Builder(
            builder: (BuildContext context) => Container(
              child: SingleChildScrollView(
                child: new Form(
                  key: _liformKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[
                      // SizedBox(height: 150),
                      /*Image(
                height: 50,
                alignment: Alignment.topCenter,
                image: AssetImage("assets/images/tinder.png"),
              ),*/
                      SizedBox(height: 80),
                      Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: false,
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 70, right: 30),
                            child: RichText(
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: 'By signing up, you agree with our '),
                                _LinkTextSpan(
                                    text: 'Terms',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                    url: 'http://www.google.com'),
                                TextSpan(text: ' of Services and '),
                                _LinkTextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                    url: 'http://www.google.com')
                              ]),
                              textAlign: TextAlign.center,
                            )),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        // handle your onTap here
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 20.0,
                            left: 20.0,
                          ),
                          child: Container(
                            height: 60,
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                    width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              /*BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                      width: 2),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(30)),*/
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: 40.0,
                                    left: 40.0,
                                  ),
                                  child: TextFormField(
                                    validator: validateEmail,
                                    controller: userNameController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: datingAppThemeChanger
                                        .selectedThemeData
                                        .loginpage_FormField_TextStyle,
                                    /*TextStyle(
                                        fontSize: 16.0, color: Colors.white),*/
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.envelope,
                                        color: Colors.white,
                                        size: 22.0,
                                      ),
                                      hintText: "Email/Username",
                                      hintStyle: datingAppThemeChanger
                                          .selectedThemeData
                                          .loginpage_hintStyle,
                                      /*TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontStyle: FontStyle.italic),*/

                                      errorStyle: datingAppThemeChanger
                                          .selectedThemeData
                                          .login_error_TextStyle,
                                      //TextStyle(color: Color(0xFFFFF0F5)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        // handle your onTap here
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 20.0,
                            left: 20.0,
                          ),
                          child: Container(
                            height: 60,
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                    width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              /* BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                      width: 2),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(30)),*/
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: 40.0,
                                    left: 40.0,
                                  ),
                                  child: TextFormField(
                                    validator: validatePassword,
                                    controller: passwordController,
                                    keyboardType: TextInputType.text,
                                    obscureText: !password1Visible,
                                    style: datingAppThemeChanger
                                        .selectedThemeData
                                        .loginpage_FormField_TextStyle,
                                    /*TextStyle(
                                        fontSize: 16.0, color: Colors.white),*/
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.lock,
                                        color: Colors.white,
                                        size: 22.0,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          password1Visible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: DatingAppTheme.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            password1Visible =
                                                !password1Visible;
                                          });
                                        },
                                      ),
                                      hintText: "Password",
                                      hintStyle: datingAppThemeChanger
                                          .selectedThemeData
                                          .loginpage_hintStyle,
                                      /*TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontStyle: FontStyle.italic),*/
                                      errorStyle: datingAppThemeChanger
                                          .selectedThemeData
                                          .login_error_TextStyle,
                                      //TextStyle(color: Color(0xFFFFF0F5)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      /*InkWell(
                      onTap: () => openHomePage(), // handle your onTap here
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                        child: Container(
                          height: 60,
                          child: Center(
                            child: Text(
                              'LOG IN',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                  colors: [Colors.pinkAccent, Colors.pink])),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),*/
                      Padding(
                        padding: EdgeInsets.only(
                          right: 20.0,
                          left: 20.0,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: () => logInUpClicked(context),
                              //onPressed: () => openHomePage(context),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0)),
                              padding: const EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [Colors.pink, Colors.deepOrange],
                                      begin: FractionalOffset(0.0, 0.0),
                                      end: FractionalOffset(1, 0.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp),
                                  /*LinearGradient(
                                colors: <Color>[Colors.pink, Colors.deepOrange],
                              ),*/
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(80.0)),
                                ),
                                child: Container(
                                  constraints: const BoxConstraints(
                                      minWidth: 88.0,
                                      minHeight:
                                          60), // min sizes for Material buttons
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Log In',
                                    style: datingAppThemeChanger
                                        .selectedThemeData
                                        .loginpage_LoginBtn_TextStyle,
                                    /*style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'GothamRounded-Medium',
                                      fontSize: 16.0,
                                      //fontStyle: FontStyle.italic
                                    ),*/
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            StreamBuilder(
                              stream: onLoginButtonClicked_NavigationDataBLoC
                                  .stream_counter,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) return invisibleWidget();
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return invisibleWidget();
                                    break;
                                  case ConnectionState.waiting:
                                    return invisibleWidget();
                                    break;
                                  case ConnectionState.active:
                                    return ifToShow_positioned_CircularProgressIndicator(
                                        snapshot);
                                    break;
                                  case ConnectionState.done:
                                    return ifToShow_positioned_CircularProgressIndicator(
                                        snapshot);
                                    break;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () => openPasswordResetPage(context),
                              child: Text(
                                'Forgot your password?',
                                style: datingAppThemeChanger.selectedThemeData
                                    .loginpage_ForgotYourPassword_TextStyle,
                                //style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: Colors.white,
                                height: 5.0,
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              'Sign In With',
                              style: datingAppThemeChanger.selectedThemeData
                                  .loginpage_SignInWith_TextStyle,
                              //TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.white,
                                height: 5.0,
                              ),
                            )
                          ],
                        ),
                      ),
                      _buildSocialBtnRow(context, mainBuildContext),
                      SizedBox(
                        height: 15.0,
                      ),
                      StreamBuilder(
                          stream: onFetchFinishedBLoC.stream_counter,
                          initialData: false,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) return invisibleWidget();
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return invisibleWidget();
                                break;
                              case ConnectionState.waiting:
                                return invisibleWidget();
                                break;
                              case ConnectionState.active:
                                if (snapshot.data) {
                                  return donthaveAnAccount_Row(
                                      datingAppThemeChanger);
                                } else {
                                  return invisibleWidget();
                                  ;
                                }
                                break;
                              case ConnectionState.done:
                                if (snapshot.data) {
                                  return donthaveAnAccount_Row(
                                      datingAppThemeChanger);
                                } else {
                                  return invisibleWidget();
                                  ;
                                }
                                break;
                            }
                          }),

                      SizedBox(
                        height: 15.0,
                      ),
                      StreamBuilder(
                          stream: onFetchFinishedBLoC.stream_counter,
                          initialData: false,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) return invisibleWidget();
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return invisibleWidget();
                                break;
                              case ConnectionState.waiting:
                                return invisibleWidget();
                                break;
                              case ConnectionState.active:
                                if (snapshot.data) {
                                  return signUp_FlatButton(
                                      datingAppThemeChanger);
                                } else {
                                  return invisibleWidget();
                                  ;
                                }
                                break;
                              case ConnectionState.done:
                                if (snapshot.data) {
                                  return signUp_FlatButton(
                                      datingAppThemeChanger);
                                } else {
                                  return invisibleWidget();
                                  ;
                                }
                                break;
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ifToShow_positioned_CircularProgressIndicator(
      AsyncSnapshot<NavigationData> snapshot) {
    NavigationData navigationData = snapshot.data;
    if (navigationData != null) {
      if (navigationData.isShow) {
        return positioned_CircularProgressIndicator();
      } else {
        return invisibleWidget();
      }
    } else {
      return invisibleWidget();
    }
  }

  Widget positioned_CircularProgressIndicator() {
    return Positioned(
      right: 8,
      child: Theme(
        data: ThemeData(
          accentColor: DatingAppTheme.nearlyDarkBlue,
        ),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget signUp_FlatButton(DatingAppThemeChanger datingAppThemeChanger) {
    return FlatButton(
      onPressed: () => openSignUpPage(),
      child: Text(
        'Sign Up',
        style: datingAppThemeChanger
            .selectedThemeData.loginpage_ForgotYourPassword_TextStyle,
        //style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget donthaveAnAccount_Row(DatingAppThemeChanger datingAppThemeChanger) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Divider(
              color: Colors.white,
              height: 5.0,
            ),
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            'Don\'t have an account?',
            style: datingAppThemeChanger
                .selectedThemeData.loginpage_SignInWith_TextStyle,
            //style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Divider(
              color: Colors.white,
              height: 5.0,
            ),
          )
        ],
      ),
    );
  }

  Widget buildLoginWithoutSignUpUI(mainBuildContext) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background-tinder.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Builder(
            builder: (BuildContext context) => Container(
              child: SingleChildScrollView(
                child: new Form(
                  key: _liformKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 80),
                      Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: false,
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 70, right: 30),
                            child: RichText(
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: 'By signing up, you agree with our '),
                                _LinkTextSpan(
                                    text: 'Terms',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                    url: 'http://www.google.com'),
                                TextSpan(text: ' of Services and '),
                                _LinkTextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                    url: 'http://www.google.com')
                              ]),
                              textAlign: TextAlign.center,
                            )),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        // handle your onTap here
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 20.0,
                            left: 20.0,
                          ),
                          child: Container(
                            height: 60,
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                    width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: 40.0,
                                    left: 40.0,
                                  ),
                                  child: TextFormField(
                                    validator: validateEmail,
                                    controller: userNameController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.envelope,
                                        color: Colors.white,
                                        size: 22.0,
                                      ),
                                      hintText: "Email/Username",
                                      hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontStyle: FontStyle.italic),
                                      errorStyle:
                                          TextStyle(color: Color(0xFFFFF0F5)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        // handle your onTap here
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 20.0,
                            left: 20.0,
                          ),
                          child: Container(
                            height: 60,
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                    width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: 40.0,
                                    left: 40.0,
                                  ),
                                  child: TextFormField(
                                    validator: validatePassword,
                                    controller: passwordController,
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.lock,
                                        color: Colors.white,
                                        size: 22.0,
                                      ),
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontStyle: FontStyle.italic),
                                      errorStyle:
                                          TextStyle(color: Color(0xFFFFF0F5)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 20.0,
                          left: 20.0,
                        ),
                        child: RaisedButton(
                          onPressed: () => logInUpClicked(context),
                          //onPressed: () => openHomePage(context),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          padding: const EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.pink, Colors.deepOrange],
                                  begin: FractionalOffset(0.0, 0.0),
                                  end: FractionalOffset(1, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80.0)),
                            ),
                            child: Container(
                              constraints: const BoxConstraints(
                                  minWidth: 88.0,
                                  minHeight:
                                      60), // min sizes for Material buttons
                              alignment: Alignment.center,
                              child: const Text(
                                'Log In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'GothamRounded-Medium',
                                  fontSize: 16.0,
                                  //fontStyle: FontStyle.italic
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () => openPasswordResetPage(context),
                              child: Text(
                                'Forgot your password?',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: Colors.white,
                                height: 5.0,
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              'Sign In With',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.white,
                                height: 5.0,
                              ),
                            )
                          ],
                        ),
                      ),
                      _buildSocialBtnRow(context, mainBuildContext),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getloadingPlaceHolder() {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background-tinder.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    alignment: FractionalOffset.center,
                    child: Theme(
                      data: new ThemeData(
                        primaryColor: Colors.white,
                        accentColor: Colors.white,
                      ),
                      child: CircularProgressIndicator(),
                    )),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Initializing ...',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'GothamRounded-Medium',
                  ),
                ),
              ])
          /* Container(
              alignment: FractionalOffset.center,
              child: CircularProgressIndicator()),*/
        ],
      ),
    );
  }

  Widget _buildSocialBtnRow(
      BuildContext context, BuildContext mainBuildContext) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => loginWithFacebook(context, mainBuildContext),
            AssetImage(
              'assets/logos/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
            () => loginWithGoogle(context, mainBuildContext),
            AssetImage(
              'assets/logos/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  loginWithGoogle(BuildContext context, BuildContext mainBuildContext) async {
    //signInWithGoogle(context, mainBuildContext).whenComplete(() {
    /*Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return Text('LOGGED IN');
          },
        ),
      );*/
    //});
    await signInWithGoogle(context, mainBuildContext);
  }

  Future<String> signInWithGoogle(
      BuildContext context, BuildContext mainBuildContext) async {
    try {
      FirebaseUser currentUser = await _auth.currentUser();
      await _auth.signOut();
      currentUser = null;
    } catch (error) {
      print('SIGNING OUT firebase error==${error}');
    }

    try {
      var isgoogleSignIn = await googleSignIn.isSignedIn();
      print('isgoogleSignIn=${isgoogleSignIn}');
      if (isgoogleSignIn) {
        var googleSignoutVar = await googleSignIn.signOut();
        print('SIGNING OUT GOOGLE');
      }
    } catch (error) {
      print('SIGNING OUT google error==${error}');
    }

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    print('email ${user.email}');
    print('displayName ${user.displayName}');
    print('photoUrl ${user.photoUrl}');
    print('phoneNumber ${user.phoneNumber}');

    FbLoginRespModel fbLoginRespModel = new FbLoginRespModel();
    fbLoginRespModel.email = user.email;
    fbLoginRespModel.name = user.displayName;
    fbLoginRespModel.first_name = user.displayName;
    fbLoginRespModel.online_filepath = user.photoUrl;
    fbLoginRespModel.phoneNumber = user.phoneNumber;

    requestPermissionWithCheck(
      PermissionGroup.storage,
      context,
      mainBuildContext,
      fbLoginRespModel,
      false,
    );

    return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }

  loginWithFacebook(BuildContext context, BuildContext mainBuildContext) async {
    await initiateFacebookLogin(context, mainBuildContext);
  }

  void initiateFacebookLogin(
      BuildContext context, BuildContext mainBuildContext) async {
    var facebookLogin = FacebookLogin();
    try {
      await facebookLogin.logOut();
    } catch (error) {
      print('SIGNING OUT facebook error==${error}');
    }

    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    FacebookLoginResult facebookLoginResult =
        //await facebookLogin.logInWithReadPermissions(['email']);
        await facebookLogin.logIn(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        //onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        //onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        FbLoginRespModel fbLoginRespModel = new FbLoginRespModel();
        var accessToken = facebookLoginResult.accessToken;
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}');
        var respBody = graphResponse.body;
        //var profile = json.decode(graphResponse.body);
        var profile = json.decode(respBody);
        print('${profile}');
        print("LoggedIn");

        fbLoginRespModel = FbLoginRespModel.fromJson(profile);
        fbLoginRespModel.token = accessToken.token;
        String profpicOnlinePath =
            'https://graph.facebook.com/${fbLoginRespModel.id}/picture?width=9999';
        fbLoginRespModel.online_filepath = profpicOnlinePath;

        print('fbLoginRespModel.token==${fbLoginRespModel.token}');

        await requestPermissionWithCheck(
          PermissionGroup.storage,
          context,
          mainBuildContext,
          fbLoginRespModel,
          true,
        );

        break;
    }
  }

  requestPermissionWithCheck(
    PermissionGroup permissionGroup,
    BuildContext context,
    BuildContext mainBuildContext,
    FbLoginRespModel fbLoginRespModel,
    bool isFBLogin,
  ) {
    PermissionHandler().checkPermissionStatus(permissionGroup).then(
        (PermissionStatus status) async {
      bool bool_status = getPermissionStatusBool(status);
      if (bool_status) {
        await downloadFile(
            fbLoginRespModel, context, isFBLogin, mainBuildContext);
      } else {
        List<PermissionGroup> permissions = <PermissionGroup>[permissionGroup];
        PermissionHandler().requestPermissions(permissions).then(
            (onValue) async {
          PermissionStatus permissionStatus = onValue[permissionGroup];
          bool bool_status = getPermissionStatusBool(permissionStatus);
          if (bool_status) {
            await downloadFile(
                fbLoginRespModel, context, isFBLogin, mainBuildContext);
          } else {
            showSnackbar("Permission denied", context);
          }
        }, onError: (error) {
          print('error REQ 1== $error');
        });
      }
    }, onError: (error) {
      print('error REQ 2== $error');
      showSnackbar("An error occurred requesting permission", context);
      return PermissionStatus.unknown;
    });
  }

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

  downloadFile(
    FbLoginRespModel fbLoginRespModel,
    BuildContext context,
    bool isFBLogin,
    BuildContext mainBuildContext,
  ) async {
    pr.show();
    Directory externalStorageDirectory = await getExternalStorageDirectory();
    String dirPath = externalStorageDirectory.path +
        Platform.pathSeparator +
        'Connections' +
        Platform.pathSeparator +
        'app' +
        Platform.pathSeparator +
        'profpics' +
        Platform.pathSeparator;
    print('dirpath=${dirPath}');
    Directory imgDir = new Directory(dirPath);
    final imgDirexists = await imgDir.exists();
    if (!imgDirexists) {
      await imgDir.create(recursive: true).then((onValue) async {
        imgDir = onValue;
        print('NEW path==${imgDir.path}');
        //await downloadAndSavePath(imgDir, fbLoginRespModel, context);
        await downloadAndSavePathDio(
          imgDir,
          fbLoginRespModel,
          context,
          isFBLogin,
          mainBuildContext,
        );
        /*WidgetsFlutterBinding.ensureInitialized();
        await FlutterDownloader.initialize().then((onValue) async {
          final taskId = await FlutterDownloader.enqueue(
            url:
                'https://graph.facebook.com/${fbLoginRespModel.id}/picture?width=9999',
            savedDir: imgDir.path, fileName: "profpic.png",
            showNotification:
                true, // show download progress in status bar (for Android)
            openFileFromNotification:
                true, // click on notification to open downloaded file (for Android)
          );
          print('taskId==${taskId}');
          List<DownloadTask> task =
              await FlutterDownloader.loadTasksWithRawQuery(
                  query: 'SELECT * FROM task WHERE task_id=\'${taskId}\'');
          if (task.length > 0) {
            DownloadTask downloadTask = task[0];
            print('downloadTask fl name==${downloadTask.filename}');
            print('downloadTask fold path==${downloadTask.savedDir}');
            final database = Provider.of<AppDatabase>(context);
          }
        }, onError: (error) {});*/
      }, onError: (error) {
        print('downloadFile error== ${error}');
        dissmissPDialog(pr);
      });
    } else {
      //await downloadAndSavePath(imgDir, fbLoginRespModel, context);
      await downloadAndSavePathDio(
        imgDir,
        fbLoginRespModel,
        context,
        isFBLogin,
        mainBuildContext,
      );
      /*print('OLD path==${imgDir.path}');
      WidgetsFlutterBinding.ensureInitialized();
      await FlutterDownloader.initialize().then((onValue) async {
        final taskId = await FlutterDownloader.enqueue(
          url:
              'https://graph.facebook.com/${fbLoginRespModel.id}/picture?width=9999',
          savedDir: imgDir.path, fileName: "profpic.png",
          showNotification:
              true, // show download progress in status bar (for Android)
          openFileFromNotification:
              true, // click on notification to open downloaded file (for Android)
        );
        print('taskId==${taskId}');
        List<DownloadTask> task = await FlutterDownloader.loadTasksWithRawQuery(
            query: 'SELECT * FROM task WHERE task_id=\'${taskId}\'');
        if (task.length > 0) {
          DownloadTask downloadTask = task[0];
          print('downloadTask fl name==${downloadTask.filename}');
          print('downloadTask fold path==${downloadTask.savedDir}');
          final database = Provider.of<AppDatabase>(context);
        }
      }, onError: (error) {});*/
    }
  }

  downloadAndSavePathDio(
    Directory imgDir,
    FbLoginRespModel fbLoginRespModel,
    BuildContext context,
    bool isFBLogin,
    BuildContext mainBuildContext,
  ) async {
    try {
      String TAG = 'downloadAndSavePathDio:';
      print(TAG + 'path==${imgDir.path}');
      String profpicOnlinePath = fbLoginRespModel.online_filepath;
      print(TAG + 'profpicOnlinePath==${profpicOnlinePath}');
      print(TAG + 'fbLoginRespModel.token==${fbLoginRespModel.token}');
      String filename = 'profpic.png';

      /*final taskId = await FlutterDownloader.enqueue(
        url: profpicOnlinePath,
        savedDir: imgDir.path,
        fileName: "profpic.png",
        showNotification: true,
        openFileFromNotification: false,
        headers: headers,
      );*/
      var dio = Dio();

      Map<String, String> headers = {};
      if (isFBLogin) {
        if (fbLoginRespModel.token != null) {
          headers['Authorization'] = 'Bearer ' + fbLoginRespModel.token;
        }
      }
      Response response = await dio.get(
        profpicOnlinePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          /*extra: {
            'Authorization': fbLoginRespModel.token,
          },*/
          headers: ((isFBLogin ? headers : null)),
        ),
      );

      File file = File(imgDir.path + filename);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      /* print('taskId==${taskId}');
      List<DownloadTask> task = await FlutterDownloader.loadTasksWithRawQuery(
          query: 'SELECT * FROM task WHERE task_id=\'${taskId}\'');*/
      //if (task.length > 0) {
      //DownloadTask downloadTask = task[0];
      /*print('downloadTask fl name==${downloadTask.filename}');
        print('downloadTask fold path==${downloadTask.savedDir}');*/
      print('downloadTask fl name==${filename}');
      print('downloadTask fold path==${imgDir.path}');

      //AppDatabase database = Provider.of<AppDatabase>(context);
      //final userProfile = UserprofileCompanion(
      //filename: moor.Value(downloadTask.filename),
      //localpath: moor.Value(downloadTask.savedDir),
      //filename: moor.Value(filename),
      //localpath: moor.Value(imgDir.path),
      //);
      /* var insertedData =
          await database.userprofileDao.insertUserprofile(userProfile);*/

      LoginRespModel loginRespModel = new LoginRespModel();
      loginRespModel.username = fbLoginRespModel.first_name;
      loginRespModel.email = fbLoginRespModel.email;
      loginRespModel.fullname = fbLoginRespModel.name;
      //loginRespModel.local_profile_picture_path = downloadTask.savedDir;
      //loginRespModel.local_profile_picture_filename = downloadTask.filename;
      loginRespModel.local_profile_picture_path = imgDir.path;
      loginRespModel.local_profile_picture_filename = filename;
      loginRespModel.isinsignupprocess = true;
      //loginRespModel.age = 24;

      List<UserProfileRespModel> usersProfile = [];
      //UserProfileRespModel userProfileRespModel = new UserProfileRespModel();
      //userProfileRespModel.picture = fbLoginRespModel.online_filepath;
      //usersProfile.add(userProfileRespModel);
      loginRespModel.usersProfile = usersProfile;
      saveSharedPrefs(
        loginRespModel,
        context,
        mainBuildContext,
      );
      /*} else {
        dissmissPDialog(pr);
        showSnackbar('Log In failed', context);
      }*/
      /*}, onError: (error) {
      print('downloadAndSavePath error== ${error}');
      dissmissPDialog(pr);
    });*/
    } catch (error) {
      print('downloadAndSavePath error==${error}');
      dissmissPDialog(pr);
      showSnackbar('An error ocurred while loggin in', context);
    }
  }

  /*downloadAndSavePath(Directory imgDir, FbLoginRespModel fbLoginRespModel,
      BuildContext context) async {
    try {
      print('path==${imgDir.path}');
      String profpicOnlinePath = fbLoginRespModel.online_filepath;
      print('profpicOnlinePath==${profpicOnlinePath}');
      /*String profpicOnlinePath =
        'https://graph.facebook.com/${fbLoginRespModel.id}/picture?width=9999';
    fbLoginRespModel.online_filepath = profpicOnlinePath;*/
      // WidgetsFlutterBinding.ensureInitialized();
      //await FlutterDownloader.initialize().then((onValue) async {
      Map<String, String> headers = new Map();
      if (fbLoginRespModel.token != null) {
        headers['Authorization'] = fbLoginRespModel.token;
      }

      final taskId = await FlutterDownloader.enqueue(
        url: profpicOnlinePath,
        savedDir: imgDir.path,
        fileName: "profpic.png",
        showNotification: true,
        openFileFromNotification: false,
        headers: headers,
      );

      print('taskId==${taskId}');
      List<DownloadTask> task = await FlutterDownloader.loadTasksWithRawQuery(
          query: 'SELECT * FROM task WHERE task_id=\'${taskId}\'');
      if (task.length > 0) {
        DownloadTask downloadTask = task[0];
        print('downloadTask fl name==${downloadTask.filename}');
        print('downloadTask fold path==${downloadTask.savedDir}');

        AppDatabase database = Provider.of<AppDatabase>(context);
        final userProfile = UserprofileCompanion(
          filename: moor.Value(downloadTask.filename),
          localpath: moor.Value(downloadTask.savedDir),
        );
        var insertedData =
            await database.userprofileDao.insertUserprofile(userProfile);

        LoginRespModel loginRespModel = new LoginRespModel();
        loginRespModel.username = fbLoginRespModel.first_name;
        loginRespModel.email = fbLoginRespModel.email;
        loginRespModel.fullname = fbLoginRespModel.name;
        loginRespModel.local_profile_picture_path = downloadTask.savedDir;
        loginRespModel.local_profile_picture_filename = downloadTask.filename;
        loginRespModel.isinsignupprocess = true;
        //loginRespModel.age = 24;

        List<UserProfileRespModel> usersProfile = [];
        //UserProfileRespModel userProfileRespModel = new UserProfileRespModel();
        //userProfileRespModel.picture = fbLoginRespModel.online_filepath;
        //usersProfile.add(userProfileRespModel);
        loginRespModel.usersProfile = usersProfile;
        saveSharedPrefs(loginRespModel, context);
      } else {
        dissmissPDialog(pr);
        showSnackbar('Log In failed', context);
      }
      /*}, onError: (error) {
      print('downloadAndSavePath error== ${error}');
      dissmissPDialog(pr);
    });*/
    } catch (error) {
      print('downloadAndSavePath error==${error}');
      dissmissPDialog(pr);
      showSnackbar('An error ocurred while loggin in', context);
    }
  }*/

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  gotoLogInPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LogInPage()),
    );
  }

  void openHomePage(BuildContext context) {
    Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => new Index()));
  }

  Future<void> openPasswordResetPage(BuildContext context) async {
    /*Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => new PasswordResetPage()));*/
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PasswordResetPage()),
    );
    if(result!=null){
      showSnackbarWBgCol(result, context, DatingAppTheme.green);
    }
  }

  void openSignUpPage() {
    final signUpPageRev = OnBoardingConcept();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => signUpPageRev),
    );
  }

  void openSignUpPage_pushReplacement() {
    final signUpPageRev = OnBoardingConcept();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => signUpPageRev),
    );
  }

  clearOnaBoardingData() async {
    await onboardingDao.deleteAllOnboardingsIndBFuture();
  }

  String validateEmail(String value) {
    /*Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Invalid Email';
    else
      return null;*/

    if (value.isEmpty || !(value.trim().length > 0)) {
      return 'Invalid Username';
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty || !(value.trim().length > 0)) {
      return 'Invalid Password';
    }
    return null;
  }

  void logInUpClicked(BuildContext context) {
    print('logInUpClicked');
    if (_liformKey.currentState.validate()) {
      _liformKey.currentState.save();
      //postUserDetails(context);
      post_User_Login(
        context,
        context,
        userNameController.text,
        passwordController.text,
        onLoginButtonClicked_NavigationDataBLoC,
      );
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  postUserDetails(BuildContext context) async {
    //pr.show();
    refresh_W_Data_Isshow_NavigationDataBLoC(
        onLoginButtonClicked_NavigationDataBLoC, true);
    String subm_username = "Null";
    String subm_password = "Null";
    if (ifStringValid(userNameController.text)) {
      subm_username = userNameController.text;
    }
    if (ifStringValid(passwordController.text)) {
      subm_password = passwordController.text;
    }

    //try {
    var response;
    /*UsernameValidator usernameValidatorBld = UsernameValidator((b) => b);
      final usernameValidatorBld_builder = usernameValidatorBld.toBuilder();
      usernameValidatorBld_builder.username = subm_username;
      usernameValidatorBld_builder.password = subm_password;
      usernameValidatorBld_builder.success = false;
      usernameValidatorBld_builder.message = "None";
      usernameValidatorBld_builder.email = "None";
      usernameValidatorBld_builder.birthday = "None";
      UsernameValidator usernameValidator =
          usernameValidatorBld_builder.build();*/

    UserSignUpRespModel usernameValidator = new UserSignUpRespModel();
    usernameValidator.username = subm_username;
    usernameValidator.password = subm_password;
    usernameValidator.success = false;
    usernameValidator.message = "None";
    usernameValidator.email = "None";
    usernameValidator.birthday = "None";
    usernameValidator.quote = "None";

    response = await Provider.of<PostApiService>(context)
        .loginwtoken(usernameValidator);
    if (response != null) {
      var respBody = response.body;
      LoginUserRespJModel loginUserRespJModel =
          LoginUserRespJModel.fromJson(respBody);
      LoginRespModel loginRespModel = loginUserRespJModel.user;
      loginRespModel.isinsignupprocess = false;
      //LoginRespModel loginRespModel = response;
      if (!loginRespModel.activestatus) {
        dissmissPDialog(pr);
        refresh_W_Data_Isshow_NavigationDataBLoC(
            onLoginButtonClicked_NavigationDataBLoC, false);
        showSnackbar(loginRespModel.username, context);
      } else {
        //Save to shared preferences
        UserSessionSharedPrefs userSessionSharedPrefs =
            new UserSessionSharedPrefs();
        userSessionSharedPrefs.setUserSession(json.encode(loginRespModel)).then(
            (onValue) {
          print('SIGN UP SUCCESS');
          dissmissPDialog(pr);
          refresh_W_Data_Isshow_NavigationDataBLoC(
              onLoginButtonClicked_NavigationDataBLoC, false);
          showSnackbar("Welcome", context);
          openHomePage(context);
        }, onError: (error) {
          print('error== $error');
          dissmissPDialog(pr);
          refresh_W_Data_Isshow_NavigationDataBLoC(
              onLoginButtonClicked_NavigationDataBLoC, false);
          showSnackbar("An error ocurred", context);
        });
      }
    } else {
      dissmissPDialog(pr);
      refresh_W_Data_Isshow_NavigationDataBLoC(
          onLoginButtonClicked_NavigationDataBLoC, false);
      showSnackbar("An error ocurred", context);
    }
    /*} catch (error) {
      print('error1==${error}');
      dissmissPDialog(pr);
      showSnackbar("An error ocurred", context);
    }*/
  }

  saveSharedPrefs(LoginRespModel loginRespModel, BuildContext context,
      BuildContext mainBuildContext) {
    //Save to shared preferences
    UserSessionSharedPrefs userSessionSharedPrefs =
        new UserSessionSharedPrefs();
    userSessionSharedPrefs.setUserSession(json.encode(loginRespModel)).then(
        (onValue) {
      dissmissPDialog(pr);
      print('SIGN UP SUCCESS');
      dissmissPDialog(pr);
      showSnackbar("Welcome", context);
      //openHomePage(context);
      print('saveSharedPrefs:saved NEW==' + json.encode(loginRespModel));
      //Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
      //Navigator.pop(context, true);
      //Navigator.push(context, route)
      //openSignUpPage();
      openSignUpPage_pushReplacement();
    }, onError: (error) {
      print('error== $error');
      dissmissPDialog(pr);
      showSnackbar("An error ocurred", context);
    });
  }

  /*postUserDetailsFaceBookLogin(BuildContext context, FacebookLoginResult facebookLoginResult) async {
    facebookLoginResult.accessToken;

    pr.show();
    String subm_username = "Null";
    String subm_password = "Null";
    String subm_email = "Null";
    String subm_birthday = "Null";
    String subm_quote = "Null";
    if (dataValidators.ifStringValid(userNameController.text)) {
      subm_username = userNameController.text;
    }
    if (dataValidators.ifStringValid(passwordController.text)) {
      subm_password = passwordController.text;
    }
    if (dataValidators.ifStringValid(emailController.text)) {
      subm_email = emailController.text;
    }
    if (dataValidators.ifStringValid(birthdayController.text)) {
      DateTime subm_format_DateTime= DateTimeField.tryParse(birthdayController.text,format);
      if(subm_format_DateTime!=null){
        var subm_format = DateFormat("yyyy-MM-dd");
        String subm_format_String= DateTimeField.tryFormat(subm_format_DateTime,subm_format);
        print('subm_format_String=${subm_format_String}');
        subm_birthday = subm_format_String;
        print('birthday=${subm_birthday}');
      }else{
        subm_birthday = "Null";
      }

    }
    if (dataValidators.ifStringValid(quoteController.text)) {
      subm_quote = quoteController.text;
    }
    //profilepicFilePath
    */ /* if (dataValidators.ifStringValid(profilepicFilePath)) {
      dissmissPDialog(pr);
      showSnackbar('Please pick a profile picture', context);
    }*/ /*

*/ /*    UsernameValidator usernameValidator = UsernameValidator((b) => b
      ..username = subm_username
      ..password = subm_password
      ..email = subm_email
      ..message = 'None'
      ..success = false
      ..birthday = subm_birthday);*/ /*
    //Response<UsernameValidator> response;
    var response;
    SnackBar snackBar;
    try {
      //SPLIT PATH TO GET FILENAME
      List<String> imgPathSplit = profilepicFilePath.split("/");
      String filename = imgPathSplit[imgPathSplit.length - 1];
      print('filemname=${filename}');

*/ /*      http.MultipartFile.fromPath("", profilepicFilePath).then((onValue) async {
        http.MultipartFile birthdayImg = onValue;
        response =
            await Provider.of<PostApiService>(context).signupprocessmultipart(
          //usernameValidator,
          subm_username,
          subm_password,
          subm_email,
          subm_birthday,
          birthdayImg,
        );
      }, onError: (error) {});*/ /*
      response = await Provider.of<PostApiService>(context)
          .signupprocessmultipart(
        //usernameValidator,
        "application/json",
        subm_username,
        subm_password,
        subm_email,
        subm_birthday,
        subm_quote,
        profilepicFilePath,
      );

      print('response.body==${response.body}');
      */ /*print('json==${json.decode(response.body)}');
    dynamic supres=json.decode(response.body);*/ /*
      //Map<String, dynamic> map = jsonDecode(response.body);
      Map<String, dynamic> map = response.body;
      dissmissPDialog(pr);
      showSnackbar(
        */ /*((supres.message != null
            ? response.body.message
            : 'An error ocurred'))
        ,
        context*/ /*

          ((map['message'] != null ? map['message'] : 'An error ocurred')),
          context);
      */ /*.then((onValue) {
      // response = onValue;
      dissmissPDialog(pr);
      showSnackbar(
          ((onValue.body.message != null
              ? onValue.body.message
              : 'An error ocurred')),
          context);
    }, onError: (error) {
      showSnackbar('An error ocurred', context);
      print('error999999999==${error}');
    });*/ /*

      */ /*response =
              await Provider.of<PostApiService>(context)
                  .postPost(
                usernameValidator,
              );

              dissmissPDialog(pr);
                    showSnackbar(
                        ((response.body.message != null
                            ? response.body.message
                            : 'An error ocurred')),
                        context);*/ /*
    } catch (error) {
      print('error1==${error}');
      dissmissPDialog(pr);
      showSnackbar('An error ocurred', context);
    }

    dissmissPDialog(pr);
  }*/

  void showSnackbar(String message, BuildContext context) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            // Some code to undo the change.
          }),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void dissmissPDialog(ProgressDialog pr) {
    try {
      if (pr != null && pr.isShowing()) {
        Navigator.of(context).pop();
        pr.hide().then((isHidden) {
          print(isHidden);
        });
      }
    } catch (error) {
      print('error dismissing pdialog ${error}');
    }
  }
}

typedef IntindexCallback = void Function(int intindex);
