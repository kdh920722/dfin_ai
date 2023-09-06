import 'dart:async';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _pwdTextController = TextEditingController();

  KeyboardVisibilityController? _keyboardVisibilityController;
  void _functionForKeyboardHide(){
    CommonUtils.log("i", "HIDE");
    _scrollController.jumpTo(0);
  }
  void _functionForKeyboardShow(){
    CommonUtils.log("i", "SHOW");
  }

  @override
  void initState(){
    CommonUtils.log("i", "새 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _keyboardVisibilityController = CommonUtils.getKeyboardViewController(_functionForKeyboardShow, _functionForKeyboardHide);
  }

  @override
  void dispose(){
    CommonUtils.log("i", "새 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _keyboardVisibilityController = null;
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
      }else{
        CommonUtils.log("i","sharedPreference init.");
        _emailTextController.text = SharedPreferenceController.getSharedPreferenceValue(SharedPreferenceController.sharedPreferenceIdKey);
        _pwdTextController.text = SharedPreferenceController.getSharedPreferenceValue(SharedPreferenceController.sharedPreferencePwKey);
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

        UiUtils.showSlideMenu(context, SlideType.bottomToTop, true, null, null, 0.5, (context, setState) =>
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
  Widget build(BuildContext context) {
    Widget? view;
    if(!Config.isAppMainInit){
      _initAtFirst();
      view = UiUtils.getInitLoadingView();
    }else{
      //Config.isControllerLoadFinished
      view = Container(color: ColorStyles.upFinWhite, width: 100.w, height: 100.h, padding: const EdgeInsets.all(20.0), child:
      Column(children: [
        SizedBox(width: 100.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UiUtils.getMarginBox(0, 7.h),
          UiUtils.getTextWithFixedScale("업핀", 55.sp, FontWeight.w800, ColorStyles.upFinButtonBlue, TextAlign.start, null),
          UiUtils.getMarginBox(0, 2.h),
          UiUtils.getTextWithFixedScale("나에게 꼭 맞는", 28.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null),
          UiUtils.getMarginBox(0, 0.5.h),
          UiUtils.getTextWithFixedScale("개인회생 대출상품", 28.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null),
          UiUtils.getMarginBox(0, 0.5.h),
          UiUtils.getTextWithFixedScale("바로 접수하세요!", 28.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null),
          UiUtils.getMarginBox(0, 7.h)
        ])),
        Form(key: _formKey,
            child: UiUtils.getRowColumnWithAlignCenter([
              UiUtils.getTextFormField(90.w, _emailTextController, TextInputType.emailAddress, false, UiUtils.getInputDecoration("이메일", ""), (text) { }, (value){
                if(value != null && value.trim().isEmpty){
                  return "이메일을 입력하세요.";
                }else{
                  return null;
                }
              }),
              UiUtils.getMarginBox(0, 2.h),
              UiUtils.getTextFormField(90.w, _pwdTextController, TextInputType.visiblePassword, true, UiUtils.getInputDecoration("비밀번호", ""), (text) { }, (value){
                if(value != null && value.trim().isEmpty){
                  return "비밀번호를 입력하세요.";
                }else{
                  return null;
                }
              }),
              UiUtils.getMarginBox(0, 2.h),
              UiUtils.getTextButtonBox(90.w, "로그인", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () {
                if(_formKey.currentState!.validate() && Config.isControllerLoadFinished){
                  CommonUtils.log("i", "OK");
                  Map<String, dynamic> inputJson = {
                    "user" : {
                      "email": _emailTextController.text.trim(),
                      "password": _pwdTextController.text.trim()
                    }
                  };

                  LogfinController.callLogfinApi(LogfinApis.signIn, inputJson, (isSuccess, outputJson){
                    if(isSuccess){
                      CommonUtils.flutterToast("환영합니다.");
                      // 1) 캐시 데이터 저장
                      SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceIdKey, _emailTextController.text.trim());
                      SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferencePwKey, _pwdTextController.text.trim());

                      // 2) 유저정보 가져오기

                      // 3) 사건정보 조회

                      // 4-1) 사건정보 없으면 한도금리 조회를 위한 조건 입력 화면으로 이동(한도금리 조회 시, 사건정보 저장)

                      // 4-2) 사건정보 있으면 사건정보 이력화면(메인 뷰)로 이동
                    }else{
                      CommonUtils.flutterToast("로그인에 실패했습니다.");
                    }
                  });
                }else{
                  if(!Config.isControllerLoadFinished){
                    CommonUtils.flutterToast("데이터 로딩에 실패했습니다. 앱을 다시 실행 해 주세요.");
                  }else{
                    CommonUtils.flutterToast("입력하신 정보를 확인 해 주세요.");
                  }
                }
              }),
              UiUtils.getMarginBox(0, 0.7.h),
              UiUtils.getTextButtonBox(90.w, "회원가입", TextStyles.upFinSkyTextInButtonStyle, ColorStyles.upFinWhiteSky, () {
                if(Config.isControllerLoadFinished){
                  CommonUtils.moveTo(context, AppView.signupView.value, null);
                }else{
                  CommonUtils.flutterToast("데이터 로딩에 실패했습니다. 앱을 다시 실행 해 주세요.");
                }
              }),
            ])
        ),
        UiUtils.getExpandedScrollView(Axis.vertical, SizedBox(width: 100.w, child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          UiUtils.getMarginBox(0, 7.h),
          UiUtils.getTextWithFixedScale("소셜 계정으로 로그인", 12.sp, FontWeight.w300, ColorStyles.upFinTextAndBorderBlue, TextAlign.center, null),
          UiUtils.getMarginBox(0, 0.1.h),
          Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end, children: [
            SnsLoginController.getKakaoLoginButton(context, 20.w, (isSuccessToLogin){
              if(isSuccessToLogin){

              }else{
                if(context.mounted){
                  CommonUtils.moveTo(context, AppView.signupView.value, null);
                }
              }
            }),
            SnsLoginController.getAppleLoginButton(context, 20.w, (isSuccessToLogin){
              if(isSuccessToLogin){

              }else{
                if(context.mounted){
                  CommonUtils.moveTo(context, AppView.signupView.value, null);
                }
              }
            })
          ])
        ])))
      ])
      );
    }

    return UiUtils.getViewWithScroll(context, view, _scrollController, CommonUtils.onWillPopForPreventBackButton);
  }

}