import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gsy_github_app_flutter/common/event/http_error_event.dart';
import 'package:gsy_github_app_flutter/common/event/index.dart';
import 'package:gsy_github_app_flutter/common/localization/default_localizations.dart';
import 'package:gsy_github_app_flutter/common/localization/gsy_localizations_delegate.dart';
import 'package:gsy_github_app_flutter/page/all/all_page.dart';
import 'package:gsy_github_app_flutter/page/debug/debug_label.dart';
import 'package:gsy_github_app_flutter/page/photoview_page.dart';
import 'package:gsy_github_app_flutter/page/webView/webView_page.dart';
import 'package:gsy_github_app_flutter/redux/gsy_state.dart';
import 'package:gsy_github_app_flutter/model/User.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:gsy_github_app_flutter/common/utils/common_utils.dart';
import 'package:gsy_github_app_flutter/page/home/home_page.dart';
import 'package:gsy_github_app_flutter/page/login/login_page.dart';
import 'package:gsy_github_app_flutter/page/welcome_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gsy_github_app_flutter/common/net/code.dart';

import 'common/event/index.dart';
import 'common/utils/navigator_utils.dart';
import 'config/application.dart';
import 'config/routes.dart';

class FlutterReduxApp extends StatefulWidget {
  @override
  _FlutterReduxAppState createState() => _FlutterReduxAppState();
}

class _FlutterReduxAppState extends State<FlutterReduxApp>
    with HttpErrorListener, NavigatorObserver {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  _FlutterReduxAppState() {
    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  /// ??????Store????????? GSYState ?????? appReducer ?????? Reducer ??????
  /// initialState ????????? State
  final store = new Store<GSYState>(
    appReducer,

    ///?????????
    middleware: middleware,

    ///???????????????
    initialState: new GSYState(
        userInfo: User.empty(),
        login: false,
        themeData: CommonUtils.getThemeData(GSYColors.primarySwatch),
        locale: Locale('zh', 'CH')),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      /// ?????? with NavigatorObserver ?????????????????????????????????????????????
      /// MaterialApp ??? StoreProvider ??? context
      /// ?????????????????? navigator;
      /// ?????????????????????????????????????????? token ???????????????????????????
      _context = navigator!.context;
      navigator!.context;
      navigator;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// ?????? flutter_redux ?????????????????????
    /// ?????? StoreProvider ?????? store
    return new StoreProvider(
      store: store,
      child: new StoreBuilder<GSYState>(builder: (context, store) {
        ///?????? StoreBuilder ?????? store ?????? theme ???locale
        store.state.platformLocale = WidgetsBinding.instance!.window.locale;
        return new MaterialApp(
          ///?????????????????????
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GSYLocalizationsDelegate.delegate,
          ],
          supportedLocales: [store.state.locale ?? store.state.platformLocale!],
          locale: store.state.locale,
          theme: store.state.themeData,
          navigatorObservers: [this],
          onGenerateRoute: Application.router.generator,
        );
      }),
    );
  }
}

mixin HttpErrorListener on State<FlutterReduxApp> {
  StreamSubscription? stream;

  ///?????????????????? _context ???????????????
  ///???????????? State ??? context ??? FlutterReduxApp ????????? MaterialApp
  ///????????????????????? context ?????????????????? MaterialApp ??? Localizations ??????
  late BuildContext _context;

  @override
  void initState() {
    super.initState();

    ///Stream??????event bus
    stream = eventBus.on<HttpErrorEvent>().listen((event) {
      print(event.code);
      errorHandleFunction(event.code, event.message);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (stream != null) {
      stream!.cancel();
      stream = null;
    }
  }

  ///??????????????????
  errorHandleFunction(int? code, message) {
    switch (code) {
      case Code.NETWORK_ERROR:
        showToast(GSYLocalizations.i18n(_context)!.network_error);
        break;
      case 401:
        showToast(GSYLocalizations.i18n(_context)!.network_error_401);
        Application.router.navigateTo(_context, LoginPage.sName);
        break;
      case 403:
        showToast(GSYLocalizations.i18n(_context)!.network_error_403);
        break;
      case 404:
        showToast(GSYLocalizations.i18n(_context)!.network_error_404);
        break;
      case 422:
        showToast(GSYLocalizations.i18n(_context)!.network_error_422);
        break;
      case Code.NETWORK_TIMEOUT:
        //??????
        showToast(GSYLocalizations.i18n(_context)!.network_error_timeout);
        break;
      case Code.GITHUB_API_REFUSED:
        //Github API ??????
        showToast(GSYLocalizations.i18n(_context)!.github_refused);
        break;
      default:
        showToast(GSYLocalizations.i18n(_context)!.network_error_unknown +
            " " +
            message);
        break;
    }
  }

  showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG);
  }
}
