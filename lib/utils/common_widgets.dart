import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget invisibleWidget() {
  return Visibility(
    visible: false,
    child: SizedBox(
      height: 0,
      width: 0,
    ),
  );
}

Widget spaCer15() {
  return SizedBox(
    height: 15,
  );
}

Widget spaCer10() {
  return SizedBox(
    height: 10,
  );
}

Widget spaCer5() {
  return SizedBox(
    height: 5,
  );
}

void showSnackbarWBgCol(String message, BuildContext context, Color bgcolor) {
  if (context != null) {
    SnackBar snackBar = SnackBar(
      content: Text(
        message,
        style: DatingAppTheme.txt_snackbar_TextStyle,
      ),
      action: SnackBarAction(
          label: 'OK', textColor: DatingAppTheme.white, onPressed: () {}),
      backgroundColor: bgcolor,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}

void showSnackbarWBgCol_If_Context(
    String message, BuildContext context, Color bgcolor) {
  if (context != null) {
    SnackBar snackBar = SnackBar(
      content: Text(
        message,
        style: DatingAppTheme.txt_snackbar_TextStyle,
      ),
      action: SnackBarAction(
          label: 'OK', textColor: DatingAppTheme.white, onPressed: () {}),
      backgroundColor: bgcolor,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}

Widget streamBuilderWidgetLoader(
  NavigationDataBLoC navigationDataBLoC,
  Color preferredcolor,
  double preferredPadding,
  bool isPositioned,
  double right,
  double bottom,
  double contWidth,
  double contHeight,
) {
  return StreamBuilder(
    stream: navigationDataBLoC.stream_counter,
    builder: (context, snapshot) {
      if (snapshot.hasError) return invisibleWidget();
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          return invisibleWidget();
          break;
        case ConnectionState.waiting:
          return invisibleWidget();
          break;
        case ConnectionState.active:
          return onLoaderInitializedWidget(
            snapshot,
            preferredcolor,
            preferredPadding,
            isPositioned,
            right,
            bottom,
            contWidth,
            contHeight,
          );
          break;
        case ConnectionState.done:
          return onLoaderInitializedWidget(
            snapshot,
            preferredcolor,
            preferredPadding,
            isPositioned,
            right,
            bottom,
            contWidth,
            contHeight,
          );
          break;
      }
    },
  );
}

Widget onLoaderInitializedWidget(
  AsyncSnapshot<NavigationData> snapshot,
  Color preferredcolor,
  double preferredPadding,
  bool isPositioned,
  double right,
  double bottom,
  double contWidth,
  double contHeight,
) {
  if (snapshot != null) {
    NavigationData navData = snapshot.data;
    if (navData.isShow) {
      return getCircularProgressIndicator(
        preferredcolor,
        preferredPadding,
        isPositioned,
        right,
        bottom,
        contWidth,
        contHeight,
      );
    } else {
      return invisibleWidget();
    }
  } else {
    return invisibleWidget();
  }
}

Widget getCircularProgressIndicator(
  Color color,
  double preferredPadding,
  bool isPositioned,
  double right,
  double bottom,
  double contWidth,
  double contHeight,
) {
  if (isPositioned) {
    return Positioned(
      right: right,
      bottom: bottom,
      child: Padding(
        padding: EdgeInsets.all(preferredPadding),
        child: Theme(
          data: ThemeData(
            accentColor: color,
          ),
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  } else {
    return Padding(
        padding: EdgeInsets.all(preferredPadding),
        child: ((contWidth != null && contHeight != null
            ? Container(
                width: contWidth,
                height: contHeight,
                child: Theme(
                  data: ThemeData(
                    accentColor: color,
                  ),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              )
            : Theme(
                data: ThemeData(
                  accentColor: color,
                ),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ))));
  }
}

displaySnackBarWithDelay(String message, Color bgColor, BuildContext context) {
  Scaffold.of(context).hideCurrentSnackBar();
  SnackBar snackBar = SnackBar(
    content: Text(
      message,
      style: DatingAppTheme.txt_snackbar_TextStyle,
    ),
    duration: Duration(seconds: 3),
    action: SnackBarAction(
        label: 'OK', textColor: DatingAppTheme.white, onPressed: () {}),
    backgroundColor: bgColor,
  );
  Scaffold.of(context).showSnackBar(snackBar);
  Future.delayed(Duration(seconds: 3), () {
    Scaffold.of(context).hideCurrentSnackBar();
  });
}

displaySnackBarWith_6sec_Delay(
    String message, Color bgColor, BuildContext context) {
  Scaffold.of(context).hideCurrentSnackBar();
  SnackBar snackBar = SnackBar(
    content: Text(
      message,
      style: DatingAppTheme.txt_snackbar_TextStyle,
    ),
    duration: Duration(seconds: 3),
    action: SnackBarAction(
        label: 'OK', textColor: DatingAppTheme.white, onPressed: () {}),
    backgroundColor: bgColor,
  );
  Scaffold.of(context).showSnackBar(snackBar);
  Future.delayed(Duration(seconds: 6), () {
    Scaffold.of(context).hideCurrentSnackBar();
  });
}

Widget wd_Error_Notifier_Validator_Text(
  DatingAppThemeChanger adrianErpThemeChanger,
  AsyncSnapshot<NavigationData> snapshot,
) {
  NavigationData navigationdata = snapshot.data;
  if (navigationdata != null) {
    if (navigationdata.isValid != null) {
      if (navigationdata.isValid) {
        return invisibleWidget();
      } else {
        return Padding(
          padding: EdgeInsets.only(top: 2),
          child: Text(
            navigationdata.message,
            style:
                adrianErpThemeChanger.selectedThemeData.default_error_TextStyle,
          ),
        );
      }
    } else {
      return invisibleWidget();
    }
  } else {
    return invisibleWidget();
  }
}

Widget wd_Error_Notifier_Validator_Text_White(
  AsyncSnapshot<NavigationData> snapshot,
) {
  NavigationData navigationdata = snapshot.data;
  if (navigationdata != null) {
    if (navigationdata.isValid != null) {
      if (navigationdata.isValid) {
        return invisibleWidget();
      } else {
        return Padding(
          padding: EdgeInsets.only(top: 2),
          child: Text(
            navigationdata.message,textAlign: TextAlign.center,
            style: TextStyle(
                color: DatingAppTheme.white,
                fontSize: 12.0,
                fontFamily: DatingAppTheme.font_AvenirLTStd_Light),
          ),
        );
      }
    } else {
      return invisibleWidget();
    }
  } else {
    return invisibleWidget();
  }
}

Widget ifToShow_positionedErrorIcon(AsyncSnapshot<NavigationData> snapshot) {
  NavigationData navigationData = snapshot.data;
  if (navigationData != null) {
    if (!navigationData.isValid) {
      return positionedErrorIcon();
    } else {
      return invisibleWidget();
    }
  } else {
    return invisibleWidget();
  }
}

Widget positionedErrorIcon() {
  return Positioned(
    right: 16,
    child: Icon(Icons.warning, size: 17, color: DatingAppTheme.red),
  );
}

Widget ifToShow_positionedNotificationIcon(
    AsyncSnapshot<NavigationData> snapshot) {
  NavigationData navigationData = snapshot.data;
  if (navigationData != null) {
    if (navigationData.isShow) {
      return positionedNotificationIcon();
    } else {
      return invisibleWidget();
    }
  } else {
    return invisibleWidget();
  }
}

Widget positionedNotificationIcon() {
  return Positioned(
    right: 2,
    top: 2,
    child: Icon(
      Icons.warning,
      size: 15,
      color: DatingAppTheme.red,
    ),
  );
}

Widget ifToShow_positionedNotificationIcon_WDims(
    AsyncSnapshot<NavigationData> snapshot, double right, double top) {
  NavigationData navigationData = snapshot.data;
  if (navigationData != null) {
    if (navigationData.isShow) {
      return positionedNotificationIcon_WDims(right, top);
    } else {
      return invisibleWidget();
    }
  } else {
    return invisibleWidget();
  }
}

Widget positionedNotificationIcon_WDims(double right, double top) {
  return Positioned(
    right: right,
    top: top,
    child: Icon(
      Icons.warning,
      size: 15,
      color: DatingAppTheme.red,
    ),
  );
}

Widget notAvailableWidget_W_KeyboardVisibility_Snapshot(
    String msg, AsyncSnapshot<bool> keyBoardVisible_snapshot) {
  if (keyBoardVisible_snapshot == null) {
    return notAvailableWidget(msg);
  } else {
    if (keyBoardVisible_snapshot.data != null) {
      print('keyBoardVisible_snapshot.data != null');
      if (keyBoardVisible_snapshot.data) {
        return invisibleWidget();
      } else {
        return notAvailableWidget(msg);
      }
    } else {
      print('keyBoardVisible_snapshot.data == null');
      return notAvailableWidget(msg);
    }
  }
}

Widget notAvailableWidget(String msg) {
  return Consumer<DatingAppThemeChanger>(
    builder: (context, adrianErpThemeChanger, child) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color:
                  adrianErpThemeChanger.selectedThemeData.white_box_Background,
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: DatingAppTheme.nearlyBlack.withOpacity(0.4),
                    offset: Offset(8.0, 8.0),
                    blurRadius: 8.0),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
              child: Container(
                width: (MediaQuery.of(context).size.width - 40) * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      msg,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: adrianErpThemeChanger
                            .selectedThemeData.mnu_grey_Color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget wd_Text_Widget_Form_Validator_Text(
  DatingAppThemeChanger datingAppThemeChanger,
  AsyncSnapshot<NavigationData> snapshot,
) {
  NavigationData navigationdata = snapshot.data;
  if (navigationdata != null) {
    if (navigationdata.isValid != null) {
      if (navigationdata.isValid) {
        return invisibleWidget();
      } else {
        return Padding(
          padding: EdgeInsets.only(top: 2),
          child: Text(
            navigationdata.message,
            style:
                datingAppThemeChanger.selectedThemeData.txt_stl_error_f12_Light,
          ),
        );
      }
    } else {
      return invisibleWidget();
    }
  } else {
    return invisibleWidget();
  }
}

Widget nointernetConnectedLoaded_Image() {
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
