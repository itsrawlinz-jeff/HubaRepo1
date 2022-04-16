import 'dart:convert';
import 'dart:io';

import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleBLoC.dart';
import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleEvent.dart';
import 'package:dating_app/Bloc/Streams/RegistrationPage/PageDraggerEvent.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_customusers_online.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_datematchdecisions_online.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_genders_online.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_put_match.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_validate_mpesa_payment.dart';
import 'package:dating_app/CustomWidgets/dropdowns/CustomUserPickerOnline.dart';
import 'package:dating_app/CustomWidgets/dropdowns/MatchDecisionPickerOnline.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/gender/GenderListRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/gender/GenderRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/DateMatchRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/MatchDecisionListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/MatchDecisionRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/payment/MpesaPaymentRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/matches/DateMatchReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/navigation/DonationReqJModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/CustomWidgets/CustomTitleView.dart';
import 'package:dating_app/UI/Presentation/ExpandedBubbleChip/ExpandedBubbleChip.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/UI/Presentation/admin_drawer/home_drawer.dart';
import 'package:dating_app/UI/Presentation/builders/column_builder.dart';
import 'package:dating_app/UI/Presentation/dialogs/AddNewIllnessDialog.dart';
import 'package:dating_app/UI/Presentation/dialogs/PhoneNoAmountDialog.dart';
import 'package:dating_app/UI/Presentation/dialogs/PhoneNoDialog.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:after_layout/after_layout.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'dart:math' as math;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:dating_app/extlibs/lipanampesa/lib/lipa_na_mpesa_online.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserCreateEditMatchRequest extends StatefulWidget {
  DateMatchReqJModel dateMatchReqJModel;
  DateMatchRespJModel dateMatchRespJModel;
  UserCreateEditMatchRequest({
    this.dateMatchReqJModel,
    this.dateMatchRespJModel,
    Key key,
  }) : super(key: key);

  @override
  _UserCreateEditMatchRequestState createState() =>
      _UserCreateEditMatchRequestState();
}

class _UserCreateEditMatchRequestState extends State<UserCreateEditMatchRequest>
    with
        TickerProviderStateMixin,
        AfterLayoutMixin<UserCreateEditMatchRequest> {
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
  NavigationDataBLoC navigationDataBLoC_Pay_Loader = NavigationDataBLoC();
  RefreshController _refreshController = RefreshController();
  bool _autoValidateF1 = false;
  GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  BuildContext snackbarBuildContext;

  //DROPDOWNS STATES
  NavigationDataBLoC onCustomUserRespJModelsChanged_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC selectedCustomUserRespJModelChanged_NavigationDataBLoC =
      NavigationDataBLoC();

  NavigationDataBLoC selectedCustomUserRespJModel_NavigationDataBLoC =
      NavigationDataBLoC();

  NavigationDataBLoC onMatchDecisionRespJModelsChanged_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC selectedMatchDecisionRespJModel_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC selectedMatchDecisionRespJModelChanged_NavigationDataBLoC =
      NavigationDataBLoC();

  NavigationDataBLoC onGenderRespModelsChanged_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC selectedGenderRespModel_NavigationDataBLoC =
      NavigationDataBLoC();

  //END OF DROPDOWN STATES
  //INTERESTED IN STATE
  NavigationDataBLoC interested_in_Changed_DailySubTaskImagesBLoC =
      NavigationDataBLoC();

  //END OF INTERESTED IN STATE
  List<CustomUserRespJModel> allCustomUserRespJModelList = [];
  CustomUserRespJModel selected_CustomUserRespJModel;

  MatchDecisionRespJModel selected_MatchDecisionRespJModel;

  //DECISION DROPDOWN
  List<MatchDecisionRespJModel> allMatchDecisionRespJModelList = [];
  LoginRespModel loginRespModel;
  int _interested_in_RadioValue = -1;

  RangeValues _rvalues = new RangeValues(18, 100);
  List<GenderRespModel> allGenderRespModelList = [];
  GenderRespModel selectedGenderRespModel;

  FocusNode fbinsta_FocusNode = FocusNode();
  TextEditingController fbinsta_TextEditingController = TextEditingController();

  FocusNode mpesa_code_FocusNode = FocusNode();
  TextEditingController mpesa_code_TextEditingController =
      TextEditingController();

  NavigationDataBLoC wd_fbinsta_Container_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC wd_mpesa_code_Container_NavigationDataBLoC =
      NavigationDataBLoC();
  bool stk_push_in_progress = false;

  //RECORD SAVED
  NavigationDataBLoC record_Saved_NavigationDataBLoC = NavigationDataBLoC();

  //DECISION
  NavigationDataBLoC decision_suggestions_changed_NavigationDataBLoC =
      NavigationDataBLoC();

  @override
  void initState() {
    print('UserCreateEditMatchRequest:initState');
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
    print('UserCreateEditMatchRequest:afterFirstLayout');
    getLoggedInUser();
    addListeners();
  }

  @override
  void dispose() {
    print('UserCreateEditMatchRequest:dispose');
    if (animationController != null) {
      animationController.dispose();
    }
    super.dispose();
  }

  //AFTER FIRST LAYOUT FUNCTIONS
  getLoggedInUser() async {
    loginRespModel = await getSessionLoginRespModel(context);

    setUpData(
      context,
      true,
    );
  }

  addListeners() {
    KeyboardVisibility.onChange.listen(
      (bool visible) {
        keyBoardVisibleBLoC.keyboard_visible_event_sink
            .add(ToggleKeyBoardVisEvent(visible));
      },
    );
  }

  setUpData(BuildContext context, bool isInitial) async {
    //LNK
    if (isStringValid(widget.dateMatchRespJModel.fb_insta_link)) {
      fbinsta_TextEditingController.text =
          widget.dateMatchRespJModel.fb_insta_link;
    }

    //MPESA CODE
    if (isStringValid(widget.dateMatchReqJModel.mpesa_code)) {
      mpesa_code_TextEditingController.text =
          widget.dateMatchReqJModel.mpesa_code;
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

      setState(() {
        _rvalues = new RangeValues(((lowval != null ? lowval.toDouble() : 18)),
            ((highval != null ? highval.toDouble() : 100)));
      });
    }
    //QUERY fks
    if (widget.dateMatchRespJModel.matching_user != null) {
      selected_CustomUserRespJModel = widget.dateMatchRespJModel.matching_user;
      widget.dateMatchReqJModel.matching_user =
          selected_CustomUserRespJModel.id;
      refresh_selectedCustomUserRespJModelChanged_NavigationDataBLoC();
      refresh_selectedCustomUserRespJModel_NavigationDataBLoC(false);
    }

    if (widget.dateMatchRespJModel.decision != null) {
      selected_MatchDecisionRespJModel = widget.dateMatchRespJModel.decision;
      widget.dateMatchReqJModel.decision = selected_MatchDecisionRespJModel.id;
      refresh_selectedMatchDecisionRespJModelChanged_NavigationDataBLoC();
      refresh_selectedMatchDecisionRespJModel_NavigationDataBLoC(false);
    }

    fetchRefresh_allGenderList(context);
    fetchRefresh_allCustomUserList(context);
    fetchRefresh_allMatchDecisionList(context);

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
        await fetch_datematchdecisions_online_limit_without_nope(
      context,
      DatingAppStaticParams.default_Max_int,
      true.toString(),
    );
    if (matchDecisionListRespJModel != null) {
      allMatchDecisionRespJModelList = matchDecisionListRespJModel.results;
      refresh_onMatchDecisionRespJModelsChanged_NavigationDataBLoC();
      refresh_decision_suggestions_changed_NavigationDataBLoC();
    }
  }

  fetchRefresh_allGenderList(BuildContext context) async {
    GenderListRespModel genderListRespModel =
        await fetch_genders_online_limit_without_prefernottosay(
      context,
      DatingAppStaticParams.default_Max_int,
      true.toString(),
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

  refresh_selectedMatchDecisionRespJModel_NavigationDataBLoC(bool isError) {
    NavigationData navigationData = NavigationData();
    navigationData.isShow = isError;
    refresh_W_Data_NavigationDataBLoC(
        selectedMatchDecisionRespJModel_NavigationDataBLoC, navigationData);
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

  refresh_wd_fbinsta_Container_NavigationDataBLoC() {
    refresh_WO_Data_NavigationDataBLoC(wd_fbinsta_Container_NavigationDataBLoC);
  }

  refresh_selectedGenderRespModel_NavigationDataBLoC(bool isError) {
    NavigationData navigationData = NavigationData();
    navigationData.isShow = isError;
    refresh_W_Data_NavigationDataBLoC(
        selectedGenderRespModel_NavigationDataBLoC, navigationData);
  }

  refresh_decision_suggestions_changed_NavigationDataBLoC() {
    NavigationData navigationData = NavigationData();
    navigationData.matchDecisionRespJModelList = allMatchDecisionRespJModelList;
    refresh_W_Data_NavigationDataBLoC(
        decision_suggestions_changed_NavigationDataBLoC, navigationData);
  }
  //END OF STATE CHANGES

  @override
  Widget build(BuildContext context) {
    print('UserCreateEditMatchRequest:build');
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
    //refreshLoader(true, navigationDataBLoC_Pay_Loader);
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
                enablePullUp: false,
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
                      titleTxt: 'Match UUUI',
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
                                              top: 16, bottom: 3),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              /*Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    top: 8,
                                                    bottom: 0),
                                                child: Text(
                                                  '(This service costs ksh 200)',
                                                  style: datingAppThemeChanger
                                                      .selectedThemeData
                                                      .txt_stl_obl_whitegrey_14_Med_pltf_grey,
                                                ),
                                              ),*/
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
                                                        ),
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
                                                        ),
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
                                              StreamBuilder(
                                                  stream:
                                                      onGenderRespModelsChanged_NavigationDataBLoC
                                                          .stream_counter,
                                                  builder: (context, snapshot) {
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
                                                            children: <Widget>[
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            16,
                                                                        right:
                                                                            16,
                                                                        top: 8,
                                                                        bottom:
                                                                            0),
                                                                child: Stack(
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              25),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                            'Interested in:',
                                                                            style:
                                                                                datingAppThemeChanger.selectedThemeData.txt_stl_whitegrey_14_Med_pltf_grey,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    StreamBuilder(
                                                                      stream: selectedGenderRespModel_NavigationDataBLoC
                                                                          .stream_counter,
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        if (snapshot
                                                                            .hasError)
                                                                          return invisibleWidget();
                                                                        switch (
                                                                            snapshot.connectionState) {
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
                                                                            return ifToShow_positionedNotificationIcon_WDims(
                                                                                snapshot,
                                                                                2,
                                                                                -2);
                                                                            break;
                                                                          case ConnectionState
                                                                              .done:
                                                                            return ifToShow_positionedNotificationIcon_WDims(
                                                                                snapshot,
                                                                                2,
                                                                                -2);
                                                                            break;
                                                                        }
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  left: 16,
                                                                  right: 16,
                                                                  top: 6,
                                                                ),
                                                                child:
                                                                    StreamBuilder(
                                                                        stream: interested_in_Changed_DailySubTaskImagesBLoC
                                                                            .stream_counter,
                                                                        builder:
                                                                            (context,
                                                                                ohs_approval_snapshot) {
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
                                                                                        onChanged: _interested_in_RadioValueChange,
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
                                                                                      onTap: () {
                                                                                        _interested_in_RadioValueChange(genderRespModel.id);
                                                                                      },
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
                                                                          /*return Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.min,
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
                                                                                        value: 0,
                                                                                        activeColor: datingAppThemeChanger.selectedThemeData.cl_cont_Sel_ClickableItem,
                                                                                        groupValue: _interested_in_RadioValue,
                                                                                        onChanged: _interested_in_RadioValueChange,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Material(
                                                                                    color: Colors.transparent,
                                                                                    child: InkWell(
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.only(left: 1, right: 2, top: 3, bottom: 3),
                                                                                        child: Text(
                                                                                          'Women',
                                                                                          style: datingAppThemeChanger.selectedThemeData.txt_stl_whitegrey_14_Med_pltf_grey,
                                                                                        ),
                                                                                      ),
                                                                                      onTap: () {
                                                                                        _interested_in_RadioValueChange(0);
                                                                                      },
                                                                                      splashColor: DatingAppTheme.pltf_grey,
                                                                                      borderRadius: BorderRadius.all(
                                                                                        Radius.circular(10.0),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.min,
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
                                                                                        value: 1,
                                                                                        activeColor: datingAppThemeChanger.selectedThemeData.cl_cont_Sel_ClickableItem,
                                                                                        groupValue: _interested_in_RadioValue,
                                                                                        onChanged: _interested_in_RadioValueChange,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Material(
                                                                                    color: Colors.transparent,
                                                                                    child: InkWell(
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.only(left: 1, right: 2, top: 3, bottom: 3),
                                                                                        child: Text(
                                                                                          'Men',
                                                                                          style: datingAppThemeChanger.selectedThemeData.txt_stl_whitegrey_14_Med_pltf_grey,
                                                                                        ),
                                                                                      ),
                                                                                      onTap: () {
                                                                                        _interested_in_RadioValueChange(1);
                                                                                      },
                                                                                      splashColor: DatingAppTheme.pltf_grey,
                                                                                      borderRadius: BorderRadius.all(
                                                                                        Radius.circular(10.0),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          );*/
                                                                        }),
                                                              ),
                                                            ],
                                                          )
                                                        : invisibleWidget()));
                                                  }),
                                              Padding(
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
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    top: 0,
                                                    bottom: 3),
                                                child: RangeSlider(
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
                                                    onChangeStart:
                                                        (RangeValues values) {},
                                                    onChangeEnd:
                                                        (RangeValues values) {
                                                      updateSelectedAge(
                                                          _rvalues);
                                                    },
                                                    onChanged:
                                                        (RangeValues values) {
                                                      setState(() {
                                                        _rvalues = values;
                                                      });
                                                    }),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    top: 0,
                                                    bottom: 3),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3,
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
                                              /*Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    top: 8,
                                                    bottom: 0),
                                                child: Text(
                                                  'Facebook/Instagram Link',
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
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  DatingAppTheme
                                                                      .white,
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          8.0),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          8.0),
                                                                  bottomRight: Radius
                                                                      .circular(
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
                                                                        const Offset(
                                                                            0,
                                                                            2),
                                                                    blurRadius:
                                                                        10.0),
                                                              ],
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 16,
                                                                      right: 16,
                                                                      top: 0,
                                                                      bottom:
                                                                          0),
                                                              child:
                                                                  TextFormField(
                                                                onChanged:
                                                                    (String
                                                                        txt) {
                                                                  onSafety_FbInstaLinkChanged();
                                                                },
                                                                style: datingAppThemeChanger
                                                                    .selectedThemeData
                                                                    .txt_stl_f14w500_Med,
                                                                cursorColor:
                                                                    datingAppThemeChanger
                                                                        .selectedThemeData
                                                                        .cl_grey,
                                                                decoration:
                                                                    InputDecoration(
                                                                  icon: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: <
                                                                        Widget>[
                                                                      Icon(
                                                                        FontAwesomeIcons
                                                                            .facebook,
                                                                        color: datingAppThemeChanger
                                                                            .selectedThemeData
                                                                            .cl_grey,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                      Icon(
                                                                        FontAwesomeIcons
                                                                            .instagram,
                                                                        color: datingAppThemeChanger
                                                                            .selectedThemeData
                                                                            .cl_grey,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText: '',
                                                                  hintStyle: datingAppThemeChanger
                                                                      .selectedThemeData
                                                                      .txt_stl_hint_f14w500_Med,
                                                                ),
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .done,
                                                                controller:
                                                                    fbinsta_TextEditingController,
                                                                focusNode:
                                                                    fbinsta_FocusNode,
                                                                autofocus:
                                                                    false,
                                                                onFieldSubmitted:
                                                                    (String
                                                                        val) {},
                                                                validator:
                                                                    validateFbInstaLink,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    StreamBuilder(
                                                      stream:
                                                          wd_fbinsta_Container_NavigationDataBLoC
                                                              .stream_counter,
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasError) {
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
                                                  ],
                                                ),
                                              ),*/
                                              /*Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    top: 8,
                                                    bottom: 3),
                                                child: Text(
                                                  'Billing',
                                                  style: datingAppThemeChanger
                                                      .selectedThemeData
                                                      .txt_stl_whitegrey_14_Med_pltf_grey,
                                                ),
                                              ),
                                              SizedBox(
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        80) /
                                                    2,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16,
                                                      right: 16,
                                                      bottom: 3),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Material(
                                                          color: DatingAppTheme
                                                              .transparent,
                                                          child: InkWell(
                                                            onTap: () {
                                                              print(
                                                                  'Log in clicked');
                                                            },
                                                            splashColor:
                                                                DatingAppTheme
                                                                    .ks_black_7,
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        8.0),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        8.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        8.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        8.0)),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: DatingAppTheme
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.7),
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            3.0),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            3.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            3.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            3.0)),
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
                                                              child: Center(
                                                                child: Text(
                                                                  'Pay Ksh 200',
                                                                  style: datingAppThemeChanger
                                                                      .selectedThemeData
                                                                      .txt_stl_whitegrey_14_Med_pltf_grey,
                                                                ),
                                                              ),
                                                              height: 30,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),*/
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: datingAppThemeChanger
                                          .selectedThemeData.bg_task_Item,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0)),
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
                                              top: 16, bottom: 3),
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
                                                    'Mpesa Code',
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
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child:
                                                                StreamBuilder(
                                                              stream: record_Saved_NavigationDataBLoC
                                                                  .stream_counter,
                                                              builder: (context,
                                                                  snapshot) {
                                                                return Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: ((widget.dateMatchReqJModel.id ==
                                                                                null ||
                                                                            (widget.dateMatchReqJModel.id != null
                                                                                &&
                                                                                widget
                                                                                    .dateMatchReqJModel.mpesa_payment==null
                                                                                /*!isStringValid(widget
                                                                                    .dateMatchReqJModel.mpesa_code)*/
                                                                            )
                                                                        ? DatingAppTheme
                                                                            .white
                                                                        : datingAppThemeChanger
                                                                            .selectedThemeData
                                                                            .cl_darkerText_bg_Grey3))
                                                                    /*((widget.dateMatchReqJModel.id ==
                                                                            null
                                                                        ? DatingAppTheme
                                                                            .white
                                                                        : datingAppThemeChanger
                                                                            .selectedThemeData
                                                                            .cl_darkerText_bg_Grey3))*/
                                                                    ,
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
                                                                    child: TextFormField(
                                                                        onChanged: (String txt) {
                                                                          onMpesaCode_Changed();
                                                                        },
                                                                        keyboardType: TextInputType.text,
                                                                        style: datingAppThemeChanger.selectedThemeData.txt_stl_f14w500_Med,
                                                                        cursorColor: datingAppThemeChanger.selectedThemeData.cl_grey,
                                                                        decoration: InputDecoration(
                                                                          icon:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: <Widget>[
                                                                              Icon(
                                                                                Icons.attach_money,
                                                                                color: DatingAppTheme.pltf_grey,
                                                                                size: 20,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          border:
                                                                              InputBorder.none,
                                                                          hintText:
                                                                              'Mpesa Code',
                                                                          hintStyle: datingAppThemeChanger
                                                                              .selectedThemeData
                                                                              .txt_stl_hint_f14w500_Med_pltf_grey,
                                                                        ),
                                                                        textInputAction: TextInputAction.done,
                                                                        controller: mpesa_code_TextEditingController,
                                                                        focusNode: mpesa_code_FocusNode,
                                                                        autofocus: false,
                                                                        onFieldSubmitted: (String val) {},
                                                                        /*enabled: widget
                                                                              .dateMatchReqJModel
                                                                              .id ==
                                                                          null*/
                                                                        enabled: widget.dateMatchReqJModel.id == null || (
                                                                            widget.dateMatchReqJModel.id != null
                                                                                &&
                                                                                widget
                                                                                    .dateMatchReqJModel.mpesa_payment==null
                                                                                /*!isStringValid(widget.dateMatchReqJModel.mpesa_code)*/
                                                                        )),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          StreamBuilder(
                                                            stream: record_Saved_NavigationDataBLoC
                                                                .stream_counter,
                                                            builder: (context,
                                                                snapshot) {
                                                              return /*((widget
                                                                          .dateMatchReqJModel
                                                                          .id ==
                                                                      null*/
                                                                  ((widget.dateMatchReqJModel.id ==
                                                                              null ||
                                                                          (widget.dateMatchReqJModel.id != null &&

                                                                              //!isStringValid(widget.dateMatchReqJModel.mpesa_code)
                                                                              widget
                                                                              .dateMatchReqJModel.mpesa_payment==null
                                                                          )
                                                                      ? Padding(
                                                                          padding:
                                                                              EdgeInsets.only(left: 8),
                                                                          child:
                                                                              Stack(
                                                                            alignment:
                                                                                Alignment.centerRight,
                                                                            children: <Widget>[
                                                                              Container(
                                                                                //height: 40,
                                                                                //width: 40,
                                                                                decoration: BoxDecoration(
                                                                                  color: DatingAppTheme.green_open.withOpacity(0.8),
                                                                                  borderRadius: const BorderRadius.all(
                                                                                    Radius.circular(5.0),
                                                                                  ),
                                                                                  /*BorderRadius.all(
                                                        Radius.circular(
                                                            43.0),
                                                      ),*/
                                                                                  boxShadow: <BoxShadow>[
                                                                                    BoxShadow(color: DatingAppTheme.nearlyBlack.withOpacity(0.4), offset: const Offset(0, 2), blurRadius: 8.0),
                                                                                  ],
                                                                                ),
                                                                                child: Material(
                                                                                  color: Colors.transparent,
                                                                                  child: InkWell(
                                                                                    borderRadius: const BorderRadius.all(
                                                                                      Radius.circular(5.0),
                                                                                    ),
                                                                                    /*const BorderRadius.all(
                                                          Radius.circular(43.0),
                                                        ),*/
                                                                                    onTap: () {
                                                                                      /*_on_Click_STK(
                                                                      context);*/
                                                                                      _addNewIllness();
                                                                                    },
                                                                                    child:
                                                                                        /*Stack(
                                                                              alignment: Alignment.center,
                                                                              children: <Widget>[*/
                                                                                        Row(
                                                                                      children: <Widget>[
                                                                                        Padding(
                                                                                          padding: EdgeInsets.only(
                                                                                            top: 2,
                                                                                            bottom: 2,
                                                                                            left: 2,
                                                                                            right: 2,
                                                                                          ),
                                                                                          child: Text(
                                                                                            'Donate',
                                                                                            style: TextStyle(
                                                                                              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: 14,
                                                                                              letterSpacing: -0.2,
                                                                                              color: DatingAppTheme.white,
                                                                                            ),
                                                                                            textAlign: TextAlign.center,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                    ),
                                                                                    /*streamBuilderWidgetLoader(
                                                                                  navigationDataBLoC_Pay_Loader,
                                                                                  DatingAppTheme.white,
                                                                                  8,
                                                                                  false,
                                                                                  0,
                                                                                  0,
                                                                                  null,
                                                                                  null,
                                                                                ),*/
                                                                                    /*],
                                                                            ),*/
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              streamBuilderWidgetLoader(
                                                                                navigationDataBLoC_Pay_Loader,
                                                                                DatingAppTheme.white,
                                                                                8,
                                                                                false,
                                                                                0,
                                                                                0,
                                                                                15,
                                                                                15,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : invisibleWidget()));
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      StreamBuilder(
                                                        stream:
                                                            wd_mpesa_code_Container_NavigationDataBLoC
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
                                              ]),
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
      ignoring: true,
      child: CustomUserPickerOnline(
        dense: false,
        onlineuserList: allCustomUserRespJModelList,
        showFlag: true,
        showDialingCode: true,
        showName: false,
        hintText: 'User',
        onChanged: (CustomUserRespJModel customUserRespJModel) {
          selected_CustomUserRespJModel = customUserRespJModel;
          widget.dateMatchReqJModel.matching_user =
              selected_CustomUserRespJModel.id;

          refresh_selectedCustomUserRespJModel_NavigationDataBLoC(false);
        },
        selectedCustomUserRespJModel: selected_CustomUserRespJModel,
        selectedCustomUserRespJModelChanged_NavigationDataBLoC:
            selectedCustomUserRespJModelChanged_NavigationDataBLoC,
        isDisabled: true,
      ),
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
      suggestions_changed_NavigationDataBLoC:
          decision_suggestions_changed_NavigationDataBLoC,
    );
  }
  //END OF DROPDOWN WIDGETS

  //WIDGET FUNCTIONS
  saveAndUpload_MatchData(BuildContext context) async {
    bool isDataValid = true;
    refreshLoader(true, navigationDataBLoC_Loader);

    if (_formKey1.currentState.validate()) {
      _formKey1.currentState.save();
      setState(() {
        _autoValidateF1 = true;
      });
    } else {
      _formKey1.currentState.save();
      setState(() {
        _autoValidateF1 = true;
      });
      isDataValid = false;
    }

    /*bool fbInstaLink_Valid = is_FbInstaLink_Valid();
    if (!fbInstaLink_Valid) {
      isDataValid = false;
    }*/

    if (!isIntValid(widget.dateMatchReqJModel.matching_user)) {
      refresh_selectedCustomUserRespJModel_NavigationDataBLoC(true);
      isDataValid = false;
    }

    if (!isIntValid(widget.dateMatchReqJModel.decision)) {
      refresh_selectedMatchDecisionRespJModel_NavigationDataBLoC(true);
      isDataValid = false;
    }

    if (!isIntValid(widget.dateMatchReqJModel.interestedin)) {
      refresh_selectedGenderRespModel_NavigationDataBLoC(true);
      isDataValid = false;
    }

    /*bool mpesaCode_Valid = await is_MpesaCode_Valid();
    if (!mpesaCode_Valid) {
      isDataValid = false;
    }*/

    /*if (widget.dateMatchReqJModel.mpesa_code == null) {
      refresh_wd_ValidationField_Container_NavigationDataBLoC(
          wd_mpesa_code_Container_NavigationDataBLoC,
          false,
          'mpesa payment not found');
      isDataValid = false; //PGJ2J2RXCO
    }*/

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
      true,
    );
    if (dateMatchRespJModel != null) {
      widget.dateMatchReqJModel.id = dateMatchRespJModel.id;
      widget.dateMatchRespJModel.id = widget.dateMatchReqJModel.id;
      if (dateMatchRespJModel.mpesa_payment != null) {
        widget.dateMatchReqJModel.mpesa_code =
            dateMatchRespJModel.mpesa_payment.mpesa_receipt_number;
      }

      refresh_WO_Data_NavigationDataBLoC(record_Saved_NavigationDataBLoC);
    }
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

  //AGE LOGIC
  updateSelectedAge(RangeValues rangeValues) async {
    widget.dateMatchReqJModel.age_low = rangeValues.start.toInt();
    widget.dateMatchReqJModel.age_high = rangeValues.end.toInt();
  }
  //END OF AGE LOGIC

  //FB_INSTA_VALIDATION LOGIC
  onSafety_FbInstaLinkChanged() {
    widget.dateMatchReqJModel.fb_insta_link =
        fbinsta_TextEditingController.text;
  }

  String validateFbInstaLink(String strVal) {
    if (!isStringValid(widget.dateMatchReqJModel.fb_insta_link)) {
      refresh_wd_ValidationField_Container_NavigationDataBLoC(
          wd_fbinsta_Container_NavigationDataBLoC, false, 'invalid link');
      return null;
    } else {
      //IS VALID
      RegExp regex = new RegExp(get_Url_Pattern());
      if (!regex.hasMatch(widget.dateMatchReqJModel.fb_insta_link)) {
        refresh_wd_ValidationField_Container_NavigationDataBLoC(
            wd_fbinsta_Container_NavigationDataBLoC, false, 'invalid link');
        return null;
      }
    }
    refresh_wd_ValidationField_Container_NavigationDataBLoC(
        wd_fbinsta_Container_NavigationDataBLoC, true, null);
    return null;
  }

  bool is_FbInstaLink_Valid() {
    if (!isStringValid(widget.dateMatchReqJModel.fb_insta_link)) {
      refresh_wd_ValidationField_Container_NavigationDataBLoC(
          wd_fbinsta_Container_NavigationDataBLoC, false, 'invalid link');
      return false;
    } else {
      //IS VALID
      RegExp regex = new RegExp(get_Url_Pattern());
      if (!regex.hasMatch(widget.dateMatchReqJModel.fb_insta_link)) {
        refresh_wd_ValidationField_Container_NavigationDataBLoC(
            wd_fbinsta_Container_NavigationDataBLoC, false, 'invalid link');
        return false;
      }
    }
    refresh_wd_ValidationField_Container_NavigationDataBLoC(
        wd_fbinsta_Container_NavigationDataBLoC, true, null);
    return true;
  }

  onMpesaCode_Changed() {
    widget.dateMatchReqJModel.mpesa_code =
        mpesa_code_TextEditingController.text;
    is_MpesaCode_Valid();
  }

  Future<bool> is_MpesaCode_Valid() async {
    widget.dateMatchReqJModel.mpesa_payment = null;
    print("is_MpesaCode_Valid");
    if (!isStringValid(widget.dateMatchReqJModel.mpesa_code)) {
      print("is_MpesaCode_Valid 1");
      refresh_wd_ValidationField_Container_NavigationDataBLoC(
          wd_mpesa_code_Container_NavigationDataBLoC,
          false,
          'invalid mpesa code');
      return false;
    } else {
      print("is_MpesaCode_Valid 2");
      if (widget.dateMatchRespJModel.id != null &&
          widget.dateMatchRespJModel.mpesa_payment != null) {
        print("is_MpesaCode_Valid 3");
        refresh_wd_ValidationField_Container_NavigationDataBLoC(
            wd_mpesa_code_Container_NavigationDataBLoC, true, null);
        return true;
      }
      MpesaPaymentRespJModel mpesaPaymentRespJModel =
          await validatepayment_by_mpesacode(
        context,
        null,
        widget.dateMatchReqJModel.mpesa_code,
        null,
      );
      if (mpesaPaymentRespJModel != null) {
        print("is_MpesaCode_Valid 4");
        if (mpesaPaymentRespJModel.is_found) {
          print("is_MpesaCode_Valid 5");
          if (mpesaPaymentRespJModel.already_used) {
            print("is_MpesaCode_Valid 6");
            refresh_wd_ValidationField_Container_NavigationDataBLoC(
                wd_mpesa_code_Container_NavigationDataBLoC,
                false,
                'mpesa code already used');
            return false;
          } else {
            print("is_MpesaCode_Valid 7");
            //IS FOUND AND IS NOT USED
            widget.dateMatchReqJModel.mpesa_payment =
                mpesaPaymentRespJModel.mpesa_payment.id;
            refresh_wd_ValidationField_Container_NavigationDataBLoC(
                wd_mpesa_code_Container_NavigationDataBLoC, true, null);
            return true;
          }
        } else {
          print("is_MpesaCode_Valid 8");
          refresh_wd_ValidationField_Container_NavigationDataBLoC(
              wd_mpesa_code_Container_NavigationDataBLoC,
              false,
              'mpesa code not found');
          return false;
        }
      } else {
        print("is_MpesaCode_Valid 9");
        refresh_wd_ValidationField_Container_NavigationDataBLoC(
            wd_mpesa_code_Container_NavigationDataBLoC,
            false,
            'error validating mpesa code');
        return false;
      }
    }
  }
  /*Future<bool> is_MpesaCode_Valid() async {
    widget.dateMatchReqJModel.mpesa_payment = null;
    if (!isStringValid(widget.dateMatchReqJModel.mpesa_code)) {
      refresh_wd_ValidationField_Container_NavigationDataBLoC(
          wd_mpesa_code_Container_NavigationDataBLoC,
          false,
          'invalid mpesa code');
      return false;
    } else {
      if (widget.dateMatchRespJModel.id != null) {
        refresh_wd_ValidationField_Container_NavigationDataBLoC(
            wd_mpesa_code_Container_NavigationDataBLoC, true, null);
        return true;
      }
      MpesaPaymentRespJModel mpesaPaymentRespJModel =
          await validatepayment_by_mpesacode(
        context,
        null,
        widget.dateMatchReqJModel.mpesa_code,
        null,
      );
      if (mpesaPaymentRespJModel != null) {
        if (mpesaPaymentRespJModel.is_found) {
          if (mpesaPaymentRespJModel.already_used) {
            refresh_wd_ValidationField_Container_NavigationDataBLoC(
                wd_mpesa_code_Container_NavigationDataBLoC,
                false,
                'mpesa code already used');
            return false;
          } else {
            //IS FOUND AND IS NOT USED
            widget.dateMatchReqJModel.mpesa_payment =
                mpesaPaymentRespJModel.mpesa_payment.id;
            refresh_wd_ValidationField_Container_NavigationDataBLoC(
                wd_mpesa_code_Container_NavigationDataBLoC, true, null);
            return true;
          }
        } else {
          refresh_wd_ValidationField_Container_NavigationDataBLoC(
              wd_mpesa_code_Container_NavigationDataBLoC,
              false,
              'mpesa code not found');
          return false;
        }
      } else {
        refresh_wd_ValidationField_Container_NavigationDataBLoC(
            wd_mpesa_code_Container_NavigationDataBLoC,
            false,
            'error validating mpesa code');
        return false;
      }
    }
  }*/

  //VALIDATORS
  //PHONE NO

  bool validate_Phone_No(String phone_no) {
    if (isStringValid(phone_no)) {
      RegExp regex = new RegExp(get_Phone_Pattern());
      if (!regex.hasMatch(phone_no)) {
        showSnackbarWBgCol('enter a valid phone number 254xxxxxxxxx',
            snackbarBuildContext, DatingAppTheme.red);
        return false;
      } else {
        return true;
      }
    } else {
      showSnackbarWBgCol(
          'phone number is invalid', snackbarBuildContext, DatingAppTheme.red);
      return false;
    }
  }

  bool validate_Amount(int amount) {
    if (amount != null && amount != 0) {
      return true;
    } else {
      showSnackbarWBgCol(
          'amount is invalid', snackbarBuildContext, DatingAppTheme.red);
      return false;
    }
  }
  //END OF PHONE NO
  //END OF VALIDATORS

  //END OF FB_INSTA_VALIDATION LOGIC

  //STK PUSH
  //phone no dialog
  _addNewIllness() async {
    DonationReqJModel initial_donationReqJModel = DonationReqJModel();
    DonationReqJModel donationReqJModel = await showGeneralDialog(
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: null,
        transitionDuration: Duration(milliseconds: 150),
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return new PhoneNoAmountDialog(
            snackbarBuildContext: snackbarBuildContext,
            animationController: animationController,
            phone_no: initial_donationReqJModel,
          );
        });

    if (donationReqJModel != null &&
        validate_Phone_No(donationReqJModel.phone_no) &&
        validate_Amount(donationReqJModel.amount)) {
      print('phone_no is valid');
      print('phone_no==');
      print(donationReqJModel.phone_no.toString());
      print('amount==');
      print(donationReqJModel.amount.toString());
      _on_Click_STK(context, donationReqJModel);
    }
  }

  _on_Click_STK(BuildContext context, DonationReqJModel donationReqJModel) {
    String TAG = '_on_Click_STK';
    refreshLoader(true, navigationDataBLoC_Pay_Loader);
    if (stk_push_in_progress) {
      showSnackbarWBgCol('Another transaction is already in progress',
          snackbarBuildContext, DatingAppTheme.red);
      return;
    }
    stk_push_in_progress = true;
    print(TAG);
    MpesaService.lipanampesa(
      env['lipa_na_mpesa_passkey'],
      env['business_short_code'],
      env['consumer_key'],
      env['consumer_secret'],
      donationReqJModel.phone_no,
      //env['phone_number'],
      env['transactiontype_c_pbo'],
      donationReqJModel.amount,
      //'https://eae0-105-163-23-148.ngrok.io/sl_mpesac2bcallback',
      env['callbackurl'],
      //env['callbackurl'],
      //'ACC 1',
      donationReqJModel.phone_no,
      env['transaction_desc'],
      apiCredintialURL:
          env['api_credintial_url'],
      apiurlforstkpush:
          env['apiurlforstkpush'],
    ).then(
      (value) {
        if (value != null) {
          bool isError = false;
          try {
            String rtm_MerchantRequestID = value['MerchantRequestID'];
            if (rtm_MerchantRequestID != null) {
              print('MerchantRequestID = ' + rtm_MerchantRequestID);
            }
          } catch (error) {
            print(TAG + ' error1==');
            print(error.toString());
            isError = true;
          }

          if (isError) {
            try {
              print(TAG + ' at 2');
              if (value.statusCode != 200) {
                print('errorCode==');
                print(json.decode(value.body)['errorCode']);
                print(json.decode(value.body));
              }

              isError = false;
            } catch (error) {
              print(TAG + ' error2==');
              print(error.toString());
            }
          }

          stk_push_in_progress = false;
          refreshLoader(false, navigationDataBLoC_Pay_Loader);
        } else {
          print(TAG + ' value == null');

          stk_push_in_progress = false;
          refreshLoader(false, navigationDataBLoC_Pay_Loader);
        }
      },
    );
  }
  /*_on_Click_STK(BuildContext context, String phone_no) {
    String TAG = '_on_Click_STK';
    refreshLoader(true, navigationDataBLoC_Pay_Loader);
    if (stk_push_in_progress) {
      showSnackbarWBgCol('Another transaction is already in progress',
          snackbarBuildContext, DatingAppTheme.red);
      return;
    }
    stk_push_in_progress = true;
    print(TAG);
    MpesaService.lipanampesa(
      env['lipa_na_mpesa_passkey'],
      env['business_short_code'],
      env['consumer_key'],
      env['consumer_secret'],
      phone_no,
      //env['phone_number'],
      env['transactiontype_c_pbo'],
      1,
      'https://e7c390cc6753.ngrok.io/sl_mpesac2bcallback',
      //env['callbackurl'],
      'ACC 1',
      env['transactionDesc'],
      apiCredintialURL:
          'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials',
      apiurlforstkpush:
          'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest',
    ).then(
      (value) {
        if (value != null) {
          bool isError = false;
          try {
            String rtm_MerchantRequestID = value['MerchantRequestID'];
            if (rtm_MerchantRequestID != null) {
              print('MerchantRequestID = ' + rtm_MerchantRequestID);
            }
          } catch (error) {
            print(TAG + ' error1==');
            print(error.toString());
            isError = true;
          }

          if (isError) {
            try {
              print(TAG + ' at 2');
              if (value.statusCode != 200) {
                //print(json.decode(value.body));
                print('errorCode==');
                print(json.decode(value.body)['errorCode']);
                print(json.decode(value.body));
              }

              isError = false;
            } catch (error) {
              print(TAG + ' error2==');
              print(error.toString());
            }
          }

          /*print('CheckoutRequestID = ' + value['CheckoutRequestID']);
          print('ResponseCode = ' + value['ResponseCode']);
          print('ResponseDescription = ' + value['ResponseDescription']);
          print('CustomerMessage = ' + value['CustomerMessage']);

          print('errorCode==');
          print(value['errorCode']);*/
          stk_push_in_progress = false;
          refreshLoader(false, navigationDataBLoC_Pay_Loader);
        } else {
          print(TAG + ' value == null');

          stk_push_in_progress = false;
          refreshLoader(false, navigationDataBLoC_Pay_Loader);
        }
        /*print('MerchantRequestID = '+value['MerchantRequestID']),
        print('CheckoutRequestID = '+value['CheckoutRequestID']),
        print('ResponseCode = '+value['ResponseCode']),
        print('ResponseDescription = '+value['ResponseDescription']),
        print('CustomerMessage = '+value['CustomerMessage'])*/
      },
    );
  }*/

  //END OF STK PUSH
  //END OF LOGIC

}
