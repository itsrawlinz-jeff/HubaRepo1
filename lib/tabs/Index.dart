import 'dart:async';
import 'dart:convert';

import 'package:dating_app/Activities/ProfileInfo.dart';
import 'package:dating_app/Bloc/Streams/LandingPage/LandingPageBLoC.dart';
import 'package:dating_app/Bloc/Streams/LandingPage/LandingPageEvent.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_datematchmodes_online.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_put_socket_notification.dart';
import 'package:dating_app/CustomWidgets/dropdowns/MatchDecisionPickerOnline.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/match_modes/DateMatchModeListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/notificationsmsg/SocketNotificationListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/notificationsmsg/SocketNotificationRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/ui/LandingPageBlocResp.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/UI/Presentation/dialogs/SelectMatchmodeDialog.dart';
import 'package:dating_app/tabs/admin/AdminHome.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dating_app/tabs/messages_tab/messages_index.dart';
import 'package:dating_app/tabs/settings_tab/settings_tab.dart';
import 'package:dating_app/utils/images.dart';
import 'package:dating_app/tabs/hookup/HookupsLikeTopPicksParent.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math' as math;

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index>
    with TickerProviderStateMixin, AfterLayoutMixin<Index> {
  PageController _pageController = new PageController(initialPage: 1);
  int currentPage = 1;
  bool isSwitchVisible = true;
  bool isImageVisible = false;
  var _switchChangedBLoC = SwitchChangedBLoC();
  NavigationDataBLoC navigationDataBLoC_UserprofilesChanged =
      NavigationDataBLoC();
  NavigationDataBLoC onInfoClickedNavigationDataBLoC = NavigationDataBLoC();
  LoginRespModel loginRespModel;
  NavigationDataBLoC checkLoginRespModel_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC current_PageViewPosition_NavigationDataBLoC =
      NavigationDataBLoC();
  BuildContext snackBarBuildContext;
  AnimationController animationController;
  BuildContext appBarBuildContext;
  NavigationDataBLoC showDraggableCards_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC hookuppageBodyDraggableCards_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC isDraggableCards_Laid_Out_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC matchModeChanged_NavigationDataBLoC = NavigationDataBLoC();

  IOWebSocketChannel notifchannel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  StreamSubscription notifchannel_StreamSubscription;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    initNotificationPlugin();
  }

 /* @override
 void dispose() {
    _pageController.dispose();

    if (animationController != null) {
      animationController.dispose();
    }
    if (notifchannel_StreamSubscription != null) {
      notifchannel_StreamSubscription.cancel();
    }
    super.dispose();
    _switchChangedBLoC.dispose();
  }*/
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
    _switchChangedBLoC.dispose();
  }

  //INIT FUNCTIONS
  initNotificationPlugin() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(
      initSetttings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null &&
        payload.contains(DatingAppStaticParams.Default_Sound_Socket)) {
      debugPrint("onSelectNotification:payload : ${payload.toString()}");

      NavigationData navigationData = new NavigationData();
      navigationData.selectedWidget = Index();
      navigationData.isInBackPressed = false;
    }
  }
  //END OF INIT FUNCTIONS

  @override
  void afterFirstLayout(BuildContext context) {
    print('Index:afterFirstLayout:');
    //setupListeners(context);
    getLoggedInUser(context);
    //refresh_showDraggableCards_NavigationDataBLoC(false);
    //setupListeners(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return Container(
          color: datingAppThemeChanger
              .selectedThemeData.sm_bg_backgroundWO_opacity,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _buildHookUpAppBar(),
            body: _buildTabsLayout(),
          ),
          //ProfileInfo(),
        );
      },
    );
  }

  //AFTER FIRST LAYOUT FUNCTOIONS
  getLoggedInUser(BuildContext context) async {
    loginRespModel = await getSessionLoginRespModel(context);
    refresh_WO_Data_NavigationDataBLoC(checkLoginRespModel_NavigationDataBLoC);
    connecttoNotificationSocket();
    setupListeners(context);
    showMatchmodeDialog(context);
  }

  setupListeners(BuildContext context) {
    String TAG = '_IndexState setupListeners:';
    /*onInfoClickedNavigationDataBLoC.stream_counter.listen((value) async {
      print(TAG + ' HERE1');*/
    /*NavigationData navigationData = value;
      if (navigationData != null &&
          navigationData.isSelected &&
          mainBuildContext != null) {
        print(TAG + ' HERE2');*/
    /*Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ProfileInfo();
          },
        ),
      );*/
    /*NavigationData navigationData = NavigationData();
        navigationData.isShow = false;
        refresh_W_Data_NavigationDataBLoC(
            showDraggableCards_NavigationDataBLoC, navigationData);
        addNewInterest(context);}*/
    //});
    /*isDraggableCards_Laid_Out_NavigationDataBLoC.stream_counter
        .listen((value) async {
      NavigationData navigationData = value;
      if (navigationData != null &&
          navigationData.isShow &&
          navigationData.isShow) {
        if (!isSystemRole(loginRespModel.tokenDecodedJModel.role_name)) {
          //QUERY FOR OPTIONS

          DateMatchModeListRespJModel dateMatchModeListRespJModel =
              await fetch_datematchmodes_online(
            context,
            DatingAppStaticParams.default_Max_int,
          );
          if (dateMatchModeListRespJModel != null &&
              dateMatchModeListRespJModel.results != null &&
              dateMatchModeListRespJModel.results.length > 0) {
            selectMatchMode(dateMatchModeListRespJModel);
          }
          //END OF QUERY FOR OPTIONS
        }
      }
    });*/

    matchModeChanged_NavigationDataBLoC.stream_counter.listen((value) async {
      NavigationData navigationData = value;
      if (navigationData != null && navigationData.isShow) {
        _pageController.jumpToPage(3);
        refresh_current_PageViewPosition_NavigationDataBLoC(3);
      }
    });
  }

  showMatchmodeDialog(BuildContext context) async {
    print('showMatchmodeDialog:');
    //QUERY FOR OPTIONS

    DateMatchModeListRespJModel dateMatchModeListRespJModel =
        await fetch_datematchmodes_online(
      context,
      DatingAppStaticParams.default_Max_int,
    );
    if (dateMatchModeListRespJModel != null &&
        dateMatchModeListRespJModel.results != null &&
        dateMatchModeListRespJModel.results.length > 0) {
      selectMatchMode(dateMatchModeListRespJModel);
    } else {
      //refresh_showDraggableCards_NavigationDataBLoC(true);
      refresh_hookuppageBodyDraggableCards_NavigationDataBLoC(true);
    }
    //END OF QUERY FOR OPTIONS
  }

  connecttoNotificationSocket() {
    String TAG = 'connecttoNotificationSocket:';
    print(TAG);
    String socketURL =
        '${DatingAppStaticParams.baseUrlWSIP_Address}notifications/?token=${loginRespModel.token}';

    try {
      notifchannel = IOWebSocketChannel.connect(
        socketURL,
      );
      notifchannel_StreamSubscription = notifchannel.stream.listen((message) {
        if (message != null) {
          _showSocketNotificationWithDefaultSound(message);
        }
      });
      print(TAG + ' CONNECTED:');
    } catch (error) {
      print(TAG + ' error==');
      print(error.toString());
      connecttoNotificationSocket();
    }
  }

  Future _showSocketNotificationWithDefaultSound(var message) async {
    String TAG = '_showSocketNotificationWithDefaultSound:';
    SocketNotificationListRespJModel socketNotificationListRespJModel =
        SocketNotificationListRespJModel.fromJson(json.decode(message));

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    List<SocketNotificationRespJModel> unreadSocketNotificationRespJModelList =
        [];
    for (int i = 0;
        i < socketNotificationListRespJModel.notifications.length;
        i++) {
      SocketNotificationRespJModel socketNotificationRespJModel =
          socketNotificationListRespJModel.notifications[i];

      if (!socketNotificationRespJModel.read) {
        unreadSocketNotificationRespJModelList
            .add(socketNotificationRespJModel);
      }
    }

    int rand_no = math.Random().nextInt(1);
    for (int i = 0; i < unreadSocketNotificationRespJModelList.length; i++) {
      SocketNotificationRespJModel socketNotificationRespJModel =
          unreadSocketNotificationRespJModelList[i];

      //READ NOTIFICATION
      socketNotificationRespJModel.read = true;
      await post_put_socket_notification(socketNotificationRespJModel,
          socketNotificationListRespJModel.notifications, i, null, context);
      //END OF READ NOTIFICATION

      await flutterLocalNotificationsPlugin.show(
        i + rand_no,
        socketNotificationRespJModel.action,
        socketNotificationRespJModel.message,
        platformChannelSpecifics,
        payload: 'Default_Sound_Socket',
      );
    }
  }
  //END OF AFTER FIRST LAYOUT FUNCTIONS

  List<Widget> get_buildTabsLayout() {
    List<Widget> widgetList = [];
    Widget settingsTab = new SettingsTab(
      navigationDataBLoC_UserprofilesChanged:
          navigationDataBLoC_UserprofilesChanged,
      current_PageViewPosition_NavigationDataBLoC:
          current_PageViewPosition_NavigationDataBLoC,
    );
    Widget hookupsLikeTopPicksParent = new HookupsLikeTopPicksParent(
      switchChangedBLoC: _switchChangedBLoC,
      navigationDataBLoC_UserprofilesChanged:
          navigationDataBLoC_UserprofilesChanged,
      onInfoClickedNavigationDataBLoC: onInfoClickedNavigationDataBLoC,
      showDraggableCards_NavigationDataBLoC:
          showDraggableCards_NavigationDataBLoC,
      hookuppageBodyDraggableCards_NavigationDataBLoC:
          hookuppageBodyDraggableCards_NavigationDataBLoC,
      isDraggableCards_Laid_Out_NavigationDataBLoC:
          isDraggableCards_Laid_Out_NavigationDataBLoC,
      current_PageViewPosition_NavigationDataBLoC:
          current_PageViewPosition_NavigationDataBLoC,
    );

    Widget messagesTab = MessagesTab(
      current_PageViewPosition_NavigationDataBLoC:
          current_PageViewPosition_NavigationDataBLoC,
    );

    widgetList.add(settingsTab);
    widgetList.add(hookupsLikeTopPicksParent);
    widgetList.add(messagesTab);
    /*loginRespModel = await getSessionLoginRespModel(context);
    if (loginRespModel != null &&
        loginRespModel.tokenDecodedJModel != null &&
        loginRespModel.tokenDecodedJModel.role_name != null &&
        loginRespModel.tokenDecodedJModel.role_name ==
            DatingAppStaticParams.SYSTEM) {
    Widget streamBuilder = StreamBuilder(
      stream: checkLoginRespModel_NavigationDataBLoC.stream_counter,
      builder: (context, snapshot) {
        return ((loginRespModel != null &&
                loginRespModel.tokenDecodedJModel != null &&
                loginRespModel.tokenDecodedJModel.role_name != null &&
                loginRespModel.tokenDecodedJModel.role_name ==
                    DatingAppStaticParams.SYSTEM
            ? AdminHome()
            : invisibleWidget()));
      },
    );
    widgetList.add(streamBuilder);
    }*/
    Widget adminHome = AdminHome();

    widgetList.add(adminHome);
    return widgetList;
  }

  Widget _buildTabsLayout() {
    /*return FutureBuilder<List<Widget>>(
      future: get_buildTabsLayout(),
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
        snackBarBuildContext = context;
        if (!snapshot.hasData) {
          return SizedBox();
        } else {*/
    return PageView(
      controller: _pageController,
      physics: ClampingScrollPhysics(),
      //physics: NeverScrollableScrollPhysics(),
      onPageChanged: _onPageChange,
      children:
          get_buildTabsLayout(), /*[
          SettingsTab(
            navigationDataBLoC_UserprofilesChanged:
                navigationDataBLoC_UserprofilesChanged,
            current_PageViewPosition_NavigationDataBLoC:
                current_PageViewPosition_NavigationDataBLoC,
          ),
          HookupsLikeTopPicksParent(
            switchChangedBLoC: _switchChangedBLoC,
            navigationDataBLoC_UserprofilesChanged:
                navigationDataBLoC_UserprofilesChanged,
            onInfoClickedNavigationDataBLoC: onInfoClickedNavigationDataBLoC,
            showDraggableCards_NavigationDataBLoC:
                showDraggableCards_NavigationDataBLoC,
            isDraggableCards_Laid_Out_NavigationDataBLoC:
                isDraggableCards_Laid_Out_NavigationDataBLoC,
            current_PageViewPosition_NavigationDataBLoC:
                current_PageViewPosition_NavigationDataBLoC,
          ),
          MessagesTab(
            current_PageViewPosition_NavigationDataBLoC:
                current_PageViewPosition_NavigationDataBLoC,
          ),
          AdminHome(),
        ]*/
    );
    /* }
      },
    );*/
  }

  /*Widget _buildTabsLayout() {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      onPageChanged: _onPageChange,
      children: <Widget>[
        new SettingsTab(
          navigationDataBLoC_UserprofilesChanged:
              navigationDataBLoC_UserprofilesChanged,
        ),
        new HookupsLikeTopPicksParent(
          switchChangedBLoC: _switchChangedBLoC,
          navigationDataBLoC_UserprofilesChanged:
              navigationDataBLoC_UserprofilesChanged,
          onInfoClickedNavigationDataBLoC: onInfoClickedNavigationDataBLoC,
        ),
        new MessagesTab(),
        StreamBuilder(
          stream: checkLoginRespModel_NavigationDataBLoC.stream_counter,
          builder: (context, snapshot) {
            return ((loginRespModel != null &&
                    loginRespModel.tokenDecodedJModel != null &&
                    loginRespModel.tokenDecodedJModel.role_name != null &&
                    loginRespModel.tokenDecodedJModel.role_name ==
                        DatingAppStaticParams.SYSTEM
                ? AdminHome()
                : invisibleWidget()));
          },
        ),
        //new AdminHome(),
      ],
    );
  }*/

  List<Widget> get_children_HookUpAppBar() {
    List<Widget> widgetList = [];

    Widget firstw = _buildTabItem(
        position: 0,
        widget: new AnimatedContainer(
            child: Icon(
              FontAwesomeIcons.solidUserCircle,
              size: 30.0,
              color: currentPage == 0 ? Colors.pink : Colors.grey,
            ),
            duration: Duration(milliseconds: 750),
            curve: Curves.fastOutSlowIn));
    Widget secondw = _buildTabItem(
        position: 1,
        widget: new AnimatedContainer(
            child: Image.asset(
              hookup_icon_small,
              color: currentPage == 1 ? Colors.pink : Colors.grey,
              height: 60.0,
              width: 60.0,
            ),
            duration: Duration(milliseconds: 750),
            curve: Curves.fastOutSlowIn));
    /*Widget secondw = _buildTabItem(
      position: 1,
      widget: StreamBuilder(
        stream: _switchChangedBLoC.stream_counter,
        initialData: initialsnapShotToObject(),
        builder: (context, snapshot) {
          return new Row(
            children: <Widget>[
              Visibility(
                child: Image.asset(
                  hookup_icon_small,
                  color: currentPage == 1 ? null : Colors.grey,
                  height: 60.0,
                  width: 60.0,
                ),
                visible: isImageVisible,
              ),
              Visibility(
                child: Switch(
                  onChanged: _onTogglePageChange,
                  value: snapShotToObject(snapshot.data).isSwitched,
                  activeColor: Colors.pink,
                ),
                visible: isSwitchVisible,
              ),
            ],
          );
        },
      ),
    );*/
    Widget thirdw = _buildTabItem(
        position: 2,
        widget: new AnimatedContainer(
            child: Icon(
              FontAwesomeIcons.solidPaperPlane,
              size: 25.0,
              color: currentPage == 2 ? Colors.pink : Colors.grey,
            ),
            duration: Duration(milliseconds: 750),
            curve: Curves.fastOutSlowIn));
    widgetList.add(firstw);
    widgetList.add(secondw);
    widgetList.add(thirdw);
    Widget fourthw = _buildTabItem(
        position: 3,
        widget: new AnimatedContainer(
            child: Icon(
              FontAwesomeIcons.cog,
              size: 25.0,
              color: currentPage == 3 ? Colors.pink : Colors.grey,
            ),
            duration: Duration(milliseconds: 750),
            curve: Curves.fastOutSlowIn));
    widgetList.add(fourthw);
    /*loginRespModel = await getSessionLoginRespModel(context);
    if (loginRespModel != null &&
        loginRespModel.tokenDecodedJModel != null &&
        loginRespModel.tokenDecodedJModel.role_name != null &&
        loginRespModel.tokenDecodedJModel.role_name ==
            DatingAppStaticParams.SYSTEM) {
    Widget fourthw = StreamBuilder(
      stream: checkLoginRespModel_NavigationDataBLoC.stream_counter,
      builder: (context, snapshot) {
        return ((loginRespModel != null &&
                loginRespModel.tokenDecodedJModel != null &&
                loginRespModel.tokenDecodedJModel.role_name != null &&
                loginRespModel.tokenDecodedJModel.role_name ==
                    DatingAppStaticParams.SYSTEM
            ? _buildTabItem(
                position: 3,
                widget: new AnimatedContainer(
                    child: Icon(
                      FontAwesomeIcons.lock,
                      size: 25.0,
                      color: currentPage == 3 ? Colors.pink : Colors.grey,
                    ),
                    duration: Duration(milliseconds: 750),
                    curve: Curves.fastOutSlowIn))
            : invisibleWidget()));
      },
    );
    widgetList.add(fourthw);
    }*/
    return widgetList;
  }

  Widget _buildHookUpAppBar() {
    return new PreferredSize(
      child: new Builder(
        builder: (BuildContext context) {
          appBarBuildContext = context;
          return SafeArea(
            child: new Container(
              decoration: BoxDecoration(
                color: DatingAppTheme.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: DatingAppTheme.grey.withOpacity(0.2),
                      offset: Offset(0, 1.1),
                      blurRadius: 3.0),
                ],
              ),
              padding: EdgeInsets.all(5.0),
              child:
                  /*new FutureBuilder<List<Widget>>(
                future: get_children_HookUpAppBar(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Widget>> snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox();
                  } else {*/
                  Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: get_children_HookUpAppBar(),
              ),
              /* }
                },
              ),*/
            ),
          );
        },
      ),
      preferredSize: new Size.fromHeight(60.0),
    );
  }

  /*Widget _buildHookUpAppBar() {
    return new PreferredSize(
        child: new SafeArea(
          child: new Container(
            padding: const EdgeInsets.all(5.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildTabItem(
                    position: 0,
                    widget: new AnimatedContainer(
                        child: Icon(
                          FontAwesomeIcons.solidUserCircle,
                          size: 30.0,
                          color: currentPage == 0 ? Colors.pink : Colors.grey,
                        ),
                        duration: Duration(milliseconds: 750),
                        curve: Curves.fastOutSlowIn)),
                _buildTabItem(
                  position: 1,
                  widget: StreamBuilder(
                    stream: _switchChangedBLoC.stream_counter,
                    initialData: initialsnapShotToObject(),
                    builder: (context, snapshot) {
                      return new Row(
                        children: <Widget>[
                          Visibility(
                            child: Image.asset(
                              hookup_icon_small,
                              color: currentPage == 1 ? null : Colors.grey,
                              height: 60.0,
                              width: 60.0,
                            ),
                            visible: isImageVisible,
                          ),
                          Visibility(
                            child: Switch(
                              onChanged: _onTogglePageChange,
                              value: snapShotToObject(snapshot.data).isSwitched,
                              activeColor: Colors.pink,
                            ),
                            visible: isSwitchVisible,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                _buildTabItem(
                    position: 2,
                    widget: new AnimatedContainer(
                        child:
                            /*Image.asset(
                          ic_chat,
                          color: currentPage == 2 ? Colors.pink : Colors.grey,
                          height: 30.0,
                          width: 30.0,
                        ),*/
                            Icon(
                          FontAwesomeIcons.solidPaperPlane,
                          size: 25.0,
                          color: currentPage == 2 ? Colors.pink : Colors.grey,
                        ),
                        duration: Duration(milliseconds: 750),
                        curve: Curves.fastOutSlowIn)),
                StreamBuilder(
                  stream: checkLoginRespModel_NavigationDataBLoC.stream_counter,
                  builder: (context, snapshot) {
                    return ((loginRespModel != null &&
                            loginRespModel.tokenDecodedJModel != null &&
                            loginRespModel.tokenDecodedJModel.role_name !=
                                null &&
                            loginRespModel.tokenDecodedJModel.role_name ==
                                DatingAppStaticParams.SYSTEM
                        ? _buildTabItem(
                            position: 3,
                            widget: new AnimatedContainer(
                                child: Icon(
                                  FontAwesomeIcons.lock,
                                  size: 25.0,
                                  color: currentPage == 3
                                      ? Colors.pink
                                      : Colors.grey,
                                ),
                                duration: Duration(milliseconds: 750),
                                curve: Curves.fastOutSlowIn))
                        : invisibleWidget()));
                  },
                ),
              ],
            ),
          ),
        ),
        preferredSize: new Size.fromHeight(60.0));
  }*/

  Widget _buildTabItem({Widget widget, int position}) {
    return new GestureDetector(
      onTap: () {
        _pageController.jumpToPage(position);
        refresh_current_PageViewPosition_NavigationDataBLoC(position);
      },
      child: Center(
        child: widget,
      ),
    );
  }

  void _onPageChange(int value) {
    //_pageController.jumpToPage(value);
    //refresh_current_PageViewPosition_NavigationDataBLoC(value);
    setState(() {
      currentPage = value;
      _onPageChangeImageSwitchToggle(value);
    });
  }

  void _onTogglePageChange(bool toggleVal) {
    print('toggleVal==$toggleVal');
    _switchChangedBLoC.switch_changed_event_sink
        .add(SwitchChangedEvent(toggleVal));
  }

/*  void _onPageChangeImageSwitchToggle(int value) {
    if (value == 1) {
      isImageVisible = false;
      isSwitchVisible = true;
    } else {
      isImageVisible = true;
      isSwitchVisible = false;
    }
  }*/

  void _onPageChangeImageSwitchToggle(int value) {
    refresh_current_PageViewPosition_NavigationDataBLoC(value);

    NavigationData navigationData = NavigationData();
    navigationData.current_index = value;
    refresh_W_Data_NavigationDataBLoC(
      current_PageViewPosition_NavigationDataBLoC,
      navigationData,
    );
  }



  LandingPageBlocResp snapShotToObject(dynamic dynamicSnapshot) {
    LandingPageBlocResp landingPageBlocResp = dynamicSnapshot;
    if (landingPageBlocResp != null) {
      print('snapShotToObject != null');
    } else if (landingPageBlocResp == null) {
      print('snapShotToObject == null');
      landingPageBlocResp = initialsnapShotToObject();
    }
    return landingPageBlocResp;
  }

  LandingPageBlocResp initialsnapShotToObject() {
    LandingPageBlocResp landingPageBlocResp = new LandingPageBlocResp();
    landingPageBlocResp.isSwitched = false;
    landingPageBlocResp.childhLTPcurrentPage = 1;
    return landingPageBlocResp;
  }

  //STATE CHANGES
  refresh_current_PageViewPosition_NavigationDataBLoC(
    int current_index,
  ) {
    NavigationData navigationData = NavigationData();
    navigationData.current_index = current_index;
    refresh_W_Data_NavigationDataBLoC(
      current_PageViewPosition_NavigationDataBLoC,
      navigationData,
    );
  }

  refresh_showDraggableCards_NavigationDataBLoC(bool isShow) {
    NavigationData navigationData = NavigationData();
    navigationData.isShow = isShow;
    refresh_W_Data_NavigationDataBLoC(
      showDraggableCards_NavigationDataBLoC,
      navigationData,
    );
  }

  refresh_hookuppageBodyDraggableCards_NavigationDataBLoC(bool isShow) {
    NavigationData navigationData = NavigationData();
    navigationData.isShow = isShow;
    refresh_W_Data_NavigationDataBLoC(
      hookuppageBodyDraggableCards_NavigationDataBLoC,
      navigationData,
    );
  }
  //END OF STATE CHANGES

  //SELECT PREFERRED MATCH MODE
  selectMatchMode(
      DateMatchModeListRespJModel dateMatchModeListRespJModel) async {
    //refresh_showDraggableCards_NavigationDataBLoC(false);
    refresh_hookuppageBodyDraggableCards_NavigationDataBLoC(false);
    await showGeneralDialog(
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: null,
        transitionDuration: Duration(milliseconds: 150),
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return new SelectMatchmodeDialog(
            snackbarBuildContext: snackBarBuildContext,
            animationController: animationController,
            matchModeChanged_NavigationDataBLoC:
                matchModeChanged_NavigationDataBLoC,
            dateMatchModeListRespJModel: dateMatchModeListRespJModel,
          );
        }).then((val) {
      print('show draggable cards');
      //refresh_showDraggableCards_NavigationDataBLoC(true);
      refresh_hookuppageBodyDraggableCards_NavigationDataBLoC(true);
    });
  }
  //END OF SELECT PREFERRED MATCH MODE
}
