import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';

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


}