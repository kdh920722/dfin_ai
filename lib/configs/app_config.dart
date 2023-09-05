import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:upfin/views/certification_result_view.dart';
import 'package:upfin/views/in_app_web_view.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../views/certification_view.dart';
import '../views/app_start.dart';

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
    AppView.rootView.value : (context) => AppStartView(),
    AppView.certificationView.value : (context) => CertificationView(),
    AppView.certificationResultView.value : (context) => CertificationResultView(),
    AppView.webView.value : (context) => InAppWebView()
  };

}

enum AppView {
  rootView, certificationView, certificationResultView, webView
}

extension SAppViewExtension on AppView {
  String get value {
    switch (this) {
      case AppView.rootView:
        return '/';
      case AppView.certificationView:
        return '/certification';
      case AppView.certificationResultView:
        return '/certificationResult';
      case AppView.webView:
        return '/webView';
    }
  }
}

enum SlideType {
  toLeft, toRight, toTop, toBottom
}

extension SlideTypeExtension on SlideType {
  String get value {
    switch (this) {
      case SlideType.toLeft:
        return 'LEFT';
      case SlideType.toRight:
        return 'RIGHT';
      case SlideType.toTop:
        return 'TOP';
      case SlideType.toBottom:
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