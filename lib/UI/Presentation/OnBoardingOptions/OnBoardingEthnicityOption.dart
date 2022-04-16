import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemBLoC.dart';
import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemEvent.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingDao.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:provider/provider.dart';

class OnBoardingEthnicityOption extends StatefulWidget {
  OnBoardingEthnicityOption({
    Key key,
    this.isSelected,
    this.isSelectable,
    this.ethnicitie,
    this.onboarding,
    this.onboardingDao,
    this.onItemClick,
    this.onBoardingClickableItemBLoC,
    this.recentOnBoardingForwardClickableItemBLoC,
  }) : super(key: key);
  bool isSelected;
  bool isSelectable;
  Ethnicitie ethnicitie;
  Onboarding onboarding;
  OnboardingDao onboardingDao;
  IntindexCallback onItemClick;
  OnBoardingClickableItemBLoC onBoardingClickableItemBLoC;
  OnBoardingClickableItemBLoC recentOnBoardingForwardClickableItemBLoC;

  @override
  _OnBoardingEthnicityOptionState createState() =>
      new _OnBoardingEthnicityOptionState();
}

class _OnBoardingEthnicityOptionState extends State<OnBoardingEthnicityOption>
    with AfterLayoutMixin<OnBoardingEthnicityOption> {
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
      refreshOnBoarding();
    });
    widget.recentOnBoardingForwardClickableItemBLoC.stream_counter
        .listen((value) {
      refreshRecentOnBoarding();
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
                  value: widget.ethnicitie.id == widget.onboarding.ethnicity,
                  //activeColor: Color(0xFFF8BBD0),
                  activeColor: datingAppThemeChanger.selectedThemeData
                      .cl_cont_Sel_ClickableItem, //Colors.pink
                  onChanged: (bool value) {
                    widget.isSelectable ? updateOnBoarding() : onTapDoNothing();
                  },
                ),
              ),
              Text(
                widget.ethnicitie.name,
                style: datingAppThemeChanger.selectedThemeData
                    .default_UnSel_ClickableItem_TextStyle, /*TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontFamily: "GothamRounded-Medium",
                ),*/
              ),
            ],
          ),
        );
      },
    );
  }

  updateOnBoarding() async {
    if (widget.isSelected) {
      widget.isSelected = false;

      bool updated = await widget.onboardingDao.updateOnboarding(widget
          .onboarding
          .toCompanion(false)
          .copyWith(ethnicity: Value(null)));
      /*if (updated) {
        Onboarding updatedOnboarding =
            await widget.onboardingDao.getOnboardingById(widget.onboarding.id);
        setState(() {
          widget.onboarding = updatedOnboarding;
        });
      }*/
      widget.onBoardingClickableItemBLoC.onboarding_itemclicked_event_sink
          .add(OneItemClickedEvent(widget.ethnicitie.id));
    } else {
      widget.isSelected = true;

      bool updated = await widget.onboardingDao.updateOnboarding(widget
          .onboarding
          .toCompanion(false)
          .copyWith(ethnicity: Value(widget.ethnicitie.id)));
      /*if (updated) {
        Onboarding updatedOnboarding =
            await widget.onboardingDao.getOnboardingById(widget.onboarding.id);
        setState(() {
          widget.onboarding = updatedOnboarding;
        });
      }*/
      widget.onBoardingClickableItemBLoC.onboarding_itemclicked_event_sink
          .add(OneItemClickedEvent(widget.ethnicitie.id));
    }
  }

  refreshOnBoarding() async {
    Onboarding updatedOnboarding =
        await widget.onboardingDao.getOnboardingById(widget.onboarding.id);
    setState(() {
      widget.onboarding = updatedOnboarding;
      if (widget.ethnicitie.id == widget.onboarding.ethnicity) {
        widget.isSelected = true;
      } else {
        widget.isSelected = false;
      }
    });
    widget.onItemClick(widget.onboarding);
  }

  refreshRecentOnBoarding() async {
    Onboarding updatedOnboarding =
        await widget.onboardingDao.getOnboardingById(widget.onboarding.id);
    //setState(() {
    widget.onboarding = updatedOnboarding;
    //});
  }

  onTapDoNothing() {
    print('chip clicked');
  }
}

typedef IntindexCallback = void Function(Onboarding onboarding);
