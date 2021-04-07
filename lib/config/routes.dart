/*
 * fluro
 * Created by Yakka
 * https://theyakka.com
 * 
 * Copyright (c) 2019 Yakka, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/page/login/login_page.dart';
import './route_handlers.dart';

class Routes {
  static String root = "/";
  static String webview = "/webview";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        print("ROUTE WAS NOT FOUND !!!");
        return;
      },
    );
    router.define(root, handler: rootHandler);
    router.define(webview, handler: webviewHandler);
    router.define(LoginPage.sName, handler: loginHandler);
    // router.define(demoSimple, handler: demoRouteHandler);
    // router.define(demoSimpleFixedTrans,
    //     handler: demoRouteHandler, transitionType: TransitionType.inFromLeft);
    // router.define(demoFunc, handler: demoFunctionHandler);
    // router.define(deepLink, handler: deepLinkHandler);
  }
}
