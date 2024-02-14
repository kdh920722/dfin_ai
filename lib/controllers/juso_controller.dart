import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import '../configs/app_config.dart';
import '../utils/common_utils.dart';

class JusoController{

  static final JusoController _instance = JusoController._internal();
  factory JusoController() => _instance;
  JusoController._internal();

  static String jusoUrl = "";
  static String confirmKey = "";

  static Future<void> initJuso(Function(bool) callback) async{
    try{
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('DFIN/API/juso').get();
      if (snapshot.exists) {
        for(var each in snapshot.children){
          switch(each.key){
            case "url" : jusoUrl = each.value.toString();
            case "key" : confirmKey = each.value.toString();
          }
        }
        callback(true);
      } else {
        callback(false);
      }
    }catch(e){
      CommonUtils.log("e", "juso get error : ${e.toString()}");
      callback(false);
    }
  }

  static Future<void> getAddressFromJuso(String searchAddress, Function(bool isSuccess, List<dynamic>? outputJsonList) callback) async {
     var targetUrl = "";
    if(Config.isWeb){
      targetUrl = 'https://corsproxy.io/?${Uri.encodeComponent(jusoUrl)}';
    }else{
      targetUrl = jusoUrl;
    }

    try {
      String params = "$targetUrl?currentPage=1&countPerPage=10&resultType=json&confmKey=$confirmKey&keyword=$searchAddress";
      final url = Uri.parse(params);
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );

      final json = jsonDecode(response.body);
      CommonUtils.log('i', 'out full : \n$json');
      if (response.statusCode == 200) { // HTTP_OK
        if(json["results"]["common"]["errorMessage"] == "정상"){
          callback(true, json["results"]["juso"]);
        }else{
          CommonUtils.log('e', 'error code : ${json["results"]["common"]["errorMessage"]}');
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
