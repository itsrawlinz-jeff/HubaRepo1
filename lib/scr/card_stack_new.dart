import 'dart:convert';

import 'package:dating_app/Activities/ProfileInfo.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_datematchdecisions_online.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_put_match.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/DateMatchRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/MatchDecisionListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/MatchDecisionRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/matches/DateMatchReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/scr/draggable_card_new.dart';
import 'package:dating_app/scr/matches_new.dart';
import 'package:dating_app/scr/profile_card_new.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';

class CardStack extends StatefulWidget {
  MatchEngine matchEngine;
  NavigationDataBLoC onInfoClickedNavigationDataBLoC;
  NavigationDataBLoC showDraggableCards_NavigationDataBLoC;
  NavigationDataBLoC isDraggableCards_Laid_Out_NavigationDataBLoC;
  BuildContext snackbarBuildContext;

  CardStack({
    Key key,
    this.matchEngine,
    this.onInfoClickedNavigationDataBLoC,
    this.showDraggableCards_NavigationDataBLoC,
    this.isDraggableCards_Laid_Out_NavigationDataBLoC,
    this.snackbarBuildContext,
  });
  @override
  _CardStackState createState() => _CardStackState();
}

class _CardStackState extends State<CardStack>
    with AfterLayoutMixin<CardStack> {
  Key _frontCard;
  DateMatch _currentMatch;
  double _nextCardScale = 0.9;
  SlideRegion slideRegion;

  BuildContext mainBuildContext;
  List<MatchDecisionRespJModel> allMatchDecisionRespJModelList = [];
  LoginRespModel loginRespJModel;

  @override
  void initState() {
    super.initState();

    widget.matchEngine.addListener(_onMatchEngineChange);
    _currentMatch = widget.matchEngine.currentMatch;
    if (_currentMatch != null) {
      _currentMatch.addListener(_onMatchChange);
      _frontCard = new Key(_currentMatch.profile.name);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    String TAG = 'CardStack afterFirstLayout:';
    print(TAG);
    //setUpListeners();
    setUpData(
      context,
      true,
    );
  }

  setUpData(BuildContext context, bool isInitial) async {
    //await fetchRefresh_allMatchDecisionList(context);
  }

  Future<List<MatchDecisionRespJModel>> fetchRefresh_allMatchDecisionList(
      BuildContext context) async {
    loginRespJModel = await getSessionLoginRespModel(context);
    List<MatchDecisionRespJModel> matchDecisionRespJModelList = [];
    MatchDecisionListRespJModel matchDecisionListRespJModel =
        await fetch_datematchdecisions_online_limit(
      context,
      DatingAppStaticParams.default_Max_int,
    );
    if (matchDecisionListRespJModel != null) {
      allMatchDecisionRespJModelList = matchDecisionListRespJModel.results;
      matchDecisionRespJModelList = allMatchDecisionRespJModelList;
    }
    return matchDecisionRespJModelList;
  }

/*  setUpListeners() {
    String TAG = 'CardStack setUpListeners:';
    print(TAG);
    onInfoClickedNavigationDataBLoC.stream_counter.listen((value) async {
      print(TAG+' HERE1');
      NavigationData navigationData = value;
      if (navigationData != null &&
          navigationData.isSelected &&
          mainBuildContext != null) {
        print(TAG+' HERE2');
        Navigator.of(mainBuildContext).push(
          MaterialPageRoute(
            builder: (context) {
              return ProfileInfo();
            },
          ),
        );
      }
    });
  }*/

  @override
  void dispose() {
    if (_currentMatch != null) {
      _currentMatch.removeListener(_onMatchChange);
    }
    widget.matchEngine.removeListener(_onMatchEngineChange);
    super.dispose();
  }

  @override
  void didUpdateWidget(CardStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.matchEngine != oldWidget.matchEngine) {
      oldWidget.matchEngine.removeListener(_onMatchEngineChange);
      widget.matchEngine.addListener(_onMatchEngineChange);
    }
    if (_currentMatch != null) {
      _currentMatch.removeListener(_onMatchChange);
    }
    _currentMatch = widget.matchEngine.currentMatch;
    if (_currentMatch != null) {
      _currentMatch.addListener(_onMatchChange);
    }
  }

  void _onMatchEngineChange() {
    setState(() {
      if (_currentMatch != null) {
        _currentMatch.removeListener(_onMatchChange);
      }
      _currentMatch = widget.matchEngine.currentMatch;
      if (_currentMatch != null) {
        _currentMatch.addListener(_onMatchChange);
      }
      _frontCard = new Key(_currentMatch.profile.name);
    });
  }

  void _onMatchChange() {
    setState(() {
      //match has been changed
    });
  }

/*  Widget _buildFrontCard() {
    return new ProfileCard(
        key: _frontCard,
        profile: widget.matchEngine.currentMatch.profile,
        decision: widget.matchEngine.currentMatch.decision,
        region: slideRegion);
  }*/

  Widget _buildFrontCard() {
    String TAG = '_buildFrontCard:';
    DateMatch currentMatch_dateMatch = widget.matchEngine.currentMatch;
    if (currentMatch_dateMatch != null) {
      return new ProfileCard(
          key: _frontCard,
          profile: currentMatch_dateMatch.profile,
          decision: currentMatch_dateMatch.decision,
          onInfoClickedNavigationDataBLoC:
              widget.onInfoClickedNavigationDataBLoC,
          region: slideRegion);
    } else {
      print(TAG + ' Container');
      return new Container();
    }
  }

/*  Widget _buildBackCard({bool isDraggable: false}) {
    return new Transform(
      transform: new Matrix4.identity()..scale(_nextCardScale, _nextCardScale),
      alignment: Alignment.center,
      child: new ProfileCard(
          profile: widget.matchEngine.nextMatch.profile,
          decision: widget.matchEngine.nextMatch.decision,
          region: slideRegion,
          isDraggable: false),
    );
  }*/
  Widget _buildBackCard({bool isDraggable: false}) {
    String TAG = '_buildBackCard:';

    DateMatch nextMatch_dateMatch = widget.matchEngine.nextMatch;
    if (nextMatch_dateMatch != null) {
      return new Transform(
        transform: new Matrix4.identity()
          ..scale(_nextCardScale, _nextCardScale),
        alignment: Alignment.center,
        child: new ProfileCard(
            profile: nextMatch_dateMatch.profile,
            decision: nextMatch_dateMatch.decision,
            region: slideRegion,
            onInfoClickedNavigationDataBLoC:
                widget.onInfoClickedNavigationDataBLoC,
            isDraggable: false),
      );
    } else {
      print(TAG + ' Container');
      return new Container();
    }
  }

  void _onSlideUpdate(double distance) {
    setState(() {
      // _nextCardScale = 0.9 + (0.1 * (distance / 100.0).clamp(0.0, 0.1));
      _nextCardScale = 0.9 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
    });
  }

  void _onSlideRegion(SlideRegion region) {
    setState(() {
      slideRegion = region;
    });
  }

  void _onSlideOutComplete(SlideDirection direction) {
    String TAG = '_onSlideOutComplete:';
    print(TAG);
    DateMatch currentMatch = widget.matchEngine.currentMatch;
    switch (direction) {
      case SlideDirection.left:
        currentMatch.nope();
        print(TAG + ' nope DECISION==${currentMatch.decision}');
        updateSelection(currentMatch, DatingAppStaticParams.Nope);
        break;
      case SlideDirection.right:
        currentMatch.like();
        print(TAG + ' like DECISION==${currentMatch.decision}');
        updateSelection(currentMatch, DatingAppStaticParams.Like);
        break;
      case SlideDirection.up:
        currentMatch.superLike();
        print(TAG + ' superLike DECISION==${currentMatch.decision}');
        updateSelection(currentMatch, DatingAppStaticParams.Super_Like);
        break;
    }

    widget.matchEngine.cycleMatch();
  }

  updateSelection(DateMatch currentMatch_dateMatch, String selection) async {
    if (currentMatch_dateMatch != null) {
      currentMatch_dateMatch.decision;
      MatchDecisionRespJModel selected_MatchDecisionRespJModel =
          allMatchDecisionRespJModelList.firstWhere(
              (matchDecisionRespJModel) =>
                  matchDecisionRespJModel.name.trim().toLowerCase() ==
                  selection.trim().toLowerCase(),
              orElse: () => null);
      if (selected_MatchDecisionRespJModel != null) {
        DateMatchReqJModel dateMatchReqJModel = DateMatchReqJModel();
        DateTime dateTimeNow = DateTime.now();
        dateMatchReqJModel.createdate =
            getDateFormat_yyyymmdd().format(dateTimeNow);
        dateMatchReqJModel.createdby =
            ((loginRespJModel != null ? loginRespJModel.id : null));
        dateMatchReqJModel.decision = selected_MatchDecisionRespJModel.id;
        dateMatchReqJModel.matching_user =
            ((loginRespJModel != null ? loginRespJModel.id : null));
        dateMatchReqJModel.match_to = currentMatch_dateMatch.profile.id;
        dateMatchReqJModel.active = true;
        dateMatchReqJModel.txndate = dateTimeNow;
        dateMatchReqJModel.isuserrequested = false;

        DateMatchRespJModel dateMatchRespJModel = await post_put_user_Match(
          context,
          null,
          null,
          dateMatchReqJModel,
          true,
        );
        if (dateMatchRespJModel != null) {
          if (dateMatchRespJModel.approved != null &&
              dateMatchRespJModel.approved) {
            if (widget.snackbarBuildContext != null) {
              showSnackbarWBgCol('It\'s a match !!!',
                  widget.snackbarBuildContext, DatingAppTheme.green);
            }
          }
          print(json.encode(dateMatchRespJModel));
          print('dateMatchRespJModel success:');
          //print(json.encode(dateMatchRespJModel));
        }
      }
    }
  }

/*  SlideDirection _desiredSlideOutDirection() {
    switch (widget.matchEngine.currentMatch.decision) {
      case Decision.nope:
        return SlideDirection.left;
      case Decision.like:
        return SlideDirection.right;
      case Decision.superLike:
        return SlideDirection.up;
      default:
        return null;
    }
  }*/

  SlideDirection _desiredSlideOutDirection() {
    DateMatch currentMatch_DateMatch = widget.matchEngine.currentMatch;
    if (currentMatch_DateMatch != null) {
      switch (currentMatch_DateMatch.decision) {
        case Decision.nope:
          return SlideDirection.left;
        case Decision.like:
          return SlideDirection.right;
        case Decision.superLike:
          return SlideDirection.up;
        default:
          return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    mainBuildContext = context;
    return FutureBuilder<List<MatchDecisionRespJModel>>(
      future: fetchRefresh_allMatchDecisionList(context),
      builder: (BuildContext context,
          AsyncSnapshot<List<MatchDecisionRespJModel>> snapshot) {
        if (!snapshot.hasData ||
            (snapshot.hasData && !(snapshot.data.length > 0))) {
          return SizedBox();
        } else {
          return Stack(
            children: <Widget>[
              new DraggableCard(
                isDraggable: false,
                isFrontCard: false,
                card: _buildBackCard(),
                onInfoClickedNavigationDataBLoC:
                    widget.onInfoClickedNavigationDataBLoC,
                showDraggableCards_NavigationDataBLoC:
                    widget.showDraggableCards_NavigationDataBLoC,
                isDraggableCards_Laid_Out_NavigationDataBLoC:
                    widget.isDraggableCards_Laid_Out_NavigationDataBLoC,
              ),
              new DraggableCard(
                card: _buildFrontCard(),
                isFrontCard: true,
                slideTo: _desiredSlideOutDirection(),
                onSlideUpdate: _onSlideUpdate,
                onSlideRegionUpdate: _onSlideRegion,
                onSlideOutComplete: _onSlideOutComplete,
                onInfoClickedNavigationDataBLoC:
                    widget.onInfoClickedNavigationDataBLoC,
                showDraggableCards_NavigationDataBLoC:
                    widget.showDraggableCards_NavigationDataBLoC,
                isDraggableCards_Laid_Out_NavigationDataBLoC:
                    widget.isDraggableCards_Laid_Out_NavigationDataBLoC,
              ),
            ],
          );
        }
      },
    );
    /*Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return new StreamBuilder(
          stream: widget.showDraggableCards_NavigationDataBLoC.stream_counter,
          builder: (context, snapshot) {
            print('rebuild draggable');
            NavigationData navigationData = snapshot.data;
            if (navigationData != null && navigationData.isShow != null) {
              if (!navigationData.isShow) {
                print('rebuild draggable hide1');
                return stack_backFront(false);
              } else {
                print('rebuild draggable show1');
                return stack_backFront(true);
              }
            } else {
              print('rebuild draggable show2');
              return stack_backFront(true);
            }
          },
        );
        */ /*Stack(
          children: <Widget>[
            new DraggableCard(
              isDraggable: false,
              card: _buildBackCard(),
              onInfoClickedNavigationDataBLoC:
                  widget.onInfoClickedNavigationDataBLoC,
              showDraggableCards_NavigationDataBLoC:
                  widget.showDraggableCards_NavigationDataBLoC,
            ),
            new DraggableCard(
              card: _buildFrontCard(),
              slideTo: _desiredSlideOutDirection(),
              onSlideUpdate: _onSlideUpdate,
              onSlideRegionUpdate: _onSlideRegion,
              onSlideOutComplete: _onSlideOutComplete,
              onInfoClickedNavigationDataBLoC:
                  widget.onInfoClickedNavigationDataBLoC,
              showDraggableCards_NavigationDataBLoC:
                  widget.showDraggableCards_NavigationDataBLoC,
            ),
          ],
        );*/ /*
      },
    );*/
  }

  Widget stack_backFront(bool toshow) {
    return Opacity(
      opacity: toshow ? 1.0 : 0.0,
      child: Stack(
        children: <Widget>[
          new DraggableCard(
            isDraggable: false,
            card: _buildBackCard(),
            onInfoClickedNavigationDataBLoC:
                widget.onInfoClickedNavigationDataBLoC,
            showDraggableCards_NavigationDataBLoC:
                widget.showDraggableCards_NavigationDataBLoC,
          ),
          new DraggableCard(
            card: _buildFrontCard(),
            slideTo: _desiredSlideOutDirection(),
            onSlideUpdate: _onSlideUpdate,
            onSlideRegionUpdate: _onSlideRegion,
            onSlideOutComplete: _onSlideOutComplete,
            onInfoClickedNavigationDataBLoC:
                widget.onInfoClickedNavigationDataBLoC,
            showDraggableCards_NavigationDataBLoC:
                widget.showDraggableCards_NavigationDataBLoC,
          ),
        ],
      ),
    );
  }
}
