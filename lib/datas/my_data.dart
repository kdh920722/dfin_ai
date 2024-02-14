import 'package:dfin/datas/accident_info_data.dart';
import 'package:dfin/datas/loan_info_data.dart';
import 'package:dfin/datas/pr_docs_info_data.dart';
import 'package:dfin/datas/pr_info_data.dart';
import '../utils/common_utils.dart';
import 'car_info_data.dart';
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
  static bool isTestUser = false;
  static bool isLogout = true;

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

  // accident data
  static final List<CarInfoData> _carInfoList = [];
  static List<CarInfoData> getCarInfoList(){
    return _carInfoList;
  }
  static void addToCarInfoList(CarInfoData carInfoData){
    bool isHere = false;
    for(var each in _carInfoList){
      if(carInfoData.carUid == each.carUid){
        isHere = true;
      }
    }
    if(!isHere){
      _carInfoList.add(carInfoData);
    }
  }
  static String findUidInCarInfoList(String targetCarNum){
    String resultUid = "";

    int maxId = -1;
    for(var each in _carInfoList){
      if(targetCarNum == each.carNum){
        if(maxId < int.parse(each.id)){
          maxId = int.parse(each.id);
          resultUid = each.carUid;
        }
      }
    }

    return resultUid;
  }
  static void clearCarInfoList(){
    _carInfoList.clear();
  }

  static void sortLoanInfoList(){
    _loanInfoList.sort((a,b) => DateTime.parse(b.createdDate).compareTo(DateTime.parse(a.createdDate)));
  }
  static void clearLoanInfoList(){
    _loanInfoList.clear();
  }
  static void updateStatusToLoanInfoAndChatRoomInfo(String roomId, String statusId) {
    for(int i1 = 0 ; i1 < _loanInfoList.length ; i1 ++){
      if(roomId == _loanInfoList[i1].chatRoomId){
        _loanInfoList[i1].statueId = statusId;
        for(int i2 = 0 ; i2 < _chatRoomInfoList.length ; i2 ++){
          if(roomId == _chatRoomInfoList[i2].chatRoomId){
            _chatRoomInfoList[i2].chatRoomLoanStatus = statusId;
          }
        }
      }
    }
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

  static void clearChatRoomInfoList(){
    _chatRoomInfoList.clear();
  }

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

  static final List<PrDocsInfoData> _prRetryDocsInfoList = [];
  static List<PrDocsInfoData> getPrRetryDocsInfoList(){
    return _prRetryDocsInfoList;
  }
  static void addToPrRetryDocsInfoList(PrDocsInfoData prRetryDocsInfoData){
    _prRetryDocsInfoList.add(prRetryDocsInfoData);
  }
  static void clearPrRetryDocsInfoList(){
    _prRetryDocsInfoList.clear();
  }

  static PrInfoData? selectedPrInfoData;
  static AccidentInfoData? selectedAccidentInfoData;
  static CarInfoData? selectedCarInfoData;

  static void printData(){
    String selectedPrInfoDataCheck = "";
    if(selectedPrInfoData != null){
      selectedPrInfoDataCheck = selectedPrInfoData!.productOfferRid.toString();
    }
    String selectedAccidentInfoDataCheck = "";
    if(selectedAccidentInfoData != null){
      selectedAccidentInfoDataCheck = selectedAccidentInfoData!.accidentUid.toString();
    }
    String selectedCarInfoDataCheck = "";
    if(selectedCarInfoData != null){
      selectedCarInfoDataCheck = selectedCarInfoData!.carUid.toString();
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
        "selectedCarInfoData: $selectedCarInfoDataCheck\n"
    );
  }

  static void resetMyData(){
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
    isTestUser = false;
    clearAccidentInfoList();
    clearCarInfoList();
    clearLoanInfoList();
    clearPrInfoList();
    clearPrDocsInfoList();
    clearChatRoomInfoList();
    clearPrRetryDocsInfoList();
    selectedPrInfoData = null;
    selectedAccidentInfoData = null;
  }
}