import 'package:dating_app/Bloc/Streams/PageChanged/OnBoardingPageBLoC.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:provider/provider.dart';

class PageIndicator extends StatefulWidget {
  int currentIndex;
  int pageCount;
  OnBoardingPageBLoC onBoardingPageBLoC;

  PageIndicator(
      {Key key, this.currentIndex, this.pageCount, this.onBoardingPageBLoC})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PageIndicatorState();
  }
}

class _PageIndicatorState extends State<PageIndicator> {
  // ScrollController _scrollController = new ScrollController();
  //PageController _scrollController = new PageController(initialPage: 0);
  ItemScrollController _scrollController = ItemScrollController();

  /* _indicator(bool isActive) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          height: 4.0,
          decoration: BoxDecoration(
              color: isActive ? Colors.white : Color(0xFF3E4750),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 2.0)
              ]),
        ),
      ),
    );
  }*/
  _indicatoro(bool isActive) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        height: 4.0,
        width: 4.0,
        decoration: BoxDecoration(
            color: isActive ? Colors.white : Color(0xFFF8BBD0),
            //Color(0xFF3E4750),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 2.0)
            ]),
      ),
    );
  }

  _indicator(bool isActive,DatingAppThemeChanger datingAppThemeChanger) {
    return isActive
        ? AnimatedContainer(
            duration: Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(horizontal: 3.3),
            height: isActive ? 10 : 4,
            width: isActive ? 10 : 4,
            decoration: BoxDecoration(
              color: isActive ? Colors.transparent : datingAppThemeChanger.selectedThemeData.cl_pgind_Sel,//Color(0xFFF8BBD0),
              border: isActive
                  ? Border.all(
                      color: datingAppThemeChanger.selectedThemeData.cl_pgind_UnSel,//Colors.white,
                      width: 2.0,
                    )
                  : Border.all(
                      color: Colors.transparent,
                      width: 1,
                    ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          )
        : Center(
            child: Wrap(children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  height: 4.0,
                  width: 4.0,
                  decoration: BoxDecoration(
                      //color: isActive ? Colors.white : Color(0xFFF8BBD0),
                      color: isActive ? Colors.transparent : datingAppThemeChanger.selectedThemeData.cl_pgind_Sel,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0.0, 2.0),
                            blurRadius: 2.0)
                      ]),
                ),
              ),
            ]),
          );
  }

/*  _buildPageIndicators() {
    List<Widget> indicatorList = [];
    for (int i = 0; i < widget.pageCount; i++) {
      indicatorList
          .add(i == widget.currentIndex ? _indicator(true) : _indicator(false));
    }
    return indicatorList;
  }*/

  _buildPageIndicator(int i,DatingAppThemeChanger datingAppThemeChanger,) {
    Widget rtnWidget =
        i == widget.currentIndex ? _indicator(true,datingAppThemeChanger) : _indicator(false,datingAppThemeChanger);
    return rtnWidget;
  }

  /*@override
  Widget build(BuildContext context) {
    return new Row(
      children: _buildPageIndicators(),
    );
  }*/

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuildFinished());
  }

  /* @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _scrollController,
      physics: NeverScrollableScrollPhysics(),
      children: _buildPageIndicators(),
    );
  }*/
  /* @override
  Widget build(BuildContext context) {
    return new ListView(
      controller: _scrollController,
      //reverse: true,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: _buildPageIndicators(),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Consumer<DatingAppThemeChanger>(
        builder: (context, datingAppThemeChanger, child) {
          return ScrollablePositionedList.builder(
      itemScrollController: _scrollController,
      itemCount: widget.pageCount,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return _buildPageIndicator(index, datingAppThemeChanger,);
      },

      /*controller: _scrollController,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: _buildPageIndicators(),*/
    );},);
  }

  afterBuildFinished() {
    setScrolledListener();
    // setScrollControllerListener();
  }

  setScrolledListener() {
    print('afterBuildFinished');
    widget.onBoardingPageBLoC.stream_counter.listen((value) {
      int landingPageBlocResp = value;
      print('landingPageBlocResp ISS: ${landingPageBlocResp}');
      if (_scrollController.isAttached) {
        setState(() {
          _scrollController.scrollTo(
              index: landingPageBlocResp, duration: Duration(seconds: 1));
          //_scrollController.jumpTo(landingPageBlocResp.toDouble());
          /*_scrollController.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );*/
        });
      } else {
        print('_scrollController is not attached');
      }
    });
  }

  /* setScrolledListener() {
    print('afterBuildFinished');
    widget.keyBoardVisibleBLoC.stream_counter.listen((value) {
      int landingPageBlocResp = value;
      print('landingPageBlocResp ISS: ${landingPageBlocResp}');
      if (_scrollController.hasClients) {
        print('_scrollController has  clients');
        print('_scrollController.offset==${_scrollController.offset}');

        print(
            '_scrollController.position.pixels=${_scrollController.position.pixels}');
        print(
            '_scrollController.position.maxScrollExtent=${_scrollController.position.maxScrollExtent}');
        setState(() {
          //_scrollController.jumpTo(landingPageBlocResp.toDouble());
          */ /*_scrollController.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );*/ /*
        });
      } else {
        print('_scrollController has no clients');
      }
    });
  }*/

  /*setScrollControllerListener() {
    print(
        '_scrollController.position.pixels=${_scrollController.position.pixels}');
    print(
        '_scrollController.position.maxScrollExtent=${_scrollController.position.maxScrollExtent}');
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });
  }*/
}
