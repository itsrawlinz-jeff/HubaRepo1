import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/scr/photo_browser_new.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewUserProfilePage extends StatefulWidget {
  CustomUserRespJModel messaging_to;
  ViewUserProfilePage({
    this.messaging_to,
    Key key,
  }) : super(key: key);

  @override
  _ViewUserProfilePageState createState() => _ViewUserProfilePageState();
}

class _ViewUserProfilePageState extends State<ViewUserProfilePage>
    with TickerProviderStateMixin, AfterLayoutMixin<ViewUserProfilePage> {
  //ANIMATION
  AnimationController animationController;
  Animation<double> topBarAnimation;
  Animation animation;
  int count = 9;
  //END OF ANIMATION
  BuildContext snackBarBuildContext;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn)));

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return Container(
          color: datingAppThemeChanger.selectedThemeData.cl_profile_page_bg,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                getMainListViewUI(datingAppThemeChanger),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getMainListViewUI(DatingAppThemeChanger datingAppThemeChanger) {
    return FutureBuilder<bool>(
      future: getData_common(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        snackBarBuildContext = context;
        if (!snapshot.hasData) {
          return SizedBox();
        } else {
          animationController.forward();
          return ListView(
            controller: scrollController,
            shrinkWrap: true,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            scrollDirection: Axis.vertical,

            /*Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),*/
            /*child: Container(
              child: new ClipRRect(
                child: new Material(
                  color: DatingAppTheme.transparent,
                  child: new Column(*/
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Stack(
                    children: <Widget>[
                      PhotoBrowser(
                          photoAssetPaths: widget.messaging_to.userprofiles
                              .map((item) => item.picture)
                              .toList(),
                          visiblePhotoIndex: 0),
                      Positioned(
                        right: 10,
                        bottom: 5,
                        child: FloatingActionButton(
                          heroTag: null,
                          child: Icon(
                            FontAwesomeIcons.arrowLeft,
                            color: DatingAppTheme.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          backgroundColor: DatingAppTheme.pltf_pink,
                        ), /*Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: DatingAppTheme.pltf_pink,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: IconButton(
                                icon: Icon(
                                  Icons.arrow_left,
                                  size: 40,
                                  color: DatingAppTheme.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                        ),*/
                      )
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      "${widget.messaging_to.name.split(" ")[0]}${((widget.messaging_to.age != null ? ', ' : ''))}",
                      style: TextStyle(
                        fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
                        fontWeight: FontWeight.normal,
                        fontSize: 25,
                        letterSpacing: 0,
                        color: datingAppThemeChanger
                            .selectedThemeData.mnu_darkerText_Color,
                      ),
                    ),
                    ((widget.messaging_to.age != null
                        ? Text(
                            "${widget.messaging_to.age}",
                            style: TextStyle(
                              fontFamily: DatingAppTheme.font_AvenirLTStd_Light,
                              fontWeight: FontWeight.normal,
                              fontSize: 23,
                              letterSpacing: 0,
                              color: DatingAppTheme.pltf_grey,
                            ),
                          )
                        : invisibleWidget())),
                  ],
                ),
              ),
              ((isStringValid(widget.messaging_to.quote)
                  ? new Padding(
                      padding: EdgeInsets.only(left: 24, right: 24, top: 5),
                      child: Text(
                        widget.messaging_to.quote,
                        style: TextStyle(
                          fontFamily: DatingAppTheme.font_AvenirLTStd_Light,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          letterSpacing: -0.3,
                          color: DatingAppTheme.pltf_grey,
                        ),
                      ),
                    )
                  : invisibleWidget())),
              ((isStringValid(widget.messaging_to.fb_link)
                  ? Padding(
                      padding: EdgeInsets.only(left: 24, right: 24, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          InkWell(
                            radius: 40,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0),
                                topRight: Radius.circular(30.0)),
                            child: Container(
                              decoration: BoxDecoration(
                                color: DatingAppTheme.colorAdrianBlue,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  FontAwesomeIcons.facebookF,
                                  color: DatingAppTheme.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            onTap: () async {
                              if (isStringValid(widget.messaging_to.fb_link)) {
                                if (await canLaunch(
                                    widget.messaging_to.fb_link)) {
                                  await launch(widget.messaging_to.fb_link);
                                } else {
                                  showSnackbarWBgCol('Could not launch link',
                                      snackBarBuildContext, DatingAppTheme.red);
                                }
                              } else {
                                showSnackbarWBgCol('Could not launch link',
                                    snackBarBuildContext, DatingAppTheme.red);
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  : invisibleWidget())),
              ((isStringValid(widget.messaging_to.insta_link)
                  ? Padding(
                      padding: EdgeInsets.only(left: 24, right: 24, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          InkWell(
                            radius: 40,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0),
                                topRight: Radius.circular(30.0)),
                            child: Container(
                              decoration: BoxDecoration(
                                color: DatingAppTheme.pink8,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  FontAwesomeIcons.instagram,
                                  color: DatingAppTheme.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            onTap: () async {
                              if (isStringValid(
                                  widget.messaging_to.insta_link)) {
                                if (await canLaunch(
                                    widget.messaging_to.insta_link)) {
                                  await launch(widget.messaging_to.insta_link);
                                } else {
                                  showSnackbarWBgCol('Could not launch link',
                                      snackBarBuildContext, DatingAppTheme.red);
                                }
                              } else {
                                showSnackbarWBgCol('Could not launch link',
                                    snackBarBuildContext, DatingAppTheme.red);
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  : invisibleWidget())),
            ],
          );
        }
      },
    );
  }

  void dispose() {
    super.dispose();
  }
}
