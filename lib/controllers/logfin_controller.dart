import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/controllers/firebase_controller.dart';
import 'package:http/http.dart' as http;
import 'package:upfin/controllers/get_controller.dart';
import 'package:upfin/controllers/websocket_controller.dart';
import 'package:upfin/datas/accident_info_data.dart';
import 'package:upfin/datas/car_info_data.dart';
import 'package:upfin/datas/loan_info_data.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/datas/pr_docs_info_data.dart';
import 'dart:convert';
import '../configs/app_config.dart';
import '../datas/chatroom_info_data.dart';
import '../datas/pr_info_data.dart';
import '../styles/ColorStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

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
  static List<String> validFileTypeList = [];
  static List<String> validDocFileTypeList = [];
  static List<Map<String,dynamic>> agreeDocsList = [];
  static List<String> agreeDocsDetailTypeInfoList = [];
  static Map<String,dynamic> autoAnswerMapForAccident = {};
  static Map<String,dynamic> autoAnswerMapForCar = {};
  static Map<String,dynamic> autoAnswerMap = {};
  static void addAgreeInfo(String type, Map<String,dynamic> agreeInfo){
    int targetIdx = -1;
    for(int i = 0 ; i < agreeDocsList.length ; i++){
      if(agreeDocsList[i]["type"] == type){
        targetIdx = i;
      }
    }

    if(targetIdx != -1){
      agreeDocsList.removeAt(targetIdx);
    }

    agreeDocsList.add(agreeInfo);
  }
  static String getAgreeContents(String type){
    String result = "";
    for(var each in agreeDocsList){
      if(each["type"] == type){
        if(each["result"]["content"] != null){
          result = each["result"]["content"];
        }
      }
    }

    return result;
  }
  static String getAgreeTitle(String type){
    String result = "";
    for(var each in agreeDocsList){
      if(each["type"] == type) result = each["result"]["title"];
    }

    if(result.length > 25){
      String front = result.substring(0,25);
      String back = result.substring(25);
      if(back.length > 1){
        if(back.substring(0,1) == " "){
          back =  result.substring(26);
        }
      }
      result = "$front\n$back";
    }
    return result;
  }

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
      CommonUtils.log("", "list : $jobList");

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
      CommonUtils.log("", "list : $courtList");

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
      CommonUtils.log("", "list : $bankList");

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
      CommonUtils.log("", "list : $preLoanCountList");

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
      CommonUtils.log("", "niceUrl : $niceUrl");

      final agreeTypeSnapshot = await ref.child('UPFIN/API/logfin/list_data/agree/agreeDetailType').get();
      if (agreeTypeSnapshot.exists) {
        for (var each in agreeTypeSnapshot.children) {
          agreeDocsDetailTypeInfoList.add(each.value.toString());
        }
      } else {
        failCount++;
      }

      final fileTypeSnapshot = await ref.child('UPFIN/API/logfin/list_data/valid_file_type').get();
      if (fileTypeSnapshot.exists) {
        for (var each in fileTypeSnapshot.children) {
          validFileTypeList.add(each.value.toString().split("@").first);
          if(each.value.toString().split("@").last == "2"){
            validDocFileTypeList.add(each.value.toString().split("@").first);
          }
        }
      } else {
        failCount++;
      }

      final agreeASnapshot = await ref.child('UPFIN/API/logfin/list_data/agree/agreeA').get();
      List<String> docTypeTempList = [];
      if (agreeASnapshot.exists) {
        for (var each in agreeASnapshot.children) {
          docTypeTempList.add(each.value.toString());
        }
      } else {
        failCount++;
      }
      final agreeBSnapshot = await ref.child('UPFIN/API/logfin/list_data/agree/agreeB').get();
      if (agreeBSnapshot.exists) {
        for (var each in agreeBSnapshot.children) {
          docTypeTempList.add(each.value.toString());
        }
      } else {
        failCount++;
      }

      await LogfinController.callLogfinApi(LogfinApis.getFaqs, {"loan_type_id": "1"}, (isSuccessToGetMap, outputJsonMap){
        if(isSuccessToGetMap){
          autoAnswerMapForAccident = outputJsonMap!;
          autoAnswerMapForAccident["파일첨부 📁"] = {"카메라 📷" : "camera"};
        }else{
          failCount++;
        }
      });

      await LogfinController.callLogfinApi(LogfinApis.getFaqs, {"loan_type_id": "3"}, (isSuccessToGetMap, outputJsonMap){
        if(isSuccessToGetMap){
          autoAnswerMapForCar = outputJsonMap!;
          autoAnswerMapForCar["파일첨부 📁"] = {"카메라 📷" : "camera"};
        }else{
          failCount++;
        }
      });


      int cnt = 0;
      for(var each in docTypeTempList){
        String searchType = each.split("@")[0];
        var inputJson = {
          "type" : searchType
        };
        callLogfinApi(LogfinApis.getAgreeDocuments, inputJson, (isSuccessToGetAgreeInfo, outputJsonForGetAgreeInfo){
          cnt++;
          if(isSuccessToGetAgreeInfo){
            agreeDocsList.add({"type" : searchType, "detailType": each, "isAgree": false, "result" : outputJsonForGetAgreeInfo});
            CommonUtils.log("", "agree result : ${{"type" : searchType, "result" : outputJsonForGetAgreeInfo}}");
          }else{
            failCount++;
          }

          if(cnt == docTypeTempList.length){
            if(failCount > 0){
              callback(false);
            }else{
              callback(true);
            }
          }
        });
      }

    } catch (e) {
      CommonUtils.log("e", "logfin other data init error : ${e.toString()}");
      callback(false);
    }
  }

  static void _setAppLogByApi(LogfinApis api){
    try{
      String logValue = api.value;
      logValue = logValue.replaceAll("/", "");
      logValue = logValue.replaceAll(".json", "");
      CommonUtils.setAppLog(logValue);
    }catch(error){
      CommonUtils.log("d", error.toString());
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
      inputJson['user']['device_type'] = Config.isAndroid? "2" : "1";
    }else if(api == LogfinApis.socialLogin || api == LogfinApis.installTracking){
      inputJson['fcm_token'] = FireBaseController.fcmToken;
      inputJson['device_type'] = Config.isAndroid? "2" : "1";
    }

    if(api != LogfinApis.signIn && api != LogfinApis.signUp && api != LogfinApis.socialLogin
        && api != LogfinApis.deleteAccount && api != LogfinApis.checkMember && api != LogfinApis.getAgreeDocuments && api != LogfinApis.getFaqs
        && api != LogfinApis.findEmail && api != LogfinApis.sendEmailCode && api != LogfinApis.checkEmailCode
        && api != LogfinApis.checkMemberByPhone && api != LogfinApis.updatePassword && api != LogfinApis.installTracking){
      if(userToken != ""){
        inputJson['api_token'] = userToken;
      }else{
        CommonUtils.log('e', "api_token is empty");
        callback(false, null);
      }
    }

    CommonUtils.log("w", "${api.value} inputJson :\n$inputJson");

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
      CommonUtils.log('w', 'out full : \n$json');

      if (response.statusCode == 200) { // HTTP_OK
        final resultData = json;
        if(resultData["success"]){
          if(api != LogfinApis.getMessage && api != LogfinApis.installTracking && api != LogfinApis.getCarDocs
              && api != LogfinApis.getRetryDocs && api != LogfinApis.getAgreeDocuments && api != LogfinApis.applyProductDocSearch && api != LogfinApis.getFaqs
              && api != LogfinApis.checkMemberByPhone && api != LogfinApis.checkMember && api != LogfinApis.checkEmailCode && api != LogfinApis.checkMessage){
            _setAppLogByApi(api);
          }


          if(api == LogfinApis.signUp){
            LogfinController.userToken = resultData["data"]["user"]['api_token'];
            CommonUtils.log('i', "userToken : ${LogfinController.userToken}");
          }else if(api == LogfinApis.socialLogin){
            LogfinController.userToken = resultData['api_token'];
            CommonUtils.log('i', "userToken : ${LogfinController.userToken}");
          }else if(api == LogfinApis.signIn){
            LogfinController.userToken = resultData["data"]['api_token'];
            CommonUtils.log('i', "userToken : ${LogfinController.userToken}");
          }else if(api == LogfinApis.getOffers || api == LogfinApis.getMessage){
            callback(true, resultData);
            return;
          }else if(api == LogfinApis.getAgreeDocuments){
            callback(true, resultData);
            return;
          }else if(api == LogfinApis.getFaqs){
            callback(true, jsonDecode(resultData['data']));
            return;
          }else if(api == LogfinApis.findEmail){
            callback(true, resultData);
            return;
          }else if(api == LogfinApis.addCar){
            Map<String, dynamic> tempMap = resultData;
            Map<String, dynamic> resultMap = {};
            if(tempMap.containsKey("retry")){
              if(tempMap["retry"]){
                List<dynamic> tempDataList = [];
                List<Map<String, dynamic>> modelList = [];
                tempDataList = tempMap["data"]["modellist"];
                for(Map<String, dynamic> eachModel in tempDataList){
                  String modelName = eachModel["modelname"];
                  for(Map<String, dynamic> eachSeries in eachModel["serieslist"]){
                    String seriesNo = eachSeries["seriesno"];
                    String seriesName = eachSeries["seriesname"];
                    modelList.add({"seriesno" : seriesNo, "name1" : modelName, "name2" : seriesName});
                  }
                }

                resultMap["retry"] = true;
                resultMap["tsKey"] = tempMap["data"]["ts_key"];
                resultMap["modelList"] = modelList;
                callback(true, resultMap);
              }else{
                resultMap["retry"] = false;
                callback(true, resultMap);
              }
            }else{
              resultMap["retry"] = false;
              resultMap["car_info"] = resultData['car_info'];
              callback(true, resultMap);
            }
            return;
          }else if(api == LogfinApis.searchCarProduct){
            callback(true, resultData);
            return;
          }else if(api == LogfinApis.searchCar){
            callback(true, resultData['car_info']);
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
        }else if(resultData["error"] == "해당 이메일로 가입되지 않았거나 잘못된 비밀번호입니다."){
          callback(false, <String,dynamic>{"error":"잘못된 비밀번호입니다."});
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
          int callCnt = 0;
          bool isFailed = false;

          // 사건정보 가져오기
          getAccidentInfo((isSuccessToGetAccidentInfo, isAccidentInfoNotEmpty){
            callCnt++;
            if(!isSuccessToGetAccidentInfo){
              isFailed = true;
            }

            if(callCnt == 2){
              if(isFailed){
                callback(false);
              }else{
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
              }
            }
          });

          // 차량정보 가져오기
          getCarInfo((isSuccessToGetCarInfo, isCarInfoNotEmpty){
            callCnt++;
            if(!isSuccessToGetCarInfo){
              isFailed = true;
            }

            if(callCnt == 2){
              if(isFailed){
                callback(false);
              }else{
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
              }
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
            CommonUtils.log("w","user : ${userInfoOutputJson["user"]}");
            if(userInfoOutputJson["user"].containsKey("test_yn")){
              MyData.isTestUser = userInfoOutputJson["user"]["test_yn"].toString() == "1" ? false : true;
            }
            MyData.name = userInfoOutputJson["user"]["name"];
            MyData.email =  userInfoOutputJson["user"]["email"];
            MyData.phoneNumber = userInfoOutputJson["user"]["contact_no"].toString();
            if(userInfoOutputJson["user"]["telecom"] != null){
              MyData.telecom = userInfoOutputJson["user"]["telecom"].toString();
            }
            MyData.birth =  userInfoOutputJson["user"]["birthday"].toString();
            MyData.isMale =  userInfoOutputJson["user"]["gender"] == "1"? true : false;
            if(userInfoOutputJson.containsKey("customer")){
              Map<String, dynamic> customerMap = userInfoOutputJson["customer"];
              CommonUtils.log("w","customer : $customerMap");
              if(userInfoOutputJson["user"]["telecom"] == null && customerMap["telecom"] != null){
                MyData.telecom = customerMap["telecom"].toString();
              }
              if(customerMap.containsKey("uid")) MyData.customerUidForNiceCert = customerMap["uid"].toString();
              if(customerMap.containsKey("registration_no")) MyData.idNumber = customerMap["registration_no"] == null? "" : customerMap["registration_no"].toString();
              if(customerMap.containsKey("job_type_id")){
                CommonUtils.log("w","customer : ${customerMap['job_type_id']}");
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
              GetController.to.resetAccdientInfoList();
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

                if(dataResult.containsKey("lend_count")){
                  String lendCount = dataResult["lend_count"].toString() == ""? "0" : dataResult["lend_count"].toString();
                  int count = int.parse(lendCount);
                  if(count <= preLoanCountList.length-1){
                    for(var each in preLoanCountList){
                      if(each.split("@")[1] == count.toString()){
                        lendCountInfo = each;
                      }
                    }
                  }else{
                    lendCountInfo = preLoanCountList.last;
                  }
                }else{
                  lendCountInfo = preLoanCountList.first;
                }

                String bankAccount = dataResult["refund_account"].toString();
                String lendAmount = dataResult["lend_amount"].toString() == ""? "0" : dataResult["lend_amount"].toString();
                String wishAmount = dataResult["wish_amount"].toString() == ""? "0" : dataResult["wish_amount"].toString();
                String accidentNo = dataResult["issue_no"];
                var resData = jsonDecode(dataResult["res_data"]);
                String date = dataResult["created_at"].toString();

                String needType = dataResult["is_account_verification_needed"].toString();
                bool isNeedToCheckAccount = needType == "1" ? true : false;
                int accountType = AccidentInfoData.getAccidentAccountValidType(isNeedToCheckAccount, resData["data"]);

                CommonUtils.log("i", "accident data ====>\n"
                    "date: ${dataResult["created_at"]} || ${dataResult["updated_at"]}\n"
                    "needType : $needType\n"
                    "isNeedToCheckAccount : $isNeedToCheckAccount\n"
                    "accountType : $accountType\n"
                    "accidentUid: ${dataResult["id"]}\n"
                    "accidentUid: ${dataResult["uid"]}\n"
                    "accidentCaseNo: $accidentNo\n"
                    "courtInfo: $courtInfo\n"
                    "bankInfo: $bankInfo\n"
                    "account: $bankAccount\n"
                    "lendCountInfo: $lendCountInfo\n"
                    "lend_amount: ${dataResult["lend_amount"]}\n"
                    "wish_amount: ${dataResult["wish_amount"]}\n"
                    "res_data: ${resData["data"]["resRepaymentList"]}\n");
                MyData.addToAccidentInfoList(AccidentInfoData(dataResult["id"].toString(), dataResult["uid"], accidentNo.substring(0,4), accidentNo.substring(4,6), accidentNo.substring(6),
                    courtInfo, bankInfo, bankAccount, lendCountInfo, lendAmount, wishAmount, date, accountType, resData["data"]));
              }

              GetController.to.updateAccidentInfoList(MyData.getAccidentInfoList());
              callback(true, true);
            }
          }else{
            GetController.to.resetAccdientInfoList();
            callback(false, false);
          }
        }else{
          GetController.to.resetAccdientInfoList();
          callback(false, false);
        }
      });
    }catch(error){
      GetController.to.resetAccdientInfoList();
      callback(false, false);
    }
  }

  static Future<void> getCarInfo(Function(bool isSuccess, bool isNotEmpty) callback) async{
    try{
      callLogfinApi(LogfinApis.getMyCarInfo, <String, dynamic>{}, (isSuccessToGetCarInfo, carInfoOutputJson){
        if(isSuccessToGetCarInfo){
          if(carInfoOutputJson != null){
            List<dynamic> carList = carInfoOutputJson["cars"];
            if(carList.isEmpty){
              GetController.to.resetCarInfoList();
              callback(true, false);
            }else {
              MyData.clearCarInfoList();
              String lendCountInfo = "";
              for(var eachCarInfo in carList){
                Map<String, dynamic> dataResult = eachCarInfo;

                List<dynamic> regBList = [];
                if(dataResult.containsKey("reg_b") && dataResult["reg_b"] != null){
                  if(CommonUtils.getRubyType(dataResult["reg_b"].toString()) == 0){
                    Map<String, dynamic> regBMapTemp = {};
                    regBMapTemp = CommonUtils.parseRubyToMap(dataResult["reg_b"].toString());
                    regBList.add(CarInfoData.getConvertedRegBMap(regBMapTemp));
                  }else if(CommonUtils.getRubyType(dataResult["reg_b"].toString()) == 1){
                    List<dynamic> regBTempList = CommonUtils.parseRubyToList(dataResult["reg_b"].toString());
                    for(var each in regBTempList){
                      regBList.add(CarInfoData.getConvertedRegBMap(each));
                    }
                  }else{
                    CommonUtils.log("w", "each reg_b is null");
                  }

                  for(var each in regBList){
                    CommonUtils.log("w", "each reg_b : $each");
                  }
                }

                if(dataResult.containsKey("lend_count")){
                  String lendCount = dataResult["lend_count"].toString() == ""? "0" : dataResult["lend_count"].toString();
                  int count = int.parse(lendCount);
                  if(count <= preLoanCountList.length-1){
                    for(var each in preLoanCountList){
                      if(each.split("@")[1] == count.toString()){
                        lendCountInfo = each;
                      }
                    }
                  }else{
                    lendCountInfo = preLoanCountList.last;
                  }
                }else{
                  lendCountInfo = preLoanCountList.first;
                }

                String lendAmount = "0";
                if(dataResult.containsKey("lend_amount")){
                  lendAmount = dataResult["lend_amount"].toString() == ""? "0" : dataResult["lend_amount"].toString();
                }

                String wishAmount = "0";
                if(dataResult.containsKey("wish_amount")){
                  wishAmount = dataResult["wish_amount"].toString() == ""? "0" : dataResult["wish_amount"].toString();
                }

                String carNum = dataResult["carno"];
                String date = dataResult["created_at"].toString();


                CommonUtils.log("w", "car data ====>\n"
                    "date: ${dataResult["created_at"]}\n"
                    "carId: ${dataResult["id"]}\n"
                    "carUid: ${dataResult["uid"]}\n"
                    "carNum: $carNum\n"
                    "carOwnerName: ${dataResult["owner_name"]}\n"
                    "lendCountInfo: $lendCountInfo\n"
                    "lend_amount: $lendAmount\n"
                    "wish_amount: $wishAmount\n");
                MyData.addToCarInfoList(CarInfoData(dataResult["id"].toString(), dataResult["uid"].toString(), carNum, dataResult["owner_name"].toString(),
                    dataResult["amount"].toString(), lendCountInfo, lendAmount, wishAmount,
                    date, dataResult["car_name"].toString(), dataResult["car_name_detail"].toString(), dataResult["car_image"].toString(), regBList, eachCarInfo));
              }

              GetController.to.updateCarInfoList(MyData.getCarInfoList());
              callback(true, true);
            }
          }else{
            GetController.to.resetCarInfoList();
            callback(false, false);
          }
        }else{
          GetController.to.resetCarInfoList();
          callback(false, false);
        }
      });
    }catch(error){
      GetController.to.resetCarInfoList();
      callback(false, false);
    }
  }

  static Future<void> addCar(BuildContext context, Map<String, dynamic> inputJson, Function(bool isSuccess) callback) async{
    LogfinController.callLogfinApi(LogfinApis.addCar, inputJson, (isSuccess, outputJson){
      if(isSuccess){
        if(outputJson!["retry"]){
          UiUtils.isLoadingStop = true;
          CommonUtils.log("w", "outputJson : $outputJson");
          Key? selectedModelKey;
          String selectedModelInfo = "";
          UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, false, 100.w, Config.isPad()? 60.h : 40.h, 0.5, (slideContext, setSlideState){
            List<Widget> widgetList = [];
            Color textColor = ColorStyles.upFinBlack;
            FontWeight fontWeight = FontWeight.w500;
            for(var each in outputJson["modelList"]){
              Key key = Key(each["seriesno"]);
              if(selectedModelKey == key) {
                textColor = ColorStyles.upFinBlack;
                fontWeight = FontWeight.w600;
              }
              else{
                textColor = ColorStyles.upFinBlack;
                fontWeight = FontWeight.w500;
              }
              widgetList.add(
                  SizedBox(width: 90.w,
                      child: Row(children: [
                        selectedModelKey == key? UiUtils.getCustomCheckBox(key, 1.5, selectedModelKey == key, ColorStyles.upFinButtonBlue, ColorStyles.upFinWhite,
                            ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                              setSlideState(() {
                                if(checkedValue != null){
                                  if(checkedValue) {
                                    selectedModelKey = key;
                                    selectedModelInfo = each["seriesno"];
                                  }
                                }
                              });
                            }) : UiUtils.getCustomCheckBox(key, 1.5, true, ColorStyles.upFinGray, ColorStyles.upFinWhite,
                            ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                              setSlideState(() {
                                if(checkedValue != null){
                                  if(!checkedValue) {
                                    selectedModelKey = key;
                                    selectedModelInfo = each["seriesno"];
                                  }
                                }
                              });
                            }),
                        Expanded(child: UiUtils.getTextOverFlowButtonWithFixedScale(55.w, "${each["name1"]} ${each["name2"]}", 13.sp, fontWeight, textColor, TextAlign.start, null, (){
                          setSlideState(() {
                            selectedModelKey = key;
                            selectedModelInfo = each["seriesno"];
                          });
                        }))
                      ])
                  )
              );
              widgetList.add(
                  UiUtils.getMarginBox(0, 0.3.h)
              );


            }

            return Material(
                color: ColorStyles.upFinWhite,
                child: Column(children: [
                  UiUtils.getMarginBox(0, 2.h),
                  Center(child: UiUtils.getTextWithFixedScale("상세모델을 선택하세요", 14.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.center, null)),
                  UiUtils.getMarginBox(0, 2.5.h),
                  UiUtils.getExpandedScrollView(Axis.vertical,
                      Column(crossAxisAlignment:CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: widgetList)),
                  UiUtils.getMarginBox(0, 0.5.h),
                  UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                      UiUtils.getTextWithFixedScale("확인", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
                        if(selectedModelInfo != ""){
                          String seriesNo = selectedModelInfo;
                          String tsKey = outputJson["tsKey"];
                          inputJson["ts_key"] = tsKey;
                          inputJson["seriesno"] = seriesNo;
                          UiUtils.isLoadingStop = false;
                          LogfinController.callLogfinApi(LogfinApis.addCar, inputJson, (isSuccessToRetry, outputJsonForRerty){
                            if(isSuccessToRetry){
                              callback(true);
                            }else{
                              String errorMsg = outputJson!["error"];
                              if(errorMsg == "no implicit conversion of String into Integer"){
                                CommonUtils.flutterToast("차량정보를 확인해주세요.");
                              }else{
                                if(errorMsg.split(".").length > 2){
                                  CommonUtils.flutterToast(errorMsg.replaceAll("+", "").replaceAll("()", "").replaceAll(".", "\n"));
                                }else{
                                  CommonUtils.flutterToast(errorMsg.replaceAll("+", "").replaceAll("()", ""));
                                }
                              }

                              callback(false);
                            }
                          });
                          Navigator.pop(slideContext);
                        }else{
                          CommonUtils.flutterToast("모델을 선택하세요.");
                        }
                      }),
                  Config.isAndroid? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 3.h)
                ])
            );
          });
        }else{
          callback(true);
        }
      }else{
        String errorMsg = outputJson!["error"];
        if(errorMsg == "no implicit conversion of String into Integer"){
          CommonUtils.flutterToast("차량정보를 확인해주세요.");
        }else{
          if(errorMsg.split(".").length > 2){
            CommonUtils.flutterToast(errorMsg.replaceAll("+", "").replaceAll("()", "").replaceAll(".", "\n"));
          }else{
            CommonUtils.flutterToast(errorMsg.replaceAll("+", "").replaceAll("()", ""));
          }
        }

        callback(false);
      }
    });
  }

  static Future<void> getLoanInfo(Function(bool isSuccess, bool isNotEmpty) callback) async{
    try{
      callLogfinApi(LogfinApis.getLoansInfo, <String, dynamic>{}, (isSuccessToGetLoansInfo, loansInfoOutputJson) async {
        if(isSuccessToGetLoansInfo){
          if(loansInfoOutputJson != null){
            List<dynamic> loansList = loansInfoOutputJson["loans"];
            if(loansList.isEmpty){
              GetController.to.resetChatLoanInfoList();
              callback(true, false);
            }else{
              MyData.clearLoanInfoList();
              for(Map eachLoans in loansList){
                CommonUtils.log("i", "each loans : $eachLoans");

                String uid = "";
                String uidType = "";
                String lenderId = "";
                String companyName = "";
                String productName = "";
                String contactNo = "";

                if(eachLoans.containsKey("lender_pr")){
                  CommonUtils.log("i", "accident loan ==>");
                  uidType = "1";
                  uid = eachLoans["accident_uid"].toString();
                  lenderId = eachLoans["lender_pr_id"].toString();
                  companyName = eachLoans["lender_pr"]["lender"]["name"].toString();
                  productName = eachLoans["lender_pr"]["lender"]["product_name"].toString();
                  contactNo = eachLoans["lender_pr"]["lender"]["contact_no"].toString();

                  CommonUtils.log("w", "loan data ====>\n"
                      "uidType: $uidType\n"
                      "uid: $uid\n"
                      "loanUid: ${eachLoans["uid"]}\n"
                      "lenderPrId: ${eachLoans["lender_pr_id"]}\n"
                      "submitAmount: ${eachLoans["submit_offer"]["amount"]}\n"
                      "submitRate: ${eachLoans["submit_offer"]["interest_rate"]}\n"
                      "companyName: ${eachLoans["lender_pr"]["lender"]["name"]}\n"
                      "productName: ${eachLoans["lender_pr"]["lender"]["product_name"]}\n"
                      "contactNo: ${eachLoans["lender_pr"]["lender"]["contact_no"]}\n"
                      "createdDate: ${eachLoans["submit_offer"]["created_at"]}\n"
                      "updatedDate: ${eachLoans["submit_offer"]["updated_at"]}\n"
                      "statueId: ${eachLoans["status_info"]["id"]}\n"
                      "roomId: ${eachLoans["pr_room"]["id"]}\n");
                }else if(eachLoans.containsKey("lender_car")){
                  CommonUtils.log("i", "car loan ==>");
                  uidType = "3";
                  uid = eachLoans["search_car_result_uid"].toString();
                  lenderId = eachLoans["lender_car_id"].toString();
                  companyName = eachLoans["lender_car"]["lender"]["name"].toString();
                  productName = eachLoans["lender_car"]["lender"]["product_name"].toString();
                  contactNo = eachLoans["lender_car"]["lender"]["contact_no"].toString();

                  CommonUtils.log("w", "car loan data ====>\n"
                      "uidType: $uidType\n"
                      "uid: $uid\n"
                      "loanUid: ${eachLoans["uid"]}\n"
                      "lenderPrId: ${eachLoans["lender_car_id"]}\n"
                      "submitAmount: ${eachLoans["submit_offer"]["amount"]}\n"
                      "submitRate: ${eachLoans["submit_offer"]["interest_rate"]}\n"
                      "companyName: ${eachLoans["lender_car"]["lender"]["name"]}\n"
                      "productName: ${eachLoans["lender_car"]["lender"]["product_name"]}\n"
                      "contactNo: ${eachLoans["lender_car"]["lender"]["contact_no"]}\n"
                      "createdDate: ${eachLoans["submit_offer"]["created_at"]}\n"
                      "updatedDate: ${eachLoans["submit_offer"]["updated_at"]}\n"
                      "statueId: ${eachLoans["status_info"]["id"]}\n"
                      "roomId: ${eachLoans["pr_room"]["id"]}\n");
                }

                var inputJson = {
                  "loan_uid" : eachLoans["uid"],
                  "last_message_id" : 0,
                  "length" : 100
                };
                await callLogfinApi(LogfinApis.getMessage, inputJson, (isSuccessToGetLoanMessageInfo, loanMessageInfoOutputJson){
                  if(isSuccessToGetLoanMessageInfo){
                    String tempAmount = eachLoans["submit_offer"]["amount"].toString();
                    String submitAmount = "0";
                    if(tempAmount.length < 5){
                      CommonUtils.log("e", "submitAmount error $tempAmount");
                    }else{
                      submitAmount = eachLoans["submit_offer"]["amount"].toString().substring(0, eachLoans["submit_offer"]["amount"].toString().length-4);
                    }

                    loanMessageInfoOutputJson!["last_read_message_id"] = eachLoans["pr_room"]["last_read_message_id"].toString();
                    MyData.addToLoanInfoList(
                        LoanInfoData(uid, uidType, eachLoans["uid"].toString(), lenderId,
                            submitAmount, eachLoans["submit_offer"]["interest_rate"].toString(),
                            companyName, companyName == "(주)안전대부"? "assets/images/bank_logo_safe.png" : "assets/images/bank_logo_default.png",
                            productName, contactNo,
                            eachLoans["submit_offer"]["created_at"].toString(), eachLoans["submit_offer"]["updated_at"].toString(),
                            eachLoans["status_info"]["id"].toString(), eachLoans["pr_room"]["id"].toString(), jsonEncode(loanMessageInfoOutputJson)));
                  }
                });
              }

              MyData.sortLoanInfoList();
              _setChatRoomInfoList();
              WebSocketController.resetConnectWebSocketCable();
              GetController.to.updateAllSubScribed(false);
              Future.delayed(const Duration(milliseconds: 500), () {
                WebSocketController.connectToWebSocketCable();
                GetController.to.updateChatLoanInfoList(MyData.getChatRoomInfoList());
                callback(true, true);
              });
            }
          }else{
            GetController.to.resetChatLoanInfoList();
            callback(false, false);
          }
        }else{
          GetController.to.resetChatLoanInfoList();
          callback(false, false);
        }
      });
    }catch(error){
      GetController.to.resetChatLoanInfoList();
      callback(false, false);
    }
  }

  static void _setChatRoomInfoList() {
    MyData.clearChatRoomInfoList();
    for(var each in MyData.getLoanInfoList()){
      MyData.addToChatRoomInfoList(ChatRoomInfoData(each.chatRoomId, each.loanUid, each.uidType,
          each.companyLogo, each.companyName, each.productName,
          each.chatRoomMsg, each.statueId, "${each.submitRate}%",
          CommonUtils.getPriceFormattedString(double.parse(each.submitAmount))));
    }
  }

  static Future<void> getAccidentPrList(String accidentCase, Function(bool isSuccess, Map<String, dynamic>? outputJson) callback) async {
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
              MyData.addToPrInfoList(PrInfoData(accidentUid, "1", offerId, each["rid"], each["lender_pr_id"].toString(), each["lender_name"], each["lender_id"].toString(),
                  each["lender_doc"].toString(), each["product_name"], each["rid"], each["min_rate"].toString(), each["max_rate"].toString(), each["limit"].toString(),
                  each["lender_name"] == "(주)안전대부"? "assets/images/bank_logo_safe.png" : "assets/images/bank_logo_default.png",
                  each["result"] as bool, each["msg"] is List ? each["msg"] : []));
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

  static Future<void> getCarPrList(String carNum, String jobInfo, String lendCnt, String lendAmount, Function(bool isSuccess, Map<String, dynamic>? outputJson) callback) async {
    try{
      String carUid = MyData.findUidInCarInfoList(carNum);
      if(carUid != ""){
        Map<String, dynamic> inputJsonForGetOffers= {
          "car_uid": carUid,
          "job" : jobInfo,
          "lend_count": lendCnt,
          "lend_amount": lendAmount,
        };
        callLogfinApi(LogfinApis.searchCarProduct, inputJsonForGetOffers, (isSuccessToGetOffers, outputJsonForGetOffers){
          if(isSuccessToGetOffers){
            MyData.clearPrInfoList();
            String offerId = outputJsonForGetOffers!["offer_id"].toString();
            List<dynamic> offerPrList = outputJsonForGetOffers['data'];
            for(var each in offerPrList){
              MyData.addToPrInfoList(PrInfoData(carUid, "3", offerId, each["rid"].toString(), each["lender_car_id"].toString(), each["lender_name"].toString(), each["lender_id"].toString(),
                  each["lender_doc"].toString(), each["product_name"].toString(), each["rid"].toString(), each["min_rate"].toString(), each["max_rate"].toString(),
                  each["limit"].toString(), each["lender_name"] == "(주)안전대부"? "assets/images/bank_logo_safe.png" : "assets/images/bank_logo_default.png",
                  each["result"] as bool, each["msg"] is List ? each["msg"] : []));
            }

            if(MyData.getPrInfoList().isNotEmpty){
              MyData.sortPrInfoListBy(false);
              getUserInfo((isSuccessToGetUserInfo){
                if(isSuccessToGetUserInfo){
                  getCarInfo((isSuccessToGetCarInfo, isCarInfoNotEmpty){
                    if(isSuccessToGetCarInfo){
                      callback(true, outputJsonForGetOffers);
                    }else{
                      callback(false, null);
                    }
                  });
                }else{
                  callback(false, null);
                }
              });
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
              CommonUtils.log("i", "doc list : ${eachInList.productDocsId}\n${eachInList.productDocsName}\n");
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

  static Future<void> getCarPrDocsList(Function(bool isSuccess, Map<String, dynamic>? outputJson) callback) async {
    try{
      MyData.clearPrDocsInfoList();
      Map<String, dynamic> inputJson = {};
      LogfinController.callLogfinApi(LogfinApis.getCarDocs, inputJson, (isSuccessToSearchDocs, outputJsonForSearchDocs){
        if(isSuccessToSearchDocs){
          for(var each in outputJsonForSearchDocs!["documents"]){
            // test
            MyData.addToPrDocsInfoList(PrDocsInfoData(each["id"], each["name"], each["del_flg"]));
          }

          if(MyData.getPrDocsInfoList().isNotEmpty){
            for(var eachInList in MyData.getPrDocsInfoList()){
              CommonUtils.log("i", "doc list : ${eachInList.productDocsId}\n${eachInList.productDocsName}\n");
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
  bankUpdateInfo, checkMember, customerUpdateInfo,
  getUserInfo, prSearch, getOffers,
  applyProductDocSearch, applyProduct,
  getAccidentInfo, getOffersInfo,
  getLoansInfo, getLoansDetailInfo,
  sendMessage, getMessage, checkMessage, getAgreeDocuments, getFaqs,
  getRetryDocs, retryDocs,
  findEmail, sendEmailCode, checkEmailCode, checkMemberByPhone, updatePassword,
  getMyCarInfo, addCar, searchCar, searchCarProduct, getCarDocs, applyCarProduct, installTracking
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
      case LogfinApis.bankUpdateInfo:
        return '/pr_edit_complete.json';
      case LogfinApis.customerUpdateInfo:
        return '/edit_customer_info.json';
      case LogfinApis.checkMember:
        return '/check_member.json';
      case LogfinApis.sendMessage:
        return '/create_message.json';
      case LogfinApis.getMessage:
        return '/get_messages.json';
      case LogfinApis.checkMessage:
        return '/checked_messages.json';
      case LogfinApis.getAgreeDocuments:
        return '/get_documents.json';
      case LogfinApis.getFaqs:
        return '/get_faqs.json';
      case LogfinApis.getRetryDocs:
        return '/unsubmitted_documents.json';
      case LogfinApis.retryDocs:
        return '/add_documents.json';
      case LogfinApis.findEmail:
        return '/find_email.json';
      case LogfinApis.sendEmailCode:
        return '/send_email_verification.json';
      case LogfinApis.checkEmailCode:
        return '/check_email_verification.json';
      case LogfinApis.checkMemberByPhone:
        return '/check_member_phone.json';
      case LogfinApis.updatePassword:
        return '/users/update_password.json';

        /// auto loan
      case LogfinApis.getMyCarInfo:
        return '/get_cars.json';
      case LogfinApis.addCar:
        return '/add_car.json';
      case LogfinApis.searchCar:
        return '/get_carinfo.json';
      case LogfinApis.searchCarProduct:
        return '/search_auto_products.json';
      case LogfinApis.getCarDocs:
        return '/get_auto_documents.json';
      case LogfinApis.applyCarProduct:
        return '/submit_auto_product.json';

      case LogfinApis.installTracking:
        return '/first_launch.json';
    }
  }
}