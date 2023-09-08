import '../utils/common_utils.dart';

class MyData {
  static String name = "";
  static String phoneNumber = "";
  static String carrierType = "";
  static String email = "";
  static String birth = "";
  static bool isMale = false;
  static bool initSearchViewFromMainView = false;

  static String birthFromPhoneCert = "";
  static String carrierTypeFromPhoneCert = "";
  static bool isMaleFromPhoneCert = false;

  static bool isSnsLogin = false;
  static String nameFromSns = "";
  static String emailFromSns = "";
  static String phoneNumberFromSns = "";

  static void printData(){
    CommonUtils.log("i", "\n"
        "name:$name\n"
        "name:$phoneNumber\n"
        "name:$carrierType\n"
        "name:$email\n"
        "name:$birth\n"
        "name:$isMale\n"
    );
  }

  static void resetMyData(){
    name = "";
    phoneNumber = "";
    carrierType = "";
    email = "";
    birth = "";
    isMale = false;
    initSearchViewFromMainView = false;
    isSnsLogin = false;
    nameFromSns = "";
    emailFromSns = "";
    phoneNumberFromSns = "";
    birthFromPhoneCert = "";
    carrierTypeFromPhoneCert = "";
    isMaleFromPhoneCert = false;
  }
}