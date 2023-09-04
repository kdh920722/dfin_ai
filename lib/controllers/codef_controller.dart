import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:upfin/controllers/get_controller.dart';
import 'package:upfin/datas/api_info_data.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import '../configs/app_config.dart';
import '../styles/ColorStyles.dart';
import '../styles/TextStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class CodeFController{

  static final CodeFController _instance = CodeFController._internal();
  factory CodeFController() => _instance;
  CodeFController._internal();

  /// CODEF API ------------------------------------------------------------------------------------------------------------------------ ///
  static HostStatus hostStatus = HostStatus.prod;
  static String token = "";

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
      void Function(bool isSuccess, bool is2WayProcess, Map<String, dynamic>? outputJson, List<dynamic>? outputJsonArray) callback) async {
    final baseUrl = hostStatus.value == HostStatus.prod.value ? Host.baseUrl.value : HostDev.baseUrl.value;
    final endPoint = apiInfo.value;
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
          if(resultCode == 'CF-00000' || resultCode == 'CF-03002'){
            final resultData = json['data'];
            if (resultData is Map<String, dynamic>) {
              resultData['result_code'] = resultCode;
              if(resultCode == 'CF-03002') {
                callback(true, true, resultData, null);
              } else {
                callback(true, false, resultData, null);
              }
            } else if (resultData is List<dynamic>) {
              resultData[0]['result_code'] = resultCode;
              if(resultCode == 'CF-03002') {
                callback(true, true, null, resultData);
              } else {
                callback(true, false, null, resultData);
              }
            }
          } else {
            final Map<String, dynamic> resultData = {};
            resultData['result_code'] = resultCode;
            CommonUtils.log('e', 'out resultCode error : $resultCode');
            callback(false, false, resultData, null);
          }
        }
      } else {
        CommonUtils.log('e', 'http error code : ${response.statusCode}');
        callback(false, false, null, null);
      }
    } catch (e) {
      CommonUtils.log('e', e.toString());
      callback(false, false, null, null);
    }
  }

  /// ------------------------------------------------------------------------------------------------------------------------ ///
  static Future<void> callApisWithCert(BuildContext context, StateSetter setState,
      List<ApiInfoData> apiInfoDataList, Function(bool isSuccess, List<ApiInfoData>? resultApiInfoDataList) callback) async {
    int callCount = 0;
    bool isFirstCalledOnCert = false;
    for(var each in apiInfoDataList){
      if(each.isCallWithCert){
        if(!isFirstCalledOnCert){
          _callApiWithCert(context, setState, each.api, each.inputJson, (isSuccess, resultMap, resultListMap) {
            if(isSuccess){
              each.isResultSuccess = true;
              if(resultMap != null){
                each.resultMap = resultMap;
              }else{
                each.resultListMap = resultListMap;
              }

              callCount++;
              if(callCount == apiInfoDataList.length){
                callback(true, apiInfoDataList);
              }
            }else{
              Navigator.of(context).pop();
              if(resultMap != null){
                switch(resultMap["result_code"]){
                  case "CF-01004" : CommonUtils.flutterToast("입력시간이 초과되었습니다.");
                  default : CommonUtils.flutterToast("에러가 발생했습니다.");
                }
                callback(false, null);
              }else{
                CommonUtils.flutterToast("에러가 발생했습니다.");
                callback(false, null);
              }
            }
          });
          await Future.delayed(const Duration(milliseconds: 500), () async {});
          isFirstCalledOnCert = true;
        }else{
          _callApiWithOutCert(context, each.api, each.inputJson, (isSuccess, resultMap, resultListMap){
            if(isSuccess){
              each.isResultSuccess = true;
              if(resultMap != null){
                each.resultMap = resultMap;
              }else{
                each.resultListMap = resultListMap;
              }

              callCount++;
              if(callCount == apiInfoDataList.length){
                callback(true, apiInfoDataList);
              }
            }else{
              Navigator.of(context).pop();
              if(resultMap != null){
                switch(resultMap["result_code"]){
                  case "CF-01004" : CommonUtils.flutterToast("입력시간이 초과되었습니다.");
                  default : CommonUtils.flutterToast("에러가 발생했습니다.");
                }

                callback(false, null);
              }else{
                CommonUtils.flutterToast("에러가 발생했습니다.");
                callback(false, null);
              }
            }
          });
        }
      }
    }
  }

  static Future<void> callApisWithOutCert(BuildContext context, StateSetter setState,
      List<ApiInfoData> apiInfoDataList, Function(bool isSuccess, List<ApiInfoData>? resultApiInfoDataList) callback) async {
    int callCount = 0;
    for(var each in apiInfoDataList){
      if(!each.isCallWithCert){
        _callApiWithOutCert(context, each.api, each.inputJson, (isSuccess, resultMap, resultListMap){
          if(isSuccess){
            each.isResultSuccess = true;
            if(resultMap != null){
              each.resultMap = resultMap;
            }else{
              each.resultListMap = resultListMap;
            }

            callCount++;
            if(callCount == apiInfoDataList.length){
              callback(true, apiInfoDataList);
            }
          }else{
            Navigator.of(context).pop();
            if(resultMap != null){
              switch(resultMap["result_code"]){
                case "CF-01004" : CommonUtils.flutterToast("입력시간이 초과되었습니다.");
                default : CommonUtils.flutterToast("에러가 발생했습니다.");
              }

              callback(false, null);
            }else{
              CommonUtils.flutterToast("에러가 발생했습니다.");
              callback(false, null);
            }
          }
        });
      }
    }
  }

  static Future<void> _callApiWithOutCert(BuildContext context, Apis api, Map<String, dynamic> inputJson,
      Function(bool isSuccess, Map<String,dynamic>? resultMap, List<dynamic>? resultListMap) callback) async {
    CommonUtils.log('i', 'normal call start');
    CodeFController._getDataFromApi(api, inputJson, (isSuccess, _, map, listMap) {
      if(isSuccess){
        if(map != null){
          callback(true, map, null);
        }else{
          callback(true, null, listMap);
        }
      }else{
        CommonUtils.log('e', 'normal call api result error');
        callback(false, map, null);
      }
    });
  }

  static Future<void> _callApiWithCert(BuildContext context, StateSetter setState, Apis representApi, Map<String, dynamic> inputJson,
      Function(bool isSuccess, Map<String,dynamic>? resultMap, List<dynamic>? resultListMap) callback) async {
    CommonUtils.log('i', '[1] call start');
    await CodeFController._getDataFromApi(representApi, inputJson, (isSuccess, is2WayProcess, map, _) async {
      if(isSuccess){
        if(map != null){
          if(is2WayProcess){
            Map<String, dynamic>? resultMap = _set2WayMap(inputJson, map);
            CommonUtils.log('i', '[1] call api result with 2way : ${resultMap.toString()}');
            if(resultMap != null){
              setState(() {
                _setAuthPop(context, representApi, resultMap,(isResultSuccess, map, listMap) async {
                  if(isResultSuccess){
                    if(map != null){
                      callback(true, map, null);
                    }else{
                      callback(true, null, listMap);
                    }
                  }else{
                    callback(false, null, null);
                  }
                });
              });
            }else{
              callback(false, null, null);
            }
          }
        }
      }else{
        CommonUtils.log('e', '[1] call api result with 2way error');
        callback(false, map, null);
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

  static Future<void> _setAuthPop(BuildContext context, Apis apiInfo, Map<String, dynamic> resultInputMap,
      Function(bool isSuccess, Map<String,dynamic>? resultMap, List<dynamic>? resultListMap) callback) async {
    UiUtils.showSlideMenu(context, SlideType.toTop, false, 0.0, (context, setState){
      return Obx(()=>
          Column(mainAxisAlignment: MainAxisAlignment.center, children:
          [ GetController.to.isWait.value ? UiUtils.getTextWithFixedScale("정보를 가져오는 중입니다...", TextStyles.basicTextStyle, TextAlign.center, null) : UiUtils.getTextWithFixedScale("", TextStyles.basicTextStyle, TextAlign.center, null),
            !GetController.to.isWait.value ?
            UiUtils.getTextButtonBox(60.w, "인증 확인", TextStyles.slidePopButtonText, ColorStyles.finAppGreen, () async {
              GetController.to.updateWait(true);
              CodeFController._getDataFromApi(apiInfo, resultInputMap, (isSuccess, _, map, listMap){
                GetController.to.updateWait(false);
                if(isSuccess){
                  if(map != null){
                    if(map['result_code'] == "CF-03002"){
                      CommonUtils.flutterToast("인증을 진행 해 주세요.");
                    }else{
                      Navigator.of(context).pop();
                      callback(true, map, null);
                    }
                  }else{
                    if(listMap?[0]['result_code'] == "CF-03002"){
                      CommonUtils.flutterToast("인증을 진행 해 주세요.");
                    }else{
                      Navigator.of(context).pop();
                      callback(true, null, listMap);
                    }
                  }
                }else{
                  Navigator.of(context).pop();
                  callback(false, null, null);
                }
              });
            }) : Container()])
      );
    });
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
  residentRegistrationAbstract, residentRegistrationCopy
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
      case Apis.residentRegistrationAbstract:
        return '/v1/kr/public/mw/resident-registration-abstract/issuance';
      case Apis.residentRegistrationCopy:
        return '/v1/kr/public/mw/resident-registration-copy/issuance';
      default:
        throw Exception('Unknown host value');
    }
  }
}
/// ------------------------------------------------------------------------------------------------------------------------ ///