import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwebchat/configs/app_config.dart';
import 'package:flutterwebchat/styles/ColorStyles.dart';
import 'package:flutterwebchat/styles/TextStyles.dart';
import 'package:flutterwebchat/utils/ui_utils.dart';
import 'package:sizer/sizer.dart';
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
        if(result['error_code'] == "F0000"){
          Navigator.pop(parentViewContext);
        }else{
          Navigator.pushReplacementNamed(
            parentViewContext,
            AppView.certificationResultView.value,
            arguments: result,
          );
        }
      },
    );
  }

  static Widget getCertificationResultView(BuildContext parentViewContext, bool isSuccess){
    String text = "인증 완료 되었습니다.";
    Color buttonColor = ColorStyles.finAppGreen;

    if(!isSuccess){
      text = "인증 실패 하였습니다.";
      buttonColor = Colors.redAccent;
    }

    return Container(color: ColorStyles.finAppWhite, width : 100.w, height: 100.h, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      UiUtils.getTextWithFixedScale(text, TextStyles.basicTextStyle, TextAlign.center, null),
      UiUtils.getMarginBox(0, 2.h),
      UiUtils.getTextButtonBox(80.w, "확인", TextStyles.buttonTextStyle, buttonColor, () {
        Navigator.pop(parentViewContext);
      })
    ]));
  }

}