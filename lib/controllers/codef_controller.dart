import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:upfin/controllers/get_controller.dart';
import 'package:upfin/datas/api_info_data.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../configs/app_config.dart';
import '../styles/ColorStyles.dart';
import '../styles/TextStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class CodeFController{

  static final CodeFController _instance = CodeFController._internal();
  factory CodeFController() => _instance;
  CodeFController._internal();
  static final Map<String,String> errorMsgMap = {
    "CF-13000" : "사업자번호(주민등록번호) 오류입니다.",
    "CF-12100" : "인증기관 오류입니다.",
    "CF-12100A" : "주소정보가 일치하지 않습니다.",
    "CF-01004" : "응답대기시간이 초과되었습니다.",
    "CF-12872" : "인증요청이 취소되었습니다.",
    "CF-12835" : "인증서정보가 없습니다.",
    "error_timeout" : "응답대기시간이 초과되었습니다.",
    "error_http" : "인터넷연결 오류입니다.",
    "error_connection" : "서버연결 오류입니다.",
    "error_cert" : "정보를 가져오는데 문제가 발생했습니다.",
    "error_null" : "정보를 가져오는데 실패했습니다.",
    };
  /// CODEF API ------------------------------------------------------------------------------------------------------------------------ ///
  static HostStatus hostStatus = HostStatus.prod;
  static String token = "";
  static const errorCodeKey = "codefError";
  static bool isTimeOutException = false;
  static void setHostStatus(HostStatus host){
    hostStatus = host;
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

  static Future<void> _getDataFromApi(Apis apiInfo, Map<String, dynamic> inputJson,
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
          final resultCode = result['code'];
          CommonUtils.log('', 'out full : \n$json');

          // CF-00000 : 성공, CF-03002 : 추가 인증 필요
          final msg = result['message'];
          if(resultCode == 'CF-00000' || resultCode == 'CF-03002'){
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
              }else{
                final Map<String, dynamic> resultData = {};
                resultData['result_code'] = errorCodeKey;
                resultData['result_codef_code'] = resultCode;
                resultData['result_msg'] = msg;
                CommonUtils.log('e', 'out resultCode error : $resultCode');
                callback(true, false, resultData, null, json);
              }
            } else if (resultData is List<dynamic>) {
              if(resultData.isNotEmpty){
                resultData[0]['result_code'] = resultCode;
                resultData[0]['result_codef_code'] = resultCode;
                if(resultCode == 'CF-03002') {
                  callback(true, true, null, resultData, json);
                } else {
                  callback(true, false, null, resultData, json);
                }
              }else{
                final Map<String, dynamic> resultData = {};
                resultData['result_code'] = errorCodeKey;
                resultData['result_codef_code'] = resultCode;
                resultData['result_msg'] = msg;
                CommonUtils.log('e', 'out resultCode error : $resultCode');
                callback(true, false, resultData, null, json);
              }
            }
          } else {
            final Map<String, dynamic> resultData = {};
            resultData['result_code'] = errorCodeKey;
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
        callback(true, false, resultData, null, null);
      }
    } catch (e) {
      isTimeOutException = true;
      CommonUtils.log('e', e.toString());
      final Map<String, dynamic> resultData = {};
      resultData['result_code'] = errorCodeKey;
      resultData['result_codef_code'] = "error_timeout";
      resultData['result_msg'] = "에러가 발생했습니다.";
      callback(true, false, resultData, null, null);
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
          CommonUtils.log('', 'out full : \n$json');

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
      isTimeOutException = true;
      CommonUtils.log('e', e.toString());
      final Map<String, dynamic> resultData = {};
      resultData['result_code'] = errorCodeKey;
      resultData['result_codef_code'] = "error_timeout";
      resultData['result_msg'] = "에러가 발생했습니다.";
      callback(false, false, resultData, null, null);
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
  static Future<void> callApisWithCert(BuildContext context, StateSetter setState, int certType,
      List<ApiInfoData> apiInfoDataList, Function(bool isSuccess, List<ApiInfoData>? resultApiInfoDataList) callback) async {
    int callCount = 0;
    bool isFirstCalledOnCert = false;
    for(var each in apiInfoDataList){
      if(each.isCallWithCert){
        if(!isFirstCalledOnCert){
          isFirstCalledOnCert = true;
          _callApiWithCert(context, setState, certType, each.api, each.inputJson, (isSuccess, resultMap, resultListMap, fullMap) {
            if(isSuccess){
              if(resultMap != null){
                if(resultMap["result_code"] == errorCodeKey){
                  each.isResultSuccess = false;
                  CommonUtils.log("e", "error api 1: ${each.api.value}");
                  String errorMsg = resultMap["result_msg"];
                  if(errorMsg == "성공"){
                    errorMsg = "조회결과가 없습니다.";
                  }
                  each.resultMap = null;
                  each.resultFullMap = fullMap;
                  //CommonUtils.flutterToast(errorMsg.replaceAll("+", " "));
                }else{
                  if(fullMap == null){
                    CommonUtils.log("e", "error api 2: ${each.api.value}");
                    each.isResultSuccess = false;
                    resultMap["result_msg"] = "조회에 실패했습니다.";
                    each.resultMap = null;
                    each.resultFullMap = fullMap;
                  }else{
                    if(fullMap["result"]["code"] == "CF-03002"){
                      CommonUtils.log("e", "error api 3: ${each.api.value}");
                      resultMap["result_msg"] = "인증에 실패했습니다.";
                      each.isResultSuccess = false;
                      each.resultMap = null;
                      each.resultFullMap = fullMap;
                    }else{
                      each.isResultSuccess = true;
                      each.resultMap = resultMap;
                      each.resultFullMap = fullMap;
                    }
                  }
                }
              }else{
                each.isResultSuccess = true;
                each.resultListMap = resultListMap;
                each.resultFullMap = fullMap;
              }

              callCount++;
              if(callCount >= apiInfoDataList.length){
                GetController.to.updateWait(false);
                isSetAuthPopOn = false;
                Navigator.of(context).pop();
                callback(true, apiInfoDataList);
              }
            }else{
              if(isSetAuthPopOn){
                GetController.to.updateWait(false);
                isSetAuthPopOn = false;
                Navigator.of(context).pop();
              }
              each.isResultSuccess = false;
              each.resultMap = null;
              each.resultListMap = null;
              each.resultFullMap = null;
              callback(false, apiInfoDataList);
            }
          });
          await Future.delayed(const Duration(milliseconds: 1000), () async {});
        }else{
          _callApiWithOutCert(context, each.api, each.inputJson, (isSuccess, resultMap, resultListMap, fullMap){
            if(isSuccess){
              if(resultMap != null){
                if(resultMap["result_code"] == errorCodeKey){
                  each.isResultSuccess = false;
                  CommonUtils.log("e", "error api 1: ${each.api.value}");
                  String errorMsg = resultMap["result_msg"];
                  if(errorMsg == "성공"){
                    errorMsg = "조회결과가 없습니다.";
                  }
                  each.resultMap = null;
                  each.resultFullMap = fullMap;
                  //CommonUtils.flutterToast(errorMsg.replaceAll("+", " "));
                }else{
                  if(fullMap == null){
                    CommonUtils.log("e", "error api 2: ${each.api.value}");
                    each.isResultSuccess = false;
                    resultMap["result_msg"] = "조회에 실패했습니다.";
                    each.resultMap = null;
                    each.resultFullMap = fullMap;
                  }else{
                    if(fullMap["result"]["code"] == "CF-03002"){
                      CommonUtils.log("e", "error api 3: ${each.api.value}");
                      resultMap["result_msg"] = "인증에 실패했습니다.";
                      each.isResultSuccess = false;
                      each.resultMap = null;
                      each.resultFullMap = fullMap;
                    }else{
                      each.isResultSuccess = true;
                      each.resultMap = resultMap;
                      each.resultFullMap = fullMap;
                    }
                  }
                }
              }else{
                each.isResultSuccess = true;
                each.resultListMap = resultListMap;
                each.resultFullMap = fullMap;
              }

              callCount++;
              if(callCount >= apiInfoDataList.length){
                if(isSetAuthPopOn){
                  GetController.to.updateWait(false);
                  isSetAuthPopOn = false;
                  Navigator.of(context).pop();
                }
                callback(true, apiInfoDataList);
              }
            }
          });
        }
      }
    }
  }

  static Future<void> callApisWithOutCert(BuildContext context, List<ApiInfoData> apiInfoDataList,
      Function(bool isSuccess, List<ApiInfoData>? resultApiInfoDataList) callback) async {
    int callCount = 0;
    for(var each in apiInfoDataList){
      if(!each.isCallWithCert){
        _callApiWithOutCert(context, each.api, each.inputJson, (isSuccess, resultMap, resultListMap, fullMap){
          if(isSuccess){
            if(resultMap != null){
              if(resultMap["result_code"] == errorCodeKey){
                each.isResultSuccess = false;
                CommonUtils.log("e", "error api : ${each.api.value}");
                String errorMsg = resultMap["result_msg"];
                if(errorMsg == "성공"){
                  errorMsg = "조회결과가 없습니다.";
                }
                each.resultMap = null;
                each.resultFullMap = fullMap;
              }else{
                each.isResultSuccess = true;
                each.resultMap = resultMap;
                each.resultFullMap = fullMap;
              }
            }else{
              each.isResultSuccess = true;
              each.resultListMap = resultListMap;
              each.resultFullMap = fullMap;
            }

            callCount++;
            if(callCount == apiInfoDataList.length){
              callback(true, apiInfoDataList);
            }
          }
        });
      }
    }
  }

  static Future<void> _callApiWithOutCert(BuildContext context, Apis api, Map<String, dynamic> inputJson,
      Function(bool isSuccess, Map<String,dynamic>? resultMap, List<dynamic>? resultListMap, Map<String,dynamic>? fullMap) callback) async {
    CodeFController._getDataFromApi(api, inputJson, (isSuccess, _, map, listMap, fullResultMap) {
      if(isSuccess){
        if(map != null){
          callback(true, map, null, fullResultMap);
        }else{
          callback(true, null, listMap, fullResultMap);
        }
      }
    });
  }

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
    await CodeFController._getDataFromApi2(apiInfoDataList[0].api, apiInfoDataList[0].inputJson, (isSuccess, is2WayProcess, map, listMap, fullResultMap) async {
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
                if(certType == 1){
                  if(await canLaunchUrl(Uri.parse("kakaotalk://launch"))){
                    launchUrl(Uri.parse("kakaotalk://launch"));
                  }else{
                    Config.isAndroid ? launchUrl(Uri.parse("market://details?id=com.kakao.talk"))
                        : launchUrl(Uri.parse("https://apps.apple.com/kr/app/kakaotalk/id869223134?mt=12"));
                  }
                }else if(certType == 6){
                  if(await canLaunchUrl(Uri.parse("naversearchapp://default?version=1"))){
                    launchUrl(Uri.parse("market://details?id=com.nhn.android.search"));
                  }else{
                    Config.isAndroid ? launchUrl(Uri.parse("market://details?id=com.nhn.android.search"))
                        : launchUrl(Uri.parse("https://apps.apple.com/kr/app/%EB%84%A4%EC%9D%B4%EB%B2%84-naver/id393499958"));
                  }
                }else if(certType == 8){
                  if(await canLaunchUrl(Uri.parse("supertoss://launch"))){
                    launchUrl(Uri.parse("market://details?id=viva.republica.toss"));
                  }else{
                    Config.isAndroid ? launchUrl(Uri.parse("market://details?id=viva.republica.toss"))
                        : launchUrl(Uri.parse("https://apps.apple.com/kr/app/%ED%86%A0%EC%8A%A4/id839333328"));
                  }
                }else if(certType == 5){
                  if(apiInfoDataList[0].inputJson.containsKey("telecom")){
                    String telecom = apiInfoDataList[0].inputJson["telecom"];
                    if(telecom == "0"){
                      if(await canLaunchUrl(Uri.parse("tauthlink://launch"))){
                        //launchUrl(Uri.parse("tauthlink://launch"));
                        launchUrl(Uri.parse("market://details?id=com.sktelecom.tauth"));
                      }else{
                        Config.isAndroid ? launchUrl(Uri.parse("market://details?id=com.sktelecom.tauth"))
                            : launchUrl(Uri.parse("https://apps.apple.com/kr/app/pass-by-skt/id1141258007"));
                      }
                    }else if(telecom == "1"){
                      if(await canLaunchUrl(Uri.parse("ktauthexternalcall://launch"))){
                        //launchUrl(Uri.parse("ktauthexternalcall://launch"));
                        launchUrl(Uri.parse("market://details?id=com.kt.ktauth"));
                      }else{
                        Config.isAndroid ? launchUrl(Uri.parse("market://details?id=com.kt.ktauth"))
                            : launchUrl(Uri.parse("https://apps.apple.com/kr/app/pass-by-kt/id1134371550"));
                      }
                    }else{
                      if(await canLaunchUrl(Uri.parse("upluscorporation://launch"))){
                        //launchUrl(Uri.parse("upluscorporation://launch"));
                        launchUrl(Uri.parse("market://details?id=com.lguplus.smartotp"));
                      }else{
                        Config.isAndroid ? launchUrl(Uri.parse("market://details?id=com.lguplus.smartotp"))
                            : launchUrl(Uri.parse("https://apps.apple.com/kr/app/pass-by-u/id1147394645"));
                      }
                    }
                  }
                }

                if(context.mounted){
                  int callCount = 0;
                  if(apiInfoDataList.length > 1){
                    for(int i = 1 ; i < apiInfoDataList.length ; i++){
                      _callApiWithOutCert2(context, apiInfoDataList[i].api, apiInfoDataList[i].inputJson, (isSuccess, resultMap, resultListMap, fullMap) {
                        callCount++;
                        if(isSuccess){
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
                        }

                        if(callCount == apiInfoDataList.length){
                          callback(true, apiInfoDataList);
                        }
                      });
                    }
                  }

                  isSetAuthPopOn = true;
                  _setAuthPop2(context, apiInfoDataList[0].api, certType, result2WayMap,(isAuthSuccess, authMap, authListMap, fullMap) async {
                    callCount++;
                    if(isAuthSuccess){
                      if(fullMap == null){
                        apiInfoDataList[0].isResultSuccess = false;
                        apiInfoDataList[0].resultMap = null;
                        apiInfoDataList[0].resultListMap = null;
                        apiInfoDataList[0].resultFullMap = null;
                        if(fullMap != null){
                          apiInfoDataList[0].errorCode = fullMap["result_codef_code"];
                        }else if(authListMap != null){
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

  static Future<void> _callApiWithCert(BuildContext context, StateSetter setState, int certType, Apis representApi, Map<String, dynamic> inputJson,
      Function(bool isSuccess, Map<String,dynamic>? resultMap, List<dynamic>? resultListMap, Map<String,dynamic>? fullMap) callback) async {
    await CodeFController._getDataFromApi(representApi, inputJson, (isSuccess, is2WayProcess, map, listMap, fullResultMap) async {
      if(isSuccess){
        if(map != null){
          if(is2WayProcess){
            Map<String, dynamic>? resultMap = _set2WayMap(inputJson, map);
            if(resultMap != null){
              if(certType == 1){
                if(await canLaunchUrl(Uri.parse("kakaotalk://launch"))){
                  launchUrl(Uri.parse("kakaotalk://launch"));
                }else{
                  Config.isAndroid ? launchUrl(Uri.parse("market://details?id=com.kakao.talk"))
                      : launchUrl(Uri.parse("https://apps.apple.com/kr/app/kakaotalk/id869223134?mt=12"));
                }
              }else if(certType == 6){
                if(await canLaunchUrl(Uri.parse("naversearchapp://default?version=1"))){
                  launchUrl(Uri.parse("market://details?id=com.nhn.android.search"));
                }else{
                  Config.isAndroid ? launchUrl(Uri.parse("market://details?id=com.nhn.android.search"))
                      : launchUrl(Uri.parse("https://apps.apple.com/kr/app/%EB%84%A4%EC%9D%B4%EB%B2%84-naver/id393499958"));
                }
              }else if(certType == 8){
                if(await canLaunchUrl(Uri.parse("supertoss://launch"))){
                  launchUrl(Uri.parse("market://details?id=viva.republica.toss"));
                }else{
                  Config.isAndroid ? launchUrl(Uri.parse("market://details?id=viva.republica.toss"))
                      : launchUrl(Uri.parse("https://apps.apple.com/kr/app/%ED%86%A0%EC%8A%A4/id839333328"));
                }
              }else if(certType == 5){
                if(inputJson.containsKey("telecom")){
                  String telecom = inputJson["telecom"];
                  if(telecom == "0"){
                    if(await canLaunchUrl(Uri.parse("tauthlink://launch"))){
                      //launchUrl(Uri.parse("tauthlink://launch"));
                      launchUrl(Uri.parse("market://details?id=com.sktelecom.tauth"));
                    }else{
                      Config.isAndroid ? launchUrl(Uri.parse("market://details?id=com.sktelecom.tauth"))
                          : launchUrl(Uri.parse("https://apps.apple.com/kr/app/pass-by-skt/id1141258007"));
                    }
                  }else if(telecom == "1"){
                    if(await canLaunchUrl(Uri.parse("ktauthexternalcall://launch"))){
                      //launchUrl(Uri.parse("ktauthexternalcall://launch"));
                      launchUrl(Uri.parse("market://details?id=com.kt.ktauth"));
                    }else{
                      Config.isAndroid ? launchUrl(Uri.parse("market://details?id=com.kt.ktauth"))
                          : launchUrl(Uri.parse("https://apps.apple.com/kr/app/pass-by-kt/id1134371550"));
                    }
                  }else{
                    if(await canLaunchUrl(Uri.parse("upluscorporation://launch"))){
                      //launchUrl(Uri.parse("upluscorporation://launch"));
                      launchUrl(Uri.parse("market://details?id=com.lguplus.smartotp"));
                    }else{
                      Config.isAndroid ? launchUrl(Uri.parse("market://details?id=com.lguplus.smartotp"))
                          : launchUrl(Uri.parse("https://apps.apple.com/kr/app/pass-by-u/id1147394645"));
                    }
                  }
                }
              }
              isSetAuthPopOn = true;
              if(context.mounted){
                _setAuthPop(context, representApi, certType, resultMap,(isAuthSuccess, authMap, authListMap, fullMap) async {
                  if(isAuthSuccess){
                    if(authMap != null){
                      callback(true, authMap, null, fullMap);
                    }else{
                      callback(true, null, authListMap, fullMap);
                    }
                  }else{
                    callback(false, null, null, null);
                  }
                });
              }
              setState(() {});
            }else{

            }
          }else{
            callback(true, map, null, fullResultMap);
          }
        }
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
    String certName = "인증을 완료하셨다면,";
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


    UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, false, null, 40.h, 0.0, (context, setState){
      return Obx(()=>Column(mainAxisAlignment: MainAxisAlignment.start, children:[
        UiUtils.getMarginBox(0, 9.5.h),
        GetController.to.isWait.value? Column(children: [
          UiUtils.getImage(20.w, 20.w,  Image.asset(fit: BoxFit.fill,'assets/images/doc_move.gif')),
          UiUtils.getMarginBox(0, 0.5.h),
          LinearPercentIndicator(
            animateFromLastPercent: true,
            alignment: MainAxisAlignment.center,
            barRadius: const Radius.circular(10),
            animation: true,
            center: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
              UiUtils.getTextWithFixedScale("${GetController.to.loadingPercent.value}", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null),
              UiUtils.getMarginBox(0.5.w, 0),
              UiUtils.getTextWithFixedScale("%", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null),
            ]),
            width: 60.w,
            lineHeight: 3.h,
            linearStrokeCap: LinearStrokeCap.round,
            backgroundColor : ColorStyles.upFinWhite,
            progressColor: ColorStyles.upFinWhite,
          )
        ])
            : Column(children: [
              UiUtils.getMarginBox(0, 0.5.h),
              UiUtils.getStyledTextWithFixedScale(certName, TextStyles.upFinBasicTextStyle, TextAlign.center, null)]),
        GetController.to.isWait.value? UiUtils.getMarginBox(0, 3.h) : UiUtils.getMarginBox(0, 0.5.h),
        GetController.to.isWait.value? UiUtils.getStyledTextWithFixedScale("서류를 가지고 오는중입니다.", TextStyles.upFinBasicTextStyle, TextAlign.center, null) : Container(),
        GetController.to.isWait.value? Container() : UiUtils.getStyledTextWithFixedScale("간편인증 후 확인 버튼을 눌러주세요.", TextStyles.upFinBasicTextStyle, TextAlign.center, null),
        GetController.to.isWait.value? Container() : UiUtils.getExpandedScrollView(Axis.vertical, const Column(children: [])),
        GetController.to.isWait.value? Container() : UiUtils.getBorderButtonBox(85.w, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinTextAndBorderBlue,
            UiUtils.getTextWithFixedScale("확인", 15.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
              GetController.to.updateWait(true);
              CodeFController._getDataFromApi2(apiInfo, resultInputMap, (isSuccess, _, map, listMap, fullMap){
                if(isSuccess){
                  if(map != null){
                    if(map['result_code'] == "CF-03002"){
                      CommonUtils.flutterToast("인증을 진행해주세요.");
                      GetController.to.updateWait(false);
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

  static Future<void> _setAuthPop(BuildContext context, Apis apiInfo, int certType, Map<String, dynamic> resultInputMap,
      Function(bool isSuccess, Map<String,dynamic>? resultMap, List<dynamic>? resultListMap, Map<String,dynamic>? fullResultMap) callback) async {
    String certName = "인증을 완료하셨다면,";
    if(certType == 1){
      certName = "카카오앱에서 $certName";
    }else if(certType == 6){
      certName = "네이버앱에서 $certName";
    }else if(certType == 8){
      certName = "토스앱에서 $certName";
    }else if(certType == 5){
      certName = "PASS앱에서 $certName";
    }

    UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, false, null, 40.h, 0.0, (context, setState){
      return Obx(()=>Column(mainAxisAlignment: MainAxisAlignment.start, children:[
        UiUtils.getMarginBox(0, 9.5.h),
        GetController.to.isWait.value? UiUtils.getImage(20.w, 20.w,  Image.asset(fit: BoxFit.fill,'assets/images/doc_move.gif'))
            : Column(children: [
          UiUtils.getMarginBox(0, 0.5.h),
          UiUtils.getStyledTextWithFixedScale(certName, TextStyles.upFinBasicTextStyle, TextAlign.center, null)]),
        GetController.to.isWait.value? UiUtils.getMarginBox(0, 3.h) : UiUtils.getMarginBox(0, 0.8.h),
        GetController.to.isWait.value? UiUtils.getStyledTextWithFixedScale("서류를 가지고 오는중입니다.", TextStyles.upFinBasicTextStyle, TextAlign.center, null) : Container(),
        GetController.to.isWait.value? Container() : UiUtils.getStyledTextWithFixedScale("간편인증 후 확인 버튼을 눌러주세요.", TextStyles.upFinBasicTextStyle, TextAlign.center, null),
        GetController.to.isWait.value? Container() : UiUtils.getExpandedScrollView(Axis.vertical, const Column(children: [])),
        GetController.to.isWait.value? Container() : UiUtils.getBorderButtonBox(85.w, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinTextAndBorderBlue,
            UiUtils.getTextWithFixedScale("확인", 15.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
              GetController.to.updateWait(true);
              CodeFController._getDataFromApi(apiInfo, resultInputMap, (isSuccess, _, map, listMap, fullMap){
                if(isSuccess){
                  if(map != null){
                    if(map['result_code'] == "CF-03002"){
                      CommonUtils.flutterToast("인증을 진행해주세요.");
                      GetController.to.updateWait(false);
                    }else if(fullMap!['result']['code'] == "CF-12872"){
                      CommonUtils.log("i","cancel");
                      CommonUtils.flutterToast("인증에 실패했습니다.\n다시 시도해주세요.");
                      GetController.to.updateWait(false);
                      callback(false, null, null, null);
                    }else if(fullMap['result']['code'] == "CF-12835"){
                      CommonUtils.log("i","cancel");
                      CommonUtils.flutterToast("인증서 정보가 없습니다.");
                      GetController.to.updateWait(false);
                      callback(false, null, null, null);
                    }else if(fullMap['result']['code'] == "CF-01004"){
                      CommonUtils.log("i","cancel");
                      CommonUtils.flutterToast("응답 대기시간이 초과되었습니다.");
                      GetController.to.updateWait(false);
                      callback(false, null, null, null);
                    }else if(fullMap['result']['code'] == "CF-13000"){
                      CommonUtils.log("i","cancel");
                      CommonUtils.flutterToast("주민.사업자등록번호 오류입니다.");
                      GetController.to.updateWait(false);
                      callback(false, null, null, null);
                    }else if(fullMap['result']['code'] == "CF-12100"){
                      CommonUtils.log("i","cancel");
                      CommonUtils.flutterToast("입력하신 정보를\n확인해주세요.");
                      GetController.to.updateWait(false);
                      callback(false, null, null, null);
                    }else{
                      CommonUtils.log("i","no cancel");
                      callback(true, map, null, fullMap);
                    }
                  }else{
                    if(listMap?[0]['result_code'] == "CF-03002"){
                      CommonUtils.flutterToast("인증을 진행해주세요.");
                      GetController.to.updateWait(false);
                    }else if(fullMap!['result']['code'] == "CF-12872"){
                      CommonUtils.log("i","cancel");
                      CommonUtils.flutterToast("인증에 실패했습니다.\n다시 시도해주세요.");
                      GetController.to.updateWait(false);
                      callback(false, null, null, null);
                    }else if(fullMap['result']['code'] == "CF-12835"){
                      CommonUtils.log("i","cancel");
                      CommonUtils.flutterToast("인증서 정보가 없습니다.");
                      GetController.to.updateWait(false);
                      callback(false, null, null, null);
                    }else if(fullMap['result']['code'] == "CF-01004"){
                      CommonUtils.log("i","cancel");
                      CommonUtils.flutterToast("응답 대기시간이 초과되었습니다.");
                      GetController.to.updateWait(false);
                      callback(false, null, null, null);
                    }else if(fullMap['result']['code'] == "CF-13000"){
                      CommonUtils.log("i","cancel");
                      CommonUtils.flutterToast("주민.사업자등록번호 오류입니다.");
                      GetController.to.updateWait(false);
                      callback(false, null, null, null);
                    }else if(fullMap['result']['code'] == "CF-12100"){
                      CommonUtils.log("i","cancel");
                      CommonUtils.flutterToast("입력하신 정보를\n확인해주세요.");
                      GetController.to.updateWait(false);
                      callback(false, null, null, null);
                    }else{
                      CommonUtils.log("i","no cancel");
                      callback(true, null, listMap, fullMap);
                    }
                  }
                }
              });
            }),
        Config.isAndroid? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 3.h)
      ]));
    });
  }

  static Map<String, dynamic> makeInputJsonForCertApis(Apis api, String loginIdentity, String identity, String birth, String name, String phoneNo, String telecom,
      String address, String loginCertType, String randomKey){
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
        "personalInfoChangeYN": "0",
        "pastAddrChangeYN": "0",
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
        "isIdentityViewYn": "1",
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
      DateTime oneMonthAgo = DateTime(
        now.year,
        now.month - 1,
        now.day,
        now.hour,
        now.minute,
        now.second,
      );

      String oneMonthAgoString = CommonUtils.convertTimeToString(oneMonthAgo);
      DateTime lastYearDate = DateTime(oneMonthAgo.year - 1, 12, 31);
      String targetMonth = oneMonthAgoString.substring(4,6);
      String oneMonthAgoYearString = oneMonthAgoString.substring(0,4);
      String lastYearString = CommonUtils.convertTimeToString(lastYearDate).substring(0,4);

      String startDate = "$lastYearString$targetMonth";
      String endDate = "$oneMonthAgoYearString$targetMonth";
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
        "useType": "01",
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
        "isIdentityViewYn": "1",
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
      DateTime julyFirst = DateTime(now.year, 7, 1);
      bool isBeforeJuly = now.isBefore(julyFirst);
      DateTime lastYearDate = isBeforeJuly
          ? DateTime(now.year - 2, 12, 31) // 7월 1일 이전이면 재작년 날짜
          : DateTime(now.year - 1, 12, 31); // 7월 1일 이후이면 작년 날짜

      String lastYearString = CommonUtils.convertTimeToString(lastYearDate).substring(0,4);
      String startDate = isBeforeJuly? "${lastYearString}07" : "${lastYearString}01";
      String endDate = isBeforeJuly? "${CommonUtils.convertTimeToString(DateTime(now.year - 1, 12, 31)).substring(0,4)}06" : "${lastYearString}12";
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
  addressApi1, addressApi2, carRegistration1Api, carRegistration2Api, bankruptApi1, bankruptApi2,
  gov24residentRegistrationAbstract, gov24residentRegistrationCopy, gov24localTaxPaymentCert,
  nhisIdentifyConfirmation, nhisConfirmation,
  ntsProofCorporateRegistration, ntsProofIssue, ntsProofAdditionalTasStandard, ntsTaxCert
}

extension ApisExtension on Apis {
  String get value {
    switch (this) {
      case Apis.addressApi1:
        return '/v1/kr/etc/ld/kb/serial-number';
      case Apis.addressApi2:
        return '/v1/kr/etc/ld/kb/market-price-information';
      case Apis.carRegistration1Api:
        return '/v1/kr/public/mw/car-registration-a/issuance';
      case Apis.carRegistration2Api:
        return '/v1/kr/public/mw/car-registration-b/issuance';
      case Apis.bankruptApi1:
        return '/v1/kr/public/ck/rehab-bankruptcy/list';
      case Apis.bankruptApi2:
        return '/v1/kr/public/ck/scourt-events/search';
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
      default:
        throw Exception('Unknown host value');
    }
  }
}
/// ------------------------------------------------------------------------------------------------------------------------ ///