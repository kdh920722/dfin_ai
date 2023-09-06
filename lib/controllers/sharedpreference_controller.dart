import 'package:shared_preferences/shared_preferences.dart';
import '../utils/common_utils.dart';

class SharedPreferenceController {
  static final SharedPreferenceController _instance = SharedPreferenceController._internal();
  factory SharedPreferenceController() => _instance;
  SharedPreferenceController._internal();

  static String sharedPreferenceIdKey = "KEY_ID";
  static String sharedPreferencePwKey = "KEY_PW";
  static SharedPreferences? sharedPreferences;

  static Future<void> initSharedPreference(Function(bool) callback) async {
    try{
      sharedPreferences = await SharedPreferences.getInstance();
      callback(true);
    }catch(e){
      CommonUtils.log("e", "sharedPreference init error : ${e.toString()}");
      callback(false);
    }

  }

  static Future<void> saveSharedPreference(String key, String value) async {
    await sharedPreferences!.setString(key, value);
    String returnValue = sharedPreferences!.getString(key)!;
    CommonUtils.log('i', "sharedPreference saved value : $returnValue");
  }

  static String getSharedPreferenceValue(String key){
    try{
      if(sharedPreferences!.containsKey(key)){
        String? returnValue = sharedPreferences!.getString(key);
        if(returnValue != null){
          CommonUtils.log('i', "sharedPreference get value : $returnValue");
          return returnValue;
        }else{
          return "";
        }
      }else{
        return "";
      }
    }catch(e){
      CommonUtils.log('e', e.toString());
      return "";
    }
  }

}