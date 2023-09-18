import 'package:upfin/datas/accident_info_data.dart';
import 'package:upfin/datas/loan_info_data.dart';
import 'package:upfin/datas/pr_docs_info_data.dart';
import 'package:upfin/datas/pr_info_data.dart';
import '../utils/common_utils.dart';

class MyData {
  static String name = "";
  static String phoneNumber = "";
  static String telecom = "";
  static String email = "";
  static String birth = "";
  static bool isMale = false;
  static String jobInfo = "";
  static String idNumber = "";
  static String customerUidForNiceCert = "";
  static bool initSearchViewFromMainView = false;

  static String birthFromPhoneCert = "";
  static String telecomTypeFromPhoneCert = "";
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

  static final List<LoanInfoData> _loanInfoList = [];
  static List<LoanInfoData> getLoanInfoList(){
    return _loanInfoList;
  }
  static void addToLoanInfoList(LoanInfoData loanInfoData){
    bool isAdded = false;
    for(var each in _loanInfoList){
      if(each.loanUid == loanInfoData.loanUid){
        isAdded = true;
      }
    }

    if(!isAdded){
      _loanInfoList.add(loanInfoData);
    }
  }
  static void clearLoanInfoList(){
    _loanInfoList.clear();
  }

  //12:신분증  13:개인회생사건조회  1:주민등록등본  2:주민등록초본  3:건강보험자격득실확인서  4:건강보험납부확인서
  static final List<PrInfoData> _prInfoList = [];
  static List<PrInfoData> getPrInfoList(){
    return _prInfoList;
  }
  static void sortPrInfoListBy(bool isOrderByLimit){
    if(isOrderByLimit){
      _prInfoList.sort((a,b){
        int comparison = double.parse(a.productLoanLimit).compareTo(double.parse(b.productLoanLimit));
        if (comparison == 0) {
          return double.parse(a.productLoanMinRates).compareTo(double.parse(b.productLoanMinRates));
        } else {
          return double.parse(b.productLoanLimit).compareTo(double.parse(a.productLoanLimit));
        }
      });
    }else{
      _prInfoList.sort((a,b){
        int comparison = double.parse(a.productLoanMinRates).compareTo(double.parse(b.productLoanMinRates));
        if (comparison == 0) {
          return double.parse(b.productLoanLimit).compareTo(double.parse(a.productLoanLimit));
        } else {
          return double.parse(a.productLoanMinRates).compareTo(double.parse(b.productLoanMinRates));
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

  static final List<PrDocsInfoData> _prDocsInfoList = [];
  static List<PrDocsInfoData> getPrDocsInfoList(){
    return _prDocsInfoList;
  }
  static void addToPrDocsInfoList(PrDocsInfoData prDocsInfoData){
    _prDocsInfoList.add(prDocsInfoData);
  }
  static void clearPrDocsInfoList(){
    _prDocsInfoList.clear();
  }

  static PrInfoData? selectedPrInfoData;

  static void printData(){
    String selectedPrInfoDataCheck = "";
    if(selectedPrInfoData != null){
      selectedPrInfoDataCheck = selectedPrInfoData!.productOfferRid.toString();
    }
    CommonUtils.log("i", "\n"
        "name:$name\n"
        "phoneNumber:$phoneNumber\n"
        "carrierType:$telecom\n"
        "email:$email\n"
        "birth:$birth\n"
        "isMale:$isMale\n"
        "idNumber:$idNumber\n"
        "customerUidForNiceCert:$customerUidForNiceCert\n"
        "jobInfo:$jobInfo\n"
        "accidentInfoList: ${_accidentInfoList.length}\n"
        "loanInfoList: ${_loanInfoList.length}\n"
        "prInfoList: ${_prInfoList.length}\n"
        "prDocsInfoList: ${_prDocsInfoList.length}\n"
        "selectedPrInfoData: $selectedPrInfoDataCheck\n"
    );
  }

  static void resetMyData(){
    name = "";
    phoneNumber = "";
    telecom = "";
    email = "";
    birth = "";
    isMale = false;
    idNumber = "";
    initSearchViewFromMainView = false;
    isSnsLogin = false;
    nameFromSns = "";
    emailFromSns = "";
    phoneNumberFromSns = "";
    birthFromPhoneCert = "";
    telecomTypeFromPhoneCert = "";
    isMaleFromPhoneCert = false;
    jobInfo = "";
    clearAccidentInfoList();
    clearLoanInfoList();
    clearPrInfoList();
    clearPrDocsInfoList();
    selectedPrInfoData = null;
  }
}