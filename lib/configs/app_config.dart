import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:upfin/views/app_accident_detail_view.dart';
import 'package:upfin/views/app_agree_detail_info_view.dart';
import 'package:upfin/views/app_apply_pr_view.dart';
import 'package:upfin/views/app_detail_pr_view.dart';
import 'package:upfin/views/app_main_view.dart';
import 'package:upfin/views/app_result_pr_view.dart';
import 'package:upfin/views/app_root_view.dart';
import 'package:upfin/views/app_search_accident_view.dart';
import 'package:upfin/views/app_signup_view.dart';
import 'package:upfin/views/app_update_accident_view.dart';
import 'package:upfin/views/app_web_view.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../utils/common_utils.dart';
import '../views/app_chat_view.dart';
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
    AppView.appRootView.value : (context) => AppRootView(),
    AppView.appLoginView.value : (context) => AppLoginView(),
    AppView.appCertificationView.value : (context) => AppLoginCertificationView(),
    AppView.appWebView.value : (context) => AppWebView(),
    AppView.appSignupView.value : (context) => AppSignUpView(),
    AppView.appMainView.value : (context) => AppMainView(),
    AppView.appSearchAccidentView.value : (context) => AppSearchAccidentView(),
    AppView.appUpdateAccidentView.value : (context) => AppUpdateAccidentView(),
    AppView.appResultPrView.value : (context) => AppResultPrView(),
    AppView.appDetailPrView.value : (context) => AppDetailPrView(),
    AppView.appApplyPrView.value : (context) => AppApplyPrView(),
    AppView.appChatView.value : (context) => AppChatView(),
    AppView.appAccidentDetailInfoView.value : (context) => AppAccidentDetailView(),
    AppView.appAgreeDetailInfoView.value : (context) => AppAgreeDetailInfoView()
  };

  static Future<void> initAppState(Function(bool isSuccess) callback) async{
    try{
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('UPFIN/APP_STATE').get();
      if (snapshot.exists) {
        int androidState = 99;
        int iosState = 99;
        for(var each in snapshot.children){
          switch(each.key){
            case "android_open_state" : androidState = int.parse(each.value.toString());
            case "ios_open_state" : iosState = int.parse(each.value.toString());
          }
        }
        appState = isAndroid? androidState : iosState;

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
  appRootView, appLoginView, appCertificationView, appWebView, appSignupView, appMainView, appSearchAccidentView,
  appUpdateAccidentView, appResultPrView, appDetailPrView, appApplyPrView, appChatView, appAccidentDetailInfoView, appAgreeDetailInfoView
}

extension SAppViewExtension on AppView {
  String get value {
    switch (this) {
      case AppView.appRootView:
        return '/rootView';
      case AppView.appLoginView:
        return '/loginView';
      case AppView.appCertificationView:
        return '/certification';
      case AppView.appWebView:
        return '/webView';
      case AppView.appSignupView:
        return '/signupView';
      case AppView.appMainView:
        return '/mainView';
      case AppView.appSearchAccidentView:
        return '/searchAccidentView';
      case AppView.appUpdateAccidentView:
        return '/updateAccidentView';
      case AppView.appResultPrView:
        return '/resultPrView';
      case AppView.appDetailPrView:
        return '/detailPrView';
      case AppView.appApplyPrView:
        return '/applyPrView';
      case AppView.appChatView:
        return '/appChatView';
      case AppView.appAccidentDetailInfoView:
        return '/accidentDetailInfoView';
      case AppView.appAgreeDetailInfoView:
        return '/agreeDetailInfoView';
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