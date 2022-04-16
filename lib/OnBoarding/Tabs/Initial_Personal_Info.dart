import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:dating_app/Activities/LogInPage.dart';
import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleBLoC.dart';
import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleEvent.dart';
import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemBLoC.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataEvent.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_validate_email.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_validate_phone_no.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_validate_user_name.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/EducationlevelDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingDao.dart';
import 'package:dating_app/Data/SharedPreferences/UserSessionSharedPrefs.dart';
import 'package:dating_app/Models/Chopper/UsernameValidator.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/Services/Fetch/OnboardingDataFetch.dart';
import 'package:dating_app/UI/Presentation/CountryPicker/flutter_country_picker.dart';
import 'package:dating_app/UI/Presentation/CustomChip/CustomChipView.dart';
import 'package:dating_app/UI/Presentation/CustomWidgets/CustomTitleView.dart';
import 'package:dating_app/UI/Presentation/OnBoardingOptions/OnBoardingPickyAboutHerEducationOption.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/gestures.dart';
//import 'package:flutter_country_picker/flutter_country_picker.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dating_app/tabs/Index.dart';
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
import 'package:moor_flutter/moor_flutter.dart' as flutterMoor;
import 'package:flutter_masked_text/flutter_masked_text.dart';

class Initial_Personal_Info extends StatefulWidget {
  KeyBoardVisibleBLoC keyBoardVisibleBLoC;
  Onboarding onboarding;
  IntindexCallback functionOnBoardingChanged;
  OnBoardingClickableItemBLoC
      recentOnBoardingChangedOnBoardingClickableItemBLoC;
  NavigationDataBLoC saved_Clicked_NavigationDataBLoC;

  Initial_Personal_Info({
    Key key,
    @required this.keyBoardVisibleBLoC,
    this.functionOnBoardingChanged,
    @required this.onboarding,
    this.recentOnBoardingChangedOnBoardingClickableItemBLoC,
    this.saved_Clicked_NavigationDataBLoC,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Initial_Personal_Info_State();
  }
}

class _Initial_Personal_Info_State extends State<Initial_Personal_Info>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<Initial_Personal_Info>,
        AfterLayoutMixin<Initial_Personal_Info> {
  final userNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNoController = TextEditingController();
  final passwordController = TextEditingController();
  final confpasswordController = TextEditingController();
  final emailController = TextEditingController();
  final fbController = TextEditingController();
  final instaController = TextEditingController();
  //final birthdayController = TextEditingController();
  MaskedTextController birthdayController =
      new MaskedTextController(mask: '00/00/0000');
  final quoteController = TextEditingController();
  String profilepicFilePath = "Null";

  FocusNode userNameFocusNode = new FocusNode();
  FocusNode firstNameFocusNode = new FocusNode();
  FocusNode lastNameFocusNode = new FocusNode();
  FocusNode phoneNoFocusNode = new FocusNode();
  FocusNode emailFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();
  FocusNode confpasswordFocusNode = new FocusNode();
  FocusNode birthdayFocusNode = new FocusNode();
  FocusNode quoteFocusNode = new FocusNode();
  FocusNode fbFocusNode = new FocusNode();
  FocusNode instaFocusNode = new FocusNode();

  bool password1Visible = false;
  bool password2Visible = false;

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String str_GothamRounded_Medium = 'GothamRounded-Medium';

  final format = DateFormat("dd/MM/yyyy");
  ProgressDialog pr;
  bool _autoValidate = false;
  final GlobalKey<FormState> _suformKey = GlobalKey<FormState>();
  //static const colorGreen1 = const Color(0xFF164a2e);
  static const colorGreen1 = const Color(0xFF680f29);
  static const colorGreyText = const Color(0xFF164a2e);
  static const colorBlack = Colors.white;

  // static const colorDarkGrey = const Color(0xFFa9a9a9);
  static const colorDarkGrey = Colors.white;
  static const colorLightGrey = const Color(0xFFd3d3d3);
  static const colorGrey = const Color(0xFF808080);
  static const colorDarkGrey1 = const Color(0xFF595858);

  var colorUserNameIcon = Colors.white;
  var colorEmailIcon = Colors.white;
  var colorPasswordIcon = Colors.white;
  var colorConfPasswordIcon = Colors.white;
  var colorBirthdayIcon = Colors.white;
  var colorProfPicIcon = Colors.white;
  var colorQuoteIcon = Colors.white;

  List<Asset> images = List<Asset>();
  String _error;
  String profPicPath = 'assets/illustrations/profile_pic_trans.png';
  File fileProfpic = null;

  var database;
  EducationLevelDao educationLevelDao;
  OnboardingDao onboardingDao;
  OnBoardingClickableItemBLoC onBoardingClickableItemBLoC =
      OnBoardingClickableItemBLoC();

  bool whitecau = false;
  bool blackafric = false;
  bool lathispan = false;
  bool asian = false;
  bool nativeameric = false;
  bool middleeastern = false;
  String TAG = '_Initial_Personal_Info_State:';
  AnimationController animationController;
  var date_format_ymd = DateFormat("dd/MM/yyyy");

  NavigationDataBLoC wd_Activity_Container_DailySubTaskImagesBLoC =
      NavigationDataBLoC();

  Country defKenya = Country(
    asset: "assets/flags/ke_flag.png",
    dialingCode: "254",
    isoCode: "KE",
    name: "Kenya",
    currency: "Kenyan shilling",
    currencyISO: "KES",
  );

  NavigationDataBLoC wd_onboarding_email_Container_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC wd_onboarding_firstname_Container_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC wd_onboarding_lastname_Container_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC wd_onboarding_phoneno_Container_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC wd_onboarding_username_Container_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC wd_onboarding_password1_Container_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC wd_onboarding_password2_Container_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC wd_onboarding_profilepic_Container_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC wd_fb_Container_NavigationDataBLoC = NavigationDataBLoC();
  NavigationDataBLoC wd_insta_Container_NavigationDataBLoC =
      NavigationDataBLoC();

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
  }

  @override
  void afterFirstLayout(BuildContext context) {
    KeyboardVisibility.onChange.listen(
      (bool visible) {
        widget.keyBoardVisibleBLoC.keyboard_visible_event_sink
            .add(ToggleKeyBoardVisEvent(visible));
      },
    );
    initUI();
    refreshRecentOnBoarding();
    addListeners();
    getSignUpData();
  }

  addListeners() {
    widget.recentOnBoardingChangedOnBoardingClickableItemBLoC.stream_counter
        .listen((value) {
      refreshOnBoarding();
    });

    widget.saved_Clicked_NavigationDataBLoC.stream_counter.listen((value) {
      print('SAVE CLICKED UUUUII');
      if (_suformKey.currentState.validate()) {
        _suformKey.currentState.save();
        setState(() {
          _autoValidate = true;
        });
      } else {
        _suformKey.currentState.save();
        setState(() {
          _autoValidate = true;
        });
      }
      validateProfilePicture();

      validateExistingEmail();
      validateExistingUsername();
      validateExistingPhoneno();
    });
  }

  refreshOnBoarding() async {
    Onboarding updatedOnboarding =
        await onboardingDao.getOnboardingById(widget.onboarding.id);
    widget.onboarding = updatedOnboarding;
  }

  initUI() async {
    database = Provider.of<AppDatabase>(context);
    onboardingDao = database.onboardingDao;
    educationLevelDao = database.educationLevelDao;
  }

  refreshRecentOnBoarding() async {
    Onboarding updatedOnboarding =
        await onboardingDao.getOnboardingById(widget.onboarding.id);
    widget.onboarding = updatedOnboarding;
    print(TAG + ' refreshRecentOnBoarding');
    print(TAG + 'iam==');
    print(widget.onboarding.iam.toString());
    print(TAG + 'widget.onboarding.id==');
    print(widget.onboarding.id.toString());
  }

  initVariables() {
    getImageFileFromAssets('assets/illustrations/profile_pic_trans.png');
  }

  getSignUpData() async {
    UserSessionSharedPrefs userSessionSharedPrefs =
        new UserSessionSharedPrefs();
    LoginRespModel loginRespModel =
        await userSessionSharedPrefs.getUserSessionLoginRespModel();
    if (loginRespModel != null) {
      resetDataFromUserSessionSharedPrefs(loginRespModel);
    }
  }

  resetDataFromUserSessionSharedPrefs(LoginRespModel loginRespModel) {
    userNameController.text = loginRespModel.username;
    emailController.text = loginRespModel.email;
    setState(() {
      fileProfpic = File(loginRespModel.local_profile_picture_path +
          loginRespModel.local_profile_picture_filename);
    });

    OnboardingsCompanion onboardingsCompanion =
        widget.onboarding.toCompanion(false).copyWith(
              email: flutterMoor.Value(emailController.text),
              username: flutterMoor.Value(userNameController.text),
              profpicpath: flutterMoor.Value(
                  loginRespModel.local_profile_picture_path +
                      loginRespModel.local_profile_picture_filename),
            );
    updateOnBoarding(onboardingsCompanion);
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
        builder: (context, adrianErpThemeChanger, child) {
          return SingleChildScrollView(
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                height: MediaQuery.of(context).size.height,
/*            decoration: BoxDecoration(
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
                color: DatingAppTheme.background,
                child: Builder(
                  builder: (BuildContext context) => Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 60),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 30.0,
                            left: 30.0,
                          ),
                          child:
                              /*Text(
                            'Sign Up',
                            style: new TextStyle(
                                fontSize: 30.0,
                                fontFamily: 'GothamRoundedMedium_21022',
                                color: Colors.white),
                          ),*/
                              CustomTitleView(
                            titleTxt: 'Sign Up',
                            subTxt: '',
                            animation: Tween<double>(begin: 0.0, end: 1.0)
                                .animate(CurvedAnimation(
                                    parent: animationController,
                                    curve: Interval((1 / 9) * 0, 1.0,
                                        curve: Curves.fastOutSlowIn))),
                            animationController: animationController,
                            titleTextStyle: adrianErpThemeChanger
                                .selectedThemeData
                                .default_bgTitleText_TextStyle,
                          ),
                        ),
                        SizedBox(height: 30),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.0,
                                      ),
                                      child: Text(
                                        'Email',
                                        style: adrianErpThemeChanger
                                            .selectedThemeData
                                            .default_label_TextStyle,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: DatingAppTheme.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(30.0),
                                            ),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  offset: Offset(1, 5),
                                                  blurRadius: 5.0),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              right: 0.0,
                                              left: 10.0,
                                            ),
                                            child: TextFormField(
                                              style: adrianErpThemeChanger
                                                  .selectedThemeData
                                                  .default_text_TextStyle,
                                              cursorColor:
                                                  DatingAppTheme.darkText,
                                              decoration: InputDecoration(
                                                icon: Icon(
                                                  FontAwesomeIcons.envelope,
                                                  color: adrianErpThemeChanger
                                                      .selectedThemeData
                                                      .cl_grey,
                                                  size: 22.0,
                                                ),
                                                border: InputBorder.none,
                                                hintText: "Email",
                                                hintStyle: adrianErpThemeChanger
                                                    .selectedThemeData
                                                    .default_hint_TextStyle,
                                                errorStyle: adrianErpThemeChanger
                                                    .selectedThemeData
                                                    .default_error_TextStyle,
                                              ),
                                              validator: validate_Email,
                                              controller: emailController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              focusNode: emailFocusNode,
                                              onChanged: (String value) {
                                                emailEditingComplete(value);
                                              },
                                              onEditingComplete: () {
                                                email_onEditingComplete();
                                              },
                                            ),
                                          ),
                                        ),
                                        StreamBuilder(
                                          stream:
                                              wd_onboarding_email_Container_NavigationDataBLoC
                                                  .stream_counter,
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
                                                return wd_Error_Notifier_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                              case ConnectionState.done:
                                                return wd_Error_Notifier_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.0,
                                      ),
                                      child: Text(
                                        'First Name',
                                        style: adrianErpThemeChanger
                                            .selectedThemeData
                                            .default_label_TextStyle,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: DatingAppTheme.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(30.0),
                                            ),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  offset: Offset(1, 5),
                                                  blurRadius: 5.0),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              right: 0.0,
                                              left: 10.0,
                                            ),
                                            child: TextFormField(
                                              style: adrianErpThemeChanger
                                                  .selectedThemeData
                                                  .default_text_TextStyle,
                                              cursorColor:
                                                  DatingAppTheme.darkText,
                                              decoration: InputDecoration(
                                                icon: Icon(
                                                  FontAwesomeIcons.user,
                                                  color: adrianErpThemeChanger
                                                      .selectedThemeData
                                                      .cl_grey,
                                                  size: 22.0,
                                                ),
                                                border: InputBorder.none,
                                                hintText: "First Name",
                                                hintStyle: adrianErpThemeChanger
                                                    .selectedThemeData
                                                    .default_hint_TextStyle,
                                                errorStyle: adrianErpThemeChanger
                                                    .selectedThemeData
                                                    .default_error_TextStyle,
                                              ),
                                              validator: validateFirstName,
                                              controller: firstNameController,
                                              keyboardType: TextInputType.text,
                                              focusNode: firstNameFocusNode,
                                              onChanged: (String value) {
                                                firstnameEditingComplete(value);
                                              },
                                            ),
                                          ),
                                        ),
                                        StreamBuilder(
                                          stream:
                                              wd_onboarding_firstname_Container_NavigationDataBLoC
                                                  .stream_counter,
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
                                                return wd_Error_Notifier_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                              case ConnectionState.done:
                                                return wd_Error_Notifier_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.0,
                                      ),
                                      child: Text(
                                        'Last Name',
                                        style: adrianErpThemeChanger
                                            .selectedThemeData
                                            .default_label_TextStyle,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: DatingAppTheme.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(30.0),
                                            ),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  offset: Offset(1, 5),
                                                  blurRadius: 5.0),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              right: 0.0,
                                              left: 10.0,
                                            ),
                                            child: TextFormField(
                                              style: adrianErpThemeChanger
                                                  .selectedThemeData
                                                  .default_text_TextStyle,
                                              cursorColor:
                                                  DatingAppTheme.darkText,
                                              decoration: InputDecoration(
                                                icon: Icon(
                                                  FontAwesomeIcons.user,
                                                  color: adrianErpThemeChanger
                                                      .selectedThemeData
                                                      .cl_grey,
                                                  size: 22.0,
                                                ),
                                                border: InputBorder.none,
                                                hintText: "Last Name",
                                                hintStyle: adrianErpThemeChanger
                                                    .selectedThemeData
                                                    .default_hint_TextStyle,
                                                errorStyle: adrianErpThemeChanger
                                                    .selectedThemeData
                                                    .default_error_TextStyle,
                                              ),
                                              validator: validateLastName,
                                              controller: lastNameController,
                                              keyboardType: TextInputType.text,
                                              focusNode: lastNameFocusNode,
                                              onChanged: (String value) {
                                                lastnameEditingComplete(value);
                                              },
                                            ),
                                          ),
                                        ),
                                        StreamBuilder(
                                          stream:
                                              wd_onboarding_lastname_Container_NavigationDataBLoC
                                                  .stream_counter,
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
                                                return wd_Error_Notifier_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                              case ConnectionState.done:
                                                return wd_Error_Notifier_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.0,
                                      ),
                                      child: Text(
                                        'Phone No.',
                                        style: adrianErpThemeChanger
                                            .selectedThemeData
                                            .default_label_TextStyle,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Expanded(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    height: 40,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 5.0,
                                                      ),
                                                      child: CountryPicker(
                                                        dense: false,
                                                        selectedCountry:
                                                            defKenya,
                                                        showFlag:
                                                            true, //displays flag, true by default
                                                        showDialingCode:
                                                            true, //displays dialing code, false by default
                                                        showName:
                                                            false, //displays country name, true by default
                                                        onChanged:
                                                            (Country country) {
                                                          defKenya = country;
                                                        },
                                                        dialingCodeTextStyle:
                                                            adrianErpThemeChanger
                                                                .selectedThemeData
                                                                .default_text_TextStyle,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 5.0,
                                                      ),
                                                      child: Container(
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: DatingAppTheme
                                                              .white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    0),
                                                            topRight:
                                                                Radius.circular(
                                                                    30),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    30),
                                                          ),
                                                          boxShadow: <
                                                              BoxShadow>[
                                                            BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.2),
                                                                offset: Offset(
                                                                    1, 5),
                                                                blurRadius:
                                                                    5.0),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            right: 0.0,
                                                            left: 10.0,
                                                          ),
                                                          child: TextFormField(
                                                            style: adrianErpThemeChanger
                                                                .selectedThemeData
                                                                .default_text_TextStyle,
                                                            cursorColor:
                                                                DatingAppTheme
                                                                    .darkText,
                                                            decoration:
                                                                InputDecoration(
                                                              icon: Icon(
                                                                FontAwesomeIcons
                                                                    .phone,
                                                                color: adrianErpThemeChanger
                                                                    .selectedThemeData
                                                                    .cl_grey,
                                                                size: 22.0,
                                                              ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintText:
                                                                  "Phone No.",
                                                              hintStyle: adrianErpThemeChanger
                                                                  .selectedThemeData
                                                                  .default_hint_TextStyle,
                                                              errorStyle: adrianErpThemeChanger
                                                                  .selectedThemeData
                                                                  .default_error_TextStyle,
                                                            ),
                                                            validator:
                                                                validatePhoneNo,
                                                            controller:
                                                                phoneNoController,
                                                            keyboardType: TextInputType
                                                                .numberWithOptions(
                                                                    decimal:
                                                                        false),
                                                            focusNode:
                                                                phoneNoFocusNode,
                                                            onChanged:
                                                                (String value) {
                                                              phoneNoEditingComplete(
                                                                  value);
                                                            },
                                                            onEditingComplete:
                                                                () {
                                                              phoneno_onEditingComplete();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        StreamBuilder(
                                          stream:
                                              wd_onboarding_phoneno_Container_NavigationDataBLoC
                                                  .stream_counter,
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
                                                return wd_Error_Notifier_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                              case ConnectionState.done:
                                                return wd_Error_Notifier_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.0,
                                      ),
                                      child: Text(
                                        'Username',
                                        style: adrianErpThemeChanger
                                            .selectedThemeData
                                            .default_label_TextStyle,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: DatingAppTheme.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(30.0),
                                            ),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  offset: Offset(1, 5),
                                                  blurRadius: 5.0),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              right: 0.0,
                                              left: 10.0,
                                            ),
                                            child: TextFormField(
                                              style: adrianErpThemeChanger
                                                  .selectedThemeData
                                                  .default_text_TextStyle,
                                              cursorColor:
                                                  DatingAppTheme.darkText,
                                              decoration: InputDecoration(
                                                icon: Icon(
                                                  FontAwesomeIcons.user,
                                                  color: adrianErpThemeChanger
                                                      .selectedThemeData
                                                      .cl_grey,
                                                  size: 22.0,
                                                ),
                                                border: InputBorder.none,
                                                hintText: "Username",
                                                hintStyle: adrianErpThemeChanger
                                                    .selectedThemeData
                                                    .default_hint_TextStyle,
                                                errorStyle: adrianErpThemeChanger
                                                    .selectedThemeData
                                                    .default_error_TextStyle,
                                              ),
                                              validator: validateUserName,
                                              controller: userNameController,
                                              keyboardType: TextInputType.text,
                                              focusNode: userNameFocusNode,
                                              onChanged: (String value) {
                                                usernameEditingComplete(value);
                                              },
                                              onEditingComplete: () {
                                                username_onEditingComplete();
                                              },
                                            ),
                                          ),
                                        ),
                                        StreamBuilder(
                                          stream:
                                              wd_onboarding_username_Container_NavigationDataBLoC
                                                  .stream_counter,
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
                                                return wd_Error_Notifier_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                              case ConnectionState.done:
                                                return wd_Error_Notifier_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                            }
                                          },
                                        ),
                                      ],
                                    ),

                                    /* TextFormField(
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
                                        fontSize: 16.0,
                                        color: colorDarkGrey,
                                        fontFamily: 'GothamRounded-Medium',
                                      ),
                                      decoration: InputDecoration(
                                        //border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.user,
                                          color: colorUserNameIcon,
                                          size: 22.0,
                                        ),
                                        hintText: "Username",
                                        hintStyle: TextStyle(
                                          color: colorDarkGrey,
                                          fontFamily: 'GothamRounded-Medium',
                                          fontSize: 16.0,
                                          //fontStyle: FontStyle.italic
                                        ),
                                        errorStyle:
                                            TextStyle(color: Colors.black),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: colorGreen1, width: 2),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1),
                                        ),
                                      ),
                                      focusNode: userNameFocusNode,
                                      onChanged: (String value) {
                                        usernameEditingComplete(value);
                                      },
                                    ),*/
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.0,
                                      ),
                                      child: Text(
                                        'Birth Date',
                                        style: adrianErpThemeChanger
                                            .selectedThemeData
                                            .default_label_TextStyle,
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: DatingAppTheme.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(30.0),
                                            ),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  offset: Offset(1, 5),
                                                  blurRadius: 5.0),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              right: 0.0,
                                              left: 10.0,
                                            ),
                                            child: TextFormField(
                                              style: adrianErpThemeChanger
                                                  .selectedThemeData
                                                  .default_text_TextStyle,
                                              cursorColor:
                                                  DatingAppTheme.darkText,
                                              decoration: InputDecoration(
                                                icon: Icon(
                                                  FontAwesomeIcons.birthdayCake,
                                                  color: adrianErpThemeChanger
                                                      .selectedThemeData
                                                      .cl_grey,
                                                  size: 22.0,
                                                ),
                                                border: InputBorder.none,
                                                hintText: "dd/MM/yyyy",
                                                hintStyle: adrianErpThemeChanger
                                                    .selectedThemeData
                                                    .default_hint_TextStyle,
                                                errorStyle: adrianErpThemeChanger
                                                    .selectedThemeData
                                                    .default_error_TextStyle,
                                              ),
                                              //validator: validateUserName,
                                              controller: birthdayController,
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: false),
                                              focusNode: birthdayFocusNode,
                                              onChanged: (String value) {
                                                onBirthdayFieldChanged(value);
                                              },
                                              onFieldSubmitted:
                                                  (String value) {},
                                            ),
                                            /*DateTimeField(
                                          validator: (value) {
                                            return validateBirthDay(
                                                value.toString());
                                          },
                                          controller: birthdayController,
                                          keyboardType: TextInputType.text,
                                          style: adrianErpThemeChanger
                                              .selectedThemeData
                                              .default_text_TextStyle,
                                          decoration: InputDecoration(
                                            icon: Icon(
                                              FontAwesomeIcons.birthdayCake,
                                              color: adrianErpThemeChanger
                                                  .selectedThemeData.cl_grey,
                                              size: 22.0,
                                            ),
                                            hintText: "Birth Date",
                                            hintStyle: adrianErpThemeChanger
                                                .selectedThemeData
                                                .default_hint_TextStyle,
                                            errorStyle: adrianErpThemeChanger
                                                .selectedThemeData
                                                .default_error_TextStyle,
                                            border: InputBorder.none,
                                          ),
                                          focusNode: birthdayFocusNode,
                                          format: format,
                                          onShowPicker:
                                              (context, currentValue) async {
                                            final date = await showDatePicker(
                                                context: context,
                                                firstDate: DateTime(1900),
                                                initialDate: currentValue ??
                                                    DateTime.now(),
                                                lastDate: DateTime(2100));
                                            if (date != null) {
                                              birthdayEditingComplete(
                                                  DateTimeField.combine(
                                                      date, null));
                                              return DateTimeField.combine(
                                                  date, null);
                                            } else {
                                              return currentValue;
                                            }
                                          },
                                        ),*/
                                          ),
                                        ),
                                        StreamBuilder(
                                          stream:
                                              wd_Activity_Container_DailySubTaskImagesBLoC
                                                  .stream_counter,
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
                                                return wd_Error_Notifier_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                              case ConnectionState.done:
                                                return wd_Error_Notifier_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.0,
                                      ),
                                      child: Text(
                                        'Facebook Link',
                                        style: adrianErpThemeChanger
                                            .selectedThemeData
                                            .default_label_TextStyle,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: DatingAppTheme.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(30.0),
                                            ),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  offset: Offset(1, 5),
                                                  blurRadius: 5.0),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              right: 0.0,
                                              left: 10.0,
                                            ),
                                            child: TextFormField(
                                              style: adrianErpThemeChanger
                                                  .selectedThemeData
                                                  .default_text_TextStyle,
                                              cursorColor:
                                                  DatingAppTheme.darkText,
                                              decoration: InputDecoration(
                                                icon: Icon(
                                                  FontAwesomeIcons.facebook,
                                                  color: adrianErpThemeChanger
                                                      .selectedThemeData
                                                      .cl_grey,
                                                  size: 22.0,
                                                ),
                                                border: InputBorder.none,
                                                hintText: "Facebook Link",
                                                hintStyle: adrianErpThemeChanger
                                                    .selectedThemeData
                                                    .default_hint_TextStyle,
                                                errorStyle: adrianErpThemeChanger
                                                    .selectedThemeData
                                                    .default_error_TextStyle,
                                              ),
                                              validator: validateFbLink,
                                              controller: fbController,
                                              keyboardType: TextInputType.text,
                                              focusNode: fbFocusNode,
                                              onChanged: (String value) {
                                                fblinkEditingComplete(value);
                                              },
                                              onEditingComplete: () {},
                                            ),
                                          ),
                                        ),
                                        StreamBuilder(
                                          stream:
                                              wd_fb_Container_NavigationDataBLoC
                                                  .stream_counter,
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
                                                return wd_Text_Widget_Form_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                              case ConnectionState.done:
                                                return wd_Text_Widget_Form_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.0,
                                      ),
                                      child: Text(
                                        'Instagram Link',
                                        style: adrianErpThemeChanger
                                            .selectedThemeData
                                            .default_label_TextStyle,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: DatingAppTheme.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(30.0),
                                            ),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  offset: Offset(1, 5),
                                                  blurRadius: 5.0),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              right: 0.0,
                                              left: 10.0,
                                            ),
                                            child: TextFormField(
                                              style: adrianErpThemeChanger
                                                  .selectedThemeData
                                                  .default_text_TextStyle,
                                              cursorColor:
                                                  DatingAppTheme.darkText,
                                              decoration: InputDecoration(
                                                icon: Icon(
                                                  FontAwesomeIcons.instagram,
                                                  color: adrianErpThemeChanger
                                                      .selectedThemeData
                                                      .cl_grey,
                                                  size: 22.0,
                                                ),
                                                border: InputBorder.none,
                                                hintText: "Instagram Link",
                                                hintStyle: adrianErpThemeChanger
                                                    .selectedThemeData
                                                    .default_hint_TextStyle,
                                                errorStyle: adrianErpThemeChanger
                                                    .selectedThemeData
                                                    .default_error_TextStyle,
                                              ),
                                              validator: validateInstaLink,
                                              controller: instaController,
                                              keyboardType: TextInputType.text,
                                              focusNode: instaFocusNode,
                                              onChanged: (String value) {
                                                instalinkEditingComplete(value);
                                              },
                                              onEditingComplete: () {},
                                            ),
                                          ),
                                        ),
                                        StreamBuilder(
                                          stream:
                                              wd_insta_Container_NavigationDataBLoC
                                                  .stream_counter,
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
                                                return wd_Text_Widget_Form_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                              case ConnectionState.done:
                                                return wd_Text_Widget_Form_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                            }
                                          },
                                        ),
                                      ],
                                    ),

/*                                    DateTimeField(
                                      validator: (value) {
                                        if (value.toString().isEmpty ||
                                            !(value.toString().trim().length >
                                                0)) {
                                          return 'Invalid Birthday';
                                        }
                                        return null;
                                      },
                                      controller: birthdayController,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: colorDarkGrey,
                                        fontFamily: 'GothamRounded-Medium',
                                      ),
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          FontAwesomeIcons.birthdayCake,
                                          color: colorBirthdayIcon,
                                          size: 22.0,
                                        ),
                                        hintText: "Birthday",
                                        hintStyle: TextStyle(
                                          color: colorDarkGrey,
                                          fontFamily: 'GothamRounded-Medium',
                                          fontSize: 16.0,
                                        ),
                                        errorStyle:
                                            TextStyle(color: Colors.black),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: colorGreen1, width: 2),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1),
                                        ),
                                      ),
                                      focusNode: birthdayFocusNode,
                                      format: format,
                                      onShowPicker:
                                          (context, currentValue) async {
                                        final date = await showDatePicker(
                                            context: context,
                                            firstDate: DateTime(1900),
                                            initialDate:
                                                currentValue ?? DateTime.now(),
                                            lastDate: DateTime(2100));
                                        if (date != null) {
                                          birthdayEditingComplete(
                                              DateTimeField.combine(
                                                  date, null));
                                          return DateTimeField.combine(
                                              date, null);
                                        } else {
                                          return currentValue;
                                        }
                                      },
                                    ),*/
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.0,
                                      ),
                                      child: Text(
                                        'Password',
                                        style: adrianErpThemeChanger
                                            .selectedThemeData
                                            .default_label_TextStyle,
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: DatingAppTheme.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(30.0),
                                            ),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  offset: Offset(1, 5),
                                                  blurRadius: 5.0),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              right: 0.0,
                                              left: 10.0,
                                            ),
                                            child: TextFormField(
                                              style: adrianErpThemeChanger
                                                  .selectedThemeData
                                                  .default_text_TextStyle,
                                              cursorColor:
                                                  DatingAppTheme.darkText,
                                              decoration: InputDecoration(
                                                icon: Icon(
                                                  FontAwesomeIcons.lock,
                                                  color: adrianErpThemeChanger
                                                      .selectedThemeData
                                                      .cl_grey,
                                                  size: 22.0,
                                                ),
                                                border: InputBorder.none,
                                                hintText: "Password",
                                                hintStyle: adrianErpThemeChanger
                                                    .selectedThemeData
                                                    .default_hint_TextStyle,
                                                errorStyle: adrianErpThemeChanger
                                                    .selectedThemeData
                                                    .default_error_TextStyle,
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    password1Visible
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: DatingAppTheme.grey,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      password1Visible =
                                                          !password1Visible;
                                                    });
                                                  },
                                                ),
                                              ),
                                              validator: validatePass1,
                                              controller: passwordController,
                                              obscureText: !password1Visible,
                                              keyboardType: TextInputType.text,
                                              focusNode: passwordFocusNode,
                                              onChanged: (String value) {
                                                password1EditingComplete(value);
                                              },
                                            ),
                                          ),
                                        ),
                                        StreamBuilder(
                                          stream:
                                              wd_onboarding_password1_Container_NavigationDataBLoC
                                                  .stream_counter,
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
                                                return wd_Error_Notifier_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                              case ConnectionState.done:
                                                return wd_Error_Notifier_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    /*TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty ||
                                            !(value.trim().length > 0)) {
                                          return 'Invalid Password';
                                        }
                                        if (value !=
                                            confpasswordController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                      controller: passwordController,
                                      obscureText: true,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: colorDarkGrey,
                                        fontFamily: 'GothamRounded-Medium',
                                      ),
                                      decoration: InputDecoration(
                                        //border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.lock,
                                          color: colorPasswordIcon,
                                          size: 22.0,
                                        ),
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                          color: colorDarkGrey,
                                          fontFamily: 'GothamRounded-Medium',
                                          fontSize: 16.0,
                                          //fontStyle: FontStyle.italic
                                        ),
                                        errorStyle:
                                            TextStyle(color: Colors.black),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: colorGreen1, width: 2),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1),
                                        ),
                                      ),
                                      focusNode: passwordFocusNode,
                                      onChanged: (String value) {
                                        password1EditingComplete(value);
                                      },
                                    ),*/
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.0,
                                      ),
                                      child: Text(
                                        'Confirm Password',
                                        style: adrianErpThemeChanger
                                            .selectedThemeData
                                            .default_label_TextStyle,
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: DatingAppTheme.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(30.0),
                                            ),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  offset: Offset(1, 5),
                                                  blurRadius: 5.0),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              right: 0.0,
                                              left: 10.0,
                                            ),
                                            child: TextFormField(
                                              style: adrianErpThemeChanger
                                                  .selectedThemeData
                                                  .default_text_TextStyle,
                                              cursorColor:
                                                  DatingAppTheme.darkText,
                                              decoration: InputDecoration(
                                                icon: Icon(
                                                  FontAwesomeIcons.lock,
                                                  color: adrianErpThemeChanger
                                                      .selectedThemeData
                                                      .cl_grey,
                                                  size: 22.0,
                                                ),
                                                border: InputBorder.none,
                                                hintText: "Confirm Password",
                                                hintStyle: adrianErpThemeChanger
                                                    .selectedThemeData
                                                    .default_hint_TextStyle,
                                                errorStyle: adrianErpThemeChanger
                                                    .selectedThemeData
                                                    .default_error_TextStyle,
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    password2Visible
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: DatingAppTheme.grey,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      password2Visible =
                                                          !password2Visible;
                                                    });
                                                  },
                                                ),
                                              ),
                                              validator: validatePass2,
                                              controller:
                                                  confpasswordController,
                                              obscureText: !password2Visible,
                                              keyboardType: TextInputType.text,
                                              focusNode: confpasswordFocusNode,
                                              onChanged: (String value) {
                                                password2EditingComplete(value);
                                              },
                                            ),
                                          ),
                                        ),
                                        StreamBuilder(
                                          stream:
                                              wd_onboarding_password2_Container_NavigationDataBLoC
                                                  .stream_counter,
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
                                                return wd_Error_Notifier_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                              case ConnectionState.done:
                                                return wd_Error_Notifier_Validator_Text(
                                                    adrianErpThemeChanger,
                                                    snapshot);
                                                break;
                                            }
                                          },
                                        ),
                                      ],
                                    ),

                                    /*TextFormField(
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
                                        fontSize: 16.0,
                                        color: colorDarkGrey,
                                        fontFamily: 'GothamRounded-Medium',
                                      ),
                                      decoration: InputDecoration(
                                        //border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.lock,
                                          color: colorConfPasswordIcon,
                                          size: 22.0,
                                        ),
                                        hintText: "Confirm Password",
                                        hintStyle: TextStyle(
                                          color: colorDarkGrey,
                                          fontFamily: 'GothamRounded-Medium',
                                          fontSize: 16.0,
                                          //fontStyle: FontStyle.italic
                                        ),
                                        errorStyle:
                                            TextStyle(color: Colors.black),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: colorGreen1, width: 2),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1),
                                        ),
                                      ),
                                      focusNode: confpasswordFocusNode,
                                      onChanged: (String value) {
                                        password2EditingComplete(value);
                                      },
                                    ),*/
                                    SizedBox(height: 10),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 10.0,
                                                ),
                                                child: Icon(
                                                  FontAwesomeIcons.userAlt,
                                                  color: adrianErpThemeChanger
                                                      .selectedThemeData
                                                      .cl_grey,
                                                  size: 22.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 9),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  3, 5, 3, 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Stack(
                                                    children: <Widget>[
                                                      Column(
                                                        children: <Widget>[
                                                          CircularProfileAvatar(
                                                            '',
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: fileProfpic !=
                                                                            null
                                                                        ? Image.file(fileProfpic)
                                                                            .image
                                                                        : Image.asset('assets/images/image_placeholder.png')
                                                                            .image,
                                                                    fit: BoxFit
                                                                        .cover),
                                                              ),
                                                            ),
                                                            radius: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                4,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            borderWidth: 0,
                                                            initialsText: Text(
                                                              "Profile Picture",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      str_GothamRounded_Medium,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            elevation: 5.0,
                                                            foregroundColor:
                                                                Colors.brown
                                                                    .withOpacity(
                                                                        0.5),
                                                            cacheImage: true,
                                                            onTap: () {
                                                              pickProfilePic(
                                                                  context);
                                                            },
                                                            showInitialTextAbovePicture:
                                                                false,
                                                          ),
                                                        ],
                                                      ),
                                                      StreamBuilder(
                                                        stream:
                                                            wd_onboarding_profilepic_Container_NavigationDataBLoC
                                                                .stream_counter,
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasError) {
                                                            return invisibleWidget();
                                                          }
                                                          switch (snapshot
                                                              .connectionState) {
                                                            case ConnectionState
                                                                .none:
                                                              return invisibleWidget();
                                                              break;
                                                            case ConnectionState
                                                                .waiting:
                                                              return invisibleWidget();
                                                              break;
                                                            case ConnectionState
                                                                .active:
                                                              return ifToShow_positionedErrorIcon(
                                                                  snapshot);
                                                              break;
                                                            case ConnectionState
                                                                .done:
                                                              return ifToShow_positionedErrorIcon(
                                                                  snapshot);
                                                              break;
                                                          }
                                                        },
                                                      ),
                                                      //positionedErrorIcon(),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right: 5.0,
                                      ),
                                      child: Text(
                                        'When you tap save, Connections will verify your info and create your user account. Data rates may apply.',
                                        style: adrianErpThemeChanger
                                            .selectedThemeData
                                            .default_description_TextStyle,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(height: 20),
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
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

  //BIRTH DATE FIELD AND VALIDATOR
  refresh_wd_Activity_Container_DailySubTaskImagesBLoC(
      bool isValid, String msg) {
    NavigationData navigationData = NavigationData();
    navigationData.isValid = isValid;
    navigationData.message = msg;
    wd_Activity_Container_DailySubTaskImagesBLoC.dailySubTaskimages_event_sink
        .add(NavigationDataAddedEvent(navigationData));
  }

  onBirthdayFieldChanged(String strVal) {
    String TAG = 'onBirthdayFieldChanged:';
    if (!isStringValid(birthdayController.text)) {
      refresh_wd_Activity_Container_DailySubTaskImagesBLoC(
          false, 'invalid Birth Date');
      return;
    }
    try {
      DateTime dateTimeFromFormat = format.parseStrict(birthdayController.text);

      if (isAdult(dateTimeFromFormat)) {
        DateTime today = DateTime.now();
        int yearDiff = today.year - dateTimeFromFormat.year;
        if (yearDiff > 100) {
          refresh_wd_Activity_Container_DailySubTaskImagesBLoC(
              false, 'invalid Birth Date');
          return;
        } else {
          OnboardingsCompanion onboardingsCompanion = widget.onboarding
              .toCompanion(false)
              .copyWith(birthday: flutterMoor.Value(birthdayController.text));
          updateOnBoarding(onboardingsCompanion);
          refresh_wd_Activity_Container_DailySubTaskImagesBLoC(true, null);
        }
      } else {
        refresh_wd_Activity_Container_DailySubTaskImagesBLoC(
            false, 'you must be 18+');
        return;
      }
    } catch (error) {
      print(TAG + ' error==');
      print(error.toString());
      refresh_wd_Activity_Container_DailySubTaskImagesBLoC(
          false, 'invalid Birth Date');
      return;
    }
    refresh_wd_Activity_Container_DailySubTaskImagesBLoC(true, null);
  }

  //END OF BIRTH DATE FIELD AND VALIDATOR

  //EMAIL FIELD AND VALIDATOR
  String validate_Email(String strVal) {
    if (!isStringValid(emailController.text)) {
      refresh_wd_validator_NavigationDataBLoC(false, 'invalid Email',
          wd_onboarding_email_Container_NavigationDataBLoC);
      return null;
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(emailController.text)) {
        refresh_wd_validator_NavigationDataBLoC(
            false,
            'email should be in the format name@domain.com',
            wd_onboarding_email_Container_NavigationDataBLoC);
        return null;
      } else {
        refresh_wd_validator_NavigationDataBLoC(
            true, null, wd_onboarding_email_Container_NavigationDataBLoC);
        validateExistingEmail();
        return null;
      }
    }
  }

  emailEditingComplete(String fValue) {
    validate_Email(fValue);
    OnboardingsCompanion onboardingsCompanion = widget.onboarding
        .toCompanion(false)
        .copyWith(email: flutterMoor.Value(emailController.text));
    updateOnBoarding(onboardingsCompanion);
  }

  email_onEditingComplete() {
    String TAG = 'email_onEditingComplete:';
    validateExistingEmail();
  }

  validateExistingEmail() async {
    bool user_exists = await post_validate_email(
      context,
      null,
      emailController.text,
      null,
    );
    if (user_exists) {
      refresh_wd_validator_NavigationDataBLoC(
          false,
          'user with this email exists',
          wd_onboarding_email_Container_NavigationDataBLoC);
    } else {
      refresh_wd_validator_NavigationDataBLoC(
          true, null, wd_onboarding_email_Container_NavigationDataBLoC);
    }
  }

  //END OF EMAIL FIELD AND VALIDATOR

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
      response =
          await Provider.of<PostApiService>(context).signupprocessmultipart(
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

  //USERNAME FIELD
  usernameEditingComplete(String fValue) {
    validateUserName(fValue);
    OnboardingsCompanion onboardingsCompanion = widget.onboarding
        .toCompanion(false)
        .copyWith(username: flutterMoor.Value(userNameController.text));
    updateOnBoarding(onboardingsCompanion);
  }

  String validateUserName(String value) {
    if (!isStringValid(userNameController.text)) {
      refresh_wd_validator_NavigationDataBLoC(false, 'invalid Username',
          wd_onboarding_username_Container_NavigationDataBLoC);
      return null;
    } else {
      refresh_wd_validator_NavigationDataBLoC(
          true, null, wd_onboarding_username_Container_NavigationDataBLoC);
      validateExistingUsername();
      return null;
    }
  }

  fblinkEditingComplete(String fValue) {
    validateFbLink(fValue);
    OnboardingsCompanion onboardingsCompanion = widget.onboarding
        .toCompanion(false)
        .copyWith(fb_link: flutterMoor.Value(fbController.text));
    updateOnBoarding(onboardingsCompanion);
  }

  String validateFbLink(String strVal) {
    if (!isStringValid(fbController.text)) {
      refresh_wd_ValidationField_Container_NavigationDataBLoC(
          wd_fb_Container_NavigationDataBLoC, false, 'invalid link');
      return null;
    } else {
      //IS VALID
      RegExp regex = new RegExp(get_Url_Pattern());
      if (!regex.hasMatch(fbController.text)) {
        refresh_wd_ValidationField_Container_NavigationDataBLoC(
            wd_fb_Container_NavigationDataBLoC, false, 'invalid link');
        return null;
      }
    }
    refresh_wd_ValidationField_Container_NavigationDataBLoC(
        wd_fb_Container_NavigationDataBLoC, true, null);
    return null;
  }

  instalinkEditingComplete(String fValue) {
    validateInstaLink(fValue);
    OnboardingsCompanion onboardingsCompanion = widget.onboarding
        .toCompanion(false)
        .copyWith(insta_link: flutterMoor.Value(instaController.text));
    updateOnBoarding(onboardingsCompanion);
  }

  String validateInstaLink(String strVal) {
    if (!isStringValid(instaController.text)) {
      refresh_wd_ValidationField_Container_NavigationDataBLoC(
          wd_insta_Container_NavigationDataBLoC, false, 'invalid link');
      return null;
    } else {
      //IS VALID
      RegExp regex = new RegExp(get_Url_Pattern());
      if (!regex.hasMatch(instaController.text)) {
        refresh_wd_ValidationField_Container_NavigationDataBLoC(
            wd_insta_Container_NavigationDataBLoC, false, 'invalid link');
        return null;
      }
    }
    refresh_wd_ValidationField_Container_NavigationDataBLoC(
        wd_insta_Container_NavigationDataBLoC, true, null);
    return null;
  }

  username_onEditingComplete() {
    String TAG = 'username_onEditingComplete:';
    validateExistingUsername();
  }

  validateExistingUsername() async {
    bool user_exists = await post_validate_user_name(
      context,
      null,
      userNameController.text,
      null,
    );
    if (user_exists) {
      refresh_wd_validator_NavigationDataBLoC(
          false,
          'user with this username exists',
          wd_onboarding_username_Container_NavigationDataBLoC);
    } else {
      refresh_wd_validator_NavigationDataBLoC(
          true, null, wd_onboarding_username_Container_NavigationDataBLoC);
    }
  }

  //END OF USERNAME FIELD

  //FIRST NAME FIELD

  String validateFirstName(String strVal) {
    if (!isStringValid(firstNameController.text)) {
      refresh_wd_validator_NavigationDataBLoC(false, 'invalid First Name',
          wd_onboarding_firstname_Container_NavigationDataBLoC);
      return null;
    } else {
      refresh_wd_validator_NavigationDataBLoC(
          true, null, wd_onboarding_firstname_Container_NavigationDataBLoC);
      return null;
    }
  }

  //END OF FIRST NAME FIELD

  //LAST NAME FIELD
  String validateLastName(String value) {
    if (!isStringValid(lastNameController.text)) {
      refresh_wd_validator_NavigationDataBLoC(false, 'invalid Last Name',
          wd_onboarding_lastname_Container_NavigationDataBLoC);
      return null;
    } else {
      refresh_wd_validator_NavigationDataBLoC(
          true, null, wd_onboarding_lastname_Container_NavigationDataBLoC);
      return null;
    }
  }
  //END OF LAST NAME FIELD

  //PHONE NO FIELD
  String validatePhoneNo(String value) {
    if (!isStringValid(phoneNoController.text)) {
      refresh_wd_validator_NavigationDataBLoC(false, 'invalid Phone No',
          wd_onboarding_phoneno_Container_NavigationDataBLoC);
      return null;
    } else {
      List<String> strList = phoneNoController.text.split('');
      List<String> stringsNotnumeric = [];
      for (String str in strList) {
        bool isnumeric = isNumeric(str);
        if (!isnumeric) {
          stringsNotnumeric.add(str);
        }
      }
      if (stringsNotnumeric.length > 0) {
        refresh_wd_validator_NavigationDataBLoC(false, 'invalid Phone No',
            wd_onboarding_phoneno_Container_NavigationDataBLoC);
        return null;
      } else {
        Pattern pnonenoPattern = r'^[0-9]{9}$';
        RegExp regex = new RegExp(pnonenoPattern);
        if (!regex.hasMatch(phoneNoController.text)) {
          refresh_wd_validator_NavigationDataBLoC(false, 'invalid Phone No',
              wd_onboarding_phoneno_Container_NavigationDataBLoC);
          return null;
        } else {
          refresh_wd_validator_NavigationDataBLoC(
              true, null, wd_onboarding_phoneno_Container_NavigationDataBLoC);
          validateExistingPhoneno();
          return null;
        }
      }
    }
  }

  phoneno_onEditingComplete() {
    String TAG = 'phoneno_onEditingComplete:';
    validateExistingPhoneno();
  }

  validateExistingPhoneno() async {
    bool user_exists = await post_validate_phone_no(
      context,
      null,
      defKenya.dialingCode + phoneNoController.text,
      null,
    );
    if (user_exists) {
      refresh_wd_validator_NavigationDataBLoC(
          false,
          'user with this phone no. exists',
          wd_onboarding_phoneno_Container_NavigationDataBLoC);
    } else {
      refresh_wd_validator_NavigationDataBLoC(
          true, null, wd_onboarding_phoneno_Container_NavigationDataBLoC);
    }
  }
  //END OF PHONE NO FIELD

  String validateBirthDay(String value) {
    if (!ifStringValid(value)) {
      return 'Invalid Birthday';
    }
    return null;
  }

  //PASSWORD 1 FIELD

  String validatePass1(String value) {
    if (!ifStringValid(passwordController.text)) {
      refresh_wd_validator_NavigationDataBLoC(false, 'invalid Password',
          wd_onboarding_password1_Container_NavigationDataBLoC);
      return null;
    }
    if (!(passwordController.text.length >= 5)) {
      refresh_wd_validator_NavigationDataBLoC(
          false,
          'password minimum is 5 characters',
          wd_onboarding_password1_Container_NavigationDataBLoC);
      return null;
    }

    RegExp regex = new RegExp(get_Password_Pattern());
    if (!regex.hasMatch(passwordController.text)) {
      refresh_wd_validator_NavigationDataBLoC(
          false,
          'illegal character in password',
          wd_onboarding_password1_Container_NavigationDataBLoC);
      return null;
    }
    if (passwordController.text != confpasswordController.text) {
      refresh_wd_validator_NavigationDataBLoC(false, 'passwords do not match',
          wd_onboarding_password1_Container_NavigationDataBLoC);
      return null;
    }
    refresh_wd_validator_NavigationDataBLoC(
        true, null, wd_onboarding_password1_Container_NavigationDataBLoC);
    refresh_wd_validator_NavigationDataBLoC(
        true, null, wd_onboarding_password2_Container_NavigationDataBLoC);
    return null;
  }

  //END OF PASSWORD 1 FIELD

  //END OF PASSWORD 2 FIELD
  String validatePass2(String value) {
    if (!ifStringValid(confpasswordController.text)) {
      refresh_wd_validator_NavigationDataBLoC(false, 'invalid Password',
          wd_onboarding_password2_Container_NavigationDataBLoC);
      return null;
    }
    if (!(confpasswordController.text.length >= 5)) {
      refresh_wd_validator_NavigationDataBLoC(
          false,
          'password minimum is 5 characters',
          wd_onboarding_password2_Container_NavigationDataBLoC);
      return null;
    }
    RegExp regex = new RegExp(get_Password_Pattern());
    if (!regex.hasMatch(confpasswordController.text)) {
      refresh_wd_validator_NavigationDataBLoC(
          false,
          'illegal character in password',
          wd_onboarding_password2_Container_NavigationDataBLoC);
      return null;
    }
    if (passwordController.text != confpasswordController.text) {
      refresh_wd_validator_NavigationDataBLoC(false, 'passwords do not match',
          wd_onboarding_password2_Container_NavigationDataBLoC);
      return null;
    }
    refresh_wd_validator_NavigationDataBLoC(
        true, null, wd_onboarding_password2_Container_NavigationDataBLoC);
    refresh_wd_validator_NavigationDataBLoC(
        true, null, wd_onboarding_password1_Container_NavigationDataBLoC);
    return null;
  }
  //END OF PASSWORD 2 FIELD

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

  pickProfilePic(BuildContext context) async {
    print('pickProfilePic');

    userNameFocusNode.unfocus();
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
    confpasswordFocusNode.unfocus();
    birthdayFocusNode.unfocus();
    setState(() {
      colorProfPicIcon = colorGreen1;

      colorPasswordIcon = colorBlack;
      colorEmailIcon = colorBlack;
      colorUserNameIcon = colorBlack;
      colorConfPasswordIcon = colorBlack;
      colorBirthdayIcon = colorBlack;
    });
    requestPermissionWithCheck(PermissionGroup.storage, context, 1);
  }

  requestPermissionWithCheck(
      PermissionGroup permissionGroup, BuildContext context, int noImagesReq) {
    PermissionHandler().checkPermissionStatus(permissionGroup).then(
        (PermissionStatus status) {
      bool bool_status = getPermissionStatusBool(status);
      if (bool_status) {
        pickFile(noImagesReq);
      } else {
        List<PermissionGroup> permissions = <PermissionGroup>[permissionGroup];
        PermissionHandler().requestPermissions(permissions).then((onValue) {
          PermissionStatus permissionStatus = onValue[permissionGroup];
          bool bool_status = getPermissionStatusBool(permissionStatus);
          if (bool_status) {
            pickFile(noImagesReq);
          } else {
            refresh_Isvalid_NavigationDataBLoC(
                false, wd_onboarding_profilepic_Container_NavigationDataBLoC);
            showSnackbar("Permission denied", context);
          }
        }, onError: (error) {
          refresh_Isvalid_NavigationDataBLoC(
              false, wd_onboarding_profilepic_Container_NavigationDataBLoC);
          print('error REQ 1== $error');
        });
      }
    }, onError: (error) {
      print('error REQ 2== $error');
      refresh_Isvalid_NavigationDataBLoC(
          false, wd_onboarding_profilepic_Container_NavigationDataBLoC);
      showSnackbar("An error occurred requesting permission", context);
      return PermissionStatus.unknown;
    });
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

  pickFile(int maxImages) async {
    await FilePicker.platform.pickFiles(
      type: FileType.image,
        allowMultiple: false
    ).then((result) {
      setState(() {
        String onValue=result.files.single.path;
        fileProfpic = new File(onValue);
        profPicPath = onValue;
        profilepicFilePath = onValue;
        profpicPathEditingComplete(onValue);
      });
    }, onError: (error) {
      print('error REQ 3== $error');
      setState(() {
        profPicPath = 'assets/illustrations/profile_pic_trans.png';
        profilepicFilePath = null;
      });
      refresh_Isvalid_NavigationDataBLoC(
          false, wd_onboarding_profilepic_Container_NavigationDataBLoC);
    });
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
  }

  firstnameEditingComplete(String fValue) {
    validateFirstName(fValue);
    OnboardingsCompanion onboardingsCompanion = widget.onboarding
        .toCompanion(false)
        .copyWith(firstname: flutterMoor.Value(firstNameController.text));
    updateOnBoarding(onboardingsCompanion);
  }

  lastnameEditingComplete(String fValue) {
    validateLastName(fValue);
    OnboardingsCompanion onboardingsCompanion = widget.onboarding
        .toCompanion(false)
        .copyWith(lastname: flutterMoor.Value(lastNameController.text));
    updateOnBoarding(onboardingsCompanion);
  }

  phoneNoEditingComplete(String fValue) {
    validatePhoneNo(fValue);
    OnboardingsCompanion onboardingsCompanion = widget.onboarding
        .toCompanion(false)
        .copyWith(
            phone_number: flutterMoor.Value(
                defKenya.dialingCode + phoneNoController.text));
    updateOnBoarding(onboardingsCompanion);
  }

  birthdayEditingComplete(DateTime dateTime) {
    birthdayController.text =
        DateTimeField.tryFormat(dateTime, date_format_ymd);
    OnboardingsCompanion onboardingsCompanion = widget.onboarding
        .toCompanion(false)
        .copyWith(birthday: flutterMoor.Value(birthdayController.text));
    updateOnBoarding(onboardingsCompanion);
  }

  password1EditingComplete(String fValue) {
    validatePass1(fValue);
    if (passwordController.text == confpasswordController.text) {
      OnboardingsCompanion onboardingsCompanion = widget.onboarding
          .toCompanion(false)
          .copyWith(password: flutterMoor.Value(passwordController.text));
      updateOnBoarding(onboardingsCompanion);
    }
  }

  password2EditingComplete(String fValue) {
    validatePass2(fValue);
    if (passwordController.text == confpasswordController.text) {
      OnboardingsCompanion onboardingsCompanion = widget.onboarding
          .toCompanion(false)
          .copyWith(password: flutterMoor.Value(passwordController.text));
      updateOnBoarding(onboardingsCompanion);
    }
  }

  profpicPathEditingComplete(String fValue) {
    refresh_Isvalid_NavigationDataBLoC(
        true, wd_onboarding_profilepic_Container_NavigationDataBLoC);
    OnboardingsCompanion onboardingsCompanion = widget.onboarding
        .toCompanion(false)
        .copyWith(profpicpath: flutterMoor.Value(fValue));
    updateOnBoarding(onboardingsCompanion);
  }

  updateOnBoarding(OnboardingsCompanion onboardingsCompanion) async {
    try {
      bool isUpdated =
          await onboardingDao.updateOnboarding(onboardingsCompanion);
      widget.onboarding =
          await onboardingDao.getOnboardingById(widget.onboarding.id);
      widget.functionOnBoardingChanged(widget.onboarding);
      print('isUpdated=${isUpdated}');
    } catch (error) {
      print('error=${error}');
    }
  }

  validateProfilePicture() {
    if (!isStringValid(widget.onboarding.profpicpath)) {
      refresh_Isvalid_NavigationDataBLoC(
          false, wd_onboarding_profilepic_Container_NavigationDataBLoC);
    } else {
      refresh_Isvalid_NavigationDataBLoC(
          true, wd_onboarding_profilepic_Container_NavigationDataBLoC);
    }
  }
}

typedef IntindexCallback = void Function(Onboarding onboarding);
