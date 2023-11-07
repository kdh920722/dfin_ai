import 'package:upfin/controllers/codef_controller.dart';

class ApiInfoData {
  int apiId;
  Map<String,dynamic> inputJson;
  Apis api;
  bool isCallWithCert;
  List<dynamic>? resultListMap;
  Map<String,dynamic>? resultMap;
  Map<String,dynamic>? resultFullMap;
  bool isResultSuccess = false;
  String? errorCode;

  ApiInfoData(this.apiId, this.inputJson, this.api, this.isCallWithCert);
}