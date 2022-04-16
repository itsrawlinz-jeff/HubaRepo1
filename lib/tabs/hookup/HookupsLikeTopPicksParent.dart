import 'package:dating_app/Bloc/Streams/LandingPage/LandingPageBLoC.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Models/ui/LandingPageBlocResp.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:flutter/material.dart';
//import 'package:dating_app/scr/hookup.dart';
import 'package:dating_app/scr/hookupnew.dart';
import 'package:dating_app/tabs/hookup/LikeTopPicksPageHolder.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:provider/provider.dart';

class HookupsLikeTopPicksParent extends StatefulWidget {
  SwitchChangedBLoC switchChangedBLoC;
  NavigationDataBLoC navigationDataBLoC_UserprofilesChanged;
  NavigationDataBLoC onInfoClickedNavigationDataBLoC;
  NavigationDataBLoC showDraggableCards_NavigationDataBLoC;
  NavigationDataBLoC isDraggableCards_Laid_Out_NavigationDataBLoC;
  NavigationDataBLoC current_PageViewPosition_NavigationDataBLoC;
  NavigationDataBLoC hookuppageBodyDraggableCards_NavigationDataBLoC;
  HookupsLikeTopPicksParent({
    Key key,
    @required this.switchChangedBLoC,
    this.navigationDataBLoC_UserprofilesChanged,
    this.onInfoClickedNavigationDataBLoC,
    this.showDraggableCards_NavigationDataBLoC,
    this.isDraggableCards_Laid_Out_NavigationDataBLoC,
    this.current_PageViewPosition_NavigationDataBLoC,
    this.hookuppageBodyDraggableCards_NavigationDataBLoC,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HookupsLikeTopPicksParentState();
  }
}

class HookupsLikeTopPicksParentState extends State<HookupsLikeTopPicksParent>
    with AutomaticKeepAliveClientMixin<HookupsLikeTopPicksParent> {
  PageController _hLTPpageController = new PageController(initialPage: 1);
  int _hLTPcurrentPage = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuildFinished());
  }

  afterBuildFinished() {
    print('afterBuildFinished');
    widget.switchChangedBLoC.stream_counter.listen((value) {
      LandingPageBlocResp landingPageBlocResp = value;
      print(
          'Value from controller ISS: ${landingPageBlocResp.childhLTPcurrentPage}');
      if (_hLTPpageController.hasClients) {
        print(
            'landingPageBlocResp.childhLTPcurrentPage.toDouble()=${landingPageBlocResp.childhLTPcurrentPage.toDouble()}');
        //_hLTPpageController.jumpTo(landingPageBlocResp.childhLTPcurrentPage.toDouble());
        onhLTPPageChangeWoState(landingPageBlocResp.childhLTPcurrentPage);
      } else {
        print('_hLTPpageController has no clients');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return Scaffold(
          body: _buildLTPTabsLayout(datingAppThemeChanger),
        );
      },
    );
  }

  Widget _buildLTPTabsLayout(DatingAppThemeChanger datingAppThemeChanger) {
    /*StreamBuilder(
      stream: _switchChangedBLoC.stream_counter,
      initialData: initialsnapShotToObject(),
      builder: (context, snapshot) {
        return VisibilityDetector(
          key: Key("myhookupliketoppicsparent"),
          onVisibilityChanged: (VisibilityInfo info) {
            if (info.visibleFraction > 0) {
              print(
                  'hookuppage ${snapShotToObject(snapshot.data).childhLTPcurrentPage}');
              _hLTPcurrentPage =
                  snapShotToObject(snapshot.data).childhLTPcurrentPage;
              if (_hLTPpageController.hasClients) {
                _hLTPpageController.jumpToPage(
                    snapShotToObject(snapshot.data).childhLTPcurrentPage);
              }
            }
            debugPrint("hookuppage ${info.visibleFraction} of my widget is visible");
          },
          child: new PageView(
            controller: _hLTPpageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: onhLTPPageChange,
            children: <Widget>[
              new LikeTopPicksPageHolder(),
              new HookUp(),
            ],
          ),
        );
      },
    );*/
    /*return StreamBuilder(
      stream: widget.switchChangedBLoC.stream_counter,
      builder: (context, snapshot) {
        return new PageView(
          controller: PageController(
              initialPage:
                  snapShotToObject(snapshot.data).childhLTPcurrentPage),
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: onhLTPPageChange,
          children: <Widget>[
            new LikeTopPicksPageHolder(),
            new HookUp(),
          ],
        );
      },
    );*/
    /*return StreamBuilder(
      stream: widget.switchChangedBLoC.stream_counter,
      builder: (context, snapshot) {

       // return Text('${snapShotToObject(snapshot.data).childhLTPcurrentPage}');
       switch (snapShotToObject(snapshot.data).childhLTPcurrentPage) {
          case 0:

            return new PageView(
              controller: new PageController(initialPage: 0
                  //snapShotToObject(snapshot.data).childhLTPcurrentPage
                  ),
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: onhLTPPageChange,
              children: <Widget>[
                new HookUp(),
                new LikeTopPicksPageHolder(),
              ],
            );
          default:
            return new PageView(
              controller: new PageController(initialPage: 1
                  //snapShotToObject(snapshot.data).childhLTPcurrentPage
                  ),
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: onhLTPPageChange,
              children: <Widget>[
                new LikeTopPicksPageHolder(),
                new HookUp(),
              ],
            );
        }
      },
    );*/
    /* return PageView(
        controller: _hLTPpageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: onhLTPPageChange,
        children: <Widget>[
          new LikeTopPicksPageHolder(),
          new HookUp(),
        ],
      );*/
    //);
    /* widget.switchChangedBLoC.stream_counter.listen((value) {
      LandingPageBlocResp landingPageBlocResp = value;
      print(
          'Value from controller ISS: ${landingPageBlocResp.childhLTPcurrentPage}');
      if (_hLTPpageController.hasClients) {
        print(
            'landingPageBlocResp.childhLTPcurrentPage.toDouble()=${landingPageBlocResp.childhLTPcurrentPage.toDouble()}');
        _hLTPpageController
            .jumpTo(landingPageBlocResp.childhLTPcurrentPage.toDouble());
      } else {
        print('_hLTPpageController has no clients');
      }
    });*/

    /*return StreamBuilder(
      stream: widget.switchChangedBLoC.stream_counter,
      builder: (context, snapshot) {

        if (_hLTPpageController.hasClients) {
          _hLTPpageController.jumpTo(
              snapShotToObject(snapshot.data).childhLTPcurrentPage.toDouble());
        }
        */ /* return SizedBox(
            height: 0,
            width: 0,
          );
        });*/
    return PageView(
      controller: _hLTPpageController,
      physics: NeverScrollableScrollPhysics(),
      onPageChanged: onhLTPPageChange,
      children: <Widget>[
        new LikeTopPicksPageHolder(),
        new HookUp(
          navigationDataBLoC_UserprofilesChanged:
              widget.navigationDataBLoC_UserprofilesChanged,
          onInfoClickedNavigationDataBLoC:
              widget.onInfoClickedNavigationDataBLoC,
          showDraggableCards_NavigationDataBLoC:
              widget.showDraggableCards_NavigationDataBLoC,
          isDraggableCards_Laid_Out_NavigationDataBLoC:
              widget.isDraggableCards_Laid_Out_NavigationDataBLoC,
          current_PageViewPosition_NavigationDataBLoC:
              widget.current_PageViewPosition_NavigationDataBLoC,
          hookuppageBodyDraggableCards_NavigationDataBLoC:
              widget.hookuppageBodyDraggableCards_NavigationDataBLoC,
        ),
      ],
    );
    /*},
    );*/
  }

  void onhLTPPageChangeWoState(int value) {
    if (_hLTPpageController.hasClients) {
      _hLTPpageController.jumpToPage(value);
    }
  }

  void onhLTPPageChange(int value) {
    setState(() {
      _hLTPcurrentPage = value;
      if (_hLTPpageController.hasClients) {
        _hLTPpageController.jumpToPage(value);
      }
    });
  }

  @override
  void dispose() {
    _hLTPpageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  LandingPageBlocResp snapShotToObject(dynamic dynamicSnapshot) {
    LandingPageBlocResp landingPageBlocResp = dynamicSnapshot;
    if (landingPageBlocResp != null) {
      print('hookuppage snapShotToObject != null');
      /*if (landingPageBlocResp.isSwitched == null) {
        landingPageBlocResp.isSwitched = false;
      }*/
    } else if (landingPageBlocResp == null) {
      print('hookuppage snapShotToObject == null');
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
}
