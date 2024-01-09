import 'package:facebook_app_events/facebook_app_events.dart';
import '../utils/common_utils.dart';

class FacebookController{
  static final FacebookController _instance = FacebookController._internal();
  factory FacebookController() => _instance;
  FacebookController._internal();

  static FacebookAppEvents? facebookAppEvents;

  static Future<void> initFacebookEventLog() async{
    try{
      facebookAppEvents = FacebookAppEvents();
      facebookAppEvents!.setAutoLogAppEventsEnabled(true);
      facebookAppEvents!.setAdvertiserTracking(enabled: true);
    }catch(e){
      CommonUtils.log("e", "facebook init error : ${e.toString()}");
    }
  }
}