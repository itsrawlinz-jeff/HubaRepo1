import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemBLoC.dart';
import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemEvent.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataEvent.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingsomethingspecificDao.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:moor_flutter/moor_flutter.dart' as flutterMoor;
import 'package:provider/provider.dart';

class OnBoardingSomethingSpecificOption extends StatefulWidget {
  OnBoardingSomethingSpecificOption({
    Key key,
    this.isSelected,
    this.isSelectable,
    this.somethingspecific,
    this.onboarding,
    this.onboardingDao,
    this.onItemClick,
    this.onBoardingClickableItemBLoC,
    this.onboardingsomethingspecificDao,
    this.recentOnBoardingForwardClickableItemBLoC,
  }) : super(key: key);
  bool isSelected;
  bool isSelectable;
  Somethingspecific somethingspecific;
  Onboarding onboarding;
  OnboardingDao onboardingDao;
  IntindexCallback onItemClick;
  OnBoardingClickableItemBLoC onBoardingClickableItemBLoC;
  OnboardingsomethingspecificDao onboardingsomethingspecificDao;
  OnBoardingClickableItemBLoC recentOnBoardingForwardClickableItemBLoC;

  @override
  _OnBoardingSomethingSpecificOptionState createState() =>
      new _OnBoardingSomethingSpecificOptionState();
}

class _OnBoardingSomethingSpecificOptionState
    extends State<OnBoardingSomethingSpecificOption>
    with AfterLayoutMixin<OnBoardingSomethingSpecificOption> {
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
      refreshSomethingSpecific();
    });
    widget.recentOnBoardingForwardClickableItemBLoC.stream_counter
        .listen((value) {
      refreshRecentOnBoarding();
    });
  }

  @override
  Widget build(BuildContext context) {
    /* return FutureBuilder(
        future: isSomethingspecificSelectedInOnBoardingById(
            widget.somethingspecific.id, widget.onboarding.id),
        builder: (context, snapshot) {*/
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return InkWell(
          splashColor: Colors.white24,
          onTap: () {
            print('AM TAPPED');
            widget.isSelectable ? updateOnBoarding() : onTapDoNothing();
          },
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
          ),
          child: mainContainerItemStreamBuilder(datingAppThemeChanger),
        );
      },
    );
    /* });*/

    /*return InkWell(
      splashColor: Colors.white24,
      onTap: () {
        print('AM TAPPED');
        widget.isSelectable ? updateOnBoarding() : onTapDoNothing();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 1.0,
                    color:
                          isSomethingspecificSelectedInOnBoardingById(
                                widget.somethingspecific.id,
                                widget.onboarding.id) ==
                            true
                        //color: widget.somethingspecific.id == widget.onboarding.religion
                        ? Color(0xFFFFFFFF)
                        : Colors.black.withOpacity(.12))
              ],
              color: isSomethingspecificSelectedInOnBoardingById(
                          widget.somethingspecific.id, widget.onboarding.id) ==
                      true
                  // color: widget.somethingspecific.id == widget.onboarding.religion
                  ? Colors.pink
                  : Color(0xFFF8BBD0),
              borderRadius: radius,
            ),
            child: Stack(
              children: <Widget>[
                Text(
                  widget.somethingspecific.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: isSomethingspecificSelectedInOnBoardingById(
                                widget.somethingspecific.id,
                                widget.onboarding.id) ==
                            true
                        //color: widget.somethingspecific.id ==widget.onboarding.religion
                        ? Color(0xFFFFFFFF)
                        : Colors.pink,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );*/
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
    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              blurRadius: .5,
              spreadRadius: 1.0,
              /*color: widget.isSelected
                  ? Color(0xFFFFFFFF)
                  : Colors.black.withOpacity(.12))*/
              color: widget.isSelected
                  ? datingAppThemeChanger
                      .selectedThemeData.cl_cont_Sel_ClickableItem_Bshadow
                  : datingAppThemeChanger
                      .selectedThemeData.cl_cont_UnSel_ClickableItem_Bshadow)
        ],
        color: widget.isSelected
            ? datingAppThemeChanger
                .selectedThemeData.cl_cont_Sel_ClickableItem //Colors.pink
            : datingAppThemeChanger.selectedThemeData
                .cl_cont_UnSel_ClickableItem, //Color(0xFFF8BBD0),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
          topLeft: Radius.circular(10.0),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Text(
            widget.somethingspecific.name,
            style: widget.isSelected
                ? datingAppThemeChanger
                    .selectedThemeData.default_Sel_ClickableItem_TextStyle
                : datingAppThemeChanger
                    .selectedThemeData.default_UnSel_ClickableItem_TextStyle,
            /*style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 0.27,
              color: widget.isSelected ? Color(0xFFFFFFFF) : Colors.pink,
            ),*/
          ),
        ],
      ),
    );
  }

  updateOnBoarding() async {
    if (widget.isSelected) {
      //widget.isSelected = false;

      //UNSELECT-DELETE
      Onboardingsomethingspecific onboardingsomethingspecific = await widget
          .onboardingsomethingspecificDao
          .getSomethingspecificInOnBoardingById(
              widget.somethingspecific.id, widget.onboarding.id);

      if (onboardingsomethingspecific != null) {
        int deletedonboardingsomethingspecific = await widget
            .onboardingsomethingspecificDao
            .deleteOnboardingsomethingspecific(onboardingsomethingspecific);
        print('deleted ${deletedonboardingsomethingspecific}');
      }
      widget.onBoardingClickableItemBLoC.onboarding_itemclicked_event_sink
          .add(OneItemClickedEvent(widget.somethingspecific.id));
    } else {
      //widget.isSelected = true;
      //SELECT-INSERT
      Onboardingsomethingspecific onboardingsomethingspecific = await widget
          .onboardingsomethingspecificDao
          .getSomethingspecificInOnBoardingById(
              widget.somethingspecific.id, widget.onboarding.id);

      if (onboardingsomethingspecific != null) {
        bool isUpdated = await widget.onboardingsomethingspecificDao
            .updateOnboardingsomethingspecific(onboardingsomethingspecific
                .toCompanion(false)
                .copyWith(
                    onboarding: flutterMoor.Value(widget.onboarding.id),
                    somethingspecifics:
                        flutterMoor.Value(widget.somethingspecific.id)));
      } else {
        //CREATE AND INSERT
        OnboardingsomethingspecificsCompanion
            onboardingsomethingspecificsCompanion =
            new OnboardingsomethingspecificsCompanion(
                onboarding: flutterMoor.Value(widget.onboarding.id),
                somethingspecifics:
                    flutterMoor.Value(widget.somethingspecific.id));
        int insertedId = await widget.onboardingsomethingspecificDao
            .insertOnboardingsomethingspecific(
                onboardingsomethingspecificsCompanion);
      }
      widget.onBoardingClickableItemBLoC.onboarding_itemclicked_event_sink
          .add(OneItemClickedEvent(widget.somethingspecific.id));
    }
  }

/*  refreshSomethingSpecific() async {
    */ /* Onboarding updatedOnboarding =
        await widget.onboardingDao.getOnboardingById(widget.onboarding.id);*/ /*
    */ /*bool isSelected = await isSomethingspecificSelectedInOnBoardingById(
        widget.somethingspecific.id, widget.onboarding.id);
    setState(() {
      //if (widget.somethingspecific.id == widget.onboarding.iam) {
      if (isSelected) {
        widget.isSelected = true;
      } else {
        widget.isSelected = false;
      }
    });*/ /*
    setState(() {});
    widget.onItemClick(widget.onboarding);
  }*/

  refreshSomethingSpecific() async {
    bool isSelected = await widget.onboardingsomethingspecificDao
        .isSomethingspecificInOnBoardingById(
            widget.somethingspecific.id, widget.onboarding.id);
    widget.isSelected = isSelected;
    onselectNavigationDataBLoC.dailySubTaskimages_event_sink
        .add(NavigationDataAddedEvent(NavigationData()));
    //widget.onItemClick(widget.onboarding);
  }

  refreshRecentOnBoarding() async {
    Onboarding updatedOnboarding =
        await widget.onboardingDao.getOnboardingById(widget.onboarding.id);
    widget.onboarding = updatedOnboarding;
  }

  onTapDoNothing() {
    print('chip clicked');
  }

  /* Future<bool> isSomethingspecificSelectedInOnBoardingById(
      int somethingspecificId, int onboardingId) async {
    return await widget.onboardingsomethingspecificDao
        .isSomethingspecificInOnBoardingById(somethingspecificId, onboardingId)
        .then((onValue) {
      return onValue;
    }, onError: (error) {
      return false;
    });
  }*/
}

typedef IntindexCallback = void Function(Onboarding onboarding);
