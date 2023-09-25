import 'dart:async';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:upfin/controllers/aws_controller.dart';
import 'package:upfin/controllers/clova_controller.dart';
import 'package:upfin/controllers/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:upfin/controllers/hyphen_controller.dart';
import 'package:upfin/controllers/iamport_controller.dart';
import 'package:upfin/controllers/juso_controller.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/controllers/sharedpreference_controller.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/controllers/gpt_controller.dart';
import 'package:upfin/controllers/firebase_controller.dart';
import 'package:upfin/controllers/sns_login_controller.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:uni_links/uni_links.dart';
import '../controllers/codef_controller.dart';
import '../datas/my_data.dart';
import '../styles/TextStyles.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppRootView extends StatefulWidget{
  @override
  AppRootViewState createState() => AppRootViewState();
}

class AppRootViewState extends State<AppRootView> with WidgetsBindingObserver{

  @override
  void initState(){
    CommonUtils.log("i", "AppRootView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    MyData.resetMyData();
    _initDeepLinkHandling();
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppRootView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    GetController.to.resetPercent();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('i','AppRootView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('i','AppRootView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('i','AppRootView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('i','AppRootView paused');
        break;
      default:
        break;
    }
  }

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

  Future<void> _initAppState() async {
    // init
    await Config.initAppState((bool isSuccess){
      if(isSuccess){
        CommonUtils.log("i", "app state : ${Config.appState}");
      }else{
        CommonUtils.flutterToast("에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initGPT() async {
    // init
    await GptController.initGPT((bool isSuccess){
      if(isSuccess){
        GetController.to.updatePercent(10);
        CommonUtils.log("i", "gpt key : ${GptController.gptApiKey}");

        if(GetController.to.loadingPercent.value == 100){
          setState(() {
            Config.isControllerLoadFinished = true;
          });
        }
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
        GetController.to.updatePercent(20);
        CommonUtils.log("i", "codef token : ${CodeFController.token}");
        CommonUtils.log("i", "percent : ${GetController.to.loadingPercent.value}");
        if(GetController.to.loadingPercent.value == 100){
          setState(() {
            Config.isControllerLoadFinished = true;
          });
        }
      }else{
        CommonUtils.flutterToast("codef init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initJuso() async {
    // init
    await JusoController.initJuso((bool isSuccess){
      if(isSuccess){
        GetController.to.updatePercent(10);
        CommonUtils.log("i", "juso token : ${JusoController.confirmKey}");
        CommonUtils.log("i", "percent : ${GetController.to.loadingPercent.value}");
        if(GetController.to.loadingPercent.value == 100){
          setState(() {
            Config.isControllerLoadFinished = true;
          });
        }
      }else{
        CommonUtils.flutterToast("juso init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initCLOVA() async {
    // init
    await CLOVAController.initCLOVA((bool isSuccess){
      if(isSuccess){
        GetController.to.updatePercent(10);
        CommonUtils.log("i", "clova url : ${CLOVAController.apiURL}\nclova secretKey : ${CLOVAController.secretKey}");
        CommonUtils.log("i", "percent : ${GetController.to.loadingPercent.value}");
        if(GetController.to.loadingPercent.value == 100){
          setState(() {
            Config.isControllerLoadFinished = true;
          });
        }
      }else{
        CommonUtils.flutterToast("clova init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initAWS() async {
    // init
    await AwsController.initAWS((bool isSuccess){
      if(isSuccess){
        GetController.to.updatePercent(10);
        CommonUtils.log("i", "aws keys : ${AwsController.awsAccessKey}\naws secretKey : ${AwsController.awsSecretKey}");
        CommonUtils.log("i", "percent : ${GetController.to.loadingPercent.value}");
        if(GetController.to.loadingPercent.value == 100){
          setState(() {
            Config.isControllerLoadFinished = true;
          });
        }
      }else{
        CommonUtils.flutterToast("aws init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initLogfin() async {
    // init
    await LogfinController.initLogfin((bool isSuccess){
      if(isSuccess){
        GetController.to.updatePercent(10);
        CommonUtils.log("i", "logfin url : ${LogfinController.url}");
        CommonUtils.log("i", "percent : ${GetController.to.loadingPercent.value}");

        DateTime thirtyMinutesLater = CommonUtils.getCurrentLocalTime().add(const Duration(minutes: 30));
        SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceValidDateKey, CommonUtils.convertTimeToString(thirtyMinutesLater));
        if(GetController.to.loadingPercent.value == 100){
          setState(() {
            Config.isControllerLoadFinished = true;
          });
        }
      }else{
        CommonUtils.flutterToast("logfin init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initHyphen() async {
    // init
    await HyphenController.initHyphen((bool isSuccess){
      if(isSuccess){
        GetController.to.updatePercent(10);
        CommonUtils.log("i", "hyphen url : ${HyphenController.url}\hyphen hKey : ${HyphenController.hkey}");
        CommonUtils.log("i", "percent : ${GetController.to.loadingPercent.value}");
        if(GetController.to.loadingPercent.value == 100){
          setState(() {
            Config.isControllerLoadFinished = true;
          });
        }
      }else{
        CommonUtils.flutterToast("hyphen init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initIamport() async {
    // init
    await IamportController.initIamport((bool isSuccess){
      if(isSuccess){
        GetController.to.updatePercent(10);
        CommonUtils.log("i", "iamport user_code : ${IamportController.iamportUserCode}");
        CommonUtils.log("i", "percent : ${GetController.to.loadingPercent.value}");
        if(GetController.to.loadingPercent.value == 100){
          setState(() {
            Config.isControllerLoadFinished = true;
          });
        }
      }else{
        CommonUtils.flutterToast("iamport init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initKakao() async {
    // init
    await SnsLoginController.initKakao((bool isSuccess){
      if(isSuccess){
        GetController.to.updatePercent(20);
        CommonUtils.log("i", "kakao key : ${SnsLoginController.kakaoKey}");
        CommonUtils.log("i", "percent : ${GetController.to.loadingPercent.value}");
        if(GetController.to.loadingPercent.value == 100){
          setState(() {
            Config.isControllerLoadFinished = true;
          });
        }
      }else{
        CommonUtils.flutterToast("iamport init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initSharedPreference() async {
    // init
    await SharedPreferenceController.initSharedPreference((bool isSuccess){
      if(isSuccess){
        CommonUtils.log("i","sharedPreference init.");
      }else{
        CommonUtils.flutterToast("sharedPreference init 에러가 발생했습니다.");
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

  Future<void> _initDeepLinkHandling() async {
    try {
      uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;

        if (uri != null) {
          CommonUtils.log("i", "depp link uri : $uri");
          Config.deppLinkInfo = uri.toString();
          String paramValue = CommonUtils.getValueFromDeepLink(Config.deppLinkInfo, "param1");
          CommonUtils.log("i", "init deep link paramValue : $paramValue");
        }else{
          CommonUtils.log("i", "depp link uri is null");
          Config.deppLinkInfo = "";
        }
      });
    } catch (e) {
      print('Error initializing deep link handling: $e');
    }
  }

  Future<void> _requestPermissions() async {
    await CommonUtils.requestPermissions((isDenied, deniedPermissionsList) async {
      if(isDenied){
        String deniedPermissionsString = "";
        for(int i = 0; i < deniedPermissionsList!.length; i++){
          deniedPermissionsString += deniedPermissionsList[i];
          if(i != deniedPermissionsList.length-1){
            deniedPermissionsString += ", ";
          }
        }

        await Future.delayed(const Duration(milliseconds: 1500), () async {
          UiUtils.showSlideMenu(context, SlideType.bottomToTop, false, null, 18.h, 0.5, (slideContext, setState) =>
              Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UiUtils.getStyledTextWithFixedScale("[$deniedPermissionsString] 권한이 필요합니다. ", TextStyles.upFinBasicTextStyle, TextAlign.center, null),
                    UiUtils.getMarginBox(100.w, 2.h),
                    UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinTextAndBorderBlue,
                        UiUtils.getTextWithFixedScale("설정 바로가기", 12.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null), () {
                          openAppSettings();
                          Navigator.of(slideContext).pop();
                        })
                  ]
              ));
        });

        CommonUtils.log("i", "denied permissions : $deniedPermissionsString");
      }
    });
  }

  Future<void> _initAtFirst() async {
    Config.isAppMainInit = true;
    Get.put(GetController());
    await _initFirebase();
    await _initAppState();
    if(Config.appState == Config.appOpenState){
      await _initDeepLink().then((value){
        if(value != null){
          Config.deppLinkInfo = value;
        }else{
          Config.deppLinkInfo = "";
        }
      });
      await _requestPermissions();
      await _initSharedPreference();
      //_initGPT(); // count
      _initCodeF(); // count aa
      _initJuso(); // count aa
      _initCLOVA(); // count aa
      _initAWS(); // count aa
      _initLogfin(); // count aa
      _initHyphen(); // count
      _initIamport(); // count aa
      _initKakao(); // count aa
    }else{
      if(context.mounted){
        UiUtils.showSlideMenu(context, SlideType.bottomToTop, false, 100.w, 30.h, 0.5, (context, setState){
          return Center(child: UiUtils.getTextWithFixedScale("시스템 점검중입니다.", 20.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.center, null));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? view;
    if(!Config.isAppMainInit){
      _initAtFirst();
      view = Obx(()=>UiUtils.getInitLoadingView(GetController.to.loadingPercent.value));
    }else{
      if(!Config.isControllerLoadFinished){
        view = Obx(()=>UiUtils.getInitLoadingView(GetController.to.loadingPercent.value));
      }else{
        view = Container(color: ColorStyles.upFinWhite, width: 100.w, height: 100.h, padding: EdgeInsets.all(5.w), child:
        Column(children: [
          SizedBox(width: 100.w, child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            UiUtils.getMarginBox(0, 15.h),
            UiUtils.getTitleWithFixedScale("upfin", 75.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, null),
            UiUtils.getMarginBox(0, 10.h),
            UiUtils.getTextWithFixedScale("나에게 꼭 맞는", 30.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, null),
            UiUtils.getMarginBox(0, 0.5.h),
            UiUtils.getTextWithFixedScale("다이렉트 대출신청!", 30.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, null),
            UiUtils.getMarginBox(0, 8.h)
          ])),
          UiUtils.getExpandedScrollView(Axis.vertical, SizedBox(width: 100.w, child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                UiUtils.getTextWithFixedScale("Email 로그인", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
                  CommonUtils.moveTo(context, AppView.loginView.value, null);
                }),
            UiUtils.getMarginBox(0, 0.5.h),
            SnsLoginController.getKakaoLoginButton(context, 20.w, (isSuccessToLogin) async {
              if(isSuccessToLogin != null){
                if(isSuccessToLogin){
                  CommonUtils.flutterToast("환영합니다!");
                  UiUtils.showLoadingPop(context);
                  await LogfinController.getMainOrSearchView((isSuccessToGetViewInfo, viewInfo){
                    UiUtils.closeLoadingPop(context);
                    if(isSuccessToGetViewInfo){
                      CommonUtils.moveTo(context, AppView.mainView.value, null);
                    }
                  });
                }else{
                  UiUtils.closeLoadingPop(context);
                  await CommonUtils.moveToWithResult(context, AppView.signupView.value, null);
                }
              }else{
                UiUtils.closeLoadingPop(context);
              }
            }),
            UiUtils.getMarginBox(0, 0.5.h),
            SnsLoginController.getAppleLoginButton(context, 20.w, (isSuccessToLogin) async {
              if(isSuccessToLogin != null){
                if(isSuccessToLogin){
                  CommonUtils.flutterToast("환영합니다!");
                  UiUtils.showLoadingPop(context);
                  await LogfinController.getMainOrSearchView((isSuccessToGetViewInfo, viewInfo){
                    UiUtils.closeLoadingPop(context);
                    if(isSuccessToGetViewInfo){
                      CommonUtils.moveTo(context, AppView.mainView.value, null);
                    }
                  });
                }else{
                  UiUtils.closeLoadingPop(context);
                  await CommonUtils.moveToWithResult(context, AppView.signupView.value, null);
                }
              }else{
                UiUtils.closeLoadingPop(context);
              }
            }),
            UiUtils.getMarginBox(0, 0.5.h),
            UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinButtonBlue,
                UiUtils.getTextWithFixedScale("회원가입", 14.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, null), () {
                  CommonUtils.moveTo(context, AppView.signupView.value, null);
                }),
            UiUtils.getMarginBox(0, 0.5.h),
            UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinRed, ColorStyles.upFinRed,
                UiUtils.getTextWithFixedScale("회원탈퇴(테스트용)", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
                  Map<String, dynamic> inputJson = {
                    "user" : {
                      "email": "lalalllaa@kakao.com",
                      "password": "1111111"
                    }
                  };
                  UiUtils.showLoadingPop(context);
                  LogfinController.callLogfinApi(LogfinApis.deleteAccount, inputJson, (isSuccessToLogin, outputJson) async {
                    UiUtils.closeLoadingPop(context);
                    if(isSuccessToLogin){
                      CommonUtils.flutterToast("회원삭제");
                    }else{
                      CommonUtils.flutterToast(outputJson!["error"]);
                    }
                  });
                }),
          ])))
        ])
        );
      }
    }

    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}