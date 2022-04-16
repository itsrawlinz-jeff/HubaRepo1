import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';

class HomeDrawer extends StatefulWidget {
  HomeDrawer(
      {Key key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer>
    with AfterLayoutMixin<HomeDrawer> {
  List<DrawerList> drawerList = [];
  NavigationDataBLoC on_drawerList_Changed_NavigationDataBLoC =
      NavigationDataBLoC();
  LoginRespModel loginRespModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getLoggedInUser_and_setUpData(context);
  }

  getLoggedInUser_and_setUpData(BuildContext context) async {
    loginRespModel = await getSessionLoginRespModel(context);
    setdDrawerListArray();
  }

  void setdDrawerListArray() {
    if (isSystemRole(loginRespModel.tokenDecodedJModel.role_name)) {
      drawerList.add(DrawerList(
        index: DrawerIndex.Matches,
        labelName: 'Matches',
        icon: Icon(Icons.compare_arrows),
      ));
    } else {
      drawerList.add(DrawerList(
        index: DrawerIndex.UserRequestMatch,
        labelName: 'Requests',
        icon: Icon(Icons.compare_arrows),
      ));
    }
    refresh_on_drawerList_Changed_NavigationDataBLoC();
    /*DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Dash Board',
        icon: Icon(Icons.dashboard),
      ),*/
  }

  //STATE CHANGES
  refresh_on_drawerList_Changed_NavigationDataBLoC() {
    refresh_WO_Data_NavigationDataBLoC(
        on_drawerList_Changed_NavigationDataBLoC);
  }
  //END OF STATE CHANGES

  @override
  Widget build(BuildContext context) {
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return Scaffold(
          backgroundColor: DatingAppTheme.notWhite.withOpacity(0.5),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              /*Container(
            width: double.infinity,
            padding:  EdgeInsets.only(top: 40.0),
            child: Container(
              padding:  EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(
                            1.0 - (widget.iconAnimationController.value) * 0.2),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(Tween<double>(
                                      begin: 0.0, end: 24.0)
                                  .animate(CurvedAnimation(
                                      parent: widget.iconAnimationController,
                                      curve: Curves.fastOutSlowIn))
                                  .value /
                              360),
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: DatingAppTheme.grey.withOpacity(0.6),
                                    offset:  Offset(2.0, 4.0),
                                    blurRadius: 8),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius:
                                   BorderRadius.all(Radius.circular(60.0)),
                              child: Image.asset('assets/images/userImage.png'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      'Chris Hemsworth',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: DatingAppTheme.grey,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),*/
              SizedBox(
                height: 4,
              ),
              /*Divider(
            height: 1,
            color: DatingAppTheme.grey.withOpacity(0.6),
          ),*/
              Expanded(
                  child: StreamBuilder(
                stream: on_drawerList_Changed_NavigationDataBLoC.stream_counter,
                builder: (context, snapshot) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(0.0),
                    itemCount: drawerList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return inkwell(drawerList[index], datingAppThemeChanger);
                    },
                  );
                },
              )),
            ],
          ),
        );
      },
    );
  }

  Widget inkwell(
      DrawerList listData, DatingAppThemeChanger datingAppThemeChanger) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: DatingAppTheme.pltf_grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? DatingAppTheme.pltf_pink
                                  : DatingAppTheme.pltf_grey),
                        )
                      : Icon(listData.icon.icon,
                          color: widget.screenIndex == listData.index
                              ? DatingAppTheme.pltf_pink
                              : DatingAppTheme.pltf_grey),
                  Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? DatingAppTheme.pltf_pink
                          : DatingAppTheme.pltf_grey,
                    ),
                    /*TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? DatingAppTheme.pltf_pink
                          : DatingAppTheme.pltf_grey,
                    ),*/
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: DatingAppTheme.pltf_pink.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndex {
  HOME,
  Matches,
  UserRequestMatch,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
