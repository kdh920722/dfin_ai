import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/views/app_accident_detail_view.dart';
import 'package:upfin/views/app_agree_detail_info_view.dart';
import 'package:upfin/views/app_apply_pr_view.dart';
import 'package:upfin/views/app_car_detail_view.dart';
import 'package:upfin/views/app_findpw_view.dart';
import 'package:upfin/views/app_main_view.dart';
import 'package:upfin/views/app_result_pr_view.dart';
import 'package:upfin/views/app_root_view.dart';
import 'package:upfin/views/app_search_accident_view.dart';
import 'package:upfin/views/app_search_car_view.dart';
import 'package:upfin/views/app_signout_view.dart';
import 'package:upfin/views/app_signup_view.dart';
import 'package:upfin/views/app_update_accident_view.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:upfin/views/app_update_car_view.dart';
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
  static List<Permission> permissionList = [];
  static List<Permission> storagePermissionListForAndroid = [];
  static String appVersion = "";
  static String appTestVersion = "";
  static String appStoreUrl = "";
  static String privacyUrl = "";
  static String privacyText = "";
  static String privacyText2 = "";
  static String privacyText3 = "";
  static BuildContext? contextForEmergencyBack;
  static bool isEmergencyRoot = false;
  static bool isTablet = false;
  static Map<String,dynamic> certCmpInfoMap = {};
  static bool isAutoOpen = false;

  static Map<String, WidgetBuilder> appRoutes = {
    AppView.appRootView.value : (context) => AppRootView(),
    AppView.appLoginView.value : (context) => AppLoginView(),
    AppView.appCertificationView.value : (context) => AppLoginCertificationView(),
    AppView.appSignupView.value : (context) => AppSignUpView(),
    AppView.appMainView.value : (context) => AppMainView(),
    AppView.appSearchAccidentView.value : (context) => AppSearchAccidentView(),
    AppView.appUpdateAccidentView.value : (context) => AppUpdateAccidentView(),
    AppView.appResultPrView.value : (context) => AppResultPrView(),
    AppView.appApplyPrView.value : (context) => AppApplyPrView(),
    AppView.appChatView.value : (context) => AppChatView(),
    AppView.appAccidentDetailInfoView.value : (context) => AppAccidentDetailView(),
    AppView.appAgreeDetailInfoView.value : (context) => AppAgreeDetailInfoView(),
    AppView.appSignOutView.value : (context) => AppSignOutView(),
    AppView.appFindPwView.value : (context) => AppFindPwView(),
    AppView.debugForAdminView.value : (context) => DebugForAdminView(),
    AppView.appCarDetailInfoView.value : (context) => AppCarDetailView(),
    AppView.appSearchCarView.value : (context) => AppSearchCarView(),
    AppView.appUpdateCarView.value : (context) => AppUpdateCarView(),
  };

  static bool isPad(){
    final data = MediaQueryData.fromView(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? false :true;
  }

  static Future<void> initAppState(Function(bool isSuccess) callback) async{
    try{

      if(isAndroid){
        List<Permission> permissionListForAndroid = [Permission.phone];
        permissionList.addAll(permissionListForAndroid);
      }else{
        List<Permission> permissionListForIos = [];
        permissionList.addAll(permissionListForIos);
      }

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
            case "privacy_url" : privacyUrl = each.value.toString();
            case "privacy_text" : privacyText = each.value.toString();
            case "privacy_text2" : privacyText2 = each.value.toString();
            case "privacy_text3" : privacyText3 = each.value.toString();
            case "cert_cmp_info" : certCmpInfoMap = jsonDecode(jsonEncode(each.value));
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
            case "auto_open_yn" : isAutoOpen = each.value.toString() == "y"? true : false;
          }
        }
      }else{
        isValid = false;
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

  static Future<int> isNeedToUpdateForMain() async {
    int stateCode = 10;
    final ref = FirebaseDatabase.instance.ref();
    final appForDeviceInfoSnapshot = isAndroid? await ref.child('UPFIN/APP_STATE/android_state').get()
        : await ref.child('UPFIN/APP_STATE/ios_state').get();

    if(appForDeviceInfoSnapshot.exists){
      for(var each in appForDeviceInfoSnapshot.children){
        switch(each.key){
          case "app_state" : appState = int.parse(each.value.toString());
          case "app_version" : appVersion = each.value.toString();
          case "app_test_version" : appTestVersion = each.value.toString();
        }
      }
    }

    stateCode = appState;

    if(await _isNeedToUpdateVersion()){
      stateCode = 44;
    }

    return stateCode;
  }

  static Future<String> getAppVersion() async {
    String yamlValue = await rootBundle.loadString("pubspec.yaml");
    var yamlDoc = loadYaml(yamlValue);
    return yamlDoc["version"].toString();
  }

  static Future<bool> _isNeedToUpdateVersion() async {
    bool result = false;
    String version = await getAppVersion();
    String checkVersion = MyData.isTestUser? appTestVersion : appVersion;
    if(version == checkVersion){
      result = false;
    }else{
      result = true;
    }

    return result;
  }
}

enum AppView {
  appRootView, appLoginView, appCertificationView, appSignupView, appMainView, appSearchAccidentView, appSignOutView,
  appUpdateAccidentView, appResultPrView, appApplyPrView, appChatView, appAccidentDetailInfoView, appAgreeDetailInfoView,
  appFindPwView, debugForAdminView, appCarDetailInfoView, appSearchCarView, appUpdateCarView
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
      case AppView.appFindPwView:
        return '/appFindPwView';
      case AppView.debugForAdminView:
        return '/debugForAdminView';
      case AppView.appCarDetailInfoView:
        return '/appCarDetailInfoView';
      case AppView.appSearchCarView:
        return '/appSearchCarView';
      case AppView.appUpdateCarView:
        return '/appUpdateCarView';
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