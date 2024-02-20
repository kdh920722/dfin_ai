import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../datas/my_data.dart';
import '../utils/common_utils.dart';

class SharedPreferenceController {
  static final SharedPreferenceController _instance = SharedPreferenceController._internal();
  factory SharedPreferenceController() => _instance;
  SharedPreferenceController._internal();

  static String sharedPreferenceIdKey = "KEY_ID";
  static String sharedPreferencePwKey = "KEY_PW";
  static String sharedPreferenceApplyPrKey = "KEY_APPLY_PR";
  static String sharedPreferenceValidDateKey = "VALID_DATE";
  static String sharedPreferenceFileName = "FILE_NAME_KEY";
  static String sharedPreferenceSnsToken = "SNS_TOKEN";
  static String sharedPreferenceSnsId = "SNS_ID";
  static String sharedPreferenceSnsType = "SNS_TYPE";
  static String sharedPreferenceIsSnsLogin = "IS_SNS_LOGIN";
  static String sharedPreferenceValidInfoVersion = "VALID_INFO_VERSION";
  static String sharedPreferenceValidInfoDateKey = "VALID_INFO_DATE";
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
    CommonUtils.log("", "[s]: save origin value: $value");
    if(key == sharedPreferenceIdKey || key == sharedPreferencePwKey || key == sharedPreferenceApplyPrKey
        || key == sharedPreferenceSnsToken || key == sharedPreferenceSnsId){
      value = CommonUtils.encryptData(value);
      CommonUtils.log("", "[s]: save encoded value: $value");
    }

    await sharedPreferences!.setString(key, value);
    String returnValue = sharedPreferences!.getString(key)!;
    CommonUtils.log("", "[d]: saved value: $returnValue");
  }

  static String getSharedPreferenceValue(String key){
    try{
      if(sharedPreferences!.containsKey(key)){
        String? returnValue = sharedPreferences!.getString(key);
        if(returnValue != null){
          if(key == sharedPreferenceIdKey || key == sharedPreferencePwKey || key == sharedPreferenceApplyPrKey
              || key == sharedPreferenceSnsToken || key == sharedPreferenceSnsId){
            returnValue = CommonUtils.decryptData(returnValue);
          }
          return returnValue;
        }else{
          return "";
        }
      }else{
        return "";
      }
    }catch(error){
      CommonUtils.log('e', error.toString());
      return "";
    }
  }

  static void deleteValidAutoLoginData(){
    try{
      if(sharedPreferences!.containsKey(sharedPreferenceValidDateKey)){
        sharedPreferences!.remove(sharedPreferenceValidDateKey);
      }
    }catch(error){
      CommonUtils.log('e', error.toString());
    }
  }

  static void deleteApplyPrJsonData(){
    if(sharedPreferences!.containsKey(sharedPreferenceApplyPrKey)){
      String savedValue = getSharedPreferenceValue(SharedPreferenceController.sharedPreferenceApplyPrKey);
      List<Map<String, dynamic>> tempList = List<Map<String, dynamic>>.from(jsonDecode(savedValue));
      DateTime currentTime = CommonUtils.getCurrentLocalTime();
      DateTime minus3Days = currentTime.subtract(MyData.isTestUser? const Duration(hours: 1) : const Duration(days: 3));

      bool isValid = false;
      for(Map<String, dynamic> eachTemp in tempList){
        if(eachTemp.containsKey("doc_date")){
          DateTime savedTime = CommonUtils.convertStringToTime(eachTemp["doc_date"]);
          if(minus3Days.isBefore(savedTime)){
            isValid = true;
          }
        }
      }
      if(!isValid){
        sharedPreferences!.remove(sharedPreferenceApplyPrKey);
      }
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

      if(sharedPreferences!.containsKey(sharedPreferenceIsSnsLogin)){
        sharedPreferences!.remove(sharedPreferenceIsSnsLogin);
      }

      if(sharedPreferences!.containsKey(sharedPreferenceSnsToken)){
        sharedPreferences!.remove(sharedPreferenceSnsToken);
      }

      if(sharedPreferences!.containsKey(sharedPreferenceSnsId)){
        sharedPreferences!.remove(sharedPreferenceSnsId);
      }

      if(sharedPreferences!.containsKey(sharedPreferenceSnsType)){
        sharedPreferences!.remove(sharedPreferenceSnsType);
      }

      if(sharedPreferences!.containsKey(sharedPreferenceFileName)){
        sharedPreferences!.remove(sharedPreferenceFileName);
      }

      if(sharedPreferences!.containsKey(sharedPreferenceApplyPrKey)){
        sharedPreferences!.remove(sharedPreferenceApplyPrKey);
      }

      if(sharedPreferences!.containsKey(sharedPreferenceValidDateKey)){
        sharedPreferences!.remove(sharedPreferenceValidDateKey);
      }

      if(sharedPreferences!.containsKey(sharedPreferenceValidInfoVersion)){
        sharedPreferences!.remove(sharedPreferenceValidInfoVersion);
      }

      if(sharedPreferences!.containsKey(sharedPreferenceValidInfoDateKey)){
        sharedPreferences!.remove(sharedPreferenceValidInfoDateKey);
      }


    }catch(error){
      CommonUtils.log('e', error.toString());
    }
  }

}