import 'package:chopper/chopper.dart';
import 'package:dating_app/Models/Chopper/UsernameValidator.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'LogInPage.dart';

import 'package:dating_app/tabs/Index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:provider/provider.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignUpPage extends StatefulWidget {
  final IntindexCallback navigate;

  SignUpPage({
    Key key,
    this.navigate,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignUpPageState();
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

class _SignUpPageState extends State<SignUpPage> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confpasswordController = TextEditingController();
  final emailController = TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  ProgressDialog pr;
  bool _autoValidate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    pr.style(
      message: 'Signing Up...',
      borderRadius: 10.0,
      backgroundColor: Colors.transparent,
      progressWidget: CircularProgressIndicator(
        backgroundColor: Colors.white,
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: TextStyle(
          color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) => Stack(
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
              child: new Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 150),
                    /*Image(
                height: 50,
                alignment: Alignment.topCenter,
                image: AssetImage("assets/images/tinder.png"),
              ),*/
                    SizedBox(height: 45),
                    Container(
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
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () => openHomePage(), // handle your onTap here
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
                                child: TextFormField(
                                  validator: validateEmail,
                                  controller: emailController,
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
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontStyle: FontStyle.italic),
                                    errorStyle: TextStyle(color: Colors.white),
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
                      onTap: () => openHomePage(), // handle your onTap here
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
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty ||
                                        !(value.trim().length > 0)) {
                                      return 'Invalid Username';
                                    }
                                    return null;
                                  },
                                  controller: userNameController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(
                                      FontAwesomeIcons.user,
                                      color: Colors.white,
                                      size: 22.0,
                                    ),
                                    hintText: "Username",
                                    hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontStyle: FontStyle.italic),
                                    errorStyle: TextStyle(color: Colors.white),
                                  ),
                                  onChanged: (text) =>
                                      usernameChanged(userNameController.text),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () => openHomePage(), // handle your onTap here
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
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty ||
                                        !(value.trim().length > 0)) {
                                      return 'Invalid Password';
                                    }
                                    if (value != confpasswordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                  controller: passwordController,
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
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
                                    errorStyle: TextStyle(color: Colors.white),
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
                      onTap: () => openHomePage(), // handle your onTap here
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
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty ||
                                        !(value.trim().length > 0)) {
                                      return 'Invalid Password';
                                    }
                                    if (value != passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                  controller: confpasswordController,
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.white),
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
                                    errorStyle: TextStyle(color: Colors.white),
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
                      padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                      child: Material(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(30),
                        child: InkWell(
                          onTap: () => signUpClicked(context),
                          borderRadius: BorderRadius.circular(30),
                          splashColor: Colors.grey,
                          child: Container(
                            height: 60,
                            child: Center(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    /*InkWell(
                      onTap: () =>
                          signUpClicked(context), // handle your onTap here
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                        child: Container(
                          height: 60,
                          child: Center(
                            child: Text(
                              'Sign Up',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                  colors: [Colors.pinkAccent, Colors.pink])),
                        ),
                      ),
                    ),*/
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
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

  void openHomePage() {
    Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => new Index()));
  }

  void usernameChanged(String submitttedText) {
    //postUserDetails(submitttedText);
  }

  void signUpClicked(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      postUserDetails(context);
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  postUserDetails(BuildContext context) async {
    pr.show();
    String subm_username = "Null";
    String subm_password = "Null";
    String subm_email = "Null";
    if (ifStringValid(userNameController.text)) {
      subm_username = userNameController.text;
    }
    if (ifStringValid(passwordController.text)) {
      subm_password = passwordController.text;
    }
    if (ifStringValid(emailController.text)) {
      subm_email = emailController.text;
    }

    UsernameValidator usernameValidator = UsernameValidator((b) => b
      ..username = subm_username
      ..password = subm_password
      ..email = subm_email
      ..message = 'None'
      ..success = false);
    Response<UsernameValidator> response;
    SnackBar snackBar;
    try {
      response = await Provider.of<PostApiService>(context)
          .postPost(usernameValidator);

      dissmissPDialog(pr);
      showSnackbar(
          ((response.body.message != null
              ? response.body.message
              : 'An error ocurred')),
          context);
    } catch (error) {
      dissmissPDialog(pr);
      showSnackbar('An error ocurred', context);
    }

    dissmissPDialog(pr);
  }

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
    if (pr != null && pr.isShowing()) {
      pr.hide().then((isHidden) {
        print(isHidden);
      });
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Invalid Email';
    else
      return null;
  }
}

typedef IntindexCallback = void Function(int intindex);
