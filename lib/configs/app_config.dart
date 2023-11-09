import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:upfin/views/app_accident_detail_view.dart';
import 'package:upfin/views/app_agree_detail_info_view.dart';
import 'package:upfin/views/app_agree_detail_info_view_test.dart';
import 'package:upfin/views/app_apply_pr_view.dart';
import 'package:upfin/views/app_detail_pr_view.dart';
import 'package:upfin/views/app_main_view.dart';
import 'package:upfin/views/app_result_pr_view.dart';
import 'package:upfin/views/app_root_view.dart';
import 'package:upfin/views/app_search_accident_view.dart';
import 'package:upfin/views/app_signout_view.dart';
import 'package:upfin/views/app_signup_view.dart';
import 'package:upfin/views/app_update_accident_view.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:upfin/views/debug_for_admin_view.dart';
import 'package:yaml/yaml.dart';
import '../utils/common_utils.dart';
import '../views/app_chat_view.dart';
import '../views/app_login_certification_view.dart';
import '../views/app_login_view.dart';

class Config{
  static bool isControllerLoadFinished = false;
  static bool isAppMainInit = false;
  static Map<String,dynamic> stateInfoMap = {};
  static int appState = 10; // 10 : open, 99: close, 44: update
  static Map<String,dynamic> appInfoTextMap = {};
  static bool isWeb = kIsWeb;
  static bool isAndroid = Platform.isAndroid;
  static String deppLinkInfo = "";
  static List<Permission> permissionList = [Permission.notification, Permission.camera, Permission.phone, Permission.microphone];
  static String appVersion = "";
  static String appStoreUrl = "";
  static BuildContext? contextForEmergencyBack;
  static bool isEmergencyRoot = false;
  static FlutterDownloader flutterDownloader = FlutterDownloader();

  static Map<String, WidgetBuilder> appRoutes = {
    AppView.appRootView.value : (context) => AppRootView(),
    AppView.appLoginView.value : (context) => AppLoginView(),
    AppView.appCertificationView.value : (context) => AppLoginCertificationView(),
    AppView.appSignupView.value : (context) => AppSignUpView(),
    AppView.appMainView.value : (context) => AppMainView(),
    AppView.appSearchAccidentView.value : (context) => AppSearchAccidentView(),
    AppView.appUpdateAccidentView.value : (context) => AppUpdateAccidentView(),
    AppView.appResultPrView.value : (context) => AppResultPrView(),
    AppView.appDetailPrView.value : (context) => AppDetailPrView(),
    AppView.appApplyPrView.value : (context) => AppApplyPrView(),
    AppView.appChatView.value : (context) => AppChatView(),
    AppView.appAccidentDetailInfoView.value : (context) => AppAccidentDetailView(),
    AppView.appAgreeDetailInfoView.value : (context) => AppAgreeDetailInfoView(),
    AppView.appSignOutView.value : (context) => AppSignOutView(),
    AppView.appAgreeDetailInfoViewTest.value : (context) => AppAgreeDetailInfoViewTest(),
    AppView.debugForAdminView.value : (context) => DebugForAdminView(),
  };

  static Future<void> initAppState(Function(bool isSuccess) callback) async{
    try{
      bool isValid = true;
      final ref = FirebaseDatabase.instance.ref();
      final appInfoSnapshot = await ref.child('UPFIN/APP_STATE/app_info').get();
      final appSateInfoSnapshot = await ref.child('UPFIN/APP_STATE/app_info/state').get();
      final appForDeviceInfoSnapshot = isAndroid? await ref.child('UPFIN/APP_STATE/android_state').get()
          : await ref.child('UPFIN/APP_STATE/ios_state').get();

      if(appInfoSnapshot.exists){
        for(var each in appInfoSnapshot.children){
          switch(each.key){
            case "close_text" : appInfoTextMap["close_text"] = each.value.toString();
            case "info_text" : appInfoTextMap["info_text"] = each.value.toString();
            case "close_version" : appInfoTextMap["close_text_version"] = int.parse(each.value.toString());
            case "info_version" : appInfoTextMap["info_text_version"] = int.parse(each.value.toString());
          }
        }
      }else{
        isValid = false;
      }

      if(appSateInfoSnapshot.exists){
        for(var each in appSateInfoSnapshot.children){
          if(each.key != null) stateInfoMap[each.key!] = int.parse(each.value.toString());
        }
      }else{
        isValid = false;
      }

      if(appForDeviceInfoSnapshot.exists){
        for(var each in appForDeviceInfoSnapshot.children){
          switch(each.key){
            case "app_download_url" : appStoreUrl = each.value.toString();
            case "app_state" : appState = int.parse(each.value.toString());
            case "app_version" : appVersion = each.value.toString();
          }
        }
      }else{
        isValid = false;
      }

      if(await _isNeedToUpdateVersion()){
        appState = stateInfoMap["update"];
      }

      if(isValid){
        callback(true);
      }else{
        callback(false);
      }

    }catch(e){
      CommonUtils.log("e", "init app state error : ${e.toString()}");
      callback(false);
    }
  }

  static Future<bool> _isNeedToUpdateVersion() async {
    bool result = false;
    String yamlValue = await rootBundle.loadString("pubspec.yaml");
    var yamlDoc = loadYaml(yamlValue);
    String version = yamlDoc["version"].toString();
    if(version == appVersion){
      result = false;
    }else{
      result = true;
    }

    return result;
  }
}

enum AppView {
  appRootView, appLoginView, appCertificationView, appSignupView, appMainView, appSearchAccidentView, appSignOutView,
  appUpdateAccidentView, appResultPrView, appDetailPrView, appApplyPrView, appChatView, appAccidentDetailInfoView, appAgreeDetailInfoView, appAgreeDetailInfoViewTest,
  debugForAdminView
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
      case AppView.appSignOutView:
        return '/appSignOutView';
      case AppView.appAgreeDetailInfoViewTest:
        return '/appAgreeDetailInfoViewTest';
      case AppView.debugForAdminView:
        return '/debugForAdminView';
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