import 'package:upfin/datas/accident_info_data.dart';
import 'package:upfin/datas/pr_info_data.dart';
import '../utils/common_utils.dart';

class MyData {
  static String name = "";
  static String phoneNumber = "";
  static String telecom = "";
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

  static final List<AccidentInfoData> _accidentInfoList = [];
  static List<AccidentInfoData> getAccidentInfoList(){
    return _accidentInfoList;
  }
  static void addToAccidentInfoList(AccidentInfoData accidentInfoData){
    bool isAdded = false;
    for(var each in _accidentInfoList){
      if("${each.accidentCaseNumberYear}${each.accidentCaseNumberType}${each.accidentCaseNumberNumber}" ==
          "${accidentInfoData.accidentCaseNumberYear}${accidentInfoData.accidentCaseNumberType}${accidentInfoData.accidentCaseNumberNumber}"){
        isAdded = true;
      }
    }

    if(!isAdded){
      _accidentInfoList.add(accidentInfoData);
    }
  }
  static String findUidInAccidentInfoList(String targetAccidentCaseNumber){
    String resultUid = "";
    for(var each in _accidentInfoList){
      if(targetAccidentCaseNumber == "${each.accidentCaseNumberYear}${each.accidentCaseNumberType}${each.accidentCaseNumberNumber}"){
        resultUid = each.accidentUid;
      }
    }

    return resultUid;
  }
  static void clearAccidentInfoList(){
    _accidentInfoList.clear();
  }

  static final List<PrInfoData> _prInfoList = [];
  static List<PrInfoData> getPrInfoList(){
    return _prInfoList;
  }
  static void prInfoListReOrderBy(bool isOrderByLimit){
    if(isOrderByLimit){
      _prInfoList.sort((a,b){
        int comparison = double.parse(a.productLoanLimit).compareTo(double.parse(b.productLoanLimit));
        if (comparison == 0) {
          return double.parse(a.productLoanRates).compareTo(double.parse(b.productLoanRates));
        } else {
          return double.parse(b.productLoanLimit).compareTo(double.parse(a.productLoanLimit));
        }
      });
    }else{
      _prInfoList.sort((a,b){
        int comparison = double.parse(a.productLoanRates).compareTo(double.parse(b.productLoanRates));
        if (comparison == 0) {
          return double.parse(b.productLoanLimit).compareTo(double.parse(a.productLoanLimit));
        } else {
          return double.parse(a.productLoanRates).compareTo(double.parse(b.productLoanRates));
        }
      });
    }
  }
  static void addToPrInfoList(PrInfoData prInfoData){
    _prInfoList.add(prInfoData);
  }
  static void clearPrInfoList(){
    _prInfoList.clear();
  }

  static void printData(){
    CommonUtils.log("i", "\n"
        "name:$name\n"
        "phoneNumber:$phoneNumber\n"
        "carrierType:$telecom\n"
        "email:$email\n"
        "birth:$birth\n"
        "isMale:$isMale\n"
        "accidentInfoList: ${_accidentInfoList.length}\n"
        "prInfoList: ${_prInfoList.length}\n"
    );
  }

  static void resetMyData(){
    name = "";
    phoneNumber = "";
    telecom = "";
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
    clearAccidentInfoList();
    clearPrInfoList();
  }
}