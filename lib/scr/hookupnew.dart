import 'dart:async';
import 'dart:io';

import 'package:dating_app/Activities/ProfileInfo.dart';
import 'package:dating_app/Bloc/Streams/UserProfilesForMatching/UserProfilesForMatchingBloC.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Models/Chopper/UsersProfileResp.dart';
import 'package:dating_app/Models/Chopper/UsersResp.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/DateMatchListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/DateMatchRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/user_profiles/UserUserProfileReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/UI/Presentation/dialogs/AddNewHobbieDialog.dart';
import 'package:dating_app/UI/Presentation/dialogs/ProfileDetailsDialog.dart';
import 'package:dating_app/UI/Presentation/painters/circle_painter.dart';
import 'package:dating_app/UI/Presentation/waves/curve_wave.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/scr/card_stack_new.dart';
import 'package:dating_app/scr/matches_new.dart';
import 'package:dating_app/scr/profiles.dart';
import 'package:dating_app/utils/images.dart';
import 'package:provider/provider.dart';
import 'round_icon_button.dart';
import 'package:after_layout/after_layout.dart';

class HookUp extends StatefulWidget {
  HookUp({
    Key key,
    this.navigationDataBLoC_UserprofilesChanged,
    this.onInfoClickedNavigationDataBLoC,
    this.showDraggableCards_NavigationDataBLoC,
    this.isDraggableCards_Laid_Out_NavigationDataBLoC,
    this.current_PageViewPosition_NavigationDataBLoC,
    this.hookuppageBodyDraggableCards_NavigationDataBLoC,
  }) : super(key: key);

  NavigationDataBLoC onInfoClickedNavigationDataBLoC;
  NavigationDataBLoC navigationDataBLoC_UserprofilesChanged;
  NavigationDataBLoC showDraggableCards_NavigationDataBLoC;
  NavigationDataBLoC isDraggableCards_Laid_Out_NavigationDataBLoC;
  NavigationDataBLoC current_PageViewPosition_NavigationDataBLoC;
  NavigationDataBLoC hookuppageBodyDraggableCards_NavigationDataBLoC;

  @override
  _HookUpState createState() => _HookUpState();
}

class _HookUpState extends State<HookUp>
    with
        //AutomaticKeepAliveClientMixin<HookUp>,
        AfterLayoutMixin<HookUp>,
        TickerProviderStateMixin {
  MatchEngine bldMatchEngine = new MatchEngine(
    matches: new List<Profile>().map((Profile profile) {
      return new DateMatch(profile: profile);
    }).toList(),
  );

  var _userProfilesForMatchingBloC = new UserProfilesForMatchingBloC();

  BuildContext mainBuildContext;
  Widget cardStack = new Container();
  NavigationDataBLoC hobbiesAddedNavigationDataBLoC = NavigationDataBLoC();
  BuildContext snackbarBuildContext;
  NavigationDataBLoC loginRespModel_NavigationDataBLoC = NavigationDataBLoC();
  NavigationDataBLoC profilesFetched_NavigationDataBLoC = NavigationDataBLoC();

  LoginRespModel loginRespModel;
  AnimationController _controller;
  Timer _timer;
  bool isOnNavigationBack = false;
  bool isHookupBodyVisible = false;
  NavigationDataBLoC isHookupBodyVisible_NavigationDataBLoC =
      NavigationDataBLoC();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _userProfilesForMatchingBloC.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getLoggedInUser(context);
    setupListeners(context);
  }

  //AFTER FIRST LAYOUT FUNCTIONS
  getLoggedInUser(BuildContext context) async {
    loginRespModel = await getSessionLoginRespModel(context);
    refresh_WO_Data_NavigationDataBLoC(loginRespModel_NavigationDataBLoC);
    if (!_controller.isAnimating) {
      _controller.repeat();
    }
    getProfileList(context);
  }
  //END OF AFTER FIRST LAYOUT FUNCTIONS

  setupListeners(BuildContext context) {
    widget.navigationDataBLoC_UserprofilesChanged.stream_counter
        .listen((value) async {
      print('LISTENER widget.navigationDataBLoC_UserprofilesChanged 1');
      NavigationData navData = value;
      if (navData != null && navData.isShow) {
        print('LISTENER widget.navigationDataBLoC_UserprofilesChanged 2');
        refresh_WO_Data_NavigationDataBLoC(profilesFetched_NavigationDataBLoC);
        if (!_controller.isAnimating) {
          _controller.repeat();
        }
        await getProfileList(mainBuildContext);//context
      }
    });

    String TAG = 'HookUp setUpListeners:';
    print(TAG);
    widget.onInfoClickedNavigationDataBLoC.stream_counter.listen((value) async {
      print(TAG + ' HERE1');
      print('LISTENER widget.onInfoClickedNavigationDataBLoC 1');
      NavigationData navigationData = value;
      if (navigationData != null &&
          navigationData.isSelected &&
          mainBuildContext != null) {
        print('LISTENER widget.onInfoClickedNavigationDataBLoC 2');
        print(TAG + ' HERE2');
        /*Navigator.of(mainBuildContext).push(
          MaterialPageRoute(
            builder: (context) {
              return ProfileInfo();
            },
          ),
        );*/
        NavigationData navigationData = NavigationData();
        navigationData.isShow = false;
        refresh_W_Data_NavigationDataBLoC(
            widget.showDraggableCards_NavigationDataBLoC, navigationData);
        addNewInterest(context);
      }
    });

    if (widget.current_PageViewPosition_NavigationDataBLoC != null) {
      widget.current_PageViewPosition_NavigationDataBLoC.stream_counter
          .listen((value) async {
        print('LISTENER widget.current_PageViewPosition_NavigationDataBLoC 1');
        NavigationData navigationData = value;
        if (navigationData != null && navigationData.current_index == 1) {
          print('LISTENER widget.current_PageViewPosition_NavigationDataBLoC 2');
          //SETTING PAGE RUN ON INIT

          isOnNavigationBack = true;
          refresh_WO_Data_NavigationDataBLoC(
              profilesFetched_NavigationDataBLoC);
          if (!_controller.isAnimating) {
            _controller.repeat();
          }
          await getProfileList(mainBuildContext);//context
        }
      });
    }

    if (widget.hookuppageBodyDraggableCards_NavigationDataBLoC != null) {
      widget.hookuppageBodyDraggableCards_NavigationDataBLoC.stream_counter
          .listen((value) async {
        print('LISTENER widget.hookuppageBodyDraggableCards_NavigationDataBLoC 1');
        NavigationData navigationData = value;
        if (navigationData != null && navigationData.isShow != null) {
          print('LISTENER widget.hookuppageBodyDraggableCards_NavigationDataBLoC 2');
          if (!navigationData.isShow) {
            print('LISTENER widget.hookuppageBodyDraggableCards_NavigationDataBLoC 3');
            isHookupBodyVisible = false;
            refresh_WO_Data_NavigationDataBLoC(
                isHookupBodyVisible_NavigationDataBLoC);
          } else {
            print('LISTENER widget.hookuppageBodyDraggableCards_NavigationDataBLoC 4');
            isHookupBodyVisible = true;
            refresh_WO_Data_NavigationDataBLoC(
                isHookupBodyVisible_NavigationDataBLoC);

            refresh_WO_Data_NavigationDataBLoC(
                profilesFetched_NavigationDataBLoC);
            if (!_controller.isAnimating) {
              _controller.repeat();
            }
            await getProfileList(mainBuildContext);//context
          }
        } else {
          print('LISTENER widget.hookuppageBodyDraggableCards_NavigationDataBLoC 4');
          isHookupBodyVisible = true;
          refresh_WO_Data_NavigationDataBLoC(
              isHookupBodyVisible_NavigationDataBLoC);

          refresh_WO_Data_NavigationDataBLoC(
              profilesFetched_NavigationDataBLoC);
          if (!_controller.isAnimating) {
            _controller.repeat();
          }
          await getProfileList(mainBuildContext);//context
        }
      });
    }
  }

  //STATE CHANGES
  refresh_profilesFetched_NavigationDataBLoC(bool isShow) {
    NavigationData navigationData = NavigationData();
    navigationData.isShow = isShow;
    refresh_W_Data_NavigationDataBLoC(
        profilesFetched_NavigationDataBLoC, navigationData);
  }
  //END OF STATE CHANGES

  @override
  Widget build(BuildContext context) {
    mainBuildContext = context;
    //super.build(context);
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        snackbarBuildContext = context;
        return Container(
          color: datingAppThemeChanger
              .selectedThemeData.sm_bg_backgroundWO_opacity,
          child: Scaffold(
            //backgroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            body: //cardStack_Widget(),

                StreamBuilder(
              stream: isHookupBodyVisible_NavigationDataBLoC.stream_counter,
              builder: (context, snapshot) {
                return Visibility(
                  visible: isHookupBodyVisible,
                  child: StreamBuilder(
                    stream: profilesFetched_NavigationDataBLoC.stream_counter,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return ripple_ProfilePicture();
                      }
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return ripple_ProfilePicture();
                          break;
                        case ConnectionState.waiting:
                          return ripple_ProfilePicture();
                          break;
                        case ConnectionState.active:
                          return if_Show_UserProfiles(snapshot);
                          break;
                        case ConnectionState.done:
                          return if_Show_UserProfiles(snapshot);
                          break;
                      }
                    },
                  ),
                );
              },
            ),

            /*Container(
                height: 120.0,
                width: 120.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: isStringValid(loginRespModel.profile_picture)
                            ? NetworkImage(loginRespModel.profile_picture)
                            : AssetImage("assets/images/image_placeholder.png"),
                        fit: BoxFit.cover,
                        alignment: Alignment.center),
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.2)),
              ),*/

            bottomNavigationBar: _buildBottomBar(bldMatchEngine),
          ),
        );
      },
    );
  }

  //BUILD WIDGETS
  Widget if_Show_UserProfiles(AsyncSnapshot<NavigationData> snapshot) {
    if (bldMatchEngine != null &&
        bldMatchEngine.matches != null &&
        bldMatchEngine.matches.length > 0) {
      return cardStack_Widget();
    } else {
      //SET TIMER TO STOP ANIMATION
      //|| (_timer != null && !_timer.isActive)
      if (_timer == null) {
        print('STOP ANIMATION SUBTRACT _timer == null');
        stop_animation_Timer();
      }else{
        print('STOP ANIMATION SUBTRACT _timer != null');
      }
      //END OF SET TIMER TO STOP ANIMATION
      NavigationData navigationData = snapshot.data;
      if (navigationData != null &&
          navigationData.isShow != null &&
          !navigationData.isShow) {
        print('STOP ANIMATION SUBTRACT !navigationData.isShow');
        _controller.reset();
        if (_timer != null) {
          print('STOP ANIMATION SUBTRACT _timer != null');
          _timer.cancel();
          _timer = null;
        }
        return text_With_ProfilePicture();
      } else {
        if (isOnNavigationBack) {
          if (_timer == null) {
            print('STOP ANIMATION SUBTRACT 2 _timer == null');
            stop_animation_Timer();
          }
          return ripple_ProfilePicture();
        }
      }
      return ripple_ProfilePicture();
    }
  }

  Widget ripple_ProfilePicture() {
    return StreamBuilder(
      stream: loginRespModel_NavigationDataBLoC.stream_counter,
      builder: (context, snapshot) {
        /*&&
        isStringValid(loginRespModel.profile_picture)*/
        return ((loginRespModel != null
            ? Center(
                child: CustomPaint(
                  painter: CirclePainter(
                    _controller,
                    color: DatingAppTheme.pltf_pink,
                  ),
                  child: SizedBox(
                    width: 480,
                    height: 480,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: <Color>[
                                DatingAppTheme.pltf_pink.withOpacity(0.2),
                                Color.lerp(
                                    DatingAppTheme.pltf_pink.withOpacity(0.6),
                                    DatingAppTheme.transparent,
                                    .05)
                              ],
                            ),
                          ),
                          child: ScaleTransition(
                            scale: Tween(begin: 0.95, end: 1.0).animate(
                              CurvedAnimation(
                                parent: _controller,
                                curve: const CurveWave(),
                              ),
                            ),
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: loginRespModel != null &&
                                              isStringValid(loginRespModel
                                                  .profile_picture)
                                          ? NetworkImage(
                                              loginRespModel.profile_picture)
                                          : AssetImage(
                                              "assets/images/image_placeholder.png"),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center),
                                  shape: BoxShape.circle,
                                  color: Colors.grey.withOpacity(0.2)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : invisibleWidget()));
      },
    );
  }

  Widget text_With_ProfilePicture() {
    return StreamBuilder(
      stream: loginRespModel_NavigationDataBLoC.stream_counter,
      builder: (context, snapshot) {
        return Center(
          child: SizedBox(
            width: 480,
            height: 480,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: loginRespModel != null &&
                                    isStringValid(
                                        loginRespModel.profile_picture)
                                ? NetworkImage(loginRespModel.profile_picture)
                                : AssetImage(
                                    "assets/images/image_placeholder.png"),
                            fit: BoxFit.cover,
                            alignment: Alignment.center),
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.2)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 3,
                    ),
                    child: Text(
                      'No nearby users found',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: DatingAppTheme.font_AvenirLTStd_Light,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget cardStack_Widget() {
    return new CardStack(
      matchEngine: bldMatchEngine,
      onInfoClickedNavigationDataBLoC: widget.onInfoClickedNavigationDataBLoC,
      showDraggableCards_NavigationDataBLoC:
          widget.showDraggableCards_NavigationDataBLoC,
      isDraggableCards_Laid_Out_NavigationDataBLoC:
          widget.isDraggableCards_Laid_Out_NavigationDataBLoC,
      snackbarBuildContext: snackbarBuildContext,
    );
  }

  Widget _buildBottomBar(MatchEngine matchEngine) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0.0,
      child: new Padding(
        padding: EdgeInsets.all(16.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new RoundIconButton.small(
              icon: Icons.settings_backup_restore,
              iconColor: Colors.orange,
              onPressed: () {},
            ),
            new RoundIconButton.large(
              icon: Icons.clear,
              iconColor: Colors.red,
              onPressed: () {
                if (matchEngine.currentMatch != null) {
                  matchEngine.currentMatch.nope();
                }
                //matchEngine.currentMatch.nope();
              },
            ),
            new RoundIconButton.small(
              icon: Icons.star,
              iconColor: Colors.blue,
              onPressed: () {
                if (matchEngine.currentMatch != null) {
                  matchEngine.currentMatch.superLike();
                }
                //matchEngine.currentMatch.superLike();
              },
            ),
            new RoundIconButton.large(
              icon: Icons.favorite,
              iconColor: Colors.green,
              onPressed: () {
                if (matchEngine.currentMatch != null) {
                  matchEngine.currentMatch.like();
                }
                //matchEngine.currentMatch.like();
              },
            ),
            new RoundIconButton.widget(
              imageAsset: lightening,
              iconColor: Colors.purple,
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
  //END OF BUILD WIDGETS

  //BUILD WIDGET FUNCTIONS
  void stop_animation_Timer() {
    int _start = 15;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          print('STOP ANIMATION');
          refresh_profilesFetched_NavigationDataBLoC(false);
          timer.cancel();
          _timer.cancel();
          _timer = null;
        } else {
          print('STOP ANIMATION SUBTRACT');
          _start--;
        }
      },
    );
  }

  //END OF BUILD WIDGET FUNCTIONS
  Future<List<Profile>> getProfileList(BuildContext context) async {
    String TAG = 'getProfileList:';
    List<Profile> profileList = [];
/*    var response =
        await Provider.of<PostApiService>(context).getUserProfiles();
    print(response.body.toString());
    List<UsersResp> usersRespList = response.body.asList();*/
    //await Provider.of<PostApiService>(mainBuildContext)
    var response = await PostApiService.create()
        .getCustomusers_Auth_Excludng_LoggedInUser_By_MatchingUserId(
            DatingAppStaticParams.tokenWspace + loginRespModel.token,
            loginRespModel.id);

    int statusCode = response.statusCode;
    if (isresponseSuccessfull(statusCode)) {
      CustomUserListRespJModel customUserListRespJModel =
          CustomUserListRespJModel.fromJson(response.body);

      List<CustomUserRespJModel> usersRespList =
          customUserListRespJModel.results;

      print('usersRespList ${usersRespList.length}');
      for (var usersResp in usersRespList) {
        //for (int i=0;i<1;i++) {
        //var usersResp=usersRespList[i];
        /*if (!(usersResp.usersProfile.asList().length > 0)) {
        continue;
      }*/
        if (!(usersResp.userprofiles.length > 0)) {
          continue;
        }
        Profile profile = new Profile();
        profile.id = usersResp.id;
        profile.users = usersResp.id;
        profile.name = usersResp.username;
        profile.age = usersResp.age;
        profile.bio = ((usersResp.quote != null ? usersResp.quote : ""));
        profile.location = 'Nairobi';
        List<UserUserProfileReqJModel> usersProfileRespList =
            usersResp.userprofiles;
        //List<UsersProfileResp> usersProfileRespList = usersResp.usersProfile.asList();
        List<String> photos = [];
        for (var usersProfileResp in usersProfileRespList) {
          photos.add(usersProfileResp.picture);
        }
        profile.photos = photos;
        profileList.add(profile);
      }

      print('profileList ${profileList.length}');
      if (profileList.length > 0) {
        /*setState(() {
          bldMatchEngine = new MatchEngine(
            matches: profileList.map((Profile profile) {
              return new DateMatch(profile: profile);
            }).toList(),
          );
        });*/
        bldMatchEngine = new MatchEngine(
          matches: profileList.map((Profile profile) {
            return new DateMatch(profile: profile);
          }).toList(),
        );
        refresh_WO_Data_NavigationDataBLoC(profilesFetched_NavigationDataBLoC);
      } else {
        bldMatchEngine = new MatchEngine(
          matches: profileList.map((Profile profile) {
            return new DateMatch(profile: profile);
          }).toList(),
        );
        refresh_WO_Data_NavigationDataBLoC(profilesFetched_NavigationDataBLoC);
      }
    } else {
      bldMatchEngine = new MatchEngine(
        matches: profileList.map((Profile profile) {
          return new DateMatch(profile: profile);
        }).toList(),
      );
      refresh_WO_Data_NavigationDataBLoC(profilesFetched_NavigationDataBLoC);
      /*setState(() {
        bldMatchEngine = new MatchEngine(
          matches: profileList.map((Profile profile) {
            return new DateMatch(profile: profile);
          }).toList(),
        );
      });*/
    }
  }

  Widget getloadingPlaceHolder() {
    return Scaffold(
      body: Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator()),
    );
  }

  addNewInterest(BuildContext context) {
    showGeneralDialog(
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: null,
        transitionDuration: Duration(milliseconds: 150),
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return new ProfileDetailsDialog(
            snackbarBuildContext: mainBuildContext,
            animationController: AnimationController(
                duration: Duration(milliseconds: 600), vsync: this),
            showDraggableCards_NavigationDataBLoC:
                widget.showDraggableCards_NavigationDataBLoC,
          );
        });
  }
}
