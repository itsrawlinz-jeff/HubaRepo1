import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/tabs/messages_tab/feed.dart';
import 'package:dating_app/tabs/messages_tab/messages.dart';
import 'package:after_layout/after_layout.dart';
import 'package:provider/provider.dart';

class MessagesTab extends StatefulWidget {
  NavigationDataBLoC current_PageViewPosition_NavigationDataBLoC;

  MessagesTab({
    Key key,
    this.current_PageViewPosition_NavigationDataBLoC,
  }) : super(key: key);

  @override
  _MessagesTabState createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab>
    with
        AutomaticKeepAliveClientMixin<MessagesTab>,
        AfterLayoutMixin<MessagesTab> {
  PageController _pageController = new PageController(initialPage: 0);
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setUpListeners();
  }

  setUpListeners() {
    String TAG = 'setUpListeners:';
    widget.current_PageViewPosition_NavigationDataBLoC.stream_counter
        .listen((value) async {
      NavigationData navigationData = value;
      if (navigationData != null && navigationData.current_index == 2) {
        //MESSAGES PAGE RUN ON INIT
        print(TAG + ' current_PageViewPosition_NavigationDataBLoC==2 MESSAGES');
      }
    });
  }

  setUpData() {}

  Widget _buildMessageAppBar() {
    return new Column(
      children: <Widget>[
        new SizedBox(
          height: 8,
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildTabItem(title: "Messages", position: 0),
            new Container(
              height: 30.0,
              width: 1,
              color: Colors.grey.withOpacity(0.5),
            ),
            _buildTabItem(title: "Feeds", position: 1),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTabsLayout() {
    return new Flexible(
      child: PageView(
        controller: _pageController,
        //physics: NeverScrollableScrollPhysics(),
        onPageChanged: _onPageChange,
        children: <Widget>[
          new Messages(
            current_PageViewPosition_NavigationDataBLoC:
                widget.current_PageViewPosition_NavigationDataBLoC,
          ),
          new Feed(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Consumer<DatingAppThemeChanger>(
        builder: (context, datingAppThemeChanger, child) {
      return Container(
        color:
            datingAppThemeChanger.selectedThemeData.sm_bg_backgroundWO_opacity,
        child: Scaffold(
          //backgroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          body: new Column(
            children: <Widget>[_buildMessageAppBar(), _buildTabsLayout()],
          ),
        ),
      );
    });
  }

  void _onPageChange(int value) {
    setState(() {
      currentPage = value;
    });
  }

  Widget _buildTabItem({String title, int position}) {
    Color color = position == currentPage ? Colors.pink : Colors.grey;

    return new Flexible(
      child: new GestureDetector(
        onTap: () {
          _pageController.jumpToPage(position);
        },
        //child: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: DatingAppTheme.font_AvenirLTStd_Black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
