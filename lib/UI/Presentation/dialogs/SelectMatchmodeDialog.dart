import 'dart:async';

import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_customusers_online.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_put_customuser.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/match_modes/DateMatchModeListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/match_modes/DateMatchModeRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/users/CustomUserReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/UI/Presentation/builders/column_builder.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/widgets.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';

class SelectMatchmodeDialog extends StatefulWidget {
  AnimationController animationController;
  BuildContext snackbarBuildContext;
  NavigationDataBLoC matchModeChanged_NavigationDataBLoC;
  DateMatchModeListRespJModel dateMatchModeListRespJModel;

  SelectMatchmodeDialog({
    Key key,
    this.animationController,
    this.snackbarBuildContext,
    this.matchModeChanged_NavigationDataBLoC,
    this.dateMatchModeListRespJModel,
  }) : super(key: key);
  @override
  _SelectMatchmodeDialogState createState() =>
      new _SelectMatchmodeDialogState();
}

class _SelectMatchmodeDialogState extends State<SelectMatchmodeDialog>
    with TickerProviderStateMixin, AfterLayoutMixin<SelectMatchmodeDialog> {
  List<String> str = [];
  AnimationController animationController;
  Animation<double> _scaleAnimation;
  Animation animation;
  NavigationDataBLoC interested_in_Changed_DailySubTaskImagesBLoC =
      NavigationDataBLoC();

  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  NavigationDataBLoC loader_NavigationDataBLoC = NavigationDataBLoC();
  int _interested_in_RadioValue = -1;
  List<DateMatchModeRespJModel> options_list = [];
  LoginRespModel loginRespModel;
  NavigationDataBLoC navigationDataBLoC_Loader = NavigationDataBLoC();

  @override
  void initState() {
    super.initState();
    if (widget.dateMatchModeListRespJModel != null) {
      options_list = widget.dateMatchModeListRespJModel.results;
    }

    animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _scaleAnimation = Tween(begin: 0.6, end: 1.0).animate(animationController);

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval((1 / 9) * 0, 1.0, curve: Curves.fastOutSlowIn)));
  }

  @override
  Future<void> dispose() {
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    String TAG = 'SelectMatchmodeDialog afterFirstLayout:';
    getLoggedInUser(context);
    setUpListeners();
    refresh_WO_Data_NavigationDataBLoC(
        interested_in_Changed_DailySubTaskImagesBLoC);
  }

  getLoggedInUser(BuildContext context) async {
    loginRespModel = await getSessionLoginRespModel(context);
    setUpData(context);
  }

  setUpData(BuildContext context) async {
    refreshLoader_with_isSaved(true, false, navigationDataBLoC_Loader);
    CustomUserRespJModel customUserRespJModel =
        await fetch_customuser_online_by_id(
            context, loginRespModel.tokenDecodedJModel.id);

    if (customUserRespJModel != null &&
        customUserRespJModel.date_match_mode != null) {
      _interested_in_RadioValue = customUserRespJModel.date_match_mode.id;
      refresh_WO_Data_NavigationDataBLoC(
          interested_in_Changed_DailySubTaskImagesBLoC);
    }
    refreshLoader_with_isSaved(false, false, navigationDataBLoC_Loader);
    resetData();
  }

  resetData() {}

  setUpListeners() {}

  //STATE CHANGES
  refresh_interested_in_Changed_DailySubTaskImagesBLoC() {
    NavigationData navigationData = NavigationData();
    refresh_W_Data_NavigationDataBLoC(
        interested_in_Changed_DailySubTaskImagesBLoC, navigationData);
  }

  refresh_widget_matchModeChanged_NavigationDataBLoC(bool isShow) {
    if (widget.matchModeChanged_NavigationDataBLoC != null) {
      NavigationData navigationData = NavigationData();
      navigationData.isShow = isShow;
      refresh_W_Data_NavigationDataBLoC(
          widget.matchModeChanged_NavigationDataBLoC, navigationData);
    }
  }

  //END OF STATE CHANGES

  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return AlertDialog(
          elevation: 8,
          backgroundColor: DatingAppTheme.transparent,
          contentPadding: EdgeInsets.all(0.0),
          titlePadding: EdgeInsets.all(0),
          content: Container(
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: datingAppThemeChanger
                  .selectedThemeData.cl_dismissibleBackground_white,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 10,
                top: 8,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        AnimatedBuilder(
                          animation: widget.animationController,
                          builder: (BuildContext context, Widget child) {
                            return FadeTransition(
                              opacity: animation,
                              child: new Transform(
                                transform: new Matrix4.translationValues(
                                    0.0, 30 * (1.0 - animation.value), 0.0),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 0, right: 0, top: 0, bottom: 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: datingAppThemeChanger
                                          .selectedThemeData
                                          .cl_dismissibleBackground_white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0)),
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        new Form(
                                          key: _key,
                                          autovalidate: _validate,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 16, left: 16, right: 24),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 4,
                                                      right: 4,
                                                      bottom: 5,
                                                      top: 16),
                                                  child: Text(
                                                    'Select Match Mode',
                                                    textAlign: TextAlign.center,
                                                    style: datingAppThemeChanger
                                                        .selectedThemeData
                                                        .title_TextStyle,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 4,
                                                      right: 4,
                                                      top: 3,
                                                      bottom: 8),
                                                  child: Container(
                                                    height: 2,
                                                    decoration: BoxDecoration(
                                                      color: DatingAppTheme
                                                          .background,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4.0)),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16,
                                                      right: 16,
                                                      top: 8,
                                                      bottom: 0),
                                                  child: StreamBuilder(
                                                      stream:
                                                          interested_in_Changed_DailySubTaskImagesBLoC
                                                              .stream_counter,
                                                      builder: (context,
                                                          ohs_approval_snapshot) {
                                                        return ((options_list
                                                                    .length >
                                                                0
                                                            ? ColumnBuilder(
                                                                itemCount:
                                                                    options_list
                                                                        .length,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return Column(
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
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Theme(
                                                                            data:
                                                                                ThemeData(
                                                                              unselectedWidgetColor: DatingAppTheme.pltf_grey,
                                                                              disabledColor: datingAppThemeChanger.selectedThemeData.cl_real_grey_grey_Disabled,
                                                                            ),
                                                                            child:
                                                                                SizedBox(
                                                                              height: 24.0,
                                                                              width: 24.0,
                                                                              child: Radio(
                                                                                value: options_list[index].id,
                                                                                activeColor: datingAppThemeChanger.selectedThemeData.cl_cont_Sel_ClickableItem,
                                                                                groupValue: _interested_in_RadioValue,
                                                                                onChanged: _interested_in_RadioValueChange,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Material(
                                                                            color:
                                                                                Colors.transparent,
                                                                            child:
                                                                                InkWell(
                                                                              child: Padding(
                                                                                padding: EdgeInsets.only(left: 1, right: 2, top: 3, bottom: 3),
                                                                                child: Text(
                                                                                  options_list[index].name,
                                                                                  style: datingAppThemeChanger.selectedThemeData.txt_stl_whitegrey_14_Med_pltf_grey,
                                                                                ),
                                                                              ),
                                                                              onTap: () {
                                                                                _interested_in_RadioValueChange(options_list[index].id);
                                                                              },
                                                                              splashColor: DatingAppTheme.pltf_grey,
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10.0),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      ((options_list.length - 1 >
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
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
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
                                                              color: Colors
                                                                  .transparent,
                                                              child: InkWell(
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              1,
                                                                          right:
                                                                              2,
                                                                          top:
                                                                              3,
                                                                          bottom:
                                                                              3),
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
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
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
                                                              color: Colors
                                                                  .transparent,
                                                              child: InkWell(
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              1,
                                                                          right:
                                                                              2,
                                                                          top:
                                                                              3,
                                                                          bottom:
                                                                              3),
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
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    );*/
                                                      }),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        StreamBuilder(
                                          stream: navigationDataBLoC_Loader
                                              .stream_counter,
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
                        /*Positioned(
                          right: 0.0,
                          bottom: 0.0,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: new Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  if (_interested_in_RadioValue == 0) {
                                    //ADMIN
                                    if (widget
                                            .matchModeChanged_NavigationDataBLoC !=
                                        null) {
                                      NavigationData navigationData =
                                          NavigationData();
                                      navigationData.isShow = true;
                                      refresh_W_Data_NavigationDataBLoC(
                                          widget
                                              .matchModeChanged_NavigationDataBLoC,
                                          navigationData);
                                    }
                                    dismissSelf();
                                  } else if (_interested_in_RadioValue == 1) {
                                    //APP
                                    dismissSelf();
                                  } else {}
                                },
                                borderRadius: BorderRadius.all(
                                  Radius.circular(43.0),
                                ),
                                splashColor: DatingAppTheme.grey,
                                child: Container(
                                  width: 85,
                                  height: 85,
                                  decoration: BoxDecoration(
                                    color:
                                        DatingAppTheme.white.withOpacity(0.8),
                                    shape: BoxShape.circle,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: DatingAppTheme.nearlyBlack
                                              .withOpacity(0.4),
                                          offset: Offset(8.0, 8.0),
                                          blurRadius: 8.0),
                                    ],
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Icon(
                                        OMIcons.save,
                                        size: 42,
                                        color: DatingAppTheme.grey,
                                      ),
                                      streamBuilderWidgetLoader(
                                        loader_NavigationDataBLoC,
                                        DatingAppTheme.nearlyDarkBlue,
                                        0,
                                        false,
                                        null,
                                        null,
                                        50,
                                        50,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),*/
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //MATCHMODE SELECTION
  /*Future<void> _interested_in_RadioValueChange(int value) async {
    String TAG = '_ohs_approvalRadioValueChange:';
    print(TAG);
    _interested_in_RadioValue = value;
    if (_interested_in_RadioValue == 0) {
      //WOMEN
      refresh_interested_in_Changed_DailySubTaskImagesBLoC();
    } else {
      //MEN
      refresh_interested_in_Changed_DailySubTaskImagesBLoC();
    }
  }*/
  Future<void> _interested_in_RadioValueChange(int value) async {
    String TAG = '_ohs_approvalRadioValueChange:';
    print(TAG);
    CustomUserReqJModel customUserReqJModel = CustomUserReqJModel();
    customUserReqJModel.id = loginRespModel.tokenDecodedJModel.id;
    customUserReqJModel.date_match_mode = value;

    CustomUserRespJModel customUserRespJModel = await post_put_customuser(
      context,
      widget.snackbarBuildContext,
      navigationDataBLoC_Loader,
      customUserReqJModel,
    );

    if (customUserRespJModel != null) {
      _interested_in_RadioValue = ((customUserRespJModel.date_match_mode != null
          ? customUserRespJModel.date_match_mode.id
          : _interested_in_RadioValue));
      refresh_WO_Data_NavigationDataBLoC(
          interested_in_Changed_DailySubTaskImagesBLoC);

      if (customUserRespJModel.date_match_mode != null &&
          isStringValid(customUserRespJModel.date_match_mode.name) &&
          customUserRespJModel.date_match_mode.name
              .toLowerCase()
              .contains('admin')) {
        refresh_widget_matchModeChanged_NavigationDataBLoC(true);
      }
      dismissSelf();
    }
  }

  //END OF MATCHMODE SELECTION

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

  dismissSelf() {
    Navigator.pop(context);
  }
}
