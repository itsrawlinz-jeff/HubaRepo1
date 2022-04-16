import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemBLoC.dart';
import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemEvent.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingDao.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:provider/provider.dart';

class OnBoardingDrinkStatusOption extends StatefulWidget {
  OnBoardingDrinkStatusOption({
    Key key,
    this.isSelected,
    this.isSelectable,
    this.drinkstatuse,
    this.onboarding,
    this.onboardingDao,
    this.onItemClick,
    this.onBoardingClickableItemBLoC,
    this.recentOnBoardingForwardClickableItemBLoC,
  }) : super(key: key);

  bool isSelected;
  bool isSelectable;
  Drinkstatuse drinkstatuse;
  Onboarding onboarding;
  OnboardingDao onboardingDao;
  IntindexCallback onItemClick;
  OnBoardingClickableItemBLoC onBoardingClickableItemBLoC;
  OnBoardingClickableItemBLoC recentOnBoardingForwardClickableItemBLoC;

  @override
  _OnBoardingDrinkStatusOptionState createState() =>
      new _OnBoardingDrinkStatusOptionState();
}

class _OnBoardingDrinkStatusOptionState
    extends State<OnBoardingDrinkStatusOption>
    with AfterLayoutMixin<OnBoardingDrinkStatusOption> {
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
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  splashColor: Colors.white24,
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  onTap: () {
                    print('AM TAPPED');
                    widget.isSelectable
                        ? updateOnBoardingNew()
                        : onTapDoNothing();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(3.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: .5,
                            spreadRadius: 1.0,
                            /*color: widget.drinkstatuse.id ==
                                    widget.onboarding.want_date_to_drink
                                ? Color(0xFFFFFFFF)
                                : Colors.black.withOpacity(.12))*/
                            color: widget.drinkstatuse.id ==
                                    widget.onboarding.want_date_to_drink
                                ? datingAppThemeChanger.selectedThemeData
                                    .cl_cont_Sel_ClickableItem_Bshadow //Color(0xFFFFFFFF)
                                : datingAppThemeChanger.selectedThemeData
                                    .cl_cont_UnSel_ClickableItem_Bshadow)
                      ],
                      /*color: widget.drinkstatuse.id ==
                              widget.onboarding.want_date_to_drink
                          ? Colors.pink
                          : Color(0xFFF8BBD0),*/
                      color: widget.drinkstatuse.id ==
                              widget.onboarding.want_date_to_drink
                          ? datingAppThemeChanger.selectedThemeData
                              .cl_cont_Sel_ClickableItem //Colors.pink
                          : datingAppThemeChanger
                              .selectedThemeData.cl_cont_UnSel_ClickableItem,
                      borderRadius: radius,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.drinkstatuse.name,
                          style: widget.drinkstatuse.id ==
                                  widget.onboarding.want_date_to_drink
                              ? datingAppThemeChanger.selectedThemeData
                                  .default_Sel_ClickableItem_TextStyle
                              : datingAppThemeChanger.selectedThemeData
                                  .default_UnSel_ClickableItem_TextStyle,
                          /*style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            letterSpacing: 0.27,
                            color: widget.drinkstatuse.id ==
                                    widget.onboarding.want_date_to_drink
                                ? Color(0xFFFFFFFF)
                                : Colors.pink,
                          ),*/
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  updateOnBoardingNew() async {
    if (widget.isSelected) {
      print('was Selected');
      widget.isSelected = false;

      bool updated = await widget.onboardingDao.updateOnboarding(widget
          .onboarding
          .toCompanion(false)
          .copyWith(want_date_to_drink: Value(null)));
      /*if (updated) {
        Onboarding updatedOnboarding =
            await widget.onboardingDao.getOnboardingById(widget.onboarding.id);
        setState(() {
          widget.onboarding = updatedOnboarding;
        });
      }*/
      widget.onBoardingClickableItemBLoC.onboarding_itemclicked_event_sink
          .add(OneItemClickedEvent(widget.drinkstatuse.id));
    } else {
      widget.isSelected = true;
      bool updated = await widget.onboardingDao.updateOnboarding(widget
          .onboarding
          .toCompanion(false)
          .copyWith(want_date_to_drink: Value(widget.drinkstatuse.id)));
      /* if (updated) {
        Onboarding updatedOnboarding =
            await widget.onboardingDao.getOnboardingById(widget.onboarding.id);
        setState(() {
          widget.onboarding = updatedOnboarding;
        });
      }*/
      widget.onBoardingClickableItemBLoC.onboarding_itemclicked_event_sink
          .add(OneItemClickedEvent(widget.drinkstatuse.id));
    }
  }

  updateOnBoarding() async {
    if (widget.isSelected) {
      bool updated = await widget.onboardingDao.updateOnboarding(widget
          .onboarding
          .toCompanion(false)
          .copyWith(do_you_smoke: Value(widget.drinkstatuse.id)));
      if (updated) {
        Onboarding updatedOnboarding =
            await widget.onboardingDao.getOnboardingById(widget.onboarding.id);
        setState(() {
          widget.onboarding = updatedOnboarding;
        });
      }
    } else {
      Onboarding updatedOnboarding =
          await widget.onboardingDao.getOnboardingById(widget.onboarding.id);
      setState(() {
        widget.onboarding = updatedOnboarding;
      });
    }
  }

  refreshOnBoarding() async {
    Onboarding updatedOnboarding =
        await widget.onboardingDao.getOnboardingById(widget.onboarding.id);
    setState(() {
      widget.onboarding = updatedOnboarding;
      if (widget.drinkstatuse.id == widget.onboarding.want_date_to_drink) {
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
