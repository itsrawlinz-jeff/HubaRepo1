import 'package:dating_app/UI/Presentation/CountryPicker/flutter_country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:flutter_country_picker/flutter_country_picker.dart';

class LogInPage extends StatefulWidget {
  final IntindexCallback navigate;

  LogInPage({
    Key key,
    this.navigate,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LogInPageState();
  }
}

class _LogInPageState extends State<LogInPage> {
  Country _selected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            /*image: DecorationImage(
            image: AssetImage("assets/images/background-tinder.jpg"),
            fit: BoxFit.cover,
          ),*/
            ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 100),
            Padding(
              padding: EdgeInsets.only(left: 40.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'My number is',
                    style: new TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 40.0),
              child: Row(
                children: <Widget>[
                  CountryPicker(
                    dense: false,
                    showFlag: true, //displays flag, true by default
                    showDialingCode:
                        true, //displays dialing code, false by default
                    showName: false, //displays country name, true by default
                    onChanged: (Country country) {
                      setState(() {
                        _selected = country;
                      });
                    },
                    selectedCountry: _selected,
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        style: new TextStyle(
                            color: Colors.black87, fontSize: 16.0),
                        decoration: new InputDecoration(
                          hintText: '',
                          hintStyle: new TextStyle(
                              color: Colors.black87, fontSize: 16.0),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightGreen),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightGreen),
                          ),
                        ),
                        onSubmitted: (String val) {},
                        autofocus: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

typedef IntindexCallback = void Function(int intindex);
