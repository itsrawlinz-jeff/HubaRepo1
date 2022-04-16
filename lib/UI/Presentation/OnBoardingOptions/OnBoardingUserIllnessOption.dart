import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemBLoC.dart';
import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemEvent.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataEvent.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardinguserillnessDao.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:moor_flutter/moor_flutter.dart' as flutterMoor;
import 'package:provider/provider.dart';

class OnBoardingUserIllnessOption extends StatefulWidget {
  OnBoardingUserIllnessOption({
    Key key,
    this.isSelected,
    this.isSelectable,
    this.illness,
    this.onboarding,
    this.onboardingDao,
    this.onItemClick,
    this.onBoardingClickableItemBLoC,
    this.onboardinguserillnessDao,
    this.recentOnBoardingForwardClickableItemBLoC,
  }) : super(key: key);
  bool isSelected;
  bool isSelectable;
  Illness illness;
  Onboarding onboarding;
  OnboardingDao onboardingDao;
  IntindexCallback onItemClick;
  OnBoardingClickableItemBLoC onBoardingClickableItemBLoC;
  OnboardinguserillnessDao onboardinguserillnessDao;
  OnBoardingClickableItemBLoC recentOnBoardingForwardClickableItemBLoC;

  @override
  _OnBoardingUserIllnessOptionState createState() =>
      new _OnBoardingUserIllnessOptionState();
}

class _OnBoardingUserIllnessOptionState
    extends State<OnBoardingUserIllnessOption>
    with AfterLayoutMixin<OnBoardingUserIllnessOption> {
  NavigationDataBLoC onselectNavigationDataBLoC = NavigationDataBLoC();

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
      refreshIllness();
    });
    widget.recentOnBoardingForwardClickableItemBLoC.stream_counter
        .listen((value) {
      refreshRecentOnBoarding();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return StreamBuilder(
          stream: onselectNavigationDataBLoC.stream_counter,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return mainContainerItem(datingAppThemeChanger);
            }
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return mainContainerItem(datingAppThemeChanger);
                break;
              case ConnectionState.waiting:
                return mainContainerItem(datingAppThemeChanger);
                break;
              case ConnectionState.active:
                return mainContainerItem(datingAppThemeChanger);
                break;
              case ConnectionState.done:
                return mainContainerItem(datingAppThemeChanger);
                break;
            }
          },
        );
      },
    );
  }

  Widget mainContainerItem(DatingAppThemeChanger datingAppThemeChanger) {
    return Row(
      children: <Widget>[
        Theme(
          data: ThemeData(
            unselectedWidgetColor:
                datingAppThemeChanger.selectedThemeData.cl_grey_op_06,
            disabledColor:
                datingAppThemeChanger.selectedThemeData.cl_grey_op_06,
          ),
          child: Checkbox(
            value: widget.isSelected,
            activeColor: datingAppThemeChanger
                .selectedThemeData.cl_cont_Sel_ClickableItem,
            checkColor: DatingAppTheme.white,
            onChanged: (bool value) {
              widget.isSelectable ? updateOnBoarding() : onTapDoNothing();
            },
          ),
        ),
        Text(
          widget.illness.name,
          style: datingAppThemeChanger
              .selectedThemeData.default_UnSel_ClickableItem_TextStyle,
        ),
      ],
    );
  }

  updateOnBoarding() async {
    if (widget.isSelected) {
      //UNSELECT-DELETE
      Onboardinguserillness onboardinguserillness = await widget
          .onboardinguserillnessDao
          .getIllnessInOnBoardingById(widget.illness.id, widget.onboarding.id);

      if (onboardinguserillness != null) {
        int deletedonboardinguserillness = await widget.onboardinguserillnessDao
            .deleteOnboardinguserillness(onboardinguserillness);
      }
      widget.onBoardingClickableItemBLoC.onboarding_itemclicked_event_sink
          .add(OneItemClickedEvent(widget.illness.id));
    } else {
      //SELECT-INSERT
      Onboardinguserillness onboardinguserillness = await widget
          .onboardinguserillnessDao
          .getIllnessInOnBoardingById(widget.illness.id, widget.onboarding.id);

      if (onboardinguserillness != null) {
        bool isUpdated = await widget.onboardinguserillnessDao
            .updateOnboardinguserillness(onboardinguserillness
                .toCompanion(false)
                .copyWith(
                    onboarding: flutterMoor.Value(widget.onboarding.id),
                    illness: flutterMoor.Value(widget.illness.id)));
      } else {
        //CREATE AND INSERT
        OnboardinguserillnesssCompanion onboardinguserillnesssCompanion =
            new OnboardinguserillnesssCompanion(
                onboarding: flutterMoor.Value(widget.onboarding.id),
                illness: flutterMoor.Value(widget.illness.id));
        int insertedId = await widget.onboardinguserillnessDao
            .insertOnboardinguserillness(onboardinguserillnesssCompanion);
      }
      widget.onBoardingClickableItemBLoC.onboarding_itemclicked_event_sink
          .add(OneItemClickedEvent(widget.illness.id));
    }
  }

  onTapDoNothing() {
    print('chip clicked');
  }

  refreshIllness() async {
    bool isSelected = await widget.onboardinguserillnessDao
        .isIllnessInOnBoardingById(widget.illness.id, widget.onboarding.id);
    widget.isSelected = isSelected;
    onselectNavigationDataBLoC.dailySubTaskimages_event_sink
        .add(NavigationDataAddedEvent(NavigationData()));
  }

  refreshRecentOnBoarding() async {
    Onboarding updatedOnboarding =
        await widget.onboardingDao.getOnboardingById(widget.onboarding.id);
    widget.onboarding = updatedOnboarding;
  }
}

typedef IntindexCallback = void Function(Onboarding onboarding);
