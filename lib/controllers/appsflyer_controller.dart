import 'package:firebase_database/firebase_database.dart';
import '../utils/common_utils.dart';

class AppsflyerController{
  static final AppsflyerController _instance = AppsflyerController._internal();
  factory AppsflyerController() => _instance;
  AppsflyerController._internal();

  static String devKey = "";
  static String inviteKey = "";
  static String appIdForIos = "";

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
}