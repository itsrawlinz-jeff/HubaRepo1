import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileAppBar extends StatefulWidget {
  AnimationController animationController;
  double topBarOpacity;

  ProfileAppBar({
    Key key,
    this.animationController,
    this.topBarOpacity,
  }) : super(key: key);

  @override
  _ProfileAppBarState createState() => _ProfileAppBarState();
}

class _ProfileAppBarState extends State<ProfileAppBar>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  var dateFormat = DateFormat("dd MMM");

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return Column(
          children: <Widget>[
            AnimatedBuilder(
              animation: widget.animationController,
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                  opacity: topBarAnimation,
                  child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: datingAppThemeChanger
                            .selectedThemeData.mnu_topbar_Bg
                            .withOpacity(widget.topBarOpacity),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32.0),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: DatingAppTheme.grey
                                  .withOpacity(0.4 * widget.topBarOpacity),
                              offset: const Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).padding.top,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 16 - 8.0 * widget.topBarOpacity,
                                bottom: 12 - 8.0 * widget.topBarOpacity),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: DatingAppTheme
                                            .font_AvenirLTStd_Heavy,
                                        fontWeight: FontWeight.w700,
                                        fontSize:
                                            22 + 6 - 6 * widget.topBarOpacity,
                                        letterSpacing: 1.2,
                                        color: datingAppThemeChanger
                                            .selectedThemeData.mnu_Color,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 38,
                                  width: 38,
                                  child: InkWell(
                                    highlightColor: Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(32.0)),
                                    onTap: () {},
                                    child: Center(
                                      child: Icon(
                                        Icons.keyboard_arrow_left,
                                        color: datingAppThemeChanger
                                            .selectedThemeData.mnu_grey_Color,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Icon(
                                          Icons.calendar_today,
                                          color: datingAppThemeChanger
                                              .selectedThemeData.mnu_grey_Color,
                                          size: 18,
                                        ),
                                      ),
                                      Text(
                                        '${dateFormat.format(new DateTime.now())}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: DatingAppTheme.fontName,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                          letterSpacing: -0.2,
                                          color: datingAppThemeChanger
                                              .selectedThemeData
                                              .mnu_darkerText_Color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 38,
                                  width: 38,
                                  child: InkWell(
                                    highlightColor: Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(32.0)),
                                    onTap: () {},
                                    child: Center(
                                      child: Icon(
                                        Icons.keyboard_arrow_right,
                                        color: datingAppThemeChanger
                                            .selectedThemeData.mnu_grey_Color,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }
}
