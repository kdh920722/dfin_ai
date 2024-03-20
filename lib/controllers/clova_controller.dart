import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import 'package:image/image.dart' as imglib;

import '../views/app_apply_pr_view.dart';
import 'logfin_controller.dart';

class CLOVAController{
  static final CLOVAController _instance = CLOVAController._internal();
  factory CLOVAController() => _instance;
  CLOVAController._internal();

  static String apiURL = "";
  static String secretKey = "";

  static Future<void> initCLOVA(Function(bool) callback) async{
    try{
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('DFIN/API/clova').get();
      if (snapshot.exists) {
        for(var each in snapshot.children){
          switch(each.key){
            case "url" : apiURL = each.value.toString();
            case "secret_key" : secretKey = each.value.toString();
          }
        }
        callback(true);
      } else {
        callback(false);
      }
    }catch(e){
      CommonUtils.log("e", "DFIN get url error : ${e.toString()}");
      callback(false);
    }
  }

  static Future<void> uploadImageToCLOVA(String imagePath, Function(bool, Map<String, dynamic>? outputJson) callback) async {
    var targetUrl = "";

    if(Config.isWeb){
      targetUrl = 'https://corsproxy.io/?${Uri.encodeComponent(apiURL)}';
    }else{
      targetUrl = apiURL;
    }

    try {
      String fileName = imagePath.split('/').last;
      final bytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(bytes);
      Map<String, dynamic> inputJson = {
        "version": "V2",
        "requestId": CommonUtils.getRandomKey(),
        "timestamp": 0,
        "images": [
          {
            "format": "jpg",
            "data":  base64Image,
            "name": "CLOVA_CHECK_$fileName",
          }
        ]
      };

      final url = Uri.parse(targetUrl);
      final reqBody = jsonEncode(inputJson);
      final response = await http.post(
        url,
        headers: {
          "X-OCR-SECRET": secretKey,
          "Content-Type": "application/json"
        },
        body: reqBody,
      ).timeout(const Duration(seconds: 120));

      final json = jsonDecode(response.body);
      CommonUtils.log('i', 'out full : \n$json');

      if (response.statusCode == 200) { // HTTP_OK
        final resultData = json['images'][0];
        if(resultData['inferResult'] == "SUCCESS"){
          Map<String, dynamic> map = resultData['idCard']['result'];
          if(map.containsKey("dl")){
            final resultMap = resultData['idCard']['result']['dl'];
            resultMap["id_type"] = "dl";
            resultMap["rois_map"] = resultData['idCard']['result']['rois'];
            callback(true, resultMap);
          }else if(map.containsKey("ic")){
            final resultMap = resultData['idCard']['result']['ic'];
            resultMap["id_type"] = "ic";
            resultMap["rois_map"] = resultData['idCard']['result']['rois'];
            callback(true, resultMap);
          }else{
            callback(false, null);
          }
        }else{
          callback(false, null);
        }
      } else {
        CommonUtils.log('e', 'http error code : ${response.statusCode}');
        callback(false, null);
      }
    } catch (e) {
      CommonUtils.log('e', e.toString());
      callback(false, null);
    }
  }

  static bool checkValidInfo(Map<String, dynamic> maskingInfoMap){
    bool isValid = true;
    String name = maskingInfoMap['name'][0]["formatted"]["value"].toString();
    String personalNum = maskingInfoMap['personalNum'][0]["formatted"]["value"].toString().replaceAll("-", "");

    if(maskingInfoMap['id_type'] == "dl"){
      if(name != "" && personalNum != ""){
        bool isNameValid = true;
        for (int i = 0; i < name.length; i++) {
          int codeUnit = name.codeUnitAt(i);
          if (codeUnit < 44032 || codeUnit > 55203) {
            isNameValid = false;
          }
        }
        if(!isNameValid){
          isValid = false;
          LogfinController.setLogJson(AppApplyPrViewState.isRetry? LogfinController.applyDocCertCodeString : LogfinController.applyCertCodeString, {"input" : ""},
              {"masking_info_error" : {"name_error" : maskingInfoMap}});
        }

        bool isPersonalNumValid = true;
        for (int i = 0; i < personalNum.length; i++) {
          if (personalNum.codeUnitAt(i) < 48 || personalNum.codeUnitAt(i) > 57) {
            isPersonalNumValid = false;
          }
        }
        if(!isPersonalNumValid){
          isValid = false;
          LogfinController.setLogJson(AppApplyPrViewState.isRetry? LogfinController.applyDocCertCodeString : LogfinController.applyCertCodeString, {"input" : ""},
              {"masking_info_error" : {"personalNum_error" : maskingInfoMap}});
        }
      }else{
        isValid = false;
        LogfinController.setLogJson(AppApplyPrViewState.isRetry? LogfinController.applyDocCertCodeString : LogfinController.applyCertCodeString, {"input" : ""},
            {"masking_info_error" : {"empty_error" : maskingInfoMap}});
      }
    }else{
      String issueDate = maskingInfoMap['issueDate'][0]["formatted"]["year"].toString() + maskingInfoMap['issueDate'][0]["formatted"]["month"].toString() + maskingInfoMap['issueDate'][0]["formatted"]["day"].toString();
      if(name != "" && personalNum != "" && issueDate != ""){
        bool isNameValid = true;
        for (int i = 0; i < name.length; i++) {
          int codeUnit = name.codeUnitAt(i);
          if (codeUnit < 44032 || codeUnit > 55203) {
            isNameValid = false;
          }
        }
        if(!isNameValid){
          isValid = false;
          LogfinController.setLogJson(AppApplyPrViewState.isRetry? LogfinController.applyDocCertCodeString : LogfinController.applyCertCodeString, {"input" : ""},
              {"masking_info_error" : {"name_error" : maskingInfoMap}});
        }

        bool isPersonalNumValid = true;
        for (int i = 0; i < personalNum.length; i++) {
          if (personalNum.codeUnitAt(i) < 48 || personalNum.codeUnitAt(i) > 57) {
            isPersonalNumValid = false;
          }
        }
        if(!isPersonalNumValid){
          isValid = false;
          LogfinController.setLogJson(AppApplyPrViewState.isRetry? LogfinController.applyDocCertCodeString : LogfinController.applyCertCodeString, {"input" : ""},
              {"masking_info_error" : {"personalNum_error" : maskingInfoMap}});
        }

        bool isIssueDateValid = true;
        for (int i = 0; i < issueDate.length; i++) {
          if (issueDate.codeUnitAt(i) < 48 || issueDate.codeUnitAt(i) > 57) {
            isIssueDateValid = false;
          }
        }
        if(!isIssueDateValid){
          isValid = false;
          LogfinController.setLogJson(AppApplyPrViewState.isRetry? LogfinController.applyDocCertCodeString : LogfinController.applyCertCodeString, {"input" : ""},
              {"masking_info_error" : {"issueDate_error" : maskingInfoMap}});
        }
      }else{
        isValid = false;
        LogfinController.setLogJson(AppApplyPrViewState.isRetry? LogfinController.applyDocCertCodeString : LogfinController.applyCertCodeString, {"input" : ""},
            {"masking_info_error" : {"empty_error" : maskingInfoMap}});
      }
    }

    return isValid;
  }

  static Future<String> makeMaskingImageAndGetPath(String imagePath, Map<String, dynamic> maskingInfoMap) async {
    try {
      final imglib.Image image = imglib.decodeImage(File(imagePath).readAsBytesSync())!;
      List<dynamic> listMap = maskingInfoMap['personalNum'][0]['maskingPolys'][0]['vertices'];
      List<int> xPoints = [];
      List<int> yPoints = [];
      for(Map<String,dynamic> each in listMap){
        var xPoint = each['x'].toString().split(".")[0];
        var yPoint = each['y'].toString().split(".")[0];
        xPoints.add(int.parse(xPoint));
        yPoints.add(int.parse(yPoint));
      }

      int minXValue = xPoints.reduce((min, current) => min < current ? min : current);
      int maxXValue = xPoints.reduce((max, current) => max > current ? max : current);
      int minYValue = yPoints.reduce((min, current) => min < current ? min : current);
      int maxYValue = yPoints.reduce((max, current) => max > current ? max : current);
      int maskingXSize = maxXValue - minXValue;
      int maskingYSize = maxYValue - minYValue;
      int startXPoint = minXValue;
      int startYPoint = minYValue;
      int endXPoint = maxXValue;
      int endYPoint = maxYValue;

      List<dynamic> listMapForBounding = maskingInfoMap['personalNum'][0]['boundingPolys'][0]['vertices'];
      List<int> xPointsForBounding = [];
      List<int> yPointsForBounding = [];
      for(Map<String,dynamic> each in listMapForBounding){
        var xPointForBounding = each['x'].toString().split(".")[0];
        var yPointForBounding = each['y'].toString().split(".")[0];
        xPointsForBounding.add(int.parse(xPointForBounding));
        yPointsForBounding.add(int.parse(yPointForBounding));
      }

      int minXValueForBounding = xPointsForBounding.reduce((min, current) => min < current ? min : current);
      int maxXValueForBounding = xPointsForBounding.reduce((max, current) => max > current ? max : current);
      int minYValueForBounding = yPointsForBounding.reduce((min, current) => min < current ? min : current);
      int maxYValueForBounding = yPointsForBounding.reduce((max, current) => max > current ? max : current);
      int maskingXSizeForBounding = maxXValueForBounding - minXValueForBounding;
      int maskingYSizeForBounding = maxYValueForBounding - minYValueForBounding;
      int startXPointForBounding = minXValueForBounding;
      int startYPointForBounding = minYValueForBounding;

      bool isError = false;
      if(maskingXSizeForBounding > maskingYSizeForBounding){
        //가로모드
        if(maskingXSizeForBounding*0.4 >= maskingXSize){
          isError = true;
        }

        if(maskingYSize*2.5 >= maskingXSize){
          isError = true;
        }
      }else{
        //세로모드
        if(maskingYSizeForBounding*0.4 >= maskingYSize){
          isError = true;
        }

        if(maskingXSize*2.5 >= maskingYSize){
          isError = true;
        }
      }

      CommonUtils.log("i", "Bounding image info ===========>\n"
          "maskingXSizeForBounding:$maskingXSizeForBounding maskingYSizeForBounding:$maskingYSizeForBounding\n"
          "startXPointForBounding:$startXPointForBounding startYPointForBounding: $startYPointForBounding");

      CommonUtils.log("i", "Masking image info ===========>\n"
          "maskingXSize:$maskingXSize maskingYSize:$maskingYSize\n"
          "startXPoint:$startXPoint startYPoint: $startYPoint");

      if(isError){
        CommonUtils.log('e', "masking size error");
        String maskingErrorInfoBounding = "Bounding image info ===========>\n"
            "maskingXSizeForBounding:$maskingXSizeForBounding maskingYSizeForBounding:$maskingYSizeForBounding\n"
            "startXPointForBounding:$startXPointForBounding startYPointForBounding: $startYPointForBounding";
        String maskingErrorInfo = "Masking image info ===========>\n"
            "maskingXSize:$maskingXSize maskingYSize:$maskingYSize\n"
            "startXPoint:$startXPoint startYPoint: $startYPoint";
        LogfinController.setLogJson(AppApplyPrViewState.isRetry? LogfinController.applyDocCertCodeString : LogfinController.applyCertCodeString, {"input" : imagePath},
            {"maskingErrorInfoBounding" : maskingErrorInfoBounding, "maskingErrorInfo" : maskingErrorInfo, "error_output" : maskingInfoMap});

        return "";
      }else{
        if(checkValidInfo(maskingInfoMap)){
          imglib.fillRect(image, x1: startXPoint, x2 : endXPoint, y1: startYPoint, y2 : endYPoint, color: imglib.ColorRgba8(0, 0, 0, 255));
          final modifiedImagePath = imagePath.replaceAll('.jpg', '_masked.jpg');
          File(modifiedImagePath).writeAsBytesSync(imglib.encodeJpg(image));
          return modifiedImagePath;
        }else{
          return "";
        }
      }


    } catch (e) {
      CommonUtils.log('e', e.toString());
      LogfinController.setLogJson(AppApplyPrViewState.isRetry? LogfinController.applyDocCertCodeString : LogfinController.applyCertCodeString, {"input" : imagePath}, {"error_output" : e.toString()});
      return "";
    }
  }

  static Future<String> makeCroppedImageAndGetPath(String imagePath, Map<String,dynamic> infoMap) async {
    try {
      final imglib.Image image = imglib.decodeImage(File(imagePath).readAsBytesSync())!;
      List<dynamic> listMap = infoMap['rois_map'][0]['vertices'];
      List<int> xPoints = [];
      List<int> yPoints = [];
      for(Map<String,dynamic> each in listMap){
        var xPoint = each['x'].toString().split(".")[0];
        var yPoint = each['y'].toString().split(".")[0];
        xPoints.add(int.parse(xPoint));
        yPoints.add(int.parse(yPoint));
      }

      int minXValue = xPoints.reduce((min, current) => min < current ? min : current);
      int maxXValue = xPoints.reduce((max, current) => max > current ? max : current);
      int minYValue = yPoints.reduce((min, current) => min < current ? min : current);
      int maxYValue = yPoints.reduce((max, current) => max > current ? max : current);
      int maskingXSize = maxXValue - minXValue;
      int maskingYSize = maxYValue - minYValue;
      int startXPoint = minXValue;
      int startYPoint = minYValue;

      final cropped = imglib.copyCrop(image, x: startXPoint, y: startYPoint, width: maskingXSize, height: maskingYSize);
      final modifiedImagePath = imagePath.replaceAll('.jpg', '_cropped.jpg');
      File(modifiedImagePath).writeAsBytesSync(imglib.encodeJpg(cropped));
      return modifiedImagePath;
    } catch (e) {
      CommonUtils.log('e', e.toString());
      return "";
    }
  }
}