import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataEvent.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_customusers_online.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_user_usersProfiles.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/batch_put_posting/batch_put_post_user_usersProfiles.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_put_customuser.dart';
import 'package:dating_app/CustomWidgets/ProfileAppBar.dart';
import 'package:dating_app/CustomWidgets/ProfileImageGridViewItem.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/user_profiles/UserUserProfileReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/users/CustomUserReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/JsonSerializable/navigation/IndexAndUserUserProfileReqJModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileEditInfoPage extends StatefulWidget {
  ProfileEditInfoPage({
    Key key,
    this.navigationDataBLoC_UserprofilesChanged,
    this.profilepic_changed_Externally_NavigationDataBLoC,
  }) : super(key: key);
  NavigationDataBLoC navigationDataBLoC_UserprofilesChanged;
  NavigationDataBLoC profilepic_changed_Externally_NavigationDataBLoC;

  @override
  _ProfileEditInfoPageState createState() => _ProfileEditInfoPageState();
}

class _ProfileEditInfoPageState extends State<ProfileEditInfoPage>
    with TickerProviderStateMixin, AfterLayoutMixin<ProfileEditInfoPage> {
  ScrollController scrollController = ScrollController();
  DateFormat dtf = DateFormat('dd MMM,yy');
  Animation<double> topBarAnimation;
  double topBarOpacity = 0.0;
  Animation<double> _scaleAnimation;
  Animation animation;
  int count = 9;
  TextEditingController searchTextEditingController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  var database;
  bool isDisabled = true;
  AnimationController animationController;
  //oo_ProfileImageUIJModel
  /*List<UserUserProfileReqJModel> userUserProfileReqJModelList= [
    UserUserProfileReqJModel(),
    UserUserProfileReqJModel_(),
    UserUserProfileReqJModel()
  ];*/
  AnimationController gridVItemsAnimationController;
  AnimationController listItemsanimationController;
  NavigationDataBLoC gridviewNavigationDataBLoC = NavigationDataBLoC();
  int requiredImagesLength = 9;
  BuildContext snackBarBuildContext;
  int remainingRequiredImages = 0;
  NavigationDataBLoC navigationDataBLoC_ShowProgressDialog =
      NavigationDataBLoC();
  NavigationDataBLoC wd_fb_Container_NavigationDataBLoC = NavigationDataBLoC();
  NavigationDataBLoC wd_insta_Container_NavigationDataBLoC =
      NavigationDataBLoC();
  NavigationData initialLoaderNavigationData = NavigationData();
  LoginRespModel loginRespModel;
  List<UserUserProfileReqJModel> userUserProfileReqJModelList = [];

  TextEditingController fb_TextEditingController = TextEditingController();
  TextEditingController insta_TextEditingController = TextEditingController();
  FocusNode fb_FocusNode = FocusNode();
  FocusNode insta_FocusNode = FocusNode();

  //TOP LOADER
  AnimationController _scaleFactor;
  AnimationController _positionController;
  Animation<Offset> _positionFactor;
  bool is_readyToRefresh = false;
  //END OF TOPLOADER

  bool _autoValidateF1 = false;
  GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  NavigationDataBLoC navigationDataBLoC_Loader = NavigationDataBLoC();
  NavigationDataBLoC fb_navigationDataBLoC_Loader = NavigationDataBLoC();
  CustomUserRespJModel customUserRespJModel;

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

    _scaleAnimation = Tween(begin: 0.6, end: 1.0).animate(animationController);

    gridVItemsAnimationController = AnimationController(
        duration: const Duration(milliseconds: 1300), vsync: this);

    listItemsanimationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

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
        .drive(Tween<Offset>(begin: Offset(0.0, -0.5), end: Offset(0.0, 0.8)));
    //END OF TOPLOADER

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    initialLoaderNavigationData.isShow = false;
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    //generateRequiredImageSize(context);
    fetchUserImages(context);
    getLoggedInUser_and_setUpData(context);
  }

  getLoggedInUser_and_setUpData(BuildContext context) async {
    loginRespModel = await getSessionLoginRespModel(context);
    setUpData(context);
  }

  setUpData(BuildContext context) async {
    bool isshow_loading_indicator = await show_loading_indicator(
      is_readyToRefresh,
      _positionController,
      get_default_loader_distance(),
      get_default_loader_height(),
      _scaleFactor,
    );

    set_is_readyToRefresh_value(isshow_loading_indicator);

    customUserRespJModel = await fetch_customuser_online_by_id(
        context, loginRespModel.tokenDecodedJModel.id);

    if (customUserRespJModel != null) {
      fb_TextEditingController.text = customUserRespJModel.fb_link;
      insta_TextEditingController.text = customUserRespJModel.insta_link;
    }

    //DISMISS TOP LOADER
    dismiss_loading_indicator(_scaleFactor);
    //END OF DISMISS TOP LOADER
  }

  /*generateRequiredImageSize(BuildContext context) {
    remainingRequiredImages =
        requiredImagesLength - userUserProfileReqJModelList.length;
    print('DIFF==${remainingRequiredImages}');
    if (userUserProfileReqJModelList.length < requiredImagesLength) {
      for (int i = 0; i < remainingRequiredImages; i++) {
        userUserProfileReqJModelList.add(new UserUserProfileReqJModel());
      }
      refreshGridviewNavigationDataBLoC();
    }
  }*/

  fetchUserImages(BuildContext context) async {
    String TAG = 'fetchUserImages:';
    userUserProfileReqJModelList = await fetch_user_usersProfiles(
      context,
      navigationDataBLoC_ShowProgressDialog,
      DatingAppStaticParams.default_Max_int,
    );
    remainingRequiredImages =
        requiredImagesLength - userUserProfileReqJModelList.length;
    print('DIFF==${remainingRequiredImages}');
    if (userUserProfileReqJModelList.length < requiredImagesLength) {
      for (int i = 0; i < remainingRequiredImages; i++) {
        userUserProfileReqJModelList.add(new UserUserProfileReqJModel());
      }
      refreshGridviewNavigationDataBLoC();
    }
    refreshGridviewNavigationDataBLoC();
  }

  refreshGridviewNavigationDataBLoC() {
    NavigationData navigationData = NavigationData();
    gridviewNavigationDataBLoC.dailySubTaskimages_event_sink
        .add(NavigationDataAddedEvent(navigationData));
  }

  refresh_navigationDataBLoC_UserprofilesChanged(bool isRefresh) {
    NavigationData navigationData = NavigationData();
    navigationData.isShow = isRefresh;
    widget.navigationDataBLoC_UserprofilesChanged.dailySubTaskimages_event_sink
        .add(NavigationDataAddedEvent(navigationData));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return Container(
          color: datingAppThemeChanger.selectedThemeData.cl_profile_page_bg,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              iconTheme: IconThemeData(
                  color: datingAppThemeChanger.selectedThemeData
                      .cl_appbar_icon_pink //change your color here
                  ),
              backgroundColor: DatingAppTheme.white,
              elevation: 0,
              title: Text(
                'Edit Profile',
                style: TextStyle(
                  fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  letterSpacing: -0.2,
                  color: datingAppThemeChanger
                      .selectedThemeData.mnu_darkerText_Color,
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                getMainListViewUI(datingAppThemeChanger),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
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
            ),
          ),
        );
      },
    );
  }

  Widget getMainListViewUI(DatingAppThemeChanger datingAppThemeChanger) {
    return FutureBuilder<bool>(
      future: getData(),
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
              top: 0,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            scrollDirection: Axis.vertical,
            /* Padding(
            padding: EdgeInsets.only(

              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            child:*/ /*SingleChildScrollView(
              controller: scrollController,
              physics: ClampingScrollPhysics(),
              child: Column(*/
            children: <Widget>[
              AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget child) {
                  return FadeTransition(
                    opacity: animation,
                    child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - animation.value), 0.0),
                      child: Container(
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            StreamBuilder(
                              stream: gridviewNavigationDataBLoC.stream_counter,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return gridView();
                                }
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return gridView();
                                    break;
                                  case ConnectionState.waiting:
                                    return gridView();
                                    break;
                                  case ConnectionState.active:
                                    return gridView();
                                    break;
                                  case ConnectionState.done:
                                    return gridView();
                                    break;
                                }
                              },
                            ),
                            StreamBuilder(
                              stream: navigationDataBLoC_ShowProgressDialog
                                  .stream_counter,
                              initialData: initialLoaderNavigationData,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return invisibleWidget();
                                }
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return invisibleWidget();
                                    break;
                                  case ConnectionState.waiting:
                                    return circularProgressDialog_StreamBuilder(
                                        snapshot);
                                    break;
                                  case ConnectionState.active:
                                    return circularProgressDialog_StreamBuilder(
                                        snapshot);
                                    break;
                                  case ConnectionState.done:
                                    return circularProgressDialog_StreamBuilder(
                                        snapshot);
                                    break;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget child) {
                  return FadeTransition(
                    opacity: animation,
                    child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - animation.value), 0.0),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 16),
                        child: Container(
                          child: Form(
                            autovalidate: _autoValidateF1,
                            key: _formKey1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 3),
                                  child: Text(
                                    'Facebook Link',
                                    style: datingAppThemeChanger
                                        .selectedThemeData
                                        .txt_stl_whitegrey_14_Med_pltf_grey,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Column(
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              color: DatingAppTheme.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8.0),
                                                  bottomLeft:
                                                      Radius.circular(8.0),
                                                  bottomRight:
                                                      Radius.circular(8.0),
                                                  topRight:
                                                      Radius.circular(8.0)),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    offset: const Offset(0, 2),
                                                    blurRadius: 10.0),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  top: 0,
                                                  bottom: 0),
                                              child: TextFormField(
                                                onChanged: (String txt) {
                                                  on_FbLinkChanged();
                                                },
                                                style: datingAppThemeChanger
                                                    .selectedThemeData
                                                    .txt_stl_f14w500_Med,
                                                cursorColor:
                                                    datingAppThemeChanger
                                                        .selectedThemeData
                                                        .cl_grey,
                                                decoration: InputDecoration(
                                                  icon: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .facebook,
                                                        color:
                                                            datingAppThemeChanger
                                                                .selectedThemeData
                                                                .cl_grey,
                                                        size: 20,
                                                      ),
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .instagram,
                                                        color:
                                                            datingAppThemeChanger
                                                                .selectedThemeData
                                                                .cl_grey,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                  border: InputBorder.none,
                                                  hintText: 'Facebook Link',
                                                  hintStyle: datingAppThemeChanger
                                                      .selectedThemeData
                                                      .txt_stl_hint_f14w500_Med,
                                                ),
                                                textInputAction:
                                                    TextInputAction.done,
                                                controller:
                                                    fb_TextEditingController,
                                                focusNode: fb_FocusNode,
                                                autofocus: false,
                                                onFieldSubmitted: (String val) {
                                                  on_fbLink_Validated();
                                                },
                                                validator: validateFbLink,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 3,
                                            top: 2,
                                            child: StreamBuilder(
                                              stream:
                                                  fb_navigationDataBLoC_Loader
                                                      .stream_counter,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasError)
                                                  return invisibleWidget();
                                                switch (
                                                    snapshot.connectionState) {
                                                  case ConnectionState.none:
                                                    return invisibleWidget();
                                                    break;
                                                  case ConnectionState.waiting:
                                                    return invisibleWidget();
                                                    break;
                                                  case ConnectionState.active:
                                                    return iftoshow_positionedCirclarProgressContainer(
                                                        snapshot);
                                                    break;
                                                  case ConnectionState.done:
                                                    return iftoshow_positionedCirclarProgressContainer(
                                                        snapshot);
                                                    break;
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      StreamBuilder(
                                        stream:
                                            wd_fb_Container_NavigationDataBLoC
                                                .stream_counter,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return invisibleWidget();
                                          }
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.none:
                                              return invisibleWidget();
                                              break;
                                            case ConnectionState.waiting:
                                              return invisibleWidget();
                                              break;
                                            case ConnectionState.active:
                                              return wd_Text_Widget_Form_Validator_Text(
                                                  datingAppThemeChanger,
                                                  snapshot);
                                              break;
                                            case ConnectionState.done:
                                              return wd_Text_Widget_Form_Validator_Text(
                                                  datingAppThemeChanger,
                                                  snapshot);
                                              break;
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 3),
                                  child: Text(
                                    'Instagram Link',
                                    style: datingAppThemeChanger
                                        .selectedThemeData
                                        .txt_stl_whitegrey_14_Med_pltf_grey,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Column(
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              color: DatingAppTheme.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8.0),
                                                  bottomLeft:
                                                      Radius.circular(8.0),
                                                  bottomRight:
                                                      Radius.circular(8.0),
                                                  topRight:
                                                      Radius.circular(8.0)),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    offset: const Offset(0, 2),
                                                    blurRadius: 10.0),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  top: 0,
                                                  bottom: 0),
                                              child: TextFormField(
                                                onChanged: (String txt) {
                                                  on_InstaLinkChanged();
                                                },
                                                style: datingAppThemeChanger
                                                    .selectedThemeData
                                                    .txt_stl_f14w500_Med,
                                                cursorColor:
                                                    datingAppThemeChanger
                                                        .selectedThemeData
                                                        .cl_grey,
                                                decoration: InputDecoration(
                                                  icon: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .facebook,
                                                        color:
                                                            datingAppThemeChanger
                                                                .selectedThemeData
                                                                .cl_grey,
                                                        size: 20,
                                                      ),
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .instagram,
                                                        color:
                                                            datingAppThemeChanger
                                                                .selectedThemeData
                                                                .cl_grey,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                  border: InputBorder.none,
                                                  hintText: 'Instagram Link',
                                                  hintStyle: datingAppThemeChanger
                                                      .selectedThemeData
                                                      .txt_stl_hint_f14w500_Med,
                                                ),
                                                textInputAction:
                                                    TextInputAction.done,
                                                controller:
                                                    insta_TextEditingController,
                                                focusNode: insta_FocusNode,
                                                autofocus: false,
                                                onFieldSubmitted: (String val) {
                                                  on_instaLink_Validated();
                                                },
                                                validator: validateInstaLink,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 3,
                                            top: 2,
                                            child: StreamBuilder(
                                              stream: navigationDataBLoC_Loader
                                                  .stream_counter,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasError)
                                                  return invisibleWidget();
                                                switch (
                                                    snapshot.connectionState) {
                                                  case ConnectionState.none:
                                                    return invisibleWidget();
                                                    break;
                                                  case ConnectionState.waiting:
                                                    return invisibleWidget();
                                                    break;
                                                  case ConnectionState.active:
                                                    return iftoshow_positionedCirclarProgressContainer(
                                                        snapshot);
                                                    break;
                                                  case ConnectionState.done:
                                                    return iftoshow_positionedCirclarProgressContainer(
                                                        snapshot);
                                                    break;
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      StreamBuilder(
                                        stream:
                                            wd_insta_Container_NavigationDataBLoC
                                                .stream_counter,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return invisibleWidget();
                                          }
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.none:
                                              return invisibleWidget();
                                              break;
                                            case ConnectionState.waiting:
                                              return invisibleWidget();
                                              break;
                                            case ConnectionState.active:
                                              return wd_Text_Widget_Form_Validator_Text(
                                                  datingAppThemeChanger,
                                                  snapshot);
                                              break;
                                            case ConnectionState.done:
                                              return wd_Text_Widget_Form_Validator_Text(
                                                  datingAppThemeChanger,
                                                  snapshot);
                                              break;
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
            /*),
            ),*/
          );
        }
      },
    );
  }

  Widget gridView() {
    return GridView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: List<Widget>.generate(
        userUserProfileReqJModelList.length,
        (int index) {
          int count = userUserProfileReqJModelList.length;
          Animation<double> animation =
              Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: gridVItemsAnimationController,
              curve: Interval((1 / count) * index, 1.0,
                  curve: Curves.fastOutSlowIn),
            ),
          );
          UserUserProfileReqJModel userUserProfileReqJModel =
              userUserProfileReqJModelList[index];
          gridVItemsAnimationController.forward();
          return Container(
            height: 216,
            child: ProfileImageGridViewItem(
              userUserProfileReqJModel: userUserProfileReqJModel,
              animation: animation,
              animationController: listItemsanimationController,
              functionOnClickListItems: functionOnClickListItems,
              index: index,
              onImagesPickedCallback: onImagesPickedCallback,
              snackBarBuildContext: snackBarBuildContext,
              remainingRequiredImages: remainingRequiredImages,
              navigationDataBLoC_ShowProgressDialog:
                  navigationDataBLoC_ShowProgressDialog,
            ),
          );
        },
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 0.68,
      ),
    );
  }

  Widget circularProgressDialog_StreamBuilder(
      AsyncSnapshot<NavigationData> snapshot) {
    String TAG = 'circularProgressDialog_StreamBuilder:';
    NavigationData navData = snapshot.data;
    if (navData == null) {
      print(TAG + ' navData == null');
      return invisibleWidget();
    }
    if (navData.isShow == null) {
      print(TAG + ' navData.isShow == null');
      return invisibleWidget();
    } else {
      if (navData.isShow) {
        print('RETURNIG PROGRESS DIALOG navData.isShow');
        return getCenteredCircularProgressDialog();
      } else {
        print(TAG + ' last invisibleWidget');
        return invisibleWidget();
      }
    }
  }

  Widget getCenteredCircularProgressDialog() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
      ),
    );
  }

  void functionOnClickListItems(
      UserUserProfileReqJModel profileImageGridViewItem,
      BuildContext buildContext) {}

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  onImagesPickedCallback(
    List<String> pickedFilePathList,
    UserUserProfileReqJModel userUserProfileReqJModel,
    BuildContext context,
    int index,
  ) async {
    String TAG = 'onImagesPickedCallback:';
    print(TAG);
    refreshLoader(true, navigationDataBLoC_ShowProgressDialog);
    try {
      if (pickedFilePathList.length >= requiredImagesLength) {
        for (int i = 0; i < pickedFilePathList.length; i++) {
          String imgPath = pickedFilePathList[i];
          UserUserProfileReqJModel userUserProfileReqJModel =
              userUserProfileReqJModelList[i];
          userUserProfileReqJModel.localfilepath = imgPath;
          userUserProfileReqJModel.imagename = extractFilenamefromPath(imgPath);
          userUserProfileReqJModel.issettobeupdated = true;
          userUserProfileReqJModel.isprofilepicture =
              ((userUserProfileReqJModel.isprofilepicture != null
                  ? userUserProfileReqJModel.isprofilepicture
                  : false));
          userUserProfileReqJModelList[i] = userUserProfileReqJModel;
        }

        List<UserUserProfileReqJModel> userUserProfileReqJModelListRemaining =
            [];
        for (UserUserProfileReqJModel userUserProfileReqJModel
            in userUserProfileReqJModelList) {
          if (!isStringValid(userUserProfileReqJModel.localfilepath) &&
              !isStringValid(userUserProfileReqJModel.picture)) {
            userUserProfileReqJModelListRemaining.add(userUserProfileReqJModel);
          }
        }
        remainingRequiredImages = userUserProfileReqJModelListRemaining.length;
        print('HERE 1');
        await batch_put_post_user_usersProfiles(
          context,
          null,
          userUserProfileReqJModelList,
        );

        refreshGridviewNavigationDataBLoC();
        refresh_navigationDataBLoC_UserprofilesChanged(true);
        refresh_W_Data_IsSelected_NavigationDataBLoC(
          widget.profilepic_changed_Externally_NavigationDataBLoC,
          true,
        );
      } else {
        if (pickedFilePathList.length > 0) {
          String imgPath = pickedFilePathList[0];
          UserUserProfileReqJModel userUserProfileReqJModel =
              userUserProfileReqJModelList[index];
          userUserProfileReqJModel.localfilepath = imgPath;
          userUserProfileReqJModel.imagename = extractFilenamefromPath(imgPath);
          userUserProfileReqJModel.issettobeupdated = true;
          userUserProfileReqJModel.isprofilepicture =
              ((userUserProfileReqJModel.isprofilepicture != null
                  ? userUserProfileReqJModel.isprofilepicture
                  : false));
          userUserProfileReqJModelList[index] = userUserProfileReqJModel;
          pickedFilePathList.removeAt(0);

          for (int i = 0; i < pickedFilePathList.length; i++) {
            String imgPath = pickedFilePathList[i];
            List<IndexAndUserUserProfileReqJModel>
                foundIndexAndUserUserProfileReqJModelList = [];
            for (int x = 0; x < userUserProfileReqJModelList.length; x++) {
              UserUserProfileReqJModel userUserProfileReqJModel =
                  userUserProfileReqJModelList[x];
              if (x != index &&
                  !(foundIndexAndUserUserProfileReqJModelList.length > 0) &&
                  !isStringValid(userUserProfileReqJModel.localfilepath) &&
                  !isStringValid(userUserProfileReqJModel.picture)) {
                IndexAndUserUserProfileReqJModel
                    indexAndUserUserProfileReqJModel =
                    IndexAndUserUserProfileReqJModel();
                indexAndUserUserProfileReqJModel.index = x;
                indexAndUserUserProfileReqJModel.imagePath = imgPath;
                indexAndUserUserProfileReqJModel.userUserProfileReqJModel =
                    userUserProfileReqJModel;
                foundIndexAndUserUserProfileReqJModelList
                    .add(indexAndUserUserProfileReqJModel);
              }
            }
            if (foundIndexAndUserUserProfileReqJModelList.length > 0) {
              IndexAndUserUserProfileReqJModel
                  indexAndUserUserProfileReqJModel =
                  foundIndexAndUserUserProfileReqJModelList[0];
              UserUserProfileReqJModel userUserProfileReqJModel =
                  indexAndUserUserProfileReqJModel.userUserProfileReqJModel;
              userUserProfileReqJModel.localfilepath =
                  indexAndUserUserProfileReqJModel.imagePath;
              userUserProfileReqJModel.imagename = extractFilenamefromPath(
                  indexAndUserUserProfileReqJModel.imagePath);
              userUserProfileReqJModel.issettobeupdated = true;
              userUserProfileReqJModelList[indexAndUserUserProfileReqJModel
                  .index] = userUserProfileReqJModel;
            }
          }

          List<UserUserProfileReqJModel> userUserProfileReqJModelListRemaining =
              [];
          for (UserUserProfileReqJModel userUserProfileReqJModel
              in userUserProfileReqJModelList) {
            if (!isStringValid(userUserProfileReqJModel.localfilepath) &&
                !isStringValid(userUserProfileReqJModel.picture)) {
              userUserProfileReqJModelListRemaining
                  .add(userUserProfileReqJModel);
            }
          }
          remainingRequiredImages =
              userUserProfileReqJModelListRemaining.length;
          print('HERE 2');
          bool isbatch_put_post_user_usersProfiles =
              await batch_put_post_user_usersProfiles(
            context,
            null,
            userUserProfileReqJModelList,
          );
          refreshGridviewNavigationDataBLoC();
          refresh_navigationDataBLoC_UserprofilesChanged(true);
          refresh_W_Data_IsSelected_NavigationDataBLoC(
            widget.profilepic_changed_Externally_NavigationDataBLoC,
            true,
          );
        }
      }
      refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
    } catch (error) {
      print(TAG + ' error==');
      print(error.toString());
      refreshLoader(false, navigationDataBLoC_ShowProgressDialog);
    }
  }

  void dispose() {
    listItemsanimationController.dispose();
    gridVItemsAnimationController.dispose();
    super.dispose();
  }

  //ON CHANGES
  on_FbLinkChanged() {
    validateFbLink(fb_TextEditingController.text);
  }

  on_InstaLinkChanged() {
    validateInstaLink(insta_TextEditingController.text);
  }

  //END OF ON CHANGES
  //VALIDATORS
  String validateFbLink(String strVal) {
    if (!isStringValid(fb_TextEditingController.text)) {
      refresh_wd_ValidationField_Container_NavigationDataBLoC(
          wd_fb_Container_NavigationDataBLoC, false, 'invalid link');
      return null;
    } else {
      //IS VALID
      RegExp regex = new RegExp(get_Url_Pattern());
      if (!regex.hasMatch(fb_TextEditingController.text)) {
        refresh_wd_ValidationField_Container_NavigationDataBLoC(
            wd_fb_Container_NavigationDataBLoC, false, 'invalid link');
        return null;
      }
    }
    refresh_wd_ValidationField_Container_NavigationDataBLoC(
        wd_fb_Container_NavigationDataBLoC, true, null);
    return null;
  }

  bool is_FbLink_Valid() {
    if (!isStringValid(fb_TextEditingController.text)) {
      refresh_wd_ValidationField_Container_NavigationDataBLoC(
          wd_fb_Container_NavigationDataBLoC, false, 'invalid link');
      return false;
    } else {
      //IS VALID
      RegExp regex = new RegExp(get_Url_Pattern());
      if (!regex.hasMatch(fb_TextEditingController.text)) {
        refresh_wd_ValidationField_Container_NavigationDataBLoC(
            wd_fb_Container_NavigationDataBLoC, false, 'invalid link');
        return false;
      }
    }
    refresh_wd_ValidationField_Container_NavigationDataBLoC(
        wd_fb_Container_NavigationDataBLoC, true, null);
    return true;
  }

  String validateInstaLink(String strVal) {
    if (!isStringValid(insta_TextEditingController.text)) {
      refresh_wd_ValidationField_Container_NavigationDataBLoC(
          wd_insta_Container_NavigationDataBLoC, false, 'invalid link');
      return null;
    } else {
      //IS VALID
      RegExp regex = new RegExp(get_Url_Pattern());
      if (!regex.hasMatch(insta_TextEditingController.text)) {
        refresh_wd_ValidationField_Container_NavigationDataBLoC(
            wd_insta_Container_NavigationDataBLoC, false, 'invalid link');
        return null;
      }
    }
    refresh_wd_ValidationField_Container_NavigationDataBLoC(
        wd_insta_Container_NavigationDataBLoC, true, null);
    return null;
  }

  bool is_InstaLink_Valid() {
    if (!isStringValid(insta_TextEditingController.text)) {
      refresh_wd_ValidationField_Container_NavigationDataBLoC(
          wd_insta_Container_NavigationDataBLoC, false, 'invalid link');
      return false;
    } else {
      //IS VALID
      RegExp regex = new RegExp(get_Url_Pattern());
      if (!regex.hasMatch(insta_TextEditingController.text)) {
        refresh_wd_ValidationField_Container_NavigationDataBLoC(
            wd_insta_Container_NavigationDataBLoC, false, 'invalid link');
        return false;
      }
    }
    refresh_wd_ValidationField_Container_NavigationDataBLoC(
        wd_insta_Container_NavigationDataBLoC, true, null);
    return true;
  }
  //END OF VALIDATORS

  //PATCH CUSTOMUSER
  on_instaLink_Validated() async {
    if (is_InstaLink_Valid() && customUserRespJModel != null) {
      CustomUserReqJModel customUserReqJModel = CustomUserReqJModel();
      customUserReqJModel.id = customUserRespJModel.id;
      customUserReqJModel.insta_link = insta_TextEditingController.text;
      CustomUserRespJModel updated_CustomUserRespJModel =
          await post_put_customuser(
        context,
        snackBarBuildContext,
        navigationDataBLoC_Loader,
        customUserReqJModel,
      );
    }
  }

  on_fbLink_Validated() async {
    if (is_FbLink_Valid() && customUserRespJModel != null) {
      CustomUserReqJModel customUserReqJModel = CustomUserReqJModel();
      customUserReqJModel.id = customUserRespJModel.id;
      customUserReqJModel.fb_link = fb_TextEditingController.text;
      CustomUserRespJModel updated_CustomUserRespJModel =
          await post_put_customuser(
        context,
        snackBarBuildContext,
        fb_navigationDataBLoC_Loader,
        customUserReqJModel,
      );
    }
  }

  //END OF PATCH CUSTOMUSER

  //SAVE AND UPLOAD
  saveAndUpload_MatchData(BuildContext context) async {
    bool isDataValid = true;
    refreshLoader(true, navigationDataBLoC_Loader);

    if (_formKey1.currentState.validate()) {
      _formKey1.currentState.save();
      setState(() {
        _autoValidateF1 = true;
      });
    } else {
      _formKey1.currentState.save();
      setState(() {
        _autoValidateF1 = true;
      });
      isDataValid = false;
    }

    bool fbLink_Valid = is_FbLink_Valid();
    if (!fbLink_Valid) {
      isDataValid = false;
    }

    bool instaLink_Valid = is_InstaLink_Valid();
    if (!instaLink_Valid) {
      instaLink_Valid = false;
    }

    if (!isDataValid) {
      refreshLoader(false, navigationDataBLoC_Loader);
      return false;
    }
  }
  //END OF SAVE AND UPLOAD

  //POSITIONED LOADER set_is_readyToRefresh
  set_is_readyToRefresh_value(
    bool isshow_loading_indicator,
  ) {
    if (isshow_loading_indicator != null) {
      is_readyToRefresh = isshow_loading_indicator;
    }
  }
//END OF POSITIONED LOADER set_is_readyToRefresh

//WIDGETS
  Widget iftoshow_positionedCirclarProgressContainer(
      AsyncSnapshot<NavigationData> snapshot) {
    NavigationData navData = snapshot.data;
    if (navData.isShow != null && navData.isShow) {
      return positionedCirclarProgressContainer();
    } else {
      return invisibleWidget();
    }
  }

  Widget positionedCirclarProgressContainer() {
    return Container(
      width: 15,
      height: 15,
      child: Theme(
        data: ThemeData(
          accentColor: DatingAppTheme.pltf_pink,
        ),
        child: CircularProgressIndicator(
          strokeWidth: 1,
        ),
      ),
    );
  }
//END OF WIDGETS

}
