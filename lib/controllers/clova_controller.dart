import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
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

  static Future<void> uploadImageToCLOVA(String imagePath, Function(bool) callback) async {
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

      CommonUtils.log('i', 'input file info start ===========================>');
      CommonUtils.log('i', 'input file path : $imagePath');
      CommonUtils.log('i', 'input file base62image : $base64Image\n\n');
      CommonUtils.log('i', 'input file inputJson : $inputJson\n\n');
      await CommonUtils.printFileSize(File(imagePath));
      CommonUtils.log('i', 'input file info end ===========================>');

      final url = Uri.parse(targetUrl);
      final reqBody = jsonEncode(inputJson);
      CommonUtils.isValidEncoded(reqBody);
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