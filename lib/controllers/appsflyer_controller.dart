import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:upfin/controllers/firebase_controller.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import 'logfin_controller.dart';

class AppsflyerController{
  static final AppsflyerController _instance = AppsflyerController._internal();
  factory AppsflyerController() => _instance;
  AppsflyerController._internal();

  static String devKey = "";
  static String inviteKey = "";
  static String appIdForIos = "";

  static AppsflyerSdk? appsFlyerSdk;
  static String appsFlyerOneLink = "";
  static int appsFlyerOneLinkCnt = 0;

  static Future<void> initAppsflyer(Function(bool) callback) async{
    try{
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('UPFIN/API/appsflyer').get();
      if (snapshot.exists) {
        for(var each in snapshot.children){
          switch(each.key){
            case "dev_key" : devKey = each.value.toString();
            case "invite_key" : inviteKey = each.value.toString();
            case "ios_app_id" : appIdForIos = each.value.toString();
          }
        }
        callback(true);
      } else {
        callback(false);
      }
    }catch(e){
      CommonUtils.log("e", "appsflyer init error : ${e.toString()}");
      callback(false);
    }
  }

  static void initAppsflyerEventLog() {
    appsFlyerSdk = Config.isAndroid?
    AppsflyerSdk(
        AppsFlyerOptions(
            afDevKey: AppsflyerController.devKey,
            appInviteOneLink : AppsflyerController.inviteKey,
            showDebug: false,
            disableAdvertisingIdentifier: false, // Optional field
            disableCollectASA: false)
    ) :
    AppsflyerSdk(
        AppsFlyerOptions(
            appId: AppsflyerController.appIdForIos,
            afDevKey: AppsflyerController.devKey,
            appInviteOneLink : AppsflyerController.inviteKey,
            showDebug: false,
            disableAdvertisingIdentifier: false, // Optional field
            disableCollectASA: false)
    );
    appsFlyerSdk!.onAppOpenAttribution((res){
      // 이미 설치 된 후, 링크 열었을 때
    });
    appsFlyerSdk!.onInstallConversionData((res){
      // 설치 된 후, 링크 열었을 때
      appsFlyerOneLink = res.toString();
      appsFlyerOneLinkCnt++;
      if(appsFlyerOneLinkCnt == 3){
        sendInfoForInstallTracking();
      }

    });
    appsFlyerSdk!.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true
    );
  }

  static Future<void> sendInfoForInstallTracking() async {
    if(appsFlyerOneLink != "" && FireBaseController.fcmToken != ""){
      String deviceId = await CommonUtils.getDeviceId();
      Map<String, dynamic> inputJson = {
        "response" : appsFlyerOneLink,
        "device_id" : deviceId,
      };
      LogfinController.callLogfinApi(LogfinApis.installTracking, inputJson, (isSuccess, outputJson){});
    }
  }
}