import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:upfin/controllers/firebase_controller.dart';
import 'package:http/http.dart' as http;
import 'package:upfin/controllers/get_controller.dart';
import 'package:upfin/datas/accident_info_data.dart';
import 'package:upfin/datas/loan_info_data.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/datas/pr_docs_info_data.dart';
import 'dart:convert';
import '../configs/app_config.dart';
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
        CommonUtils.log('e', 'http error code : ${response.statusCode}');
        callback(false, <String,dynamic>{"error":"http연결에\n에러가 발생했습니다."});
      }
    } catch (e) {
      CommonUtils.log('e', e.toString());
      callback(false, <String,dynamic>{"error":"에러가 발생했습니다."});
    }
  }

  static Future<void> getMainOrSearchView(Function(bool isSuccess, AppView? appView) callback) async {
    try{
      // 1) 유저정보 가져오기
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
              if(customerMap.containsKey("registration_no")) MyData.idNumber = customerMap["registration_no"].toString();
              if(customerMap.containsKey("job_type_id")){

                CommonUtils.log("i", "jobjobjobjob : ${customerMap["job_type_id"]}");
                for(var each in jobList){
                  if(each.split("@")[1] == customerMap["job_type_id"].toString()){
                    MyData.jobInfo = each;
                  }
                }
              }
            }

            // 2) 사건정보 조회
            callLogfinApi(LogfinApis.getAccidentInfo, <String, dynamic>{}, (isSuccessToGetAccidentInfo, accidentInfoOutputJson){
              if(isSuccessToGetAccidentInfo){
                List<dynamic> accidentList = accidentInfoOutputJson!["accidents"];
                if(accidentList.isEmpty){
                  // 3-1) 사건정보 없으면 한도금리 조회를 위한 조건 입력 화면으로 이동(한도금리 조회 시, 사건정보 저장)
                  MyData.printData();
                  MyData.initSearchViewFromMainView = false;
                  callback(true, AppView.searchAccidentView);
                }else{
                  // 3-2) 사건정보 있으면 사건정보 이력화면(메인 뷰)로 이동(저장한걸 보여줌)
                  String bankName = "";
                  for(var eachAccident in accidentList){
                    var dataResult = jsonDecode(eachAccident["req_data"].toString())["pr"];
                    for(var eachBank in bankList){
                      if(eachBank.split("@")[1].substring(1) == dataResult["bankCode"]){
                        bankName = eachBank.split("@")[0];
                      }
                    }
                    MyData.addToAccidentInfoList(AccidentInfoData(eachAccident["uid"], dataResult["caseNumberYear"], dataResult["caseNumberType"], dataResult["caseNumberNumber"],
                        dataResult["court_name"], bankName, dataResult["bankCode"], dataResult["account"]));
                  }

                  callLogfinApi(LogfinApis.getLoansInfo, <String, dynamic>{}, (isSuccessToGetLoansInfo, loansInfoOutputJson){
                    if(isSuccessToGetLoansInfo){
                      List<dynamic> loansList = loansInfoOutputJson!["loans"];
                      if(loansList.isNotEmpty){
                        CommonUtils.log("i", " loan list in!");
                        for(var eachLoans in loansList){
                          CommonUtils.log("i", " loan ${eachLoans["accident_uid"]}\n${eachLoans["uid"]}\n"
                              "${eachLoans["selected_offer_id"]}\n${eachLoans["current_status"]}\n"
                              "${eachLoans["loan_type_id"]}\n${eachLoans["created_at"]}\n"
                              "${eachLoans["updated_at"]}\n${eachLoans["amount"]}\n");
                          MyData.addToLoanInfoList(LoanInfoData(eachLoans["accident_uid"], eachLoans["uid"],
                              int.parse(eachLoans["selected_offer_id"].toString()), int.parse(eachLoans["current_status"].toString()), int.parse(eachLoans["loan_type_id"].toString()),
                              eachLoans["created_at"], eachLoans["updated_at"], eachLoans["amount"].toString()));
                        }
                      }

                      MyData.printData();
                      MyData.initSearchViewFromMainView = true;
                      callback(true, AppView.mainView);
                    }else{
                      CommonUtils.flutterToast(loansInfoOutputJson!["error"]);
                      callback(false, null);
                    }
                  });
                }
              }else{
                CommonUtils.flutterToast(accidentInfoOutputJson!["error"]);
                callback(false, null);
              }
            });
          }else{
            CommonUtils.flutterToast("유저정보 로딩 실패\n다시 실행 해 주세요.");
            callback(false, null);
          }
        }else{
          CommonUtils.flutterToast("데이터 로딩 실패\n다시 실행 해 주세요.");
          callback(false, null);
        }
      });
    }catch(error){
      CommonUtils.flutterToast("데이터 로딩 실패\n다시 실행 해 주세요.");
      callback(false, null);
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
              MyData.addToPrInfoList(PrInfoData(offerId, each["rid"], each["lender_pr_id"].toString(), each["lender_name"], each["lender_id"].toString(),
                  each["product_name"], each["rid"], each["min_rate"].toString(), each["max_rate"].toString(),
                  each["limit"].toString(), "assets/images/deutsche_bank_icon.png", each["result"] as bool, each["msg"]));
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
  signUp, signIn, socialLogin, deleteAccount,
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
    }
  }
}