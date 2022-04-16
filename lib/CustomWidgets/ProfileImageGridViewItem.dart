import 'dart:async';
import 'dart:io';

import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataEvent.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/user_profiles/UserUserProfileReqJModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:after_layout/after_layout.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
//import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

class ProfileImageGridViewItem extends StatefulWidget {
  ProfileImageGridViewItem({
    Key key,
    this.userUserProfileReqJModel,
    this.animationController,
    this.animation,
    this.index,
    this.functionOnClickListItems,
    this.snackBarBuildContext,
    this.onImagesPickedCallback,
    this.remainingRequiredImages,
    this.navigationDataBLoC_ShowProgressDialog,
  }) : super(key: key);

  UserUserProfileReqJModel userUserProfileReqJModel;
  AnimationController animationController;
  Animation<dynamic> animation;
  IntindexCallback functionOnClickListItems;
  int index;
  BuildContext snackBarBuildContext;
  OnImagesPickedCallback onImagesPickedCallback;
  int remainingRequiredImages;
  NavigationDataBLoC navigationDataBLoC_ShowProgressDialog;

  @override
  _ProfileImageGridViewItemState createState() =>
      _ProfileImageGridViewItemState();
}

class _ProfileImageGridViewItemState extends State<ProfileImageGridViewItem>
    with TickerProviderStateMixin, AfterLayoutMixin<ProfileImageGridViewItem> {
  NavigationDataBLoC imageChangedNavigationDataBLoC = NavigationDataBLoC();
  NavigationDataBLoC imageBackgroundChangedNavigationDataBLoC =
      NavigationDataBLoC();
  NavigationDataBLoC internetChangedRefreshImageNavigationDataBLoC =
      NavigationDataBLoC();
  NavigationData initialInternetConnNavigationData = NavigationData();
  StreamSubscription<ConnectivityResult> internetListenersubscription;

  @override
  void initState() {
    super.initState();
    initialInternetConnNavigationData.isInternetConnected = true;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    onIntitSetup();
  }

  onIntitSetup() async {
    await checkIternetConnection();
    await listenToInternetStatus();
  }

  Future<bool> checkIternetConnection() async {
    NavigationData navigationData = NavigationData();
    /*navigationData.isInternetConnected =
        await DataConnectionChecker().hasConnection;*/
    navigationData.isInternetConnected =
        await isInternetConnectedCheckFunction();
    refreshInternetChangedRefreshImageNavigationDataBLoCe(navigationData);
    return true;
  }

  refreshInternetChangedRefreshImageNavigationDataBLoCe(
      NavigationData navigationData) {
    internetChangedRefreshImageNavigationDataBLoC.dailySubTaskimages_event_sink
        .add(NavigationDataAddedEvent(navigationData));
  }

  Future<bool> listenToInternetStatus() async {
    String TAG = 'listenToInternetStatus:';
    internetListenersubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        NavigationData navigationData = NavigationData();
        /*navigationData.isInternetConnected =
            await DataConnectionChecker().hasConnection;*/
        navigationData.isInternetConnected =
            await isInternetConnectedCheckFunction();
        refreshInternetChangedRefreshImageNavigationDataBLoCe(navigationData);
        initialInternetConnNavigationData.isInternetConnected =
            navigationData.isInternetConnected;
      } else {
        NavigationData navigationData = NavigationData();
        navigationData.isInternetConnected = false;
        refreshInternetChangedRefreshImageNavigationDataBLoCe(navigationData);
        initialInternetConnNavigationData.isInternetConnected =
            navigationData.isInternetConnected;
      }
    });
    return true;
  }

  @override
  void dispose() {
    String TAG = 'dispose:';
    if (internetListenersubscription != null) {
      try {
        internetListenersubscription.cancel();
      } catch (error) {
        print(TAG + ' error==');
        print(error.toString());
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: widget.animation,
              child: Transform(
                transform: Matrix4.translationValues(
                    100 * (1.0 - widget.animation.value), 0.0, 0.0),
                child: SizedBox(
                  width: 140,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, left: 3, right: 3, bottom: 3),
                        child: InkWell(
                          splashColor: DatingAppTheme.grey.withOpacity(0.4),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          onTap: () {
                            pickImage(context);
                            widget.functionOnClickListItems(
                                widget.userUserProfileReqJModel, context);
                          },
                          child: getImageParentStreamBuilder(
                              datingAppThemeChanger),
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: widget.userUserProfileReqJModel
                                        .isprofilepicture !=
                                    null &&
                                widget.userUserProfileReqJModel.isprofilepicture
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: 1, bottom: 2),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {},
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30.0),
                                        ),
                                        splashColor: DatingAppTheme.grey,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: DatingAppTheme.nearlyWhite,
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: <Color>[
                                                DatingAppTheme.pink5
                                                    .withOpacity(0.8),
                                                DatingAppTheme.pink6
                                                    .withOpacity(0.8),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Icon(
                                              Icons.person,
                                              color: DatingAppTheme.white,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: 2, bottom: 2),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          print('FAB CLICKED');
                                          pickImage(context);
                                        },
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(43.0),
                                        ),
                                        splashColor: DatingAppTheme.grey,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: DatingAppTheme.nearlyWhite,
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: <Color>[
                                                DatingAppTheme.pink5
                                                    .withOpacity(0.8),
                                                DatingAppTheme.pink6
                                                    .withOpacity(0.8),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Icon(
                                              Icons.add,
                                              color: DatingAppTheme.white,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Padding(
                                padding: EdgeInsets.only(right: 2, bottom: 2),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      print('FAB CLICKED');
                                      pickImage(context);
                                    },
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(43.0),
                                    ),
                                    splashColor: DatingAppTheme.grey,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: DatingAppTheme.nearlyWhite,
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            DatingAppTheme.pink5
                                                .withOpacity(0.8),
                                            DatingAppTheme.pink6
                                                .withOpacity(0.8),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Icon(
                                          Icons.add,
                                          color: DatingAppTheme.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
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
      },
    );
  }

  Widget getImageParentStreamBuilder(
      DatingAppThemeChanger datingAppThemeChanger) {
    return StreamBuilder(
      stream: imageBackgroundChangedNavigationDataBLoC.stream_counter,
      builder: (context, snapshot) {
        return getImageParent(snapshot, datingAppThemeChanger);
      },
    );
  }

  Widget getImageParent(
    AsyncSnapshot<NavigationData> snapshot,
    DatingAppThemeChanger datingAppThemeChanger,
  ) {
    if (!isStringValid(widget.userUserProfileReqJModel.localfilepath) &&
        !isStringValid(widget.userUserProfileReqJModel.picture)) {
      return onImageNotPicked(datingAppThemeChanger);
    } else {
      return onImagePicked(datingAppThemeChanger);
    }
  }

  Widget onImagePicked(DatingAppThemeChanger datingAppThemeChanger) {
    return Padding(
      padding: EdgeInsets.only(
        right: 0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: datingAppThemeChanger.selectedThemeData.cl_profile_item_bg,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: getImageStreamBuilder(),
            ),
          ],
        ),
      ),
    );
  }

  Widget getImageStreamBuilder() {
    return StreamBuilder(
      stream: internetChangedRefreshImageNavigationDataBLoC.stream_counter,
      initialData: initialInternetConnNavigationData,
      builder: (context, snapshot) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            image: getDecorationImage(snapshot),
          ),
        );
      },
    );
  }

  DecorationImage getDecorationImage(AsyncSnapshot<NavigationData> snapshot) {
    if (isStringValid(widget.userUserProfileReqJModel.localfilepath)) {
      return DecorationImage(
        image: Image.file(File(widget.userUserProfileReqJModel.localfilepath))
            .image,
        fit: BoxFit.cover,
      );
    } else {
      NavigationData navigationData = snapshot.data;
      if (navigationData != null) {
        if (navigationData.isInternetConnected) {
          if (isStringValid(widget.userUserProfileReqJModel.picture)) {
            return DecorationImage(
              image: CachedNetworkImageProvider(
                widget.userUserProfileReqJModel.picture,
                errorListener: imageInternetLoadingError(),
              ),
              fit: BoxFit.cover,
            );
          } else {
            return DecorationImage(
              image: Image.asset('assets/images/reload_img.png').image,
              fit: BoxFit.fitWidth,
            );
          }
        } else {
          return DecorationImage(
            image: Image.asset('assets/images/reload_img.png').image,
            fit: BoxFit.fitWidth,
          );
        }
      } else {
        return DecorationImage(
          image: Image.asset('assets/images/reload_img.png').image,
          fit: BoxFit.fitWidth,
        );
      }
    }
  }

  Widget onImageNotPicked(DatingAppThemeChanger datingAppThemeChanger) {
    return Padding(
      padding: EdgeInsets.only(
        right: 2,
      ),
      child: DottedBorder(
        borderType: BorderType.RRect,
        strokeWidth: 5,
        padding: EdgeInsets.all(0),
        radius: Radius.circular(10),
        color: datingAppThemeChanger.selectedThemeData.cl_profile_item_border,
        child: Container(
          decoration: BoxDecoration(
            color: datingAppThemeChanger.selectedThemeData.cl_profile_item_bg,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  pickImage(BuildContext context) {
    requestPermissionWithCheck(PermissionGroup.storage, context);
  }

  requestPermissionWithCheck(
      PermissionGroup permissionGroup, BuildContext context) {
    PermissionHandler().checkPermissionStatus(permissionGroup).then(
        (PermissionStatus status) {
      bool bool_status = getPermissionStatusBool(status);
      if (bool_status) {
        pickFile(context);
      } else {
        List<PermissionGroup> permissions = <PermissionGroup>[permissionGroup];
        PermissionHandler().requestPermissions(permissions).then((onValue) {
          PermissionStatus permissionStatus = onValue[permissionGroup];
          bool bool_status = getPermissionStatusBool(permissionStatus);
          if (bool_status) {
            pickFile(context);
          } else {
            showSnackbarWBgCol('Permission denied', widget.snackBarBuildContext,
                DatingAppTheme.red);
          }
        }, onError: (error) {});
      }
    }, onError: (error) {
      showSnackbarWBgCol('An error occurred requesting permission',
          widget.snackBarBuildContext, DatingAppTheme.red);
      return PermissionStatus.unknown;
    });
  }

  pickFile(BuildContext context) async {
    String TAG = 'pickFile:';
    refreshLoader(true, widget.navigationDataBLoC_ShowProgressDialog);

    FilePickerResult filesPathMap = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    /*Map<String, String> filesPathMap=await FilePicker.getMultiFilePath(
      type: FileType.image,
    );*/
    /*if (filesPathMap != null &&
        filesPathMap.paths!=null &&  filesPathMap.paths> 0) {*/
    if (filesPathMap != null &&
        filesPathMap.paths!=null &&  filesPathMap.paths.length> 0) {
      List<String> pickedFilePathList = [];
      pickedFilePathList.addAll(filesPathMap.paths);
      /*pickedFilePathList.addAll(filesPathMap.values.toList());*/
      widget.onImagesPickedCallback(
        pickedFilePathList,
        widget.userUserProfileReqJModel,
        context,
        widget.index,
      );
    } else {
      refreshLoader(false, widget.navigationDataBLoC_ShowProgressDialog);
    }

    /* .then((onValue) {
       onValue;
      List<String> pickedFilePathList = [];
      pickedFilePathList.addAll(filesPathMap.values.toList());
      if (pickedFilePathList.length > 0) {
        refreshLoader(false, widget.navigationDataBLoC_ShowProgressDialog);
        refreshLoader(true, widget.navigationDataBLoC_ShowProgressDialog);
        widget.onImagesPickedCallback(
          pickedFilePathList,
          widget.userUserProfileReqJModel,
          context,
          widget.index,
        );
      }
    }, onError: (error) {
      print(TAG + ' error==');
      print(error.toString());
    });*/
  }

  imageInternetLoadingError() {}
}

typedef IntindexCallback = void Function(
    UserUserProfileReqJModel userUserProfileReqJModel, BuildContext context);
typedef OnImagesPickedCallback = void Function(
  List<String> pickedFilePathList,
  UserUserProfileReqJModel userUserProfileReqJModel,
  BuildContext context,
  int index,
);
