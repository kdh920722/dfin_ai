import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
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

  static Future<void> uploadImage(XFile targetImage, Function(bool) callback) async {
    try {
      //final MultipartFile multipartFile =  MultipartFile.fromFileSync(targetImage.path, contentType: MediaType("image", "jpg"));
      //var formData = FormData.fromMap({'imageKey': multipartFile});
      var formData = FormData.fromMap({
        "version": "V2",
        "requestId": CommonUtils.getRandomKey(),
        "timestamp": 0,
        "images": [
          {
            "format": "jpg",
            "name": "CLOVA_CHECK_${targetImage.name}",
            'data': await MultipartFile.fromFile(targetImage.path)
          }
        ]

      });

      var dio = Dio();
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;
      dio.options.baseUrl = apiURL;
      dio.options.headers = {
        "Content-Type": "multipart/form-data",
        "X-OCR-SECRET": secretKey
      };
      final res = await dio.post(apiURL, data: formData);
      CommonUtils.log('i', 'out full : \n${res.toString()}');
      if (res.statusCode == 200) {
        callback(true);
      } else {
        callback(false);
      }
    } catch (e) {
      CommonUtils.log('e', e.toString());
      callback(false);
    }
  }

  static Future<void> uploadImageToCLOVA(String imagePath, Function(bool) callback) async {
    var targetUrl = apiURL;

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

      //final decodedResponseBody = Uri.decodeFull(response.body);
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

  static Future<void> uploadImageToCLOVA2(String imagePath, Function(bool) callback) async {
    try{
      final requestJson = {
        'images': [
          {
            'format': 'jpg',
            'name': 'demo',
          }
        ],
        'requestId': CommonUtils.getRandomKey(),
        'version': 'V2',
        'timestamp': 0,
      };
      final String fileName = imagePath.split('/').last;
      final payload = {'message': jsonEncode(requestJson)};
      final multipartFile = http.MultipartFile(
        'file',
        File(imagePath).readAsBytes().asStream(),
        File(imagePath).lengthSync(),
        filename: fileName,
      );

      final request = http.MultipartRequest('POST', Uri.parse(apiURL))
        ..headers.addAll({'X-OCR-SECRET': secretKey, "Content-Type" : "multipart/form-data"})
        ..fields.addAll(payload)
        ..files.add(multipartFile);

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      final decodedResponseBody = Uri.decodeFull(responseBody);
      final json = jsonDecode(decodedResponseBody);
      CommonUtils.log('i', 'out full : \n$json');
      callback(true);
    }catch(e){
      CommonUtils.log('e', e.toString());
      callback(false);
    }
  }


}