import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleBLoC.dart';
import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleEvent.dart';
import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemBLoC.dart';
import 'package:dating_app/Bloc/Streams/RegistrationPage/PageDraggerBLoC.dart';
import 'package:dating_app/Bloc/Streams/RegistrationPage/PageDraggerEvent.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingDao.dart';
import 'package:dating_app/UI/Presentation/CustomWidgets/CustomTitleView.dart';
import 'package:dating_app/UI/Presentation/ExpandedBubbleChip/ExpandedBubbleChip.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:flutter/material.dart';import 'package:dating_app/utils/data_validators.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:after_layout/after_layout.dart';
import 'package:moor_flutter/moor_flutter.dart' as flutterMoor;

class Her_Age_OB_Page extends StatefulWidget {
  KeyBoardVisibleBLoC keyBoardVisibleBLoC;
  PageDraggerBLoC pageDraggerBLoC;
  Onboarding onboarding;
  IntindexCallback functionOnBoardingChanged;
  OnBoardingClickableItemBLoC
      recentOnBoardingChangedOnBoardingClickableItemBLoC;

  Her_Age_OB_Page({
    Key key,
    @required this.keyBoardVisibleBLoC,
    @required this.pageDraggerBLoC,
    @required this.onboarding,
    this.functionOnBoardingChanged,
    this.recentOnBoardingChangedOnBoardingClickableItemBLoC,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OB_Page6State();
  }
}

class _OB_Page6State extends State<Her_Age_OB_Page>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<Her_Age_OB_Page>,
        AfterLayoutMixin<Her_Age_OB_Page> {
  bool _autoValidate = false;
  final GlobalKey<FormState> _suformKey = GlobalKey<FormState>();

  var _rvalues = new RangeValues(18, 100);
  var database;
  OnboardingDao onboardingDao;
  String TAG = 'Her_Age_OB_Page:';
  AnimationController animationController;

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
  }

  initUI() async {
    database = Provider.of<AppDatabase>(context);
    onboardingDao = database.onboardingDao;
    //await refreshRecentOnBoarding();
    refreshRecentOnBoarding();
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

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return Scaffold(
      body: Consumer<DatingAppThemeChanger>(
        builder: (context, datingAppThemeChanger, child) {
          return SingleChildScrollView(
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: datingAppThemeChanger.selectedThemeData.sm_bg_background,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 60),
                        CustomTitleView(
                          titleTxt: 'Her Age?',
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
                        SizedBox(height: 10.0),
                        /*Transform(
                          transform: Matrix4.translationValues(
                              0.0, 30.0 * (1.0 - 1.0), 0.0),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 0.0, bottom: 10.0, left: 20, right: 20),
                            child: Center(
                              child: Text(
                                'Her Age?',
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
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 45),
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
                                    children: <Widget>[
                                      SizedBox(
                                        height: 80,
                                        child: RangeSlider(
                                            //activeColor: Color(0xFFF8BBD0),
                                            //inactiveColor: Color(0xFFF8BBD0),
                                          activeColor: datingAppThemeChanger.selectedThemeData.cl_cont_Sel_ClickableItem,
                                          inactiveColor: datingAppThemeChanger.selectedThemeData.cl_cont_Sel_ClickableItem,
                                            values: _rvalues,
                                            min: 18,
                                            max: 100,
                                            onChangeStart:
                                                (RangeValues values) {
                                              widget.pageDraggerBLoC
                                                  .enableDrag_sink
                                                  .add(IfDragPageEvent(false));
                                            },
                                            onChangeEnd: (RangeValues values) {
                                              widget.pageDraggerBLoC
                                                  .enableDrag_sink
                                                  .add(IfDragPageEvent(true));

                                              updateOnBoarding(_rvalues);
                                            },
                                            //min: 0,
                                            onChanged: (RangeValues values) {
                                              setState(() {
                                                _rvalues = values;
                                              });
                                            }),
                                      ),
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: Row(
                                          children: <Widget>[
                                            ExpandedBubbleChip(
                                              isSelectable: false,
                                              isSelected: false,
                                              title:
                                                  '${_rvalues.start.toInt()} - ${_rvalues.end.toInt()}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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

  updateOnBoarding(RangeValues rangeValues) async {
    Onboarding qryOnboarding =
        await onboardingDao.getOnboardingById(widget.onboarding.id);
    bool updated = await onboardingDao.updateOnboarding(qryOnboarding
        .toCompanion(false)
        .copyWith(
            herage_high: flutterMoor.Value(rangeValues.end.toInt()),
            herage_low: flutterMoor.Value(rangeValues.start.toInt())));
    if (updated) {
      Onboarding updatedOnboarding =
          await onboardingDao.getOnboardingById(widget.onboarding.id);
      setState(() {
        widget.onboarding = updatedOnboarding;
      });
    }
    widget.functionOnBoardingChanged(widget.onboarding);
  }
}

typedef IntindexCallback = void Function(Onboarding onboarding);
