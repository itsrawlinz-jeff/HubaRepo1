import 'package:dating_app/Activities/LogInPage.dart';
import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleBLoC.dart';
import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleEvent.dart';
import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemBLoC.dart';
import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemEvent.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/IllnessDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardinguserillnessDao.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/CustomWidgets/CustomTitleView.dart';
import 'package:dating_app/UI/Presentation/OnBoardingOptions/OnBoardingUserIllnessOption.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/UI/Presentation/dialogs/AddNewIllnessDialog.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/tabs/index.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:after_layout/after_layout.dart';
import 'package:moor_flutter/moor_flutter.dart' as flutterMoor;

class I_Have_A_Chronic_Illness_OB_Page extends StatefulWidget {
  KeyBoardVisibleBLoC keyBoardVisibleBLoC;
  Onboarding onboarding;
  IntindexCallback functionOnBoardingChanged;
  OnBoardingClickableItemBLoC
      recentOnBoardingChangedOnBoardingClickableItemBLoC;

  I_Have_A_Chronic_Illness_OB_Page(
      {Key key,
      @required this.keyBoardVisibleBLoC,
      @required this.onboarding,
      this.functionOnBoardingChanged,
      this.recentOnBoardingChangedOnBoardingClickableItemBLoC})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OB_Page6State();
  }
}

class _OB_Page6State extends State<I_Have_A_Chronic_Illness_OB_Page>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<I_Have_A_Chronic_Illness_OB_Page>,
        AfterLayoutMixin<I_Have_A_Chronic_Illness_OB_Page> {
  final GlobalKey<FormState> _suformKey = GlobalKey<FormState>();

  List<Widget> optionsDynamic = [];
  AppDatabase database;
  IllnessDao illnessDao;
  OnboardingDao onboardingDao;
  OnboardinguserillnessDao onboardinguserillnessDao;
  OnBoardingClickableItemBLoC onBoardingClickableItemBLoC =
      OnBoardingClickableItemBLoC();
  OnBoardingClickableItemBLoC recentOnBoardingForwardClickableItemBLoC =
      OnBoardingClickableItemBLoC();
  AnimationController animationController;
  int _havechronic_desease_RadioValue = -1;
  NavigationDataBLoC _if_has_chronic_illness_NavigationDataBLoC =
      NavigationDataBLoC();
  bool _autoValidate = false;
  BuildContext snackBarBuildContext;
  NavigationDataBLoC illnesssAddedNavigationDataBLoC = NavigationDataBLoC();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    KeyboardVisibility.onChange.listen(
      (bool visible) {
        print('afterFirstLayout keyboard visible OB3 ${visible}');
        widget.keyBoardVisibleBLoC.keyboard_visible_event_sink
            .add(ToggleKeyBoardVisEvent(visible));
      },
    );
    initDbVariables(context);
    initUI();
    addListeners();
  }

  initDbVariables(BuildContext context) {
    database = Provider.of<AppDatabase>(context);
    onboardingDao = database.onboardingDao;
    illnessDao = database.illnessDao;
    onboardinguserillnessDao = database.onboardinguserillnessDao;
  }

  addListeners() {
    widget.recentOnBoardingChangedOnBoardingClickableItemBLoC.stream_counter
        .listen((value) {
      refreshOnBoarding();
    });

    illnesssAddedNavigationDataBLoC.stream_counter.listen((value) async {
      NavigationData navigationData = value;
      if (navigationData != null) {
        if (navigationData.isAdded != null) {
          if (navigationData.isAdded) {
            if (navigationData.illness != null) {
              addToOnBoardingUserIllnessOption(navigationData.illness);
            }
          }
        }
      }
    });
  }

  addToOnBoardingUserIllnessOption(Illness newillness) {
    String TAG = 'addToOnBoardingUserIllnessOption:';
    print(TAG);
    optionsDynamic = [];
    illnessDao.getActiveIllnessList().then((List<Illness> illnessList) async {
      if (illnessList != null) {
        for (Illness illness in illnessList) {
          optionsDynamic.add(new FutureBuilder(
              future: onboardinguserillnessDao.isIllnessInOnBoardingById(
                  illness.id, widget.onboarding.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return invisibleWidget();
                } else {
                  return new OnBoardingUserIllnessOption(
                    isSelected: snapshot.data,
                    isSelectable: true,
                    onboarding: widget.onboarding,
                    onboardingDao: onboardingDao,
                    onboardinguserillnessDao: onboardinguserillnessDao,
                    illness: illness,
                    onItemClick: functionOnDoYouSmokeItemClick,
                    onBoardingClickableItemBLoC: onBoardingClickableItemBLoC,
                    recentOnBoardingForwardClickableItemBLoC:
                        recentOnBoardingForwardClickableItemBLoC,
                  );
                }
              }));
        }
        setState(() {});
      } else {}
    }, onError: (error) {
      print('error== ${error}');
    });
  }

  refreshOnBoarding() async {
    Onboarding updatedOnboarding =
        await onboardingDao.getOnboardingById(widget.onboarding.id);
    widget.onboarding = updatedOnboarding;
    refresh_recentOnBoardingForwardClickableItemBLoC();
  }

  refresh_recentOnBoardingForwardClickableItemBLoC() {
    recentOnBoardingForwardClickableItemBLoC.onboarding_itemclicked_event_sink
        .add(OneItemClickedEvent(1));
  }

  //STATE CHANGES
  refresh_if_has_chronic_illness_NavigationDataBLoC() {
    refresh_WO_Data_NavigationDataBLoC(
        _if_has_chronic_illness_NavigationDataBLoC);
  }
  //END OF STATE CHANGES

  initUI() async {
    refreshRecentOnBoarding();
    illnessDao.getActiveIllnessList().then((List<Illness> illnessList) async {
      if (illnessList != null) {
        for (Illness illness in illnessList) {
          optionsDynamic.add(new FutureBuilder(
              future: onboardinguserillnessDao.isIllnessInOnBoardingById(
                  illness.id, widget.onboarding.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return invisibleWidget();
                } else {
                  return new OnBoardingUserIllnessOption(
                    isSelected: snapshot.data,
                    isSelectable: true,
                    onboarding: widget.onboarding,
                    onboardingDao: onboardingDao,
                    onboardinguserillnessDao: onboardinguserillnessDao,
                    illness: illness,
                    onItemClick: functionOnDoYouSmokeItemClick,
                    onBoardingClickableItemBLoC: onBoardingClickableItemBLoC,
                    recentOnBoardingForwardClickableItemBLoC:
                        recentOnBoardingForwardClickableItemBLoC,
                  );
                }
              }));
        }
        setState(() {});
      } else {}
    }, onError: (error) {
      print('error== ${error}');
    });
  }

  get_ActiveIllness_AddTo_Widget_List() {
    optionsDynamic = [];
    illnessDao.getActiveIllnessList().then((List<Illness> illnessList) async {
      if (illnessList != null) {
        for (Illness illness in illnessList) {
          optionsDynamic.add(new FutureBuilder(
              future: onboardinguserillnessDao.isIllnessInOnBoardingById(
                  illness.id, widget.onboarding.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return invisibleWidget();
                } else {
                  return new OnBoardingUserIllnessOption(
                    isSelected: snapshot.data,
                    isSelectable: true,
                    onboarding: widget.onboarding,
                    onboardingDao: onboardingDao,
                    onboardinguserillnessDao: onboardinguserillnessDao,
                    illness: illness,
                    onItemClick: functionOnDoYouSmokeItemClick,
                    onBoardingClickableItemBLoC: onBoardingClickableItemBLoC,
                    recentOnBoardingForwardClickableItemBLoC:
                        recentOnBoardingForwardClickableItemBLoC,
                  );
                }
              }));
        }
        setState(() {});
      } else {}
    }, onError: (error) {
      print('error== ${error}');
    });
  }

  refreshRecentOnBoarding() async {
    Onboarding updatedOnboarding =
        await onboardingDao.getOnboardingById(widget.onboarding.id);
    widget.onboarding = updatedOnboarding;
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
    animationController.forward();
    return Scaffold(
      body: Consumer<DatingAppThemeChanger>(
        builder: (context, datingAppThemeChanger, child) {
          snackBarBuildContext = context;
          return SingleChildScrollView(
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: datingAppThemeChanger.selectedThemeData.sm_bg_background,
                child: Builder(
                  builder: (BuildContext context) => Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(height: 60),
                        CustomTitleView(
                          titleTxt: 'I have a chronic illness',
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
                              'assets/onb/onboarding0.png',
                            ),
                            height: 300.0,
                            width: 300.0,
                          ),
                        ),
                        Expanded(
                          child:
                             SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: 30.0,
                                  left: 30.0,
                                ),
                                child: new Form(
                                  key: _suformKey,
                                  autovalidate: _autoValidate,
                                  child: StreamBuilder(
                                      stream:
                                          _if_has_chronic_illness_NavigationDataBLoC
                                              .stream_counter,
                                      builder: (context,
                                          safety_officer_approval_snapshot) {
                                        return Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Theme(
                                                  data: ThemeData(
                                                    /*unselectedWidgetColor:
                                                        datingAppThemeChanger
                                                            .selectedThemeData
                                                            .cl_white_grey,
                                                    disabledColor:
                                                        datingAppThemeChanger
                                                            .selectedThemeData
                                                            .cl_real_grey_grey_Disabled,*/
                                                    unselectedWidgetColor:
                                                        datingAppThemeChanger
                                                            .selectedThemeData
                                                            .cl_grey_op_06,
                                                    disabledColor:
                                                        datingAppThemeChanger
                                                            .selectedThemeData
                                                            .cl_grey_op_06,
                                                  ),
                                                  child: Radio(
                                                    value: 1,
                                                    /*activeColor: DatingAppTheme
                                                        .colorAdrianBlue,*/
                                                    activeColor:
                                                        datingAppThemeChanger
                                                            .selectedThemeData
                                                            .cl_cont_Sel_ClickableItem,
                                                    groupValue:
                                                        _havechronic_desease_RadioValue,
                                                    onChanged:
                                                        _havechronic_desease_RadioValueChange,
                                                  ),
                                                ),
                                                Text(
                                                  'Yes',
                                                  style: datingAppThemeChanger
                                                      .selectedThemeData
                                                      .txt_stl_whitegrey_14_Med,
                                                ),
                                                Theme(
                                                  data: ThemeData(
                                                    /*unselectedWidgetColor:
                                                        datingAppThemeChanger
                                                            .selectedThemeData
                                                            .cl_white_grey,
                                                    disabledColor:
                                                        datingAppThemeChanger
                                                            .selectedThemeData
                                                            .cl_real_grey_grey_Disabled,*/
                                                    unselectedWidgetColor:
                                                        datingAppThemeChanger
                                                            .selectedThemeData
                                                            .cl_grey_op_06,
                                                    disabledColor:
                                                        datingAppThemeChanger
                                                            .selectedThemeData
                                                            .cl_grey_op_06,
                                                  ),
                                                  child: Radio(
                                                    value: 0,
                                                    activeColor:
                                                        datingAppThemeChanger
                                                            .selectedThemeData
                                                            .cl_cont_Sel_ClickableItem,
                                                    groupValue:
                                                        _havechronic_desease_RadioValue,
                                                    onChanged:
                                                        _havechronic_desease_RadioValueChange,
                                                  ),
                                                ),
                                                Text(
                                                  'No',
                                                  style: datingAppThemeChanger
                                                      .selectedThemeData
                                                      .txt_stl_whitegrey_14_Med,
                                                ),
                                              ],
                                            ),
                                            Opacity(
                                              opacity:
                                                  ((_havechronic_desease_RadioValue ==
                                                          1
                                                      ? 1
                                                      : 0)),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: optionsDynamic,
                                              ),
                                            ),
                                            Opacity(
                                              opacity:
                                                  ((_havechronic_desease_RadioValue ==
                                                          1
                                                      ? 1
                                                      : 0)),
                                              child: Padding(
                                                padding:  EdgeInsets.only(
                                                    left: 0.0,bottom: 50),
                                                child: new Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      print('FAB CLICKED');
                                                      addNewIllness();
                                                    },
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(43.0),
                                                    ),
                                                    splashColor:
                                                        DatingAppTheme.grey,
                                                    child: Container(
                                                      width: 43,
                                                      height: 43,
                                                      decoration: BoxDecoration(
                                                        color: DatingAppTheme
                                                            .white
                                                            .withOpacity(0.8),
                                                        shape: BoxShape.circle,
                                                        boxShadow: <BoxShadow>[
                                                          BoxShadow(
                                                              color: DatingAppTheme
                                                                  .nearlyBlack
                                                                  .withOpacity(
                                                                      0.4),
                                                              offset: Offset(
                                                                  8.0, 8.0),
                                                              blurRadius: 8.0),
                                                        ],
                                                      ),
                                                      child: Center(
                                                          child: Icon(
                                                        Icons.add,
                                                        size: 30,
                                                        color: datingAppThemeChanger
                                                            .selectedThemeData
                                                            .cl_cont_Sel_ClickableItem,
                                                      )),
                                                      //),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                          ],
                                        );
                                      }),
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

  _havechronic_desease_RadioValueChange(int value) async {
    _havechronic_desease_RadioValue = value;
    if (_havechronic_desease_RadioValue == 0) {
      //NO
      //DELETE ALL SELECTED
      List<Onboardinguserillness> onboardinguserillnessList =
          await onboardinguserillnessDao.getAllOnboardinguserillnesss();
      onboardinguserillnessDao
          .deleteAllOnboardinguserillnesssFuture(onboardinguserillnessList);
      get_ActiveIllness_AddTo_Widget_List();
      refresh_if_has_chronic_illness_NavigationDataBLoC();
      updateOnBoarding(false);
    } else {
      //YES

      refresh_if_has_chronic_illness_NavigationDataBLoC();
      updateOnBoarding(true);
    }
  }

  updateOnBoarding(bool have_chronic_illness) async {
    Onboarding tosaveOnboarding =
        await onboardingDao.getOnboardingById(widget.onboarding.id);
    bool updated = await onboardingDao
        .updateOnboarding(tosaveOnboarding.toCompanion(false).copyWith(
              have_chronic_illness: flutterMoor.Value(have_chronic_illness),
            ));
    if (updated) {
      Onboarding updatedOnboarding =
          await onboardingDao.getOnboardingById(widget.onboarding.id);
      widget.onboarding = updatedOnboarding;
      widget.functionOnBoardingChanged(widget.onboarding);
    }
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

  void functionOnDoYouSmokeItemClick(Onboarding onboarding) {
    setState(() {
      widget.onboarding = onboarding;
    });
    widget.functionOnBoardingChanged(widget.onboarding);
  }

  //ADD NEW ILLNESS
  addNewIllness() {
    Illness illness = new Illness();
    showGeneralDialog(
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: null,
        transitionDuration: Duration(milliseconds: 150),
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return new AddNewIllnessDialog(
            snackbarBuildContext: snackBarBuildContext,
            animationController: animationController,
            illness: illness,
            illnesssAddedNavigationDataBLoC: illnesssAddedNavigationDataBLoC,
          );
        });
  }
  //END OF ADD NEW ILLNESS
}

typedef IntindexCallback = void Function(Onboarding onboarding);
