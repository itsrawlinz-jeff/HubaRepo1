import 'dart:async';

import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ProfileDetailsDialog extends StatefulWidget {
  AnimationController animationController;
  BuildContext snackbarBuildContext;
  NavigationDataBLoC showDraggableCards_NavigationDataBLoC;

  Hobbie hobbie;
  ProfileDetailsDialog({
    Key key,
    this.animationController,
    this.snackbarBuildContext,
    this.showDraggableCards_NavigationDataBLoC,
  }) : super(key: key);
  @override
  _ProfileDetailsDialogState createState() => new _ProfileDetailsDialogState();
}

class _ProfileDetailsDialogState extends State<ProfileDetailsDialog>
    with TickerProviderStateMixin, AfterLayoutMixin<ProfileDetailsDialog> {
  List<String> str = [];
  AnimationController animationController;
  Animation<double> _scaleAnimation;
  Animation animation;

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
    print('dispose DIALOG');
    NavigationData navigationData = NavigationData();
    navigationData.isShow = true;
    refresh_W_Data_NavigationDataBLoC(
        widget.showDraggableCards_NavigationDataBLoC, navigationData);
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    String TAG = 'ProfileDetailsDialog afterFirstLayout:';
    setUpData(context);
    setUpListeners();
  }

  setUpData(BuildContext context) async {
    resetData();
  }

  resetData() {}

  setUpListeners() {}

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
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Text('meeen'),
              ),
            ),
          ),
        );
      },
    );
  }

  dismissSelf() {
    Navigator.pop(context);
  }
}
