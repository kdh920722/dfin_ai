import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

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
}

enum AppView {
  rootView, certificationView
}

extension SAppViewExtension on AppView {
  String get value {
    switch (this) {
      case AppView.rootView:
        return '/';
      case AppView.certificationView:
        return '/certification';
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