import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:upfin/views/app_signup_view.dart';
import 'package:upfin/views/in_app_web_view.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../views/certification_view.dart';
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
    AppView.rootView.value : (context) => AppLoginView(),
    AppView.certificationView.value : (context) => CertificationView(),
    AppView.webView.value : (context) => InAppWebView(),
    AppView.signupView.value : (context) => AppSignUpView()
  };

}

enum AppView {
  rootView, certificationView, webView, signupView
}

extension SAppViewExtension on AppView {
  String get value {
    switch (this) {
      case AppView.rootView:
        return '/';
      case AppView.certificationView:
        return '/certification';
      case AppView.webView:
        return '/webView';
      case AppView.signupView:
        return '/signupView';
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