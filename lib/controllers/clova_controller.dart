import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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
      final snapshot = await ref.child('WEBCHAT/API/clova/url').get();
      if (snapshot.exists) {
        apiURL =  snapshot.value.toString();
        await _getKeyForCLOVA((bool isSuccess){
          if(isSuccess){
            callback(true);
          }else{
            callback(false);
          }
        });
      } else {
        callback(false);
      }
    }catch(e){
      CommonUtils.log("e", "clova get url error : ${e.toString()}");
      callback(false);
    }
  }

  static Future<void> _getKeyForCLOVA(Function(bool) callback) async{
    try{
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('WEBCHAT/API/clova/secret_key').get();
      if (snapshot.exists) {
        secretKey =  snapshot.value.toString();
        callback(true);
      } else {
        callback(false);
      }
    }catch(e){
      CommonUtils.log("e", "clova get key error : ${e.toString()}");
      callback(false);
    }
  }

  static Future<void> uploadImageToCLOVA(XFile targetImage, Function(bool) callback) async {
    var targetUrl = "";
    if(Config.isWeb){
      targetUrl = 'https://corsproxy.io/?${Uri.encodeComponent(apiURL)}';
    }else{
      targetUrl = apiURL;
    }

    try {
      File fileImage = File(targetImage.path);
      final bytes = File(fileImage.path).readAsBytesSync();
      String base64Image = base64Encode(bytes);

      Map<String, dynamic> inputJson = {
        "version": "V2",
        "requestId": CommonUtils.getRandomKey(),
        "timestamp": 0,
        "images": [
          {
            "format": "jpg",
            "name": "CLOVA_CHECK_${targetImage.name}",
            "data": base64Image
          }
        ]
      };

      final url = Uri.parse(targetUrl);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "X-OCR-SECRET": secretKey,
        },
        body: jsonEncode(inputJson),
      );
      final decodedResponseBody = Uri.decodeFull(response.body);
      final json = jsonDecode(decodedResponseBody);
      CommonUtils.log('i', 'out full : \n$json');

      if (response.statusCode == 200) { // HTTP_OK
        final resultData = json['images'][0];
        if(resultData['inferResult'] == "SUCCESS"){
          callback(true);
        }else{
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
}