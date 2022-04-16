import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:flutter/material.dart';

class ProfileInfo extends StatefulWidget {
  ProfileInfo({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfileInfoState();
  }
}

class _ProfileInfoState extends State<ProfileInfo> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('WILL POOOP BACK');
        Navigator.pop(context);
      },
      child: Scaffold(
        body: Container(
          color: DatingAppTheme.green,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }
}
