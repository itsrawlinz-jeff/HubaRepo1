import 'dart:math';

import 'package:dating_app/Activities/ProfileInfo.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/CustomLayouts/Overlays/ProfileOverlay.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/UI/Presentation/dialogs/AddNewHobbieDialog.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:fluttery/layout.dart';
import 'package:dating_app/scr/matches.dart';
import 'package:after_layout/after_layout.dart';
import 'package:rect_getter/rect_getter.dart';

enum SlideDirection { left, right, up }
enum SlideRegion { inNopeRegion, inLikeRegion, inSuperLikeRegion }

class DraggableCard extends StatefulWidget {
  final Widget card;
  final bool isDraggable;
  final SlideDirection slideTo;
  final SlideRegion slideRegion;
  final Function(double distance) onSlideUpdate;
  final Function(SlideRegion slideRegion) onSlideRegionUpdate;
  final Function(SlideDirection direction) onSlideOutComplete;
  final NavigationDataBLoC onInfoClickedNavigationDataBLoC;
  final NavigationDataBLoC showDraggableCards_NavigationDataBLoC;
  final NavigationDataBLoC isDraggableCards_Laid_Out_NavigationDataBLoC;
  final bool isFrontCard;

  DraggableCard({
    this.card,
    this.isDraggable = true,
    this.onSlideUpdate,
    this.onSlideOutComplete,
    this.slideTo,
    this.slideRegion,
    this.onSlideRegionUpdate,
    this.onInfoClickedNavigationDataBLoC,
    this.showDraggableCards_NavigationDataBLoC,
    this.isDraggableCards_Laid_Out_NavigationDataBLoC,
    this.isFrontCard,
  });
  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with TickerProviderStateMixin, AfterLayoutMixin<DraggableCard>, RouteAware {
  Decision decision;
  GlobalKey profileCardKey = new GlobalKey(debugLabel: 'profile_card_key');
  Offset cardOffset = Offset(0.0, 0.0);
  Offset dragStart;
  Offset dragPosition;
  Offset slideBackStart;
  SlideDirection slideOutDirection;
  SlideRegion slideRegion;
  AnimationController slideBackAnimation;
  Tween<Offset> slideOutTween;
  AnimationController slideOutAnimation;
  BuildContext anchoredOverlayBuildContext;
  bool showDragabbleCards = true;
  //bool showDragabbleCards = false;
  bool afterFirstLayout_ran_isDraggableCards_Laid_Out = false;

  @override
  void initState() {
    super.initState();

    slideBackAnimation = new AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )
      ..addListener(() => setState(() {
            cardOffset = Offset.lerp(
              slideBackStart,
              Offset(0.0, 0.0),
              Curves.elasticOut.transform(slideBackAnimation.value),
            );

            if (null != widget.onSlideUpdate) {
              widget.onSlideUpdate(cardOffset.distance);
            }

            if (null != widget.onSlideRegionUpdate) {
              widget.onSlideRegionUpdate(slideRegion);
            }
          }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            slideBackStart = null;
            dragPosition = null;
          });
        }
      });

    slideOutAnimation = new AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          cardOffset = slideOutTween.evaluate(slideOutAnimation);

          if (null != widget.onSlideUpdate) {
            widget.onSlideUpdate(cardOffset.distance);
          }

          if (null != widget.onSlideRegionUpdate) {
            widget.onSlideRegionUpdate(slideRegion);
          }
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            dragPosition = null;
            slideOutTween = null;

            if (widget.onSlideOutComplete != null) {
              widget.onSlideOutComplete(slideOutDirection);
            }
          });
        }
      });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    String TAG = '_DraggableCardState:afterFirstLayout:';
    print(TAG);
    //print(TAG);
    setUpListeners();
    refresh_isDraggableCards_Laid_Out_NavigationDataBLoC(true);
  }

  //STATE CHANGES
  //REPORT BACK DRAGGABLE CARDS ARE LAID OUT
  refresh_isDraggableCards_Laid_Out_NavigationDataBLoC(bool isShow) {
    String TAG =
        '_DraggableCardState:refresh_isDraggableCards_Laid_Out_NavigationDataBLoC:';
    NavigationData navigationData = NavigationData();
    navigationData.isShow = isShow;
    if (!afterFirstLayout_ran_isDraggableCards_Laid_Out && widget.isFrontCard) {
      print(TAG);
      refresh_W_Data_NavigationDataBLoC(
        widget.isDraggableCards_Laid_Out_NavigationDataBLoC,
        navigationData,
      );
    } else {
      print(TAG + ' !!!!!!!!');
    }
    afterFirstLayout_ran_isDraggableCards_Laid_Out = true;
  }
  //END OF REPORT BACK DRAGGABLE CARDS ARE LAID OUT
  //END OF STATE CHANGES

  setUpListeners() {
    String TAG = '_DraggableCardState_O setUpListeners:';
    print(TAG);
    /*widget.onInfoClickedNavigationDataBLoC.stream_counter.listen((value) async {
      print(TAG + ' HERE1');
      NavigationData navigationData = value;
      if (navigationData != null &&
          navigationData.isSelected &&
          anchoredOverlayBuildContext != null) {
        print(TAG + ' HERE2');
        /*Navigator.of(anchoredOverlayBuildContext).push(
          MaterialPageRoute(
            builder: (context) {
              return ProfileInfo();
            },
          ),
        );*/
      }
    });*/
    widget.showDraggableCards_NavigationDataBLoC.stream_counter
        .listen((value) async {
      NavigationData navigationData = value;
      if (navigationData != null && navigationData.isShow != null) {
        if (!navigationData.isShow) {
          print('showDraggableCards_NavigationDataBLoC hide1');
          setState(() {
            showDragabbleCards = false;
          });
        } else {
          print('showDraggableCards_NavigationDataBLoC show1');
          setState(() {
            showDragabbleCards = true;
            /*profileCardKey = new GlobalKey(debugLabel: 'profile_card_key');
            cardOffset= _chooseRandomDragStart();*/
            /*cardOffset = Offset.lerp(
              slideBackStart,
              Offset(0.0, 0.0),
              Curves.elasticOut.transform(slideBackAnimation.value),
            );

            if (null != widget.onSlideUpdate) {
              widget.onSlideUpdate(cardOffset.distance);
            }

            if (null != widget.onSlideRegionUpdate) {
              widget.onSlideRegionUpdate(slideRegion);
            }
            showDragabbleCards = true;*/
          });
        }
      } else {
        print('showDraggableCards_NavigationDataBLoC show2');
        setState(() {
          showDragabbleCards = true;
        });
      }
    });
  }

  @override
  void didUpdateWidget(DraggableCard oldWidget) {
    String TAG = 'didUpdateWidget:';
    super.didUpdateWidget(oldWidget);
    print(TAG);
    if (widget.showDraggableCards_NavigationDataBLoC !=
        oldWidget.showDraggableCards_NavigationDataBLoC) {
      print(
          'didUpdateWidget ACTIVE widget.showDraggableCards_NavigationDataBLoC!=');
    }
    if (widget.card.key != oldWidget.card.key) {
      print(TAG + ' HERE1');
      cardOffset = Offset(0.0, 0.0);
    }

    if (oldWidget.slideTo == null && widget.slideTo != null) {
      print(TAG + ' HERE2');
      switch (widget.slideTo) {
        case SlideDirection.left:
          print(TAG + ' HERE3');
          _slideLeft();
          break;
        case SlideDirection.right:
          print(TAG + ' HERE4');
          _slideRight();
          break;
        case SlideDirection.up:
          print(TAG + ' HERE5');
          _slideUp();
          break;
      }
    }

//    if (oldWidget.slideRegion == null && widget.slideRegion != null) {
//      switch (widget.slideRegion) {
//        case SlideDirection.left:
//          _slideLeft();
//          break;
//        case SlideDirection.right:
//          _slideRight();
//          break;
//        case SlideDirection.up:
//          _slideUp();
//          break;
//      }
//    }
  }

  @override
  void dispose() {
    slideBackAnimation.dispose();
    super.dispose();
  }

  Offset _chooseRandomDragStart() {
    print('AT _chooseRandomDragStart');
    final cardContext = profileCardKey.currentContext;
    final cardTopLeft = (cardContext.findRenderObject() as RenderBox)
        .localToGlobal(Offset(0.0, 0.0));
    final dragStartY = cardContext.size.height *
            (new Random().nextDouble() < 0.5 ? 0.25 : 0.75) +
        cardTopLeft.dy;
    return new Offset(cardContext.size.width / 2 + cardTopLeft.dx, dragStartY);
  }

  void _slideLeft() async {
    print('AT _slideLeft');
    await Future.delayed(Duration(milliseconds: 1)).then((_) {
      final screenWidth = context.size.width;
      dragStart = _chooseRandomDragStart();
      slideOutTween = new Tween(
          begin: Offset(0.0, 0.0), end: new Offset(-2 * screenWidth, 0.0));
      slideOutAnimation.forward(from: 0.0);
    });
  }

  void _slideRight() async {
    print('AT _slideRight');
    await Future.delayed(Duration(milliseconds: 1)).then((_) {
      final screenWidth = context.size.width;
      dragStart = _chooseRandomDragStart();
      slideOutTween = new Tween(
          begin: Offset(0.0, 0.0), end: new Offset(2 * screenWidth, 0.0));
      slideOutAnimation.forward(from: 0.0);
    });
  }

  void _slideUp() async {
    print('AT _slideUp');
    await Future.delayed(Duration(milliseconds: 1)).then((_) {
      final screenHeight = context.size.height;
      dragStart = _chooseRandomDragStart();
      slideOutTween = new Tween(
          begin: Offset(0.0, 0.0), end: new Offset(0.0, -2 * screenHeight));
      slideOutAnimation.forward(from: 0.0);
    });
  }

  void _onPanStart(DragStartDetails details) {
    print('AT _onPanStart');
    dragStart = details.globalPosition;

    if (slideBackAnimation.isAnimating) {
      slideBackAnimation.stop(canceled: true);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    print('AT _onPanUpdate');
    final isInLeftRegion = (cardOffset.dx / context.size.width) < -0.45;
    final isInRightRegion = (cardOffset.dx / context.size.width) > 0.45;
    final isInTopRegion = (cardOffset.dy / context.size.height) < -0.40;

    setState(() {
      if (isInLeftRegion || isInRightRegion) {
        slideRegion = isInLeftRegion
            ? SlideRegion.inNopeRegion
            : SlideRegion.inLikeRegion;
      } else if (isInTopRegion) {
        slideRegion = SlideRegion.inSuperLikeRegion;
      } else {
        slideRegion = null;
      }

      dragPosition = details.globalPosition;
      cardOffset = dragPosition - dragStart;

      if (null != widget.onSlideUpdate) {
        widget.onSlideUpdate(cardOffset.distance);
      }

      if (null != widget.onSlideRegionUpdate) {
        widget.onSlideRegionUpdate(slideRegion);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    String TAG = 'AT _onPanEnd:';
    print(TAG);
    final dragVector = cardOffset / cardOffset.distance;

    final isInLeftRegion = (cardOffset.dx / context.size.width) < -0.45;
    final isInRightRegion = (cardOffset.dx / context.size.width) > 0.45;
    final isInTopRegion = (cardOffset.dy / context.size.height) < -0.40;

    setState(() {
      if (isInLeftRegion || isInRightRegion) {
        slideOutTween = new Tween(
            begin: cardOffset, end: dragVector * (2 * context.size.width));
        slideOutAnimation.forward(from: 0.0);

        slideOutDirection =
            isInLeftRegion ? SlideDirection.left : SlideDirection.right;
      } else if (isInTopRegion) {
        slideOutTween = new Tween(
            begin: cardOffset, end: dragVector * (2 * context.size.height));
        slideOutAnimation.forward(from: 0.0);

        slideOutDirection = SlideDirection.up;
      } else {
        print(TAG + ' NOT IN ANY REGION');
        slideBackStart = cardOffset;
        slideBackAnimation.forward(from: 0.0);
      }

      slideRegion = null;
      if (null != widget.onSlideRegionUpdate) {
        widget.onSlideRegionUpdate(slideRegion);
      }
    });
  }

  double _rotation(Rect dragBounds) {
    if (dragStart != null) {
      final rotationCornerMultiplier =
          dragStart.dy >= dragBounds.top + (dragBounds.height / 2) ? -1 : 1;
      return (pi / 8) *
          (cardOffset.dx / dragBounds.width) *
          rotationCornerMultiplier;
    } else {
      return 0.0;
    }
  }

  Offset _rotationOrigin(Rect dragBounds) {
    if (dragStart != null) {
      return dragStart - dragBounds.topLeft;
    } else {
      return Offset(0.0, 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    String TAG = '_DraggableCardState:';

    return draggableCard(true);
    /* StreamBuilder(
      stream: widget.showDraggableCards_NavigationDataBLoC.stream_counter,
      builder: (context, snapshot) {
        print('rebuild draggable');
        NavigationData navigationData = snapshot.data;
        if (navigationData != null && navigationData.isShow != null) {
          if (!navigationData.isShow) {
            print('rebuild draggable hide1');
            return draggableCard(false);
          } else {
            print('rebuild draggable show1');
            return draggableCard(true);
          }
        } else {
          print('rebuild draggable show2');
          return draggableCard(true);
        }
      },
    );*/

    /* return new Visibility(
    visible: true,
    child: AnchoredOverlay(
    showOverlay: true,
    child: new Center(),
    overlayBuilder:
    (BuildContext context, Rect anchorBounds, Offset anchor) {
    anchoredOverlayBuildContext = context;
    return CenterAbout(
    position: anchor,
    child: new Transform(
    transform: new Matrix4.translationValues(
    cardOffset.dx, cardOffset.dy, 0.0)
    ..rotateZ(_rotation(anchorBounds)),
    origin: _rotationOrigin(anchorBounds),
    child: new Container(
    key: profileCardKey,
    width: anchorBounds.width,
    height: anchorBounds.height,
    padding:  EdgeInsets.all(16.0),
    child: new GestureDetector(
    onPanStart: _onPanStart,
    onPanUpdate: _onPanUpdate,
    onPanEnd: _onPanEnd,
    child: widget.card,
    ),
    ),
    ),
    );
    },
    ),
    );*/
    /*return Container(
      decoration: BoxDecoration(
        color: DatingAppTheme.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
            topRight: Radius.circular(8.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: DatingAppTheme.grey.withOpacity(0.2),
              offset: Offset(1.1, 1.1),
              blurRadius: 10.0),
        ],
      ),
      child: Builder(
        builder: (BuildContext context) {

          return GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: widget.card,
          );/*FittedBox(
            child: new RectGetter(
              key: globalKey_Container,
              child: Transform(
                transform: new Matrix4.translationValues(
                    cardOffset.dx, cardOffset.dy, 0.0)
                  ..rotateZ(_rotation(
                      RectGetter.getRectFromKey(globalKey_Container))),
                origin: _rotationOrigin(
                    RectGetter.getRectFromKey(globalKey_Container)),
                child: new Container(
                  key: profileCardKey,
                  width: RectGetter.getRectFromKey(globalKey_Container).width,
                  height: RectGetter.getRectFromKey(globalKey_Container).height,
                  padding:  EdgeInsets.all(16.0),
                  child: new GestureDetector(
                    onPanStart: _onPanStart,
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    child: widget.card,
                  ),
                ),
              ),
            ),
          );*/
        },
      ),
    );*/

    /*new AnchoredOverlay(
      showOverlay: true,
      child: new Center(),
      overlayBuilder: (BuildContext context, Rect anchorBounds, Offset anchor) {
        anchoredOverlayBuildContext = context;
        return CenterAbout(
          position: anchor,
          child: new Transform(
            transform:
                new Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0)
                  ..rotateZ(_rotation(anchorBounds)),
            origin: _rotationOrigin(anchorBounds),
            child: new Container(
              key: profileCardKey,
              width: anchorBounds.width,
              height: anchorBounds.height,
              padding:  EdgeInsets.all(16.0),
              child: new GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: widget.card,
              ),
            ),
          ),
        );
      },
    );*/
  }

  Widget draggableCard(bool isVisible) {
    return AnchoredOverlay(

      showOverlay: true, //showDragabbleCards,
      child: new Center(),
      overlayBuilder: (BuildContext context, Rect anchorBounds, Offset anchor) {
        return CenterAbout(
          position: anchor,
          child: new Transform(
            transform:
                new Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0)
                  ..rotateZ(_rotation(anchorBounds)),
            origin: _rotationOrigin(anchorBounds),
            child: new Container(
              key: profileCardKey,
              width: anchorBounds.width,
              height: anchorBounds.height,
              padding: EdgeInsets.all(16.0),
              child:
                  /*Material(child: InkWell(
                  child: Text('im new'),
                  onTap: () {
                    NavigationData navigationData = NavigationData();
                    navigationData.isSelected = true;
                    refresh_W_Data_NavigationDataBLoC(
                        widget.onInfoClickedNavigationDataBLoC, navigationData);
                  },
                ),),*/
                  Visibility(
                visible: showDragabbleCards,
                //opacity: showDragabbleCards ? 1.0 : 0.0,
                child: GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: widget.card,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/*class _Draggable1CardState extends State<DraggableCard>
    with TickerProviderStateMixin<DraggableCard> {
  Decision decision;
  GlobalKey profileCardKey = new GlobalKey(debugLabel: "profile_card_key");
  Offset cardOffset =  Offset(0.0, 0.0);
  Offset dragStart;
  Offset dragPosition;
  Offset slideBackStart;
  SlideDirection slideOutDirection;
  AnimationController slideBackAnimation;
  Tween<Offset> slideOutTween;
  AnimationController slideOutAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    slideBackAnimation = new AnimationController(
        duration:  Duration(milliseconds: 1000), vsync: this)
      ..addListener(() => setState(() {
            cardOffset = Offset.lerp(
              slideBackStart,
               Offset(0.0, 0.0),
              Curves.elasticOut.transform(slideBackAnimation.value),
            );

            if (null != widget.onSlideUpdate) {
              widget.onSlideUpdate(cardOffset.distance);
            }
          }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            slideBackStart = null;
            dragPosition = null;
          });
        }
      });

    slideOutAnimation = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {
          cardOffset = slideOutTween.evaluate(slideOutAnimation);

          if (null != widget.onSlideUpdate) {
            widget.onSlideUpdate(cardOffset.distance);
          }
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            dragPosition = null;
            slideOutTween = null;
            //cardOffset =  Offset(0.0, 0.0);

            //widget.matchEngine.resetMatch();
            if (widget.onSlideOutComplete != null) {
              widget.onSlideOutComplete(slideOutDirection);
            }
          });
        }
      });

    //widget.matchEngine.addListener(_onMatchChange);
    //decision = widget.matchEngine.decision;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //widget.matchEngine.removeListener(_onMatchChange);
    slideBackAnimation.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DraggableCard oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
//    if (widget.matchEngine != oldWidget.matchEngine) {
//      oldWidget.matchEngine.removeListener(_onMatchChange);
//      widget.matchEngine.addListener(_onMatchChange);
//    }

    if (widget.card.key != oldWidget.card.key) {
      cardOffset =  Offset(0.0, 0.0);
    }

    if (oldWidget.slideTo == null && widget.slideTo != null) {
      switch (widget.slideTo) {
        case SlideDirection.left:
          _slideLeft();
          break;
        case SlideDirection.right:
          _slideRight();
          break;
        case SlideDirection.up:
          _slideUp();
          break;
      }
    }
  }

  Offset _chooseRandomDragStart() {
    final cardContext = profileCardKey.currentContext;
    final cardToLeft = (cardContext.findRenderObject() as RenderBox)
        .localToGlobal( Offset(0.0, 0.0));
    final dragStartY = cardContext.size.height *
            (new Random().nextDouble() < 0.5 ? 0.25 : 0.75) +
        cardToLeft.dy;
    return new Offset(cardContext.size.width / 2 + cardToLeft.dx, dragStartY);
  }

  void _slideLeft() async {
    await Future.delayed(Duration(milliseconds: 500)).then((_) {
      final screenWidth = context.size.width;
      dragStart = _chooseRandomDragStart();
      slideOutTween = new Tween(
          begin:  Offset(0.0, 0.0),
          end: new Offset(-2 * screenWidth, 0.0));
      slideOutAnimation.forward(from: 0.0);
    });
  }

  void _slideRight() async {
    await Future.delayed(Duration(milliseconds: 500)).then((_) {
      final screenWidth = context.size.width;
      dragStart = _chooseRandomDragStart();
      slideOutTween = new Tween(
          begin:  Offset(0.0, 0.0), end: new Offset(2 * screenWidth, 0.0));
      slideOutAnimation.forward(from: 0.0);
    });
  }

  void _slideUp() async {
    await Future.delayed(Duration(milliseconds: 500)).then((_) {
      final screenHeight = context.size.height;
      dragStart = _chooseRandomDragStart();
      slideOutTween = new Tween(
          begin:  Offset(0.0, 0.0),
          end: new Offset(0.0, -2 * screenHeight));
      slideOutAnimation.forward(from: 0.0);
    });
  }

  void _onPanStart(DragStartDetails details) {
    dragStart = details.globalPosition;
    if (slideBackAnimation.isAnimating) {
      slideBackAnimation.stop(canceled: true);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      dragPosition = details.globalPosition;
      cardOffset = dragPosition - dragStart;

      if (null != widget.onSlideUpdate) {
        widget.onSlideUpdate(cardOffset.distance);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final dragVector = cardOffset / cardOffset.distance;
    final isInLeftRegion = (cardOffset.dx / context.size.width) < 0.45;
    final isInRightRegion = (cardOffset.dx / context.size.width) > 0.45;
    final isInTopRegion = (cardOffset.dy / context.size.height) < -0.40;

    setState(() {
      if (isInLeftRegion || isInRightRegion) {
        slideOutTween = new Tween(
            begin: cardOffset, end: dragVector * (2 * context.size.width));
        slideOutAnimation.forward(from: 0.0);

        slideOutDirection =
            isInLeftRegion ? SlideDirection.left : SlideDirection.right;
      } else if (isInTopRegion) {
        slideOutTween = new Tween(
            begin: cardOffset, end: dragVector * (2 * context.size.height));
        slideOutAnimation.forward(from: 0.0);
        slideOutDirection = SlideDirection.up;
      } else {
        slideBackStart = cardOffset;
        slideBackAnimation.forward(from: 0.0);
      }
    });
  }

  //handles the card rotation
  double _rotation(Rect dragBounds) {
    if (dragStart != null) {
      final rotationCornerMultiplier =
          dragStart.dy >= dragBounds.top + (dragBounds.height / 2) ? -1 : 1;
      return (pi / 8) *
          (cardOffset.dx / dragBounds.width) *
          rotationCornerMultiplier;
    } else {
      return 0.0;
    }
  }

  //handle the card rotation about a point
  Offset _rotationOrigin(Rect dragBounds) {
    if (dragStart != null) {
      return dragStart - dragBounds.topLeft;
    } else {
      return  Offset(0.0, 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildCardStack();
  }

  //build card stack
  Widget _buildCardStack() {
    return new AnchoredOverlay(
      showOverlay: true,
      child: new Container(),
      overlayBuilder: (context, anchorBounds, anchor) {
        return CenterAbout(
          position: anchor,
          child: new Transform(
            transform:
                new Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0)
                  ..rotateZ(_rotation(anchorBounds)),
            origin: _rotationOrigin(anchorBounds),
            child: new Container(
              key: profileCardKey,
              width: anchorBounds.width,
              height: anchorBounds.height,
              padding:  EdgeInsets.all(16.0),
              child: new GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: widget.card),
            ),
          ),
        );
      },
    );
  }
}*/
