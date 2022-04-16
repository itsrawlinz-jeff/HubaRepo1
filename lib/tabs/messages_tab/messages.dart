import 'dart:async';

import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_datematches_online.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/DateMatchListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/DateMatchRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/tabs/messages_tab/widgets/DirectMessagingPage.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/utils/images.dart';
import 'package:after_layout/after_layout.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  NavigationDataBLoC current_PageViewPosition_NavigationDataBLoC;
  Messages({
    Key key,
    this.current_PageViewPosition_NavigationDataBLoC,
  }) : super(key: key);
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages>
    with TickerProviderStateMixin, AfterLayoutMixin<Messages> {
  StreamSubscription<NavigationData>
      current_PageViewPosition_NavigationDataBLoC_streamSubscription;
  List<DateMatchRespJModel> dateMatchRespJModelList = [];
  DateMatchListRespJModel current_DateMatchListRespJModel;
  NavigationDataBLoC messagesList_NavigationDataBLoC = NavigationDataBLoC();
  NavigationDataBLoC search_Field_NavigationDataBLoC = NavigationDataBLoC();

  //ANIMATION
  Animation animation;
  AnimationController animationController;

  //TOP LOADER
  AnimationController _scaleFactor;
  AnimationController _positionController;
  Animation<Offset> _positionFactor;
  bool is_readyToRefresh = false;

  //END OF TOPLOADER
  //USER SESSION
  LoginRespModel loginRespModel;
  //END OF USER SESSION

  //SEARCH FIELD
  TextEditingController searchTextEditingController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  //END OF SEARCH FIELD

  @override
  void initState() {
    //ANIMATION
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval((1 / 9) * 0, 1.0, curve: Curves.fastOutSlowIn)));

    //TOP LOADER
    _positionController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
        upperBound: 1.0,
        lowerBound: 0.0,
        value: 0.0);

    _scaleFactor = AnimationController(
        vsync: this,
        value: 1.0,
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: Duration(milliseconds: 300));

    _positionFactor = _positionController
        .drive(Tween<Offset>(begin: Offset(0.0, -0.5), end: Offset(0.0, 0.64)));
    //END OF TOPLOADER
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getLoggedInUser_and_setUpData(context);
    setUpListeners(context);
  }

  setUpListeners(BuildContext context) {
    String TAG = 'Messages:setUpListeners:';
    current_PageViewPosition_NavigationDataBLoC_streamSubscription = widget
        .current_PageViewPosition_NavigationDataBLoC.stream_counter
        .listen((value) async {
      NavigationData navigationData = value;
      if (navigationData != null && navigationData.current_index == 2) {
        getLoggedInUser_and_setUpData(context);
      }
    });
  }

  getLoggedInUser_and_setUpData(BuildContext context) async {
    loginRespModel = await getSessionLoginRespModel(context);
    setUpData(context);
  }

  setUpData(BuildContext context) async {
    String TAG = 'Messages:setUpData:';
    //SHOW TOP LOADER
    bool isshow_loading_indicator = await show_loading_indicator(
      is_readyToRefresh,
      _positionController,
      get_default_loader_distance(),
      get_default_loader_height(),
      _scaleFactor,
    );

    set_is_readyToRefresh_value(isshow_loading_indicator);
    //END OF SHOW TOP LOADER
    current_DateMatchListRespJModel =
        await fetch_datematches_online_by_approved_active(
      context,
      'True',
      'True',
    );
    if (current_DateMatchListRespJModel != null) {
      dateMatchRespJModelList = current_DateMatchListRespJModel.results;
      refresh_messagesList_NavigationDataBLoC();
    }
    //DISMISS TOP LOADER
    dismiss_loading_indicator(_scaleFactor);
    //END OF DISMISS TOP LOADER
  }

  //STATE CHANGES
  refresh_messagesList_NavigationDataBLoC() {
    refresh_WO_Data_NavigationDataBLoC(messagesList_NavigationDataBLoC);
  }

  //END OF STATE CHANGES

  @override
  void dispose() {
    if (current_PageViewPosition_NavigationDataBLoC_streamSubscription !=
        null) {
      current_PageViewPosition_NavigationDataBLoC_streamSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                new SliverList(
                    delegate: SliverChildListDelegate([
                  //_buildSearchField(),
                  _searchField(datingAppThemeChanger),
                  _buildMatches(datingAppThemeChanger),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 16.0),
                    child: new Text(
                      "Messages",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.pink,
                        fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
                      ),
                    ),
                  ),
                  new SizedBox(
                    height: 10.0,
                  ),
                  _buildMessages(datingAppThemeChanger),
                ])),
              ],
            ),
            Container(
              child: SlideTransition(
                child: ScaleTransition(
                  scale: _scaleFactor,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: RefreshProgressIndicator(
                      semanticsLabel: MaterialLocalizations?.of(context)
                          ?.refreshIndicatorSemanticLabel,
                      value: null,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        DatingAppTheme.pltf_pink.withOpacity(0.5),
                      ),
                      backgroundColor: DatingAppTheme.white,
                    ),
                  ),
                ),
                position: _positionFactor,
              ),
              height: 100,
            ),
          ],
        );
      },
    );
  }

  Widget _searchField(DatingAppThemeChanger datingAppThemeChanger) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.only(right: 16, top: 8, bottom: 0),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: datingAppThemeChanger.selectedThemeData
                                  .cl_dismissibleBackground_white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    offset: Offset(1, 4),
                                    blurRadius: 4.0),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 16, right: 16, top: 0, bottom: 0),
                              child: StreamBuilder(
                                stream: search_Field_NavigationDataBLoC
                                    .stream_counter,
                                builder: (context, snapshot) {
                                  return TextField(
                                    textAlign: TextAlign.left,
                                    style: datingAppThemeChanger
                                        .selectedThemeData.txt_stl_f14w500_Med,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.search,
                                          size: 24,
                                          color: datingAppThemeChanger
                                              .selectedThemeData.cl_grey),
                                      suffixIcon: !isStringValid(
                                              searchTextEditingController.text)
                                          ? Container(
                                              height: 0.0,
                                              width: 0.0,
                                            )
                                          : InkWell(
                                              child: Icon(Icons.clear,
                                                  color: datingAppThemeChanger
                                                      .selectedThemeData
                                                      .cl_grey //Colors.white
                                                  ),
                                              onTap: () {
                                                searchTextEditingController
                                                    .clear();
                                                refresh_WO_Data_NavigationDataBLoC(
                                                    search_Field_NavigationDataBLoC);
                                                refresh_WO_Data_NavigationDataBLoC(
                                                    messagesList_NavigationDataBLoC);
                                              },
                                            ),
                                      border: InputBorder.none,
                                      hintText: 'Search Matches',
                                      hintStyle: datingAppThemeChanger
                                          .selectedThemeData
                                          .txt_stl_hint_f14w500_Med,
                                    ),
                                    controller: searchTextEditingController,
                                    cursorColor: datingAppThemeChanger
                                        .selectedThemeData.cl_grey,
                                    focusNode: searchFocusNode,
                                    autofocus: false,
                                    onTap: () {},
                                    onChanged: (String txt) {
                                      onSearchParamChanged(txt);
                                    },
                                  );
                                },
                              ),
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
        );
      },
    );
  }

  /*
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: new TextFormField(
        decoration: InputDecoration(
          icon: Icon(
            Icons.search,
            color: Colors.pink,
          ),
          hintText: "Search 2 Matches",
          hintStyle: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 18.0),
          border: new UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.pink.withOpacity(0.5), width: 0.5)),
          enabledBorder: new UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.pink.withOpacity(0.5), width: 0.5)),
          disabledBorder: new UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.pink.withOpacity(0.5), width: 0.5)),
          focusedBorder: new UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.pink.withOpacity(0.5), width: 0.5)),
        ),
      ),
    );
  }*/

  Widget _buildMatches(DatingAppThemeChanger datingAppThemeChanger) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            "New Matches",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.pink,
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
            ),
          ),
          new SizedBox(
            height: 10.0,
          ),
          _buildMatchList(datingAppThemeChanger)
        ],
      ),
    );
  }

  Widget _buildMatchList(DatingAppThemeChanger datingAppThemeChanger) {
    return new Container(
        height: 100.0,
        child: new ListView.builder(
            itemCount: 4,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return new Container(
                margin: EdgeInsets.all(5.0),
                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: DatingAppTheme.pltf_grey.withOpacity(0.2)),
              );
            }));
  }

  Widget _buildMessages(DatingAppThemeChanger datingAppThemeChanger) {
    return new StreamBuilder(
      stream: messagesList_NavigationDataBLoC.stream_counter,
      builder: (context, snapshot) {
        return ListView.separated(
          itemCount: dateMatchRespJModelList.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 8, right: 8),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            DateMatchRespJModel dateMatchRespJModel =
                dateMatchRespJModelList[index];

            CustomUserRespJModel messaging_to =
                ((dateMatchRespJModel.match_to.id == loginRespModel.id
                    ? dateMatchRespJModel.matching_user
                    : dateMatchRespJModel.match_to));

            if (!isStringValid(searchTextEditingController.text) ||
                '${get_CustomUserRespJModel_Fullname(messaging_to)}'
                    .toLowerCase()
                    .contains(searchTextEditingController.text.toLowerCase())) {
              return new Material(
                color: datingAppThemeChanger
                    .selectedThemeData.cl_dismissibleBackground_white,
                child: ListTile(
                  leading: new CircularProfileAvatar(
                    '',
                    child: ((isStringValid(messaging_to.picture)
                        ? CachedNetworkImage(
                            imageUrl: messaging_to.picture,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) {
                              return placeholder_image_Container();
                            },
                            errorWidget: (context, url, error) {
                              return placeholder_image_Container();
                            },
                          )
                        : placeholder_image_Container())),
                    radius: 30,
                    backgroundColor: DatingAppTheme.pltf_grey.withOpacity(0.2),
                    //Colors.black,
                    borderWidth: 0,
                    borderColor: Colors.transparent,
                    initialsText: Text(
                      "",
                    ),
                    elevation: 5.0,

                    cacheImage: true,
                    onTap: () {
                      print('image tapped');
                    },
                    showInitialTextAbovePicture: false,
                  ),
                  title: Row(
                    children: <Widget>[
                      Text(
                        messaging_to.first_name + ' ' + messaging_to.last_name,
                        style: TextStyle(
                          fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: -0.2,
                          color: DatingAppTheme.darkerText,
                        ),
                      ),
                      Text(
                        dateMatchRespJModel.unread_messages_no > 0
                            ? getDateFormat_ddMMyy().format(dateMatchRespJModel
                                .last_message.created_at
                                .toLocal())
                            : '',
                        style: TextStyle(
                            fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: 0.0,
                            color: dateMatchRespJModel.unread_messages_no > 0
                                ? datingAppThemeChanger
                                    .selectedThemeData.cl_white_grey
                                : datingAppThemeChanger
                                    .selectedThemeData.cl_white_grey),
                      ),
                    ],
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      dateMatchRespJModel.last_message != null
                          ? dateMatchRespJModel.last_message.read
                              ? Padding(
                                  padding: EdgeInsets.only(right: 2.0),
                                  child: Icon(
                                    Icons.done_all,
                                    color: datingAppThemeChanger
                                        .selectedThemeData
                                        .cl_white_nearlyDarkBlue,
                                    size: 12.0,
                                  ))
                              : Padding(
                                  padding: EdgeInsets.only(right: 2.0),
                                  child: Icon(
                                    Icons.done,
                                    color: datingAppThemeChanger
                                        .selectedThemeData
                                        .cl_white_nearlyDarkBlue,
                                    size: 12.0,
                                  ))
                          : Container(),
                      dateMatchRespJModel.last_message != null
                          ? Flexible(
                              child: Text(
                                dateMatchRespJModel.last_message.content,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: datingAppThemeChanger.selectedThemeData
                                    .txt_stl_white_grey05_10_w500_sp0_Med,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  /*trailing: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        dateMatchRespJModel.unread_messages_no > 0
                            ? getDateFormat_ddMMyy().format(dateMatchRespJModel
                                .last_message.created_at
                                .toLocal())
                            : '',
                        style: TextStyle(
                            fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: 0.0,
                            color: dateMatchRespJModel.unread_messages_no > 0
                                ? DatingAppTheme.notificationBadgeColor
                                : DatingAppTheme.pltf_pink/*datingAppThemeChanger.selectedThemeData
                                    .cl_white_grey*/ //Colors.grey,
                            ),
                      ),
                      //widget.chat.unreadMessages
                      /*dateMatchRespJModel.unread_messages_no > 0
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                color: DatingAppTheme.notificationBadgeColor,
                              ),
                              width: 24.0,
                              height: 24.0,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(right: 4.0, top: 4.0),
                              child: Text(
                                '${dateMatchRespJModel.unread_messages_no}',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : Text(''),*/
                    ],
                  ),*/
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new DirectMessagingPage(
                                  messaging_to: messaging_to,
                                )));
                  },
                ),
              );
            }
            return invisibleWidget();
          },
          separatorBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 80.0),
              child: new Divider(
                height: 24.0,
              ),
            );
          },
        );
      },
    );
  }

  //BUILD WIDGET FUNCTIONS
  onSearchParamChanged(String txt) {
    refresh_WO_Data_NavigationDataBLoC(messagesList_NavigationDataBLoC);
    refresh_WO_Data_NavigationDataBLoC(search_Field_NavigationDataBLoC);
  }

  //END OF BUILD WIDGET FUNCTIONS
  //POSITIONED LOADER set_is_readyToRefresh
  set_is_readyToRefresh_value(
    bool isshow_loading_indicator,
  ) {
    if (isshow_loading_indicator != null) {
      is_readyToRefresh = isshow_loading_indicator;
    }
  }
//END OF POSITIONED LOADER set_is_readyToRefresh
}
