import 'package:upfin/datas/accident_info_data.dart';
import 'package:upfin/datas/loan_info_data.dart';
import 'package:upfin/datas/pr_docs_info_data.dart';
import 'package:upfin/datas/pr_info_data.dart';
import '../utils/common_utils.dart';
import 'chatroom_info_data.dart';

class MyData {
  // user data
  static String name = "";
  static String phoneNumber = "";
  static String telecom = "";
  static String email = "";
  static String birth = "";
  static bool isMale = false;
  static String idNumber = "";
  static String jobInfo = "";
  static String customerUidForNiceCert = "";
  static String birthFromPhoneCert = "";
  static String telecomTypeFromPhoneCert = "";
  static bool isMaleFromPhoneCert = false;
  static bool isSnsLogin = false;
  static String nameFromSns = "";
  static String emailFromSns = "";
  static String phoneNumberFromSns = "";
  static List<Map<String,dynamic>> agreeDocsList = [];

  // accident data
  static final List<AccidentInfoData> _accidentInfoList = [];
  static List<AccidentInfoData> getAccidentInfoList(){
    return _accidentInfoList;
  }
  static void addToAccidentInfoList(AccidentInfoData accidentInfoData){
    bool isHere = false;
    for(var each in _accidentInfoList){
      if(accidentInfoData.accidentUid == each.accidentUid){
        isHere = true;
      }
    }
    if(!isHere){
      _accidentInfoList.add(accidentInfoData);
    }
  }
  static String findUidInAccidentInfoList(String targetAccidentCaseNumber){
    String resultUid = "";

    int maxId = -1;
    for(var each in _accidentInfoList){
      if(targetAccidentCaseNumber == "${each.accidentCaseNumberYear}${each.accidentCaseNumberType}${each.accidentCaseNumberNumber}"){
        if(maxId < int.parse(each.id)){
          maxId = int.parse(each.id);
          resultUid = each.accidentUid;
        }
      }
    }

    return resultUid;
  }
  static void clearAccidentInfoList(){
    _accidentInfoList.clear();
  }
  static bool isPossibleAccidentInfo(AccidentInfoData selectedInfo){
    bool isSuccessToGetDetailInfo = true;
    if(selectedInfo.resData.isNotEmpty && selectedInfo.resData.containsKey("resRepaymentList")){
      if(selectedInfo.resData["resRepaymentList"][0]["resAmount"] == ""
          || selectedInfo.resData["resRepaymentList"][0]["resRoundNo"] == ""
          || selectedInfo.resData["resRepaymentList"][0]["resUnpaidAmt"] == ""
          || selectedInfo.resData["resRepaymentList"][0]["resRoundNo2"] == ""
          || selectedInfo.resData["resRepaymentList"][0]["resRoundNo1"] == ""
          || selectedInfo.resData["resRepaymentList"][0]["resTotalAmt"] == ""
          || selectedInfo.resData["resRepaymentList"][0]["resRepaymentCycle"] == ""){
        isSuccessToGetDetailInfo = false;
      }
    }else{
      isSuccessToGetDetailInfo = false;
    }

    return isSuccessToGetDetailInfo;
  }

  // loan data
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
  static void sortLoanInfoList(){
    _loanInfoList.sort((a,b) => DateTime.parse(b.createdDate).compareTo(DateTime.parse(a.createdDate)));
  }
  static void clearLoanInfoList(){
    _loanInfoList.clear();
  }

  // loan chat data
  static final List<ChatRoomInfoData> _chatRoomInfoList = [];
  static List<ChatRoomInfoData> getChatRoomInfoList(){
    return _chatRoomInfoList;
  }
  static void addToChatRoomInfoList(ChatRoomInfoData chatRoomInfoData){
    bool isAdded = false;
    for(var each in _chatRoomInfoList){
      if(each.chatRoomId == chatRoomInfoData.chatRoomId){
        isAdded = true;
      }
    }

    if(!isAdded){
      _chatRoomInfoList.add(chatRoomInfoData);
    }
  }
  /*
  static void sortChatRoomInfoList(){
    _chatRoomInfoList.sort((a,b){
      int yearA = int.parse(a.chatRoomLastMsgTime.substring(0, 4));
      int monthA = int.parse(a.chatRoomLastMsgTime.substring(4, 6));
      int dayA = int.parse(a.chatRoomLastMsgTime.substring(6, 8));
      int hourA = int.parse(a.chatRoomLastMsgTime.substring(8, 10));
      int minuteA = int.parse(a.chatRoomLastMsgTime.substring(10, 12));
      int secondA = int.parse(a.chatRoomLastMsgTime.substring(12, 14));
      var dateA = DateTime(yearA, monthA, dayA, hourA, minuteA, secondA);

      int yearB = int.parse(b.chatRoomLastMsgTime.substring(0, 4));
      int monthB = int.parse(b.chatRoomLastMsgTime.substring(4, 6));
      int dayB = int.parse(b.chatRoomLastMsgTime.substring(6, 8));
      int hourB = int.parse(b.chatRoomLastMsgTime.substring(8, 10));
      int minuteB = int.parse(b.chatRoomLastMsgTime.substring(10, 12));
      int secondB = int.parse(b.chatRoomLastMsgTime.substring(12, 14));
      var dateB = DateTime(yearB, monthB, dayB, hourB, minuteB, secondB);

      return dateA.compareTo(dateB);
    });
  }
  */

  static void clearChatRoomInfoList(){
    _chatRoomInfoList.clear();
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
  static AccidentInfoData? selectedAccidentInfoData;

  static void printData(){
    String selectedPrInfoDataCheck = "";
    if(selectedPrInfoData != null){
      selectedPrInfoDataCheck = selectedPrInfoData!.productOfferRid.toString();
    }
    String selectedAccidentInfoDataCheck = "";
    if(selectedAccidentInfoData != null){
      selectedAccidentInfoDataCheck = selectedAccidentInfoData!.accidentUid.toString();
    }
    CommonUtils.log("", "\n"
        "name:$name\n"
        "phoneNumber:$phoneNumber\n"
        "carrierType:$telecom\n"
        "email:$email\n"
        "birth:$birth\n"
        "isMale:$isMale\n"
        "jobInfo:$jobInfo\n"
        "idNumber:$idNumber\n"
        "customerUidForNiceCert:$customerUidForNiceCert\n"
        "accidentInfoList: ${_accidentInfoList.length}\n"
        "loanInfoList: ${_loanInfoList.length}\n"
        "chatRoomInfoList: ${_chatRoomInfoList.length}\n"
        "prInfoList: ${_prInfoList.length}\n"
        "prDocsInfoList: ${_prDocsInfoList.length}\n"
        "selectedPrInfoData: $selectedPrInfoDataCheck\n"
        "selectedAccidentInfoData: $selectedAccidentInfoDataCheck\n"
    );
  }

  static void resetMyData(){
    CommonUtils.log("i", "Clear my data");
    name = "";
    phoneNumber = "";
    telecom = "";
    email = "";
    birth = "";
    isMale = false;
    jobInfo = "";
    idNumber = "";
    isSnsLogin = false;
    nameFromSns = "";
    emailFromSns = "";
    phoneNumberFromSns = "";
    birthFromPhoneCert = "";
    telecomTypeFromPhoneCert = "";
    isMaleFromPhoneCert = false;
    clearAccidentInfoList();
    clearLoanInfoList();
    clearPrInfoList();
    clearPrDocsInfoList();
    clearChatRoomInfoList();
    selectedPrInfoData = null;
    selectedAccidentInfoData = null;
    agreeDocsList.clear();
  }
}