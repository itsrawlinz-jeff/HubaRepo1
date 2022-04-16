import 'dart:convert';

import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleBLoC.dart';
import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleEvent.dart';
import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemBLoC.dart';
import 'package:dating_app/Bloc/Streams/OnBoardingClickableItem/OnBoardingClickableItemEvent.dart';
import 'package:dating_app/Bloc/Streams/PageChanged/OnBoardingPageBLoC.dart';
import 'package:dating_app/Bloc/Streams/PageChanged/OnBoardingPageEvent.dart';
import 'package:dating_app/Bloc/Streams/RegistrationPage/PageDraggerBLoC.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataEvent.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/batch_put_posting/batch_post_put_onboardingInterest.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/batch_put_posting/batch_post_put_onboardingmoneysheshldmake.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/batch_put_posting/batch_post_put_onboardingsomethingspecific.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/batch_put_posting/batch_post_put_onboardinguserillness.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_put_onboardings.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_user_login.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_validate_email.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_validate_phone_no.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_validate_user_name.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/put_post_user_usersProfiles.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/DrinkstatusDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/EducationlevelDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/EthnicityDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/GenderDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/HobbyDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/IncomerangeDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/OnboardingDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/RelationshipstatusDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/ReligionDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/SmokestatusDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/SomethingspecificDao.dart';
import 'package:dating_app/Data/Database/Moor/Dao/WantchildrenstatusDao.dart';
import 'package:dating_app/Data/Database/Moor/JoinClasses/OnboardinginterestJoinClass.dart';
import 'package:dating_app/Data/Database/Moor/JoinClasses/OnboardingmoneyshemakesJoinClass.dart';
import 'package:dating_app/Data/Database/Moor/JoinClasses/OnboardingsomethingspecificJoinClass.dart';
import 'package:dating_app/Data/Database/Moor/JoinClasses/OnboardinguserillnessJoinClass.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Genders.dart';
import 'package:dating_app/Data/Database/Moor/Tables/Smokestatuses.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/smokestatus/SmokestatuseRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserPostPutRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/OnboardingsomethingspecificReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/user_profiles/UserUserProfileReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/drinkstatus/DrinkStatusRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/educationlevel/EducationlevelRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/ethnicity/EthnicityRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/gender/GenderRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/hobby/HobbyRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/incomerange/IncomerangeRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/relationshipstatus/RelStatusRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/religion/ReligionRespModel.dart';

import 'package:dating_app/Models/JsonSerializable/Api/from/somethingspecific/SomethingspecificRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/wantchildren/WantchildrenstatuseRespModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/OnBoarding/Tabs/A_Little_About_Self.dart';
import 'package:dating_app/OnBoarding/Tabs/I_Have_A_Chronic_Illness_OB_Page.dart';
import 'package:dating_app/OnBoarding/Tabs/Initial_Personal_Info.dart';
import 'package:dating_app/OnBoarding/Tabs/Your_Religion_OB_Page.dart';
import 'package:dating_app/OnBoarding/Tabs/Her_Age_OB_Page.dart';
import 'package:dating_app/OnBoarding/Tabs/Looking_Smth_Specific_OB_Page.dart';
import 'package:dating_app/OnBoarding/Tabs/Iam_OB_Page.dart';
import 'package:dating_app/OnBoarding/Tabs/Searching_For_OB_Page.dart';
import 'package:dating_app/OnBoarding/Tabs/What_Your_Interests_OB_Page.dart';
import 'package:dating_app/OnBoarding/Tabs/Do_You_Wnt_Date_Drink_OB_Page.dart';
import 'package:dating_app/OnBoarding/Tabs/Rel_Status_OB_Page.dart';
import 'package:dating_app/OnBoarding/Tabs/Do_You_Smoke_OB_Page.dart';
import 'package:dating_app/OnBoarding/Tabs/Edu_Level_OB_Page.dart';
import 'package:dating_app/OnBoarding/Tabs/Do_You_WChildr_OB_Page.dart';
import 'package:dating_app/OnBoarding/Tabs/How_Oftn_Drink_OB_Page.dart';
import 'package:dating_app/OnBoarding/Tabs/Which_Ethnicity_Desc_You_OB_Page.dart';
import 'package:dating_app/OnBoarding/Tabs/Money_Shld_She_Make_OB_Page.dart';
import 'package:dating_app/OnBoarding/Tabs/Picky_About_Her_Education.dart';
import 'package:dating_app/UI/Presentation/FancyOB/page_model.dart';
import 'package:dating_app/UI/Presentation/PageIndicator/page_indicator.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:after_layout/after_layout.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';

class OnBoardingConcept extends StatefulWidget {
  OnBoardingConcept({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OnBoardingConceptState createState() => new _OnBoardingConceptState();
}

class _OnBoardingConceptState extends State<OnBoardingConcept>
    with TickerProviderStateMixin, AfterLayoutMixin<OnBoardingConcept> {
  KeyBoardVisibleBLoC _keyBoardVisibleBLoC = KeyBoardVisibleBLoC();
  static var _pageDraggerBLoC = PageDraggerBLoC();

  PageController _controller;
  int currentPage = 0;
  bool lastPage = false;
  AnimationController animationController;
  Animation<double> _scaleAnimation;
  static var _onBoardingPageBLoC = OnBoardingPageBLoC();
  ProgressDialog pr;

  List<PageModel> pageList = [];
  AppDatabase database;
  GenderDao genderDao;
  RelationshipstatusDao relationshipstatusDao;
  SmokestatusDao smokestatusDao;
  EducationLevelDao educationLevelDao;
  WantchildrenstatusDao wantchildrenstatusDao;
  DrinkstatusDao drinkstatusDao;
  EthnicityDao ethnicityDao;
  ReligionDao religionDao;

  //OnBoardingDao onBoardingDao;
  Onboarding recentOnboarding;
  OnBoardingClickableItemBLoC
      recentOnBoardingChangedOnBoardingClickableItemBLoC =
      OnBoardingClickableItemBLoC();
  BuildContext builderContext;
  NavigationDataBLoC pageListrebuildNavigationDataBLoC = NavigationDataBLoC();
  NavigationDataBLoC swipeLeftTocontinueNavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC saved_Clicked_NavigationDataBLoC = NavigationDataBLoC();
  NavigationDataBLoC navigationDataBLoC_Loader = NavigationDataBLoC();

  final birthday_format = DateFormat("dd/MM/yyyy");

  List<PageModel> createPagesList() {
    var pagerList = [
      PageModel(
          color: const Color(0xFF678FB4),
          heroAssetPath: 'assets/png/hotels.png',
          title: Text('Hotels',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text('All hotels and hostels are sorted by hospitality rating',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          iconAssetPath: '',
          widget: new Initial_Personal_Info(
            functionOnBoardingChanged: functionOnBoardingChanged,
            keyBoardVisibleBLoC: _keyBoardVisibleBLoC,
            onboarding: recentOnboarding,
            recentOnBoardingChangedOnBoardingClickableItemBLoC:
                recentOnBoardingChangedOnBoardingClickableItemBLoC,
            saved_Clicked_NavigationDataBLoC: saved_Clicked_NavigationDataBLoC,
          )),
      PageModel(
          color: const Color(0xFF678FB4),
          heroAssetPath: 'assets/png/hotels.png',
          title: Text('Hotels',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text('All hotels and hostels are sorted by hospitality rating',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          iconAssetPath: '',
          widget: new Iam_OB_Page(
            keyBoardVisibleBLoC: _keyBoardVisibleBLoC,
            onboarding: recentOnboarding,
            recentOnBoardingChangedOnBoardingClickableItemBLoC:
                recentOnBoardingChangedOnBoardingClickableItemBLoC,
            functionOnBoardingChanged: functionOnBoardingChanged,
          )),
      PageModel(
          color: const Color(0xFF678FB4),
          heroAssetPath: 'assets/png/hotels.png',
          title: Text('Hotels',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text('All hotels and hostels are sorted by hospitality rating',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          iconAssetPath: '',
          widget: new Searching_For_OB_Page(
            keyBoardVisibleBLoC: _keyBoardVisibleBLoC,
            onboarding: recentOnboarding,
            recentOnBoardingChangedOnBoardingClickableItemBLoC:
                recentOnBoardingChangedOnBoardingClickableItemBLoC,
            functionOnBoardingChanged: functionOnBoardingChanged,
          )),
      PageModel(
          color: const Color(0xFF678FB4),
          heroAssetPath: 'assets/png/hotels.png',
          title: Text('Hotels',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text('All hotels and hostels are sorted by hospitality rating',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          iconAssetPath: '',
          widget: new Rel_Status_OB_Page(
            keyBoardVisibleBLoC: _keyBoardVisibleBLoC,
            onboarding: recentOnboarding,
            recentOnBoardingChangedOnBoardingClickableItemBLoC:
                recentOnBoardingChangedOnBoardingClickableItemBLoC,
            functionOnBoardingChanged: functionOnBoardingChanged,
          )),
      PageModel(
          color: const Color(0xFF65B0B4),
          heroAssetPath: 'assets/png/banks.png',
          title: Text('Banks',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text(
              'We carefully verify all banks before adding them into the app',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          iconAssetPath: '',
          widget: new Do_You_Smoke_OB_Page(
            keyBoardVisibleBLoC: _keyBoardVisibleBLoC,
            onboarding: recentOnboarding,
            recentOnBoardingChangedOnBoardingClickableItemBLoC:
                recentOnBoardingChangedOnBoardingClickableItemBLoC,
            functionOnBoardingChanged: functionOnBoardingChanged,
          )),
      PageModel(
          color: const Color(0xFF9B90BC),
          heroAssetPath: 'assets/png/stores.png',
          title: Text('Store',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text('All local stores are categorized for your convenience',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          iconAssetPath: '',
          //assets/png/shopping_cart.png
          widget: new Edu_Level_OB_Page(
            keyBoardVisibleBLoC: _keyBoardVisibleBLoC,
            onboarding: recentOnboarding,
            recentOnBoardingChangedOnBoardingClickableItemBLoC:
                recentOnBoardingChangedOnBoardingClickableItemBLoC,
            functionOnBoardingChanged: functionOnBoardingChanged,
          )),
      // SVG Pages Example
      PageModel(
          color: const Color(0xFF678FB4),
          heroAssetPath: 'assets/svg/hotel.svg',
          title: Text('Hotels SVG',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text('All hotels and hostels are sorted by hospitality rating',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          iconAssetPath: '',
          //assets/svg/key.svg
          heroAssetColor: Colors.white,
          widget: new Do_You_WChildr_OB_Page(
            keyBoardVisibleBLoC: _keyBoardVisibleBLoC,
            onboarding: recentOnboarding,
            recentOnBoardingChangedOnBoardingClickableItemBLoC:
                recentOnBoardingChangedOnBoardingClickableItemBLoC,
            functionOnBoardingChanged: functionOnBoardingChanged,
          )),
      PageModel(
          color: const Color(0xFF678FB4),
          heroAssetPath: 'assets/svg/hotel.svg',
          title: Text('Hotels SVG',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text('All hotels and hostels are sorted by hospitality rating',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          iconAssetPath: '',
          heroAssetColor: Colors.white,
          widget: new How_Oftn_Drink_OB_Page(
            keyBoardVisibleBLoC: _keyBoardVisibleBLoC,
            onboarding: recentOnboarding,
            recentOnBoardingChangedOnBoardingClickableItemBLoC:
                recentOnBoardingChangedOnBoardingClickableItemBLoC,
            functionOnBoardingChanged: functionOnBoardingChanged,
          )),
      PageModel(
          color: const Color(0xFF678FB4),
          heroAssetPath: '',
          title: Text('Hotels SVG',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text('All hotels and hostels are sorted by hospitality rating',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          iconAssetPath: '',
          heroAssetColor: Colors.white,
          widget: new Which_Ethnicity_Desc_You_OB_Page(
            keyBoardVisibleBLoC: _keyBoardVisibleBLoC,
            onboarding: recentOnboarding,
            recentOnBoardingChangedOnBoardingClickableItemBLoC:
                recentOnBoardingChangedOnBoardingClickableItemBLoC,
            functionOnBoardingChanged: functionOnBoardingChanged,
          )),

      PageModel(
          color: const Color(0xFF678FB4),
          heroAssetPath: 'assets/svg/hotel.svg',
          title: Text('Hotels SVG',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text('All hotels and hostels are sorted by hospitality rating',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          iconAssetPath: '',
          heroAssetColor: Colors.white,
          widget: new Your_Religion_OB_Page(
            keyBoardVisibleBLoC: _keyBoardVisibleBLoC,
            onboarding: recentOnboarding,
            recentOnBoardingChangedOnBoardingClickableItemBLoC:
                recentOnBoardingChangedOnBoardingClickableItemBLoC,
            functionOnBoardingChanged: functionOnBoardingChanged,
          )),
      PageModel(
          color: const Color(0xFF678FB4),
          heroAssetPath: 'assets/svg/hotel.svg',
          title: Text('Hotels SVG',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text('All hotels and hostels are sorted by hospitality rating',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          iconAssetPath: '',
          heroAssetColor: Colors.white,
          widget: new Her_Age_OB_Page(
            pageDraggerBLoC: _pageDraggerBLoC,
            keyBoardVisibleBLoC: _keyBoardVisibleBLoC,
            onboarding: recentOnboarding,
            recentOnBoardingChangedOnBoardingClickableItemBLoC:
                recentOnBoardingChangedOnBoardingClickableItemBLoC,
            functionOnBoardingChanged: functionOnBoardingChanged,
          )),
      /*PageModel(
          color: const Color(0xFF678FB4),
          heroAssetPath: 'assets/svg/hotel.svg',
          title: Text('Hotels SVG',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text('All hotels and hostels are sorted by hospitality rating',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          iconAssetPath: '',
          heroAssetColor: Colors.white,
          widget: new Looking_Smth_Specific_OB_Page(
            keyBoardVisibleBLoC: _keyBoardVisibleBLoC,
            onboarding: recentOnboarding,
            recentOnBoardingChangedOnBoardingClickableItemBLoC:
                recentOnBoardingChangedOnBoardingClickableItemBLoC,
            functionOnBoardingChanged: functionOnBoardingChanged,
          )),*/
      PageModel(
          color: const Color(0xFF678FB4),
          heroAssetPath: 'assets/svg/hotel.svg',
          title: Text('Hotels SVG',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text('All hotels and hostels are sorted by hospitality rating',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          iconAssetPath: '',
          heroAssetColor: Colors.white,
          widget: new What_Your_Interests_OB_Page(
            keyBoardVisibleBLoC: _keyBoardVisibleBLoC,
            onboarding: recentOnboarding,
            recentOnBoardingChangedOnBoardingClickableItemBLoC:
                recentOnBoardingChangedOnBoardingClickableItemBLoC,
            functionOnBoardingChanged: functionOnBoardingChanged,
          )),
      PageModel(
          color: const Color(0xFF678FB4),
          heroAssetPath: 'assets/svg/hotel.svg',
          title: Text('Hotels SVG',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text('All hotels and hostels are sorted by hospitality rating',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          iconAssetPath: '',
          heroAssetColor: Colors.white,
          widget: new I_Have_A_Chronic_Illness_OB_Page(
            keyBoardVisibleBLoC: _keyBoardVisibleBLoC,
            onboarding: recentOnboarding,
            recentOnBoardingChangedOnBoardingClickableItemBLoC:
                recentOnBoardingChangedOnBoardingClickableItemBLoC,
            functionOnBoardingChanged: functionOnBoardingChanged,
          )),
      PageModel(
          color: const Color(0xFF678FB4),
          heroAssetPath: 'assets/svg/hotel.svg',
          title: Text('Hotels SVG',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text('All hotels and hostels are sorted by hospitality rating',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          iconAssetPath: '',
          heroAssetColor: Colors.white,
          widget: new Money_Shld_She_Make_OB_Page(
            keyBoardVisibleBLoC: _keyBoardVisibleBLoC,
            onboarding: recentOnboarding,
            recentOnBoardingChangedOnBoardingClickableItemBLoC:
                recentOnBoardingChangedOnBoardingClickableItemBLoC,
            functionOnBoardingChanged: functionOnBoardingChanged,
          )),
      PageModel(
          color: const Color(0xFF678FB4),
          heroAssetPath: 'assets/svg/hotel.svg',
          title: Text('Hotels SVG',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text('All hotels and hostels are sorted by hospitality rating',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          iconAssetPath: '',
          heroAssetColor: Colors.white,
          widget: new Do_You_Wnt_Date_Drink_OB_Page(
            keyBoardVisibleBLoC: _keyBoardVisibleBLoC,
            onboarding: recentOnboarding,
            recentOnBoardingChangedOnBoardingClickableItemBLoC:
                recentOnBoardingChangedOnBoardingClickableItemBLoC,
            functionOnBoardingChanged: functionOnBoardingChanged,
          )),

      PageModel(
          color: const Color(0xFF678FB4),
          heroAssetPath: 'assets/svg/hotel.svg',
          title: Text('Hotels SVG',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text('All hotels and hostels are sorted by hospitality rating',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          iconAssetPath: '',
          heroAssetColor: Colors.white,
          widget: new A_Little_About_Self(
            keyBoardVisibleBLoC: _keyBoardVisibleBLoC,
            onboarding: recentOnboarding,
            recentOnBoardingChangedOnBoardingClickableItemBLoC:
                recentOnBoardingChangedOnBoardingClickableItemBLoC,
            functionOnBoardingChanged: functionOnBoardingChanged,
          )),
      PageModel(
          color: const Color(0xFF678FB4),
          heroAssetPath: 'assets/svg/hotel.svg',
          title: Text('Hotels SVG',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text('All hotels and hostels are sorted by hospitality rating',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          iconAssetPath: '',
          heroAssetColor: Colors.white,
          widget: new Picky_About_Her_Education(
            keyBoardVisibleBLoC: _keyBoardVisibleBLoC,
            onboarding: recentOnboarding,
            recentOnBoardingChangedOnBoardingClickableItemBLoC:
                recentOnBoardingChangedOnBoardingClickableItemBLoC,
            functionOnBoardingChanged: functionOnBoardingChanged,
          )),
    ];
    return pagerList;
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: currentPage,
    );
    animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _scaleAnimation = Tween(begin: 0.6, end: 1.0).animate(animationController);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    print('OnBoardingConcept afterFirstLayout');
    database = Provider.of<AppDatabase>(context);
    genderDao = database.genderDao;
    relationshipstatusDao = database.relationshipstatusDao;
    smokestatusDao = database.smokestatusDao;
    educationLevelDao = database.educationLevelDao;
    wantchildrenstatusDao = database.wantchildrenstatusDao;
    drinkstatusDao = database.drinkstatusDao;
    ethnicityDao = database.ethnicityDao;
    religionDao = database.religionDao;

    getRecentOnBoarding();
    /*syncOnBoardingSmokestatusData();
    syncOnBoardingGenderData();
    syncOnBoardingRelationshipstatusData();
    syncOnBoardingDrinkstatusData();
    syncOnBoardingEducationLevelData();
    syncOnBoardingEthnicityData();
    syncOnBoardingHobbieData();
    syncOnBoardingIncomerangeData();
    syncOnBoardingReligionData();
    syncOnBoardingWantchildrenstatuseData();
    syncOnBoardingSomethingspecificData();*/
    //addListeners();
  }

/*  addListeners() {
    KeyboardVisibility.onChange.listen(
      (bool visible) {
        print('AUUUUII MEE${visible.toString()}');
        _keyBoardVisibleBLoC.keyboard_visible_event_sink
            .add(ToggleKeyBoardVisEvent(visible));
      },
    );
  }*/

  getRecentOnBoarding() async {
    await database.onboardingDao.getRecentOnboardingLimit1().then(
        (List<Onboarding> onBoardingList) async {
      if (onBoardingList.length > 0) {
        Onboarding onBoarding = onBoardingList[0];
        if (onBoarding == null) {
          print('NEW ONBOARDING');
          recentOnboarding = new Onboarding(
            herage_low: 18,
            herage_high: 100,
            have_chronic_illness: false,
          );
          int insertedOnboardingId =
              await database.onboardingDao.insertOnboarding(recentOnboarding);
          if (insertedOnboardingId > 0) {
            recentOnboarding = await database.onboardingDao
                .getOnboardingById(insertedOnboardingId);
            setUpUI();
          }
          print('insertedOnboardingId==${insertedOnboardingId}');
        } else {
          print('EXISTING ONBOARDING== ${onBoarding.id}');
          database.onboardinginterestDao.deleteAllOnboardinginterest();
          database.onboardingsomethingspecificDao
              .deleteAllOnboardingsomethingspecific();
          database.onboardingmoneyshemakeDao.deleteAllOnboardingmoneyshemake();
          database.onboardinguserillnessDao.deleteAllOnboardinguserillness();
          final companion = onBoarding.toCompanion(true).copyWith(
                username: Value(null),
                password: Value(null),
                email: Value(null),
                birthday: Value(null),
                profpicpath: Value(null),
                iam: Value(null),
                searchingfor: Value(null),
                relationshipstatus: Value(null),
                do_you_smoke: Value(null),
                education_level: Value(null),
                want_children: Value(null),
                often_you_drink: Value(null),
                ethnicity: Value(null),
                want_date_to_drink: Value(null),
                picky_abt_her_education: Value(null),
                religion: Value(null),
                herage_low: Value(18),
                herage_high: Value(100),
                onlineid: Value(null),
                firstname: Value(null),
                lastname: Value(null),
                little_about_self: Value(null),
                phone_number: Value(null),
                userprofile_onlineid: Value(null),
                have_chronic_illness: Value(false),
                insta_link: Value(null),
                fb_link: Value(null),
              );

          var recentOnboardingVar =
              database.onboardings.mapFromCompanion(companion);
          bool isUpdated = await database.onboardingDao
              .updateOnboarding(recentOnboardingVar);
          recentOnboarding =
              await database.onboardingDao.getOnboardingById(onBoarding.id);

          setUpUI();
        }
      } else {
        print('onBoardingList !>0');
        print('NEW ONBOARDING 1');
        recentOnboarding = new Onboarding(
          herage_low: 18,
          herage_high: 100,
          have_chronic_illness: false,
        );
        int insertedOnboardingId =
            await database.onboardingDao.insertOnboarding(recentOnboarding);
        if (insertedOnboardingId > 0) {
          recentOnboarding = await database.onboardingDao
              .getOnboardingById(insertedOnboardingId);
          if (recentOnboarding != null) {
            print('inserted!= null 1');
          } else {
            print('inserted null 1');
          }
          setUpUI();
        }
        print('insertedOnboardingId 1==${insertedOnboardingId}');
      }
    }, onError: (error) {
      print('error=${error}');
    });
  }

  setUpUI() {
    print('setUpUI');
    print('recentOnboarding.id==');
    print(recentOnboarding.id.toString());
    pageList = createPagesList();

    NavigationData navigationData = NavigationData();
    navigationData.pageList = pageList;
    pageListrebuildNavigationDataBLoC.dailySubTaskimages_event_sink
        .add(NavigationDataAddedEvent(navigationData));

    if (pageList.length > 0) {
      refreshSwipeLeftTocontinueNavigationDataBLoC(true);
    }

    /* setState(() {
      pageList = createPagesList();
    });*/
  }

  refreshSwipeLeftTocontinueNavigationDataBLoC(bool isToshow) {
    NavigationData navigationDataSw = NavigationData();
    navigationDataSw.isShow = isToshow;
    swipeLeftTocontinueNavigationDataBLoC.dailySubTaskimages_event_sink
        .add(NavigationDataAddedEvent(navigationDataSw));
  }

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
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: TextStyle(
          color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return Container(
          /*decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFF485563), Color(0xFF29323C)],
            tileMode: TileMode.clamp,
            begin: Alignment.topCenter,
            stops: [0.0, 1.0],
            end: Alignment.bottomCenter),
      ),*/
          /*     decoration: BoxDecoration(
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
          //color: DatingAppTheme.background,
          color: datingAppThemeChanger
              .selectedThemeData.sm_bg_backgroundWO_opacity,
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: new Builder(
                builder: (BuildContext context) {
                  builderContext = context;
                  return Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      pageViewerStreamBuilderWidget(),
                      /* PageView.builder(
                    itemCount: pageList.length,
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                        if (currentPage == pageList.length - 1) {
                          lastPage = true;
                          animationController.forward();
                        } else {
                          lastPage = false;
                          animationController.reset();
                        }
                        print(lastPage);
                        _onBoardingPageBLoC.onBoardingPage_visible_event_sink
                            .add(OnBoardingPageChangedEvent(currentPage));
                      });
                    },
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          var page = pageList[index];
                          var delta;
                          var y = 1.0;

                          if (_controller.position.haveDimensions) {
                            delta = _controller.page - index;
                            y = 1 - delta.abs().clamp(0.0, 1.0);
                          }
                          return page.widget;
                          */
                      /*return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(page.imageUrl),
                        Container(
                          margin: EdgeInsets.only(left: 12.0),
                          height: 100.0,
                          child: Stack(
                            children: <Widget>[
                              Opacity(
                                opacity: .10,
                                child: GradientText(
                                  page.title,
                                  gradient: LinearGradient(
                                      colors: pageList[index].titleGradient),
                                  style: TextStyle(
                                      fontSize: 100.0,
                                      fontFamily: "Montserrat-Black",
                                      letterSpacing: 1.0),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 30.0, left: 22.0),
                                child: GradientText(
                                  page.title,
                                  gradient: LinearGradient(
                                      colors: pageList[index].titleGradient),
                                  style: TextStyle(
                                    fontSize: 70.0,
                                    fontFamily: "Montserrat-Black",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 34.0, top: 12.0),
                          child: Transform(
                            transform:
                                Matrix4.translationValues(0, 50.0 * (1 - y), 0),
                            child: Text(
                              page.body,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: "Montserrat-Medium",
                                  color: Color(0xFF9B9B9B)),
                            ),
                          ),
                        )
                      ],
                    );*/ /*
                        },
                      );
                    },
                  ),*/
                      /*Positioned(
              left: 30.0,
              bottom: 55.0,
              child: Container(
                width: 160.0,
                child: Container(
                  width: 160.0,
                  height: 4,
                  child: PageIndicator(
                      currentIndex: currentPage,
                      pageCount: pageList.length,
                      onBoardingPageBLoC: _onBoardingPageBLoC),
                  */ /*child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Text(
                        "fjjfnjgfgnfjuuuuuuuuuuuuuuuu88888888888888888888888888888888888",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),*/ /*
                ),
              ),
            ),*/
                      StreamBuilder(
                        stream: _keyBoardVisibleBLoC.stream_counter,
                        initialData: false,
                        builder: (context, snapshot) {
                          return Visibility(
                            visible: !snapshot.data,
                            child: Positioned(
                              left: 30.0,
                              bottom: 55.0,
                              child: Container(
                                width: 160.0,
                                child: Container(
                                  width: 160.0,
                                  height: 10,
                                  child:
                                      pageIndicatorWidgetStreamBuilderWidget(), /*PageIndicator(
                                  currentIndex: currentPage,
                                  pageCount: pageList.length,
                                  onBoardingPageBLoC: _onBoardingPageBLoC),*/
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      swipeLeftToContinueStreamBuilderWidget(
                          datingAppThemeChanger),
                      /*Positioned(
                        right: 5.0,
                        bottom: 50.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3.5,
                          child: Text(
                            'Swipe left to continue ...',
                            style: datingAppThemeChanger.selectedThemeData
                                .default_swp_left_To_Cont_TextStyle,
                          ),
                        ),
                      ),*/
                      finishButtonStreamBuilderWidget(datingAppThemeChanger),
                      /*Positioned(
                    right: 30.0,
                    bottom: 30.0,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: lastPage
                          ? FloatingActionButton(
                              backgroundColor: Color(0xFFF8BBD0),
                              child: Icon(
                                OMIcons.save,
                                //Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                await uploadOnBoarding();
                              },
                            )
                          : Container(),
                      */
                      /*  Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    Padding(
                      padding:
                      const EdgeInsets.only(left: 8.0),
                      child: InkWell(
                        onTap: () {

                        },
                        borderRadius: BorderRadius.all(
                          Radius.circular(43.0),
                        ),
                        splashColor: Colors.grey,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(0.8),
                            shape: BoxShape.circle,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors
                                      .black
                                      .withOpacity(0.4),
                                  offset: Offset(8.0, 8.0),
                                  blurRadius: 8.0),
                            ],
                          ),
                          child: Padding(
                            padding:
                            const EdgeInsets.all(4.0),
                            child: Center(
                                child: Icon(
                                  OMIcons.addAPhoto,
                                  size: 30,
                                  color: Colors.grey,
                                )),
                          ),
                        ),
                      ),
                    )
                  ],
                ),*/ /*
                    ),
                  ),*/
                    ],
                  );
                },
              )),
        );
      },
    );
  }

  Widget pageIndicatorWidgetStreamBuilderWidget() {
    return StreamBuilder(
      stream: pageListrebuildNavigationDataBLoC.stream_counter,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return pageIndicatorWidget();
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return pageIndicatorWidget();
            break;
          case ConnectionState.waiting:
            return pageIndicatorWidget();
            break;
          case ConnectionState.active:
            return pageIndicatorWidget();
            break;
          case ConnectionState.done:
            return pageIndicatorWidget();
            break;
        }
      },
    );
  }

  Widget pageIndicatorWidget() {
    return PageIndicator(
        currentIndex: currentPage,
        pageCount: pageList.length,
        onBoardingPageBLoC: _onBoardingPageBLoC);
  }

  Widget finishButtonStreamBuilderWidget(
      DatingAppThemeChanger datingAppThemeChanger) {
    return StreamBuilder(
      stream: pageListrebuildNavigationDataBLoC.stream_counter,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return finishButton(datingAppThemeChanger, context);
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return finishButton(datingAppThemeChanger, context);
            break;
          case ConnectionState.waiting:
            return finishButton(datingAppThemeChanger, context);
            break;
          case ConnectionState.active:
            return finishButton(datingAppThemeChanger, context);
            break;
          case ConnectionState.done:
            return finishButton(datingAppThemeChanger, context);
            break;
        }
      },
    );
  }

  Widget finishButton(
      DatingAppThemeChanger datingAppThemeChanger, BuildContext context) {
    return Positioned(
      right: 30.0,
      bottom: 30.0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: lastPage
            ? FloatingActionButton(
                backgroundColor: datingAppThemeChanger
                    .selectedThemeData.cl_save_Btn, //Color(0xFFF8BBD0),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Icon(
                      OMIcons.save,
                      color: datingAppThemeChanger.selectedThemeData
                          .cl_icon_col_save_Btn, //Colors.white,
                    ),
                    streamBuilderWidgetLoader(
                      navigationDataBLoC_Loader,
                      DatingAppTheme.nearlyDarkBlue,
                      8,
                      false,
                      0,
                      0,
                      null,
                      null,
                    ),
                  ],
                ),
                onPressed: () async {
                  await uploadOnBoarding(context);
                },
              )
            : invisibleWidget(),
      ),
    );
  }

  Widget pageViewerStreamBuilderWidget() {
    return StreamBuilder(
      stream: pageListrebuildNavigationDataBLoC.stream_counter,
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
            return ifToshowPageBuilder(snapshot);
            break;
          case ConnectionState.done:
            return ifToshowPageBuilder(snapshot);
            break;
        }
      },
    );
  }

  Widget swipeLeftToContinueStreamBuilderWidget(
      DatingAppThemeChanger datingAppThemeChanger) {
    return StreamBuilder(
      stream: swipeLeftTocontinueNavigationDataBLoC.stream_counter,
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
            return ifToshowSwipeLeftToContinueText(
              snapshot,
              datingAppThemeChanger,
            );
            break;
          case ConnectionState.done:
            return ifToshowSwipeLeftToContinueText(
              snapshot,
              datingAppThemeChanger,
            );
            break;
        }
      },
    );
  }

  Widget ifToshowPageBuilder(AsyncSnapshot<NavigationData> snapshot) {
    if (snapshot != null) {
      NavigationData navigationData = snapshot.data;
      if (navigationData != null) {
        if (navigationData.pageList != null &&
            navigationData.pageList.length > 0) {
          return pageViewerWidget();
        } else {
          return invisibleWidget();
        }
      } else {
        return invisibleWidget();
      }
    } else {
      return invisibleWidget();
    }
  }

  Widget ifToshowSwipeLeftToContinueText(
    AsyncSnapshot<NavigationData> snapshot,
    DatingAppThemeChanger datingAppThemeChanger,
  ) {
    if (snapshot != null) {
      NavigationData navigationData = snapshot.data;
      if (navigationData != null) {
        if (navigationData.isShow)
        /*if (navigationData.pageList != null &&
            navigationData.pageList.length > 0)*/
        {
          return swipeLeftToContinueText(datingAppThemeChanger);
        } else {
          return invisibleWidget();
        }
      } else {
        return invisibleWidget();
      }
    } else {
      return invisibleWidget();
    }
  }

  Widget swipeLeftToContinueText(DatingAppThemeChanger datingAppThemeChanger) {
    return StreamBuilder(
      stream: _keyBoardVisibleBLoC.stream_counter,
      initialData: false,
      builder: (context, snapshot) {
        return Visibility(
          visible: !snapshot.data,
          child: Positioned(
            right: 5.0,
            bottom: 50.0,
            child: Container(
              width: MediaQuery.of(context).size.width / 3.5,
              child: Text(
                'Swipe left to continue ...',
                style: datingAppThemeChanger
                    .selectedThemeData.default_swp_left_To_Cont_TextStyle,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget pageViewerWidget() {
    return PageView.builder(
      itemCount: pageList.length,
      controller: _controller,
      onPageChanged: (index) {
        setState(() {
          currentPage = index;
          if (currentPage == pageList.length - 1) {
            lastPage = true;
            animationController.forward();
            refreshSwipeLeftTocontinueNavigationDataBLoC(false);
          } else {
            lastPage = false;
            animationController.reset();
            refreshSwipeLeftTocontinueNavigationDataBLoC(true);
          }
          _onBoardingPageBLoC.onBoardingPage_visible_event_sink
              .add(OnBoardingPageChangedEvent(currentPage));
        });
      },
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            var page = pageList[index];
            var delta;
            var y = 1.0;

            if (_controller.position.haveDimensions) {
              delta = _controller.page - index;
              y = 1 - delta.abs().clamp(0.0, 1.0);
            }
            return page.widget;
          },
        );
      },
    );
  }

  uploadOnBoarding(BuildContext context) async {
    refreshLoader(true, navigationDataBLoC_Loader);
    refresh_W_Data_NavigationDataBLoC(
        saved_Clicked_NavigationDataBLoC, NavigationData());
    String TAG = 'uploadOnBoarding:';
    if (recentOnboarding != null) {
      Onboarding updatedOnboarding =
          await database.onboardingDao.getOnboardingById(recentOnboarding.id);
      print('MY ID==');
      print(updatedOnboarding.id);
      recentOnboarding = updatedOnboarding;
      if (updatedOnboarding != null) {
        //pr.show();
        //EMAIL
        print('email=');
        print(updatedOnboarding.email);
        /*if (!ifStringValid(updatedOnboarding.email)) {
          showSnackbarWBgCol(
              'Enter a valid email', builderContext, DatingAppTheme.red);
          return;
        }*/
        if (!isStringValid(updatedOnboarding.email)) {
          showSnackbarWBgCol(
              'Enter a valid email', builderContext, DatingAppTheme.red);
          refreshLoader(false, navigationDataBLoC_Loader);
          return;
        } else {
          RegExp regex = new RegExp(get_Email_Pattern());
          if (!regex.hasMatch(updatedOnboarding.email)) {
            showSnackbarWBgCol('Email should be in the format name@domain.com',
                builderContext, DatingAppTheme.red);
            refreshLoader(false, navigationDataBLoC_Loader);
            return;
          }
        }

        bool user_exists_email = await post_validate_email(
          context,
          null,
          updatedOnboarding.email,
          null,
        );
        if (user_exists_email) {
          refreshLoader(false, navigationDataBLoC_Loader);
          showSnackbarWBgCol('User with this email exists', builderContext,
              DatingAppTheme.red);
          return;
        }

        //END OF EMAIL

        //FIRST NAME
        print('firstname=');
        print(updatedOnboarding.firstname);
        if (!ifStringValid(updatedOnboarding.firstname)) {
          showSnackbarWBgCol(
              'Enter a valid first name', builderContext, DatingAppTheme.red);
          refreshLoader(false, navigationDataBLoC_Loader);
          return;
        }

        //END OF FIRST NAME

        //LAST NAME
        print('lastname=');
        print(updatedOnboarding.lastname);
        if (!ifStringValid(updatedOnboarding.lastname)) {
          showSnackbarWBgCol(
              'Enter a valid last name', builderContext, DatingAppTheme.red);
          refreshLoader(false, navigationDataBLoC_Loader);
          return;
        }
        //END OF LAST NAME

        //PHONE NUMBER
        print('phone_number=');
        print(updatedOnboarding.phone_number);
        /*if (!ifStringValid(updatedOnboarding.phone_number)) {
          showSnackbarWBgCol(
              'Enter a valid phone number', builderContext, DatingAppTheme.red);
          return;
        }*/

        if (!isStringValid(updatedOnboarding.phone_number)) {
          showSnackbarWBgCol(
              'Enter a valid phone number', builderContext, DatingAppTheme.red);
          refreshLoader(false, navigationDataBLoC_Loader);
          return;
        }

        bool user_exists_phoneno = await post_validate_phone_no(
          context,
          null,
          updatedOnboarding.phone_number,
          null,
        );
        if (user_exists_phoneno) {
          refreshLoader(false, navigationDataBLoC_Loader);
          showSnackbarWBgCol('User with this phone no. exists', builderContext,
              DatingAppTheme.red);
          return;
        }
        /*else {
          List<String> strList = updatedOnboarding.phone_number.split('');
          List<String> stringsNotnumeric = [];
          for (String str in strList) {
            bool isnumeric = isNumeric(str);
            if (!isnumeric) {
              stringsNotnumeric.add(str);
            }
          }
          if (stringsNotnumeric.length > 0) {
            showSnackbarWBgCol(
                'Invalid Phone No.', builderContext, DatingAppTheme.red);
            refreshLoader(false, navigationDataBLoC_Loader);
            return;
          } else {
            RegExp regex = new RegExp(get_PhoneNo_Pattern());
            if (!regex.hasMatch(updatedOnboarding.phone_number)) {
              showSnackbarWBgCol(
                  'Invalid Phone No.', builderContext, DatingAppTheme.red);
              refreshLoader(false, navigationDataBLoC_Loader);
              return;
            }
          }
        }*/

        //END OF PHONE NUMBER

        //username
        print('username=');
        print(updatedOnboarding.username);
        if (!ifStringValid(updatedOnboarding.username)) {
          showSnackbarWBgCol(
              'Enter a valid username', builderContext, DatingAppTheme.red);
          refreshLoader(false, navigationDataBLoC_Loader);
          return;
        }
        bool user_exists = await post_validate_user_name(
          context,
          null,
          updatedOnboarding.username,
          null,
        );
        if (user_exists) {
          showSnackbarWBgCol('User with this username exists', builderContext,
              DatingAppTheme.red);
          refreshLoader(false, navigationDataBLoC_Loader);
          return;
        }
        //END OF USERNAME

        //PASSWORD
        print('password=');
        print(updatedOnboarding.password);
        /*if (!ifStringValid(updatedOnboarding.password)) {
          showSnackbarWBgCol(
              'Enter a valid password', builderContext, DatingAppTheme.red);
          return;
        }*/

        if (!ifStringValid(updatedOnboarding.password)) {
          showSnackbarWBgCol('Invalid password/Check if passwords match.',
              builderContext, DatingAppTheme.red);
          refreshLoader(false, navigationDataBLoC_Loader);
          return;
        }
        if (!(updatedOnboarding.password.length >= 5)) {
          showSnackbarWBgCol('Password minimum is 5 characters', builderContext,
              DatingAppTheme.red);
          refreshLoader(false, navigationDataBLoC_Loader);
          return;
        }

        //END OF PASSWORD

        //BIRTHDAY
        print('birthday=');
        print(updatedOnboarding.birthday);
        /*if (!ifStringValid(updatedOnboarding.birthday)) {
          showSnackbarWBgCol(
              'Enter a valid birthday', builderContext, DatingAppTheme.red);
          return;
        }*/
        if (!isStringValid(updatedOnboarding.birthday)) {
          showSnackbarWBgCol(
              'Enter a valid birth date', builderContext, DatingAppTheme.red);
          refreshLoader(false, navigationDataBLoC_Loader);
          return;
        }
        try {
          DateTime dateTimeFromFormat =
              birthday_format.parseStrict(updatedOnboarding.birthday);
          if (isAdult(dateTimeFromFormat)) {
            DateTime today = DateTime.now();
            int yearDiff = today.year - dateTimeFromFormat.year;
            if (yearDiff > 100) {
              showSnackbarWBgCol('Your age must not be 100+', builderContext,
                  DatingAppTheme.red);
              refreshLoader(false, navigationDataBLoC_Loader);
              return;
            }
          } else {
            showSnackbarWBgCol(
                'Your age must not be 18+', builderContext, DatingAppTheme.red);
            refreshLoader(false, navigationDataBLoC_Loader);
            return;
          }
        } catch (error) {
          showSnackbarWBgCol(
              'Enter a valid birth date', builderContext, DatingAppTheme.red);
          refreshLoader(false, navigationDataBLoC_Loader);
          return;
        }

        //END OF BIRTHDAY

        //FB LINK
        print('fblink=');
        print(updatedOnboarding.fb_link);
        if (!is_Link_Valid(updatedOnboarding.fb_link)) {
          showSnackbarWBgCol('Enter a valid facebook link', builderContext,
              DatingAppTheme.red);
          refreshLoader(false, navigationDataBLoC_Loader);
          return;
        }
        //END OF FB LINK

        //INSTAGRAM LINK
        print('instalink=');
        print(updatedOnboarding.insta_link);
        if (!is_Link_Valid(updatedOnboarding.insta_link)) {
          showSnackbarWBgCol('Enter a valid instagram link', builderContext,
              DatingAppTheme.red);
          refreshLoader(false, navigationDataBLoC_Loader);
          return;
        }
        //END OF INSTAGRAM LINK

        //PROFILE PICTURE
        print('profpicpath=');
        print(updatedOnboarding.profpicpath);
        /*if (!ifStringValid(updatedOnboarding.profpicpath)) {
          showSnackbarWBgCol('Choose a valid profile picture', builderContext,
              DatingAppTheme.red);
          return;
        }*/
        if (!isStringValid(updatedOnboarding.profpicpath)) {
          showSnackbarWBgCol('Choose a valid profile picture', builderContext,
              DatingAppTheme.red);
          refreshLoader(false, navigationDataBLoC_Loader);
          return;
        }
        //END OF PROFILE PICTURE

        //END OF Initial_Personal_Info

        //try {
        Gender iamObj = await genderDao.getGenderById(updatedOnboarding.iam);
        try {
          if (iamObj == null) {
            showSnackbarWBgCol(
                'Pick your gender', builderContext, DatingAppTheme.red);
            refreshLoader(false, navigationDataBLoC_Loader);
            return;
          }
          print('iamObj');
          print(iamObj.id.toString());
        } catch (error) {}
        //END OF Iam_OB_Page
        Gender searchingforObj =
            await genderDao.getGenderById(updatedOnboarding.searchingfor);
        try {
          if (searchingforObj == null) {
            showSnackbarWBgCol('Please pick what you are searching for',
                builderContext, DatingAppTheme.red);
            refreshLoader(false, navigationDataBLoC_Loader);
            return;
          }
          print('searchingforObj');
          print(searchingforObj.id.toString());
        } catch (error) {}
        //END OF Searching_For_OB_Page
        Relationshipstatuse relationshipstatusObj = await relationshipstatusDao
            .getRelationshipstatuseById(updatedOnboarding.relationshipstatus);
        try {
          if (relationshipstatusObj == null) {
            showSnackbarWBgCol('Please pick your relationship status',
                builderContext, DatingAppTheme.red);
            refreshLoader(false, navigationDataBLoC_Loader);
            return;
          }
          print('relationshipstatusObj');
          print(relationshipstatusObj.id.toString());
        } catch (error) {}
        //END OF  Rel_Status_OB_Page
        Smokestatuse do_you_smokeObj = await smokestatusDao
            .getSmokestatuseById(updatedOnboarding.do_you_smoke);
        try {
          if (do_you_smokeObj == null) {
            showSnackbarWBgCol(
                'Please pick if you smoke', builderContext, DatingAppTheme.red);
            refreshLoader(false, navigationDataBLoC_Loader);
            return;
          }
          print('do_you_smokeObj');
          print(do_you_smokeObj.id.toString());
        } catch (error) {}
        //END OF Do_You_Smoke_OB_Page
        Educationlevel education_levelObj = await educationLevelDao
            .getEducationlevelById(updatedOnboarding.education_level);
        try {
          if (education_levelObj == null) {
            showSnackbarWBgCol('Please pick your education level',
                builderContext, DatingAppTheme.red);
            refreshLoader(false, navigationDataBLoC_Loader);
            return;
          }
          print('education_levelObj');
          print(education_levelObj.id.toString());
        } catch (error) {}
        //END OF Edu_Level_OB_Page
        Wantchildrenstatuse want_childrenObj = await wantchildrenstatusDao
            .getWantchildrenstatuseById(updatedOnboarding.want_children);
        try {
          if (want_childrenObj == null) {
            showSnackbarWBgCol('Please choose if you want children',
                builderContext, DatingAppTheme.red);
            refreshLoader(false, navigationDataBLoC_Loader);
            return;
          }
          print('want_childrenObj');
          print(want_childrenObj.id.toString());
        } catch (error) {}
        //END OF Do_You_WChildr_OB_Page
        Drinkstatuse often_you_drinkObj = await drinkstatusDao
            .getDrinkstatuseById(updatedOnboarding.often_you_drink);
        try {
          if (often_you_drinkObj == null) {
            showSnackbarWBgCol('Please choose how often you drink',
                builderContext, DatingAppTheme.red);
            refreshLoader(false, navigationDataBLoC_Loader);
            return;
          }
          print('often_you_drinkObj');
          print(often_you_drinkObj.id.toString());
        } catch (error) {}
        //END OF How_Oftn_Drink_OB_Page
        Ethnicitie ethnicityObj =
            await ethnicityDao.getEthnicitieById(updatedOnboarding.ethnicity);
        try {
          if (ethnicityObj == null) {
            showSnackbarWBgCol('Please choose your ethnicity', builderContext,
                DatingAppTheme.red);
            refreshLoader(false, navigationDataBLoC_Loader);
            return;
          }
          print('ethnicityObj');
          print(ethnicityObj.id.toString());
        } catch (error) {}
        //END OF Which_Ethnicity_Desc_You_OB_Page

        Religion religionObj =
            await religionDao.getReligionById(updatedOnboarding.religion);
        try {
          if (religionObj == null) {
            showSnackbarWBgCol('Please choose your religion', builderContext,
                DatingAppTheme.red);
            refreshLoader(false, navigationDataBLoC_Loader);
            return;
          }
          print('religionObj');
          print(religionObj.id.toString());
        } catch (error) {}
        //END OF Your_Religion_OB_Page

        if (!isIntValid(updatedOnboarding.herage_low)) {
          showSnackbarWBgCol('Please choose your date\'s age range',
              builderContext, DatingAppTheme.red);
          refreshLoader(false, navigationDataBLoC_Loader);
          return;
        }
        print('herage_low=');
        print(updatedOnboarding.herage_low);

        if (!isIntValid(updatedOnboarding.herage_high)) {
          showSnackbarWBgCol('Please choose your date\'s age range',
              builderContext, DatingAppTheme.red);
          refreshLoader(false, navigationDataBLoC_Loader);
          return;
        }
        print('herage_high=');
        print(updatedOnboarding.herage_high);
        //END OF Her_Age_OB_Page
        /*List<OnboardingsomethingspecificReqJModel>
            onboardingsomethingspecificReqJModelList = [];*/
        /*int nosspec = await database.onboardingsomethingspecificDao
              .countOnboardingsomethingspecific();
          if (!isIntValid(nosspec)) {
            showSnackbar('Please chhoose your specific items', builderContext);
            return;
          } else {
            List<OnboardingsomethingspecificJoinClass>
                onboardingsomethingspecificJoinClassList = await database
                    .onboardingsomethingspecificDao
                    .getOnboardingsomethingspecificJoinClassByOnboardingId(
                        updatedOnboarding.id);
            for (OnboardingsomethingspecificJoinClass onsomspec
                in onboardingsomethingspecificJoinClassList) {
              OnboardingsomethingspecificReqJModel
                  onboardingsomethingspecificReqJModel =
                  OnboardingsomethingspecificReqJModel();
              onboardingsomethingspecificReqJModel.somethingspecificid =
                  onsomspec.somethingspecific.onlineid;
              onboardingsomethingspecificReqJModel.onboardingid =
                  ((isIntValid(onsomspec.onboarding.onlineid)
                      ? onsomspec.onboarding.onlineid
                      : 0));
              onboardingsomethingspecificReqJModelList
                  .add(onboardingsomethingspecificReqJModel);
            }
          }*/

        //END OF Looking_Smth_Specific_OB_Page

        List<OnboardinginterestJoinClass> onboardinginterestJoinClassList =
            await database.onboardinginterestDao
                .getOnboardinginterestJoinClassByOnboardingId(
                    updatedOnboarding.id);
        if (!isIntValid(onboardinginterestJoinClassList.length)) {
          showSnackbarWBgCol('Please choose your interests', builderContext,
              DatingAppTheme.red);
          refreshLoader(false, navigationDataBLoC_Loader);
          return;
        }
        //END OF What_Your_Interests_OB_Page

        //USER ILLNESS
        List<OnboardinguserillnessJoinClass>
            onboardinguserillnessJoinClassList = await database
                .onboardinguserillnessDao
                .getOnboardinguserillnessJoinClassByOnboardingId(
                    updatedOnboarding.id);

        if (!isIntValid(onboardinguserillnessJoinClassList.length) &&
            updatedOnboarding.have_chronic_illness) {
          showSnackbarWBgCol('Please select illnesses you have', builderContext,
              DatingAppTheme.red);
          refreshLoader(false, navigationDataBLoC_Loader);
          return;
        }
        //END OF USER ILLNESS

        List<OnboardingmoneyshemakesJoinClass>
            onboardingmoneyshemakesJoinClassList = await database
                .onboardingmoneyshemakeDao
                .getOnboardingmoneyshemakesJoinClassByOnboardingId(
                    updatedOnboarding.id);
        if (!isIntValid(onboardingmoneyshemakesJoinClassList.length)) {
          showSnackbarWBgCol('Please choose money your date should make',
              builderContext, DatingAppTheme.red);
          refreshLoader(false, navigationDataBLoC_Loader);
          return;
        }
        //END OF Money_Shld_She_Make_OB_Page

        Drinkstatuse want_date_to_drinkObj = await drinkstatusDao
            .getDrinkstatuseById(updatedOnboarding.want_date_to_drink);
        try {
          if (want_date_to_drinkObj == null) {
            showSnackbarWBgCol('Please choose if you want your date to drink',
                builderContext, DatingAppTheme.red);
            refreshLoader(false, navigationDataBLoC_Loader);
            return;
          }
          print('want_date_to_drinkObj');
          print(want_date_to_drinkObj.id.toString());
        } catch (error) {}
        //END OF Do_You_Wnt_Date_Drink_OB_Page

        print('little_about_self=');
        print(updatedOnboarding.little_about_self);
        if (!ifStringValid(updatedOnboarding.little_about_self)) {
          showSnackbarWBgCol('Please write a little about yourself',
              builderContext, DatingAppTheme.red);
          refreshLoader(false, navigationDataBLoC_Loader);
          return;
        }
        //END OF A_Little_About_Self

        Educationlevel picky_abt_her_educationObj = await educationLevelDao
            .getEducationlevelById(updatedOnboarding.picky_abt_her_education);
        try {
          if (picky_abt_her_educationObj == null) {
            showSnackbarWBgCol('Please choose your date\'s education level',
                builderContext, DatingAppTheme.red);
            refreshLoader(false, navigationDataBLoC_Loader);
            return;
          }
          print('picky_abt_her_educationObj');
          print(picky_abt_her_educationObj.id.toString());
        } catch (error) {}
        //END OF Picky_About_Her_Education
        //print('onboardinginterestReqJModelList==');
        //print(json.encode(onboardinginterestReqJModelList));
        /*print('onboardingmoneyshemakeReqJModelList==');
        print(json.encode(onboardingmoneyshemakeReqJModelList));*/
        /*print('onboardingsomethingspecificReqJModelList==');
        print(json.encode(onboardingsomethingspecificReqJModelList));*/

/*          var response =
              await Provider.of<PostApiService>(context).onboarding(
            "application/json",
            updatedOnboarding.username,
            updatedOnboarding.password,
            updatedOnboarding.email,
            updatedOnboarding.birthday,
            updatedOnboarding.little_about_self,
            updatedOnboarding.profpicpath,
            iamObj.onlineid,
            searchingforObj.onlineid,
            relationshipstatusObj.onlineid,
            do_you_smokeObj.onlineid,
            education_levelObj.onlineid,
            want_childrenObj.onlineid,
            often_you_drinkObj.onlineid,
            ethnicityObj.onlineid,
            religionObj.onlineid,
            want_date_to_drinkObj.onlineid,
            picky_abt_her_educationObj.onlineid,
            updatedOnboarding.herage_low,
            updatedOnboarding.herage_high,
            json.encode(onboardinginterestReqJModelList),
            json.encode(onboardingmoneyshemakeReqJModelList),
            json.encode(onboardingsomethingspecificReqJModelList),
          );

          Map<String, dynamic> map = response.body;
          dissmissPDialog(pr);
          String errorrMsgStr = 'An error ocurred';
          showSnackbarWBgCol(
              ((map['message'] != null ? map['message'] : errorrMsgStr)),
              builderContext,
              ((map['message'] != null && map['message'] != errorrMsgStr
                  ? DatingAppTheme.green
                  : DatingAppTheme.red)));*/

/*        var response =
            await Provider.of<PostApiService>(context).customusers(
          updatedOnboarding.username,
          updatedOnboarding.password,
          updatedOnboarding.email,
          updatedOnboarding.birthday,
          updatedOnboarding.little_about_self,
          updatedOnboarding.profpicpath,
          iamObj.onlineid,
          searchingforObj.onlineid,
          relationshipstatusObj.onlineid,
          do_you_smokeObj.onlineid,
          education_levelObj.onlineid,
          want_childrenObj.onlineid,
          often_you_drinkObj.onlineid,
          ethnicityObj.onlineid,
          religionObj.onlineid,
          want_date_to_drinkObj.onlineid,
          picky_abt_her_educationObj.onlineid,
          updatedOnboarding.herage_low,
          updatedOnboarding.herage_high,
          updatedOnboarding.username,
          updatedOnboarding.username,
        );*/
        /*int statusCode = response.statusCode;
        print(TAG + ' response==');
        print(response.toString());*/

        displaySnackBarWithDelay(
            'Registering...', DatingAppTheme.nearlyDarkBlue, builderContext);

        bool isprofilepictureSaved = false;
        bool is_post_put_onboardings = await post_put_onboardings(
          context,
          null,
          updatedOnboarding,
          null,
          iamObj,
          searchingforObj,
          do_you_smokeObj,
          education_levelObj,
          want_childrenObj,
          often_you_drinkObj,
          ethnicityObj,
          religionObj,
          want_date_to_drinkObj,
          picky_abt_her_educationObj,
          relationshipstatusObj,
        );
        if (is_post_put_onboardings) {
          updatedOnboarding = await database.onboardingDao
              .getOnboardingById(updatedOnboarding.id);
          if (isIntValid(updatedOnboarding.onlineid)) {
            try {
              UserUserProfileReqJModel userUserProfileReqJModel =
                  UserUserProfileReqJModel();
              userUserProfileReqJModel.localfilepath =
                  updatedOnboarding.profpicpath;
              userUserProfileReqJModel.users = updatedOnboarding.onlineid;
              userUserProfileReqJModel.isprofilepicture = true;
              userUserProfileReqJModel.users = updatedOnboarding.onlineid;
              userUserProfileReqJModel.id =
                  updatedOnboarding.userprofile_onlineid;

              UserUserProfileReqJModel userUserProfileReqJModelFrmServer =
                  await put_post_user_usersProfiles(
                context,
                null,
                userUserProfileReqJModel,
                null,
                null,
                true,
              );
              if (userUserProfileReqJModelFrmServer != null &&
                  isIntValid(userUserProfileReqJModelFrmServer.id)) {
                Onboarding onboardingToUpdate = updatedOnboarding.copyWith(
                    userprofile_onlineid: userUserProfileReqJModelFrmServer.id);
                bool isUpdated = await database.onboardingDao
                    .updateOnboarding(onboardingToUpdate);
                if (isUpdated) {
                  updatedOnboarding = onboardingToUpdate;
                }
              } else {
                refreshLoader(false, navigationDataBLoC_Loader);
                displaySnackBarWithDelay('Profile picture not saved',
                    DatingAppTheme.red, builderContext);
                return;
              }

              await batch_post_put_onboardingInterest(
                context,
                null,
                updatedOnboarding,
                null,
                onboardinginterestJoinClassList,
              );

              await batch_post_put_onboardingMoneySheShldmake(
                context,
                null,
                updatedOnboarding,
                null,
                onboardingmoneyshemakesJoinClassList,
              );

              if (isIntValid(onboardinguserillnessJoinClassList.length)) {
                await batch_post_put_onboardingUserIllness(
                  context,
                  null,
                  updatedOnboarding,
                  null,
                  onboardinguserillnessJoinClassList,
                );
              }

              /*await batch_post_put_onboardingSomethingSpecific(
              context,
              builderContext,
              updatedOnboarding,
              null,
              onboardingsomethingspecificReqJModelList,
            );*/

              refreshLoader(false, navigationDataBLoC_Loader);
              displaySnackBarWith_6sec_Delay('Registration successful',
                  DatingAppTheme.green, builderContext);
              Toast.show("Registration successful", builderContext,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.BOTTOM,
                  backgroundColor: DatingAppTheme.green,
                  textColor: DatingAppTheme.white,
                  backgroundRadius: 10);
              try {
                refreshLoader(true, navigationDataBLoC_Loader);
                displaySnackBarWith_6sec_Delay(
                    'Logging In...', DatingAppTheme.green, builderContext);
                post_User_Login(
                  context,
                  builderContext,
                  updatedOnboarding.username,
                  updatedOnboarding.password,
                  navigationDataBLoC_Loader,
                );
              } catch (error) {
                refreshLoader(false, navigationDataBLoC_Loader);
              }
            } catch (error) {
              dissmissPDialog(pr);
              showSnackbarWBgCol(
                  'An error ocurred', builderContext, DatingAppTheme.red);
              print(TAG + ' error==');
              print(error.toString());
            }
          } else {
            refreshLoader(false, navigationDataBLoC_Loader);
            dissmissPDialog(pr);
            showSnackbarWBgCol(
                'An error ocurred', builderContext, DatingAppTheme.red);
          }
        } else {
          refreshLoader(false, navigationDataBLoC_Loader);
          dissmissPDialog(pr);
          showSnackbarWBgCol(
              'An error ocurred', builderContext, DatingAppTheme.red);
        }
        /*} catch (error) {
          print('error1==${error}');
          dissmissPDialog(pr);
          showSnackbarWBgCol(
              'An error ocurred', builderContext, DatingAppTheme.red);
        }*/
      } else {
        refreshLoader(false, navigationDataBLoC_Loader);
        showSnackbarWBgCol(
            'Data not saved', builderContext, DatingAppTheme.red);
      }
    } else {
      refreshLoader(false, navigationDataBLoC_Loader);
      showSnackbarWBgCol('Data not saved', builderContext, DatingAppTheme.red);
    }
  }

  void dissmissPDialog(ProgressDialog pr) {
    if (pr != null && pr.isShowing()) {
      pr.hide().then((isHidden) {
        print(isHidden);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void functionOnBoardingChanged(Onboarding onboarding) {
    //setState(() {
    recentOnboarding = onboarding;
    //});
    recentOnBoardingChangedOnBoardingClickableItemBLoC
        .onboarding_itemclicked_event_sink
        .add(OneItemClickedEvent(1));
    print('I AM TRIGGERED IN ONBOARDING CONCEPT');
    print('iam==');
    print(recentOnboarding.iam.toString());
    print('recentOnboarding id');
    print(recentOnboarding.id.toString());
  }
}

typedef IntindexCallback = void Function(Onboarding onboarding);
