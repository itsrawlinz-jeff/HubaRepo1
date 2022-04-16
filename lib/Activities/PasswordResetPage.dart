import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleBLoC.dart';
import 'package:dating_app/Bloc/Streams/PageChanged/OnBoardingPageBLoC.dart';
import 'package:dating_app/Bloc/Streams/PageChanged/OnBoardingPageEvent.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/auth/post_put_request_pass_reset.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/authentication/PasswordResetRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'LogInPage.dart';

import 'package:dating_app/tabs/Index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PasswordResetPage extends StatefulWidget {
  final IntindexCallback navigate;

  PasswordResetPage({
    Key key,
    this.navigate,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PasswordResetPageState();
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

class _PasswordResetPageState extends State<PasswordResetPage> {
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  BuildContext scaffoldBuildContext;
  final GlobalKey<FormState> _liformKey = GlobalKey<FormState>();

  bool phone_no_valid = false;
  bool otp_valid = false;
  String otpString;
  bool _autoValidate = false;
  KeyBoardVisibleBLoC resetPassBLoC = KeyBoardVisibleBLoC();
  OnBoardingPageBLoC loginBtnPageBLoC = OnBoardingPageBLoC();
  PasswordResetRespJModel passwordResetRespJModel = PasswordResetRespJModel();

  //reset
  TextEditingController ctrlF1 = TextEditingController();
  FocusNode fnf1 = FocusNode();
  TextEditingController ctrlF2 = TextEditingController();
  FocusNode fnf2 = FocusNode();
  TextEditingController ctrlF3 = TextEditingController();
  FocusNode fnf3 = FocusNode();
  TextEditingController ctrlF4 = TextEditingController();
  FocusNode fnf4 = FocusNode();
  TextEditingController ctrlF5 = TextEditingController();
  FocusNode fnf5 = FocusNode();

  bool passwordVisible = false;
  bool newpasswordVisible = false;
  TextEditingController passController1 = TextEditingController();
  FocusNode passFocusNode2 = FocusNode();
  TextEditingController passController2 = TextEditingController();
  FocusNode passFocusNode1 = FocusNode();

  NavigationDataBLoC _wd_pass1_Container_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC _wd_pass2_Container_NavigationDataBLoC =
      NavigationDataBLoC();
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      Padding(
        padding: EdgeInsets.only(left: 0.0, right: 2.0),
        child: new Container(
          color: Colors.transparent,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
            alignment: Alignment.center,
            decoration: new BoxDecoration(
                //color: Color.fromRGBO(0, 0, 0, 0.1),
                color: DatingAppTheme.white,
                border: new Border.all(
                    width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
                borderRadius: new BorderRadius.circular(4.0)),
            child: TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
              controller: ctrlF1,
              focusNode: fnf1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              enabled: true,
              autofocus: false,
              textAlign: TextAlign.center,
              style: DatingAppTheme.txt_OTP_TextStyle,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              onSubmitted: (String str) {
                fnf2.requestFocus();
              },
              onChanged: (String val) {
                fnf2.requestFocus();
                ctrlF2.selection =
                    TextSelection.fromPosition(TextPosition(offset: 0));
              },
              onTap: () {
                ctrlF1.selection =
                    TextSelection.fromPosition(TextPosition(offset: 0));
              },
            )),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              //color: Color.fromRGBO(0, 0, 0, 0.1),
              color: DatingAppTheme.white,
              border: new Border.all(
                  width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: new BorderRadius.circular(4.0)),
          child: new TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            controller: ctrlF2,
            focusNode: fnf2,
            autofocus: false,
            enabled: true,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.center,
            style: DatingAppTheme.txt_OTP_TextStyle,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            onSubmitted: (String str) {
              fnf3.requestFocus();
            },
            onChanged: (String val) {
              fnf3.requestFocus();
              ctrlF3.selection =
                  TextSelection.fromPosition(TextPosition(offset: 0));
            },
            onTap: () {
              ctrlF2.selection =
                  TextSelection.fromPosition(TextPosition(offset: 0));
            },
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              //color: Color.fromRGBO(0, 0, 0, 0.1),
              color: DatingAppTheme.white,
              border: new Border.all(
                  width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: new BorderRadius.circular(4.0)),
          child: new TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            focusNode: fnf3,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            controller: ctrlF3,
            textAlign: TextAlign.center,
            autofocus: false,
            enabled: true,
            style: DatingAppTheme.txt_OTP_TextStyle,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            onSubmitted: (String str) {
              fnf4.requestFocus();
            },
            onChanged: (String val) {
              fnf4.requestFocus();
              ctrlF4.selection =
                  TextSelection.fromPosition(TextPosition(offset: 0));
            },
            onTap: () {
              ctrlF3.selection =
                  TextSelection.fromPosition(TextPosition(offset: 0));
            },
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              //color: Color.fromRGBO(0, 0, 0, 0.1),
              color: DatingAppTheme.white,
              border: new Border.all(
                  width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: new BorderRadius.circular(4.0)),
          child: new TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            focusNode: fnf4,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            controller: ctrlF4,
            autofocus: false,
            enabled: true,
            style: DatingAppTheme.txt_OTP_TextStyle,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            onSubmitted: (String str) {
              fnf5.requestFocus();
            },
            onChanged: (String val) {
              fnf5.requestFocus();
              ctrlF5.selection =
                  TextSelection.fromPosition(TextPosition(offset: 0));
            },
            onTap: () {
              ctrlF4.selection =
                  TextSelection.fromPosition(TextPosition(offset: 0));
            },
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              //color: Color.fromRGBO(0, 0, 0, 0.1),
              color: DatingAppTheme.white,
              border: new Border.all(
                  width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: new BorderRadius.circular(4.0)),
          child: new TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            focusNode: fnf5,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            controller: ctrlF5,
            autofocus: false,
            enabled: true,
            style: DatingAppTheme.txt_OTP_TextStyle,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            onSubmitted: (String str) {
              fnf5.unfocus();
            },
            onChanged: (String val) {},
            onTap: () {
              ctrlF5.selection =
                  TextSelection.fromPosition(TextPosition(offset: 0));
            },
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 2.0, right: 0.0),
        child: new Container(
          color: Colors.transparent,
        ),
      ),
    ];
    return Scaffold(
      body: Builder(
        builder: (BuildContext sCafoldcontext) {
          scaffoldBuildContext = sCafoldcontext;
          return Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background-tinder.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    /*SizedBox(height: 150),
                SizedBox(height: 75),
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
                        TextSpan(text: 'By signing up, you agree with our '),
                        _LinkTextSpan(
                            text: 'Terms',
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                            url: 'http://www.google.com'),
                        TextSpan(text: ' of Services and '),
                        _LinkTextSpan(
                            text: 'Privacy Policy',
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                            url: 'http://www.google.com')
                      ]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  //onTap: () => openHomePage(), // handle your onTap here
                  child: Container(
                    height: 60,
                    width: 300,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 2),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 40.0,
                            left: 40.0,
                          ),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
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
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  //onTap: () => openHomePage(), // handle your onTap here
                  child: Container(
                    height: 60,
                    width: 300,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 2),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 40.0,
                            left: 40.0,
                          ),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
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
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  //onTap: () => openHomePage(), // handle your onTap here
                  child: Container(
                    height: 60,
                    width: 300,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 2),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 40.0,
                            left: 40.0,
                          ),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                color: Colors.white,
                                size: 22.0,
                              ),
                              hintText: "Confirm Password",
                              hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () => resetPasswordClicked(), // handle your onTap here
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                    child: Container(
                      height: 60,
                      child: Center(
                        child: Text(
                          'RESET PASSWORD',
                          style: TextStyle(color: Colors.white, fontSize: 16,
                              fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy),
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                              colors: [Colors.pinkAccent, Colors.pink])),
                    ),
                  ),
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
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Form(
                        key: _liformKey,
                        autovalidate: _autoValidate,
                        child:  StreamBuilder(
                          stream: resetPassBLoC.stream_counter,
                          builder: (context, snapshot) {
                            if (snapshot.hasError)
                              return requestPassReset(context, sCafoldcontext);
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return requestPassReset(
                                    context, sCafoldcontext);
                              case ConnectionState.waiting:
                                return requestPassReset(
                                    context, sCafoldcontext);
                              case ConnectionState.active:
                                try {
                                  bool isrequest = snapshot.data;
                                  if (!isrequest) {
                                    return resetPass(
                                        widgetList, context, sCafoldcontext);
                                  }
                                } catch (error) {}
                                return requestPassReset(
                                    context, sCafoldcontext);
                              case ConnectionState.done:
                                try {
                                  bool isrequest = snapshot.data;
                                  if (!isrequest) {
                                    return resetPass(
                                        widgetList, context, sCafoldcontext);
                                  }
                                } catch (error) {}
                                return requestPassReset(
                                    context, sCafoldcontext);
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          StreamBuilder(
                            stream: resetPassBLoC.stream_counter,
                            builder: (context, snapshot) {
                              if (snapshot.hasError)
                                return requestPasswordResetButton(
                                    sCafoldcontext);
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  return requestPasswordResetButton(
                                      sCafoldcontext);
                                case ConnectionState.waiting:
                                  return requestPasswordResetButton(
                                      sCafoldcontext);
                                case ConnectionState.active:
                                  try {
                                    bool isrequest = snapshot.data;
                                    if (!isrequest) {
                                      return resetPasswordButton(
                                          sCafoldcontext);
                                    }
                                  } catch (error) {}
                                  return requestPasswordResetButton(
                                      sCafoldcontext);
                                case ConnectionState.done:
                                  try {
                                    bool isrequest = snapshot.data;
                                    if (!isrequest) {
                                      return resetPasswordButton(
                                          sCafoldcontext);
                                    }
                                  } catch (error) {}
                                  return requestPasswordResetButton(
                                      sCafoldcontext);
                              }
                            },
                          ),
                          StreamBuilder(
                            stream: loginBtnPageBLoC.stream_counter,
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
                                  if (snapshot.data == 0) {
                                    return circularProgressIndicator();
                                  }
                                  if (snapshot.data == 1) {
                                    return invisibleWidget();
                                  }
                                  break;
                                case ConnectionState.done:
                                  if (snapshot.data == 0) {
                                    return circularProgressIndicator();
                                  }
                                  if (snapshot.data == 1) {
                                    return invisibleWidget();
                                  }
                                  break;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  gotoLogInPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LogInPage()),
    );
  }

  void resetPasswordClicked() {
    /*Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => new Index()));*/
    //validate details
    //post
  }

  //BUILD WIDGETS
  //request pass reset
  Widget requestPassReset(BuildContext context, BuildContext sCafoldcontext) {
    return Container(
      height: 60,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.white, style: BorderStyle.solid, width: 2),
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
            child: Padding(
          padding: EdgeInsets.only(
            right: 40.0,
            left: 40.0,
          ),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(fontSize: 16.0, color: Colors.white),
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
            ),
            //validator: validateEmail,
            focusNode: emailFocusNode,
            controller: emailController,
          ),
        )),
      ),
    );

    /*Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        /*Container(
          width: MediaQuery.of(context).size.width / 3,
          child: Column(
            children: <Widget>[
              AuthenticationCountryPicker(
                dense: false,
                selectedCountry: defKenya,
                showFlag: true, //displays flag, true by default
                showDialingCode: true, //displays dialing code, false by default
                showName: false, //displays country name, true by default
                onChanged: (Country country) {
                  defKenya = country;
                },
              ),
            ],
          ),
        ),*/
       /* SizedBox(
          width: 5,
        ),*/
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            obscureText: false,
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              fillColor: DatingAppTheme.background,
              filled: true,
              hintText: 'phone no/email',
              hintStyle: DatingAppTheme.auth_hint_TextStyle,
              errorStyle: DatingAppTheme
                  .auth_error_TextStyle,
            ),
            style: DatingAppTheme.auth_txt_FieldTextStyle,
            controller: emailController,
            validator: validateEmail,
            onFieldSubmitted: (String str) {
              requestPasswordResetButtonClicked(context, sCafoldcontext);
            },
            focusNode: emailFocusNode,
          ),
        ),
      ],
    );*/
  }

  requestPasswordResetButtonClicked(
      BuildContext context, BuildContext sCafoldcontext) {
    print("requestPasswordResetButtonClicked");
    /*if (_liformKey.currentState.validate()) {
      _liformKey.currentState.save();*/

    /* passwordResetRespJModel.phone_number =
             emailController.text;*/
    //passwordResetRespJModel.email
    /*authapicalls.resetPass(context, sCafoldcontext, passwordResetRespJModel,
            loginBtnPageBLoC, resetPassBLoC);*/

    /*} else {
      setState(() {
        _autoValidate = true;
      });
    }*/

    if (_data_valid()) {
      //post

      post_put_request_pass_reset(
        context,
        sCafoldcontext,
        passwordResetRespJModel,
        loginBtnPageBLoC,
        resetPassBLoC,
      );
    } else {
      loginBtnPageBLoC.onBoardingPage_visible_event_sink
          .add(OnBoardingPageChangedEvent(1));
    }
  }

  bool _data_valid() {
    bool _is_validateEmail = _validateEmail();
    bool _is_validatePhone = _validatePhone();

    if (_is_validateEmail || _is_validatePhone) {
      if (_is_validateEmail) {
        passwordResetRespJModel.email = emailController.text;
        passwordResetRespJModel.phone_number = null;
      }
      if (_is_validatePhone) {
        passwordResetRespJModel.email = null;
        passwordResetRespJModel.phone_number = emailController.text;
      }
      return true;
    } else {
      showSnackbarWBgCol(
          'Invalid phone no/email', scaffoldBuildContext, DatingAppTheme.red);
    }
    return false;
  }

  /* String validateEmail(String value) {
    /*Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Invalid email';
    else
      return null;*/

    /*phone_no_valid = true;
    if (isStringValid(value)) {
      List<String> strList = value.split('');
      List<String> stringsNotnumeric = [];
      for (String str in strList) {
        bool isnumeric = isNumeric(str);
        /* if (!isnumeric) {
          phone_no_valid = false;
          showSnackbar('Invalid phone no', scaffoldBuildContext);
          // return 'Invalid phone no';
          return null;
        }*/
        if (!isnumeric) {
          stringsNotnumeric.add(str);
        }
      }
      if (stringsNotnumeric.length > 0) {
        phone_no_valid = false;
        showSnackbarWBgCol(
            'Invalid phone no', scaffoldBuildContext, DatingAppTheme.red);
        return null;
      } else {
        Pattern pnonenoPattern = r'^(7)[0-9]{8}$';
        RegExp regex = new RegExp(pnonenoPattern);
        if (!regex.hasMatch(value)) {
          phone_no_valid = false;
          showSnackbarWBgCol(
              'Invalid phone no', scaffoldBuildContext, DatingAppTheme.red);
          return null;
        } else {
          phone_no_valid = true;
          return null;
        }
      }
    } else {
      //return 'Invalid phone no';
      phone_no_valid = false;
      showSnackbarWBgCol(
          'Invalid phone no', scaffoldBuildContext, DatingAppTheme.red);
      return null;
    }*/

    bool _is_validateEmail = _validateEmail();
    print(_is_validateEmail.toString());
    bool _is_validatePhone = _validatePhone();
    print(_is_validatePhone.toString());

    if (_is_validateEmail || _is_validatePhone) {
    } else {
      showSnackbarWBgCol(
          'Invalid phone no/email', scaffoldBuildContext, DatingAppTheme.red);
    }
   */

  bool _validateEmail() {
    if (!isStringValid(emailController.text)) {
      return false;
    } else {
      RegExp regex = new RegExp(get_Email_Pattern());
      if (!regex.hasMatch(emailController.text)) {
        return false;
      }
    }
    return true;
  }

  bool _validatePhone() {
    if (!isStringValid(emailController.text)) {
      return false;
    } else {
      List<String> strList = emailController.text.split('');
      List<String> stringsNotnumeric = [];
      for (String str in strList) {
        bool isnumeric = isNumeric(str);
        if (!isnumeric) {
          stringsNotnumeric.add(str);
        }
      }
      if (stringsNotnumeric.length > 0) {
        return false;
      }
    }
    return true;
  }

  Widget requestPasswordResetButton(BuildContext sCafoldcontext) {
    return RaisedButton(
      onPressed: () =>
          requestPasswordResetButtonClicked(context, sCafoldcontext),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
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
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
        ),
        child: Container(
          constraints: const BoxConstraints(
              minWidth: 88.0, minHeight: 60), // min sizes for Material buttons
          alignment: Alignment.center,
          child: Text(
            'Request',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );

    /*Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          requestPasswordResetButtonClicked(context, sCafoldcontext);
        },
        splashColor: DatingAppTheme.grey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(29),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(
            top: 15,
            bottom: 15,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    DatingAppTheme.colorAdrianRed.withOpacity(0.8),
                    DatingAppTheme.colorAdrianBlue.withOpacity(0.8),
                  ])),
          child: Text(
            'Request',
            style: DatingAppTheme
                .auth_Btns_TextStyle,
          ),
        ),
      ),
    );*/
  }

  //reset pass
  Widget resetPass(List<Widget> widgetList, BuildContext context,
      BuildContext sCafoldcontext) {
    /*smsReceiver = new SmsReceiver();
    smsReceiver.onSmsReceived.listen((SmsMessage msg) {
      print(msg.body);
      print(msg.sender);
      if (msg.sender.trim() == 'ADRIANKE') {
        List<String> splitMessageList = msg.body.split('.');
        if (splitMessageList.length > 0) {
          String stringWithCode = splitMessageList[0];
          List<String> stringWithCodeList = stringWithCode.split(' ');
          if (stringWithCodeList.length > 0) {
            String codeStr = stringWithCodeList[stringWithCodeList.length - 1];
            print('code is ${codeStr}');
            List<String> splitCodeStrList = codeStr.split('');
            if (splitCodeStrList.length > 0) {
              ctrlF1.text = splitCodeStrList[0];
            }
            if (splitCodeStrList.length > 1) {
              ctrlF2.text = splitCodeStrList[1];
            }
            if (splitCodeStrList.length > 2) {
              ctrlF3.text = splitCodeStrList[2];
            }
            if (splitCodeStrList.length > 3) {
              ctrlF4.text = splitCodeStrList[3];
            }
          }
        }
      }
    });*/
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GridView.count(
              crossAxisCount: 7,
              mainAxisSpacing: 10.0,
              shrinkWrap: true,
              primary: false,
              scrollDirection: Axis.vertical,
              children: List<Container>.generate(
                  7, (int index) => Container(child: widgetList[index]))),
          SizedBox(
            height: 20,
          ),
          /*TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          obscureText: !newpasswordVisible,
          decoration: InputDecoration(
            border: InputBorder.none,
            errorMaxLines: 2,
            fillColor: DatingAppTheme.background,
            filled: true,
            hintText: 'new password',
            hintStyle: DatingAppTheme.auth_hint_TextStyle,
            errorStyle: DatingAppTheme.auth_error_TextStyle,
            suffixIcon: IconButton(
              icon: Icon(
                newpasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: DatingAppTheme.grey,
              ),
              onPressed: () {
                setState(() {
                  newpasswordVisible = !newpasswordVisible;
                });
              },
            ),
          ),
          style: DatingAppTheme.auth_txt_FieldTextStyle,
          controller: passController1,
          //validator: validatePassword1,
          onFieldSubmitted: (String str) {
            passFocusNode2.requestFocus();
          },
          focusNode: passFocusNode1,
          textAlign: TextAlign.center,
        ),*/
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 60,
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white,
                        style: BorderStyle.solid,
                        width: 2),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                      child: Padding(
                    padding: EdgeInsets.only(
                      right: 40.0,
                      left: 40.0,
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      obscureText: !newpasswordVisible,

                      decoration: InputDecoration(
                        border: InputBorder.none,
                        errorMaxLines: 2,
                        hintText: 'new password',
                        hintStyle: TextStyle(
                          fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          color: Colors.white,
                        ),
                        //DatingAppTheme.auth_hint_TextStyle,
                        errorStyle: TextStyle(
                          fontFamily: DatingAppTheme.font_AvenirLTStd_Light,
                          /*fontWeight: FontWeight.w500,
                    fontSize: 12,
                    letterSpacing: 0.0,*/
                          color: DatingAppTheme.white,
                        ), //DatingAppTheme.auth_error_TextStyle,
                        /* icon: Icon(
                    FontAwesomeIcons.lock,
                    color: Colors.white,
                    size: 22.0,
                  ),*/
                        suffixIcon: IconButton(
                          icon: Icon(
                            newpasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                            size: 22.0,
                          ),
                          onPressed: () {
                            setState(() {
                              newpasswordVisible = !newpasswordVisible;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: 0.0,
                        color: DatingAppTheme.white,
                      ), //DatingAppTheme.auth_txt_FieldTextStyle,
                      controller: passController1,
                      //validator: validatePassword1,
                      onChanged: (String txt) {
                        _on_pass1_changed(txt);
                      },
                      onFieldSubmitted: (String str) {
                        passFocusNode2.requestFocus();
                      },
                      focusNode: passFocusNode1,
                      textAlign: TextAlign.center,
                    ),
                  )),
                ),
              ),
              StreamBuilder(
                stream: _wd_pass1_Container_NavigationDataBLoC.stream_counter,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return invisibleWidget();
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return invisibleWidget();
                      break;
                    case ConnectionState.waiting:
                      return invisibleWidget();
                      break;
                    case ConnectionState.active:
                      return wd_Error_Notifier_Validator_Text_White(snapshot);
                      break;
                    case ConnectionState.done:
                      return wd_Error_Notifier_Validator_Text_White(snapshot);
                      break;
                  }
                },
              ),
              /*StreamBuilder(
              stream: _wd_pass1_Container_NavigationDataBLoC.stream_counter,
              builder: (context, AsyncSnapshot<NavigationData> snapshot) {
                return ((snapshot.data != null &&
                        snapshot.data.isShow != null &&
                        snapshot.data.isShow
                    ? Padding(
                        padding: EdgeInsets.only(right: 42),
                        child: Text('error'),
                      )
                    : invisibleWidget()));
              },
            ),*/
            ],
          ),
          SizedBox(
            height: 10,
          ),
          /*TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          obscureText: !passwordVisible,
          decoration: InputDecoration(
            border: InputBorder.none,
            errorMaxLines: 2,
            fillColor: DatingAppTheme.background,
            filled: true,
            hintText: 'confirm password',
            hintStyle: DatingAppTheme.auth_hint_TextStyle,

            errorStyle: DatingAppTheme.auth_error_TextStyle,

            suffixIcon: IconButton(
              icon: Icon(
                passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: DatingAppTheme.grey,
              ),
              onPressed: () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              },
            ),
          ),
          style: DatingAppTheme.auth_txt_FieldTextStyle,
          controller: passController2,
          //validator: validatePassword2,
          onFieldSubmitted: (String str) {
            passwordResetButtonClicked(context, sCafoldcontext);
          },
          focusNode: passFocusNode2,
          textAlign: TextAlign.center,
        ),*/
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 60,
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white,
                        style: BorderStyle.solid,
                        width: 2),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                      child: Padding(
                    padding: EdgeInsets.only(
                      right: 40.0,
                      left: 40.0,
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      obscureText: !passwordVisible,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        errorMaxLines: 2,
                        hintText: 'confirm password',
                        hintStyle: TextStyle(
                          fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          color: Colors.white,
                        ),
                        //DatingAppTheme.auth_hint_TextStyle,
                        errorStyle: TextStyle(
                          fontFamily: DatingAppTheme.font_AvenirLTStd_Light,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          letterSpacing: 0.0,
                          color: DatingAppTheme.white,
                        ),

                        ///DatingAppTheme.auth_error_TextStyle,

                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                            size: 22.0,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: 0.0,
                        color: DatingAppTheme.white,
                      ),
                      //DatingAppTheme.auth_txt_FieldTextStyle,
                      controller: passController2,
                      //validator: validatePassword2,
                      onChanged: (String txt) {
                        _on_pass2_changed(txt);
                      },
                      onFieldSubmitted: (String str) {
                        passwordResetButtonClicked(context, sCafoldcontext);
                      },
                      focusNode: passFocusNode2,
                      textAlign: TextAlign.center,
                    ),
                  )),
                ),
              ),
              StreamBuilder(
                stream: _wd_pass2_Container_NavigationDataBLoC.stream_counter,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return invisibleWidget();
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return invisibleWidget();
                      break;
                    case ConnectionState.waiting:
                      return invisibleWidget();
                      break;
                    case ConnectionState.active:
                      return wd_Error_Notifier_Validator_Text_White(snapshot);
                      break;
                    case ConnectionState.done:
                      return wd_Error_Notifier_Validator_Text_White(snapshot);
                      break;
                  }
                },
              ),
            ],
          )
        ]);
  }

  _on_pass1_changed(String value) {
    _validatePassword1();
  }

  bool _validatePassword1() {
    if (!isStringValid(passController1.text)) {
      refresh_wd_validator_NavigationDataBLoC(
        false,
        'Invalid password',
        _wd_pass1_Container_NavigationDataBLoC,
      );
      return false;
    } else {
      if (!(passController1.text.length > 7)) {
        refresh_wd_validator_NavigationDataBLoC(
          false,
          'Password must be at least 8 characters long',
          _wd_pass1_Container_NavigationDataBLoC,
        );
        return false;
      } else {
        Pattern passPattern = r'^[0-9a-zA-Z]+$';//r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z])';
        RegExp regex = new RegExp(passPattern);
        if (!regex.hasMatch(passController1.text)) {
          refresh_wd_validator_NavigationDataBLoC(
            false,
            'Password must be at least 8 characters long, no special characters',
            //'Password must have at least a number, and a least an uppercase and a lowercase letter',
            _wd_pass1_Container_NavigationDataBLoC,
          );
          return false;
        } else {
          refresh_wd_validator_NavigationDataBLoC(
            true,
            null,
            _wd_pass1_Container_NavigationDataBLoC,
          );
          _validatePassword2();
          return true;
        }
      }
    }
  }

  bool _validateData() {
    bool _is_validatePassword1 = _validatePassword1();
    bool _is_validatePassword2 = _validatePassword2();

    bool _is_valid = _is_validatePassword1 && _is_validatePassword2;
    return _is_valid;
  }

  /*String validatePassword1(String value) {
    if (!isStringValid(value)) {
      return 'Invalid password';
    } else {
      if (!(value.length > 7)) {
        return 'Password must be at least 8 characters long';
      } else {
        Pattern passPattern = r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z])';
        RegExp regex = new RegExp(passPattern);
        if (!regex.hasMatch(value)) {
          return 'Password must have at least a number, and a least an uppercase and a lowercase letter';
        } else {
          return null;
        }
      }
    }
  }*/

  _on_pass2_changed(String value) {
    _validatePassword2();
  }

  bool _validatePassword2() {
    if (!isStringValid(passController2.text)) {
      refresh_wd_validator_NavigationDataBLoC(
        false,
        'Invalid password',
        _wd_pass2_Container_NavigationDataBLoC,
      );
      return false;
    } else {
      if (!(passController2.text.length > 7)) {
        refresh_wd_validator_NavigationDataBLoC(
          false,
          'Password must be at least 8 characters long',
          _wd_pass2_Container_NavigationDataBLoC,
        );
        return false;
      } else {
        Pattern passPattern = r'^[0-9a-zA-Z]+$';//r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z])';
        RegExp regex = new RegExp(passPattern);
        if (!regex.hasMatch(passController2.text)) {
          refresh_wd_validator_NavigationDataBLoC(
            false,
            'Password must be at least 8 characters long, no special characters',
            //'Password must have at least a number, and a least an uppercase and a lowercase letter',
            _wd_pass2_Container_NavigationDataBLoC,
          );
          return false;
        } else {
          if (!(passController1.text == passController2.text)) {
            refresh_wd_validator_NavigationDataBLoC(
              false,
              'Passwords do not match',
              _wd_pass2_Container_NavigationDataBLoC,
            );
            return false;
          } else {
            refresh_wd_validator_NavigationDataBLoC(
              true,
              null,
              _wd_pass2_Container_NavigationDataBLoC,
            );
            return true;
          }
        }
      }
    }
  }
  /* String validatePassword2(String value) {
    if (!isStringValid(value)) {
      return 'Invalid password';
    } else {
      if (!(value.length > 7)) {
        return 'Password must be at least 8 characters long';
      } else {
        Pattern passPattern = r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z])';
        RegExp regex = new RegExp(passPattern);
        if (!regex.hasMatch(value)) {
          return 'Password must have at least a number, and a least an uppercase and a lowercase letter';
        } else {
          if (!(passController1.text == passController2.text)) {
            return 'Passwords do not match';
          } else {
            return null;
          }
        }
      }
    }
  }*/

  Widget resetPasswordButton(BuildContext sCafoldcontext) {
    return RaisedButton(
      onPressed: () => passwordResetButtonClicked(context, sCafoldcontext),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      padding: const EdgeInsets.all(0.0),
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.pink, Colors.deepOrange],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
        ),
        child: Container(
          constraints: const BoxConstraints(
              minWidth: 88.0, minHeight: 60), // min sizes for Material buttons
          alignment: Alignment.center,
          child: Text(
            'Reset',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  passwordResetButtonClicked(
      BuildContext context, BuildContext sCafoldcontext) {
    /*if (_liformKey.currentState.validate()) {
      _liformKey.currentState.save();*/
    validateOTP('');
    if (otp_valid && _validateData()) {
      /*PasswordResetRespJModel passwordResetRespJModel =
          PasswordResetRespJModel();
      passwordResetRespJModel.phone_number = emailController.text;*/
      passwordResetRespJModel.otp = otpString;
      passwordResetRespJModel.password = passController2.text;
      passwordResetRespJModel.confirm_password = passController2.text;
      //authapicalls.resetPassWithOTP(context, sCafoldcontext,
      // passwordResetRespJModel, loginBtnPageBLoC, resetPassBLoC);
      //POST
      post_put_pass_reset_w_otp(
        context,
        sCafoldcontext,
        passwordResetRespJModel,
        loginBtnPageBLoC,
        resetPassBLoC,
      );
    } else {
      loginBtnPageBLoC.onBoardingPage_visible_event_sink
          .add(OnBoardingPageChangedEvent(1));
    }
    /* } else {
      setState(() {
        _autoValidate = true;
      });
    }*/
  }

  String validateOTP(String str) {
    otpString =
        ctrlF1.text + ctrlF2.text + ctrlF3.text + ctrlF4.text + ctrlF5.text;
    if (isStringValid(otpString) && otpString.length > 3) {
      otp_valid = true;
      return null;
    } else {
      otp_valid = false;
      showSnackbarWBgCol(
          'Invalid OTP', scaffoldBuildContext, DatingAppTheme.red);
      return null;
    }
  }

  Widget circularProgressIndicator() {
    /*return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 7, right: 10),
          child: Theme(
            data: ThemeData(
              accentColor: DatingAppTheme.white,
            ),
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );*/
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

  //END OF BUILD WIDGETS
}

typedef IntindexCallback = void Function(int intindex);
