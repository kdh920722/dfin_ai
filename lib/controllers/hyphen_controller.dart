import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:dfin/datas/my_data.dart';
import 'dart:convert';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import '../views/app_apply_pr_view.dart';
import 'logfin_controller.dart';

class HyphenController {
  static final HyphenController _instance = HyphenController._internal();
  factory HyphenController() => _instance;
  HyphenController._internal();

  static String url = "";
  static String ekey = "";
  static String hkey = "";
  static String id = "";

  static Future<void> initHyphen(Function(bool) callback) async {
    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('DFIN/API/hyphen').get();
      if (snapshot.exists) {
        for (var each in snapshot.children) {
          switch (each.key) {
            case "url" : url = each.value.toString();
            case "ekey" : ekey = each.value.toString();
            case "hkey" : hkey = each.value.toString();
            case "id" : id = each.value.toString();
          }
        }
        callback(true);
      } else {
        callback(false);
      }
    } catch (e) {
      CommonUtils.log("e", "hyphen init error : ${e.toString()}");
      callback(false);
    }
  }

  static Future<void> _callHyphenApi(HyphenApis api, Map<String, dynamic> inputJson, Function(bool isSuccess, Map<String, dynamic>? outputJson) callback) async {
    var targetUrl = "";
    if(Config.isWeb){
      targetUrl = 'https://corsproxy.io/?${Uri.encodeComponent(url+api.value)}';
    }else{
      targetUrl = url+api.value;
    }

    CommonUtils.log("i", "${api.value} inputJson :\n$inputJson");

    try {
      final url = Uri.parse(targetUrl);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "user-id": id,
          "Hkey": hkey,
        },
        body: jsonEncode(inputJson),
      ).timeout(const Duration(seconds: 30));

      final json = jsonDecode(response.body);
      CommonUtils.log('i', 'out full : \n$json');

      if (response.statusCode == 200) { // HTTP_OK
        final resultData = json;
        if(resultData["common"]["errYn"] == "N"){
          // dirver id ["data"]["licenceTruthYn"]
          // id ["data"]["truthYn"]
          callback(true, resultData['data']);
        }else{
          String errorMsg = resultData["common"]["errMsg"];
          CommonUtils.log('e', 'http error code : $errorMsg');
          callback(false, <String,dynamic>{"error":errorMsg});
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

  static Future<void> callHyphenApiForCert(HyphenApis api, Map<String, dynamic> inputJson, Function(bool isSuccess, int errorCode) callback) async {
    HyphenController._callHyphenApi(api, inputJson, (isSuccessToCertId, outputJsonForCertId){
      if(isSuccessToCertId){
        if(api == HyphenApis.idCert){
          if(outputJsonForCertId!["truthYn"] == "Y"){
            if(MyData.name == outputJsonForCertId["name"]){
              LogfinController.setLogJson(AppApplyPrViewState.isRetry? LogfinController.applyDocCertCodeString : LogfinController.applyCertCodeString, {"input" : inputJson}, {});
              CommonUtils.flutterToast("신분증 확인에 성공했어요.");
              callback(true, 0);
            }else{
              CommonUtils.flutterToast("신분증 진위확인에 실패\n유효한 신분증이 아니에요.");
              callback(false, 0);
            }
          }else{
            LogfinController.setLogJson(AppApplyPrViewState.isRetry? LogfinController.applyDocCertCodeString : LogfinController.applyCertCodeString, {"input" : inputJson}, {"error_output" : outputJsonForCertId});
            CommonUtils.flutterToast("신분증 진위확인에 실패\n유효한 신분증이 아니에요.");
            callback(false, 0);
          }
        }else{
          if(outputJsonForCertId!["licenceTruthYn"] == "Y"){
            if(MyData.name == outputJsonForCertId["name"]){
              LogfinController.setLogJson(AppApplyPrViewState.isRetry? LogfinController.applyDocCertCodeString : LogfinController.applyCertCodeString, {"input" : inputJson}, {});
              CommonUtils.flutterToast("신분증 확인에 성공했어요.");
              callback(true, 0);
            }else{
              CommonUtils.flutterToast("신분증 진위확인에 실패\n유효한 신분증이 아니에요.");
              callback(false, 0);
            }
          }else{
            LogfinController.setLogJson(AppApplyPrViewState.isRetry? LogfinController.applyDocCertCodeString : LogfinController.applyCertCodeString, {"input" : inputJson}, {"error_output" : outputJsonForCertId});
            CommonUtils.flutterToast("신분증 진위확인에 실패\n유효한 신분증이 아니에요.");
            callback(false, 0);
          }
        }
      }else{
        if(outputJsonForCertId != null){
          LogfinController.setLogJson(AppApplyPrViewState.isRetry? LogfinController.applyDocCertCodeString : LogfinController.applyCertCodeString, {"input" : inputJson}, {"error_output" : outputJsonForCertId});

          if(outputJsonForCertId.containsKey("error")){
            if(outputJsonForCertId["error"].toString().contains("재처리")){
              CommonUtils.flutterToast("시스템 점검중입니다.\n약 3분뒤에 다시 시도해주세요.");
              callback(false, 1);
            }else{
              if(outputJsonForCertId["error"].toString().contains("점검중")){
                CommonUtils.flutterToast("시스템 점검중입니다.");
                callback(false, 2);
              }else{
                String errorMsg = outputJsonForCertId["error"].toString();
                if(errorMsg.split("] ").length > 1){
                  errorMsg = errorMsg.split("] ").last;
                  errorMsg = errorMsg.replaceAll("다. ", "다.\n");
                }

                CommonUtils.flutterToast(errorMsg);
                callback(false, 0);
              }
            }
          }else{
            CommonUtils.flutterToast("신분증 진위확인에 실패\n유효한 신분증이 아니에요.");
            callback(false, 0);
          }
        }else{
          LogfinController.setLogJson(AppApplyPrViewState.isRetry? LogfinController.applyDocCertCodeString : LogfinController.applyCertCodeString, {"input" : inputJson}, {"error_output" : "hyphen result is null"});
          CommonUtils.flutterToast("신분증 진위확인에 실패했어요.");
          callback(false, 0);
        }
      }
    });
  }
}

enum HyphenApis {
  idCert, driveIdCert
}

extension HyphenApisExtension on HyphenApis {
  String get value {
    switch (this) {
      case HyphenApis.idCert:
        return '/in0005000233';
      case HyphenApis.driveIdCert:
        return '/in0072000230';
    }
  }
}