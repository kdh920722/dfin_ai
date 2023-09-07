import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:upfin/views/app_main_view.dart';
import 'package:upfin/views/app_search_accident_view.dart';
import 'package:upfin/views/app_signup_view.dart';
import 'package:upfin/views/app_web_view.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../views/app_login_certification_view.dart';
import '../views/app_login_view.dart';

class Config{
  static bool isControllerLoadFinished = false;
  static const int buildTwice = 2;
  static bool isAppMainInit = false;
  static const double appWidth = 393;
  static const double appHeight = 852;
  static bool isWeb = kIsWeb;
  static bool isAndroid = Platform.isAndroid;
  static String deppLinkInfo = "";
  static List<Permission> permissionList = [Permission.notification];

  static Map<String, WidgetBuilder> appRoutes = {
    AppView.rootLoginView.value : (context) => AppLoginView(),
    AppView.certificationView.value : (context) => AppLoginCertificationView(),
    AppView.webView.value : (context) => AppWebView(),
    AppView.signupView.value : (context) => AppSignUpView(),
    AppView.mainView.value : (context) => AppMainView(),
    AppView.searchAccidentView.value : (context) => AppSearchAccidentView()
  };

}

enum AppView {
  rootLoginView, certificationView, webView, signupView, mainView, searchAccidentView
}

extension SAppViewExtension on AppView {
  String get value {
    switch (this) {
      case AppView.rootLoginView:
        return '/loginView';
      case AppView.certificationView:
        return '/certification';
      case AppView.webView:
        return '/webView';
      case AppView.signupView:
        return '/signupView';
      case AppView.mainView:
        return '/mainView';
      case AppView.searchAccidentView:
        return '/searchAccidentView';
    }
  }
}

enum SlideType {
  rightToLeft, leftToRight, bottomToTop, topToBottom
}

extension SlideTypeExtension on SlideType {
  String get value {
    switch (this) {
      case SlideType.rightToLeft:
        return 'LEFT';
      case SlideType.leftToRight:
        return 'RIGHT';
      case SlideType.bottomToTop:
        return 'TOP';
      case SlideType.topToBottom:
        return 'BOTTOM';
      default:
        throw Exception('Unknown SlideType value');
    }
  }
}

enum FabType {
  bottomLeft, bottomRight
}

extension FabTypeExtension on FabType {
  String get value {
    switch (this) {
      case FabType.bottomLeft:
        return 'BOTTOM LEFT';
      case FabType.bottomRight:
        return 'BOTTOM RIGHT';
      default:
        throw Exception('Unknown FabType value');
    }
  }
}