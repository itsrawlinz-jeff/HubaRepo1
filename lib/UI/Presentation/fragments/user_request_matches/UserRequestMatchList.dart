import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleBLoC.dart';
import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleEvent.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Bloc/bloc_library/navigationdrawer/navigationdrawer_bloc.dart';
import 'package:dating_app/Bloc/bloc_library/navigationdrawer/navigationdrawer_event.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_datematches_online.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/DateMatchListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/DateMatchRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/CustomWidgets/CustomTitleView.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/UI/Presentation/admin_drawer/home_drawer.dart';
import 'package:dating_app/UI/Presentation/fragments/AdminCreateEditMatch.dart';
import 'package:dating_app/UI/Presentation/fragments/user_request_matches/UserCreateEditMatchRequest.dart';
import 'package:dating_app/UI/Presentation/listitems/DateMatchListItem.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'dart:io';
import 'package:outline_material_icons/outline_material_icons.dart';

class UserRequestMatchList extends StatefulWidget {
  @override
  _UserRequestMatchListState createState() => _UserRequestMatchListState();
}

class _UserRequestMatchListState extends State<UserRequestMatchList>
    with TickerProviderStateMixin, AfterLayoutMixin<UserRequestMatchList> {
  ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  Animation animation;

  RefreshController _refreshController = RefreshController();
  AnimationController animationController;
  NavigationDataBLoC searchMatch_NavigationDataBLoC = NavigationDataBLoC();

  FocusNode searchFocusNode = FocusNode();
  TextEditingController searchTextEditingController = TextEditingController();
  List<DateMatchRespJModel> dateMatchRespJModelList = [];
  DateMatchListRespJModel current_DateMatchListRespJModel;
  String current_PageUrl;
  NavigationDataBLoC noTicketsAvailable_NavigationDataBLoC =
      NavigationDataBLoC();
  KeyBoardVisibleBLoC keyBoardVisibleBLoC = KeyBoardVisibleBLoC();
  bool initial_keyboardShown_isvisible = false;
  LoginRespModel loginRespModel;
  BuildContext build_context;

  @override
  void initState() {
    print('UserRequestMatchList:initState');
    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval((1 / 9) * 0, 1.0, curve: Curves.fastOutSlowIn)));

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
    print('UserRequestMatchList:afterFirstLayout');
    getLoggedInUser();
    addListeners();
    initial_AfterFirstLayout_OnlineFetch(_refreshController);
  }

  @override
  void dispose() {
    print('UserRequestMatchList:dispose');
    super.dispose();
  }

  getLoggedInUser() async {
    loginRespModel = await getSessionLoginRespModel(context);
  }

  addListeners() async {
    LoginRespModel loginRespModel = await getSessionLoginRespModel(context);
    print('token==');
    print(loginRespModel.token);

    KeyboardVisibility.onChange.listen(
      (bool visible) {
        initial_keyboardShown_isvisible = visible;
        keyBoardVisibleBLoC.keyboard_visible_event_sink
            .add(ToggleKeyBoardVisEvent(visible));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('UserRequestMatchList:build');
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
         build_context=context;
        return Container(
          color: datingAppThemeChanger.selectedThemeData.sm_bg_background,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                getMainListViewUI(datingAppThemeChanger),
                StreamBuilder(
                  stream: keyBoardVisibleBLoC.stream_counter,
                  initialData: initial_keyboardShown_isvisible,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return ifToshownoTicketsAvailableWidget_StreamBuilder(
                          snapshot);
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return ifToshownoTicketsAvailableWidget_StreamBuilder(
                            snapshot);
                        break;
                      case ConnectionState.waiting:
                        return ifToshownoTicketsAvailableWidget_StreamBuilder(
                            snapshot);
                        break;
                      case ConnectionState.active:
                        return ifToshownoTicketsAvailableWidget_StreamBuilder(
                            snapshot);
                        break;
                      case ConnectionState.done:
                        return ifToshownoTicketsAvailableWidget_StreamBuilder(
                            snapshot);
                        break;
                    }
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
            floatingActionButton: new Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: new Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    print('FAB CLICKED');

                    DateMatchRespJModel dateMatchRespJModel =
                        DateMatchRespJModel();
                    DateTime dateTime = DateTime.now();
                    dateMatchRespJModel.active = true;
                    dateMatchRespJModel.createdate = dateTime;
                    dateMatchRespJModel.txndate = dateTime;
                    dateMatchRespJModel.isuserrequested = true;
                    dateMatchRespJModel.matching_user =
                        customUserRespJModelFromLoginRespModel(loginRespModel);
                    dateMatchRespJModel.age_low = 18;
                    dateMatchRespJModel.age_high = 100;
                    dateMatchRespJModel.approved=false;
                    function_AddMatch_Clicked(dateMatchRespJModel);
                  },
                  borderRadius: BorderRadius.all(
                    Radius.circular(43.0),
                  ),
                  splashColor: DatingAppTheme.grey,
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: DatingAppTheme.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: DatingAppTheme.nearlyBlack.withOpacity(0.4),
                            offset: Offset(8.0, 8.0),
                            blurRadius: 8.0),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Center(
                          child: Icon(
                        OMIcons.add,
                        size: 32,
                        color: DatingAppTheme.pltf_pink,
                      )),
                    ),
                  ),
                ),
              ),
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
        if (!snapshot.hasData) {
          return SizedBox();
        } else {
          animationController.forward();
          return Theme(
            data: ThemeData(primaryColor: DatingAppTheme.colorAdrianBlue),
            child: SmartRefresher(
              onRefresh: () async {
                if (!isStringValid(searchTextEditingController.text)) {
                  await onRefresh_fetchErpTickets_OnlineFetch(context);
                } else {}
                _refreshController.refreshCompleted();
              },
              enablePullUp: true,
              onLoading: () async {
                if (!isStringValid(searchTextEditingController.text)) {
                  await onLoading_fetchErpTickets_OnlineFetch(context);
                }
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
                  color: datingAppThemeChanger.selectedThemeData.cl_white_grey,
                ),
                canLoadingIcon: Icon(
                  Icons.arrow_upward,
                  color: datingAppThemeChanger.selectedThemeData.cl_white_grey,
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
                    titleTxt: 'Requests List',
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
                  searchField(datingAppThemeChanger),
                  StreamBuilder(
                    stream: searchMatch_NavigationDataBLoC.stream_counter,
                    builder: (context, snapshot) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: dateMatchRespJModelList.length,
                          itemBuilder: (_, index) {
                            DateMatchRespJModel dateMatchRespJModel =
                                dateMatchRespJModelList[index];

                            return DateMatchListItem(
                              animation: Tween<double>(begin: 0.0, end: 1.0)
                                  .animate(CurvedAnimation(
                                      parent: animationController,
                                      curve: Interval((1 / 9) * 3, 1.0,
                                          curve: Curves.fastOutSlowIn))),
                              animationController: animationController,
                              dateMatchRespJModel: dateMatchRespJModel,
                              functionCallback: function_AddMatch_Clicked,
                            );
                          });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
                //),
              ),
            ),
          );
        }
      },
    );
  }

  //BUILD WIDGETS
  Widget ifToshownoTicketsAvailableWidget_StreamBuilder(
      AsyncSnapshot<bool> keyBoardVisible_snapshot) {
    return StreamBuilder(
      stream: noTicketsAvailable_NavigationDataBLoC.stream_counter,
      builder: (context, snapshot) {
        NavigationData navData = snapshot.data;
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
            return ifToshownoTicketsAvailableWidget(
              navData,
              keyBoardVisible_snapshot,
            );
            break;
          case ConnectionState.done:
            return ifToshownoTicketsAvailableWidget(
              navData,
              keyBoardVisible_snapshot,
            );
            break;
        }
      },
    );
  }

  Widget ifToshownoTicketsAvailableWidget(
      NavigationData navdata, AsyncSnapshot<bool> keyBoardVisible_snapshot) {
    if (navdata != null && navdata.dateMatchRespJModelList != null) {
      if (navdata.dateMatchRespJModelList.length > 0) {
        return invisibleWidget();
      } else {
        if (navdata.isFromTrigger != null && navdata.isFromTrigger) {
          String msg = 'No matches available';
          return notAvailableWidget_W_KeyboardVisibility_Snapshot(
              msg, keyBoardVisible_snapshot);
        } else {
          return invisibleWidget();
        }
      }
    } else {
      return invisibleWidget();
    }
  }
  //END OF BUILD WIDGETS
  //SEARCH FIELDS

  Widget searchField(DatingAppThemeChanger datingAppThemeChanger) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 0, bottom: 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 16, top: 8, bottom: 0),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: datingAppThemeChanger.selectedThemeData
                                  .cl_dismissibleBackground_white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    offset: const Offset(0, 2),
                                    blurRadius: 10.0),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 0, bottom: 0),
                              child: TextField(
                                textAlign: TextAlign.left,
                                style: datingAppThemeChanger
                                    .selectedThemeData.txt_stl_f14w500_Med,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.search,
                                      size: 24,
                                      color: datingAppThemeChanger
                                          .selectedThemeData.cl_grey),
                                  border: InputBorder.none,
                                  hintText: 'Search',
                                  hintStyle: datingAppThemeChanger
                                      .selectedThemeData
                                      .txt_stl_hint_f14w500_Med,
                                ),
                                controller: searchTextEditingController,
                                cursorColor: datingAppThemeChanger
                                    .selectedThemeData.cl_grey,
                                focusNode: searchFocusNode,
                                autofocus: false,
                                onTap: () {},
                                onChanged: (String txt) {
                                  onSearchParamChanged(context);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: DatingAppTheme.white.withOpacity(0.8),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(43.0),
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color:
                                    DatingAppTheme.nearlyBlack.withOpacity(0.4),
                                offset: const Offset(0, 2),
                                blurRadius: 8.0),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(43.0),
                            ),
                            onTap: () {
                              onSearchParamChanged(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(11.0),
                              child: Icon(Icons.search,
                                  size: 24, color: DatingAppTheme.grey),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  //END OF SEARCH FIELDS

  //QUERIES

  Future<bool> onRefresh_fetchErpTickets_OnlineFetch(
      BuildContext context) async {
    String TAG = 'onRefresh_fetchErpTickets_OnlineFetch:';

    current_DateMatchListRespJModel =
        await fetch_datematches_online_limit_by_isuserrequested(
      context,
      DatingAppStaticParams.default_Query_Limit,
      true.toString(),
    );

    if (current_DateMatchListRespJModel != null) {
      dateMatchRespJModelList = current_DateMatchListRespJModel.results;
      _refreshController.refreshCompleted();
      refreshifToshowNoTicketAvailable();
      refresh_WO_Data_NavigationDataBLoC(searchMatch_NavigationDataBLoC);
    } else {
      dateMatchRespJModelList = [];
      _refreshController.refreshCompleted();
      refreshifToshowNoTicketAvailable();
      refresh_WO_Data_NavigationDataBLoC(searchMatch_NavigationDataBLoC);
    }
    return true;
  }

  Future<bool> onLoading_fetchErpTickets_OnlineFetch(
      BuildContext context) async {
    String TAG = 'onLoading_fetchErpTickets_OnlineFetch:';
    _refreshController.requestLoading();
    if (current_DateMatchListRespJModel != null) {
      String nextPageUrl = current_DateMatchListRespJModel.next;
      print(TAG + ' nextPageUrl==${nextPageUrl}');
      if (isStringValid(nextPageUrl) &&
          (!isStringValid(current_PageUrl) ||
              (isStringValid(current_PageUrl) &&
                  nextPageUrl != current_PageUrl))) {
        current_DateMatchListRespJModel =
            await fetch_datematches_online_by_isuserrequested_loadnext(
          context,
          nextPageUrl,
        );
        if (current_DateMatchListRespJModel != null) {
          current_PageUrl = nextPageUrl;
        }
        add_FromFetched();
      } else {
        _refreshController.loadComplete();
        refreshifToshowNoTicketAvailable();
      }
    } else {
      current_DateMatchListRespJModel =
          await fetch_datematches_online_limit_by_isuserrequested(
        context,
        DatingAppStaticParams.default_Query_Limit,
        true.toString(),
      );
      add_FromFetched();
    }
    return true;
  }

  replace_FromFetched() {
    if (current_DateMatchListRespJModel != null) {
      dateMatchRespJModelList = current_DateMatchListRespJModel.results;
      _refreshController.loadComplete();
      refreshifToshowNoTicketAvailable();
      refresh_WO_Data_NavigationDataBLoC(searchMatch_NavigationDataBLoC);
    } else {
      _refreshController.loadComplete();
      refreshifToshowNoTicketAvailable();
    }
  }

  add_FromFetched() {
    if (current_DateMatchListRespJModel != null) {
      dateMatchRespJModelList.addAll(current_DateMatchListRespJModel.results);
      _refreshController.loadComplete();
      refreshifToshowNoTicketAvailable();
      refresh_WO_Data_NavigationDataBLoC(searchMatch_NavigationDataBLoC);
    } else {
      _refreshController.loadComplete();
      refreshifToshowNoTicketAvailable();
    }
  }
  //END OF QUERIES

  //STATE CHANGES
  refreshifToshowNoTicketAvailable() {
    NavigationData navigationData = NavigationData();
    navigationData.dateMatchRespJModelList = dateMatchRespJModelList;
    navigationData.isFromTrigger = true;
    refresh_W_Data_NavigationDataBLoC(
        noTicketsAvailable_NavigationDataBLoC, navigationData);
  }
  //END OF STATE CHANGES

  //BUILD FUNCTIONS
  onSearchParamChanged(BuildContext context) async {
    String TAG = 'onSearchParamChanged:';
    String searchParam = searchTextEditingController.text;
    if (isStringValid(searchParam)) {
      refreshifToshowNoTicketAvailable();
      refresh_WO_Data_NavigationDataBLoC(searchMatch_NavigationDataBLoC);
      current_DateMatchListRespJModel =
          await fetch_datematches_online_limit_by_searchparam_by_isuserrequested(
        context,
        DatingAppStaticParams.default_Query_Limit,
        searchParam,
        true.toString(),
      );
      replace_FromFetched();
    } else {
      if (current_DateMatchListRespJModel != null) {
        if (dateMatchRespJModelList == null ||
            !(dateMatchRespJModelList.length > 0)) {
          current_DateMatchListRespJModel =
              await fetch_datematches_online_limit_by_isuserrequested(
            context,
            DatingAppStaticParams.default_Query_Limit,
            true.toString(),
          );
          replace_FromFetched();
        }
      } else {
        current_DateMatchListRespJModel =
            await fetch_datematches_online_limit_by_isuserrequested(
          context,
          DatingAppStaticParams.default_Query_Limit,
          true.toString(),
        );
        replace_FromFetched();
      }
    }
  }

  void function_AddMatch_Clicked(DateMatchRespJModel dateMatchRespJModel) {
    NavigationData navigationData = new NavigationData();
    print('UserRequestMatchList:function_AddMatch_Clicked');
    navigationData.selectedWidget = UserCreateEditMatchRequest(
      dateMatchReqJModel:
          dateMatchReqJModelFromDateMatchRespJModel(dateMatchRespJModel),
      dateMatchRespJModel: dateMatchRespJModel,
    );
    navigationData.isInBackPressed = false;
    NavigationdrawerBloc navigationdrawerBloc =
        BlocProvider.of<NavigationdrawerBloc>(build_context);
    navigationdrawerBloc.add(NavDrawer(navigationData));
  }

}
