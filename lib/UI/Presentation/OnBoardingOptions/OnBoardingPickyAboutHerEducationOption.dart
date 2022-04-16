import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemBLoC.dart';
import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemEvent.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataEvent.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingDao.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:provider/provider.dart';

class OnBoardingPickyAboutHerEducationOption extends StatefulWidget {
  OnBoardingPickyAboutHerEducationOption(
      {Key key,
      this.isSelected,
      this.isSelectable,
      this.educationlevel,
      this.onboarding,
      this.onboardingDao,
      this.onItemClick,
      this.onBoardingClickableItemBLoC,
      this.recentOnBoardingForwardClickableItemBLoC,
      this.database})
      : super(key: key);
  bool isSelected;
  bool isSelectable;
  Educationlevel educationlevel;
  Onboarding onboarding;
  OnboardingDao onboardingDao;
  IntindexCallback onItemClick;
  NavigationDataBLoC onBoardingClickableItemBLoC;
  NavigationDataBLoC recentOnBoardingForwardClickableItemBLoC;
  AppDatabase database;

  @override
  _OnBoardingPickyAboutHerEducationOptionState createState() =>
      new _OnBoardingPickyAboutHerEducationOptionState();
}

class _OnBoardingPickyAboutHerEducationOptionState
    extends State<OnBoardingPickyAboutHerEducationOption>
    with AfterLayoutMixin<OnBoardingPickyAboutHerEducationOption> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    addItemsClickedListener();
  }

  addItemsClickedListener() {
    widget.onBoardingClickableItemBLoC.stream_counter.listen((value) {
      NavigationData navigationData = value;
      if (navigationData != null &&
          navigationData.onboarding != null &&
          (widget.educationlevel.id !=
              navigationData.onboarding.picky_abt_her_education)) {
        setState(() {
          widget.onboarding = navigationData.onboarding;
          if (widget.educationlevel.id ==
              widget.onboarding.picky_abt_her_education) {
            widget.isSelected = true;
          } else {
            widget.isSelected = false;
          }
        });
      }
      //refreshOnBoarding();
    });
    widget.recentOnBoardingForwardClickableItemBLoC.stream_counter
        .listen((value) {
      NavigationData navigationData = value;
      if (navigationData != null && navigationData.onboarding != null) {
        widget.onboarding = navigationData.onboarding;
      }
      //refreshRecentOnBoarding();
    });
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.only(
      topRight: Radius.circular(10.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(10.0),
      topLeft: Radius.circular(10.0),
    );
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: <Widget>[
              Theme(
                data: ThemeData(
                    unselectedWidgetColor: datingAppThemeChanger
                        .selectedThemeData.cl_Checkbox_Item //Colors.white
                    ),
                child: Checkbox(
                  value: widget.educationlevel.id ==
                      widget.onboarding.picky_abt_her_education,
                  //activeColor: Color(0xFFF8BBD0),
                  activeColor: datingAppThemeChanger
                      .selectedThemeData.cl_cont_Sel_ClickableItem,
                  onChanged: (bool value) {
                    widget.isSelectable ? updateOnBoarding() : onTapDoNothing();
                  },
                ),
              ),
              Text(
                widget.educationlevel.name,
                //widget.educationlevel.name,
                /*style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontFamily: "GothamRounded-Medium",
                ),*/
                style: datingAppThemeChanger
                    .selectedThemeData.default_UnSel_ClickableItem_TextStyle,
              ),
            ],
          ),
        );
      },
    );
  }

  updateOnBoarding() async {
    if (widget.isSelected) {
      //UNSELECT
      widget.isSelected = false;

      /*bool updated = await widget.onboardingDao.updateOnboarding(widget
          .onboarding
          .toCompanion(false)
          .copyWith(picky_abt_her_education: Value(null)));*/

      OnboardingsCompanion onboardingsCompanion = widget.onboarding
          .toCompanion(false)
          .copyWith(picky_abt_her_education: Value(null));

      setState(() {
        widget.onboarding =
            widget.database.onboardings.mapFromCompanion(onboardingsCompanion);
      });

      bool updated =
          await widget.onboardingDao.updateOnboarding(widget.onboarding);

      /*if (updated) {
        Onboarding updatedOnboarding =
            await widget.onboardingDao.getOnboardingById(widget.onboarding.id);
        setState(() {
          widget.onboarding = updatedOnboarding;
        });
      }*/
      /*widget.onBoardingClickableItemBLoC.onboarding_itemclicked_event_sink
          .add(OneItemClickedEvent(widget.educationlevel.id));*/
      refresh_onBoardingClickableItemBLoC();
      widget.onItemClick(widget.onboarding);
    } else {
      //SELECT
      widget.isSelected = true;

      /*bool updated = await widget.onboardingDao.updateOnboarding(widget
          .onboarding
          .toCompanion(false)
          .copyWith(picky_abt_her_education: Value(widget.educationlevel.id)));*/

      OnboardingsCompanion onboardingsCompanion = widget.onboarding
          .toCompanion(false)
          .copyWith(picky_abt_her_education: Value(widget.educationlevel.id));

      setState(() {
        widget.onboarding =
            widget.database.onboardings.mapFromCompanion(onboardingsCompanion);
      });

      bool updated =
          await widget.onboardingDao.updateOnboarding(widget.onboarding);

      /*if (updated) {
        Onboarding updatedOnboarding =
            await widget.onboardingDao.getOnboardingById(widget.onboarding.id);
        setState(() {
          widget.onboarding = updatedOnboarding;
        });
      }*/
      /* widget.onBoardingClickableItemBLoC.onboarding_itemclicked_event_sink
          .add(OneItemClickedEvent(widget.educationlevel.id));*/
      refresh_onBoardingClickableItemBLoC();
      widget.onItemClick(widget.onboarding);
    }
  }

  refreshOnBoarding() async {
    String TAG = 'refreshOnBoarding:';
    print(TAG);
    Onboarding updatedOnboarding =
        await widget.onboardingDao.getOnboardingById(widget.onboarding.id);
    setState(() {
      widget.onboarding = updatedOnboarding;
      if (widget.educationlevel.id ==
          widget.onboarding.picky_abt_her_education) {
        widget.isSelected = true;
      } else {
        widget.isSelected = false;
      }
    });
    widget.onItemClick(widget.onboarding);
  }

  /* refreshRecentOnBoarding() async {
    Onboarding updatedOnboarding =
        await widget.onboardingDao.getOnboardingById(widget.onboarding.id);
    //setState(() {
    widget.onboarding = updatedOnboarding;
    //});
  }*/

  onTapDoNothing() {
    print('chip clicked');
  }

  refresh_onBoardingClickableItemBLoC() {
    NavigationData navigationData = NavigationData();
    navigationData.onboarding = widget.onboarding;
    widget.onBoardingClickableItemBLoC.dailySubTaskimages_event_sink
        .add(NavigationDataAddedEvent(navigationData));
  }
}

typedef IntindexCallback = void Function(Onboarding onboarding);
