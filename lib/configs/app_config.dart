import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upfin/views/app_accident_detail_view.dart';
import 'package:upfin/views/app_agree_detail_info_view.dart';
import 'package:upfin/views/app_agree_detail_info_view_test.dart';
import 'package:upfin/views/app_apply_doc_view.dart';
import 'package:upfin/views/app_apply_pr_view.dart';
import 'package:upfin/views/app_detail_pr_view.dart';
import 'package:upfin/views/app_main_view.dart';
import 'package:upfin/views/app_result_pr_view.dart';
import 'package:upfin/views/app_root_view.dart';
import 'package:upfin/views/app_search_accident_view.dart';
import 'package:upfin/views/app_signout_view.dart';
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
  static const int appUpdateState = 44;
  static const int appCloseState = 99;
  static int appState = 10; // 10 : open, 99: close, 44: update
  static String appCloseText = "";
  static bool isWeb = kIsWeb;
  static bool isAndroid = Platform.isAndroid;
  static String deppLinkInfo = "";
  static List<Permission> permissionList = [Permission.notification, Permission.camera];
  static String appVersion = "";
  static String appStoreUrl = "";
  static BuildContext? contextForEmergencyBack;
  static bool isEmergencyRoot = false;
  static FlutterDownloader flutterDownloader = FlutterDownloader();

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
    AppView.appApplyDocView.value : (context) => AppApplyDocView(),
    AppView.appChatView.value : (context) => AppChatView(),
    AppView.appAccidentDetailInfoView.value : (context) => AppAccidentDetailView(),
    AppView.appAgreeDetailInfoView.value : (context) => AppAgreeDetailInfoView(),
    AppView.appSignOutView.value : (context) => AppSignOutView(),
    AppView.appAgreeDetailInfoViewTest.value : (context) => AppAgreeDetailInfoViewTest(),
  };

  static Future<void> initAppState(Function(bool isSuccess) callback) async{
    try{
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('UPFIN/APP_STATE').get();
      if (snapshot.exists) {
        int androidState = 99;
        int iosState = 99;
        String androidVersion = "";
        String iosVersion = "";
        String androidStoreUrl = "";
        String iosStoreUrl = "";

        for(var each in snapshot.children){
          switch(each.key){
            case "android_open_state" : androidState = int.parse(each.value.toString());
            case "ios_open_state" : iosState = int.parse(each.value.toString());
            case "android_app_version" : androidVersion = each.value.toString();
            case "ios_app_version" : iosVersion = each.value.toString();
            case "android_store" : androidStoreUrl = each.value.toString();
            case "ios_store" : iosStoreUrl = each.value.toString();
            case "app_close_text" : appCloseText = each.value.toString();
          }
        }

        appState = isAndroid? androidState : iosState;
        appVersion = isAndroid? androidVersion : iosVersion;
        appStoreUrl = isAndroid? androidStoreUrl : iosStoreUrl;
        if(await _isNeedToUpdateVersion()){
          appState = appUpdateState;
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

  static Future<bool> _isNeedToUpdateVersion() async {
    bool result = false;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    CommonUtils.log("", ""
        "\nappName : $appName"
        "\npackageName : $packageName"
        "\nversion : $version"
        "\nbuildNumber : $buildNumber");

    CommonUtils.log("", "appVersion : $appVersion || $version");
    if(version == appVersion){
      result = false;
    }else{
      result = true;
    }

    return result;
  }
}

enum AppView {
  appRootView, appLoginView, appCertificationView, appWebView, appSignupView, appMainView, appSearchAccidentView, appSignOutView, appApplyDocView,
  appUpdateAccidentView, appResultPrView, appDetailPrView, appApplyPrView, appChatView, appAccidentDetailInfoView, appAgreeDetailInfoView, appAgreeDetailInfoViewTest
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
      case AppView.appApplyDocView:
        return '/applyDocView';
      case AppView.appChatView:
        return '/appChatView';
      case AppView.appAccidentDetailInfoView:
        return '/accidentDetailInfoView';
      case AppView.appAgreeDetailInfoView:
        return '/agreeDetailInfoView';
      case AppView.appSignOutView:
        return '/appSignOutView';
      case AppView.appAgreeDetailInfoViewTest:
        return '/appAgreeDetailInfoViewTest';
    }
  }
}

enum SlideMenuMoveType {
  rightToLeft, leftToRight, bottomToTop, topToBottom
}

extension SlideTypeExtension on SlideMenuMoveType {
  String get value {
    switch (this) {
      case SlideMenuMoveType.rightToLeft:
        return 'LEFT';
      case SlideMenuMoveType.leftToRight:
        return 'RIGHT';
      case SlideMenuMoveType.bottomToTop:
        return 'TOP';
      case SlideMenuMoveType.topToBottom:
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