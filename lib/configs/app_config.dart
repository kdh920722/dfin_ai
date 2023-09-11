import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:upfin/views/app_main_view.dart';
import 'package:upfin/views/app_result_pr_view.dart';
import 'package:upfin/views/app_search_accident_view.dart';
import 'package:upfin/views/app_signup_view.dart';
import 'package:upfin/views/app_web_view.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../utils/common_utils.dart';
import '../views/app_login_certification_view.dart';
import '../views/app_login_view.dart';

class Config{
  static bool isControllerLoadFinished = false;
  static const int buildTwice = 2;
  static bool isAppMainInit = false;
  static const double appWidth = 393;
  static const double appHeight = 852;
  static const int appOpenState = 10;
  static const int appCloseState = 99;
  static int appState = 10; // 10 : open, 99: close
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
    AppView.searchAccidentView.value : (context) => AppSearchAccidentView(),
    AppView.resultPrView.value : (context) => AppResultPrView()
  };

  static Future<void> initAppState(Function(bool isSuccess) callback) async{
    try{
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('UPFIN/APP_STATE').get();
      if (snapshot.exists) {
        for(var each in snapshot.children){
          switch(each.key){
            case "open_state" : appState = int.parse(each.value.toString());
          }
        }
        callback(true);
      } else {
        callback(false);
      }
    }catch(e){
      CommonUtils.log("e", "init app state error : ${e.toString()}");
      callback(false);
    }
  }
}

enum AppView {
  rootLoginView, certificationView, webView, signupView, mainView, searchAccidentView, resultPrView
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
      case AppView.resultPrView:
        return '/resultPrView';
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