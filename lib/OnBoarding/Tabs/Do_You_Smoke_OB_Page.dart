import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:dating_app/Activities/LogInPage.dart';
import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleBLoC.dart';
import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleEvent.dart';
import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemBLoC.dart';
import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemEvent.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/SmokestatusDao.dart';
import 'package:dating_app/Models/Chopper/UsernameValidator.dart';
import 'package:dating_app/UI/Presentation/CountryPicker/flutter_country_picker.dart';
import 'package:dating_app/UI/Presentation/CustomChip/CustomChipView.dart';
import 'package:dating_app/UI/Presentation/CustomWidgets/CustomTitleView.dart';
import 'package:dating_app/UI/Presentation/ExpandedBubbleChip/ExpandedBubbleChip.dart';
import 'package:dating_app/UI/Presentation/OnBoardingOptions/OnBoardingOption.dart';
import 'package:dating_app/UI/Presentation/OnBoardingOptions/OnBoardingSmokeStatusOption.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:flutter/material.dart';import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/gestures.dart';
//import 'package:flutter_country_picker/flutter_country_picker.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dating_app/tabs/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:provider/provider.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:after_layout/after_layout.dart';

class Do_You_Smoke_OB_Page extends StatefulWidget {
  KeyBoardVisibleBLoC keyBoardVisibleBLoC;
  Onboarding onboarding;
  IntindexCallback functionOnBoardingChanged;
  OnBoardingClickableItemBLoC
      recentOnBoardingChangedOnBoardingClickableItemBLoC;

  Do_You_Smoke_OB_Page(
      {Key key,
      @required this.keyBoardVisibleBLoC,
      @required this.onboarding,
      this.functionOnBoardingChanged,
      this.recentOnBoardingChangedOnBoardingClickableItemBLoC})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Do_You_Smoke_OB_PageState();
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

class _Do_You_Smoke_OB_PageState extends State<Do_You_Smoke_OB_Page>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<Do_You_Smoke_OB_Page>,
        AfterLayoutMixin<Do_You_Smoke_OB_Page> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confpasswordController = TextEditingController();
  final emailController = TextEditingController();
  final birthdayController = TextEditingController();
  final quoteController = TextEditingController();
  String profilepicFilePath = "Null";

  FocusNode userNameFocusNode = new FocusNode();
  FocusNode emailFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();
  FocusNode confpasswordFocusNode = new FocusNode();
  FocusNode birthdayFocusNode = new FocusNode();
  FocusNode quoteFocusNode = new FocusNode();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String str_GothamRounded_Medium = 'GothamRounded-Medium';

  final format = DateFormat("dd/MM/yyyy");
  ProgressDialog pr;
  bool _autoValidate = false;
  final GlobalKey<FormState> _suformKey = GlobalKey<FormState>();
  static const colorGreen1 = const Color(0xFF164a2e);
  static const colorGreyText = const Color(0xFF164a2e);
  static const colorBlack = Colors.black;

  static const colorDarkGrey = const Color(0xFFa9a9a9);
  static const colorLightGrey = const Color(0xFFd3d3d3);
  static const colorGrey = const Color(0xFF808080);
  static const colorDarkGrey1 = const Color(0xFF595858);

  var colorUserNameIcon = Colors.black;
  var colorEmailIcon = Colors.black;
  var colorPasswordIcon = Colors.black;
  var colorConfPasswordIcon = Colors.black;
  var colorBirthdayIcon = Colors.black;
  var colorProfPicIcon = Colors.black;
  var colorQuoteIcon = Colors.black;

  List<Asset> images = List<Asset>();
  String _error;
  String profPicPath = 'assets/illustrations/profile_pic_trans.png';
  File fileProfpic = null;
  List<Widget> optionsDynamic = [];

  var database;
  SmokestatusDao smokestatusDao;
  OnboardingDao onboardingDao;
  OnBoardingClickableItemBLoC onBoardingClickableItemBLoC =
      OnBoardingClickableItemBLoC();
  String TAG = 'Do_You_Smoke_OB_Page:';
  OnBoardingClickableItemBLoC recentOnBoardingForwardClickableItemBLoC =
      OnBoardingClickableItemBLoC();
  AnimationController animationController;

  //bool ifKeyBoardVisible;

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    userNameFocusNode.addListener(onformFieldChange);
    emailFocusNode.addListener(onformFieldChange);
    passwordFocusNode.addListener(onformFieldChange);
    confpasswordFocusNode.addListener(onformFieldChange);
    birthdayFocusNode.addListener(onformFieldChange);
    quoteFocusNode.addListener(onformFieldChange);

    //WidgetsBinding.instance.addPostFrameCallback((_) => initVariables());
    /*KeyboardVisibility.onChange.listen(
      (bool visible) {
        print('keyboard visible OB3 ${visible}');
        widget.keyBoardVisibleBLoC.switch_changed_event_sink.add(ToggleKeyBoardVisEvent(visible));
        setState(() {
          ifKeyBoardVisible = visible;
        });
      },
    );*/
  }

  @override
  void afterFirstLayout(BuildContext context) {
    database = Provider.of<AppDatabase>(context);
    onboardingDao = database.onboardingDao;
    smokestatusDao = database.smokestatusDao;

    print('afterFirstLayout do you smoke');
    KeyboardVisibility.onChange.listen(
      (bool visible) {
        print('afterFirstLayout keyboard visible OB3 ${visible}');
        widget.keyBoardVisibleBLoC.keyboard_visible_event_sink
            .add(ToggleKeyBoardVisEvent(visible));
        /*setState(() {
          ifKeyBoardVisible = visible;
        });*/
      },
    );
    initUI();
    addListeners();
  }

  addListeners() {
    widget.recentOnBoardingChangedOnBoardingClickableItemBLoC.stream_counter
        .listen((value) {
      refreshOnBoarding();
    });
  }

  refreshOnBoarding() async {
    Onboarding updatedOnboarding =
        await onboardingDao.getOnboardingById(widget.onboarding.id);
    //setState(() {
    widget.onboarding = updatedOnboarding;
    //});
    refresh_recentOnBoardingForwardClickableItemBLoC();
  }

  refresh_recentOnBoardingForwardClickableItemBLoC() {
    recentOnBoardingForwardClickableItemBLoC.onboarding_itemclicked_event_sink
        .add(OneItemClickedEvent(1));
  }

  initUI() async {
    //await refreshRecentOnBoarding();
    refreshRecentOnBoarding();
    smokestatusDao.getActiveSmokestatuseList().then(
        (List<Smokestatuse> smokestatuseList) {
      if (smokestatuseList != null) {
        for (Smokestatuse smokestatuse in smokestatuseList) {
          optionsDynamic.add(new OnBoardingSmokeStatusOption(
            title: smokestatuse.name,
            isSelected: smokestatuse.id == widget.onboarding.do_you_smoke,
            isSelectable: true,
            onboarding: widget.onboarding,
            onboardingDao: onboardingDao,
            smokestatuse: smokestatuse,
            onItemClick: functionOnDoYouSmokeItemClick,
            onBoardingClickableItemBLoC: onBoardingClickableItemBLoC,
            recentOnBoardingForwardClickableItemBLoC:
                recentOnBoardingForwardClickableItemBLoC,
          ));
        }
        print('optionsDynamic len ${optionsDynamic.length}');
        setState(() {});
      } else {
        print('smokestatuseList IS NULL');
      }
    }, onError: (error) {
      print('error== ${error}');
    });
  }

  refreshRecentOnBoarding() async {
    Onboarding updatedOnboarding =
        await onboardingDao.getOnboardingById(widget.onboarding.id);
    print(updatedOnboarding.iam);
    //setState(() {
    widget.onboarding = updatedOnboarding;
    //});
    print(TAG + ' refreshRecentOnBoarding');
    print(TAG + 'iam==');
    print(widget.onboarding.iam.toString());
  }

  initVariables() {
    print('initVariables');
    getImageFileFromAssets('assets/illustrations/profile_pic_trans.png');
  }

  PermissionStatus _listenForPermissionStatus(
      PermissionGroup _permissionGroup) {
    final Future<PermissionStatus> statusFuture =
        PermissionHandler().checkPermissionStatus(_permissionGroup);

    statusFuture.then((PermissionStatus status) {
      print(status);
      return status;
    });
  }

  Future<PermissionStatus> _listenForPermissionStatuss(
      PermissionGroup _permissionGroup) async {
    Future<PermissionStatus> statusFuture =
        PermissionHandler().checkPermissionStatus(_permissionGroup);

    statusFuture.then((PermissionStatus status) {
      return status;
    }, onError: (error) {
      print('error== $error');
      return PermissionStatus.unknown;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    pr.style(
      message: 'Signing Up...',
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
    animationController.forward();
    return Scaffold(
      body: Consumer<DatingAppThemeChanger>(
        builder: (context, datingAppThemeChanger, child) {
          return SingleChildScrollView(
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: DatingAppTheme.background,
                /*decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.4, 0.7, 0.9],
                colors: [
                  Color(0xFFF8BBD0),
                  Color(0xFFF48FB1),
                  Color(0xFFEC407A),
                  Color(0xFFE91E63),
                ],
              ),
            ),*/
                child: Builder(
                  builder: (BuildContext context) => Container(
                    //child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 60),
                        CustomTitleView(
                          titleTxt: 'Do you smoke?',
                          subTxt: '',
                          animation: Tween<double>(begin: 0.0, end: 1.0)
                              .animate(CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / 9) * 0, 1.0,
                                  curve: Curves.fastOutSlowIn))),
                          animationController: animationController,
                          titleTextStyle: datingAppThemeChanger
                              .selectedThemeData.title_TextStyle,
                        ),
                        Center(
                          child: Image(
                            image: AssetImage(
                              'assets/onb/onboarding2.png',
                            ),
                            height: 300.0,
                            width: 300.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        /*Transform(
                          transform: Matrix4.translationValues(
                              0.0, 30.0 * (1.0 - 1.0), 0.0),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 0.0, bottom: 10.0, left: 20, right: 20),
                            child: Center(
                              child: Text(
                                'Do you smoke?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontFamily: "GothamRounded-Medium",
                                ),
                              ),
                            ),
                          ),
                        ),*/
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: 30.0,
                                left: 30.0,
                              ),
                              child: new Form(
                                key: _suformKey,
                                autovalidate: _autoValidate,
                                child: Column(
                                  children: optionsDynamic,
                                  //children: <Widget>[
                                  /*Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Row(
                                    children: <Widget>[
                                      */ /*CustomChipView(
                                        title: "No",
                                        isSelected: false,
                                      ),*/ /*
                                      ExpandedBubbleChip(
                                        isSelectable: true,
                                        isSelected: false,
                                        title: 'No',
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Row(
                                    children: <Widget>[
                                      */ /*CustomChipView(
                                        title: "Yes - ocassionally",
                                        isSelected: false,
                                      ),*/ /*
                                      ExpandedBubbleChip(
                                        isSelectable: true,
                                        isSelected: false,
                                        title: "Yes - ocassionally",
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Row(
                                    children: <Widget>[
                                      */ /* CustomChipView(
                                        title: "Yes - daily",
                                        isSelected: false,
                                      ),*/ /*
                                      ExpandedBubbleChip(
                                        isSelectable: true,
                                        isSelected: false,
                                        title: "Yes - daily",
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Row(
                                    children: <Widget>[
                                      ExpandedBubbleChip(
                                        isSelectable: true,
                                        isSelected: false,
                                        title: "Yes - trying to quit",
                                      ),
                                      */ /*CustomChipView(
                                        title: "Yes - trying to quit",
                                        isSelected: false,
                                      ),*/ /*
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),*/
                                  /* InkWell(
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
                                ),*/
                                  /*           SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'GothamRounded-Medium',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),*/
                                  //],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
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

  void openHomePage() {
    Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => new Index()));
  }

  void usernameChanged(String submitttedText) {
    //postUserDetails(submitttedText);
  }

  void signUpClicked(BuildContext context) {
    print('signUpClicked');

    if (_suformKey.currentState.validate()) {
      if (!ifStringValid(profilepicFilePath)) {
        dissmissPDialog(pr);
        showSnackbar('Please pick a profile picture', context);
        return;
      }
      _suformKey.currentState.save();
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
    String subm_birthday = "Null";
    String subm_quote = "Null";
    if (ifStringValid(userNameController.text)) {
      subm_username = userNameController.text;
    }
    if (ifStringValid(passwordController.text)) {
      subm_password = passwordController.text;
    }
    if (ifStringValid(emailController.text)) {
      subm_email = emailController.text;
    }
    if (ifStringValid(birthdayController.text)) {
      DateTime subm_format_DateTime =
          DateTimeField.tryParse(birthdayController.text, format);
      if (subm_format_DateTime != null) {
        var subm_format = DateFormat("yyyy-MM-dd");
        String subm_format_String =
            DateTimeField.tryFormat(subm_format_DateTime, subm_format);
        print('subm_format_String=${subm_format_String}');
        subm_birthday = subm_format_String;
        print('birthday=${subm_birthday}');
      } else {
        subm_birthday = "Null";
      }
    }
    if (ifStringValid(quoteController.text)) {
      subm_quote = quoteController.text;
    }
    //profilepicFilePath
    /* if (ifStringValid(profilepicFilePath)) {
      dissmissPDialog(pr);
      showSnackbar('Please pick a profile picture', context);
    }*/

/*    UsernameValidator usernameValidator = UsernameValidator((b) => b
      ..username = subm_username
      ..password = subm_password
      ..email = subm_email
      ..message = 'None'
      ..success = false
      ..birthday = subm_birthday);*/
    //Response<UsernameValidator> response;
    var response;
    SnackBar snackBar;
    try {
      //SPLIT PATH TO GET FILENAME
      List<String> imgPathSplit = profilepicFilePath.split("/");
      String filename = imgPathSplit[imgPathSplit.length - 1];
      print('filemname=${filename}');

/*      http.MultipartFile.fromPath("", profilepicFilePath).then((onValue) async {
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
      }, onError: (error) {});*/
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
      /*print('json==${json.decode(response.body)}');
    dynamic supres=json.decode(response.body);*/
      //Map<String, dynamic> map = jsonDecode(response.body);
      Map<String, dynamic> map = response.body;
      dissmissPDialog(pr);
      showSnackbar(
          /*((supres.message != null
            ? response.body.message
            : 'An error ocurred'))
        ,
        context*/

          ((map['message'] != null ? map['message'] : 'An error ocurred')),
          context);
      /*.then((onValue) {
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
    });*/

      /*response =
              await Provider.of<PostApiService>(context)
                  .postPost(
                usernameValidator,
              );

              dissmissPDialog(pr);
                    showSnackbar(
                        ((response.body.message != null
                            ? response.body.message
                            : 'An error ocurred')),
                        context);*/
    } catch (error) {
      print('error1==${error}');
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

  void onformFieldChange() {
    if (userNameFocusNode.hasFocus) {
      setState(() {
        colorUserNameIcon = colorGreen1;

        colorEmailIcon = colorBlack;
        colorPasswordIcon = colorBlack;
        colorConfPasswordIcon = colorBlack;
        colorBirthdayIcon = colorBlack;
        colorProfPicIcon = colorBlack;
        colorQuoteIcon = colorBlack;
      });
    }
    if (emailFocusNode.hasFocus) {
      setState(() {
        colorEmailIcon = colorGreen1;

        colorUserNameIcon = colorBlack;
        colorPasswordIcon = colorBlack;
        colorConfPasswordIcon = colorBlack;
        colorBirthdayIcon = colorBlack;
        colorProfPicIcon = colorBlack;
        colorQuoteIcon = colorBlack;
      });
    }
    if (passwordFocusNode.hasFocus) {
      setState(() {
        colorPasswordIcon = colorGreen1;

        colorEmailIcon = colorBlack;
        colorUserNameIcon = colorBlack;
        colorConfPasswordIcon = colorBlack;
        colorBirthdayIcon = colorBlack;
        colorProfPicIcon = colorBlack;
        colorQuoteIcon = colorBlack;
      });
    }
    if (confpasswordFocusNode.hasFocus) {
      setState(() {
        colorConfPasswordIcon = colorGreen1;

        colorPasswordIcon = colorBlack;
        colorEmailIcon = colorBlack;
        colorUserNameIcon = colorBlack;
        colorBirthdayIcon = colorBlack;
        colorProfPicIcon = colorBlack;
        colorQuoteIcon = colorBlack;
      });
    }
    if (birthdayFocusNode.hasFocus) {
      setState(() {
        colorBirthdayIcon = colorGreen1;

        colorPasswordIcon = colorBlack;
        colorEmailIcon = colorBlack;
        colorUserNameIcon = colorBlack;
        colorConfPasswordIcon = colorBlack;
        colorProfPicIcon = colorBlack;
        colorQuoteIcon = colorBlack;
      });
    }

    if (quoteFocusNode.hasFocus) {
      setState(() {
        colorQuoteIcon = colorGreen1;

        colorPasswordIcon = colorBlack;
        colorEmailIcon = colorBlack;
        colorUserNameIcon = colorBlack;
        colorConfPasswordIcon = colorBlack;
        colorProfPicIcon = colorBlack;
        colorBirthdayIcon = colorBlack;
      });
    }
  }


  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }



  Future<void> loadAssets(int maxImages) async {
    setState(() {
      images = List<Asset>();
    });
    List<Asset> resultList;
    String error;
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: maxImages,
      );
    } on Exception catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
      print('no images=${images.length}');
      print('path=${images[0].name}');
      print('identifier=${images[0].identifier}');
      print('no error=${error}');
    });
  }

  ServiceStatus checkServiceStatus(PermissionGroup permission) {
    PermissionHandler()
        .checkServiceStatus(permission)
        .then((ServiceStatus serviceStatus) {
      print(serviceStatus.toString());
      return serviceStatus;
    });
  }

  PermissionStatus requestPermission(PermissionGroup permission) {
    List<PermissionGroup> permissions = <PermissionGroup>[permission];
    Future<Map<PermissionGroup, PermissionStatus>> futurePerm =
        PermissionHandler().requestPermissions(permissions);

    futurePerm.then((onValue) {
      PermissionStatus permissionStatus = onValue[permission];
      return permissionStatus;
    }, onError: (error) {
      print('error== $error');
      return PermissionStatus.unknown;
    });
    /*final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);*/
    /* permissionRequestResult.then(
            (onValue) {
      PermissionStatus permissionStatus = onValue[permission];

    }, onError: (error) {
      print('error== $error');
    });*/
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

  Future<File> getImageFileFromAssets(String path) async {
    rootBundle.load(path).then((onValueRootBundle) {
      var byteData = onValueRootBundle;
      getTemporaryDirectory().then((onValueTemporaryDir) {
        Directory dr = onValueTemporaryDir;
        var file = File('${dr.path}/$path');
        file
            .writeAsBytes(byteData.buffer
                .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes))
            .then((onValue) {
          setState(() {
            fileProfpic = onValue;
          });
        }, onError: (error) {
          print('error3== $error');
        });
      }, onError: (error) {
        print('error2== $error');
      });
    }, onError: (error) {
      print('error1== $error');
    });

    //  final byteData = await rootBundle.load('assets/$path');
    /*final byteData = await rootBundle.load(path);
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file
        .writeAsBytes(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes))
        .then((onValue) {
      setState(() {
        fileProfpic = onValue;
      });
      return onValue;
    }, onError: (error) {
      print('getImageFileFromAssets error== $error');
      return null;
    });*/
  }

  void functionOnDoYouSmokeItemClick(Onboarding onboarding) {
    setState(() {
      widget.onboarding = onboarding;
    });
    widget.functionOnBoardingChanged(widget.onboarding);
  }
}

typedef IntindexCallback = void Function(Onboarding onboarding);
