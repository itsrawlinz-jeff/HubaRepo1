import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemBLoC.dart';
import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemEvent.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataEvent.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingmoneyshemakeDao.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:moor_flutter/moor_flutter.dart' as flutterMoor;
import 'package:provider/provider.dart';

class OnBoardingMoneySheShouldMakeOption extends StatefulWidget {
  OnBoardingMoneySheShouldMakeOption({
    Key key,
    this.isSelected,
    this.isSelectable,
    this.incomerange,
    this.onboarding,
    this.onboardingDao,
    this.onItemClick,
    this.onBoardingClickableItemBLoC,
    this.onboardingmoneyshemakeDao,
    this.recentOnBoardingForwardClickableItemBLoC,
  }) : super(key: key);
  bool isSelected;
  bool isSelectable;
  Incomerange incomerange;
  Onboarding onboarding;
  OnboardingDao onboardingDao;
  IntindexCallback onItemClick;
  OnBoardingClickableItemBLoC onBoardingClickableItemBLoC;
  OnboardingmoneyshemakeDao onboardingmoneyshemakeDao;
  OnBoardingClickableItemBLoC recentOnBoardingForwardClickableItemBLoC;

  @override
  _OnBoardingMoneySheShouldMakeOptionState createState() =>
      new _OnBoardingMoneySheShouldMakeOptionState();
}

class _OnBoardingMoneySheShouldMakeOptionState
    extends State<OnBoardingMoneySheShouldMakeOption>
    with AfterLayoutMixin<OnBoardingMoneySheShouldMakeOption> {
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
      refreshIncomerange();
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
    /*return FutureBuilder(
        future: isIncomerangeSelectedInOnBoardingById(
            widget.incomerange.id, widget.onboarding.id),
        initialData: false,
        builder: (context, snapshot) {*/
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: mainContainerItemStreamBuilder(
              datingAppThemeChanger), /*Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: snapshot.data,
              activeColor: Color(0xFFF8BBD0),
              onChanged: (bool value) {
                widget.isSelectable ? updateOnBoarding() : onTapDoNothing();
              },
            ),
          ),
          Text(
            widget.incomerange.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontFamily: "GothamRounded-Medium",
            ),
          ),
        ],
      ),*/
        );
      },
    );
    /*  });*/
  }

  Widget mainContainerItemStreamBuilder(
      DatingAppThemeChanger datingAppThemeChanger) {
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
  }

  Widget mainContainerItem(DatingAppThemeChanger datingAppThemeChanger) {
    return Row(
      children: <Widget>[
        Theme(
          data: ThemeData(
              unselectedWidgetColor: datingAppThemeChanger
                  .selectedThemeData.cl_Checkbox_Item //Colors.white
              ),
          child: Checkbox(
            value: widget.isSelected,
            activeColor: datingAppThemeChanger.selectedThemeData
                .cl_cont_Sel_ClickableItem, //Color(0xFFF8BBD0),
            onChanged: (bool value) {
              widget.isSelectable ? updateOnBoarding() : onTapDoNothing();
            },
          ),
        ),
        Text(
          widget.incomerange.name,
          style: datingAppThemeChanger
              .selectedThemeData.default_UnSel_ClickableItem_TextStyle,
          /*style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "GothamRounded-Medium",
          ),*/
        ),
      ],
    );
  }

  updateOnBoarding() async {
    if (widget.isSelected) {
      //widget.isSelected = false;

      //UNSELECT-DELETE
      Onboardingmoneyshemake onboardingmoneyshemake =
          await widget.onboardingmoneyshemakeDao.getIncomeRangeInOnBoardingById(
              widget.incomerange.id, widget.onboarding.id);

      if (onboardingmoneyshemake != null) {
        int deletedonboardingmoneyshemake = await widget
            .onboardingmoneyshemakeDao
            .deleteOnboardingmoneyshemake(onboardingmoneyshemake);
      }
      widget.onBoardingClickableItemBLoC.onboarding_itemclicked_event_sink
          .add(OneItemClickedEvent(widget.incomerange.id));
    } else {
      //widget.isSelected = true;
      //SELECT-INSERT
      Onboardingmoneyshemake onboardingmoneyshemake =
          await widget.onboardingmoneyshemakeDao.getIncomeRangeInOnBoardingById(
              widget.incomerange.id, widget.onboarding.id);

      if (onboardingmoneyshemake != null) {
        bool isUpdated = await widget.onboardingmoneyshemakeDao
            .updateOnboardingmoneyshemake(onboardingmoneyshemake
                .toCompanion(false)
                .copyWith(
                    onboarding: flutterMoor.Value(widget.onboarding.id),
                    incomeRange: flutterMoor.Value(widget.incomerange.id)));
      } else {
        //CREATE AND INSERT
        OnboardingmoneyshemakesCompanion onboardingmoneyshemakesCompanion =
            new OnboardingmoneyshemakesCompanion(
                onboarding: flutterMoor.Value(widget.onboarding.id),
                incomeRange: flutterMoor.Value(widget.incomerange.id));
        int insertedId = await widget.onboardingmoneyshemakeDao
            .insertOnboardingmoneyshemake(onboardingmoneyshemakesCompanion);
      }
      widget.onBoardingClickableItemBLoC.onboarding_itemclicked_event_sink
          .add(OneItemClickedEvent(widget.incomerange.id));
    }
  }

  onTapDoNothing() {
    print('chip clicked');
  }

/*  refreshIncomerange() async {
    bool isSelected = await isIncomerangeSelectedInOnBoardingById(
        widget.incomerange.id, widget.onboarding.id);
    setState(() {
      if (isSelected) {
        widget.isSelected = true;
      } else {
        widget.isSelected = false;
      }
    });
    widget.onItemClick(widget.onboarding);
  }*/

  refreshIncomerange() async {
    bool isSelected = await widget.onboardingmoneyshemakeDao
        .isIncomeRangeInOnBoardingById(
            widget.incomerange.id, widget.onboarding.id);
    widget.isSelected = isSelected;
    onselectNavigationDataBLoC.dailySubTaskimages_event_sink
        .add(NavigationDataAddedEvent(NavigationData()));
  }

/*  refreshRecentOnBoarding() async {
    Onboarding updatedOnboarding =
        await widget.onboardingDao.getOnboardingById(widget.onboarding.id);
    setState(() {
      widget.onboarding = updatedOnboarding;
    });
  }*/
  refreshRecentOnBoarding() async {
    Onboarding updatedOnboarding =
        await widget.onboardingDao.getOnboardingById(widget.onboarding.id);
    widget.onboarding = updatedOnboarding;
  }

/*  Future<bool> isIncomerangeSelectedInOnBoardingById(
      int incomerangeId, int onboardingId) async {
    return await widget.onboardingmoneyshemakeDao
        .isIncomeRangeInOnBoardingById(incomerangeId, onboardingId)
        .then((onValue) {
      return onValue;
    }, onError: (error) {
      return false;
    });
  }*/
}

typedef IntindexCallback = void Function(Onboarding onboarding);
