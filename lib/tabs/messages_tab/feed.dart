import 'dart:async';
import 'dart:io';

import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleBLoC.dart';
import 'package:dating_app/Bloc/Streams/KeyBoardVisiblility/KeyBoardVisibleEvent.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/functions/data_fetching/fetch_feeds_online.dart';
import 'package:dating_app/CustomWidgets/feeds/ImagePostFromFeedsRespJModel.dart';
import 'package:dating_app/Data/postsdata.dart';
import 'package:dating_app/Models/Chopper/FeedsImagesResp.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/feeds/FeedsReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/feeds/FeedsRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/FeedsListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/Models/Chopper/FeedsResp.dart';
import 'package:chopper/chopper.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:provider/provider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:after_layout/after_layout.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed>
    with TickerProviderStateMixin, AfterLayoutMixin<Feed> {
  //FIELD VARIABLES
  List<ImagePostFromFeedsRespJModel> feedData = [];
  LoginRespModel loginRespJModel;

  FeedsListRespJModel current_FeedsListRespJModel;
  List<FeedsRespJModel> feedsRespJModelList = [];

  RefreshController _refreshController = RefreshController();
  ScrollController scrollController = ScrollController();
  //END OF FIELD DVARIALBES

  //TOP LOADER
  AnimationController _scaleFactor;
  AnimationController _positionController;
  Animation<Offset> _positionFactor;
  bool is_readyToRefresh = false;
  String current_PageUrl;

  //END OF TOPLOADER

  //STATE HOLDERS
  NavigationDataBLoC feeds_changed_NavigationDataBLoC = NavigationDataBLoC();
  KeyBoardVisibleBLoC keyBoardVisibleBLoC = KeyBoardVisibleBLoC();
  bool initial_keyboardShown_isvisible = false;
  NavigationDataBLoC noTicketsAvailableDailySubTaskImagesBLoC =
      NavigationDataBLoC();
  //END OF STATE HOLDERS

  @override
  void initState() {
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
    addListeners();
    getLoggedInUser_and_setUpData(context);
  }

  getLoggedInUser_and_setUpData(BuildContext context) async {
    loginRespJModel = await getSessionLoginRespModel(context);
    initial_AfterFirstLayout_OnlineFetch(_refreshController);
    setUpData();
  }

  addListeners() {
    KeyboardVisibility.onChange.listen(
      (bool visible) {
        initial_keyboardShown_isvisible = visible;
        keyBoardVisibleBLoC.keyboard_visible_event_sink
            .add(ToggleKeyBoardVisEvent(visible));
      },
    );
  }

  setUpData() {}

  //STATE CHANGES

  refreshifToshowNoTicketAvailable() {
    NavigationData navigationData = NavigationData();
    navigationData.feedsRespJModelList = feedsRespJModelList;
    navigationData.isFromTrigger = true;
    refresh_W_Data_NavigationDataBLoC(
      noTicketsAvailableDailySubTaskImagesBLoC,
      navigationData,
    );
  }
  //END OF STATE CHANGES

  //SMART REFRESHER FUNCTIONS
  //ONREFRESH
  Future<bool> onRefresh_fetchErpTickets_OnlineFetch(
      BuildContext context) async {
    String TAG = 'onRefresh_fetchErpTickets_OnlineFetch:';
    _refreshController.requestRefresh();
    current_FeedsListRespJModel = await fetch_feeds_online_by_userid_limit(
      context,
      DatingAppStaticParams.default_Query_Limit,
      loginRespJModel.tokenDecodedJModel.id,
    );
    if (current_FeedsListRespJModel != null) {
      feedsRespJModelList = current_FeedsListRespJModel.results;
      feedData = _generateFeedsResp(feedsRespJModelList);
      _refreshController.refreshCompleted();
      refreshifToshowNoTicketAvailable();
      refresh_WO_Data_NavigationDataBLoC(feeds_changed_NavigationDataBLoC);
    } else {
      feedsRespJModelList = [];
      feedData = _generateFeedsResp(feedsRespJModelList);
      _refreshController.refreshCompleted();
      refreshifToshowNoTicketAvailable();
      refresh_WO_Data_NavigationDataBLoC(feeds_changed_NavigationDataBLoC);
    }
    return true;
  }

  //ONLOADING
  Future<bool> onLoading_fetchErpTickets_OnlineFetch(
      BuildContext context) async {
    String TAG = 'onLoading_fetchErpTickets_OnlineFetch:';
    _refreshController.requestLoading();
    if (current_FeedsListRespJModel != null) {
      String nextPageUrl = current_FeedsListRespJModel.next;
      print(TAG + ' nextPageUrl==${nextPageUrl}');
      if (isStringValid(nextPageUrl) &&
          (!isStringValid(current_PageUrl) ||
              (isStringValid(current_PageUrl) &&
                  nextPageUrl != current_PageUrl))) {
        current_FeedsListRespJModel = await fetch_feeds_load_next(
          context,
          nextPageUrl,
        );
        if (current_FeedsListRespJModel != null) {
          current_PageUrl = nextPageUrl;
        }
        add_FromFetched();
      } else {
        _refreshController.loadComplete();
        refreshifToshowNoTicketAvailable();
      }
    } else {
      current_FeedsListRespJModel = await fetch_feeds_online_by_userid_limit(
        context,
        DatingAppStaticParams.default_Query_Limit,
        loginRespJModel.tokenDecodedJModel.id,
      );
      add_FromFetched();
    }
    return true;
  }

  add_FromFetched() {
    if (current_FeedsListRespJModel != null) {
      feedsRespJModelList.addAll(current_FeedsListRespJModel.results);
      feedData.addAll(_generateFeedsResp(current_FeedsListRespJModel.results));
      _refreshController.loadComplete();
      refreshifToshowNoTicketAvailable();
      refresh_WO_Data_NavigationDataBLoC(feeds_changed_NavigationDataBLoC);
    } else {
      _refreshController.loadComplete();
      refreshifToshowNoTicketAvailable();
    }
  }
  //END OF SMART REFRESHER FUNCTIONS

  @override
  Widget build(BuildContext context) {
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return Scaffold(
          backgroundColor: DatingAppTheme.transparent,
          body: Stack(children: <Widget>[
            getMainListViewUI(datingAppThemeChanger),
            StreamBuilder(
              stream: keyBoardVisibleBLoC.stream_counter,
              initialData: initial_keyboardShown_isvisible,
              builder: (context, snapshot) {
                return ifToshownoTicketsAvailableWidget_StreamBuilder(snapshot);
              },
            ),
          ]),
          /*RefreshIndicator(
        onRefresh: _refresh,
        child: buildFeed(),
      ),*/
          /*ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          Map post = posts[index];
          return PostItem(
            img: post['img'],
            name: post['name'],
            dp: post['dp'],
            time: post['time'],
          );
        },
      ),*/

          /*child: Center(
          child: new Text(
        "FEEDS TAB",
        style: TextStyle(fontSize: 20.0),
      )),*/
        );
      },
    );
  }

  Widget getMainListViewUI(DatingAppThemeChanger datingAppThemeChanger) {
    return Theme(
      data: ThemeData(primaryColor: DatingAppTheme.pltf_pink),
      child: SmartRefresher(
        onRefresh: () async {
          await onRefresh_fetchErpTickets_OnlineFetch(context);
          _refreshController.refreshCompleted();
        },
        enablePullUp: true,
        onLoading: () async {
          await onLoading_fetchErpTickets_OnlineFetch(context);
          _refreshController.loadComplete();
        },
        controller: _refreshController,
        enablePullDown: true,
        header: WaterDropMaterialHeader(
            backgroundColor:
                datingAppThemeChanger.selectedThemeData.bg_WaterDrop,
            color: DatingAppTheme.pltf_pink,
            distance: 30),
        footer: ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          textStyle:
              datingAppThemeChanger.selectedThemeData.txt_stl_whitegrey_13_Book,
          completeDuration: Duration(milliseconds: 500),
          loadingIcon: SizedBox(
            width: 25.0,
            height: 25.0,
            child: Platform.isIOS
                ? CupertinoActivityIndicator()
                : CircularProgressIndicator(strokeWidth: 2.0),
          ),
          idleIcon: Icon(
            Icons.sync,
            color: datingAppThemeChanger.selectedThemeData.cl_white_grey,
          ),
          canLoadingIcon: Icon(
            Icons.arrow_upward,
            color: datingAppThemeChanger.selectedThemeData.cl_white_grey,
          ),
        ),
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 20),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            //OTHER FIELDS
            StreamBuilder(
              stream: feeds_changed_NavigationDataBLoC.stream_counter,
              builder: (context, snapshot) {
                return ListView(
                  shrinkWrap: true,
                  children: feedData,
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
          ],
          //),
        ),
      ),
    );
  }

  Widget ifToshownoTicketsAvailableWidget_StreamBuilder(
      AsyncSnapshot<bool> keyBoardVisible_snapshot) {
    return StreamBuilder(
      stream: noTicketsAvailableDailySubTaskImagesBLoC.stream_counter,
      builder: (context, snapshot) {
        NavigationData navData = snapshot.data;
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
            return ifToshownoTicketsAvailableWidget(
              navData,
              keyBoardVisible_snapshot,
            );
            break;
          case ConnectionState.done:
            return ifToshownoTicketsAvailableWidget(
              navData,
              keyBoardVisible_snapshot,
            );
            break;
        }
      },
    );
  }

  Widget ifToshownoTicketsAvailableWidget(
    NavigationData navdata,
    AsyncSnapshot<bool> keyBoardVisible_snapshot,
  ) {
    if (navdata != null && navdata.feedsRespJModelList != null) {
      if (navdata.feedsRespJModelList.length > 0) {
        return invisibleWidget();
      } else {
        if (navdata.isFromTrigger != null && navdata.isFromTrigger) {
          String msg = 'No feeds available';
          return notAvailableWidget_W_KeyboardVisibility_Snapshot(
              msg, keyBoardVisible_snapshot);
        } else {
          return invisibleWidget();
        }
      }
    } else {
      return invisibleWidget();
    }
  }

  _loadFeed() async {
    print('_loadFeed');

    FeedsReqJModel feedsResp = FeedsReqJModel();
    feedsResp.message = 'None';
    feedsResp.success = false;
    feedsResp.userid = 83;

    print('going to response');
    //Response<BuiltList<FeedsResp>> response;
    Response response = await Provider.of<PostApiService>(context)
        .getfeedsprocess_by_FeedsReqJModel(feedsResp);
    print('response.body===');
    print(response.body);
    print('response.bodyString===');
    print(response.bodyString);
    try {
      if (response != null) {
        List<FeedsRespJModel> feedsRespList = List<FeedsRespJModel>.from(
            response.body.map((model) => FeedsRespJModel.fromJson(model)));
        List<ImagePostFromFeedsRespJModel> listOfPosts =
            _generateFeedsResp(feedsRespList);
        setState(() {
          feedData = listOfPosts;
        });
      } else {
        _getFeed();
      }
    } catch (error) {
      print('error==');
      print(error.toString());
    }
  }

  List<ImagePostFromFeedsRespJModel> _generateFeedsResp(
      List<FeedsRespJModel> feedDataList) {
    List<ImagePostFromFeedsRespJModel> listOfPosts = [];

    for (var postData in feedDataList) {
      listOfPosts
          .add(ImagePostFromFeedsRespJModel.fromFeedsRespJModel(postData));
    }

    return listOfPosts;
  }

  _getFeed() async {
    print("Staring getFeed");

    FeedsReqJModel feedsResp = FeedsReqJModel();
    feedsResp.message = 'None';
    feedsResp.success = false;
    feedsResp.userid = 83;

    try {
      Response response = await Provider.of<PostApiService>(context)
          .getfeedsprocess_by_FeedsReqJModel(feedsResp);
      print('response.body==');
      print(response.body);
      if (response != null) {
        List<FeedsRespJModel> feedsRespList = List<FeedsRespJModel>.from(
            response.body.map((model) => FeedsRespJModel.fromJson(model)));
        List<ImagePostFromFeedsRespJModel> listOfPosts =
            _generateFeedsResp(feedsRespList);
        setState(() {
          feedData = listOfPosts;
        });
      } else {
        _getFeed();
      }
    } catch (error) {
      print('error =$error');
    }
  }

  Future<Null> _refresh() async {
    await _getFeed();
    setState(() {});
    return;
  }

  buildFeed() {
    if (feedData == null || !(feedData.length > 0)) {
      _loadFeed();
      return Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator());
    } else {
      return ListView(
        children: feedData,
      );
    }
  }

  Future<Size> getImageSizeFromUrl(String imageUrl) {
    Completer<Size> completer = Completer();
    Image image = Image.network(imageUrl);
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }

  getImageSize(FeedsImagesResp feedsImagesResp) {
    var sizeFuture = getImageSizeFromUrl(feedsImagesResp.image_path);
    sizeFuture.then((value) {
      print('getImageSize value= $value');
      final feedsImagesResp_builder = feedsImagesResp.toBuilder();
      feedsImagesResp_builder.image_height = value.height;
      feedsImagesResp_builder.build();
    }, onError: (error) {
      print('completed with error $error');
    });
  }
}
