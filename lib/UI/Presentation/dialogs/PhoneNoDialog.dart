import 'dart:async';

import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataEvent.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/put_post_illness.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Data/Database/Moor/Dao/IllnessDao.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/widgets.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:moor_flutter/moor_flutter.dart' as flutterMoor;

class PhoneNoDialog extends StatefulWidget {
  AnimationController animationController;
  BuildContext snackbarBuildContext;
  String phone_no;
  PhoneNoDialog({
    Key key,
    this.animationController,
    this.snackbarBuildContext,
    this.phone_no,
  }) : super(key: key);
  @override
  _PhoneNoDialogState createState() => new _PhoneNoDialogState();
}

class _PhoneNoDialogState extends State<PhoneNoDialog>
    with TickerProviderStateMixin, AfterLayoutMixin<PhoneNoDialog> {
  List<String> str = [];
  AnimationController animationController;
  Animation<double> _scaleAnimation;
  Animation animation;

  TextEditingController first_name_txt_Controller = TextEditingController();

  FocusNode first_name_FocusNode = FocusNode();

  NavigationDataBLoC val_first_name_NavigationDataBLoC = NavigationDataBLoC();

  NavigationDataBLoC loader_NavigationDataBLoC = NavigationDataBLoC();

  NavigationDataBLoC wd_name_Container_NavigationDataBLoC =
      NavigationDataBLoC();

  NavigationDataBLoC illnessSavedDailySubTaskImagesBLoC = NavigationDataBLoC();

  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

  @override
  void initState() {
    super.initState();
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
    String TAG = 'PhoneNoDialog afterFirstLayout:';

    setUpData(context);
    setUpListeners();
  }

  setUpData(BuildContext context) async {}

  setUpListeners() {}

  //STATE CHANGES
  refresh_wd_name_Container_NavigationDataBLoC(bool isValid, String msg) {
    NavigationData navigationData = NavigationData();
    navigationData.isValid = isValid;
    navigationData.message = msg;
    wd_name_Container_NavigationDataBLoC.dailySubTaskimages_event_sink
        .add(NavigationDataAddedEvent(navigationData));
  }

  //END OF STATE CHANGES

  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return AlertDialog(
          elevation: 8,
          backgroundColor: datingAppThemeChanger
              .selectedThemeData.sm_bg_background, //DatingAppTheme.transparent,
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
                                      left: 0, right: 0, top: 0, bottom: 0),
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
                                    child: new Form(
                                        key: _key,
                                        autovalidate: _validate,
                                        child: FormUI(datingAppThemeChanger)),
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
                                  saveData(context);
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

  Widget FormUI(DatingAppThemeChanger datingAppThemeChanger) {
    return new Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 4, right: 16, top: 8, bottom: 3),
            child: Text(
              'Phone No',
              style: datingAppThemeChanger
                  .selectedThemeData.txt_stl_whitegrey_14_Med,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0, bottom: 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Column(
                  children: <Widget>[
                    first_name_StreamBuilder(datingAppThemeChanger),
                    StreamBuilder(
                      stream:
                          wd_name_Container_NavigationDataBLoC.stream_counter,
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
                            return wd_name_Validator_Text(
                                datingAppThemeChanger, snapshot);
                            break;
                          case ConnectionState.done:
                            return wd_name_Validator_Text(
                                datingAppThemeChanger, snapshot);
                            break;
                        }
                      },
                    )
                  ],
                ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: invisibleWidget(),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            print('ok clicked');
                            saveData(context);
                          },
                          borderRadius: BorderRadius.all(
                            Radius.circular(43.0),
                          ),
                          splashColor: DatingAppTheme.pltf_pink,
                          child: Container(
                            decoration: BoxDecoration(
                              color: DatingAppTheme.pltf_pink.withOpacity(0.8),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: DatingAppTheme.nearlyBlack
                                        .withOpacity(0.4),
                                    offset: Offset(3.0, 3.0),
                                    blurRadius: 2.0),
                              ],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(3.0),
                                  bottomLeft: Radius.circular(3.0),
                                  bottomRight: Radius.circular(3.0),
                                  topRight: Radius.circular(3.0)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: 3, bottom: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'OK',
                                    style: TextStyle(
                                      color: DatingAppTheme.white,
                                      fontFamily: DatingAppTheme
                                          .font_AvenirLTStd_Medium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 2.0,
                      child: streamBuilderWidgetLoader(
                        loader_NavigationDataBLoC,
                        DatingAppTheme.white,
                        0,
                        false,
                        0,
                        0,
                        15,
                        15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  Widget wd_name_Validator_Text(
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
              style: datingAppThemeChanger
                  .selectedThemeData.txt_stl_error_f12_Light,
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

  double chooseContainerWidth(AsyncSnapshot<NavigationData> snapshot) {
    if (snapshot != null) {
      NavigationData navigationData = snapshot.data;
      if (navigationData != null) {
        if (navigationData.isValid) {
          return 40;
        } else {
          return 60;
        }
      } else {
        return 40;
      }
    } else {
      return 40;
    }
  }

  Widget first_name_StreamBuilder(DatingAppThemeChanger datingAppThemeChanger) {
    return StreamBuilder(
      stream: val_first_name_NavigationDataBLoC.stream_counter,
      builder: (context, snapshot) {
        return /*Container(
          height: chooseContainerWidth(snapshot),
          child:*/
            Container(
          height: chooseContainerWidth(snapshot),
          decoration: BoxDecoration(
            color: DatingAppTheme.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topRight: Radius.circular(8.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  offset: Offset(0.3, 2),
                  blurRadius: 4.0),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
            child: first_name_TextFormField(datingAppThemeChanger),
          ),
        );
      },
    );
  }

  Widget first_name_TextFormField(DatingAppThemeChanger datingAppThemeChanger) {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      style: datingAppThemeChanger.selectedThemeData.txt_stl_f14w500_Med,
      cursorColor: datingAppThemeChanger.selectedThemeData.cl_grey,
      decoration: InputDecoration(
        /*border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),*/
        border: InputBorder.none,
        hintText: "Phone No ",
        /*contentPadding: EdgeInsets.only(
          bottom: 0,
          right: 20.0,
          left: 10.0,
        ),*/
        hintStyle:
            datingAppThemeChanger.selectedThemeData.txt_stl_hint_f14w500_Med,
        errorStyle:
            datingAppThemeChanger.selectedThemeData.txt_stl_error_f12_Light,
        /*fillColor:
            datingAppThemeChanger.selectedThemeData.cl_darkText_backgroundcolor,
        filled: true,*/
        prefixIcon: Icon(
          Icons.phone,
          color: datingAppThemeChanger.selectedThemeData.cl_grey,
          size: 15.0,
        ),
      ),
      textInputAction: TextInputAction.next,
      onChanged: (String val) {
        illnessNameChanged();
      },
      controller: first_name_txt_Controller,
      focusNode: first_name_FocusNode,
      autofocus: false,
      onFieldSubmitted: (String val) {
        first_name_FocusNode.unfocus();
      },
    );
  }

  illnessNameChanged() {
    widget.phone_no = first_name_txt_Controller.text;
    validate_Phone_No();
  }

  //VALIDATORS
  bool validate_Phone_No() {
    widget.phone_no = first_name_txt_Controller.text;
    if (isStringValid(widget.phone_no)) {
      RegExp regex = new RegExp(get_Phone_Pattern());
      if (!regex.hasMatch(widget.phone_no)) {
        refresh_wd_name_Container_NavigationDataBLoC(
            false, 'enter a valid phone number 254xxxxxxxxx');
        return false;
      } else {
        refresh_wd_name_Container_NavigationDataBLoC(true, null);
        return true;
      }
    } else {
      refresh_wd_name_Container_NavigationDataBLoC(
          false, 'phone number is invalid');
      return false;
    }
  }

  bool isDataValid() {
    bool isDataValid = true;
    bool is_validate_Phone_No = validate_Phone_No();

    isDataValid = is_validate_Phone_No;
    return isDataValid;
  }
  //END OF VALIDATORS

  saveData(BuildContext context) async {
    String TAG = 'saveData';
    refreshLoader(true, loader_NavigationDataBLoC);
    print(TAG);

    if (isDataValid()) {
    } else {}
    refreshLoader(false, loader_NavigationDataBLoC);
    _dismissSelf();
  }

  _dismissSelf() {
    Navigator.pop(context, widget.phone_no);
  }
}
