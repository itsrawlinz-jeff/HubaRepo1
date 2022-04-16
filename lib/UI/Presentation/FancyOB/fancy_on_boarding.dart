library fancy_on_boarding;

import 'dart:async';
/*import 'package:fancy_on_boarding/src/page_dragger.dart';
import 'package:fancy_on_boarding/src/page_reveal.dart';
import 'package:fancy_on_boarding/src/page_model.dart';
import 'package:fancy_on_boarding/src/pager_indicator.dart';
import 'package:fancy_on_boarding/src/pages.dart';*/
import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleBLoC.dart';
import 'package:dating_app/Bloc/Streams/RegistrationPage/PageDraggerBLoC.dart';
import 'package:dating_app/UI/Presentation/FancyOB/page_dragger.dart';
import 'package:dating_app/UI/Presentation/FancyOB/page_model.dart';
import 'package:dating_app/UI/Presentation/FancyOB/page_reveal.dart';
import 'package:dating_app/UI/Presentation/FancyOB/pager_indicator.dart';
import 'package:dating_app/UI/Presentation/FancyOB/pages.dart';
import 'package:flutter/material.dart';

class FancyOnBoarding extends StatefulWidget {
  final List<PageModel> pageList;
  final VoidCallback onDoneButtonPressed;
  final VoidCallback onSkipButtonPressed;
  final String doneButtonText;
  final String skipButtonText;
  final bool showSkipButton;
  KeyBoardVisibleBLoC keyBoardVisibleBLoC;
  PageDraggerBLoC pageDraggerBLoC;

  FancyOnBoarding({
    @required this.pageList,
    @required this.onDoneButtonPressed,
    this.onSkipButtonPressed,
    this.doneButtonText = "Done",
    this.skipButtonText = "Skip",
    this.showSkipButton = true,
    this.keyBoardVisibleBLoC,
    this.pageDraggerBLoC,
  }) : assert(pageList.length != 0 && onDoneButtonPressed != null);

  @override
  _FancyOnBoardingState createState() => _FancyOnBoardingState();
}

class _FancyOnBoardingState extends State<FancyOnBoarding>
    with TickerProviderStateMixin {
  StreamController<SlideUpdate> slideUpdateStream;
  AnimatedPageDragger animatedPageDragger;
  List<PageModel> pageList;
  int activeIndex = 0;
  int nextPageIndex = 0;
  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0.0;

  @override
  void initState() {
    super.initState();
    this.pageList = widget.pageList;
    this.slideUpdateStream = StreamController<SlideUpdate>();
    _listenSlideUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Page(
          model: pageList[activeIndex],
          percentVisible: 1.0,
        ),
        PageReveal(
          revealPercent: slidePercent,
          child: Page(
            model: pageList[nextPageIndex],
            percentVisible: slidePercent,
          ),
        ),
        StreamBuilder(
          stream: widget.keyBoardVisibleBLoC.stream_counter,
          initialData: false,
          builder: (context, snapshot) {
            return Visibility(
              visible: !snapshot.data,
              child: PagerIndicator(
                viewModel: PagerIndicatorViewModel(
                    pageList, activeIndex, slideDirection, slidePercent, null),
              ),
            );
          },
        ),
        StreamBuilder(
          stream: widget.pageDraggerBLoC.stream_counter,
          initialData: true,
          builder: (context, snapshot) {
            if (snapshot.data) {
              return PageDragger(
                pageLength: pageList.length - 1,
                currentIndex: activeIndex,
                canDragLeftToRight: activeIndex > 0,
                canDragRightToLeft: activeIndex < pageList.length - 1,
                slideUpdateStream: this.slideUpdateStream,
              );
            } else {
              return Visibility(
                visible: false,child: Container(),
              );
            }
          },
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: Opacity(
            opacity: _getOpacity(),
            child: FlatButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              color: const Color(0x88FFFFFF),
              child: Text(
                widget.doneButtonText,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w800),
              ),
              onPressed:
                  _getOpacity() == 1.0 ? widget.onDoneButtonPressed : () {},
            ),
          ),
        ),
        widget.showSkipButton
            ? Positioned(
                top: MediaQuery.of(context).padding.top,
                right: 0,
                child: FlatButton(
                  child: Text(
                    widget.skipButtonText,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800),
                  ),
                  onPressed: widget.onSkipButtonPressed,
                ),
              )
            : Offstage()
      ],
    );
  }

  _listenSlideUpdate() {
    slideUpdateStream.stream.listen((SlideUpdate event) {
      setState(() {
        if (event.updateType == UpdateType.dragging) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

          if (slideDirection == SlideDirection.leftToRight) {
            nextPageIndex = activeIndex - 1;
          } else if (slideDirection == SlideDirection.rightToLeft) {
            nextPageIndex = activeIndex + 1;
          } else {
            nextPageIndex = activeIndex;
          }
        } else if (event.updateType == UpdateType.doneDragging) {
          if (slidePercent > 0.5) {
            animatedPageDragger = AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.open,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );
          } else {
            animatedPageDragger = AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.close,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );
            nextPageIndex = activeIndex;
          }

          animatedPageDragger.run();
        } else if (event.updateType == UpdateType.animating) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;
        } else if (event.updateType == UpdateType.doneAnimating) {
          activeIndex = nextPageIndex;

          slideDirection = SlideDirection.none;
          slidePercent = 0.0;

          animatedPageDragger.dispose();
        }
      });
    });
  }

  double _getOpacity() {
    if (pageList.length - 2 == activeIndex &&
        slideDirection == SlideDirection.rightToLeft) return slidePercent;
    if (pageList.length - 1 == activeIndex &&
        slideDirection == SlideDirection.leftToRight) return 1 - slidePercent;
    if (pageList.length - 1 == activeIndex) return 1.0;
    return 0.0;
  }

  @override
  void dispose() {
    slideUpdateStream?.close();
    super.dispose();
  }
}
