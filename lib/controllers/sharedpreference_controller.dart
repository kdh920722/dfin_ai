import 'package:shared_preferences/shared_preferences.dart';
import '../utils/common_utils.dart';

class SharedPreferenceController {
  static final SharedPreferenceController _instance = SharedPreferenceController._internal();
  factory SharedPreferenceController() => _instance;
  SharedPreferenceController._internal();

  static String sharedPreferenceIdKey = "KEY_ID";
  static String sharedPreferencePwKey = "KEY_PW";
  static String sharedPreferenceApplyPrKey = "KEY_APPLY_PR";
  static String sharedPreferenceValidDateKey = "VALID_DATE";
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
    CommonUtils.log("i", "[s]: save origin value: $value");
    if(key == sharedPreferenceIdKey || key == sharedPreferencePwKey || key == sharedPreferenceApplyPrKey){
      value = CommonUtils.encryptData(value);
      CommonUtils.log("i", "[s]: save encoded value: $value");
    }

    await sharedPreferences!.setString(key, value);
    String returnValue = sharedPreferences!.getString(key)!;
    CommonUtils.log("i", "[s]: saved value: $returnValue");
  }

  static String getSharedPreferenceValue(String key){
    try{
      if(sharedPreferences!.containsKey(key)){
        String? returnValue = sharedPreferences!.getString(key);
        if(returnValue != null){
          if(key == sharedPreferenceIdKey || key == sharedPreferencePwKey || key == sharedPreferenceApplyPrKey){
            returnValue = CommonUtils.decryptData(returnValue);
          }
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

  static void deleteAllData(){
    try{
      if(sharedPreferences!.containsKey(sharedPreferenceIdKey)){
        sharedPreferences!.remove(sharedPreferenceIdKey);
      }

      if(sharedPreferences!.containsKey(sharedPreferencePwKey)){
        sharedPreferences!.remove(sharedPreferencePwKey);
      }

      if(sharedPreferences!.containsKey(sharedPreferenceApplyPrKey)){
        sharedPreferences!.remove(sharedPreferenceApplyPrKey);
      }

      if(sharedPreferences!.containsKey(sharedPreferenceValidDateKey)){
        sharedPreferences!.remove(sharedPreferenceValidDateKey);
      }
    }catch(e){
      CommonUtils.log('e', e.toString());
    }
  }

}