import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:upfin/controllers/get_controller.dart';
import 'package:upfin/datas/api_info_data.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
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
  //CF-13000 사업자번호(주민등록번호)가+잘못
  // 12100 해당+기관+오류
  /// CODEF API ------------------------------------------------------------------------------------------------------------------------ ///
  static HostStatus hostStatus = HostStatus.prod;
  static String token = "";
  static const errorCodeKey = "codefError";
  static void setHostStatus(HostStatus host){
    hostStatus = host;
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
      );

      if(response.statusCode == 200) {
        final decodedResponseBody = Uri.decodeFull(response.body);
        final json = jsonDecode(decodedResponseBody);
        if(json.containsKey('result') && json.containsKey('data')){
          final result = json['result'];
          final resultCode = result['code'];
          CommonUtils.log('i', 'out full : \n$json');

          // CF-00000 : 성공, CF-03002 : 추가 인증 필요
          final msg = result['message'];
          if(resultCode == 'CF-00000' || resultCode == 'CF-03002'){
            final resultData = json['data'];
            if (resultData is Map<String, dynamic>) {
              if(resultData.isNotEmpty){
                resultData['result_code'] = resultCode;
                if(resultCode == 'CF-03002') {
                  callback(true, true, resultData, null, json);
                } else {
                  callback(true, false, resultData, null, json);
                }
              }else{
                final Map<String, dynamic> resultData = {};
                resultData['result_code'] = errorCodeKey;
                resultData['result_msg'] = msg;
                CommonUtils.log('e', 'out resultCode error : $resultCode');
                callback(true, false, resultData, null, json);
              }
            } else if (resultData is List<dynamic>) {
              if(resultData.isNotEmpty){
                resultData[0]['result_code'] = resultCode;
                if(resultCode == 'CF-03002') {
                  callback(true, true, null, resultData, json);
                } else {
                  callback(true, false, null, resultData, json);
                }
              }else{
                final Map<String, dynamic> resultData = {};
                resultData['result_code'] = errorCodeKey;
                resultData['result_msg'] = msg;
                CommonUtils.log('e', 'out resultCode error : $resultCode');
                callback(true, false, resultData, null, json);
              }
            }
          } else {
            final Map<String, dynamic> resultData = {};
            resultData['result_code'] = errorCodeKey;
            resultData['result_msg'] = msg;
            CommonUtils.log('e', 'out resultCode error : $resultCode');
            callback(true, false, resultData, null, json);
          }
        }
      } else {
        CommonUtils.log('e', 'http error code : ${response.statusCode}');
        final Map<String, dynamic> resultData = {};
        resultData['result_code'] = errorCodeKey;
        resultData['result_msg'] = "인터넷 연결에러가 발생했습니다.";
        callback(true, false, resultData, null, null);
      }
    } catch (e) {
      CommonUtils.log('e', e.toString());
      final Map<String, dynamic> resultData = {};
      resultData['result_code'] = errorCodeKey;
      resultData['result_msg'] = "에러가 발생했습니다.";
      callback(true, false, resultData, null, null);
    }
  }

  /// ------------------------------------------------------------------------------------------------------------------------ ///
  static Future<void> callApisWithCert(BuildContext context, StateSetter setState, int certType,
      List<ApiInfoData> apiInfoDataList, Function(bool isSuccess, List<ApiInfoData>? resultApiInfoDataList) callback) async {
    int callCount = 0;
    bool isFirstCalledOnCert = false;
    for(var each in apiInfoDataList){
      if(each.isCallWithCert){
        if(!isFirstCalledOnCert){
          _callApiWithCert(context, setState, certType, each.api, each.inputJson, (isSuccess, resultMap, resultListMap, fullMap) {
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
                  //CommonUtils.flutterToast(errorMsg.replaceAll("+", " "));
                }else{
                  if(fullMap == null){
                    each.isResultSuccess = false;
                    resultMap["result_msg"] = "조회에 실패했습니다.";
                    each.resultMap = null;
                    each.resultFullMap = fullMap;
                  }else{
                    if(fullMap["result"]["code"] == "CF-03002"){
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
              if(callCount == apiInfoDataList.length){
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
          await Future.delayed(const Duration(milliseconds: 500), () async {});
          isFirstCalledOnCert = true;
        }else{
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
                  //CommonUtils.flutterToast(errorMsg.replaceAll("+", " "));
                }else{
                  if(fullMap == null){
                    each.isResultSuccess = false;
                    resultMap["result_msg"] = "조회에 실패했습니다.";
                    each.resultMap = null;
                    each.resultFullMap = fullMap;
                  }else{
                    if(fullMap["result"]["code"] == "CF-03002"){
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
              if(callCount == apiInfoDataList.length){
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
                  launchUrl(Uri.parse("naversearchapp://default?version=1"));
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

    UiUtils.showSlideMenu(context, SlideType.bottomToTop, false, null, 25.h, 0.0, (context, setState){
      return Obx(()=>
          Column(mainAxisAlignment: MainAxisAlignment.start, children:
          [
            UiUtils.getMarginBox(0, 3.h),
            GetController.to.isWait.value ? UiUtils.getStyledTextWithFixedScale("인증 정보를 확인하는 중입니다...", TextStyles.upFinBasicTextStyle, TextAlign.center, null) :
            UiUtils.getStyledTextWithFixedScale("", TextStyles.upFinBasicTextStyle, TextAlign.center, null),
            GetController.to.isWait.value ? Container() : Column(children: [
              UiUtils.getStyledTextWithFixedScale(certName, TextStyles.upFinBasicTextStyle, TextAlign.center, null),
              UiUtils.getMarginBox(0, 0.5.h),
              UiUtils.getStyledTextWithFixedScale("아래 인증확인 버튼을 눌러주세요.", TextStyles.upFinBasicTextStyle, TextAlign.center, null),
              UiUtils.getMarginBox(0, 3.h),
              UiUtils.getBorderButtonBox(85.w, ColorStyles.upFinWhite, ColorStyles.upFinTextAndBorderBlue,
                  UiUtils.getTextWithFixedScale("인증확인", 15.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null), () {
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
                          }else if(fullMap!['result']['code'] == "CF-12835"){
                            CommonUtils.log("i","cancel");
                            CommonUtils.flutterToast("인증서 정보가 없습니다.");
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
                          }else if(fullMap!['result']['code'] == "CF-12835"){
                            CommonUtils.log("i","cancel");
                            CommonUtils.flutterToast("인증서 정보가 없습니다.");
                            GetController.to.updateWait(false);
                            callback(false, null, null, null);
                          }else{
                            CommonUtils.log("i","no cancel");
                            callback(true, null, listMap, fullMap);
                          }
                        }
                      }
                    });
                  })
            ])])
      );
    });
  }

  static Map<String, dynamic> makeInputJsonForCertApis(Apis api, String identity, String birth, String name, String phoneNo, String telecom,
      String address, String loginCertType, String randomKey){
    if(api == Apis.gov24residentRegistrationAbstract){
      Map<String, dynamic> inputJsonForAbstract = {
        "organization": "0001",
        "loginType": "6",
        "identity": identity,
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
        "identity": identity,
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
        "identity": identity,
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
        "loginIdentity": identity,
        "userName": name,
        "id": randomKey,
        "usePurposes": "01",
        "submitTargets": "01",
        "isIdentityViewYN": "0",
        "originDataYN": "0",
        "applicationType": "01",
        "identity": "",
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
        "loginIdentity": identity,
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
        "identity": "",
        "sourceIncomeYN": "",
        "telecom": telecom
      };

      return inputJsonForNtsPoorfIssue;
    }else{
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
        "loginIdentity": identity,
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
        "identity": "*************",
        "applicationType": "01",
        "originDataYN": "0",
        "telecom": telecom
      };

      return inputJsonForNtsProofAdditionalTasStandard;
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
  ntsProofCorporateRegistration, ntsProofIssue, ntsProofAdditionalTasStandard
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
      default:
        throw Exception('Unknown host value');
    }
  }
}
/// ------------------------------------------------------------------------------------------------------------------------ ///