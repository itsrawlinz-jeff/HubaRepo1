import 'dart:developer';

import 'package:dating_app/Bloc/Actions/ImagePostBlocActions.dart';
import 'package:dating_app/Bloc/Streams/AppInit/AppInitBloC.dart';
import 'package:dating_app/Bloc/Streams/AppInit/AppInitEvent.dart';
import 'package:dating_app/Bloc/bloc_library/navigationdrawer/navigationdrawer_bloc.dart';
import 'package:dating_app/Bloc/weather_bloc.dart';
import 'package:dating_app/Data/Database/Moor/Core/AppDatabase.dart';
import 'package:dating_app/Models/JsonSerializable/LoginRespModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/tabs/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'Activities/LoginSignUpOptionsPage.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

Future<void> main() async {
  await DotEnv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

//class _MyAppState extends StatelessWidget , AfterLayoutMixin<HookUp> {
class _MyAppState extends State<MyApp> with AfterLayoutMixin<MyApp> {
  var _appInitBloC = AppInitBloC();
  BuildContext buildContextStreamBuilder;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          builder: (_) => AppDatabase(),
        ),
        Provider(
          create: (maincontext) => PostApiService.create(),
          dispose: (maincontext, PostApiService service) =>
              service.client.dispose(),
        ),
        BlocProvider(
          builder: (context) => WeatherBloc(ImagePostBlocActions()),
        ),
        Provider(
            create: (maincontext) {
              ParentSelectedThemeData parentSelectedThemeData =
                  ParentSelectedThemeData();
              return parentSelectedThemeData;
            },
            dispose: (maincontext,
                ParentSelectedThemeData parentSelectedThemeData) {}),
        ChangeNotifierProvider(
          create: (maincontext) {
            DatingAppThemeChanger datingAppThemeChanger =
                DatingAppThemeChanger();
            return datingAppThemeChanger;
          },
        ),
        BlocProvider<NavigationdrawerBloc>(
          builder: (maincontext) => NavigationdrawerBloc(),
        ),
      ],
      child: //oldapp(),
          MaterialApp(
        title: 'Love Birds',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder(
          stream: _appInitBloC.stream_counter,
          builder: (context, snapshot) {
            buildContextStreamBuilder = context;
            NavigationData navigationData = snapshot.data;
            ParentSelectedThemeData parentSelectedThemeData =
                Provider.of<ParentSelectedThemeData>(context, listen: true);
            if (parentSelectedThemeData != null &&
                parentSelectedThemeData.isFromToggle != null &&
                !parentSelectedThemeData.isFromToggle) {
              if (navigationData != null) {
                try {
                  ParentSelectedThemeData parentSelectedThemeData =
                      Provider.of<ParentSelectedThemeData>(context,
                          listen: true);

                  parentSelectedThemeData.selectedThemeData =
                      DatingAppSelectedTheme.get_themeData(
                          navigationData.isDarkMode);

                  DatingAppThemeChanger adrianErpThemeChanger =
                      Provider.of<DatingAppThemeChanger>(context, listen: true);
                  adrianErpThemeChanger.isDarkThemeSelected =
                      navigationData.isDarkMode;
                  adrianErpThemeChanger.selectedThemeData =
                      DatingAppSelectedTheme.get_themeData(
                          navigationData.isDarkMode);
                } catch (error) {
                  print('Error on init==');
                  print(error.toString());
                }
              }
            }

            /*if (snapshot.hasError) {
              return LoginPage();
            }
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return LoginPage();
              case ConnectionState.waiting:
                return getloadingPlaceHolder();
              case ConnectionState.active:
                return getAfterAppInitBlocWidget(navigationData);
              case ConnectionState.done:
                return LoginPage();
            }*/

            if (snapshot.hasError) return LoginSignUpOptionsPage();
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return LoginSignUpOptionsPage();
              case ConnectionState.waiting:
                return getloadingPlaceHolder();
              case ConnectionState.active:
                try {
                  NavigationData navigationData = snapshot.data;
                  if (navigationData != null &&
                      navigationData.loginRespModel != null &&
                      navigationData.loginRespModel.username != null &&
                      (navigationData.loginRespModel.isinsignupprocess ==
                              null ||
                          (navigationData.loginRespModel.isinsignupprocess !=
                                  null &&
                              !navigationData
                                  .loginRespModel.isinsignupprocess))) {
                    return new Index();
                  }
                } catch (error) {}
                return LoginSignUpOptionsPage();
              case ConnectionState.done:
                try {
                  NavigationData navigationData = snapshot.data;
                  if (navigationData != null &&
                      navigationData.loginRespModel != null &&
                      navigationData.loginRespModel.username != null &&
                      (navigationData.loginRespModel.isinsignupprocess ==
                              null ||
                          (navigationData.loginRespModel.isinsignupprocess !=
                                  null &&
                              !navigationData
                                  .loginRespModel.isinsignupprocess))) {
                    return new Index();
                  }
                } catch (error) {}
                return LoginSignUpOptionsPage();
            }
          },
        ),
      ),
    );
  }

  Widget oldapp() {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: _appInitBloC.stream_counter,
        builder: (context, snapshot) {
          buildContextStreamBuilder = context;
          if (snapshot.hasError) return LoginSignUpOptionsPage();
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return LoginSignUpOptionsPage();
            case ConnectionState.waiting:
              return getloadingPlaceHolder();
            case ConnectionState.active:
              try {
                LoginRespModel loginRespModel = snapshot.data;
                if (loginRespModel != null && loginRespModel.username != null) {
                  return new Index();
                }
              } catch (error) {}
              return LoginSignUpOptionsPage();
            case ConnectionState.done:
              try {
                LoginRespModel loginRespModel = snapshot.data;
                if (loginRespModel != null && loginRespModel.username != null) {
                  return new Index();
                }
              } catch (error) {}
              return LoginSignUpOptionsPage();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _appInitBloC.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _appInitBloC.switch_changed_event_sink
        .add(AppInitializedEvent(buildContextStreamBuilder));
  }

  @override
  void initState() {
    super.initState();
    initFlutterDownloader();
  }

  initFlutterDownloader() async {
    print('initFlutterDownloader');
    try {
      WidgetsFlutterBinding.ensureInitialized();
      //var flutterDownloaderInitialize = await FlutterDownloader.initialize();
      var flutterDownloaderInitialize = await FlutterDownloader.initialize(
          //debug: true
          );
    } catch (error) {
      print('initFlutterDownloader error=${error}');
    }
  }

  Widget getloadingPlaceHolder() {
    return Scaffold(
      body: Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator()),
    );

    /*return Container(
      height: 400.0,
      child: Center(child: CircularProgressIndicator()),
    );*/
    /*  Container(
  alignment: FractionalOffset.center,
  child: CircularProgressIndicator());*/
  }
}
