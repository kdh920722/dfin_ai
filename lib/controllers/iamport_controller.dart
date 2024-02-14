import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dfin/styles/ColorStyles.dart';
import 'package:dfin/utils/ui_utils.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import 'package:iamport_flutter/iamport_certification.dart';
import 'package:iamport_flutter/model/certification_data.dart';
import 'package:http/http.dart' as http;

class IamportController {
  static final IamportController _instance = IamportController._internal();
  factory IamportController() => _instance;
  IamportController._internal();

  static String iamportUserCode = "";
  static String iamportApiKey = "";
  static String iamportApiSecret = "";
  static List<String> carrierList = [];

  static Future<void> initIamport(Function(bool) callback) async{
    try{
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('UPFIN/API/iamport').get();
      if (snapshot.exists) {
        for (var each in snapshot.children) {
          switch (each.key) {
            case "api_key" : iamportApiKey = each.value.toString();
            case "api_secret" : iamportApiSecret = each.value.toString();
            case "user_code" : iamportUserCode = each.value.toString();
          }
        }

        final snapshotForCarrier = await ref.child('UPFIN/API/iamport/tel_carrier_list').get();
        if (snapshotForCarrier.exists) {
          List<String> tempList = [];
          for (var each in snapshotForCarrier.children) {
            tempList.add(each.value.toString());
          }
          tempList.sort((a,b)=>int.parse(a.split("@")[1]).compareTo(int.parse(b.split("@")[1])));
          carrierList.addAll(tempList);

          CommonUtils.log("i", "iamport carrier list : $carrierList");
          callback(true);
        }else{
          callback(false);
        }
      } else {
        callback(false);
      }
    }catch(e){
      CommonUtils.log("e", "iamport init error : ${e.toString()}");
      callback(false);
    }
  }

  static Future<void> _callDetailedInfo(String impUid, Function(bool isSuccess, Map<String, dynamic>? outputJson) callback) async {
    var urlForGetToken = "https://api.iamport.kr/users/getToken";
    if(Config.isWeb){
      urlForGetToken = 'https://corsproxy.io/?${Uri.encodeComponent(urlForGetToken)}';
    }

    var urlForGetDetailedInfo = "https://api.iamport.kr/certifications/$impUid";
    if(Config.isWeb){
      urlForGetToken = 'https://corsproxy.io/?${Uri.encodeComponent(urlForGetToken)}';
    }

    try {
      Map<String, dynamic> inputJsonForToken = {
        "imp_key": iamportApiKey,
        "imp_secret": iamportApiSecret
      };
      final responseForToken = await http.post(
        Uri.parse(urlForGetToken),
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode(inputJsonForToken),
      );
      final jsonForToken = jsonDecode(responseForToken.body);
      CommonUtils.log('i', 'out full : \n$jsonForToken');

      if (responseForToken.statusCode == 200) { // HTTP_OK
        String accessToken = jsonForToken["response"]["access_token"];

        final responseForDetailedInfo = await http.get(
          Uri.parse(urlForGetDetailedInfo),
          headers: {
            "Content-Type": "application/json",
            "Authorization": accessToken
          },
        );
        final jsonForDetailedInfo = jsonDecode(responseForDetailedInfo.body);
        CommonUtils.log('i', 'out full : \n$jsonForDetailedInfo');
        if (responseForDetailedInfo.statusCode == 200){
          String name = jsonForDetailedInfo["response"]["name"];
          String birthday = jsonForDetailedInfo["response"]["birthday"];
          String gender = jsonForDetailedInfo["response"]["gender"];
          String phone = jsonForDetailedInfo["response"]["phone"];
          String carrier = jsonForDetailedInfo["response"]["carrier"];

          Map<String, dynamic> output = {
            "isSuccess": true,
            "name": name,
            "birth": birthday,
            "gender": gender,
            "phone": phone,
            "carrier": carrier,
          };
          callback(true, output);
        }else{
          CommonUtils.log('e', 'http error code : ${responseForDetailedInfo.statusCode}');
          callback(false, null);
        }
      } else {
        CommonUtils.log('e', 'http error code : ${responseForToken.statusCode}');
        callback(false, null);
      }
    } catch (e) {
      CommonUtils.log('e', e.toString());
      callback(false, null);
    }
  }

  static bool isCertificationResultSuccess(Map<String, String> result) {
    if (result['success'] == 'true') {
      return true;
    }
    return false;
  }

  static Widget getCertificationWebView(BuildContext parentViewContext, Map<String, dynamic> inputJson){
    String carrier = inputJson['carrier'];
    String name = inputJson['name'];
    String phone = inputJson['phone'];
    CommonUtils.log("i", "\ncarrier : $carrier\nname : $name\nphone : $phone");

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(width: 67.w, child: UiUtils.getTextWithFixedScale("휴대폰 본인인증", 14.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.center, null)),
        backgroundColor: ColorStyles.upFinWhite,
        leading: UiUtils.getBackButton(() {
          Navigator.pop(parentViewContext);
        })
      ),
      body: IamportCertification(
        /* 웹뷰 로딩 컴포넌트 */
        initialChild: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/iamport_logo.png'),
              const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              const Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
        userCode: iamportUserCode,
        data: CertificationData(
          merchantUid: 'mid_${DateTime.now().millisecondsSinceEpoch}',
          pg: "danal",
          company: 'ysmeta',
          carrier: carrier,
          name: name,
          phone: phone,
        ),
        callback: (Map<String, String> result) {
          CommonUtils.log('i', 'result : ${result.toString()}');
          bool isSuccess = IamportController.isCertificationResultSuccess(result);
          if(isSuccess){
            _callDetailedInfo(result["imp_uid"]!, (isSuccessToGetDetailedInfo, outputJson){
              CommonUtils.log('i', 'cert detailed result : $outputJson');
              if(isSuccessToGetDetailedInfo){
                Navigator.pop(parentViewContext, outputJson);
              }else{
                Navigator.pop(parentViewContext, null);
              }
            });
          }else{
            Navigator.pop(parentViewContext, null);
          }
        },
      ),
    );
  }
}