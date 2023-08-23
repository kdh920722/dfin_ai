import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwebchat/configs/app_config.dart';
import '../utils/common_utils.dart';
import 'package:iamport_flutter/iamport_certification.dart';
import 'package:iamport_flutter/model/certification_data.dart';

class IamportController {
  static final IamportController _instance = IamportController._internal();
  factory IamportController() => _instance;
  IamportController._internal();

  static final telTypeList = ['SKT', 'KT', 'LGU+', 'MVNO'];
  static String iamportUserCode = "";

  static Future<void> initIamport(Function(bool) callback) async{
    try{
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('WEBCHAT/API/iamport/user_code').get();
      if (snapshot.exists) {
        iamportUserCode =  snapshot.value.toString();
        callback(true);
      } else {
        callback(false);
      }
    }catch(e){
      CommonUtils.log("e", "iamport init error : ${e.toString()}");
      callback(false);
    }
  }

  static bool isCertificationResultSuccess(Map<String, String> result) {
    if (result['imp_success'] == 'true') {
      return true;
    }
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

    return IamportCertification(
      appBar: AppBar(title: const Text('휴대폰 본인인증')),
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
        popup: false,
        mRedirectUrl: "ysmeta://deeplink.upcross.ai"
      ),
      callback: (Map<String, String> result) {
        CommonUtils.log('i', 'result : ${result.toString()}');
        Navigator.pushReplacementNamed(
          parentViewContext,
          AppView.rootView.value,
          arguments: result,
        );
      },
    );
  }

}