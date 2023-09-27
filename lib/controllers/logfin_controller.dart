import 'package:firebase_database/firebase_database.dart';
import 'package:upfin/controllers/firebase_controller.dart';
import 'package:http/http.dart' as http;
import 'package:upfin/controllers/get_controller.dart';
import 'package:upfin/datas/accident_info_data.dart';
import 'package:upfin/datas/loan_info_data.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/datas/pr_docs_info_data.dart';
import 'dart:convert';
import '../configs/app_config.dart';
import '../datas/chatroom_info_data.dart';
import '../datas/pr_info_data.dart';
import '../utils/common_utils.dart';

class LogfinController {
  static final LogfinController _instance = LogfinController._internal();
  factory LogfinController() => _instance;
  LogfinController._internal();

  static String url = "";
  static String headerKey = "";
  static String userToken = "";
  static String niceUrl = "";
  static String niceSuccessUrl = "";

  static List<String> jobList = [];
  static List<String> courtList = [];
  static List<String> bankList = [];
  static List<String> preLoanCountList = [];

  static Future<void> initLogfin(Function(bool) callback) async {
    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('UPFIN/API/logfin').get();
      if (snapshot.exists) {
        for (var each in snapshot.children) {
          switch (each.key) {
            case "url" : url = each.value.toString();
            case "header_key" : headerKey = each.value.toString();
          }
        }

        await _initLogfinOtherData((isDataCallSuccess){
          if(isDataCallSuccess){
            callback(true);
          }else{
            callback(false);
          }
        });
      } else {
        callback(false);
      }
    } catch (e) {
      CommonUtils.log("e", "logfin init error : ${e.toString()}");
      callback(false);
    }
  }

  static Future<void> _initLogfinOtherData(Function(bool) callback) async {
    try {
      final ref = FirebaseDatabase.instance.ref();
      int failCount = 0;

      final jobSnapshot = await ref.child('UPFIN/API/logfin/list_data/job').get();
      if (jobSnapshot.exists) {
        List<String> tempList = [];
        for (var each in jobSnapshot.children) {
          tempList.add(each.value.toString());
        }
        tempList.sort((a,b)=>int.parse(a.split("@")[2]).compareTo(int.parse(b.split("@")[2])));
        jobList.addAll(tempList);
      } else {
        failCount++;
      }
      CommonUtils.log("i", "list : $jobList");

      final courtSnapshot = await ref.child('UPFIN/API/logfin/list_data/court').get();
      if (courtSnapshot.exists) {
        List<String> tempList = [];
        for (var each in courtSnapshot.children) {
          tempList.add(each.value.toString());
        }
        tempList.sort((a,b)=>int.parse(a.split("@")[2]).compareTo(int.parse(b.split("@")[2])));
        courtList.addAll(tempList);
      } else {
        failCount++;
      }
      CommonUtils.log("i", "list : $courtList");

      final bankSnapshot = await ref.child('UPFIN/API/logfin/list_data/bank').get();
      if (bankSnapshot.exists) {
        List<String> tempList = [];
        for (var each in bankSnapshot.children) {
          tempList.add(each.value.toString());
        }
        tempList.sort((a,b)=>int.parse(a.split("@")[2]).compareTo(int.parse(b.split("@")[2])));
        bankList.addAll(tempList);
      } else {
        failCount++;
      }
      CommonUtils.log("i", "list : $bankList");

      final loanCountSnapshot = await ref.child('UPFIN/API/logfin/list_data/loan_count').get();
      if (loanCountSnapshot.exists) {
        List<String> tempList = [];
        for (var each in loanCountSnapshot.children) {
          tempList.add(each.value.toString());
        }
        tempList.sort((a,b)=>int.parse(a.split("@")[2]).compareTo(int.parse(b.split("@")[2])));
        preLoanCountList.addAll(tempList);
      } else {
        failCount++;
      }
      CommonUtils.log("i", "list : $preLoanCountList");

      final niceSnapshot = await ref.child('UPFIN/API/logfin/nice').get();
      if (niceSnapshot.exists) {
        for (var each in niceSnapshot.children) {
          switch (each.key) {
            case "nice_url" : niceUrl = each.value.toString();
            case "nice_success_url" : niceSuccessUrl = each.value.toString();
          }
        }
      } else {
        failCount++;
      }
      CommonUtils.log("i", "niceUrl : $niceUrl");

      if(failCount > 0){
        callback(false);
      }else{
        callback(true);
      }
    } catch (e) {
      CommonUtils.log("e", "logfin other data init error : ${e.toString()}");
      callback(false);
    }
  }

  static Future<void> callLogfinApi(LogfinApis api, Map<String, dynamic> inputJson, Function(bool isSuccess, Map<String, dynamic>? outputJson) callback) async {
    var targetUrl = "";
    if(Config.isWeb){
      targetUrl = 'https://corsproxy.io/?${Uri.encodeComponent(url+api.value)}';
    }else{
      targetUrl = url+api.value;
    }

    if(api == LogfinApis.signIn || api == LogfinApis.signUp){
      inputJson['user']['fcm_token'] = FireBaseController.fcmToken;
    }else if(api == LogfinApis.socialLogin){
      inputJson['fcm_token'] = FireBaseController.fcmToken;
    }

    if(api != LogfinApis.signIn && api != LogfinApis.signUp && api != LogfinApis.socialLogin && api != LogfinApis.deleteAccount){
      if(userToken != ""){
        inputJson['api_token'] = userToken;
      }else{
        CommonUtils.log('e', "api_token is empty");
        callback(false, null);
      }
    }

    CommonUtils.log("i", "${api.value} inputJson :\n$inputJson");

    try {
      final url = Uri.parse(targetUrl);
      final header = "Bearer $headerKey";
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": header,
        },
        body: jsonEncode(inputJson),
      );

      final json = jsonDecode(response.body);
      CommonUtils.log('i', 'out full : \n$json');

      if (response.statusCode == 200) { // HTTP_OK
        final resultData = json;
        if(resultData["success"]){
          if(api == LogfinApis.signUp){
            LogfinController.userToken = resultData["data"]["user"]['api_token'];
            CommonUtils.log('i', "userToken : ${LogfinController.userToken}");
          }else if(api == LogfinApis.socialLogin){
            LogfinController.userToken = resultData['api_token'];
            CommonUtils.log('i', "userToken : ${LogfinController.userToken}");
          }else if(api == LogfinApis.signIn){
            LogfinController.userToken = resultData["data"]['api_token'];
            CommonUtils.log('i', "userToken : ${LogfinController.userToken}");
          }else if(api == LogfinApis.getOffers){
            callback(true, resultData);
            return;
          }
          callback(true, resultData['data']);
        }else{
          callback(false, resultData);
        }
      } else {
        final resultData = json;
        if(resultData["error"] == "Invalid Email or password."){
          callback(false, <String,dynamic>{"error":"회원가입이 필요합니다."});
        }else{
          CommonUtils.log('e', 'http error code : ${response.statusCode}');
          callback(false, <String,dynamic>{"error":"http연결에\n에러가 발생했습니다."});
        }
      }
    } catch (e) {
      CommonUtils.log('e', e.toString());
      callback(false, <String,dynamic>{"error":"에러가 발생했습니다."});
    }
  }

  static Future<void> getMainViewInfo(Function(bool isSuccess) callback) async {
    try{
      // 1) 유저정보 가져오기
      getUserInfo((isSuccessToGetUserInfo){
        if(isSuccessToGetUserInfo){
          getAccidentInfo((isSuccessToGetAccidentInfo, isAccidentInfoNotEmpty){
            if(isSuccessToGetAccidentInfo){
              if(isAccidentInfoNotEmpty){
                getLoanInfo((isSuccessToGetLoanInfo, isLoanInfoNotEmpty){
                  if(isSuccessToGetLoanInfo){
                    if(isLoanInfoNotEmpty){
                      callback(true);
                    }else{
                      // 대출이력 가져오기 실패는 아니나, 데이터 없음.
                      callback(true);
                    }
                  }
                });
              }else{
                // 사건이력 가져오기 실패는 아니나, 데이터 없음.
                callback(true);
              }
            }else{
              // 사건이력 가져오기 실패
              callback(false);
            }
          });
        }else{
          // 유저정보 가져오기 실패
          callback(false);
        }
      });
    }catch(error){
      callback(false);
    }
  }

  static Future<void> getUserInfo(Function(bool isSuccess) callback) async{
    try{
      callLogfinApi(LogfinApis.getUserInfo, <String, dynamic>{}, (isSuccessToGetUserInfo, userInfoOutputJson){
        if(isSuccessToGetUserInfo){
          if(userInfoOutputJson != null){
            MyData.name = userInfoOutputJson["user"]["name"];
            MyData.email =  userInfoOutputJson["user"]["email"];
            MyData.phoneNumber = userInfoOutputJson["user"]["contact_no"];
            MyData.telecom = userInfoOutputJson["user"]["telecom"];
            MyData.birth =  userInfoOutputJson["user"]["birthday"];
            MyData.isMale =  userInfoOutputJson["user"]["gender"] == "1"? true : false;
            if(userInfoOutputJson.containsKey("customer")){
              Map<String, dynamic> customerMap = userInfoOutputJson["customer"];
              if(customerMap.containsKey("uid")) MyData.customerUidForNiceCert = customerMap["uid"].toString();
              if(customerMap.containsKey("registration_no")) MyData.idNumber = customerMap["registration_no"] == null? "" : customerMap["registration_no"].toString();
              if(customerMap.containsKey("job_type_id")){
                for(var eachJob in jobList){
                  if(eachJob.split("@")[1] == customerMap["job_type_id"].toString()){
                    MyData.jobInfo = eachJob;
                  }
                }
              }
            }

            MyData.printData();
            callback(true);
          }else{
            callback(false);
          }
        }else{
          callback(false);
        }
      });
    }catch(error){
      callback(false);
    }
  }

  static Future<void> getAccidentInfo(Function(bool isSuccess, bool isNotEmpty) callback) async{
    try{
      callLogfinApi(LogfinApis.getAccidentInfo, <String, dynamic>{}, (isSuccessToGetAccidentInfo, accidentInfoOutputJson){
        if(isSuccessToGetAccidentInfo){
          if(accidentInfoOutputJson != null){
            List<dynamic> accidentList = accidentInfoOutputJson["accidents"];
            if(accidentList.isEmpty){
              GetController.to.resetMainAccidentDataChangedFlag();
              callback(true, false);
            }else {
              MyData.clearAccidentInfoList();
              String bankInfo = "";
              String courtInfo = "";
              String lendCountInfo = "";
              for(var eachAccident in accidentList){
                Map<String, dynamic> dataResult = eachAccident;

                for(var eachBank in bankList){
                  if(eachBank.split("@")[0] == dataResult["refund_bank"]){
                    bankInfo = eachBank;
                  }
                }
                for(var eachCourt in courtList){
                  if(eachCourt.split("@")[0] == dataResult["courtname"]){
                    courtInfo = eachCourt;
                  }
                }
                String lendCount = dataResult["lend_count"].toString() == ""? "0" : dataResult["lend_count"].toString();
                int count = int.parse(lendCount);
                if(count == 0){
                  lendCountInfo = preLoanCountList[0];
                }else if(count == 1){
                  lendCountInfo = preLoanCountList[1];
                }else{
                  lendCountInfo = preLoanCountList[2];
                }

                String lendAmount = dataResult["lend_amount"].toString() == ""? "0" : dataResult["lend_amount"].toString();
                String wishAmount = dataResult["wish_amount"].toString() == ""? "0" : dataResult["wish_amount"].toString();
                String accidentNo = dataResult["issue_no"];
                var resData = jsonDecode(dataResult["res_data"]);
                CommonUtils.log("", "accident data ====>\n"
                    "accidentUid: ${eachAccident["uid"]}\n"
                    "accidentCaseNo: $accidentNo\n"
                    "courtInfo: $courtInfo\n"
                    "bankInfo: $bankInfo\n"
                    "account: ${dataResult["refund_account"]}\n"
                    "lendCountInfo: $lendCountInfo\n"
                    "lend_amount: ${dataResult["lend_amount"]}\n"
                    "wish_amount: ${dataResult["wish_amount"]}\n"
                    "res_data: ${resData["data"]["resRepaymentList"]}\n");
                MyData.addToAccidentInfoList(AccidentInfoData(eachAccident["uid"], accidentNo.substring(0,4), accidentNo.substring(4,6), accidentNo.substring(6),
                    courtInfo, bankInfo, dataResult["refund_account"].toString(), lendCountInfo, lendAmount, wishAmount, resData["data"]));
              }

              GetController.to.updateMainAccidentDataChangedFlag();
              callback(true, true);
            }
          }else{
            GetController.to.resetMainAccidentDataChangedFlag();
            callback(false, false);
          }
        }else{
          GetController.to.resetMainAccidentDataChangedFlag();
          callback(false, false);
        }
      });
    }catch(error){
      GetController.to.resetMainAccidentDataChangedFlag();
      callback(false, false);
    }
  }

  static Future<void> getLoanInfo(Function(bool isSuccess, bool isNotEmpty) callback) async{
    try{
      callLogfinApi(LogfinApis.getLoansInfo, <String, dynamic>{}, (isSuccessToGetLoansInfo, loansInfoOutputJson){
        if(isSuccessToGetLoansInfo){
          if(loansInfoOutputJson != null){
            List<dynamic> loansList = loansInfoOutputJson["loans"];
            if(loansList.isEmpty){
              GetController.to.resetMainLoanDataChangedFlag();
              callback(true, false);
            }else{
              MyData.clearLoanInfoList();
              for(var eachLoans in loansList){
                CommonUtils.log("", "loan data ====>\n"
                    "accidentUid: ${eachLoans["accident_uid"]}\n"
                    "loanUid: ${eachLoans["uid"]}\n"
                    "lenderPrId: ${eachLoans["lender_pr_id"]}\n"
                    "submitAmount: ${eachLoans["submit_offer"]["amount"]}\n"
                    "submitRate: ${eachLoans["submit_offer"]["interest_rate"]}\n"
                    "companyName: ${eachLoans["lender_pr"]["lender"]["name"]}\n"
                    "productName: ${eachLoans["lender_pr"]["lender"]["product_name"]}\n"
                    "contactNo: ${eachLoans["lender_pr"]["lender"]["contact_no"]}\n"
                    "createdDate: ${eachLoans["submit_offer"]["created_at"]}\n"
                    "updatedDate: ${eachLoans["submit_offer"]["updated_at"]}\n"
                    "statueId: ${eachLoans["status_info"]["id"]}\n");

                String submitAmount = eachLoans["submit_offer"]["amount"].toString().substring(0, eachLoans["submit_offer"]["amount"].toString().length-4);
                MyData.addToLoanInfoList(LoanInfoData(eachLoans["accident_uid"].toString(), eachLoans["uid"].toString(), eachLoans["lender_pr_id"].toString(),
                    submitAmount, eachLoans["submit_offer"]["interest_rate"].toString(),
                    eachLoans["lender_pr"]["lender"]["name"].toString(), "assets/images/temp_bank_logo.png", eachLoans["lender_pr"]["lender"]["product_name"].toString(), eachLoans["lender_pr"]["lender"]["contact_no"].toString(),
                    eachLoans["submit_offer"]["created_at"].toString(), eachLoans["submit_offer"]["updated_at"].toString(), eachLoans["status_info"]["id"].toString()));
              }
              MyData.sortLoanInfoList();
              _setChatRoomInfoList();
              GetController.to.updateMainLoanDataChangedFlag();
              callback(true, true);
            }
          }else{
            GetController.to.resetMainLoanDataChangedFlag();
            callback(false, false);
          }
        }else{
          GetController.to.resetMainLoanDataChangedFlag();
          callback(false, false);
        }
      });
    }catch(error){
      GetController.to.resetMainLoanDataChangedFlag();
      callback(false, false);
    }
  }
  static void _setChatRoomInfoList(){
    MyData.clearChatRoomInfoList();
    for(var eachSortedLoan in MyData.getLoanInfoList()){
      MyData.addToChatRoomInfoList(ChatRoomInfoData(eachSortedLoan.loanUid, 1, eachSortedLoan.companyLogo,
          eachSortedLoan.companyName, eachSortedLoan.productName, "현재 고객님은 2건의 심사 결과를 대기중입니다. 조금더 알아보시렵니까?", "20231008145230", 12));
    }
  }

  static Future<void> getPrList(String accidentCase, Function(bool isSuccess, Map<String, dynamic>? outputJson) callback) async {
    try{
      String accidentUid = MyData.findUidInAccidentInfoList(accidentCase);
      if(accidentUid != ""){
        Map<String, dynamic> inputJsonForGetOffers= {
          "accident_uid": accidentUid
        };
        callLogfinApi(LogfinApis.getOffers, inputJsonForGetOffers, (isSuccessToGetOffers, outputJsonForGetOffers){
          if(isSuccessToGetOffers){
            MyData.clearPrInfoList();
            String offerId = outputJsonForGetOffers!["offer_id"].toString();
            List<dynamic> offerPrList = outputJsonForGetOffers["data"];
            for(var each in offerPrList){
              CommonUtils.log("i", "$each");
              MyData.addToPrInfoList(PrInfoData(accidentUid, offerId, each["rid"], each["lender_pr_id"].toString(), each["lender_name"], each["lender_id"].toString(),
                  each["product_name"], each["rid"], each["min_rate"].toString(), each["max_rate"].toString(),
                  each["limit"].toString(), "assets/images/temp_bank_logo.png", each["result"] as bool, each["msg"]));
            }

            if(MyData.getPrInfoList().isNotEmpty){
              MyData.sortPrInfoListBy(false);
              callback(true, outputJsonForGetOffers);
            }else{
              callback(false, null);
            }
          }else{
            callback(false, null);
          }
        });
      }else{
        callback(false, null);
      }
    }catch(error){
      callback(false, null);
    }
  }

  static Future<void> getPrDocsList(String offerId, String offerRid, Function(bool isSuccess, Map<String, dynamic>? outputJson) callback) async {
    try{
      MyData.clearPrDocsInfoList();
      Map<String, dynamic> inputJson = {
        "offer_id": offerId,
        "offer_rid": offerRid,
      };
      LogfinController.callLogfinApi(LogfinApis.applyProductDocSearch, inputJson, (isSuccessToSearchDocs, outputJsonForSearchDocs){
        if(isSuccessToSearchDocs){
          for(var each in outputJsonForSearchDocs!["documents"]){
            MyData.addToPrDocsInfoList(PrDocsInfoData(each["id"], each["name"], each["del_flg"]));
          }

          if(MyData.getPrDocsInfoList().isNotEmpty){
            for(var eachInList in MyData.getPrDocsInfoList()){
              CommonUtils.log("i", "${eachInList.productDocsId}\n${eachInList.productDocsName}\n");
            }
            callback(true, outputJsonForSearchDocs);
          }else{
            callback(false, null);
          }
        }else{
          callback(false, null);
        }
      });
    }catch(error){
      callback(false, null);
    }
  }
}

enum LogfinApis {
  signUp, signIn, socialLogin, deleteAccount, prUpdateInfo,
  getUserInfo, prSearch, getOffers,
  applyProductDocSearch, applyProduct,
  getAccidentInfo, getOffersInfo,
  getLoansInfo, getLoansDetailInfo
}

extension LogfinApisExtension on LogfinApis {
  String get value {
    switch (this) {
      case LogfinApis.signUp:
        return '/users.json';
      case LogfinApis.signIn:
        return '/users/sign_in.json';
      case LogfinApis.socialLogin:
        return '/social_login.json';
      case LogfinApis.deleteAccount:
        return '/delete_account.json';
      case LogfinApis.getUserInfo:
        return '/get_user.json';
      case LogfinApis.prSearch:
        return '/pr_search.json';
      case LogfinApis.applyProductDocSearch:
        return '/apply_product_documents.json';
      case LogfinApis.applyProduct:
        return '/apply_product.json';
      case LogfinApis.getAccidentInfo:
        return '/get_accidents.json';
      case LogfinApis.getOffersInfo:
        return '/get_offers.json';
      case LogfinApis.getLoansInfo:
          return '/get_loans.json';
      case LogfinApis.getLoansDetailInfo:
        return '/get_loan.json';
      case LogfinApis.getOffers:
        return '/get_offers.json';
      case LogfinApis.prUpdateInfo:
        return '/pr_edit_complete.json';
    }
  }
}