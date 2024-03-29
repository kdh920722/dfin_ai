import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:dfin/controllers/get_controller.dart';
import 'package:dfin/datas/api_info_data.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import '../configs/app_config.dart';
import '../datas/background_task_data.dart';
import '../styles/ColorStyles.dart';
import '../styles/TextStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class CodeFController{

  static final CodeFController _instance = CodeFController._internal();
  factory CodeFController() => _instance;
  CodeFController._internal();
  static final Map<String,String> errorMsgMap = {
    "CF-13000" : "주민등록번호/사업자번호 오류",
    "CF-12100" : "인증기관 오류",
    "CF-12100A" : "주소정보가 일치하지 않음",
    "CF-01004" : "응답대기시간 초과",
    "CF-12872" : "인증요청 취소",
    "CF-12835" : "인증서정보 없음",
    "CF-13231" : "등록원부(을)를 가져올 수 없는 차량",
    "CF-12003" : "인증기관 오류",
    "error_timeout" : "응답대기시간 초과",
    "error_abort" : "연결이 끊어졌어요. 재시도 해주세요.",
    "error_http" : "인터넷연결 오류",
    "error_connection" : "서버연결 오류",
    "error_cert" : "정보를 가져오는데 문제발생",
    "error_null" : "정보를 가져오는데 실패",
  };
  /// CODEF API ------------------------------------------------------------------------------------------------------------------------ ///
  static HostStatus hostStatus = HostStatus.prod;
  static String token = "";
  static const errorCodeKey = "codefError";
  static bool isTimeOutException = false;
  static bool isAbortException = false;
  static void setHostStatus(HostStatus host){
    hostStatus = host;
  }

  static bool isCommonError(String errorCode){
    if(errorCode == "12872" || errorCode == "CF-01004" || errorCode == "error_timeout" || errorCode == "error_null"
        || errorCode == "error_http" || errorCode == "error_connection" || errorCode == "error_cert"){
      return true;
    }else{
      return false;
    }
  }

  static String getErrorMsg(String errorCode){
    String result = "인증요청이 취소되었습니다.";
    if(errorMsgMap.containsKey(errorCode)){
      result = errorMsgMap[errorCode]!;
      return result;
    }else{
      return result;
    }
  }

  static Future<void> initAccessToken(Function(bool) callback) async {
    const oauthDomain = "https://oauth.codef.io"; // Replace with the actual OAuth domain.
    const getTokenPath = "/oauth/token"; // Replace with the actual path to get the token.
    var targetUrl = "";
    if(Config.isWeb){
      targetUrl = 'https://corsproxy.io/?${Uri.encodeComponent(oauthDomain + getTokenPath)}';
    }else{
      targetUrl = oauthDomain + getTokenPath;
    }

    try {
      final url = Uri.parse(targetUrl);
      const params = "grant_type=client_credentials&scope=read";

      final auth = hostStatus.value == HostStatus.prod.value
          ? '${Host.clientId.value}:${Host.clientSecret.value}'
          : '${HostDev.clientId.value}:${HostDev.clientSecret.value}';
      final authEncBytes = utf8.encode(auth);
      final authStringEnc = base64.encode(authEncBytes);
      final authHeader = "Basic $authStringEnc";

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": authHeader,
        },
        body: params,
      );

      if (response.statusCode == 200) { // HTTP_OK
        final decodedJson = jsonDecode(response.body);
        if (decodedJson.containsKey('access_token')) {
          token = decodedJson['access_token'];
          callback(true);
        } else {
          CommonUtils.log('e', 'json error : no value');
          callback(false);
        }
      } else {
        CommonUtils.log('e', 'http error code : ${response.statusCode}');
        callback(false);
      }
    } catch (e) {
      CommonUtils.log('e', e.toString());
      callback(false);
    }
  }

  static void backgroundTask(BackgroundTaskData backData) async {
    try {
      final response = await http.post(Uri.parse(backData.url),
          headers: {
            'Authorization': backData.tokenHeader,
            'Content-Type': 'application/json'
          },
          body: jsonEncode(backData.inputJson)
      ).timeout(const Duration(seconds: 120));

      String responseString = jsonEncode({
        'statusCode': response.statusCode,
        'body': response.body,
        'headers': response.headers,
      });
      backData.sendPort.send(responseString);

    } catch (e) {
      backData.sendPort.send(e.toString());
    }
  }

  static Future<void> _getDataFromApi2(Apis apiInfo, Map<String, dynamic> inputJson,
      void Function(bool isSuccess, bool is2WayProcess, Map<String, dynamic>? outputJson, List<dynamic>? outputJsonArray, Map<String, dynamic>? fullOutPut) callback) async {
    final baseUrl = hostStatus.value == HostStatus.prod.value ? Host.baseUrl.value : HostDev.baseUrl.value;
    final endPoint = apiInfo.value;
    CommonUtils.log("i", "call api : $endPoint");
    CommonUtils.log("i", "call input json : \n$inputJson");
    final url = baseUrl + endPoint;
    var targetUrl = "";
    if(Config.isWeb){
      targetUrl = 'https://corsproxy.io/?${Uri.encodeComponent(url)}';
    }else{
      targetUrl = url;
    }
    final tokenHeader = 'Bearer $token';

    try {
      ReceivePort receivePort = ReceivePort();
      Isolate isolate = await Isolate.spawn(backgroundTask, BackgroundTaskData(receivePort.sendPort, targetUrl, tokenHeader, inputJson));
      String data = "";
      receivePort.listen((message) {
        data = message as String;

        if(data.toLowerCase().contains("exception")){
          if(data.toLowerCase().contains("connection abort")){
            isAbortException = true;
            CommonUtils.log('e', data.toString());
            final Map<String, dynamic> resultData = {};
            resultData['result_code'] = errorCodeKey;
            resultData['result_codef_code'] = "error_abort";
            resultData['result_msg'] = "에러가 발생했습니다.";
            callback(false, false, resultData, null, null);
          }else{
            isTimeOutException = true;
            CommonUtils.log('e', data.toString());
            final Map<String, dynamic> resultData = {};
            resultData['result_code'] = errorCodeKey;
            resultData['result_codef_code'] = "error_timeout";
            resultData['result_msg'] = "에러가 발생했습니다.";
            callback(false, false, resultData, null, null);
          }

          isolate.kill(priority: Isolate.immediate);
        }else{
          Map<String, dynamic> responseData = jsonDecode(data);

          http.Response response = http.Response(
            responseData['body'],
            responseData['statusCode'],
            headers: Map<String, String>.from(responseData['headers']),
          );

          if(response.statusCode == 200) {
            final decodedResponseBody = Uri.decodeFull(response.body);
            final json = jsonDecode(decodedResponseBody);
            if(json.containsKey('result') && json.containsKey('data')){
              final result = json['result'];
              var resultCode = result['code'];
              CommonUtils.log('w', '$endPoint\nout full : \n$json');

              // CF-00000 : 성공, CF-03002 : 추가 인증 필요
              final msg = result['message'];
              if(resultCode == 'CF-00000' || resultCode == 'CF-03002' || resultCode == 'CF-13231'){
                final resultData = json['data'];
                if (resultData is Map<String, dynamic>) {
                  if(resultData.isNotEmpty){
                    resultData['result_code'] = resultCode;

                    resultData['result_codef_code'] = resultCode;
                    if(resultCode == 'CF-03002') {
                      callback(true, true, resultData, null, json);
                    } else {
                      callback(true, false, resultData, null, json);
                    }

                    isolate.kill(priority: Isolate.immediate);
                  }else{
                    if(resultCode == 'CF-13231'){
                      resultData['result_code'] = resultCode;
                      resultData['result_codef_code'] = resultCode;
                      callback(true, false, resultData, null, json);
                    }else{
                      final Map<String, dynamic> resultData = {};
                      resultData['result_code'] = errorCodeKey;

                      if(resultCode == "CF-12100"){
                        if(result['extraMessage'].toString().contains("시군구")){
                          resultCode = "CF-12100A";
                        }
                      }

                      resultData['result_codef_code'] = resultCode;
                      resultData['result_msg'] = msg;
                      CommonUtils.log('e', 'out resultCode error : $resultCode');
                      callback(true, false, resultData, null, json);
                    }

                    isolate.kill(priority: Isolate.immediate);
                  }
                } else if (resultData is List<dynamic>) {
                  if(resultData.isNotEmpty){
                    resultData[0]['result_code'] = resultCode;

                    if(resultCode == "CF-12100"){
                      if(result['extraMessage'].toString().contains("시군구")){
                        resultCode = "CF-12100A";
                      }
                    }

                    resultData[0]['result_codef_code'] = resultCode;
                    if(resultCode == 'CF-03002') {
                      callback(true, true, null, resultData, json);
                    } else {
                      callback(true, false, null, resultData, json);
                    }

                    isolate.kill(priority: Isolate.immediate);
                  }else{
                    final Map<String, dynamic> resultData = {};
                    resultData['result_code'] = errorCodeKey;

                    if(resultCode == "CF-12100"){
                      if(result['extraMessage'].toString().contains("시군구")){
                        resultCode = "CF-12100A";
                      }
                    }

                    resultData['result_codef_code'] = resultCode;
                    resultData['result_msg'] = msg;
                    CommonUtils.log('e', 'out resultCode error : $resultCode');
                    callback(true, false, resultData, null, json);
                    isolate.kill(priority: Isolate.immediate);
                  }
                }
              } else {
                final Map<String, dynamic> resultData = {};
                resultData['result_code'] = errorCodeKey;

                if(resultCode == "CF-12100"){
                  if(result['extraMessage'].toString().contains("시군구")){
                    resultCode = "CF-12100A";
                  }
                }

                resultData['result_codef_code'] = resultCode;
                resultData['result_msg'] = msg;
                CommonUtils.log('e', 'out resultCode error : $resultCode');
                callback(true, false, resultData, null, json);
                isolate.kill(priority: Isolate.immediate);
              }
            }
          } else {
            CommonUtils.log('e', 'http error code : ${response.statusCode}');
            final Map<String, dynamic> resultData = {};
            resultData['result_code'] = errorCodeKey;
            resultData['result_codef_code'] = "error_http";
            resultData['result_msg'] = "인터넷 연결에러가 발생했습니다.";
            callback(false, false, resultData, null, null);
            isolate.kill(priority: Isolate.immediate);
          }
        }
      });

    } catch (e) {
      CommonUtils.log('e', 'isolate error : $e');
    }
  }

  static Future<void> _getDataFromApi3(Apis apiInfo, Map<String, dynamic> inputJson,
      void Function(bool isSuccess, bool is2WayProcess, Map<String, dynamic>? outputJson, List<dynamic>? outputJsonArray, Map<String, dynamic>? fullOutPut) callback) async {
    final baseUrl = hostStatus.value == HostStatus.prod.value ? Host.baseUrl.value : HostDev.baseUrl.value;
    final endPoint = apiInfo.value;
    CommonUtils.log("i", "call api : $endPoint");
    CommonUtils.log("i", "call input json : \n$inputJson");
    final url = baseUrl + endPoint;
    var targetUrl = "";
    if(Config.isWeb){
      targetUrl = 'https://corsproxy.io/?${Uri.encodeComponent(url)}';
    }else{
      targetUrl = url;
    }

    final tokenHeader = 'Bearer $token';

    try {
      final response = await http.post(Uri.parse(targetUrl),
          headers: {
            'Authorization': tokenHeader,
            'Content-Type': 'application/json'
          },
          body: jsonEncode(inputJson)
      ).timeout(const Duration(seconds: 120));

      if(response.statusCode == 200) {
        final decodedResponseBody = Uri.decodeFull(response.body);
        final json = jsonDecode(decodedResponseBody);
        if(json.containsKey('result') && json.containsKey('data')){
          final result = json['result'];
          var resultCode = result['code'];
          CommonUtils.log('w', '$endPoint\nout full : \n$json');

          // CF-00000 : 성공, CF-03002 : 추가 인증 필요
          final msg = result['message'];
          if(resultCode == 'CF-00000' || resultCode == 'CF-03002'){
            final resultData = json['data'];
            if (resultData is Map<String, dynamic>) {
              if(resultData.isNotEmpty){
                resultData['result_code'] = resultCode;

                if(resultCode == "CF-12100"){
                  if(result['extraMessage'].toString().contains("시군구")){
                    resultCode = "CF-12100A";
                  }
                }

                resultData['result_codef_code'] = resultCode;
                if(resultCode == 'CF-03002') {
                  callback(true, true, resultData, null, json);
                } else {
                  callback(true, false, resultData, null, json);
                }
              }else{
                final Map<String, dynamic> resultData = {};
                resultData['result_code'] = errorCodeKey;

                if(resultCode == "CF-12100"){
                  if(result['extraMessage'].toString().contains("시군구")){
                    resultCode = "CF-12100A";
                  }
                }

                resultData['result_codef_code'] = resultCode;
                resultData['result_msg'] = msg;
                CommonUtils.log('e', 'out resultCode error : $resultCode');
                callback(true, false, resultData, null, json);
              }
            } else if (resultData is List<dynamic>) {
              if(resultData.isNotEmpty){
                resultData[0]['result_code'] = resultCode;

                if(resultCode == "CF-12100"){
                  if(result['extraMessage'].toString().contains("시군구")){
                    resultCode = "CF-12100A";
                  }
                }

                resultData[0]['result_codef_code'] = resultCode;
                if(resultCode == 'CF-03002') {
                  callback(true, true, null, resultData, json);
                } else {
                  callback(true, false, null, resultData, json);
                }
              }else{
                final Map<String, dynamic> resultData = {};
                resultData['result_code'] = errorCodeKey;

                if(resultCode == "CF-12100"){
                  if(result['extraMessage'].toString().contains("시군구")){
                    resultCode = "CF-12100A";
                  }
                }

                resultData['result_codef_code'] = resultCode;
                resultData['result_msg'] = msg;
                CommonUtils.log('e', 'out resultCode error : $resultCode');
                callback(true, false, resultData, null, json);
              }
            }
          } else {
            final Map<String, dynamic> resultData = {};
            resultData['result_code'] = errorCodeKey;

            if(resultCode == "CF-12100"){
              if(result['extraMessage'].toString().contains("시군구")){
                resultCode = "CF-12100A";
              }
            }

            resultData['result_codef_code'] = resultCode;
            resultData['result_msg'] = msg;
            CommonUtils.log('e', 'out resultCode error : $resultCode');
            callback(true, false, resultData, null, json);
          }
        }
      } else {
        CommonUtils.log('e', 'http error code : ${response.statusCode}');
        final Map<String, dynamic> resultData = {};
        resultData['result_code'] = errorCodeKey;
        resultData['result_codef_code'] = "error_http";
        resultData['result_msg'] = "인터넷 연결에러가 발생했습니다.";
        callback(false, false, resultData, null, null);
      }
    } catch (e) {
      if(e.toString().contains("connection abort")){
        isAbortException = true;
        CommonUtils.log('e', e.toString());
        final Map<String, dynamic> resultData = {};
        resultData['result_code'] = errorCodeKey;
        resultData['result_codef_code'] = "error_abort";
        resultData['result_msg'] = "에러가 발생했습니다.";
        callback(false, false, resultData, null, null);
      }else{
        isTimeOutException = true;
        CommonUtils.log('e', e.toString());
        final Map<String, dynamic> resultData = {};
        resultData['result_code'] = errorCodeKey;
        resultData['result_codef_code'] = "error_timeout";
        resultData['result_msg'] = "에러가 발생했습니다.";
        callback(false, false, resultData, null, null);
      }
    }
  }
  /// ------------------------------------------------------------------------------------------------------------------------ ///
  static Future<void> callApisWithCert2(BuildContext context, StateSetter setState, int certType,
      List<ApiInfoData> apiInfoDataList, Function(bool isSuccess, List<ApiInfoData>? resultApiInfoDataList) callback) async {
    _callApiWithCert2(context, setState, certType, apiInfoDataList, (isSuccess, resultApiInfoDataListFromCall) {
      if(isSuccess){
        GetController.to.setPercent(100);
      }

      Future.delayed(const Duration(seconds: 1), () {
        if(isSetAuthPopOn) Navigator.of(context).pop();
        if(apiCheckTimer != null) apiCheckTimer!.cancel();
        apiCheckTimer = null;
        GetController.to.updateWait(false);
        isSetAuthPopOn = false;

        if(isSuccess){
          if(resultApiInfoDataListFromCall == null){
            callback(false, apiInfoDataList);
          }else{
            callback(true, resultApiInfoDataListFromCall);
          }
        }else{
          callback(false, resultApiInfoDataListFromCall);
        }
      });
    });
  }
  /// ------------------------------------------------------------------------------------------------------------------------ ///
  static Future<void> _callApiWithOutCert2(BuildContext context, Apis api, Map<String, dynamic> inputJson,
      Function(bool isSuccess, Map<String,dynamic>? resultMap, List<dynamic>? resultListMap, Map<String,dynamic>? fullMap) callback) async {
    CodeFController._getDataFromApi2(api, inputJson, (isSuccess, _, map, listMap, fullResultMap) {
      if(isSuccess){
        if(map != null){
          callback(true, map, null, fullResultMap);
        }else{
          callback(true, null, listMap, fullResultMap);
        }
      }else{
        if(map != null){
          callback(true, map, null, fullResultMap);
        }else{
          callback(true, null, listMap, fullResultMap);
        }
      }
    });
  }

  static Future<void> _callApiWithCert2(BuildContext context, StateSetter setState, int certType,
  List<ApiInfoData> apiInfoDataList, Function(bool isSuccess, List<ApiInfoData>? resultApiInfoDataList) callback) async {
    CodeFController._getDataFromApi2(apiInfoDataList[0].api, apiInfoDataList[0].inputJson, (isSuccess, is2WayProcess, map, listMap, fullResultMap) async {
      if(isSuccess){
        if(fullResultMap != null){
          if(is2WayProcess){
            if(map == null){
              // cert call is null..
              callback(false, null);
            }else{
              Map<String, dynamic>? result2WayMap = _set2WayMap(apiInfoDataList[0].inputJson, map);
              if(result2WayMap == null){
                // cert call is wrong and null..
                callback(false, null);
              }else{
                // cert call for auth..
                /*
                if(certType == 1){
                  if(await canLaunchUrl(Uri.parse("kakaotalk://launch"))){
                    launchUrl(Uri.parse("kakaotalk://launch"));
                  }else{
                    Config.isAndroid ? launchUrl(Uri.parse("market://details?id=com.kakao.talk"))
                        : launchUrl(Uri.parse("https://apps.apple.com/kr/app/kakaotalk/id869223134?mt=12"));
                  }
                }else if(certType == 6){
                  if(await canLaunchUrl(Uri.parse("naversearchapp://default?version=1"))){
                    CommonUtils.flutterToast("네이버앱에서 인증해주세요.");
                    //launchUrl(Uri.parse("naversearchapp://default?version=1"));
                  }else{
                    Config.isAndroid ? launchUrl(Uri.parse("market://details?id=com.nhn.android.search"))
                        : launchUrl(Uri.parse("https://apps.apple.com/kr/app/%EB%84%A4%EC%9D%B4%EB%B2%84-naver/id393499958"));
                  }
                }else if(certType == 8){
                  if(await canLaunchUrl(Uri.parse("supertoss://toss-cert/v2/sign/doc?"))){
                    CommonUtils.flutterToast("Toss앱에서 인증해주세요.");
                    //launchUrl(Uri.parse("market://details?id=viva.republica.toss"));
                  }else{
                    Config.isAndroid ? launchUrl(Uri.parse("market://details?id=viva.republica.toss"))
                        : launchUrl(Uri.parse("https://apps.apple.com/kr/app/%ED%86%A0%EC%8A%A4/id839333328"));
                  }
                }else if(certType == 5){
                  CommonUtils.flutterToast("PASS앱에서 인증해주세요.");
                  if(apiInfoDataList[0].inputJson.containsKey("telecom")){
                    String telecom = apiInfoDataList[0].inputJson["telecom"];
                    if(telecom == "0"){
                      /*
                      if(await canLaunchUrl(Uri.parse("tauthlink://launch"))){
                        launchUrl(Uri.parse("market://details?id=com.sktelecom.tauth"));
                      }else{
                        Config.isAndroid ? launchUrl(Uri.parse("market://details?id=com.sktelecom.tauth"))
                            : launchUrl(Uri.parse("https://apps.apple.com/kr/app/pass-by-skt/id1141258007"));
                      }
                       */
                    }else if(telecom == "1"){
                      /*
                      if(await canLaunchUrl(Uri.parse("ktauthexternalcall://launch"))){
                        //launchUrl(Uri.parse("ktauthexternalcall://launch"));
                        launchUrl(Uri.parse("market://details?id=com.kt.ktauth"));
                      }else{
                        Config.isAndroid ? launchUrl(Uri.parse("market://details?id=com.kt.ktauth"))
                            : launchUrl(Uri.parse("https://apps.apple.com/kr/app/pass-by-kt/id1134371550"));
                      }
                      */
                    }else{
                      /*
                      if(await canLaunchUrl(Uri.parse("upluscorporation://launch"))){
                        //launchUrl(Uri.parse("upluscorporation://launch"));
                        launchUrl(Uri.parse("market://details?id=com.lguplus.smartotp"));
                      }else{
                        Config.isAndroid ? launchUrl(Uri.parse("market://details?id=com.lguplus.smartotp"))
                            : launchUrl(Uri.parse("https://apps.apple.com/kr/app/pass-by-u/id1147394645"));
                      }
                       */
                    }
                  }
                }

                if(context.mounted){

                }

                */

                int callCount = 0;
                if(apiInfoDataList.length > 1){
                  CommonUtils.log("i","call fin 1 : 첫번째(초본)호출 후 추가인증요청");
                  for(int i = 1 ; i < apiInfoDataList.length ; i++){
                    // await Future.delayed(const Duration(milliseconds: 700));
                    if(context.mounted){
                      _callApiWithOutCert2(context, apiInfoDataList[i].api, apiInfoDataList[i].inputJson, (isSuccess, resultMap, resultListMap, fullMap) {
                        callCount++;
                        if(isSuccess){
                          CommonUtils.log("i","call fin 5 : 나머지 api 응답결과 옴");
                          if(fullMap == null){
                            apiInfoDataList[i].isResultSuccess = false;
                            apiInfoDataList[i].resultMap = null;
                            apiInfoDataList[i].resultListMap = null;
                            apiInfoDataList[i].resultFullMap = null;
                            if(resultMap != null){
                              apiInfoDataList[i].errorCode = resultMap["result_codef_code"];
                            }else if(resultListMap != null){
                              apiInfoDataList[i].errorCode = resultListMap[0]["result_codef_code"];
                            }
                          }else{
                            if(resultMap != null){
                              if(resultMap["result_code"] == errorCodeKey){
                                apiInfoDataList[i].isResultSuccess = false;
                                apiInfoDataList[i].resultMap = null;
                                apiInfoDataList[i].resultListMap = null;
                                apiInfoDataList[i].resultFullMap = fullMap;
                                apiInfoDataList[i].errorCode = resultMap["result_codef_code"];
                              }else{
                                if(fullMap["result"]["code"] == "CF-03002"){
                                  apiInfoDataList[i].isResultSuccess = false;
                                  apiInfoDataList[i].resultMap = null;
                                  apiInfoDataList[i].resultListMap = null;
                                  apiInfoDataList[i].resultFullMap = fullMap;
                                  apiInfoDataList[i].errorCode = "error_cert";
                                }else{
                                  apiInfoDataList[i].isResultSuccess = true;
                                  apiInfoDataList[i].resultMap = resultMap;
                                  apiInfoDataList[i].resultListMap = null;
                                  apiInfoDataList[i].resultFullMap = fullMap;
                                }
                              }
                            }else{
                              if(resultListMap == null || resultListMap.isEmpty){
                                apiInfoDataList[i].isResultSuccess = false;
                                apiInfoDataList[i].resultMap = null;
                                apiInfoDataList[i].resultListMap = null;
                                apiInfoDataList[i].resultFullMap = fullMap;
                                apiInfoDataList[i].errorCode = "error_null";
                              }else{
                                if(resultListMap[0]["result_code"] == errorCodeKey){
                                  apiInfoDataList[i].isResultSuccess = false;
                                  apiInfoDataList[i].resultMap = null;
                                  apiInfoDataList[i].resultListMap = null;
                                  apiInfoDataList[i].resultFullMap = fullMap;
                                  apiInfoDataList[i].errorCode = resultListMap[0]["result_codef_code"];
                                }else if(fullMap["result"]["code"] == "CF-03002"){
                                  apiInfoDataList[i].isResultSuccess = false;
                                  apiInfoDataList[i].resultMap = null;
                                  apiInfoDataList[i].resultListMap = null;
                                  apiInfoDataList[i].resultFullMap = fullMap;
                                  apiInfoDataList[i].errorCode = "error_cert";
                                }else{
                                  apiInfoDataList[i].isResultSuccess = true;
                                  apiInfoDataList[i].resultMap = null;
                                  apiInfoDataList[i].resultListMap = resultListMap;
                                  apiInfoDataList[i].resultFullMap = fullMap;
                                }
                              }
                            }
                          }
                        }else{
                          apiInfoDataList[i].isResultSuccess = false;
                          apiInfoDataList[i].resultMap = null;
                          apiInfoDataList[i].resultListMap = null;
                          apiInfoDataList[i].resultFullMap = null;
                          if(resultMap != null){
                            apiInfoDataList[i].errorCode = resultMap["result_codef_code"];
                          }else if(resultListMap != null){
                            apiInfoDataList[i].errorCode = resultListMap[0]["result_codef_code"];
                          }

                          if(apiInfoDataList[i].errorCode == "CF-12872"){
                            for(var each in apiInfoDataList){
                              each.isResultSuccess = false;
                              each.resultMap = null;
                              each.resultListMap = null;
                              each.resultFullMap = fullMap;
                              each.errorCode = "CF-12872";
                            }
                            callback(false, apiInfoDataList);
                          }
                        }

                        if(callCount == apiInfoDataList.length){
                          callback(true, apiInfoDataList);
                        }
                      });
                    }
                  }
                  CommonUtils.log("i","call fin 2 : 추가인증 요청 후 나머지 api2개 호출");
                }

                CommonUtils.log("i","call fin 3 : 초본 api와 추가인증 json 요청");
                isSetAuthPopOn = true;
                if(context.mounted){
                  _setAuthPop2(context, apiInfoDataList[0].api, certType, result2WayMap,(isAuthSuccess, authMap, authListMap, fullMap) async {
                    callCount++;
                    if(isAuthSuccess){
                      CommonUtils.log("i","call fin 4 : 초본 api 응답결과 옴");
                      if(fullMap == null){
                        apiInfoDataList[0].isResultSuccess = false;
                        apiInfoDataList[0].resultMap = null;
                        apiInfoDataList[0].resultListMap = null;
                        apiInfoDataList[0].resultFullMap = null;
                        if(authListMap != null){
                          apiInfoDataList[0].errorCode = authListMap[0]["result_codef_code"];
                        }
                      }else{
                        if(authMap == null){
                          if(authListMap == null || authListMap.isEmpty){
                            apiInfoDataList[0].isResultSuccess = false;
                            apiInfoDataList[0].resultMap = null;
                            apiInfoDataList[0].resultListMap = null;
                            apiInfoDataList[0].resultFullMap = fullMap;
                            apiInfoDataList[0].errorCode = "error_null";
                          }else{
                            if(authListMap[0]["result_code"] == errorCodeKey){
                              apiInfoDataList[0].isResultSuccess = false;
                              apiInfoDataList[0].resultMap = null;
                              apiInfoDataList[0].resultListMap = null;
                              apiInfoDataList[0].resultFullMap = fullMap;
                              apiInfoDataList[0].errorCode = authListMap[0]["result_codef_code"];
                            }else if(fullMap["result"]["code"] == "CF-03002"){
                              apiInfoDataList[0].isResultSuccess = false;
                              apiInfoDataList[0].resultMap = null;
                              apiInfoDataList[0].resultListMap = null;
                              apiInfoDataList[0].resultFullMap = fullMap;
                              apiInfoDataList[0].errorCode = "error_cert";
                            }else{
                              apiInfoDataList[0].isResultSuccess = true;
                              apiInfoDataList[0].resultMap = null;
                              apiInfoDataList[0].resultListMap = authListMap;
                              apiInfoDataList[0].resultFullMap = fullMap;
                            }
                          }
                        }else{
                          if(authMap["result_code"] == errorCodeKey){
                            apiInfoDataList[0].isResultSuccess = false;
                            apiInfoDataList[0].resultMap = null;
                            apiInfoDataList[0].resultListMap = null;
                            apiInfoDataList[0].resultFullMap = fullMap;
                            apiInfoDataList[0].errorCode = authMap["result_codef_code"];
                          }else{
                            if(fullMap["result"]["code"] == "CF-03002"){
                              apiInfoDataList[0].isResultSuccess = false;
                              apiInfoDataList[0].resultMap = null;
                              apiInfoDataList[0].resultListMap = null;
                              apiInfoDataList[0].resultFullMap = fullMap;
                              apiInfoDataList[0].errorCode = "error_cert";
                            }else{
                              apiInfoDataList[0].isResultSuccess = true;
                              apiInfoDataList[0].resultMap = authMap;
                              apiInfoDataList[0].resultListMap = null;
                              apiInfoDataList[0].resultFullMap = fullMap;
                            }
                          }
                        }
                      }
                    }else{
                      apiInfoDataList[0].isResultSuccess = false;
                      apiInfoDataList[0].resultMap = null;
                      apiInfoDataList[0].resultListMap = null;
                      apiInfoDataList[0].resultFullMap = fullMap;
                      if(authMap != null){
                        apiInfoDataList[0].errorCode = authMap["result_codef_code"];
                      }else if(authListMap != null){
                        apiInfoDataList[0].errorCode = "error_cert";
                      }

                      if(apiInfoDataList[0].errorCode == "CF-12872"){
                        for(var each in apiInfoDataList){
                          each.isResultSuccess = false;
                          each.resultMap = null;
                          each.resultListMap = null;
                          each.resultFullMap = fullMap;
                          each.errorCode = "CF-12872";
                        }
                        callback(false, apiInfoDataList);
                      }
                    }

                    if(callCount == apiInfoDataList.length){
                      callback(true, apiInfoDataList);
                    }
                  });
                }
              }
            }
          }else{
            // cert call is wrong..
            apiInfoDataList[0].isResultSuccess = false;
            apiInfoDataList[0].resultMap = null;
            apiInfoDataList[0].resultListMap = null;
            apiInfoDataList[0].resultFullMap = null;
            if(map != null){
              apiInfoDataList[0].errorCode = map["result_codef_code"];
            }else if(listMap != null){
              apiInfoDataList[0].errorCode = listMap[0]["result_codef_code"];
            }
            callback(false, apiInfoDataList);
          }
        }else{
          // cert call full map is null..
          apiInfoDataList[0].isResultSuccess = false;
          apiInfoDataList[0].resultMap = null;
          apiInfoDataList[0].resultListMap = null;
          apiInfoDataList[0].resultFullMap = null;
          if(map != null){
            apiInfoDataList[0].errorCode = map["result_codef_code"];
          }else if(listMap != null){
            apiInfoDataList[0].errorCode = listMap[0]["result_codef_code"];
          }
          callback(false, apiInfoDataList);
        }
      }else{
        // cert call is null..
        apiInfoDataList[0].isResultSuccess = false;
        apiInfoDataList[0].resultMap = null;
        apiInfoDataList[0].resultListMap = null;
        apiInfoDataList[0].resultFullMap = null;
        if(map != null){
          apiInfoDataList[0].errorCode = map["result_codef_code"];
        }else if(listMap != null){
          apiInfoDataList[0].errorCode = listMap[0]["result_codef_code"];
        }
        callback(false, apiInfoDataList);
      }
    });
  }

  static Map<String, dynamic>? _set2WayMap(Map<String, dynamic> originInputMap, Map<String, dynamic> continue2WayResultMap) {
    Map<String, dynamic>? resultMap;
    bool is2way = continue2WayResultMap["continue2Way"] as bool;
    if(is2way){
      Map<String, dynamic> authMap = continue2WayResultMap;
      var jobIndex = authMap["jobIndex"];
      var threadIndex = authMap["threadIndex"];
      var jti = authMap["jti"];
      var twoWayTimestamp = authMap["twoWayTimestamp"];
      var extraInfo = authMap["extraInfo"];
      var secNo = extraInfo["reqSecureNo"];
      var secNoRefresh = extraInfo["reqSecureNoRefresh"];

      Map<String, dynamic> input2WayJson = {
        "simpleAuth" : "1",
        "secureNo": secNo,
        "secureNoRefresh" : secNoRefresh,
        "is2Way": true,
        "twoWayInfo": {
          "jobIndex": jobIndex,
          "threadIndex": threadIndex,
          "jti": jti,
          "twoWayTimestamp": twoWayTimestamp
        }
      };

      resultMap = {};
      resultMap.addAll(originInputMap);
      resultMap.addAll(input2WayJson);
    }

    return resultMap;
  }

  static bool isSetAuthPopOn = false;
  static Timer? apiCheckTimer;
  static int apiTimerCount = 0;
  static Future<void> _setAuthPop2(BuildContext context, Apis apiInfo, int certType, Map<String, dynamic> resultInputMap,
      Function(bool isSuccess, Map<String,dynamic>? resultMap, List<dynamic>? resultListMap, Map<String,dynamic>? fullResultMap) callback) async {
    String certName = "간편인증을 진행해주세요!";
    if(certType == 1){
      certName = "카카오앱에서 $certName";
    }else if(certType == 6){
      certName = "네이버앱에서 $certName";
    }else if(certType == 8){
      certName = "토스앱에서 $certName";
    }else if(certType == 5){
      certName = "PASS앱에서 $certName";
    }

    apiTimerCount = 0;
    GetController.to.resetPercent();

    apiCheckTimer ??= Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      apiTimerCount++;

      if(GetController.to.isWait.value){
        if(GetController.to.loadingPercent.value >= 80){
          GetController.to.updatePercent(0);
          if(apiCheckTimer != null) apiCheckTimer!.cancel();
          apiCheckTimer = null;
        }else if(GetController.to.loadingPercent.value >= 50){
          GetController.to.updatePercent(10);
        }else if(GetController.to.loadingPercent.value >= 10){
          GetController.to.updatePercent(6);
        }else{
          GetController.to.updatePercent(4);
        }
      }else{
        apiTimerCount = 0;
        GetController.to.setPercent(1);
      }


      if(apiTimerCount >= 100){
        if(apiCheckTimer != null) apiCheckTimer!.cancel();
        apiCheckTimer = null;
      }
    });

    UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, false, null, Config.isPad()? 60.h : 40.h, 0.0, (context, setState){
      return Obx(()=>Column(mainAxisAlignment: MainAxisAlignment.start, children:[
        GetController.to.isWait.value? UiUtils.getMarginBox(0, 5.h) : UiUtils.getMarginBox(0, 3.h),
        GetController.to.isWait.value? UiUtils.getImage(30.w, 30.w, Image.asset(fit: BoxFit.fill,'assets/images/doc_move2.gif'))
            : Column(children: [
          UiUtils.getImage(100.w, 30.w,  Image.asset(fit: BoxFit.fitWidth,'assets/images/cert_called.png')),
          UiUtils.getMarginBox(0, 2.h),
          UiUtils.getStyledTextWithFixedScale(certName, TextStyles.dFinBasicTextStyle2, TextAlign.center, null)]),
        GetController.to.isWait.value? UiUtils.getMarginBox(0, 2.h) : UiUtils.getMarginBox(0, 0.5.h),
        GetController.to.isWait.value? Column(children: [
          UiUtils.getStyledTextWithFixedScale("서류를 가지고 오는중입니다.", TextStyles.dFinBasicTextStyle2, TextAlign.center, null),
          UiUtils.getMarginBox(0, 2.h),
          LinearPercentIndicator(
            animateFromLastPercent: true,
            alignment: MainAxisAlignment.center,
            barRadius: const Radius.circular(10),
            animation: true,
            center: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
              UiUtils.getTextWithFixedScale("${GetController.to.loadingPercent.value}", 16.sp, FontWeight.w500, ColorStyles.dFinBlack, TextAlign.center, null),
              UiUtils.getMarginBox(0.5.w, 0),
              UiUtils.getTextWithFixedScale("%", 16.sp, FontWeight.w500, ColorStyles.dFinBlack, TextAlign.center, null),
            ]),
            width: 60.w,
            lineHeight: 3.h,
            linearStrokeCap: LinearStrokeCap.round,
            backgroundColor : ColorStyles.dFinWhite,
            progressColor: ColorStyles.dFinWhite,
          )
        ])
            : Container(),
        GetController.to.isWait.value? Container() : UiUtils.getStyledTextWithFixedScale("인증 후 확인 버튼을 눌러주세요.", TextStyles.dFinBasicTextStyle2, TextAlign.center, null),
        GetController.to.isWait.value? Container() : UiUtils.getExpandedScrollView(Axis.vertical, const Column(children: [])),
        GetController.to.isWait.value? Container() : UiUtils.getBorderButtonBox(85.w, ColorStyles.dFinTextAndBorderBlue, ColorStyles.dFinTextAndBorderBlue,
            UiUtils.getTextWithFixedScale("확인", 15.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.start, null), () {
              GetController.to.updateWait(true);
              CodeFController._getDataFromApi2(apiInfo, resultInputMap, (isSuccess, _, map, listMap, fullMap){
                if(isSuccess){
                  if(map != null){
                    if(map['result_code'] == "CF-03002"){
                      CommonUtils.flutterToast("인증을 진행해주세요.");
                      GetController.to.updateWait(false);
                      apiTimerCount = 0;
                      GetController.to.resetPercent();

                      apiCheckTimer ??= Timer.periodic(const Duration(seconds: 1), (Timer timer) {
                        apiTimerCount++;

                        if(GetController.to.isWait.value){
                          if(GetController.to.loadingPercent.value >= 80){
                            GetController.to.updatePercent(0);
                            if(apiCheckTimer != null) apiCheckTimer!.cancel();
                            apiCheckTimer = null;
                          }else if(GetController.to.loadingPercent.value >= 50){
                            GetController.to.updatePercent(10);
                          }else if(GetController.to.loadingPercent.value >= 10){
                            GetController.to.updatePercent(6);
                          }else{
                            GetController.to.updatePercent(4);
                          }
                        }else{
                          apiTimerCount = 0;
                          GetController.to.setPercent(1);
                        }


                        if(apiTimerCount >= 100){
                          if(apiCheckTimer != null) apiCheckTimer!.cancel();
                          apiCheckTimer = null;
                        }
                      });
                    }else if(fullMap!['result']['code'] == "CF-12872"){
                      callback(false, map, listMap, fullMap);
                    }else if(fullMap['result']['code'] == "CF-12835"){
                      callback(false, map, listMap, fullMap);
                    }else if(fullMap['result']['code'] == "CF-01004"){
                      callback(false, map, listMap, fullMap);
                    }else if(fullMap['result']['code'] == "CF-13000"){
                      callback(false, map, listMap, fullMap);
                    }else if(fullMap['result']['code'] == "CF-12100"){
                      callback(false, map, listMap, fullMap);
                    }else{
                      callback(true, map, listMap, fullMap);
                    }
                  }else{
                    if(listMap?[0]['result_code'] == "CF-03002"){
                      CommonUtils.flutterToast("인증을 진행해주세요.");
                      GetController.to.updateWait(false);
                      apiTimerCount = 0;
                      GetController.to.resetPercent();

                      apiCheckTimer ??= Timer.periodic(const Duration(seconds: 1), (Timer timer) {
                        apiTimerCount++;

                        if(GetController.to.isWait.value){
                          if(GetController.to.loadingPercent.value >= 80){
                            GetController.to.updatePercent(0);
                            if(apiCheckTimer != null) apiCheckTimer!.cancel();
                            apiCheckTimer = null;
                          }else if(GetController.to.loadingPercent.value >= 50){
                            GetController.to.updatePercent(10);
                          }else if(GetController.to.loadingPercent.value >= 10){
                            GetController.to.updatePercent(6);
                          }else{
                            GetController.to.updatePercent(4);
                          }
                        }else{
                          apiTimerCount = 0;
                          GetController.to.setPercent(1);
                        }


                        if(apiTimerCount >= 100){
                          if(apiCheckTimer != null) apiCheckTimer!.cancel();
                          apiCheckTimer = null;
                        }
                      });
                    }else if(fullMap!['result']['code'] == "CF-12872"){
                      callback(false, map, listMap, fullMap);
                    }else if(fullMap['result']['code'] == "CF-12835"){
                      callback(false, map, listMap, fullMap);
                    }else if(fullMap['result']['code'] == "CF-01004"){
                      callback(false, map, listMap, fullMap);
                    }else if(fullMap['result']['code'] == "CF-13000"){
                      callback(false, map, listMap, fullMap);
                    }else if(fullMap['result']['code'] == "CF-12100"){
                      callback(false, map, listMap, fullMap);
                    }else{
                      callback(true, map, listMap, fullMap);
                    }
                  }
                }else{
                  callback(false, map, listMap, fullMap);
                }
              });
            }),
        Config.isAndroid? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 3.h)
      ]));
    });
  }

  static Map<String, dynamic> makeInputJsonForCertApis(Apis api, String loginIdentity, String identity, String birth, String name, String phoneNo, String telecom,
      String address, String loginCertType, String randomKey, String carNum, String carOwnerName){
    if(api == Apis.gov24residentRegistrationAbstract){
      Map<String, dynamic> inputJsonForAbstract = {
        "organization": "0001",
        "loginType": "6",
        "identity": loginIdentity,
        "timeout": "120",
        "addrSido": address.split(" ")[0],
        "addrSiGunGu": address.split(" ")[1],
        "id": randomKey,
        "userName": name,
        "loginTypeLevel": loginCertType,
        "phoneNo": phoneNo,
        "personalInfoChangeYN": "1",
        "pastAddrChangeYN": "1",
        "nameRelationYN": "1",
        "militaryServiceYN": "1",
        "overseasKoreansIDYN": "0",
        "isIdentityViewYn": "0",
        "originDataYN": "0",
        "telecom": telecom
      };

      return inputJsonForAbstract;
    }else if(api == Apis.gov24residentRegistrationCopy){
      Map<String, dynamic> inputJsonForCopy = {
        "organization": "0001",
        "loginType": "6",
        "identity": loginIdentity,
        "timeout": "120",
        "addrSido": address.split(" ")[0],
        "addrSiGunGu": address.split(" ")[1],
        "id": randomKey,
        "userName": name,
        "loginTypeLevel": loginCertType,
        "phoneNo": phoneNo,
        "pastAddrChangeYN": "0",
        "inmateYN": "0",
        "relationWithHHYN": "1",
        "changeDateYN": "0",
        "compositionReasonYN": "0",
        "isIdentityViewYn": "0",
        "isNameViewYn": "1",
        "originDataYN": "0",
        "telecom": telecom
      };

      return inputJsonForCopy;
    }else if(api == Apis.gov24localTaxPaymentCert){
      Map<String, dynamic> inputJsonForlocalTaxPaymentCert = {
        "organization": "0001",
        "loginType": "6",
        "userName": name,
        "identity": loginIdentity,
        "id": randomKey,
        "loginTypeLevel": loginCertType,
        "phoneNo": phoneNo,
        "address": address,
        "addrDetail": "",
        "phoneNo1": phoneNo,
        "openDate": "",
        "proofType": "",
        "contents": "",
        "date": "",
        "isIdentityViewYn": "1",
        "telecom": telecom
      };

      return inputJsonForlocalTaxPaymentCert;
    }else if(api == Apis.gov24CarRegistrationA){
      Map<String, dynamic> inputJsonForCarRegistrationA = {
        "organization": "0001",
        "loginType": "6",
        "userName": name,
        "identity": loginIdentity,
        "phoneNo": phoneNo,
        "id": randomKey,
        "loginTypeLevel": loginCertType,
        "address": address,
        "isIdentityViewYn": "1",
        "telecom": telecom,
        "birthDate": "",
        "carNo": carNum,
        "ownerName": carOwnerName,
        "displyed": "1",
        "identity2": "",
      };

      return inputJsonForCarRegistrationA;
    }else if(api == Apis.gov24CarRegistrationB){
      Map<String, dynamic> inputJsonForCarRegistrationB = {
        "organization": "0001",//
        "loginType": "6",//
        "userName": name,//
        "loginIdentity": loginIdentity,//
        "phoneNo": phoneNo,//
        "id": randomKey,//
        "loginTypeLevel": loginCertType,//
        "address": address,//
        "isIdentityViewYn": "1",//
        "telecom": telecom,
        "birthDate": "",//
        "carNo": carNum,//
        "ownerName": carOwnerName,//
        "identity" : ""
      };

      return inputJsonForCarRegistrationB;
    }else if(api == Apis.nhisIdentifyConfirmation){

      Map<String, dynamic> inputJsonForNhisIdConfirm = {
        "organization": "0002",
        "loginType": "5",
        "identity": birth,
        "loginTypeLevel": loginCertType,
        "userName": name,
        "phoneNo": phoneNo,
        "useType": "0",
        "isIdentityViewYN": "0",
        "id": randomKey,
        "originDataYN": "0",
        "telecom": telecom
      };

      return inputJsonForNhisIdConfirm;
    }else if(api == Apis.nhisConfirmation){
      DateTime now = CommonUtils.getCurrentLocalTime();
      String nowString = CommonUtils.convertTimeToString(now);
      DateTime lastYearDate = DateTime(now.year - 1, 12, 31);
      String targetMonth = nowString.substring(4,6);
      String nowYearString = nowString.substring(0,4);
      String lastYearString = CommonUtils.convertTimeToString(lastYearDate).substring(0,4);

      String startDate = "$lastYearString$targetMonth";
      String endDate = "$nowYearString$targetMonth";
      CommonUtils.log("i", "$startDate ~ $endDate");

      Map<String, dynamic> inputJsonForNhisConfirm = {
        "organization": "0002",
        "loginType": "5",
        "id": randomKey,
        "identity": birth,
        "loginTypeLevel": loginCertType,
        "userName": name,
        "phoneNo": phoneNo,
        "startDate": startDate,
        "endDate": endDate,
        "usePurposes": "2",
        "useType": "00",
        "originDataYN": "0",
        "telecom": telecom
      };

      return inputJsonForNhisConfirm;
    }else if(api == Apis.ntsProofCorporateRegistration){
      Map<String, dynamic> inputJsonForNtsPoorfCorporateRegistration = {
        "organization": "0001",
        "loginType": "6",
        "loginIdentity": loginIdentity,
        "userName": name,
        "id": randomKey,
        "usePurposes": "01",
        "submitTargets": "01",
        "isIdentityViewYN": "0",
        "originDataYN": "0",
        "applicationType": "01",
        "identity": identity,
        "loginTypeLevel": loginCertType,
        "phoneNo": phoneNo,
        "telecom": telecom
      };

      return inputJsonForNtsPoorfCorporateRegistration;
    }else if(api == Apis.ntsProofIssue){
      DateTime now = CommonUtils.getCurrentLocalTime();
      DateTime julyFirst = DateTime(now.year, 7, 1);

      DateTime lastYearDate = now.isBefore(julyFirst)
          ? DateTime(now.year - 2, 12, 31) // 7월 1일 이전이면 재작년 날짜
          : DateTime(now.year - 1, 12, 31); // 7월 1일 이후이면 작년 날짜

      String lastYearString = CommonUtils.convertTimeToString(lastYearDate).substring(0,4);
      CommonUtils.log("i", "last year : $lastYearString");

      Map<String, dynamic> inputJsonForNtsPoorfIssue = {
        "organization": "0001",
        "loginType": "6",
        "loginTypeLevel": loginCertType,
        "loginIdentity": loginIdentity,
        "userName": name,
        "phoneNo": phoneNo,
        "birthDate": "",
        "id": randomKey,
        "startYear": lastYearString,
        "endYear": lastYearString,
        "usePurposes": "01",
        "submitTargets": "02",
        "isIdentityViewYn": "0",
        "isAddrViewYn": "0",
        "originDataYN": "0",
        "applicationType": "",
        "clientTypeLevel": "",
        "identity": identity,
        "sourceIncomeYN": "",
        "telecom": telecom
      };

      return inputJsonForNtsPoorfIssue;
    }else if(api == Apis.ntsProofAdditionalTasStandard){
      DateTime now = CommonUtils.getCurrentLocalTime();
      DateTime lastYearDate = DateTime(now.year - 1, 12, 31); // 7월 1일 이후이면 작년 날짜
      String lastYearString = CommonUtils.convertTimeToString(lastYearDate).substring(0,4);
      String startDate = "${lastYearString}01";
      String endDate = "${CommonUtils.convertTimeToString(now).substring(0,4)}12";
      CommonUtils.log("i", "last year : $lastYearString $startDate $endDate");

      Map<String, dynamic> inputJsonForNtsProofAdditionalTasStandard = {
        "organization": "0001",
        "loginType": "6",
        "loginTypeLevel": loginCertType,
        "loginIdentity": loginIdentity,
        "userName": name,
        "phoneNo": phoneNo,
        "manageNo": "",
        "managePassword": "",
        "id": randomKey,
        "startDate": startDate,
        "endDate": endDate,
        "isIdentityViewYN": "0",
        "usePurposes": "04",
        "submitTargets": "01",
        "identity": identity,
        "applicationType": "01",
        "originDataYN": "0",
        "telecom": telecom
      };

      return inputJsonForNtsProofAdditionalTasStandard;
    }else if(api == Apis.ntsTaxCert){
      DateTime now = CommonUtils.getCurrentLocalTime();
      DateTime julyFirst = DateTime(now.year, 7, 1);
      bool isBeforeJuly = now.isBefore(julyFirst);
      DateTime lastYearDate = isBeforeJuly
          ? DateTime(now.year - 2, 12, 31) // 7월 1일 이전이면 재작년 날짜
          : DateTime(now.year - 1, 12, 31); // 7월 1일 이후이면 작년 날짜

      String lastYearString = CommonUtils.convertTimeToString(lastYearDate).substring(0,4);
      String startDate = isBeforeJuly? "${lastYearString}07" : "${lastYearString}01";
      String endDate = isBeforeJuly? "${CommonUtils.convertTimeToString(DateTime(now.year - 1, 12, 31)).substring(0,4)}06" : "${lastYearString}12";
      CommonUtils.log("i", "last year : $lastYearString $startDate $endDate");

      Map<String, dynamic> inputJsonForNtsTexCert = {
        "organization": "0001",
        "loginType": "6",
        "loginTypeLevel": loginCertType,
        "loginIdentity": loginIdentity,
        "userName": name,
        "phoneNo": phoneNo,
        "manageNo": "",
        "managePassword": "",
        "id": randomKey,
        "startDate": startDate,
        "endDate": endDate,
        "isIdentityViewYN": "0",
        "usePurposes": "04",
        "submitTargets": "01",
        "identity": identity,
        "applicationType": "01",
        "originDataYN": "0",
        "isAddrViewYn": "0",
        "proofType": "B0006",
        "clientTypeLevel": "1",
        "telecom": telecom
      };

      return inputJsonForNtsTexCert;
    }else{
      return {};
    }
  }

}

/// CODEF API CONFIG ------------------------------------------------------------------------------------------------------------------------ ///
enum HostStatus {
  dev, prod
}

extension HostStatusExtension on HostStatus {
  String get value {
    switch (this) {
      case HostStatus.dev:
        return 'DEV';
      case HostStatus.prod:
        return 'PROD';
      default:
        throw Exception('Unknown host value');
    }
  }
}

enum Host {
  clientId, clientSecret, baseUrl,
}

extension HostExtension on Host {
  String get value {
    switch (this) {
      case Host.clientId:
        return 'ad589fbb-9ecb-4b90-8619-bed250751c2f';
      case Host.clientSecret:
        return '39f186a7-cdf8-4d3c-9c83-ce7bdabd1c30';
      case Host.baseUrl:
        return 'https://api.codef.io';
      default:
        throw Exception('Unknown host value');
    }
  }
}

enum HostDev {
  clientId, clientSecret, baseUrl,
}

extension HostDevExtension on HostDev {
  String get value {
    switch (this) {
      case HostDev.clientId:
        return '8d16c7c8-b60a-44d5-a30d-2c2699fe10ff';
      case HostDev.clientSecret:
        return 'cf4c6ed3-1a2d-49c6-8cac-b901314452b5';
      case HostDev.baseUrl:
        return 'https://development.codef.io';
      default:
        throw Exception('Unknown host value');
    }
  }
}

enum Apis {
  gov24residentRegistrationAbstract, gov24residentRegistrationCopy, gov24localTaxPaymentCert, gov24CarRegistrationA, gov24CarRegistrationB,
  nhisIdentifyConfirmation, nhisConfirmation,
  ntsProofCorporateRegistration, ntsProofIssue, ntsProofAdditionalTasStandard, ntsTaxCert

}

extension ApisExtension on Apis {
  String get value {
    switch (this) {
      case Apis.gov24residentRegistrationAbstract:
        return '/v1/kr/public/mw/resident-registration-abstract/issuance';
      case Apis.gov24residentRegistrationCopy:
        return '/v1/kr/public/mw/resident-registration-copy/issuance';
      case Apis.gov24localTaxPaymentCert:
        return '/v1/kr/public/mw/localtax-payment-certificate/inquiry';
      case Apis.nhisIdentifyConfirmation:
        return '/v1/kr/public/pp/nhis-join/identify-confirmation';
      case Apis.nhisConfirmation:
        return '/v1/kr/public/pp/nhis-insurance-payment/confirmation';
      case Apis.ntsProofCorporateRegistration:
        return '/v1/kr/public/nt/proof-issue/corporate-registration';
      case Apis.ntsProofIssue:
        return '/v1/kr/public/nt/proof-issue/proof-income';
      case Apis.ntsProofAdditionalTasStandard:
        return '/v1/kr/public/nt/proof-issue/additional-tax-standard';
      case Apis.ntsTaxCert:
        return '/v1/kr/public/nt/proof-issue/tax-cert-all';
      case Apis.gov24CarRegistrationA:
        return '/v1/kr/public/mw/car-registration-a/issuance';
      case Apis.gov24CarRegistrationB:
        return '/v1/kr/public/mw/car-registration-b/issuance';
      default:
        throw Exception('Unknown host value');
    }
  }
}
/// ------------------------------------------------------------------------------------------------------------------------ ///