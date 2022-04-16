import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemBLoC.dart';
import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemEvent.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataEvent.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardinginterestDao.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:moor_flutter/moor_flutter.dart' as flutterMoor;
import 'package:provider/provider.dart';

class OnBoardingInterestsOption extends StatefulWidget {
  OnBoardingInterestsOption({
    Key key,
    this.isSelected,
    this.isSelectable,
    this.hobbie,
    this.onboarding,
    this.onboardingDao,
    this.onItemClick,
    this.onBoardingClickableItemBLoC,
    this.onboardinginterestDao,
    this.recentOnBoardingForwardClickableItemBLoC,
  }) : super(key: key);
  bool isSelected;
  bool isSelectable;
  Hobbie hobbie;
  Onboarding onboarding;
  OnboardingDao onboardingDao;
  IntindexCallback onItemClick;
  OnBoardingClickableItemBLoC onBoardingClickableItemBLoC;
  OnboardinginterestDao onboardinginterestDao;
  OnBoardingClickableItemBLoC recentOnBoardingForwardClickableItemBLoC;

  @override
  _OnBoardingInterestsOptionState createState() =>
      new _OnBoardingInterestsOptionState();
}

class _OnBoardingInterestsOptionState extends State<OnBoardingInterestsOption>
    with AfterLayoutMixin<OnBoardingInterestsOption> {
  NavigationDataBLoC onselectNavigationDataBLoC = NavigationDataBLoC();
  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    addItemsClickedListener();
    print('onboarding interest redraw');
  }

  addItemsClickedListener() {
    widget.onBoardingClickableItemBLoC.stream_counter.listen((value) {
      refreshHobbie();
    });
    widget.recentOnBoardingForwardClickableItemBLoC.stream_counter
        .listen((value) {
      refreshRecentOnBoarding();
    });
  }

  @override
  Widget build(BuildContext context) {
    /*return FutureBuilder(
        //future: isHobbySelectedInOnBoardingById(
        future: widget.onboardinginterestDao
            .isHobbyInOnBoardingById(widget.hobbie.id, widget.onboarding.id),
        builder: (context, snapshot) {*/
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return InkWell(
          splashColor: Colors.white24,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
          ),
          onTap: () {
            print('AM TAPPED');
            widget.isSelectable ? updateOnBoarding() : onTapDoNothing();
          },
          child: mainContainerItemStreamBuilder(
              datingAppThemeChanger), /*Column(
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
                    color: snapshot.data == true
                        ? Color(0xFFFFFFFF)
                        : Colors.black.withOpacity(.12))
              ],
              color: snapshot.data == true ? Colors.pink : Color(0xFFF8BBD0),
              borderRadius: radius,
            ),
            child: Stack(
              children: <Widget>[
                Text(
                  widget.hobbie.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color:
                        snapshot.data == true ? Color(0xFFFFFFFF) : Colors.pink,
                  ),
                ),
              ],
            ),
          )
        ],
      ),*/
        );
      },
    );
    // });
  }

  Widget mainContainerItemStreamBuilder(
      DatingAppThemeChanger datingAppThemeChanger) {
    refresh_onselectNavigationDataBLoC();
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
                  ? datingAppThemeChanger.selectedThemeData
                      .cl_cont_Sel_ClickableItem_Bshadow //Color(0xFFFFFFFF)
                  : datingAppThemeChanger
                      .selectedThemeData.cl_cont_UnSel_ClickableItem_Bshadow)
        ],
        //color: widget.isSelected ? Colors.pink : Color(0xFFF8BBD0),
        color: widget.isSelected
            ? datingAppThemeChanger
                .selectedThemeData.cl_cont_Sel_ClickableItem //Colors.pink
            : datingAppThemeChanger
                .selectedThemeData.cl_cont_UnSel_ClickableItem,
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
            widget.hobbie.name,
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
      Onboardinginterest onboardingsomethingspecific = await widget
          .onboardinginterestDao
          .getHobbyInOnBoardingById(widget.hobbie.id, widget.onboarding.id);

      if (onboardingsomethingspecific != null) {
        int deletedonboardingsomethingspecific = await widget
            .onboardinginterestDao
            .deleteOnboardinginterest(onboardingsomethingspecific);
      }
      widget.onBoardingClickableItemBLoC.onboarding_itemclicked_event_sink
          .add(OneItemClickedEvent(widget.hobbie.id));
    } else {
      //widget.isSelected = true;
      //SELECT-INSERT
      Onboardinginterest onboardingsomethingspecific = await widget
          .onboardinginterestDao
          .getHobbyInOnBoardingById(widget.hobbie.id, widget.onboarding.id);

      if (onboardingsomethingspecific != null) {
        bool isUpdated = await widget.onboardinginterestDao
            .updateOnboardinginterest(onboardingsomethingspecific
                .toCompanion(false)
                .copyWith(
                    onboarding: flutterMoor.Value(widget.onboarding.id),
                    hobbie: flutterMoor.Value(widget.hobbie.id)));
      } else {
        //CREATE AND INSERT
        OnboardinginterestsCompanion onboardingsomethingspecificsCompanion =
            new OnboardinginterestsCompanion(
                onboarding: flutterMoor.Value(widget.onboarding.id),
                hobbie: flutterMoor.Value(widget.hobbie.id));
        int insertedId = await widget.onboardinginterestDao
            .insertOnboardinginterest(onboardingsomethingspecificsCompanion);
      }
      widget.onBoardingClickableItemBLoC.onboarding_itemclicked_event_sink
          .add(OneItemClickedEvent(widget.hobbie.id));
    }
  }

/*  refreshHobbie() async {
    bool isSelected = await isHobbySelectedInOnBoardingById(
        widget.hobbie.id, widget.onboarding.id);
    setState(() {
      if (isSelected) {
        widget.isSelected = true;
      } else {
        widget.isSelected = false;
      }
    });
    widget.onItemClick(widget.onboarding);
  }*/
  refreshHobbie() async {
    bool isSelected =
        //await isHobbySelectedInOnBoardingById(
        await widget.onboardinginterestDao
            .isHobbyInOnBoardingById(widget.hobbie.id, widget.onboarding.id);
    widget.isSelected = isSelected;
    refresh_onselectNavigationDataBLoC();
    //widget.onItemClick(widget.onboarding);
  }

  refresh_onselectNavigationDataBLoC() {
    onselectNavigationDataBLoC.dailySubTaskimages_event_sink
        .add(NavigationDataAddedEvent(NavigationData()));
  }

  refreshRecentOnBoarding() async {
    Onboarding updatedOnboarding =
        await widget.onboardingDao.getOnboardingById(widget.onboarding.id);
    widget.onboarding = updatedOnboarding;
  }

/*  Future<bool> isHobbySelectedInOnBoardingById(
      int hobbieId, int onboardingId) async {
    return await widget.onboardinginterestDao
        .isHobbyInOnBoardingById(hobbieId, onboardingId)
        .then((onValue) {
      return onValue;
    }, onError: (error) {
      return false;
    });
  }*/

  onTapDoNothing() {
    print('chip clicked');
  }
}

typedef IntindexCallback = void Function(Onboarding onboarding);
