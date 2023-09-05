import 'dart:async';
import 'package:upfin/configs/text_config.dart';
import 'package:upfin/controllers/aws_controller.dart';
import 'package:upfin/controllers/clova_controller.dart';
import 'package:upfin/controllers/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:upfin/controllers/iamport_controller.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/controllers/sharedpreference_controller.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/controllers/gpt_controller.dart';
import 'package:upfin/controllers/firebase_controller.dart';
import 'package:upfin/controllers/sns_login_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:uni_links/uni_links.dart';
import '../controllers/codef_controller.dart';
import '../styles/TextStyles.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppLoginView extends StatefulWidget{
  @override
  AppLoginViewState createState() => AppLoginViewState();
}

class AppLoginViewState extends State<AppLoginView> with WidgetsBindingObserver{

  Future<void> _initFirebase() async {
    // init
    await FireBaseController.initFcm((bool isSuccess, String fcmToken){
      if(isSuccess){
        CommonUtils.log("i", "firebase credential : ${FireBaseController.userCredential.toString()}");
      }else{
        CommonUtils.flutterToast("firebase init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initGPT() async {
    // init
    await GptController.initGPT((bool isSuccess){
      if(isSuccess){
        CommonUtils.log("i", "gpt key : ${GptController.gptApiKey}");
      }else{
        CommonUtils.flutterToast("gpt init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initCodeF() async {
    // set host : prod or dev
    CodeFController.setHostStatus(HostStatus.prod);

    // init
    await CodeFController.initAccessToken((bool isSuccess){
      if(isSuccess){
        CommonUtils.log("i", "codef token : ${CodeFController.token}");
      }else{
        CommonUtils.flutterToast("codef init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initCLOVA() async {
    // init
    await CLOVAController.initCLOVA((bool isSuccess){
      if(isSuccess){
        CommonUtils.log("i", "clova url : ${CLOVAController.apiURL}\nclova secretKey : ${CLOVAController.secretKey}");
      }else{
        CommonUtils.flutterToast("clova init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initAWS() async {
    // init
    await AwsController.initAWS((bool isSuccess){
      if(isSuccess){
        CommonUtils.log("i", "aws keys : ${AwsController.awsAccessKey}\naws secretKey : ${AwsController.awsSecretKey}");
      }else{
        CommonUtils.flutterToast("aws init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initLogfin() async {
    // init
    await LogfinController.initLogfin((bool isSuccess){
      if(isSuccess){
        CommonUtils.log("i", "logfin url : ${LogfinController.url}\naws headerKey : ${LogfinController.headerKey}");
      }else{
        CommonUtils.flutterToast("logfin init 에러가 발생했습니다.");
      }
    });
  }

  Future<String?> _initDeepLink() async {
    try{
      final initialLink = await getInitialLink();
      return initialLink;
    }catch(e){
      CommonUtils.log("e", "init deep link error : ${e.toString()}");
      return null;
    }
  }

  Future<void> _initIamport() async {
    // init
    await IamportController.initIamport((bool isSuccess){
      if(isSuccess){
        CommonUtils.log("i", "iamport user_code : ${IamportController.iamportUserCode}");
      }else{
        CommonUtils.flutterToast("iamport init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initKakao() async {
    // init
    await SnsLoginController.initKakao((bool isSuccess){
      if(isSuccess){
        CommonUtils.log("i", "kakao key : ${SnsLoginController.kakaoKey}");
      }else{
        CommonUtils.flutterToast("iamport init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initSharedPreference() async {
    // init
    await SharedPreferenceController.initSharedPreference((bool isSuccess){
      if(!isSuccess){
        CommonUtils.flutterToast("sharedPreference init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _requestPermissions() async {
    await CommonUtils.requestPermissions((isDenied, deniedPermissionsList){
      if(isDenied){
        String deniedPermissionsString = "";
        for(int i = 0; i < deniedPermissionsList!.length; i++){
          deniedPermissionsString += deniedPermissionsList[i];
          if(i != deniedPermissionsList.length-1){
            deniedPermissionsString += ", ";
          }
        }

        UiUtils.showSlideMenu(context, SlideType.toTop, true, 0.5, (context, setState) =>
            Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UiUtils.getStyledTextWithFixedScale("[$deniedPermissionsString] 권한이 필요합니다. ", TextStyles.slidePopPermissionText, TextAlign.center, null),
                  UiUtils.getMarginBox(100.w, 2.h),
                  UiUtils.getTextButtonBox(70.w, "설정 바로가기", TextStyles.slidePopButtonText, ColorStyles.finAppGreen, () {
                    openAppSettings();
                    Navigator.of(context).pop();
                  })
                ]
            ));
        CommonUtils.log("i", "denied permissions : $deniedPermissionsString");
      }
    });
  }

  Future<void> _initAtFirst() async {
    Config.isAppMainInit = true;
    Get.put(GetController());
    await _initSharedPreference();
    await _initFirebase();
    await _initGPT();
    await _initCodeF();
    await _initCLOVA();
    await _initAWS();
    await _initLogfin();
    await _initIamport();
    await _initKakao();
    await _initDeepLink().then((value){
      if(value != null){
        Config.deppLinkInfo = value;
        String paramValue = CommonUtils.getValueFromDeepLink(Config.deppLinkInfo, "param1");
        CommonUtils.log("i", "init deep link paramValue : $paramValue");
      }else{
        Config.deppLinkInfo = "";
      }
    });
    await _requestPermissions();
    Config.isControllerLoadFinished = true;
    setState(() {});
  }

  @override
  void initState(){
    CommonUtils.log("i", "새 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose(){
    CommonUtils.log("i", "새 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('i','SelectView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('i','SelectView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('i','SelectView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('i','SelectView paused');
        break;
      default:
        break;
    }
  }
  
  static Future<bool> isMember() async {
    try{
      bool isMember = false;
      String token = "";
      String id = "";
      if(SnsLoginController.loginPlatform == LoginPlatform.kakao){
        token = SnsLoginController.kakaoToken;
        id = SnsLoginController.kakaoId;
      }else{

      }

      Map<String, String> inputJson = {
        "email": MyData.email,
        "token": token,
        "user_id": id,
        "provider": SnsLoginController.loginPlatform.value
      };

      await LogfinController.callLogfinApi(LogfinApis.socialLogin, inputJson, (isSuccess, outputJson) {
        isMember = isSuccess;
        MyData.confirmed = isMember;
      });

      return isMember;
    }catch(error){
      return false;
    }

  } 

  @override
  Widget build(BuildContext context) {
    Widget? view;
    if(!Config.isAppMainInit){
      _initAtFirst();
      view = UiUtils.getInitLoadingView();
    }else{
      if(!Config.isControllerLoadFinished){
        view = UiUtils.getInitLoadingView();
      }else{
        view = Container(color: ColorStyles.upFinWhite, width: 100.w, height: 100.h, padding: const EdgeInsets.all(20.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              UiUtils.getMarginBox(0, 15.h),
              UiUtils.getBorderTextWithFixedScale("업핀", 55.sp, FontWeight.w800, TextAlign.center, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinTextAndBorderBlue),
              UiUtils.getTextWithFixedScale("나에게 꼭 맞는\n개인회생 대출상품", 28.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null),
              Row(children: [
                UiUtils.getBoxTextWithFixedScale("ASAP", 28.sp, FontWeight.w500, TextAlign.center, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinWhite),
                UiUtils.getMarginBox(1.w, 0),
                UiUtils.getTextWithFixedScale("접수하세요!", 28.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null),
              ]),
              UiUtils.getMarginBox(0, 15.h),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  UiUtils.getTextButtonBox(80.w, "카카오 로그인", TextStyles.upFinKakaoButtonTextStyle, ColorStyles.upFinKakaoYellow, () async {
                    UiUtils.showLoadingPop(context);
                    await SnsLoginController.kakaoLogin((bool isSuccess) async {
                      UiUtils.closeLoadingPop(context);
                      if(isSuccess){
                        if(await isMember()){

                        }else{
                          if(context.mounted){
                            CommonUtils.moveWithReplacementTo(context, AppView.signupView.value, null);
                          }
                        }
                      }else{
                        CommonUtils.flutterToast("${SnsLoginController.loginPlatform.value}로그인에 실패했습니다.");
                      }
                    });

                  })
                ])
              ]),
              UiUtils.getMarginBox(0, 0.5.h),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  UiUtils.getTextButtonBox(80.w, "애플 로그인", TextStyles.upFinAppleButtonTextStyle, ColorStyles.upFinBlack, () async {

                  })
                ])
              ]),
              UiUtils.getMarginBox(0, 5.h),
              UiUtils.getExpandedScrollView(Axis.vertical, UiUtils.getTextWithFixedScale(TextConfig.appStartViewIntroText, 10.sp, FontWeight.w300, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null))
            ])
        );
      }
    }

    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}