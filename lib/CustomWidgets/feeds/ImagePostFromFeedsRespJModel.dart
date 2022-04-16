import 'package:dating_app/Models/JsonSerializable/Api/from/feeds/FeedsImagesRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/feeds/FeedsRespJModel.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/Models/Chopper/FeedsImagesResp.dart';
import 'package:dating_app/UI/Presentation/Icons/my_flutter_app_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ImagePostFromFeedsRespJModel extends StatefulWidget {
  const ImagePostFromFeedsRespJModel({
    this.mediaUrl,
    this.username,
    this.location,
    this.description,
    this.likes,
    this.postId,
    this.ownerId,
    this.feedDate,
    this.feedsResp,
  });

  factory ImagePostFromFeedsRespJModel.fromFeedsRespJModel(FeedsRespJModel feedsResp) {
    return ImagePostFromFeedsRespJModel(
      username: feedsResp.message,
      location: 'New Event!',
      mediaUrl:
          "http://192.168.88.207:8000/media/files/FeedsImages/pengin_coder.png",
      likes: null,
      description: feedsResp.message,
      ownerId: feedsResp.message,
      postId: feedsResp.message,
      feedDate: ((feedsResp.created_at!=null?getDateFormat_MMMddcmyyyy().format(feedsResp.created_at):'')),
      feedsResp: feedsResp,
    );
  }

  int getLikeCount(var likes) {
    if (likes == null) {
      return 0;
    }
// issue is below
    var vals = likes.values;
    int count = 0;
    for (var val in vals) {
      if (val == true) {
        count = count + 1;
      }
    }

    return count;
  }

  final String mediaUrl;
  final String username;
  final String location;
  final String description;
  final likes;
  final String postId;
  final String ownerId;
  final String feedDate;
  final FeedsRespJModel feedsResp;

  _ImagePostFromFeedsRespJModel createState() => _ImagePostFromFeedsRespJModel(
        mediaUrl: this.mediaUrl,
        username: this.username,
        location: this.location,
        description: this.description,
        likes: this.likes,
        likeCount: getLikeCount(this.likes),
        ownerId: this.ownerId,
        postId: this.postId,
        feedDate: this.feedDate,
        feedsResp: this.feedsResp,
      );
}

class _ImagePostFromFeedsRespJModel extends State<ImagePostFromFeedsRespJModel> {
  final String mediaUrl;
  final String username;
  final String location;
  final String description;
  Map likes;
  int likeCount;
  final String postId;
  bool liked;
  final String ownerId;
  final String feedDate;
  final FeedsRespJModel feedsResp;
  bool showHeart = false;
  //double sizedBoximageHeight = 200;
  //final _counterBLoC = CounterBLoC();

  TextStyle boldStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  _ImagePostFromFeedsRespJModel({
    this.mediaUrl,
    this.username,
    this.location,
    this.description,
    this.likes,
    this.postId,
    this.likeCount,
    this.ownerId,
    this.feedDate,
    this.feedsResp,
  });

  GestureDetector buildLikeIcon() {
    Color color;
    IconData icon;

    if (true) {
      color = Colors.pink;
      icon = FontAwesomeIcons.solidHeart;
    } else {
      icon = FontAwesomeIcons.heart;
    }

    return GestureDetector(
        child: Icon(
          icon,
          size: 25.0,
          color: color,
        ),
        onTap: () {
          _likePost(postId);
        });
  }

  Widget buildLikeableImage(BuildContext context) {
    List<FeedsImagesRespJModel> feedsImagesRespList = feedsResp.feeds_images;

    return GestureDetector(
      onDoubleTap: () => _likePost(postId),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          //FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: mediaUrl),
          /*CachedNetworkImage(
            imageUrl: mediaUrl,
            fit: BoxFit.fitWidth,
            placeholder: (context, url) => loadingPlaceHolder,
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),*/
          SizedBox(
            height: 200,
            child: new Swiper(
              itemBuilder: (BuildContext context, int index) {
                FeedsImagesRespJModel feedsImagesResp = feedsImagesRespList[index];
                //return new Image.network("http://via.placeholder.com/350x150",fit: BoxFit.fill,);
                return new CachedNetworkImage(
                  //imageUrl: mediaUrl,
                  //imageUrl: 'http://192.168.88.212:8000/media/files/FeedsImages/Backpack.jpg',
                  imageUrl: feedsImagesResp.image_path,
                  fit: BoxFit.fitWidth,
                  placeholder: (context, url) => loadingPlaceHolder,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                );
              },
              itemCount: feedsImagesRespList.length,
              pagination: new SwiperPagination(),
              control: null,
            ),
          ),
          /*showHeart
              ? Positioned(
                  child: Opacity(
                      opacity: 0.85,
                      child: Icon(
                        FontAwesomeIcons.solidHeart,
                        size: 80.0,
                        color: Colors.white,
                      )),
                )
              : Container()*/
        ],
      ),
    );

    //TRIALS WITH BLOC
    /*print('buildLikeableImage');
    List<FeedsImagesResp> feedsImagesRespList = feedsResp.feedsImages.asList();*/

    /*if (feedsImagesRespList.length > 0) {
      FeedsImagesResp feedsImagesRespFirst = feedsImagesRespList[0];
      print('height=${feedsImagesRespFirst.image_height}');
      //submitImageUrl(context, feedsImagesRespFirst.image_path);
      _counterBLoC.counter_event_sink
          .add(IncrementEvent(feedsImagesRespFirst.image_path, context,feedsImagesRespFirst.image_height));
    }*/

    /* return GestureDetector(
      onDoubleTap: () => _likePost(postId),
      child: StreamBuilder(
        stream: _counterBLoC.stream_counter,
        initialData: 200.0,
        builder: (context, snapshot) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              */ /*Center(
                child:*/ /*
              */ /* Text(snapshot.data.toString()),
                );
              }
          )
          StreamBuilder(
            // Wrap our widget with a StreamBuilder
            stream: getImageHeightBloc.getCount, // pass our Stream getter here
            initialData: 0, // provide an initial data
            builder: (context, snapshot) =>*/ /*
              SizedBox(
                height: snapshot.data,
                child: new Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    FeedsImagesResp feedsImagesResp =
                        feedsImagesRespList[index];
                    return new CachedNetworkImage(
                      imageUrl: feedsImagesResp.image_path,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => loadingPlaceHolder,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    );
                  },
                  itemCount: feedsImagesRespList.length,
                  pagination: new SwiperPagination(),
                  control: null,
                  onIndexChanged: (index) =>
                      onPagerIndexChanged(index, feedsImagesRespList, context),
                ),
              ),
              //Text('${snapshot.data}'), // access the data in our Stream here

              */ /*SizedBox(
            height: sizedBoximageHeight,
            child: new Swiper(
              itemBuilder: (BuildContext context, int index) {
                FeedsImagesResp feedsImagesResp = feedsImagesRespList[index];
                return new CachedNetworkImage(
                  imageUrl: feedsImagesResp.image_path,
                  fit: BoxFit.fitWidth,
                  placeholder: (context, url) => loadingPlaceHolder,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                );
              },
              itemCount: feedsImagesRespList.length,
              pagination: new SwiperPagination(),
              control: null,
            ),
          ),*/ /*
              Text(
                'height=${snapshot.data}',
                style: new TextStyle(color: Colors.red),
              ),
            ],
          );
        },
      ),
    );*/

    /*return BlocListener<WeatherBloc, WeatherState>(
      listener: (context, state) {
        if (state is WeatherError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, _state) {
          if (_state is WeatherInitial) {
            return Text('WeatherInitial');
          } else if (_state is WeatherLoading) {
            return Text('WeatherLoading');
          } else if (_state is WeatherLoaded) {
            return new GestureDetector(
              onDoubleTap: () => _likePost(postId),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SizedBox(
                    height: _state.imageSize.height / 2,
                    child: new Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        FeedsImagesResp feedsImagesResp =
                            feedsImagesRespList[index];
                        return new CachedNetworkImage(
                          imageUrl: feedsImagesResp.image_path,
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) => loadingPlaceHolder,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        );
                      },
                      itemCount: feedsImagesRespList.length,
                      pagination: new SwiperPagination(),
                      control: null,
                    ),
                  ),
                  Text('height=${_state.imageSize.height}'),
                ],
              ),
            );
          } else if (_state is WeatherError) {
            return Text('WeatherError');
          } else {
            return Text('NOT LOADED');
          }
        },
      ),
    );*/

    /* return GestureDetector(
      onDoubleTap: () => _likePost(postId),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
//          FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: mediaUrl),
          */ /*CachedNetworkImage(
            imageUrl: mediaUrl,
            fit: BoxFit.fitWidth,
            placeholder: (context, url) => loadingPlaceHolder,
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),*/ /*
          SizedBox(
            height: 400,
            child: new Swiper(
              itemBuilder: (BuildContext context, int index) {
                FeedsImagesResp feedsImagesResp = feedsImagesRespList[index];
                //return new Image.network("http://via.placeholder.com/350x150",fit: BoxFit.fill,);
                return new CachedNetworkImage(
                  //imageUrl: mediaUrl,
                  //imageUrl: 'http://192.168.88.212:8000/media/files/FeedsImages/Backpack.jpg',
                  imageUrl: feedsImagesResp.image_path,
                  fit: BoxFit.fitWidth,
                  placeholder: (context, url) => loadingPlaceHolder,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                );
              },
              itemCount: feedsImagesRespList.length,
              pagination: new SwiperPagination(),
              control: null,
            ),
          ),
          showHeart
              ? Positioned(
                  child: Opacity(
                      opacity: 0.85,
                      child: Icon(
                        FontAwesomeIcons.solidHeart,
                        size: 80.0,
                        color: Colors.white,
                      )),
                )
              : Container()
        ],
      ),
    );*/
  }

/*  void submitImageUrl(BuildContext context, String imageUrl) {
    var weatherBloc = BlocProvider.of<WeatherBloc>(context);
    weatherBloc.add(GetWeather(imageUrl));
  }*/

  GestureDetector buildLikeableImageOLD() {
    List<FeedsImagesRespJModel> feedsImagesRespList = feedsResp.feeds_images;

    if (feedsImagesRespList.length > 0) {
      FeedsImagesRespJModel feedsImagesRespFirst = feedsImagesRespList[0];
    }

    return GestureDetector(
      onDoubleTap: () => _likePost(postId),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
//          FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: mediaUrl),
          /*CachedNetworkImage(
            imageUrl: mediaUrl,
            fit: BoxFit.fitWidth,
            placeholder: (context, url) => loadingPlaceHolder,
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),*/
          SizedBox(
            height: 400,
            child: new Swiper(
              itemBuilder: (BuildContext context, int index) {
                FeedsImagesRespJModel feedsImagesResp = feedsImagesRespList[index];
                //return new Image.network("http://via.placeholder.com/350x150",fit: BoxFit.fill,);
                return new CachedNetworkImage(
                  //imageUrl: mediaUrl,
                  //imageUrl: 'http://192.168.88.212:8000/media/files/FeedsImages/Backpack.jpg',
                  imageUrl: feedsImagesResp.image_path,
                  fit: BoxFit.fitWidth,
                  placeholder: (context, url) => loadingPlaceHolder,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                );
              },
              itemCount: feedsImagesRespList.length,
              pagination: new SwiperPagination(),
              control: null,
            ),
          ),
          showHeart
              ? Positioned(
                  child: Opacity(
                      opacity: 0.85,
                      child: Icon(
                        FontAwesomeIcons.solidHeart,
                        size: 80.0,
                        color: Colors.white,
                      )),
                )
              : Container()
        ],
      ),
    );
  }

  Future<String> myFutureMethod() async {
    String json =
        '{"photoUrl":"http://192.168.88.212:8000/media/files/FeedsImages/SAM_1232.JPG","username":"denn"}';
    return json;
  }

  buildPostHeader({String ownerId}) {
    if (ownerId == null) {
      return Text("owner error");
    }
    //return Text("owner error");

    return FutureBuilder(
        future: myFutureMethod(),
        /* future: Firestore.instance
            .collection('insta_users')
            .document(ownerId)
            .get(),*/
        builder: (context, snapshot) {
          String imageUrl = " ";
          String username = "  ";

          imageUrl =
              //"http://192.168.88.212:8000/media/files/FeedsImages/penguin.png";
              "https://i.picsum.photos/id/0/5616/3744.jpg";
          username = "DTN Connections LTD";
          /*if (snapshot.data != null) {
            imageUrl = snapshot.data.data['photoUrl'];
            username = snapshot.data.data['username'];
          }*/

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(imageUrl),
              backgroundColor: Colors.grey,
            ),
            title: GestureDetector(
              child: Text(
                username,
                style: new TextStyle(
                    color: Colors.black,
                    fontFamily: 'GothamRounded-Book',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {
                openProfile(context, ownerId);
              },
            ),
            subtitle: Text(this.location,
                style: new TextStyle(
                  color: MyFlutterApp.colorDarkGrey,
                  fontFamily: 'GothamRounded-Book',
                  fontSize: 14,
                )),
            trailing: const Icon(Icons.more_horiz),
          );
        });
  }

  Container loadingPlaceHolder = Container(
    height: 400.0,
    child: Center(child: CircularProgressIndicator()),
  );

  @override
  Widget build(BuildContext context) {
    //liked = (likes[googleSignIn.currentUser.id.toString()] == true);

    return
        /*new BlocProvider(
      builder: (context) => WeatherBloc(ImagePostFromFeedsRespJModelBlocActions()),
      child:*/
        Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(ownerId: ownerId),
        buildLikeableImage(context),
        /*Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(left: 20.0, top: 40.0)),
            buildLikeIcon(),
            Padding(padding: const EdgeInsets.only(right: 20.0)),
            GestureDetector(
                child: const Icon(
                  FontAwesomeIcons.comment,
                  size: 25.0,
                ),
                onTap: () {
                  goToComments(
                      context: context,
                      postId: postId,
                      ownerId: ownerId,
                      mediaUrl: mediaUrl);
                }),
          ],
        ),*/
        Padding(padding: const EdgeInsets.only(top: 10.0)),
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    MyFlutterApp.map_marker,
                    size: 14,
                    color: MyFlutterApp.colorGrey,
                  ),
                  /*OMIcons.locationOn,textDirection: TextDirection.ltr,
                  color: Colors.grey,*/
                  Text(
                    "$likeCount miles away",
                    style: new TextStyle(
                      color: MyFlutterApp.colorDarkGrey1,
                      fontFamily: 'GothamRounded-Light',
                      fontSize: 16,
                    ),
                    //style: boldStyle,
                  ),
                ],
              ),
            )
          ],
        ),
        Padding(padding: const EdgeInsets.only(top: 5.0)),
        Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "$feedDate ",
                  style: new TextStyle(
                    color: MyFlutterApp.colorDarkGrey,
                    fontFamily: 'GothamRounded-Book',
                    fontSize: 11,
                  ),
                  //"$username ",
                  //style: boldStyle,
                )),
            //Expanded(child: Text(description)),
          ],
        )
      ],
      // ),
    );
  }

  onPagerIndexChanged(int index, List<FeedsImagesResp> feedsImagesRespList,
      BuildContext context) {
    /*print('index==$index');
    FeedsImagesResp currentFeedsImagesResp = feedsImagesRespList[index];
    _counterBLoC.counter_event_sink.add(IncrementEvent(currentFeedsImagesResp.image_path, context,currentFeedsImagesResp.image_height));*/
  }

  @override
  dispose() {
    super.dispose();
    //_counterBLoC.dispose();
  }

  void _likePost(String postId2) {
    /*var userId = googleSignIn.currentUser.id;
    bool _liked = likes[userId] == true;*/
    bool _liked = true;

    if (_liked) {
      print('removing like');
      /*reference.document(postId).updateData({
        'likes.$userId': false
        //firestore plugin doesnt support deleting, so it must be nulled / falsed
      });*/

      setState(() {
        likeCount = likeCount - 1;
        liked = false;
        //likes[userId] = false;
      });

      removeActivityFeedItem();
    }

    if (!_liked) {
      print('liking');
      //reference.document(postId).updateData({'likes.$userId': true});

      addActivityFeedItem();

      setState(() {
        likeCount = likeCount + 1;
        liked = true;
        // likes[userId] = true;
        showHeart = true;
      });
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  void addActivityFeedItem() {
    /* Firestore.instance
        .collection("insta_a_feed")
        .document(ownerId)
        .collection("items")
        .document(postId)
        .setData({
      "username": currentUserModel.username,
      "userId": currentUserModel.id,
      "type": "like",
      "userProfileImg": currentUserModel.photoUrl,
      "mediaUrl": mediaUrl,
      "timestamp": DateTime.now().toString(),
      "postId": postId,
    });*/
  }

  void removeActivityFeedItem() {
    /*Firestore.instance
        .collection("insta_a_feed")
        .document(ownerId)
        .collection("items")
        .document(postId)
        .delete();*/
  }
}

class ImagePostFromFeedsRespJModelFromId extends StatelessWidget {
  final String id;

  const ImagePostFromFeedsRespJModelFromId({this.id});

  getImagePostFromFeedsRespJModel() async {
    /*var document =
    await Firestore.instance.collection('insta_posts').document(id).get();
    return ImagePostFromFeedsRespJModel.fromDocument(document);*/
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getImagePostFromFeedsRespJModel(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                padding: const EdgeInsets.only(top: 10.0),
                child: CircularProgressIndicator());
          return snapshot.data;
        });
  }
}

void goToComments(
    {BuildContext context, String postId, String ownerId, String mediaUrl}) {
  Navigator.of(context)
      .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
    /*return CommentScreen(
      postId: postId,
      postOwner: ownerId,
      postMediaUrl: mediaUrl,
    );*/
  }));
}

void openProfile(BuildContext context, String userId) {
  /*Navigator.of(context)
        .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
      return ProfilePage(userId: userId);
    }));*/
}
