import 'dart:async';
import 'dart:io';

import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleBLoC.dart';
import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleEvent.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_customusers_online.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_datematchdecisions_online.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_genders_online.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_user_usersProfiles.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_put_match.dart';
import 'package:dating_app/CustomWidgets/dropdowns/CustomUserPickerOnline.dart';
import 'package:dating_app/CustomWidgets/dropdowns/MatchDecisionPickerOnline.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/gender/GenderListRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/gender/GenderRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/DateMatchRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/MatchDecisionListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/MatchDecisionRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/matches/DateMatchReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/UserProfileRespModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/CustomWidgets/CustomTitleView.dart';
import 'package:dating_app/UI/Presentation/ExpandedBubbleChip/ExpandedBubbleChip.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/UI/Presentation/admin_drawer/home_drawer.dart';
import 'package:dating_app/UI/Presentation/builders/column_builder.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:after_layout/after_layout.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'dart:math' as math;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdminCreateEditMatch extends StatefulWidget {
  DateMatchReqJModel dateMatchReqJModel;
  DateMatchRespJModel dateMatchRespJModel;
  AdminCreateEditMatch({
    this.dateMatchReqJModel,
    this.dateMatchRespJModel,
    Key key,
  }) : super(key: key);

  @override
  _AdminCreateEditMatchState createState() => _AdminCreateEditMatchState();
}

class _AdminCreateEditMatchState extends State<AdminCreateEditMatch>
    with TickerProviderStateMixin, AfterLayoutMixin<AdminCreateEditMatch> {
  Widget screenView;
  DrawerIndex drawerIndex;
  AnimationController sliderAnimationController;

  Animation<double> topBarAnimation;
  Animation<double> animation;

  ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  AnimationController animationController;
  Animation<double> _scaleAnimation;
  AnimationController _controller;
  KeyBoardVisibleBLoC keyBoardVisibleBLoC = KeyBoardVisibleBLoC();
  NavigationDataBLoC navigationDataBLoC_Loader = NavigationDataBLoC();
  RefreshController _refreshController = RefreshController();
  bool _autoValidateF1 = false;
  GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  BuildContext snackbarBuildContext;

  //DROPDOWNS STATES
  NavigationDataBLoC onCustomUserRespJModelsChanged_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC selectedCustomUserRespJModelChanged_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC
      selectedCustomUserRespJModelChanged_NavigationDataBLoC_Match_To =
      NavigationDataBLoC();
  NavigationDataBLoC selectedCustomUserRespJModel_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC selectedCustomUserRespJModel_Match_To_NavigationDataBLoC =
      NavigationDataBLoC();

  NavigationDataBLoC onMatchDecisionRespJModelsChanged_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC selectedMatchDecisionRespJModel_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC selectedMatchDecisionRespJModelChanged_NavigationDataBLoC =
      NavigationDataBLoC();

  NavigationDataBLoC on_isuserrequested_Val_Changed_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC on_isApproved_Val_Changed_NavigationDataBLoC =
      NavigationDataBLoC();

  NavigationDataBLoC on_isActive_Val_Changed_NavigationDataBLoC =
      NavigationDataBLoC();

  NavigationDataBLoC interested_in_Changed_DailySubTaskImagesBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC onGenderRespModelsChanged_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC selectedGenderRespModel_NavigationDataBLoC =
      NavigationDataBLoC();

  NavigationDataBLoC on_rvalues_Changed_NavigationDataBLoC =
      NavigationDataBLoC();

  NavigationDataBLoC wd_fbinsta_Container_NavigationDataBLoC =
      NavigationDataBLoC();

  int _interested_in_RadioValue = -1;
  List<GenderRespModel> allGenderRespModelList = [];
  GenderRespModel selectedGenderRespModel;
  //END OF DROPDOWN STATES
  List<CustomUserRespJModel> allCustomUserRespJModelList = [];
  CustomUserRespJModel selected_CustomUserRespJModel;
  CustomUserRespJModel selected_CustomUserRespJModel_Match_To;
  MatchDecisionRespJModel selected_MatchDecisionRespJModel;
  NavigationDataBLoC validateagainstChanged = NavigationDataBLoC();
  NavigationDataBLoC validateagainstChanged_Match_To = NavigationDataBLoC();

  //DECISION DROPDOWN
  List<MatchDecisionRespJModel> allMatchDecisionRespJModelList = [];

  //Isuser request
  bool isuserrequested_Val = false;
  bool isApproved_Val = false;
  bool isActive_Val = false;

  RangeValues _rvalues = new RangeValues(18, 100);

  FocusNode fbinsta_FocusNode = FocusNode();
  TextEditingController fbinsta_TextEditingController = TextEditingController();

  NavigationDataBLoC onInternetConnectionToggle_DailySubTaskImagesBLoC =
      NavigationDataBLoC();

  //IMAGE PAGER
  List<UserProfileRespModel> match_To_UserProfileRespModelList = [];
  List<UserProfileRespModel> user_UserProfileRespModelList = [];
  NavigationDataBLoC onPageChangedDots_DailySubTaskImagesBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC user_onPageChangedDots_DailySubTaskImagesBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC
      match_To_UserProfileRespModelList_Changed_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC user_UserProfileRespModelList_Changed_NavigationDataBLoC =
      NavigationDataBLoC();

  CarouselController imagesCarouselController = CarouselController();
  CarouselController user_imagesCarouselController = CarouselController();
  double currentImageSwiper_Position = 0;
  double user_currentImageSwiper_Position = 0;
  AutoScrollController autoScrollController = AutoScrollController(
    axis: Axis.horizontal,
  );
  AutoScrollController user_autoScrollController = AutoScrollController(
    axis: Axis.horizontal,
  );
  //INTERNET
  var internetListenersubscription;
  //END OF INTERNET

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval((1 / 9) * 5, 1.0, curve: Curves.fastOutSlowIn)));

    _controller = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween(begin: 0.6, end: 1.0).animate(animationController);

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    addListeners();
    listenToInternetStatus();
    setUpData(
      context,
      true,
    );
  }

  //AFTER FIRST LAYOUT FUNCTIONS
  addListeners() {
    KeyboardVisibility.onChange.listen(
      (bool visible) {
        keyBoardVisibleBLoC.keyboard_visible_event_sink
            .add(ToggleKeyBoardVisEvent(visible));
      },
    );
  }

  listenToInternetStatus() async {
    String TAG = 'NEEEET connected:';
    internetListenersubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      //refresh here
      if (result != ConnectivityResult.none) {
      } else {}
    });
  }

  setUpData(BuildContext context, bool isInitial) async {
    //LNK
    if (isStringValid(widget.dateMatchRespJModel.fb_insta_link)) {
      fbinsta_TextEditingController.text =
          widget.dateMatchRespJModel.fb_insta_link;
    }
    //AGE

    if (widget.dateMatchRespJModel.age_low != null ||
        widget.dateMatchRespJModel.age_high != null) {
      int lowval = null;
      int highval = null;
      if (widget.dateMatchRespJModel.age_low != null) {
        lowval = widget.dateMatchRespJModel.age_low;
      }
      if (widget.dateMatchRespJModel.age_high != null) {
        highval = widget.dateMatchRespJModel.age_high;
      }

      _rvalues = new RangeValues(((lowval != null ? lowval.toDouble() : 18)),
          ((highval != null ? highval.toDouble() : 100)));
      refresh_on_rvalues_Changed_NavigationDataBLoC();
    }
    //isuserrequested
    if (widget.dateMatchRespJModel.isuserrequested != null) {
      isuserrequested_Val = widget.dateMatchRespJModel.isuserrequested;
      refresh_on_isuserrequested_Val_Changed_NavigationDataBLoC();
    }
    //isApproved
    if (widget.dateMatchRespJModel.approved != null) {
      isApproved_Val = widget.dateMatchRespJModel.approved;
      refresh_on_isApproved_Val_Changed_NavigationDataBLoC();
    }

    //isActive
    if (widget.dateMatchRespJModel.active != null) {
      isActive_Val = widget.dateMatchRespJModel.active;
      refresh_on_isActive_Val_Changed_NavigationDataBLoC();
    }
    //QUERY fks
    print('widget.dateMatchRespJModel.match_to==');
    print(widget.dateMatchRespJModel.match_to.toString());
    if (widget.dateMatchRespJModel.match_to != null) {
      selected_CustomUserRespJModel_Match_To =
          widget.dateMatchRespJModel.match_to;
      widget.dateMatchReqJModel.match_to =
          selected_CustomUserRespJModel_Match_To.id;
      refresh_selectedCustomUserRespJModelChanged_NavigationDataBLoC_Match_To();
      refresh_selectedCustomUserRespJModel_Match_To_NavigationDataBLoC(false);
      refresh_validateagainstChanged(
        [widget.dateMatchReqJModel.match_to],
        validateagainstChanged,
      );
    }

    print('widget.dateMatchRespJModel.matching_user==');
    print(widget.dateMatchRespJModel.matching_user.toString());
    if (widget.dateMatchRespJModel.matching_user != null) {
      selected_CustomUserRespJModel = widget.dateMatchRespJModel.matching_user;
      widget.dateMatchReqJModel.matching_user =
          selected_CustomUserRespJModel.id;
      refresh_selectedCustomUserRespJModelChanged_NavigationDataBLoC();
      refresh_selectedCustomUserRespJModel_NavigationDataBLoC(false);
      refresh_validateagainstChanged(
        [widget.dateMatchReqJModel.matching_user],
        validateagainstChanged_Match_To,
      );
    }

    if (widget.dateMatchRespJModel.decision != null) {
      selected_MatchDecisionRespJModel = widget.dateMatchRespJModel.decision;
      widget.dateMatchReqJModel.decision = selected_MatchDecisionRespJModel.id;
      refresh_selectedMatchDecisionRespJModelChanged_NavigationDataBLoC();
      refresh_selectedMatchDecisionRespJModel_NavigationDataBLoC(false);
    }

    await fetchRefresh_allGenderList(context);
    await fetchRefresh_allCustomUserList(context);
    await fetchRefresh_allMatchDecisionList(context);
    //END OF QUERY FKS
  }
  //END OF AFTER FIRST LAYOUT FUNCTIONS

  //QUERIES
  fetchRefresh_allCustomUserList(BuildContext context) async {
    CustomUserListRespJModel customUserListRespJModel =
        await fetch_customusers_online_limit(
      context,
      DatingAppStaticParams.default_Max_int,
    );
    if (customUserListRespJModel != null) {
      allCustomUserRespJModelList = customUserListRespJModel.results;
      refresh_onCustomUserRespJModelsChanged_NavigationDataBLoC();
    }
  }

  fetchRefresh_allMatchDecisionList(BuildContext context) async {
    MatchDecisionListRespJModel matchDecisionListRespJModel =
        await fetch_datematchdecisions_online_limit(
      context,
      DatingAppStaticParams.default_Max_int,
    );
    if (matchDecisionListRespJModel != null) {
      allMatchDecisionRespJModelList = matchDecisionListRespJModel.results;
      refresh_onMatchDecisionRespJModelsChanged_NavigationDataBLoC();
    }
  }

  fetchRefresh_allGenderList(BuildContext context) async {
    GenderListRespModel genderListRespModel =
        await fetch_genders_online_limit_without_prefernottosay(
      context,
      DatingAppStaticParams.default_Max_int,
      false.toString(),
    );
    if (genderListRespModel != null) {
      allGenderRespModelList = genderListRespModel.results;
      refresh_onGenderRespModelsChanged_NavigationDataBLoC();
      remap_Interested_In();
    }
  }

  remap_Interested_In() {
    if (widget.dateMatchRespJModel.interestedin != null) {
      selectedGenderRespModel = allGenderRespModelList.firstWhere(
          (obj) => obj.id == widget.dateMatchRespJModel.interestedin.id,
          orElse: () => null);
      if (selectedGenderRespModel != null) {
        widget.dateMatchReqJModel.interestedin = selectedGenderRespModel.id;
        _interested_in_RadioValueChange(widget.dateMatchReqJModel.interestedin);
      }
    }
  }
  //END OF QUERIES

  //STATE CHANGES
  refresh_onCustomUserRespJModelsChanged_NavigationDataBLoC() {
    refresh_WO_Data_NavigationDataBLoC(
        onCustomUserRespJModelsChanged_NavigationDataBLoC);
  }

  refresh_selectedCustomUserRespJModelChanged_NavigationDataBLoC() {
    NavigationData navigationData = NavigationData();
    navigationData.customUserRespJModel = selected_CustomUserRespJModel;
    refresh_W_Data_NavigationDataBLoC(
        selectedCustomUserRespJModelChanged_NavigationDataBLoC, navigationData);
  }

  refresh_selectedMatchDecisionRespJModelChanged_NavigationDataBLoC() {
    NavigationData navigationData = NavigationData();
    navigationData.matchDecisionRespJModel = selected_MatchDecisionRespJModel;
    refresh_W_Data_NavigationDataBLoC(
        selectedMatchDecisionRespJModelChanged_NavigationDataBLoC,
        navigationData);
  }

  refresh_selectedCustomUserRespJModelChanged_NavigationDataBLoC_Match_To() {
    NavigationData navigationData = NavigationData();
    navigationData.customUserRespJModel =
        selected_CustomUserRespJModel_Match_To;
    refresh_W_Data_NavigationDataBLoC(
        selectedCustomUserRespJModelChanged_NavigationDataBLoC_Match_To,
        navigationData);
  }

  refresh_onMatchDecisionRespJModelsChanged_NavigationDataBLoC() {
    refresh_WO_Data_NavigationDataBLoC(
        onMatchDecisionRespJModelsChanged_NavigationDataBLoC);
  }

  refresh_selectedCustomUserRespJModel_NavigationDataBLoC(bool isError) {
    NavigationData navigationData = NavigationData();
    navigationData.isShow = isError;
    refresh_W_Data_NavigationDataBLoC(
        selectedCustomUserRespJModel_NavigationDataBLoC, navigationData);
  }

  refresh_selectedCustomUserRespJModel_Match_To_NavigationDataBLoC(
      bool isError) {
    NavigationData navigationData = NavigationData();
    navigationData.isShow = isError;
    refresh_W_Data_NavigationDataBLoC(
        selectedCustomUserRespJModel_Match_To_NavigationDataBLoC,
        navigationData);
  }

  refresh_validateagainstChanged(
      List<int> intListPass, NavigationDataBLoC validateagainstChanged) {
    NavigationData navigationData = NavigationData();
    navigationData.intList = intListPass;
    refresh_W_Data_NavigationDataBLoC(validateagainstChanged, navigationData);
  }

  refresh_selectedMatchDecisionRespJModel_NavigationDataBLoC(bool isError) {
    NavigationData navigationData = NavigationData();
    navigationData.isShow = isError;
    refresh_W_Data_NavigationDataBLoC(
        selectedMatchDecisionRespJModel_NavigationDataBLoC, navigationData);
  }

  refresh_on_isuserrequested_Val_Changed_NavigationDataBLoC() {
    refresh_WO_Data_NavigationDataBLoC(
        on_isuserrequested_Val_Changed_NavigationDataBLoC);
  }

  refresh_on_isApproved_Val_Changed_NavigationDataBLoC() {
    refresh_WO_Data_NavigationDataBLoC(
        on_isApproved_Val_Changed_NavigationDataBLoC);
  }

  refresh_on_isActive_Val_Changed_NavigationDataBLoC() {
    refresh_WO_Data_NavigationDataBLoC(
        on_isActive_Val_Changed_NavigationDataBLoC);
  }

  refresh_interested_in_Changed_DailySubTaskImagesBLoC() {
    NavigationData navigationData = NavigationData();
    refresh_W_Data_NavigationDataBLoC(
        interested_in_Changed_DailySubTaskImagesBLoC, navigationData);
  }

  refresh_onGenderRespModelsChanged_NavigationDataBLoC() {
    refresh_WO_Data_NavigationDataBLoC(
        onGenderRespModelsChanged_NavigationDataBLoC);
  }

  refresh_selectedGenderRespModel_NavigationDataBLoC(bool isError) {
    NavigationData navigationData = NavigationData();
    navigationData.isShow = isError;
    refresh_W_Data_NavigationDataBLoC(
        selectedGenderRespModel_NavigationDataBLoC, navigationData);
  }

  refresh_on_rvalues_Changed_NavigationDataBLoC() {
    refresh_WO_Data_NavigationDataBLoC(on_rvalues_Changed_NavigationDataBLoC);
  }

  refresh_onPageChangedDots_DailySubTaskImagesBLoC(double position) {
    NavigationData navigationData = NavigationData();
    navigationData.position_double = position;
    refresh_W_Data_NavigationDataBLoC(
        onPageChangedDots_DailySubTaskImagesBLoC, navigationData);
  }

  refresh_user_onPageChangedDots_DailySubTaskImagesBLoC(double position) {
    NavigationData navigationData = NavigationData();
    navigationData.position_double = position;
    refresh_W_Data_NavigationDataBLoC(
        user_onPageChangedDots_DailySubTaskImagesBLoC, navigationData);
  }

  //END OF STATE CHANGES

  @override
  Widget build(BuildContext context) {
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return Container(
          color: datingAppThemeChanger.selectedThemeData.sm_bg_background,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                getMainListViewUI(datingAppThemeChanger),
                StreamBuilder(
                  stream: keyBoardVisibleBLoC.stream_counter,
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return save_FloatingActionButton(context);
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return save_FloatingActionButton(context);
                        break;
                      case ConnectionState.waiting:
                        return save_FloatingActionButton(context);
                        break;
                      case ConnectionState.active:
                        if (snapshot.data) {
                          return invisibleWidget();
                        }
                        if (!snapshot.data) {
                          return save_FloatingActionButton(context);
                        }
                        break;
                      case ConnectionState.done:
                        if (snapshot.data) {
                          return invisibleWidget();
                        }
                        if (!snapshot.data) {
                          return save_FloatingActionButton(context);
                        }
                        break;
                    }
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //BUILD WIDGETS

  Widget getMainListViewUI(DatingAppThemeChanger datingAppThemeChanger) {
    return FutureBuilder<bool>(
      future: common_getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        snackbarBuildContext = context;
        if (!snapshot.hasData) {
          return SizedBox();
        } else {
          animationController.forward();
          return Form(
            autovalidate: _autoValidateF1,
            key: _formKey1,
            child: Theme(
              data: ThemeData(primaryColor: DatingAppTheme.colorAdrianBlue),
              child: SmartRefresher(
                onRefresh: () async {
                  _refreshController.refreshCompleted();
                },
                enablePullUp: true,
                onLoading: () async {
                  _refreshController.loadComplete();
                },
                controller: _refreshController,
                enablePullDown: true,
                header: WaterDropMaterialHeader(
                    backgroundColor:
                        datingAppThemeChanger.selectedThemeData.bg_WaterDrop,
                    color: datingAppThemeChanger.selectedThemeData.cl_WaterDrop,
                    distance: 30),
                footer: ClassicFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                  textStyle: datingAppThemeChanger
                      .selectedThemeData.txt_stl_whitegrey_13_Book,
                  completeDuration: Duration(milliseconds: 500),
                  loadingIcon: SizedBox(
                    width: 25.0,
                    height: 25.0,
                    child: Platform.isIOS
                        ? CupertinoActivityIndicator()
                        : CircularProgressIndicator(strokeWidth: 2.0),
                  ),
                  idleIcon: Icon(
                    Icons.sync,
                    color:
                        datingAppThemeChanger.selectedThemeData.cl_white_grey,
                  ),
                  canLoadingIcon: Icon(
                    Icons.arrow_upward,
                    color:
                        datingAppThemeChanger.selectedThemeData.cl_white_grey,
                  ),
                ),
                child: ListView(
                  controller: scrollController,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                    top: //MediaQuery.of(context).padding.top,
                        AppBar().preferredSize.height +
                            MediaQuery.of(context).padding.top +
                            5,
                    bottom: 62,
                  ),
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    CustomTitleView(
                      titleTxt: 'Match',
                      subTxt: '',
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / 9) * 0, 1.0,
                                  curve: Curves.fastOutSlowIn))),
                      animationController: animationController,
                      titleTextStyle: TextStyle(
                        fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
                        fontSize: 16,
                        color: DatingAppTheme.pltf_grey,
                      ),
                      //datingAppThemeChanger.selectedThemeData.title_TextStyle,
                    ),
                    AnimatedBuilder(
                      animation: animationController,
                      builder: (BuildContext context, Widget child) {
                        return FadeTransition(
                          opacity: animation,
                          child: new Transform(
                            transform: new Matrix4.translationValues(
                                0.0, 30 * (1.0 - animation.value), 0.0),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 24, right: 24, top: 16, bottom: 18),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: datingAppThemeChanger
                                          .selectedThemeData.bg_task_Item,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                          topRight: Radius.circular(68.0)),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: DatingAppTheme.grey
                                                .withOpacity(0.2),
                                            offset: Offset(1.1, 1.1),
                                            blurRadius: 10.0),
                                      ],
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 16,
                                              left: 0,
                                              right: 0,
                                              bottom: 3),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    top: 8,
                                                    bottom: 0),
                                                child: Text(
                                                  'User',
                                                  style: datingAppThemeChanger
                                                      .selectedThemeData
                                                      .txt_stl_whitegrey_14_Med_pltf_grey,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    top: 0,
                                                    bottom: 3),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 0,
                                                                top: 8,
                                                                bottom: 8),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    DatingAppTheme
                                                                        .white,
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            8.0),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            8.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            8.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            68.0)),
                                                                boxShadow: <
                                                                    BoxShadow>[
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.2),
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              2),
                                                                      blurRadius:
                                                                          10.0),
                                                                ],
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            16,
                                                                        right:
                                                                            16,
                                                                        top: 0,
                                                                        bottom:
                                                                            0),
                                                                child:
                                                                    StreamBuilder(
                                                                  stream: onCustomUserRespJModelsChanged_NavigationDataBLoC
                                                                      .stream_counter,
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    return customUserPickerOnlinene();
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            StreamBuilder(
                                                              stream: selectedCustomUserRespJModel_NavigationDataBLoC
                                                                  .stream_counter,
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                    .hasError)
                                                                  return invisibleWidget();
                                                                switch (snapshot
                                                                    .connectionState) {
                                                                  case ConnectionState
                                                                      .none:
                                                                    return invisibleWidget();
                                                                    break;
                                                                  case ConnectionState
                                                                      .waiting:
                                                                    return invisibleWidget();
                                                                    break;
                                                                  case ConnectionState
                                                                      .active:
                                                                    return ifToShow_positionedNotificationIcon(
                                                                        snapshot);
                                                                    break;
                                                                  case ConnectionState
                                                                      .done:
                                                                    return ifToShow_positionedNotificationIcon(
                                                                        snapshot);
                                                                    break;
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //PICTURES HERE
                                              StreamBuilder(
                                                stream:
                                                    user_UserProfileRespModelList_Changed_NavigationDataBLoC
                                                        .stream_counter,
                                                builder: (context, snapshot) {
                                                  return ((user_UserProfileRespModelList
                                                              .length >
                                                          0
                                                      ? Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 16,
                                                                  right: 16,
                                                                  top: 8,
                                                                  bottom: 0),
                                                          child: SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 200,
                                                            child: Stack(
                                                              children: <
                                                                  Widget>[
                                                                Theme(
                                                                  data:
                                                                      ThemeData(
                                                                    primaryColor:
                                                                        DatingAppTheme
                                                                            .colorAdrianBlue,
                                                                  ),
                                                                  child: CarouselSlider
                                                                      .builder(
                                                                    itemCount:
                                                                        user_UserProfileRespModelList
                                                                            .length,
                                                                    carouselController:
                                                                        user_imagesCarouselController,
                                                                    options: CarouselOptions(
                                                                        autoPlay: false,
                                                                        enlargeCenterPage: true,
                                                                        viewportFraction: 1,
                                                                        aspectRatio: 2.0,
                                                                        height: 200,
                                                                        initialPage: user_UserProfileRespModelList.length,
                                                                        onPageChanged: (int index, CarouselPageChangedReason reason) {
                                                                          user_currentImageSwiper_Position =
                                                                              index.toDouble();
                                                                          refresh_user_onPageChangedDots_DailySubTaskImagesBLoC(
                                                                              user_currentImageSwiper_Position);
                                                                          Timer(
                                                                              Duration(milliseconds: 200),
                                                                              () {
                                                                            user_autoScrollController.scrollToIndex(index);
                                                                            user_autoScrollController.highlight(index);
                                                                          });
                                                                        }),
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int itemIndex) {
                                                                      UserProfileRespModel
                                                                          userProfileRespModel =
                                                                          user_UserProfileRespModelList[
                                                                              itemIndex];
                                                                      return isStringValid(userProfileRespModel
                                                                              .picture)
                                                                          ? StreamBuilder(
                                                                              stream: onInternetConnectionToggle_DailySubTaskImagesBLoC.stream_counter,
                                                                              builder: (context, snapshot) {
                                                                                return InkWell(
                                                                                  onTap: () {
                                                                                    /*onClickImageShowCommentReplaceDialog(
                                                                            context,
                                                                            erpfile,
                                                                            itemIndex);*/
                                                                                  },
                                                                                  child: CachedNetworkImage(
                                                                                    imageUrl: userProfileRespModel.picture,
                                                                                    imageBuilder: (context, imageProvider) => Container(
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                                                                                        image: DecorationImage(
                                                                                          image: imageProvider,
                                                                                          fit: BoxFit.cover,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    placeholder: (context, url) {
                                                                                      return nointernetConnectedLoaded_Image(context, userProfileRespModel, itemIndex);
                                                                                    },
                                                                                    errorWidget: (context, url, error) {
                                                                                      return nointernetConnectedLoaded_Image(context, userProfileRespModel, itemIndex);
                                                                                    },
                                                                                  ),
                                                                                );
                                                                              },
                                                                            )
                                                                          : nointernetConnectedLoaded_Image(
                                                                              context,
                                                                              userProfileRespModel,
                                                                              itemIndex);
                                                                    },
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  right: 8,
                                                                  left: 8,
                                                                  bottom: 5,
                                                                  child:
                                                                      StreamBuilder(
                                                                    stream: user_onPageChangedDots_DailySubTaskImagesBLoC
                                                                        .stream_counter,
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      return Container(
                                                                        height:
                                                                            8,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              ListView.builder(
                                                                            physics:
                                                                                BouncingScrollPhysics(),
                                                                            controller:
                                                                                user_autoScrollController,
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemCount:
                                                                                user_UserProfileRespModelList.length,
                                                                            itemBuilder:
                                                                                (BuildContext context, int index) {
                                                                              return AutoScrollTag(
                                                                                key: ValueKey(index),
                                                                                index: index,
                                                                                controller: user_autoScrollController,
                                                                                child: _buildPageIndicator(
                                                                                  index,
                                                                                  user_currentImageSwiper_Position,
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : invisibleWidget()));
                                                },
                                              ),
                                              //END OF PICTURES

                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    top: 8,
                                                    bottom: 0),
                                                child: Text(
                                                  'Match To',
                                                  style: datingAppThemeChanger
                                                      .selectedThemeData
                                                      .txt_stl_whitegrey_14_Med_pltf_grey,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    top: 0,
                                                    bottom: 3),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 0,
                                                                top: 8,
                                                                bottom: 8),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    DatingAppTheme
                                                                        .white,
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            8.0),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            8.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            8.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            8.0)),
                                                                boxShadow: <
                                                                    BoxShadow>[
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.2),
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              2),
                                                                      blurRadius:
                                                                          10.0),
                                                                ],
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            16,
                                                                        right:
                                                                            16,
                                                                        top: 0,
                                                                        bottom:
                                                                            0),
                                                                child:
                                                                    StreamBuilder(
                                                                  stream: onCustomUserRespJModelsChanged_NavigationDataBLoC
                                                                      .stream_counter,
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    return matchtocustomUserPickerOnlinene();
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            StreamBuilder(
                                                              stream: selectedCustomUserRespJModel_Match_To_NavigationDataBLoC
                                                                  .stream_counter,
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                    .hasError)
                                                                  return invisibleWidget();
                                                                switch (snapshot
                                                                    .connectionState) {
                                                                  case ConnectionState
                                                                      .none:
                                                                    return invisibleWidget();
                                                                    break;
                                                                  case ConnectionState
                                                                      .waiting:
                                                                    return invisibleWidget();
                                                                    break;
                                                                  case ConnectionState
                                                                      .active:
                                                                    return ifToShow_positionedNotificationIcon(
                                                                        snapshot);
                                                                    break;
                                                                  case ConnectionState
                                                                      .done:
                                                                    return ifToShow_positionedNotificationIcon(
                                                                        snapshot);
                                                                    break;
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //PICTURES HERE
                                              StreamBuilder(
                                                stream:
                                                    match_To_UserProfileRespModelList_Changed_NavigationDataBLoC
                                                        .stream_counter,
                                                builder: (context, snapshot) {
                                                  return ((match_To_UserProfileRespModelList
                                                              .length >
                                                          0
                                                      ? Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 16,
                                                                  right: 16,
                                                                  top: 8,
                                                                  bottom: 0),
                                                          child: SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 200,
                                                            child: Stack(
                                                              children: <
                                                                  Widget>[
                                                                Theme(
                                                                  data:
                                                                      ThemeData(
                                                                    primaryColor:
                                                                        DatingAppTheme
                                                                            .colorAdrianBlue,
                                                                  ),
                                                                  child: CarouselSlider
                                                                      .builder(
                                                                    itemCount:
                                                                        match_To_UserProfileRespModelList
                                                                            .length,
                                                                    carouselController:
                                                                        imagesCarouselController,
                                                                    options: CarouselOptions(
                                                                        autoPlay: false,
                                                                        enlargeCenterPage: true,
                                                                        viewportFraction: 1,
                                                                        aspectRatio: 2.0,
                                                                        height: 200,
                                                                        initialPage: match_To_UserProfileRespModelList.length,
                                                                        onPageChanged: (int index, CarouselPageChangedReason reason) {
                                                                          currentImageSwiper_Position =
                                                                              index.toDouble();
                                                                          refresh_onPageChangedDots_DailySubTaskImagesBLoC(
                                                                              currentImageSwiper_Position);
                                                                          Timer(
                                                                              Duration(milliseconds: 200),
                                                                              () {
                                                                            autoScrollController.scrollToIndex(index);
                                                                            autoScrollController.highlight(index);
                                                                          });
                                                                        }),
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int itemIndex) {
                                                                      UserProfileRespModel
                                                                          userProfileRespModel =
                                                                          match_To_UserProfileRespModelList[
                                                                              itemIndex];
                                                                      return isStringValid(userProfileRespModel
                                                                              .picture)
                                                                          ? StreamBuilder(
                                                                              stream: onInternetConnectionToggle_DailySubTaskImagesBLoC.stream_counter,
                                                                              builder: (context, snapshot) {
                                                                                return InkWell(
                                                                                  onTap: () {
                                                                                    /*onClickImageShowCommentReplaceDialog(
                                                                            context,
                                                                            erpfile,
                                                                            itemIndex);*/
                                                                                  },
                                                                                  child: CachedNetworkImage(
                                                                                    imageUrl: userProfileRespModel.picture,
                                                                                    imageBuilder: (context, imageProvider) => Container(
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                                                                                        image: DecorationImage(
                                                                                          image: imageProvider,
                                                                                          fit: BoxFit.cover,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    placeholder: (context, url) {
                                                                                      return nointernetConnectedLoaded_Image(context, userProfileRespModel, itemIndex);
                                                                                    },
                                                                                    errorWidget: (context, url, error) {
                                                                                      return nointernetConnectedLoaded_Image(context, userProfileRespModel, itemIndex);
                                                                                    },
                                                                                  ),
                                                                                );
                                                                              },
                                                                            )
                                                                          : nointernetConnectedLoaded_Image(
                                                                              context,
                                                                              userProfileRespModel,
                                                                              itemIndex);
                                                                    },
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  right: 8,
                                                                  left: 8,
                                                                  bottom: 5,
                                                                  child:
                                                                      StreamBuilder(
                                                                    stream: onPageChangedDots_DailySubTaskImagesBLoC
                                                                        .stream_counter,
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      return Container(
                                                                        height:
                                                                            8,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              ListView.builder(
                                                                            physics:
                                                                                BouncingScrollPhysics(),
                                                                            controller:
                                                                                autoScrollController,
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemCount:
                                                                                match_To_UserProfileRespModelList.length,
                                                                            itemBuilder:
                                                                                (BuildContext context, int index) {
                                                                              return AutoScrollTag(
                                                                                key: ValueKey(index),
                                                                                index: index,
                                                                                controller: autoScrollController,
                                                                                child: _buildPageIndicator(
                                                                                  index,
                                                                                  currentImageSwiper_Position,
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : invisibleWidget()));
                                                },
                                              ),
                                              //END OF PICTURES
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    top: 8,
                                                    bottom: 0),
                                                child: Text(
                                                  'Decision',
                                                  style: datingAppThemeChanger
                                                      .selectedThemeData
                                                      .txt_stl_whitegrey_14_Med_pltf_grey,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    top: 0,
                                                    bottom: 3),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 0,
                                                                top: 8,
                                                                bottom: 8),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    DatingAppTheme
                                                                        .white,
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            8.0),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            8.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            8.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            8.0)),
                                                                boxShadow: <
                                                                    BoxShadow>[
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.2),
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              2),
                                                                      blurRadius:
                                                                          10.0),
                                                                ],
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            16,
                                                                        right:
                                                                            16,
                                                                        top: 0,
                                                                        bottom:
                                                                            0),
                                                                child:
                                                                    StreamBuilder(
                                                                  stream: onMatchDecisionRespJModelsChanged_NavigationDataBLoC
                                                                      .stream_counter,
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    return matchDecisionPickerOnlinene();
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            StreamBuilder(
                                                              stream: selectedMatchDecisionRespJModel_NavigationDataBLoC
                                                                  .stream_counter,
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                    .hasError)
                                                                  return invisibleWidget();
                                                                switch (snapshot
                                                                    .connectionState) {
                                                                  case ConnectionState
                                                                      .none:
                                                                    return invisibleWidget();
                                                                    break;
                                                                  case ConnectionState
                                                                      .waiting:
                                                                    return invisibleWidget();
                                                                    break;
                                                                  case ConnectionState
                                                                      .active:
                                                                    return ifToShow_positionedNotificationIcon(
                                                                        snapshot);
                                                                    break;
                                                                  case ConnectionState
                                                                      .done:
                                                                    return ifToShow_positionedNotificationIcon(
                                                                        snapshot);
                                                                    break;
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ((widget.dateMatchReqJModel !=
                                                          null &&
                                                      widget.dateMatchReqJModel
                                                          .isuserrequested
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 16,
                                                          right: 16,
                                                          top: 8,
                                                          bottom: 11),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          StreamBuilder(
                                                            stream: on_isuserrequested_Val_Changed_NavigationDataBLoC
                                                                .stream_counter,
                                                            builder: (context,
                                                                snapshot) {
                                                              return Theme(
                                                                data: ThemeData(
                                                                  unselectedWidgetColor:
                                                                      DatingAppTheme
                                                                          .pltf_grey,
                                                                  disabledColor:
                                                                      datingAppThemeChanger
                                                                          .selectedThemeData
                                                                          .cl_real_grey_grey_Disabled,
                                                                ),
                                                                child: SizedBox(
                                                                  height: 24.0,
                                                                  width: 24.0,
                                                                  child:
                                                                      Checkbox(
                                                                    value:
                                                                        isuserrequested_Val,
                                                                    activeColor:
                                                                        datingAppThemeChanger
                                                                            .selectedThemeData
                                                                            .cl_cont_Sel_ClickableItem,
                                                                    checkColor:
                                                                        DatingAppTheme
                                                                            .white,
                                                                    onChanged:
                                                                        null
                                                                    /*(bool value) {
                                                            on_isuserrequested_Val_Changed(
                                                                value);
                                                          }*/
                                                                    ,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              left: 5,
                                                            ),
                                                            child: Text(
                                                              'Is a User Request',
                                                              style: datingAppThemeChanger
                                                                  .selectedThemeData
                                                                  .txt_stl_whitegrey_14_Med_pltf_grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                  : invisibleWidget())),
                                              ((widget.dateMatchReqJModel !=
                                                          null &&
                                                      widget.dateMatchReqJModel
                                                          .isuserrequested
                                                  ? StreamBuilder(
                                                      stream:
                                                          onGenderRespModelsChanged_NavigationDataBLoC
                                                              .stream_counter,
                                                      builder:
                                                          (context, snapshot) {
                                                        return ((allGenderRespModelList !=
                                                                    null &&
                                                                allGenderRespModelList
                                                                        .length >
                                                                    0
                                                            ? Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            16,
                                                                        right:
                                                                            16,
                                                                        top: 8,
                                                                        bottom:
                                                                            0),
                                                                    child:
                                                                        Stack(
                                                                      children: <
                                                                          Widget>[
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(right: 25),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: <Widget>[
                                                                              Text(
                                                                                'Interested in:',
                                                                                style: datingAppThemeChanger.selectedThemeData.txt_stl_whitegrey_14_Med_pltf_grey,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        StreamBuilder(
                                                                          stream:
                                                                              selectedGenderRespModel_NavigationDataBLoC.stream_counter,
                                                                          builder:
                                                                              (context, snapshot) {
                                                                            if (snapshot.hasError)
                                                                              return invisibleWidget();
                                                                            switch (snapshot.connectionState) {
                                                                              case ConnectionState.none:
                                                                                return invisibleWidget();
                                                                                break;
                                                                              case ConnectionState.waiting:
                                                                                return invisibleWidget();
                                                                                break;
                                                                              case ConnectionState.active:
                                                                                return ifToShow_positionedNotificationIcon_WDims(snapshot, 2, -2);
                                                                                break;
                                                                              case ConnectionState.done:
                                                                                return ifToShow_positionedNotificationIcon_WDims(snapshot, 2, -2);
                                                                                break;
                                                                            }
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            16,
                                                                        right:
                                                                            16,
                                                                        top: 8,
                                                                        bottom:
                                                                            11),
                                                                    child: StreamBuilder(
                                                                        stream: interested_in_Changed_DailySubTaskImagesBLoC.stream_counter,
                                                                        builder: (context, ohs_approval_snapshot) {
                                                                          return ColumnBuilder(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            itemCount:
                                                                                allGenderRespModelList.length,
                                                                            itemBuilder:
                                                                                (BuildContext context, int index) {
                                                                              GenderRespModel genderRespModel = allGenderRespModelList[index];
                                                                              return Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  Theme(
                                                                                    data: ThemeData(
                                                                                      unselectedWidgetColor: DatingAppTheme.pltf_grey,
                                                                                      disabledColor: datingAppThemeChanger.selectedThemeData.cl_real_grey_grey_Disabled,
                                                                                    ),
                                                                                    child: SizedBox(
                                                                                      height: 24.0,
                                                                                      width: 24.0,
                                                                                      child: Radio(
                                                                                        value: genderRespModel.id,
                                                                                        activeColor: datingAppThemeChanger.selectedThemeData.cl_cont_Sel_ClickableItem,
                                                                                        groupValue: _interested_in_RadioValue,
                                                                                        onChanged: null,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Material(
                                                                                    color: Colors.transparent,
                                                                                    child: InkWell(
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.only(left: 1, right: 2, top: 3, bottom: 3),
                                                                                        child: Text(
                                                                                          genderRespModel.name,
                                                                                          style: datingAppThemeChanger.selectedThemeData.txt_stl_whitegrey_14_Med_pltf_grey,
                                                                                        ),
                                                                                      ),
                                                                                      onTap: () {},
                                                                                      splashColor: DatingAppTheme.pltf_grey,
                                                                                      borderRadius: BorderRadius.all(
                                                                                        Radius.circular(10.0),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          );
                                                                        }),
                                                                  ),
                                                                ],
                                                              )
                                                            : invisibleWidget()));
                                                      })
                                                  : invisibleWidget())),
                                              ((widget.dateMatchReqJModel !=
                                                          null &&
                                                      widget.dateMatchReqJModel
                                                          .isuserrequested
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 16,
                                                          right: 16,
                                                          top: 8,
                                                          bottom: 0),
                                                      child: Text(
                                                        'Age',
                                                        style: datingAppThemeChanger
                                                            .selectedThemeData
                                                            .txt_stl_whitegrey_14_Med_pltf_grey,
                                                      ),
                                                    )
                                                  : invisibleWidget())),
                                              ((widget.dateMatchReqJModel !=
                                                          null &&
                                                      widget.dateMatchReqJModel
                                                          .isuserrequested
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 16,
                                                          right: 16,
                                                          top: 2,
                                                          bottom: 0),
                                                      child: StreamBuilder(
                                                        stream:
                                                            on_rvalues_Changed_NavigationDataBLoC
                                                                .stream_counter,
                                                        builder: (context,
                                                            snapshot) {
                                                          return RangeSlider(
                                                            activeColor:
                                                                datingAppThemeChanger
                                                                    .selectedThemeData
                                                                    .cl_cont_Sel_ClickableItem,
                                                            inactiveColor:
                                                                datingAppThemeChanger
                                                                    .selectedThemeData
                                                                    .cl_cont_Sel_ClickableItem,
                                                            values: _rvalues,
                                                            min: 18,
                                                            max: 100,
                                                            onChangeStart: null,
                                                            onChangeEnd: null,
                                                            onChanged: null,
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : invisibleWidget())),
                                              ((widget.dateMatchReqJModel !=
                                                          null &&
                                                      widget.dateMatchReqJModel
                                                          .isuserrequested
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 16,
                                                          right: 16,
                                                          top: 2,
                                                          bottom: 0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          StreamBuilder(
                                                            stream: on_rvalues_Changed_NavigationDataBLoC
                                                                .stream_counter,
                                                            builder: (context,
                                                                snapshot) {
                                                              return Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    3,
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    ExpandedBubbleChip(
                                                                      isSelectable:
                                                                          false,
                                                                      isSelected:
                                                                          false,
                                                                      title:
                                                                          '${_rvalues.start.toInt()} - ${_rvalues.end.toInt()}',
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : invisibleWidget())),

                                              ((widget.dateMatchReqJModel !=
                                                          null &&
                                                      widget.dateMatchReqJModel
                                                          .isuserrequested
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 16,
                                                          right: 16,
                                                          top: 8,
                                                          bottom: 11),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          StreamBuilder(
                                                            stream: on_isApproved_Val_Changed_NavigationDataBLoC
                                                                .stream_counter,
                                                            builder: (context,
                                                                snapshot) {
                                                              return Theme(
                                                                data: ThemeData(
                                                                  unselectedWidgetColor:
                                                                      DatingAppTheme
                                                                          .pltf_grey,
                                                                  disabledColor:
                                                                      datingAppThemeChanger
                                                                          .selectedThemeData
                                                                          .cl_real_grey_grey_Disabled,
                                                                ),
                                                                child: SizedBox(
                                                                  height: 24.0,
                                                                  width: 24.0,
                                                                  child:
                                                                      Checkbox(
                                                                    value:
                                                                        isApproved_Val,
                                                                    activeColor:
                                                                        datingAppThemeChanger
                                                                            .selectedThemeData
                                                                            .cl_cont_Sel_ClickableItem,
                                                                    checkColor:
                                                                        DatingAppTheme
                                                                            .white,
                                                                    onChanged: (bool
                                                                        value) {
                                                                      on_isApproved_Val_Changed(
                                                                          value);
                                                                    },
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              left: 5,
                                                            ),
                                                            child: Text(
                                                              'Approved',
                                                              style: datingAppThemeChanger
                                                                  .selectedThemeData
                                                                  .txt_stl_whitegrey_14_Med_pltf_grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                  : invisibleWidget())),

                                              ((widget.dateMatchReqJModel !=
                                                          null &&
                                                      widget.dateMatchReqJModel
                                                          .isuserrequested
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 16,
                                                          right: 16,
                                                          top: 8,
                                                          bottom: 11),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          StreamBuilder(
                                                            stream: on_isActive_Val_Changed_NavigationDataBLoC
                                                                .stream_counter,
                                                            builder: (context,
                                                                snapshot) {
                                                              return Theme(
                                                                data: ThemeData(
                                                                  unselectedWidgetColor:
                                                                      DatingAppTheme
                                                                          .pltf_grey,
                                                                  disabledColor:
                                                                      datingAppThemeChanger
                                                                          .selectedThemeData
                                                                          .cl_real_grey_grey_Disabled,
                                                                ),
                                                                child: SizedBox(
                                                                  height: 24.0,
                                                                  width: 24.0,
                                                                  child:
                                                                      Checkbox(
                                                                    value:
                                                                        isActive_Val,
                                                                    activeColor:
                                                                        datingAppThemeChanger
                                                                            .selectedThemeData
                                                                            .cl_cont_Sel_ClickableItem,
                                                                    checkColor:
                                                                        DatingAppTheme
                                                                            .white,
                                                                    onChanged: (bool
                                                                        value) {
                                                                      on_isActive_Val_Changed(
                                                                          value);
                                                                    },
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              left: 5,
                                                            ),
                                                            child: Text(
                                                              'Active',
                                                              style: datingAppThemeChanger
                                                                  .selectedThemeData
                                                                  .txt_stl_whitegrey_14_Med_pltf_grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                  : invisibleWidget())),

                                              ((widget.dateMatchReqJModel !=
                                                          null &&
                                                      widget.dateMatchReqJModel
                                                          .isuserrequested
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 16,
                                                          right: 16,
                                                          top: 8,
                                                          bottom: 3),
                                                      child: Text(
                                                        'Facebook/Instagram Link',
                                                        style: datingAppThemeChanger
                                                            .selectedThemeData
                                                            .txt_stl_whitegrey_14_Med_pltf_grey,
                                                      ),
                                                    )
                                                  : invisibleWidget())),
                                              ((widget.dateMatchReqJModel !=
                                                          null &&
                                                      widget.dateMatchReqJModel
                                                          .isuserrequested
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 16,
                                                          right: 16,
                                                          top: 0,
                                                          bottom: 3),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: DatingAppTheme
                                                                        .white,
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                8.0),
                                                                        bottomLeft:
                                                                            Radius.circular(
                                                                                8.0),
                                                                        bottomRight:
                                                                            Radius.circular(
                                                                                8.0),
                                                                        topRight:
                                                                            Radius.circular(8.0)),
                                                                    boxShadow: <
                                                                        BoxShadow>[
                                                                      BoxShadow(
                                                                          color: Colors.grey.withOpacity(
                                                                              0.2),
                                                                          offset: const Offset(
                                                                              0,
                                                                              2),
                                                                          blurRadius:
                                                                              10.0),
                                                                    ],
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            16,
                                                                        right:
                                                                            16,
                                                                        top: 0,
                                                                        bottom:
                                                                            0),
                                                                    child:
                                                                        TextFormField(
                                                                      onChanged:
                                                                          (String
                                                                              txt) {},
                                                                      style: datingAppThemeChanger
                                                                          .selectedThemeData
                                                                          .txt_stl_f14w500_Med,
                                                                      cursorColor: datingAppThemeChanger
                                                                          .selectedThemeData
                                                                          .cl_grey,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        icon:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: <
                                                                              Widget>[
                                                                            Material(
                                                                              color: Colors.transparent,
                                                                              child: InkWell(
                                                                                child: Icon(
                                                                                  FontAwesomeIcons.facebook,
                                                                                  color: datingAppThemeChanger.selectedThemeData.cl_grey,
                                                                                  size: 20,
                                                                                ),
                                                                                onTap: () {
                                                                                  on_fb_insta_link_tapped();
                                                                                },
                                                                                splashColor: DatingAppTheme.pltf_grey,
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(10.0),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 3,
                                                                            ),
                                                                            Material(
                                                                              color: Colors.transparent,
                                                                              child: InkWell(
                                                                                child: Icon(
                                                                                  FontAwesomeIcons.instagram,
                                                                                  color: datingAppThemeChanger.selectedThemeData.cl_grey,
                                                                                  size: 20,
                                                                                ),
                                                                                onTap: () {
                                                                                  on_fb_insta_link_tapped();
                                                                                },
                                                                                splashColor: DatingAppTheme.pltf_grey,
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(10.0),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        border:
                                                                            InputBorder.none,
                                                                        hintText:
                                                                            '',
                                                                        hintStyle: datingAppThemeChanger
                                                                            .selectedThemeData
                                                                            .txt_stl_hint_f14w500_Med,
                                                                      ),
                                                                      textInputAction:
                                                                          TextInputAction
                                                                              .next,
                                                                      controller:
                                                                          fbinsta_TextEditingController,
                                                                      focusNode:
                                                                          fbinsta_FocusNode,
                                                                      autofocus:
                                                                          false,
                                                                      onFieldSubmitted:
                                                                          (String
                                                                              val) {},
                                                                      readOnly:
                                                                          true,
                                                                      onTap:
                                                                          () {},
                                                                    ),
                                                                  ),
                                                                ),
                                                                StreamBuilder(
                                                                  stream: wd_fbinsta_Container_NavigationDataBLoC
                                                                      .stream_counter,
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    if (snapshot
                                                                        .hasError) {
                                                                      return invisibleWidget();
                                                                    }
                                                                    switch (snapshot
                                                                        .connectionState) {
                                                                      case ConnectionState
                                                                          .none:
                                                                        return invisibleWidget();
                                                                        break;
                                                                      case ConnectionState
                                                                          .waiting:
                                                                        return invisibleWidget();
                                                                        break;
                                                                      case ConnectionState
                                                                          .active:
                                                                        return wd_Text_Widget_Form_Validator_Text(
                                                                            datingAppThemeChanger,
                                                                            snapshot);
                                                                        break;
                                                                      case ConnectionState
                                                                          .done:
                                                                        return wd_Text_Widget_Form_Validator_Text(
                                                                            datingAppThemeChanger,
                                                                            snapshot);
                                                                        break;
                                                                    }
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                  height: 20,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : invisibleWidget())),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                  //),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  //IMAGE SWIPER
  Widget nointernetConnectedLoaded_Image(BuildContext context,
      UserProfileRespModel userProfileRespModel, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(8.0)),
          image: DecorationImage(
              image: Image.asset('assets/images/image_placeholder.png').image,
              fit: BoxFit.cover),
        ),
      ),
    );
  }

  _buildPageIndicator(int i, double current_Position) {
    Widget rtnWidget =
        i == current_Position ? _indicator(true) : _indicator(false);
    return rtnWidget;
  }

  _indicator(bool isActive) {
    return isActive
        ? AnimatedContainer(
            duration: Duration(milliseconds: 150),
            margin: EdgeInsets.symmetric(horizontal: 3.3),
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              color: DatingAppTheme.pltf_pink, //Color(0xFFF8BBD0),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          )
        : Center(
            child: Wrap(children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  height: 8.0,
                  width: 8.0,
                  decoration: BoxDecoration(
                    color: DatingAppTheme.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
            ]),
          );
  }
  //ENS OF IMAGE SWIPER

  Widget save_FloatingActionButton(BuildContext context) {
    return Positioned(
      right: 20.0,
      bottom: 20.0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                heroTag: null,
                child: new AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Transform(
                          transform: new Matrix4.rotationZ(
                              _controller.value * 0.5 * math.pi),
                          alignment: FractionalOffset.center,
                          child: new Icon(
                            _controller.isDismissed ? Icons.save : Icons.close,
                            color: DatingAppTheme.grey,
                          ),
                        ),
                        streamBuilderWidgetLoader(
                          navigationDataBLoC_Loader,
                          DatingAppTheme.colorAdrianBlue,
                          8,
                          false,
                          0,
                          0,
                          null,
                          null,
                        ),
                      ],
                    );
                  },
                ),
                onPressed: () {
                  saveAndUpload_MatchData(context);
                },
                backgroundColor: DatingAppTheme.white.withOpacity(0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //END OF BUILD WIDGETS

  //DROPDOWN WIDGETS
  Widget customUserPickerOnlinene() {
    return IgnorePointer(
      ignoring: widget.dateMatchReqJModel.isuserrequested,
      child: CustomUserPickerOnline(
        dense: false,
        onlineuserList: allCustomUserRespJModelList,
        showFlag: true,
        showDialingCode: true,
        showName: false,
        hintText: 'User',
        onChanged: (CustomUserRespJModel customUserRespJModel) async {
          selected_CustomUserRespJModel = customUserRespJModel;
          widget.dateMatchReqJModel.matching_user =
              selected_CustomUserRespJModel.id;

          refresh_selectedCustomUserRespJModel_NavigationDataBLoC(false);
          refresh_validateagainstChanged(
            [widget.dateMatchReqJModel.matching_user],
            validateagainstChanged_Match_To,
          );
          //FETCH IMAGES
          try {
            user_UserProfileRespModelList =
                await fetch_user_usersProfiles_By_UserId(
              context,
              null,
              widget.dateMatchReqJModel.matching_user,
              DatingAppStaticParams.default_Max_int,
            );
            refresh_WO_Data_NavigationDataBLoC(
                user_UserProfileRespModelList_Changed_NavigationDataBLoC);
          } catch (error) {
            print(error.toString());
          }
          //END OF FETCH IMAGES
        },
        selectedCustomUserRespJModel: selected_CustomUserRespJModel,
        selectedCustomUserRespJModelChanged_NavigationDataBLoC:
            selectedCustomUserRespJModelChanged_NavigationDataBLoC,
        isDisabled: widget.dateMatchReqJModel.isuserrequested,
        validateagainst: [widget.dateMatchReqJModel.match_to],
        validateagainstChanged: validateagainstChanged,
      ),
    );
  }

  Widget matchtocustomUserPickerOnlinene() {
    return CustomUserPickerOnline(
      dense: false,
      onlineuserList: allCustomUserRespJModelList,
      showFlag: true,
      showDialingCode: true,
      showName: false,
      hintText: 'Match To',
      onChanged: (CustomUserRespJModel customUserRespJModel) async {
        selected_CustomUserRespJModel_Match_To = customUserRespJModel;
        widget.dateMatchReqJModel.match_to =
            selected_CustomUserRespJModel_Match_To.id;
        refresh_selectedCustomUserRespJModel_Match_To_NavigationDataBLoC(false);
        refresh_validateagainstChanged(
          [widget.dateMatchReqJModel.match_to],
          validateagainstChanged,
        );
        //FETCH IMAGES
        try {
          match_To_UserProfileRespModelList =
              await fetch_user_usersProfiles_By_UserId(
            context,
            null,
            widget.dateMatchReqJModel.match_to,
            DatingAppStaticParams.default_Max_int,
          );
          refresh_WO_Data_NavigationDataBLoC(
              match_To_UserProfileRespModelList_Changed_NavigationDataBLoC);
        } catch (error) {
          print(error.toString());
        }
        //END OF FETCH IMAGES
      },
      selectedCustomUserRespJModel: selected_CustomUserRespJModel_Match_To,
      selectedCustomUserRespJModelChanged_NavigationDataBLoC:
          selectedCustomUserRespJModelChanged_NavigationDataBLoC_Match_To,
      isDisabled: false,
      validateagainst: [widget.dateMatchReqJModel.matching_user],
      validateagainstChanged: validateagainstChanged_Match_To,
    );
  }

  Widget matchDecisionPickerOnlinene() {
    return MatchDecisionPickerOnline(
      dense: false,
      matchDecisionRespJModelList: allMatchDecisionRespJModelList,
      showFlag: true,
      showDialingCode: true,
      showName: false,
      hintText: 'Decision',
      onChanged: (MatchDecisionRespJModel matchDecisionRespJModel) {
        selected_MatchDecisionRespJModel = matchDecisionRespJModel;
        widget.dateMatchReqJModel.decision =
            selected_MatchDecisionRespJModel.id;
        refresh_selectedMatchDecisionRespJModel_NavigationDataBLoC(false);
      },
      selectedMatchDecisionRespJModel: selected_MatchDecisionRespJModel,
      selectedMatchDecisionRespJModelChanged_NavigationDataBLoC:
          selectedMatchDecisionRespJModelChanged_NavigationDataBLoC,
      isDisabled: false,
    );
  }
  //END OF DROPDOWN WIDGETS

  //WIDGET FUNCTIONS
  saveAndUpload_MatchData(BuildContext context) async {
    bool isDataValid = true;
    refreshLoader(true, navigationDataBLoC_Loader);
    if (!isIntValid(widget.dateMatchReqJModel.matching_user)) {
      refresh_selectedCustomUserRespJModel_NavigationDataBLoC(true);
      isDataValid = false;
    }

    if (!isIntValid(widget.dateMatchReqJModel.match_to)) {
      refresh_selectedCustomUserRespJModel_Match_To_NavigationDataBLoC(true);
      isDataValid = false;
    }

    if (!isIntValid(widget.dateMatchReqJModel.decision)) {
      refresh_selectedMatchDecisionRespJModel_NavigationDataBLoC(true);
      isDataValid = false;
    }

    if (widget.dateMatchReqJModel.isuserrequested) {
      if (widget.dateMatchReqJModel.approved != null &&
          widget.dateMatchReqJModel.approved &&
          widget.dateMatchReqJModel.match_to == null) {
        print('HEREEE 1');
        refresh_selectedCustomUserRespJModel_Match_To_NavigationDataBLoC(true);
        isDataValid = false;
      }
    }

    if (!isDataValid) {
      refreshLoader(false, navigationDataBLoC_Loader);
      return false;
    }

    //UPLOAD MATCH

    DateMatchRespJModel dateMatchRespJModel = await post_put_user_Match(
      context,
      snackbarBuildContext,
      navigationDataBLoC_Loader,
      widget.dateMatchReqJModel,
      false,
    );
    if (dateMatchRespJModel != null) {
      widget.dateMatchReqJModel.id = dateMatchRespJModel.id;
    }
  }

  //on_isuserrequested_Val_Changed
  on_isuserrequested_Val_Changed(value) {
    isuserrequested_Val = value;
    refresh_on_isuserrequested_Val_Changed_NavigationDataBLoC();
  }

  //on_isApproved_Val_Changed
  on_isApproved_Val_Changed(value) {
    isApproved_Val = value;
    widget.dateMatchReqJModel.approved = isApproved_Val;
    refresh_on_isApproved_Val_Changed_NavigationDataBLoC();
  }

  //on_isActive_Val_Changed
  on_isActive_Val_Changed(value) {
    isActive_Val = value;
    widget.dateMatchReqJModel.active = isActive_Val;
    refresh_on_isActive_Val_Changed_NavigationDataBLoC();
  }

  //END OF WIDGET FUNCTIONS

  //LOGIC
  //INTERESTED IN  LOGIC
  Future<void> _interested_in_RadioValueChange(int value) async {
    String TAG = '_ohs_approvalRadioValueChange:';
    print(TAG);
    if (value == -1) {
      refresh_selectedGenderRespModel_NavigationDataBLoC(true);
    } else {
      refresh_selectedGenderRespModel_NavigationDataBLoC(false);
    }
    _interested_in_RadioValue = value;
    widget.dateMatchReqJModel.interestedin = _interested_in_RadioValue;
    refresh_interested_in_Changed_DailySubTaskImagesBLoC();
  }

  //END OF INTERESTED IN LOGIC
  on_fb_insta_link_tapped() async {
    if (isStringValid(widget.dateMatchReqJModel.fb_insta_link)) {
      if (await canLaunch(widget.dateMatchReqJModel.fb_insta_link)) {
        await launch(widget.dateMatchReqJModel.fb_insta_link);
      } else {
        showSnackbarWBgCol(
            'Could not launch link', snackbarBuildContext, DatingAppTheme.red);
      }
    } else {
      showSnackbarWBgCol(
          'Could not launch link', snackbarBuildContext, DatingAppTheme.red);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
