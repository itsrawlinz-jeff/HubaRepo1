import 'package:flutter/material.dart';

class LikeTopPicksPageHolder extends StatefulWidget {
  @override
  _LikeTopPicksPageHolderState createState() => _LikeTopPicksPageHolderState();
}

class _LikeTopPicksPageHolderState extends State<LikeTopPicksPageHolder>
     {
    //with AutomaticKeepAliveClientMixin<LikeTopPicksPageHolder>
  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return Scaffold(
      body: Column(children: <Widget>[
        Center(child: Text('Coming Soon'),),
       /* TextField(
          textAlign: TextAlign.center,
          keyboardType: TextInputType.text,
          style: new TextStyle(
              color: Colors.black87, fontSize: 16.0),
          decoration: new InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.lightGreen),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.lightGreen),
            ),
          ),
          onSubmitted: (String val) {},
          autofocus: true,
        ),*/
      ],),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /*@override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;*/
}
