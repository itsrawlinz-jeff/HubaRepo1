import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Bloc/bloc_library/navigationdrawer/navigationdrawer_bloc.dart';
import 'package:dating_app/Bloc/bloc_library/navigationdrawer/navigationdrawer_event.dart';
import 'package:dating_app/Bloc/bloc_library/navigationdrawer/navigationdrawer_state.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/UI/Presentation/admin_drawer/drawer_user_controller.dart';
import 'package:dating_app/UI/Presentation/admin_drawer/home_drawer.dart';
import 'package:dating_app/UI/Presentation/fragments/AdminDashBoard.dart';
import 'package:dating_app/UI/Presentation/fragments/AdminMakeMatches.dart';
import 'package:dating_app/UI/Presentation/fragments/InitialContainer.dart';
import 'package:dating_app/UI/Presentation/fragments/user_request_matches/UserRequestMatchList.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:after_layout/after_layout.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> with
    AfterLayoutMixin<AdminHome> {
  // with AutomaticKeepAliveClientMixin<AdminHome>,
  Widget screenView;
  DrawerIndex drawerIndex;
  AnimationController sliderAnimationController;
  List<Widget> widgetsHistory = [];
  LoginRespModel loginRespModel;
  NavigationDataBLoC on_loginRespModel_Changed_NavigationDataBLoC =
      NavigationDataBLoC();

  @override
  void initState() {
    //drawerIndex = DrawerIndex.Matches;
    //screenView = AdminMakeMatches();
    screenView = InitialContainer();
    print('AdminHome:initState');
    super.initState();
  }


  @override
  void dispose() {
    print('AdminHome:dispose');
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    print('AdminHome:afterFirstLayout');
    getLoggedInUser_and_setUpData(context);
  }

  getLoggedInUser_and_setUpData(BuildContext context) async {
    loginRespModel = await getSessionLoginRespModel(context);
    if (isSystemRole(loginRespModel.tokenDecodedJModel.role_name)) {
      drawerIndex = DrawerIndex.Matches;
      screenView = AdminMakeMatches();
    } else {
      drawerIndex = DrawerIndex.UserRequestMatch;
      screenView = UserRequestMatchList();
    }


    NavigationData navigationData = new NavigationData();
    navigationData.selectedWidget = screenView;
    navigationData.isInBackPressed = false;
    NavigationdrawerBloc navigationdrawerBloc =
    BlocProvider.of<NavigationdrawerBloc>(context);
    navigationdrawerBloc.add(NavDrawer(navigationData));

    refresh_on_loginRespModel_Changed_NavigationDataBLoC();
  }

  //STATE CHANGES
  refresh_on_loginRespModel_Changed_NavigationDataBLoC() {
    refresh_WO_Data_NavigationDataBLoC(
        on_loginRespModel_Changed_NavigationDataBLoC);
  }

  //END OF STATE CHANGES

  @override
  Widget build(BuildContext context) {
    print('AdminHome:build screenView=='+screenView.toString());
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Container(
        color: DatingAppTheme.nearlyWhite,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            backgroundColor: DatingAppTheme.nearlyWhite,
            body: DrawerUserController(
              screenIndex: drawerIndex,
              drawerWidth: MediaQuery.of(context).size.width * 0.75,
              animationController: (AnimationController animationController) {
                sliderAnimationController = animationController;
              },
              onDrawerCall: (DrawerIndex drawerIndexdata) {
                changeIndex(drawerIndexdata,context);
              },
              screenView: StreamBuilder(
                stream:
                    on_loginRespModel_Changed_NavigationDataBLoC.stream_counter,
                builder: (context, snapshot) {
                  return //screenView,
                      BlocListener<NavigationdrawerBloc, NavigationdrawerState>(
                    listener: (context, state) {},
                    child: BlocBuilder<NavigationdrawerBloc,
                        NavigationdrawerState>(
                      builder: (context, state) {
                        if (state is NavigationdrawerLoaded) {
                          NavigationData navigationData = state.navigationData;
                          screenView = navigationData.selectedWidget;
                          if (navigationData.drawerIndex != null) {
                            drawerIndex = navigationData.drawerIndex;
                          }
                          if (!navigationData.isInBackPressed) {
                            if (screenView is AdminDashBoard) {
                            } else {
                              ifToAddWidgetToHistory(screenView);
                            }
                          }
                          return screenView;
                        } else if (state is NavigationdrawerInitial) {
                          ifToAddWidgetToHistory(screenView);
                          return screenView;
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata, BuildContext context) {
    print('AdminHome:changeIndex'+ drawerIndex.toString());
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        screenView = AdminDashBoard();
      } else if (drawerIndex == DrawerIndex.Matches) {
        screenView = AdminMakeMatches();
      } else if (drawerIndex == DrawerIndex.UserRequestMatch) {
        screenView = UserRequestMatchList();
      }

      setState(() {
        drawerIndex = drawerIndex;
      });
      NavigationData navigationData = new NavigationData();
      navigationData.selectedWidget = screenView;
      navigationData.isInBackPressed = false;
      NavigationdrawerBloc navigationdrawerBloc =
          BlocProvider.of<NavigationdrawerBloc>(context);
      navigationdrawerBloc.add(NavDrawer(navigationData));

      //REMOVE UNTIL LAST
      try {
        Widget firstWidget = null;
        firstWidget = widgetsHistory[0];
        if (firstWidget is InitialContainer) {
          if (widgetsHistory.length > 1) {
            firstWidget = widgetsHistory[1];
          }
        }
        widgetsHistory.clear();
        if (firstWidget != null) {
          widgetsHistory.add(firstWidget);
        }
      } catch (error) {
        widgetsHistory.clear();
        print(error);
      }

      //END OF REMOVE UNTIL LAST
    } else {
      //do in your way......
      Widget currentSideMenuWidget;
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        currentSideMenuWidget = AdminDashBoard();
      } else if (drawerIndex == DrawerIndex.Matches) {
        currentSideMenuWidget = AdminMakeMatches();
      } else if (drawerIndex == DrawerIndex.UserRequestMatch) {
        currentSideMenuWidget = UserRequestMatchList();
      }

      if (screenView != currentSideMenuWidget) {
        NavigationData navigationData = new NavigationData();
        navigationData.selectedWidget = currentSideMenuWidget;
        navigationData.isInBackPressed = false;
        NavigationdrawerBloc navigationdrawerBloc =
            BlocProvider.of<NavigationdrawerBloc>(context);
        navigationdrawerBloc.add(NavDrawer(navigationData));
      }
    }
  }

  bool ifToAddWidgetToHistory(Widget widgetToadd) {
    if (widgetsHistory != null && !(widgetToadd is InitialContainer)) {
      List<Widget> widgetsFoudMatching = [];
      for (Widget widgetsHistoryItem in widgetsHistory) {
        if (widgetsHistoryItem.toString() == widgetToadd.toString()) {
          widgetsFoudMatching.add(widgetsHistoryItem);
        }
      }
      if (widgetsFoudMatching.length > 0) {
        //FOUND ALREADY IN HISTORY
      } else {
        //NOT FOUND ADD
        widgetsHistory.add(widgetToadd);
      }
    }
  }

  Future<bool> _onBackPressed(BuildContext context) {
    print('_onBackPressed');
    if (widgetsHistory.length > 0) {
      List<Widget> updatedWidgetHistoryState = [];
      updatedWidgetHistoryState.addAll(widgetsHistory);

      Widget currentWidget = widgetsHistory[widgetsHistory.length - 1];
      updatedWidgetHistoryState.remove(currentWidget);

      if (updatedWidgetHistoryState.length > 0) {
        Widget openingWidget = widgetsHistory[widgetsHistory.length - 2];

        NavigationData navigationData = new NavigationData();
        navigationData.selectedWidget = openingWidget;
        navigationData.isInBackPressed = true;

        NavigationdrawerBloc navigationdrawerBloc =
            BlocProvider.of<NavigationdrawerBloc>(context);
        navigationdrawerBloc.add(NavDrawer(navigationData));

        if (navigationData.selectedWidget is AdminMakeMatches) {
          drawerIndex = DrawerIndex.Matches;
          setState(() {
            drawerIndex = drawerIndex;
          });
        } else if (navigationData.drawerIndex != null) {
          drawerIndex = navigationData.drawerIndex;
          setState(() {
            drawerIndex = drawerIndex;
          });
        }

        widgetsHistory.remove(currentWidget);
      } else {
        //return asyncPop(context) ?? false;
        return rtn_boolVal(false);
      }
    } else {
      //return asyncPop(context) ?? false;
      return rtn_boolVal(false);
    }
  }

  Future<bool> asyncPop(BuildContext context) async {
    bool afterPop = await Navigator.of(context).pop();
    if (afterPop) {
      return afterPop;
    } else {
      await Navigator.popUntil(
          context, (Route<dynamic> route) => route.isFirst);
      return true;
    }
  }

  Future<bool> rtn_boolVal(bool boolVal) async {
    return boolVal;
  }


  /*@override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;*/
}
