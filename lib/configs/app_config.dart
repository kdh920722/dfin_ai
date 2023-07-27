import 'package:flutter/foundation.dart';

class Config{
  static bool isAppMainInit = false;
  static const double appWidth = 393;
  static const double appHeight = 852;
  static List<double> appFullSize = [0,0];
  static List<double> appRealSize = [0,0];
  static final isWebMobile = kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);
  static final isAndroidWebMobile = (defaultTargetPlatform == TargetPlatform.android);
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