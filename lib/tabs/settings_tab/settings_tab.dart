import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dating_app/Activities/LoginSignUpOptionsPage.dart';
import 'package:dating_app/Authentication/Google/GoogleSignIn.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_customusers_online.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_user_usersProfiles.dart';
import 'package:dating_app/Data/SharedPreferences/UserSessionSharedPrefs.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/user_profiles/UserUserProfileReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/tabs/settings_tab/widgets/ProfileEditInfoPage.dart';
import 'package:dating_app/tabs/settings_tab/widgets/SettingsEditPage.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/scr/round_icon_button.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';

class SettingsTab extends StatefulWidget {
  NavigationDataBLoC navigationDataBLoC_UserprofilesChanged;
  NavigationDataBLoC current_PageViewPosition_NavigationDataBLoC;
  SettingsTab({
    Key key,
    this.navigationDataBLoC_UserprofilesChanged,
    this.current_PageViewPosition_NavigationDataBLoC,
  }) : super(key: key);

  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab>
    with
        AutomaticKeepAliveClientMixin<SettingsTab>,
        AfterLayoutMixin<SettingsTab> {
  int currentPage = 0;
  int currentColor = 0;
  bool reverse = false;
  PageController _controller = new PageController();
  Timer _pageChangeTimer;
  Timer colorTimer;
  String username;
  int age;
  String profPicUrl;
  String localprofilepicpath;
  String bio_str;

  NavigationDataBLoC profilepic_changed_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC profilepic_changed_Externally_NavigationDataBLoC =
      NavigationDataBLoC();
  LoginRespModel loginRespModel;

  @override
  void initState() {
    super.initState();
    _pageChanger();
  }

  @override
  void dispose() {
    _pageChangeTimer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _pageChanger() {
    _pageChangeTimer = Timer.periodic(Duration(seconds: 2), (_) {
      if (reverse == false && currentPage < hookUpPlusList.length - 1) {
        _controller.nextPage(
            duration: Duration(milliseconds: 5), curve: Curves.easeIn);
      } else if (reverse == true && currentPage <= hookUpPlusList.length - 1) {
        _controller.previousPage(
            duration: Duration(milliseconds: 5), curve: Curves.easeOut);
      }
    });
  }

  void _onPageChanged(int value) {
    //print("$value $reverse");
    setState(() {
      currentPage = value;
    });

    if (currentPage == hookUpPlusList.length - 1) {
      setState(() {
        reverse = true;
      });
      return;
    }

    if (currentPage == 0) {
      setState(() {
        reverse = false;
      });
      return;
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setUpListeners(context);
    getLoggedInUser_and_setUpData(context);
  }

  setUpListeners(BuildContext context) {
    String TAG = 'setUpListeners:';
    widget.current_PageViewPosition_NavigationDataBLoC.stream_counter
        .listen((value) async {
      NavigationData navigationData = value;
      if (navigationData != null && navigationData.current_index == 0) {
        //SETTING PAGE RUN ON INIT
        print(TAG + ' current_PageViewPosition_NavigationDataBLoC==0');
        get_user_user_profile(context);
      }
    });

    profilepic_changed_Externally_NavigationDataBLoC.stream_counter
        .listen((value) {
      NavigationData navigationData = value;
      if (navigationData != null && navigationData.isSelected) {
        get_user_user_profile(context);
      }
    });
  }

  getLoggedInUser_and_setUpData(BuildContext context) async {
    loginRespModel = await getSessionLoginRespModel(context);
    get_user_user_profile(context);
  }

  //AFTER FIRST LAYOUT FUNCTIONS
  get_user_user_profile(BuildContext context) async {
    CustomUserRespJModel customUserRespJModel =
        await fetch_customuser_online_by_id(
            context, loginRespModel.tokenDecodedJModel.id);
    if (customUserRespJModel != null) {
      username = customUserRespJModel.username;
      age = customUserRespJModel.age;
      bio_str = customUserRespJModel.quote;
      print('bio_str==${bio_str}');
      profPicUrl = customUserRespJModel.picture;
      refresh_WO_Data_NavigationDataBLoC(profilepic_changed_NavigationDataBLoC);
    } else {
      username = loginRespModel.username;
      age = loginRespModel.age;
      bio_str = loginRespModel.quote;

      if (isStringValid(loginRespModel.profile_picture)) {
        profPicUrl = loginRespModel.profile_picture;
      } else {
        if (loginRespModel.usersProfile.length > 0) {
          profPicUrl = loginRespModel.usersProfile[0].picture;
        }
      }
      refresh_WO_Data_NavigationDataBLoC(profilepic_changed_NavigationDataBLoC);
    }

    /*List<UserUserProfileReqJModel>
        profile_pictures_UserUserProfileReqJModel_List =
        await fetch_user_usersProfiles_By_Limit_UserId_Isprofilepicture(
      context,
      null,
      DatingAppStaticParams.default_Max_int,
      true.toString(),
    );
    if (profile_pictures_UserUserProfileReqJModel_List != null &&
        profile_pictures_UserUserProfileReqJModel_List.length > 0 &&
        isStringValid(
            profile_pictures_UserUserProfileReqJModel_List[0].picture)) {
      profPicUrl = profile_pictures_UserUserProfileReqJModel_List[0].picture;
      refresh_WO_Data_NavigationDataBLoC(profilepic_changed_NavigationDataBLoC);
    }*/
  }

  //END OF AFTER FIRST LAYOUT FUNCTIONS
  /*UserSessionSharedPrefs userSessionSharedPrefs =
        new UserSessionSharedPrefs();
    userSessionSharedPrefs.getUserSession().then((onValue) {
      if (onValue != null) {
        LoginRespModel loginRespModel =
            LoginRespModel.fromJson(json.decode(onValue));
        setState(() {
          username = loginRespModel.username;
          age = loginRespModel.age;
          if (loginRespModel.local_profile_picture_path != null) {
            localprofilepicpath = loginRespModel.local_profile_picture_path;
          }
          /*localprofilepicpath = loginRespModel.local_profile_picture_path +
              loginRespModel.local_profile_picture_filename;*/
          print('localprofilepicpath== ${localprofilepicpath}');
          if (loginRespModel.usersProfile.length > 0) {
            profPicUrl = loginRespModel.usersProfile[0].picture;

            print('profPicUrl== ${profPicUrl}');
          }
        });
        print('username== ${loginRespModel.username}');
      } else {
        print('value null');
        LoginRespModel loginRespModel = new LoginRespModel();
      }
    }, onError: (error) {
      LoginRespModel loginRespModel = new LoginRespModel();
    });*/

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return Container(
          color: datingAppThemeChanger
              .selectedThemeData.sm_bg_backgroundWO_opacity,
          child: Scaffold(
            //backgroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            body: new Stack(
              children: <Widget>[_buildProfileInfo(), _buildSettingsBottom()],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.only(
          right: 15.0, left: 15.0, top: 20.0, bottom: 50.0),
      child: new StreamBuilder(
        stream: profilepic_changed_NavigationDataBLoC.stream_counter,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                height: 120.0,
                width: 120.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: ifStringValid(localprofilepicpath)
                            ? Image.file(File(localprofilepicpath)).image
                            : isStringValid(profPicUrl)
                                ? NetworkImage(profPicUrl)
                                : AssetImage(
                                    "assets/images/image_placeholder.png"),
                        fit: BoxFit.cover,
                        alignment: Alignment.center),
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.2)),
              ),
              new SizedBox(
                height: 10.0,
              ),
              isStringValid(username) || age != null
                  ? new Text(
                      '${((isStringValid(username) ? '${username + ((age != null ? ', ${age.toString()}' : ''))}' : ((age != null ? '${age.toString()}' : ''))))}',
                      //"${username.split(" ")[0]}${((age != null ? ', ${age}' : ''))}",
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
                      ),
                    )
                  : invisibleWidget(),
              new SizedBox(
                height: 10.0,
              ),
              isStringValid(bio_str)
                  ? new Text(
                      bio_str,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
                      ),
                    )
                  : invisibleWidget(),
              new SizedBox(
                height: 20.0,
              ),
              _buildSettingsButtons()
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingsBottom() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new Flexible(child: _buildHookUpPlusUI()),
          /*  new Padding(
            padding:
                const EdgeInsets.only(left: 50.0, right: 50.0, bottom: 25.0),
            child: new RaisedButton(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              onPressed: () {},
              child: Center(
                child: new Text(
                  "MY CONNECTIONS PLUS",
                  style: TextStyle(color: Colors.pink, fontSize: 16.0),
                ),
              ),
            ),
          ),*/
          new Padding(
            padding:
                const EdgeInsets.only(left: 50.0, right: 50.0, bottom: 25.0),
            child: new RaisedButton(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              onPressed: () {
                UserSessionSharedPrefs userSessionSharedPrefs =
                    new UserSessionSharedPrefs();
                userSessionSharedPrefs.setUserSession(null).then(
                    (onValue) async {
                  try {
                    FirebaseAuth _auth = FirebaseAuth.instance;
                    FirebaseUser currentUser = await _auth.currentUser();
                    await _auth.signOut();
                    currentUser = null;
                  } catch (error) {
                    print('SIGNING OUT firebase error==${error}');
                  }
                  try {
                    var isgoogleSignIn = await googleSignIn.isSignedIn();
                    print('isgoogleSignIn=${isgoogleSignIn}');
                    if (isgoogleSignIn) {
                      var googleSignoutVar = await googleSignIn.signOut();
                      print('SIGNING OUT GOOGLE');
                    }
                  } catch (error) {
                    print('SIGNING OUT google error==${error}');
                  }
                  try {
                    var facebookLogin = FacebookLogin();
                    await facebookLogin.logOut();
                  } catch (error) {
                    print('SIGNING OUT facebook error==${error}');
                  }
                  try {
                    if (onValue) {
                      Navigator.popUntil(
                          context, (Route<dynamic> route) => route.isFirst);
                      Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  new LoginSignUpOptionsPage()));
                      print('popUntil success');
                    }
                  } catch (error) {
                    print('popUntil pushReplacement error==');
                    print(error);
                  }
                }, onError: (error) {});
              },
              child: Center(
                child: new Text(
                  "Log Out",
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 16.0,
                    fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHookUpPlusUI() {
    return Container(
      height: 150.0,
      child: PageIndicatorContainer(
          size: 8.0,
          indicatorSpace: 5.0,
          indicatorSelectorColor: Colors.blue,
          indicatorColor: Colors.grey.withOpacity(0.5),
          align: IndicatorAlign.bottom,
          pageView: new PageView.builder(
              controller: _controller,
              onPageChanged: _onPageChanged,
              itemCount: hookUpPlusList.length,
              itemBuilder: (c, index) {
                return new Container(
                  padding: EdgeInsets.all(15.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        hookUpPlusList[index].title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        hookUpPlusList[index].subTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
                        ),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                );
              }),
          length: hookUpPlusList.length),
    );
  }

  Widget _buildSettingsButtons() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        new Column(
          children: <Widget>[
            new RoundIconButton.large(
              icon: Icons.settings,
              iconColor: Colors.red,
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new SettingsEditPage()));
              },
            ),
            new SizedBox(
              height: 10.0,
            ),
            new Text(
              "SETTINGS",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
                fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              ),
            )
          ],
        ),
        new Column(
          children: <Widget>[
            new RoundIconButton.small(
              icon: Icons.camera_alt,
              iconColor: Colors.blue,
              onPressed: () {},
            ),
            new SizedBox(
              height: 10.0,
            ),
            new Text(
              "ADD MEDIA",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
                fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              ),
            )
          ],
        ),
        new Column(
          children: <Widget>[
            new RoundIconButton.large(
              icon: Icons.edit,
              iconColor: Colors.green,
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ProfileEditInfoPage(
                              navigationDataBLoC_UserprofilesChanged:
                                  widget.navigationDataBLoC_UserprofilesChanged,
                              profilepic_changed_Externally_NavigationDataBLoC:
                                  profilepic_changed_Externally_NavigationDataBLoC,
                            )));
              },
            ),
            new SizedBox(
              height: 10.0,
            ),
            new Text(
              "EDIT INFO",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
                fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              ),
            )
          ],
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class HookUpPlus {
  final String title;
  final String subTitle;
  HookUpPlus({this.title, this.subTitle});
}

final List<HookUpPlus> hookUpPlusList = [
  new HookUpPlus(
      title: "Increase your chances",
      subTitle: "Choose either an in app or admin match"),
  new HookUpPlus(title: "Get Matches Faster", subTitle: "View other profiles"),
  new HookUpPlus(
      title: "Send a chat", subTitle: "Use our in app chat for fast responses"),
  /*new HookUpPlus(
      title: "Swipe Around The World",
      subTitle: "Passport to anywhere with HookUp Plus"),
  new HookUpPlus(
      title: "Control Your Profile",
      subTitle: "Limit what others see with HookUp Plus"),
  new HookUpPlus(
      title: "I Mean't to Swipe Right",
      subTitle: "Get unlimited Rewinds with HookUp Plus!"),
  new HookUpPlus(
      title: "Increase Your Chances",
      subTitle: "Get unlimited Likes with HookUp Plus!"),*/
];
