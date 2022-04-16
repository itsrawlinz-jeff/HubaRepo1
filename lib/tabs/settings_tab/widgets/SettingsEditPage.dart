import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataEvent.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_customusers_online.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_datematchmodes_online.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_user_usersProfiles.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/batch_put_posting/batch_put_post_user_usersProfiles.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_put_customuser.dart';
import 'package:dating_app/CustomWidgets/ProfileAppBar.dart';
import 'package:dating_app/CustomWidgets/ProfileImageGridViewItem.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/match_modes/DateMatchModeListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/match_modes/DateMatchModeRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/user_profiles/UserUserProfileReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/users/CustomUserReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/navigation/IndexAndUserUserProfileReqJModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/UI/Presentation/builders/column_builder.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsEditPage extends StatefulWidget {
  SettingsEditPage({
    Key key,
  }) : super(key: key);

  @override
  _SettingsEditPageState createState() => _SettingsEditPageState();
}

class _SettingsEditPageState extends State<SettingsEditPage>
    with TickerProviderStateMixin, AfterLayoutMixin<SettingsEditPage> {
  ScrollController scrollController = ScrollController();
  DateFormat dtf = DateFormat('dd MMM,yy');
  Animation<double> topBarAnimation;
  double topBarOpacity = 0.0;
  Animation<double> _scaleAnimation;
  Animation animation;
  int count = 9;
  TextEditingController searchTextEditingController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  var database;
  bool isDisabled = true;
  AnimationController animationController;

  BuildContext snackBarBuildContext;

  NavigationDataBLoC wd_fb_Container_NavigationDataBLoC = NavigationDataBLoC();
  NavigationDataBLoC wd_insta_Container_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationData initialLoaderNavigationData = NavigationData();
  LoginRespModel loginRespModel;


  //TOP LOADER
  AnimationController _scaleFactor;
  AnimationController _positionController;
  Animation<Offset> _positionFactor;
  bool is_readyToRefresh = false;
  //END OF TOPLOADER

  bool _autoValidateF1 = false;
  GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  NavigationDataBLoC navigationDataBLoC_Loader = NavigationDataBLoC();

  CustomUserRespJModel customUserRespJModel;
  DateMatchModeListRespJModel dateMatchModeListRespJModel;

  NavigationDataBLoC interested_in_Changed_DailySubTaskImagesBLoC =
      NavigationDataBLoC();
  int _interested_in_RadioValue = -1;

  List<DateMatchModeRespJModel> options_list = [];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn)));

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    _scaleAnimation = Tween(begin: 0.6, end: 1.0).animate(animationController);

    //TOP LOADER
    _positionController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
        upperBound: 1.0,
        lowerBound: 0.0,
        value: 0.0);

    _scaleFactor = AnimationController(
        vsync: this,
        value: 1.0,
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: Duration(milliseconds: 300));

    _positionFactor = _positionController
        .drive(Tween<Offset>(begin: Offset(0.0, -0.5), end: Offset(0.0, 0.8)));
    //END OF TOPLOADER

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
    initialLoaderNavigationData.isShow = false;
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    //print('SettingsEditPage afterFirstLayout');
    getLoggedInUser_and_setUpData(context);
  }

  getLoggedInUser_and_setUpData(BuildContext context) async {
    loginRespModel = await getSessionLoginRespModel(context);
    setUpData(context);
  }

  setUpData(BuildContext context) async {
    bool isshow_loading_indicator = await show_loading_indicator(
      is_readyToRefresh,
      _positionController,
      get_default_loader_distance(),
      get_default_loader_height(),
      _scaleFactor,
    );

    set_is_readyToRefresh_value(isshow_loading_indicator);

    dateMatchModeListRespJModel = await fetch_datematchmodes_online(
      context,
      DatingAppStaticParams.default_Max_int,
    );

    if (dateMatchModeListRespJModel != null) {
      options_list = dateMatchModeListRespJModel.results;
      refresh_WO_Data_NavigationDataBLoC(
          interested_in_Changed_DailySubTaskImagesBLoC);
    }

    customUserRespJModel = await fetch_customuser_online_by_id(
        context, loginRespModel.tokenDecodedJModel.id);

    if (customUserRespJModel != null &&
        customUserRespJModel.date_match_mode != null) {
      _interested_in_RadioValue = customUserRespJModel.date_match_mode.id;
      refresh_WO_Data_NavigationDataBLoC(
          interested_in_Changed_DailySubTaskImagesBLoC);
    }


    //DISMISS TOP LOADER
    dismiss_loading_indicator(_scaleFactor);
    //END OF DISMISS TOP LOADER
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return Container(
          color: datingAppThemeChanger.selectedThemeData.cl_profile_page_bg,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              iconTheme: IconThemeData(
                  color: datingAppThemeChanger.selectedThemeData
                      .cl_appbar_icon_pink //change your color here
                  ),
              backgroundColor: DatingAppTheme.white,
              elevation: 0,
              title: Text(
                'Settings',
                style: TextStyle(
                  fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  letterSpacing: -0.2,
                  color: datingAppThemeChanger
                      .selectedThemeData.mnu_darkerText_Color,
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                getMainListViewUI(datingAppThemeChanger),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
                Container(
                  child: SlideTransition(
                    child: ScaleTransition(
                      scale: _scaleFactor,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: RefreshProgressIndicator(
                          semanticsLabel: MaterialLocalizations?.of(context)
                              ?.refreshIndicatorSemanticLabel,
                          value: null,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            DatingAppTheme.pltf_pink.withOpacity(0.5),
                          ),
                          backgroundColor: DatingAppTheme.white,
                        ),
                      ),
                    ),
                    position: _positionFactor,
                  ),
                  height: 100,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getMainListViewUI(DatingAppThemeChanger datingAppThemeChanger) {
    return FutureBuilder<bool>(
      future: common_getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        snackBarBuildContext = context;
        if (!snapshot.hasData) {
          return SizedBox();
        } else {
          animationController.forward();

          return ListView(
            controller: scrollController,
            shrinkWrap: true,
            padding: EdgeInsets.only(
              top: 0,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            scrollDirection: Axis.vertical,
            children: <Widget>[
              AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget child) {
                  return FadeTransition(
                    opacity: animation,
                    child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - animation.value), 0.0),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 24, right: 24, top: 8, bottom: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: DatingAppTheme.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topRight: Radius.circular(8.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: DatingAppTheme.grey.withOpacity(0.2),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  left: 16,
                                  right: 16,
                                  bottom: 10,
                                ),
                                child: Form(
                                  autovalidate: _autoValidateF1,
                                  key: _formKey1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 3),
                                        child: Text(
                                          'Match Mode',
                                          style: datingAppThemeChanger
                                              .selectedThemeData
                                              .txt_stl_white_pltf_grey_16_Med_700,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 0),
                                        child: StreamBuilder(
                                            stream:
                                                interested_in_Changed_DailySubTaskImagesBLoC
                                                    .stream_counter,
                                            builder: (context,
                                                ohs_approval_snapshot) {
                                              return ((options_list.length > 0
                                                  ? ColumnBuilder(
                                                      itemCount:
                                                          options_list.length,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Theme(
                                                                  data:
                                                                      ThemeData(
                                                                    unselectedWidgetColor:
                                                                        DatingAppTheme
                                                                            .pltf_grey,
                                                                    disabledColor:
                                                                        datingAppThemeChanger
                                                                            .selectedThemeData
                                                                            .cl_real_grey_grey_Disabled,
                                                                  ),
                                                                  child:
                                                                      SizedBox(
                                                                    height:
                                                                        24.0,
                                                                    width: 24.0,
                                                                    child:
                                                                        Radio(
                                                                      value: options_list[
                                                                              index]
                                                                          .id,
                                                                      activeColor: datingAppThemeChanger
                                                                          .selectedThemeData
                                                                          .cl_cont_Sel_ClickableItem,
                                                                      groupValue:
                                                                          _interested_in_RadioValue,
                                                                      onChanged:
                                                                          _interested_in_RadioValueChange,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child:
                                                                      InkWell(
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              1,
                                                                          right:
                                                                              2,
                                                                          top:
                                                                              3,
                                                                          bottom:
                                                                              3),
                                                                      child:
                                                                          Text(
                                                                        options_list[index]
                                                                            .name,
                                                                        style: datingAppThemeChanger
                                                                            .selectedThemeData
                                                                            .txt_stl_whitegrey_14_Med_pltf_grey,
                                                                      ),
                                                                    ),
                                                                    onTap: () {
                                                                      _interested_in_RadioValueChange(
                                                                          options_list[
                                                                          index]
                                                                              .id);
                                                                    },
                                                                    splashColor:
                                                                        DatingAppTheme
                                                                            .pltf_grey,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          10.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            ((options_list.length -
                                                                        1 >
                                                                    index
                                                                ? SizedBox(
                                                                    height: 15,
                                                                  )
                                                                : invisibleWidget()))
                                                          ],
                                                        );
                                                      })
                                                  : invisibleWidget()));
                                              /*Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[

                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Theme(
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
                                                      child: Radio(
                                                        value: 0,
                                                        activeColor:
                                                            datingAppThemeChanger
                                                                .selectedThemeData
                                                                .cl_cont_Sel_ClickableItem,
                                                        groupValue:
                                                            _interested_in_RadioValue,
                                                        onChanged:
                                                            _interested_in_RadioValueChange,
                                                      ),
                                                    ),
                                                  ),
                                                  Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 1,
                                                                right: 2,
                                                                top: 3,
                                                                bottom: 3),
                                                        child: Text(
                                                          'Request admin to match',
                                                          style: datingAppThemeChanger
                                                              .selectedThemeData
                                                              .txt_stl_whitegrey_14_Med_pltf_grey,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        _interested_in_RadioValueChange(
                                                            0);
                                                      },
                                                      splashColor:
                                                          DatingAppTheme
                                                              .pltf_grey,
                                                      borderRadius:
                                                          BorderRadius.all(
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Theme(
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
                                                      child: Radio(
                                                        value: 1,
                                                        activeColor:
                                                            datingAppThemeChanger
                                                                .selectedThemeData
                                                                .cl_cont_Sel_ClickableItem,
                                                        groupValue:
                                                            _interested_in_RadioValue,
                                                        onChanged:
                                                            _interested_in_RadioValueChange,
                                                      ),
                                                    ),
                                                  ),
                                                  Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 1,
                                                                right: 2,
                                                                top: 3,
                                                                bottom: 3),
                                                        child: Text(
                                                          'App to match',
                                                          style: datingAppThemeChanger
                                                              .selectedThemeData
                                                              .txt_stl_whitegrey_14_Med_pltf_grey,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        _interested_in_RadioValueChange(
                                                            1);
                                                      },
                                                      splashColor:
                                                          DatingAppTheme
                                                              .pltf_grey,
                                                      borderRadius:
                                                          BorderRadius.all(
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
                                  ),
                                ),
                              ),
                              StreamBuilder(
                                stream:
                                    navigationDataBLoC_Loader.stream_counter,
                                builder: (context, snapshot) {
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
                                      return if_ShowCircularProgressIndicator(
                                          snapshot);
                                      break;
                                    case ConnectionState.done:
                                      return if_ShowCircularProgressIndicator(
                                          snapshot);
                                      break;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }
      },
    );
  }

  void dispose() {
    super.dispose();
  }

  //BUILD WIDGET FUNCTIONS
  //VALIDATORS

  //POSITIONED LOADER set_is_readyToRefresh
  set_is_readyToRefresh_value(
    bool isshow_loading_indicator,
  ) {
    if (isshow_loading_indicator != null) {
      is_readyToRefresh = isshow_loading_indicator;
    }
  }

//END OF POSITIONED LOADER set_is_readyToRefresh
  //MATCHMODE SELECTION
  Future<void> _interested_in_RadioValueChange(int value) async {
    String TAG = '_ohs_approvalRadioValueChange:';
    print(TAG);
    /*_interested_in_RadioValue = value;
    refresh_WO_Data_NavigationDataBLoC(
        interested_in_Changed_DailySubTaskImagesBLoC);*/
    //PATCH CUSTOM USER
    CustomUserReqJModel customUserReqJModel = CustomUserReqJModel();
    customUserReqJModel.id = loginRespModel.tokenDecodedJModel.id;
    customUserReqJModel.date_match_mode = value;

    CustomUserRespJModel customUserRespJModel = await post_put_customuser(
      context,
      snackBarBuildContext,
      navigationDataBLoC_Loader,
      customUserReqJModel,
    );

    if (customUserRespJModel != null) {
      _interested_in_RadioValue = ((customUserRespJModel.date_match_mode != null
          ? customUserRespJModel.date_match_mode.id
          : _interested_in_RadioValue));
      refresh_WO_Data_NavigationDataBLoC(
          interested_in_Changed_DailySubTaskImagesBLoC);
    }
  }

  //END OF BUILD WIDGET FUNCTIONS

//BUILD WIDGETS

  Widget if_ShowCircularProgressIndicator(
      AsyncSnapshot<NavigationData> snapshot) {
    if (snapshot != null) {
      NavigationData navData = snapshot.data;
      if (navData.isShow) {
        return progressDialog();
      } else {
        if (navData.isSaved) {
          return saved_Widget();
        } else {
          return invisibleWidget();
        }
      }
    } else {
      return invisibleWidget();
    }
  }

  Widget progressDialog() {
    return Positioned(
      right: 5,
      top: 5,
      child: Theme(
          data: ThemeData(
            accentColor: DatingAppTheme.colorAdrianBlue,
          ),
          child: Container(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )),
    );
  }

  Widget saved_Widget() {
    return Positioned(
      right: 5,
      top: 5,
      child: Theme(
          data: ThemeData(
            accentColor: DatingAppTheme.colorAdrianBlue,
          ),
          child: Container(
            width: 22,
            height: 22,
            child: Icon(
              Icons.check_circle,
              color: DatingAppTheme.green,
            ),
          )),
    );
  }
//END OF BUILD WIDGETS

}
