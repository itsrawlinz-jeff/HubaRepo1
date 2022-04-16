import 'dart:async';
import 'dart:convert';

import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Chopper/functions/data_put_posting/individual_put_posting/post_put_chat.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/messages/MessageRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/messages/SocketMessageListRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/messages/MessageFromToRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/CustomWidgets/CustomTitleView.dart';
import 'package:dating_app/UI/Presentation/CustomWidgets/MessageItemWidget.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/tabs/messages_tab/widgets/ViewUserProfilePage.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';

class DirectMessagingPage extends StatefulWidget {
  CustomUserRespJModel messaging_to;
  DirectMessagingPage({
    this.messaging_to,
    Key key,
  }) : super(key: key);

  @override
  _DirectMessagingPageState createState() => _DirectMessagingPageState();
}

class _DirectMessagingPageState extends State<DirectMessagingPage>
    with TickerProviderStateMixin, AfterLayoutMixin<DirectMessagingPage> {
  //ANIMATION
  AnimationController animationController;
  Animation<double> topBarAnimation;
  Animation animation;
  int count = 9;
  //END OF ANIMATION
  BuildContext snackBarBuildContext;
  TextEditingController textFieldController = TextEditingController();
  FocusNode messageFocusNode = FocusNode();
  TextInputAction _textInputAction = TextInputAction.newline;

  List<MessageRespJModel> currentmessages = [];
  ScrollController listviewScrollController = ScrollController();
  LoginRespModel loginRespModel;
  NavigationDataBLoC messages_Changed_NavigationDataBLoC = NavigationDataBLoC();
  NavigationDataBLoC loginBtnPageBLoC = NavigationDataBLoC();
  IOWebSocketChannel notifchannel;

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
  void afterFirstLayout(BuildContext context) {
    getLoggedInUser(context);
  }

  //AFTER FIRST LAYOUT FUNCTOIONS
  getLoggedInUser(BuildContext context) async {
    loginRespModel = await getSessionLoginRespModel(context);
    connectToSocket(context);
  }

  Future<bool> connectToSocket(BuildContext context) async {
    String TAG = 'connectToSocket:';
    print(TAG);
    /*Map<String, dynamic> headers = Map();
    headers[DatingAppStaticParams.authorizationConst] =
        DatingAppStaticParams.tokenWspace + loginRespModel.token;

    print(headers.toString());*/
    String socketURL =
        '${DatingAppStaticParams.baseUrlWSIP_Address}messages/${widget.messaging_to.id}/?token=${loginRespModel.token}';
    notifchannel = await IOWebSocketChannel.connect(
      socketURL,
      //headers: headers,
    );
    notifchannel.stream.listen((message) async {
      await createMessageList(message, context);
    });
    return true;
  }

  Future<bool> createMessageList(var message, BuildContext context) async {
    String TAG = "createMessageList:";
    print(TAG);
    SocketMessageListRespJModel socketMessageListRespJModel =
        SocketMessageListRespJModel.fromJson(json.decode(message));

    if (socketMessageListRespJModel != null) {
      if (socketMessageListRespJModel.messages.length !=
          currentmessages.length) {
        for (int i = 0; i < socketMessageListRespJModel.messages.length; i++) {
          MessageRespJModel messageRespJModel =
              socketMessageListRespJModel.messages[i];
          if (messageRespJModel.author.id !=
              loginRespModel.tokenDecodedJModel.id) {
            if (!messageRespJModel.read) {
              messageRespJModel.read = true;
              socketMessageListRespJModel.messages[i] = messageRespJModel;
              await post_put_chat(
                messageRespJModel,
                socketMessageListRespJModel.messages,
                i,
                loginBtnPageBLoC,
                context,
                null,
                null,
                false,
                null,
              );
            }
          }
        }

        currentmessages =
            socketMessageListRespJModel.messages.reversed.toList();
        refresh_WO_Data_NavigationDataBLoC(messages_Changed_NavigationDataBLoC);
        common_show_hide_loader(false, loginBtnPageBLoC);
      } else {}
    } else {}
    return true;
  }

  //END OF AFTER FIRST LAYOUT FUNCTOIONS

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
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProfileAvatar(
                      '',
                      child: ((isStringValid(widget.messaging_to.picture)
                          ? CachedNetworkImage(
                              imageUrl: widget.messaging_to.picture,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                      radius: (AppBar().preferredSize.height - 5) / 2,
                      backgroundColor: DatingAppTheme.grey_placeholder,
                      //Colors.black,
                      borderWidth: 0,
                      borderColor: Colors.transparent,
                      initialsText: Text(
                        "",
                      ),
                      elevation: 0.0,

                      cacheImage: true,
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new ViewUserProfilePage(
                                      messaging_to: widget.messaging_to,
                                    )));
                      },
                      showInitialTextAbovePicture: false,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2),
                      child: Text(
                        widget.messaging_to.first_name +
                            ' ' +
                            widget.messaging_to.last_name,
                        style: TextStyle(
                          fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          letterSpacing: -0.2,
                          color: datingAppThemeChanger
                              .selectedThemeData.mnu_darkerText_Color,
                        ),
                      ),
                    ),
                    Expanded(
                      child: invisibleWidget(),
                    ),
                    ((isStringValid(widget.messaging_to.fb_link)
                        ? SizedBox(
                            height: AppBar().preferredSize.height,
                            width: 40,
                            child: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.facebook,
                                color: DatingAppTheme.colorAdrianBlue,
                                size: 30,
                              ),
                              onPressed: () async {
                                if (isStringValid(
                                    widget.messaging_to.fb_link)) {
                                  if (await canLaunch(
                                      widget.messaging_to.fb_link)) {
                                    await launch(widget.messaging_to.fb_link);
                                  } else {
                                    showSnackbarWBgCol(
                                        'Could not launch link',
                                        snackBarBuildContext,
                                        DatingAppTheme.red);
                                  }
                                } else {
                                  showSnackbarWBgCol('Could not launch link',
                                      snackBarBuildContext, DatingAppTheme.red);
                                }
                              },
                            ),
                          )
                        : invisibleWidget())),
                    ((isStringValid(widget.messaging_to.insta_link)
                        ? SizedBox(
                            height: AppBar().preferredSize.height,
                            width: 40,
                            child: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.instagram,
                                color: DatingAppTheme.pink8,
                                size: 30,
                              ),
                              onPressed: () async {
                                if (isStringValid(
                                    widget.messaging_to.insta_link)) {
                                  if (await canLaunch(
                                      widget.messaging_to.insta_link)) {
                                    await launch(
                                        widget.messaging_to.insta_link);
                                  } else {
                                    showSnackbarWBgCol(
                                        'Could not launch link',
                                        snackBarBuildContext,
                                        DatingAppTheme.red);
                                  }
                                } else {
                                  showSnackbarWBgCol('Could not launch link',
                                      snackBarBuildContext, DatingAppTheme.red);
                                }
                              },
                            ),
                          )
                        : invisibleWidget())),
                  ],
                )),
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
          return Padding(
            padding: EdgeInsets.only(
              top:
                  /*AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24*/
                  0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                /*CustomTitleView(
                  titleTxt: widget.messaging_to.name,
                  subTxt: '',
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / 9) * 0, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  animationController: animationController,
                  titleTextStyle: TextStyle(
                    fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
                    fontSize: 16,
                    color: DatingAppTheme.pltf_grey,
                  ),
                  //datingAppThemeChanger.selectedThemeData.title_TextStyle,
                ),*/
                Flexible(
                  flex: 1,
                  child: StreamBuilder(
                    stream: messages_Changed_NavigationDataBLoC.stream_counter,
                    builder: (context, snapshot) {
                      return buildMessages();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(const Radius.circular(30.0)),
                            color: datingAppThemeChanger.selectedThemeData
                                .cl_dismissibleBackground_white,
                          ),
                          child: Row(
                            children: <Widget>[
                              Opacity(
                                child: IconButton(
                                  padding: const EdgeInsets.all(0.0),
                                  disabledColor: DatingAppTheme.grey_iconColor,
                                  color: DatingAppTheme.grey_iconColor,
                                  icon: Icon(Icons.insert_emoticon),
                                  splashColor: Colors.transparent,
                                  onPressed: () {},
                                ),
                                opacity: 0,
                              ),
                              Flexible(
                                child: TextField(
                                  controller: textFieldController,
                                  focusNode: messageFocusNode,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  textInputAction: _textInputAction,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(0.0),
                                    hintText: 'Type a message',
                                    hintStyle: datingAppThemeChanger
                                        .selectedThemeData
                                        .txt_stl_hint_f14w500_Med,
                                    counterText: '',
                                  ),
                                  onSubmitted: (String text) {
                                    if (_textInputAction ==
                                        TextInputAction.send) {
                                      // _sendMessage();
                                    }
                                  },
                                  style: datingAppThemeChanger
                                      .selectedThemeData.txt_stl_f14w500_Med,
                                  cursorColor: datingAppThemeChanger
                                      .selectedThemeData.cl_grey,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  maxLength: 100,
                                  onChanged: (String txt) {},
                                  autofocus: false,
                                ),
                              ),
                              !isStringValid(textFieldController.text)
                                  ? IconButton(
                                      color: Colors.transparent,
                                      icon: Icon(Icons.camera_alt),
                                      onPressed: () {},
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: FloatingActionButton(
                          elevation: 2.0,
                          backgroundColor:
                              DatingAppTheme.colorAdrianBlue, // secondaryColor,
                          foregroundColor: Colors.white,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Icon(Icons.send),
                              StreamBuilder(
                                stream: loginBtnPageBLoC.stream_counter,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError)
                                    return invisibleWidget();
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                      return invisibleWidget();
                                      break;
                                    case ConnectionState.waiting:
                                      return invisibleWidget();
                                      break;
                                    case ConnectionState.active:
                                      return if_show_hide_loader(snapshot);
                                      break;
                                    case ConnectionState.done:
                                      return if_show_hide_loader(snapshot);
                                      break;
                                  }
                                },
                              ),
                            ],
                          ),
                          onPressed: () {
                            onSubmitMessageMicPressed(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  //WIDGETS
  Widget getBottomCircularProgressBar() {
    return Theme(
      data: ThemeData(
        accentColor: DatingAppTheme.white,
      ),
      child: CircularProgressIndicator(
        strokeWidth: 2,
      ),
    );
  }

  buildMessages() {
    Timer(
        Duration(milliseconds: 500),
        () => listviewScrollController
            .jumpTo(listviewScrollController.position.maxScrollExtent));

    return ListView.builder(
        reverse: false,
        itemCount: currentmessages.length,
        controller: listviewScrollController,
        itemBuilder: (context, i) {
          MessageRespJModel messageRespJModel = currentmessages[i];
          return MessageItemWidget(
            content: messageRespJModel.content,
            timestamp: messageRespJModel.created_at,
            isYou: messageRespJModel.author.id ==
                loginRespModel.tokenDecodedJModel.id,
            isRead: messageRespJModel.read,
            isSent: isIntValid(messageRespJModel.id),
            fontSize: 15,
          );
        });
  }
  //END OF WIDGETS

  //WIDGET FUNCTIONS
  Widget if_show_hide_loader(AsyncSnapshot<NavigationData> snapshot) {
    if (snapshot != null &&
        snapshot.data != null &&
        snapshot.data.isShow != null &&
        snapshot.data.isShow) {
      return getBottomCircularProgressBar();
    } else {
      return invisibleWidget();
    }
  }

  onSubmitMessageMicPressed(BuildContext context) async {
    messageFocusNode.unfocus();
    if (isStringValid(textFieldController.text)) {
      MessageRespJModel messageRespJModel = MessageRespJModel();

      CustomUserRespJModel author = CustomUserRespJModel();
      author.id = loginRespModel.tokenDecodedJModel.id;
      messageRespJModel.author = author;

      CustomUserRespJModel receiver = CustomUserRespJModel();
      receiver.id = widget.messaging_to.id;
      messageRespJModel.receiver = receiver;

      messageRespJModel.content = textFieldController.text;
      messageRespJModel.read = false;
      messageRespJModel.created_at = DateTime.now();

      await post_put_chat(
          messageRespJModel,
          currentmessages,
          currentmessages.length - 1,
          loginBtnPageBLoC,
          context,
          null,
          textFieldController,
          true,
          messages_Changed_NavigationDataBLoC);
    } else {}
  }
  //END OF WIDGET FUNCTIONS

  void dispose() {
    super.dispose();
  }
}
