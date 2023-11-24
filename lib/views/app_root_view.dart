import 'dart:async';
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
import 'package:upfin/controllers/websocket_controller.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:uni_links/uni_links.dart';
import '../controllers/codef_controller.dart';
import '../datas/my_data.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AppRootView extends StatefulWidget{
  @override
  AppRootViewState createState() => AppRootViewState();
}

class AppRootViewState extends State<AppRootView> with WidgetsBindingObserver{
  bool isAutoLogin = false;
  Timer? permissionCheckTimer;
  bool isPermissionCheckPopStarted = false;
  bool isPermissionDenied = false;

  @override
  void initState(){
    CommonUtils.log("i", "AppRootView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    MyData.resetMyData();
    _initDeepLinkHandling();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setImagePreLoad();
    });
    Config.contextForEmergencyBack = context;
    Config.isEmergencyRoot = true;
    FireBaseController.setStateForForeground = null;
    FireBaseController.analytics!.logAppOpen();
  }

  @override
  void dispose() {
    CommonUtils.log("i", "AppRootView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    GetController.to.resetPercent();
    Config.contextForEmergencyBack = null;
    if(permissionCheckTimer != null) permissionCheckTimer!.cancel();
    permissionCheckTimer = null;
    CommonUtils.saveSettingsToFile("push_from", "");
    CommonUtils.saveSettingsToFile("push_room_id", "");
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

  void _setImagePreLoad(){
    precacheImage(const AssetImage('assets/images/img_man_searcher.png'), context);
    precacheImage(const AssetImage('assets/images/logo_kakao_circle.png'), context);
    precacheImage(const AssetImage('assets/images/logo_apple_circle.png'), context);
    precacheImage(const AssetImage('assets/images/img_man_searcher.png'), context);
    precacheImage(const AssetImage('assets/images/img_woman_searcher_01.png'), context);
    precacheImage(const AssetImage('assets/images/img_woman_coffee.png'), context);
    precacheImage(const AssetImage('assets/images/accident_icon.png'), context);
    precacheImage(const AssetImage('assets/images/bank_logo_default.png'), context);
    precacheImage(const AssetImage('assets/images/bank_logo_safe.png'), context);
    precacheImage(const AssetImage('assets/images/ani_man_search.gif'), context);
    precacheImage(const AssetImage('assets/images/img_id_card.png'), context);
    precacheImage(const AssetImage('assets/images/kakao_icon.png'), context);
    precacheImage(const AssetImage('assets/images/naver_icon.png'), context);
    precacheImage(const AssetImage('assets/images/pass_icon.png'), context);
    precacheImage(const AssetImage('assets/images/toss_icon.png'), context);
    precacheImage(const AssetImage('assets/images/chat_loading.gif'), context);
  }

  Future<void> _initFirebase() async {
    // init
    await FireBaseController.initFcm((bool isSuccess, String fcmToken){
      if(isSuccess){
        CommonUtils.log("i", "firebase credential : ${FireBaseController.userCredential.toString()}");
      }else{
        CommonUtils.flutterToast("firebase init 에러가 발생했어요.");
      }
    });
  }

  Future<void> _initAppState() async {
    // init
    await Config.initAppState((bool isSuccess){
      if(isSuccess){
        CommonUtils.log("i", "app state : ${Config.appState}");
      }else{
        CommonUtils.flutterToast("에러가 발생했어요.");
      }
    });
  }

  void _initGPT() {
    // init
    GptController.initGPT((bool isSuccess){
      if(isSuccess){
        GetController.to.updatePercent(10);
        CommonUtils.log("i", "gpt key : ${GptController.gptApiKey}");

        if(GetController.to.loadingPercent.value == 100){
          setState(() {
            Config.isControllerLoadFinished = true;
          });
        }
      }else{
        CommonUtils.flutterToast("gpt init 에러가 발생했어요.");
      }
    });
  }

  void _initCodeF() {
    // set host : prod or dev
    CodeFController.setHostStatus(HostStatus.prod);

    // init
    CodeFController.initAccessToken((bool isSuccess){
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
        CommonUtils.flutterToast("codef init 에러가 발생했어요.");
      }
    });
  }

  void _initJuso() {
    // init
    JusoController.initJuso((bool isSuccess){
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
        CommonUtils.flutterToast("juso init 에러가 발생했어요");
      }
    });
  }

  void _initCLOVA() {
    // init
    CLOVAController.initCLOVA((bool isSuccess){
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
        CommonUtils.flutterToast("clova init 에러가 발생했어요");
      }
    });
  }

  void _initAWS() {
    // init
    AwsController.initAWS((bool isSuccess){
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
        CommonUtils.flutterToast("aws init 에러가 발생했어요.");
      }
    });
  }

  void _initLogfin() {
    // init
    LogfinController.initLogfin((bool isSuccess){
      if(isSuccess){
        GetController.to.updatePercent(10);
        CommonUtils.log("i", "logfin url : ${LogfinController.url}");
        CommonUtils.log("i", "percent : ${GetController.to.loadingPercent.value}");
        if(GetController.to.loadingPercent.value == 100){
          setState(() {
            Config.isControllerLoadFinished = true;
          });
        }
      }else{
        CommonUtils.flutterToast("logfin init 에러가 발생했어요.");
      }
    });
  }

  void _initHyphen() {
    // init
    HyphenController.initHyphen((bool isSuccess){
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
        CommonUtils.flutterToast("hyphen init 에러가 발생했어요.");
      }
    });
  }

  void _initIamport() {
    // init
    IamportController.initIamport((bool isSuccess){
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

  void _initWebSocketForChat() {
    // init
    WebSocketController.initWebSocket((bool isSuccess){
      if(isSuccess){
        GetController.to.updatePercent(5);
        CommonUtils.log("i", "ws url : ${WebSocketController.wsUrl}");
        CommonUtils.log("i", "ws origin url : ${WebSocketController.wsOriginUrl}");
        CommonUtils.log("i", "ws channel name : ${WebSocketController.channelName}");
        if(GetController.to.loadingPercent.value == 100){
          setState(() {
            Config.isControllerLoadFinished = true;
          });
        }
      }else{
        CommonUtils.flutterToast("webSocket init 에러가 발생했습니다.");
      }
    });
  }

  void _initSnsLogin() {
    // init
    SnsLoginController.initKakao((bool isSuccess){
      if(isSuccess){
        GetController.to.updatePercent(5);
        CommonUtils.log("i", "kakao key : ${SnsLoginController.kakaoKey}");
        CommonUtils.log("i", "percent : ${GetController.to.loadingPercent.value}");
        if(GetController.to.loadingPercent.value == 100){
          setState(() {
            Config.isControllerLoadFinished = true;
          });
        }
      }else{
        CommonUtils.flutterToast("kakao init 에러가 발생했습니다.");
      }
    });

    SnsLoginController.initApple((bool isSuccess){
      if(isSuccess){
        GetController.to.updatePercent(10);
        CommonUtils.log("i", "apple url : ${SnsLoginController.appleUrl}");
        if(GetController.to.loadingPercent.value == 100){
          setState(() {
            Config.isControllerLoadFinished = true;
          });
        }
      }else{
        CommonUtils.flutterToast("apple url init 에러가 발생했습니다.");
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

  bool isPopOn = false;
  Future<void> _requestPermissions() async {
    isPermissionCheckPopStarted = true;
    await CommonUtils.requestPermissions((isDenied, deniedPermissionsList) async {
      if(isDenied){
        isPopOn = true;
        isPermissionDenied = true;
        String deniedPermissionsString = "";
        for(int i = 0; i < deniedPermissionsList!.length; i++){
          deniedPermissionsString += deniedPermissionsList[i];
          if(i != deniedPermissionsList.length-1){
            deniedPermissionsString += ", ";
          }
        }

        String allText = deniedPermissionsString.contains(",")? " 모두"  : "";

        UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, false, null, Config.isAndroid ? 22.h : 27.h, 0.5, (slideContext, setState){
          return Column(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UiUtils.getMarginBox(100.w, 1.h),
                Column(children: [
                  SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale2("권한이 필요합니다.",14.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.center, null)),
                  UiUtils.getMarginBox(0, 1.h),
                  SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale2("[$deniedPermissionsString]권한을$allText 허용해주세요",12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null))
                ]),
                UiUtils.getExpandedScrollView(Axis.vertical, Container()),
                UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                    UiUtils.getTextWithFixedScale("설정 바로가기", 12.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () async {
                      openAppSettings();
                    }),
                Config.isAndroid ? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 5.h),
              ]
          );
        });

        CommonUtils.log("i", "denied permissions : $deniedPermissionsString");
      }
    });
  }

  void _callInitApis(){
    // count..
    //_initGPT();
    _initCodeF();
    _initJuso();
    _initCLOVA();
    _initAWS();
    _initLogfin();
    _initHyphen();
    _initIamport();
    _initSnsLogin();
    _initWebSocketForChat();
  }

  Future<void> _initAtFirst() async {
    Config.isAppMainInit = true;
    await _initFirebase();
    await _initAppState();
    if(Config.appState == Config.stateInfoMap["open"]){
      await _initDeepLink().then((value){
        if(value != null){
          Config.deppLinkInfo = value;
        }else{
          Config.deppLinkInfo = "";
        }
      });
      await _initSharedPreference();

      /*
      if(Config.isAndroid){
        isPermissionDenied = await CommonUtils.isPermissionDenied();
        if(isPermissionDenied){
          permissionCheckTimer ??= Timer.periodic(const Duration(seconds: 2), (Timer timer) async {
            isPermissionDenied = await CommonUtils.isPermissionDenied();
            if(isPermissionDenied && !isPermissionCheckPopStarted){
              await _requestPermissions();
            }else if(!isPermissionDenied && isPermissionCheckPopStarted){
              if(permissionCheckTimer != null) permissionCheckTimer!.cancel();
              if(context.mounted && isPopOn) Navigator.pop(context);
              _callInitApis();
            }
          });
        }else{
          _callInitApis();
        }
      }else{
        _callInitApis();
      }
       */

      isPermissionDenied = await CommonUtils.isPermissionDenied();
      if(isPermissionDenied){
        permissionCheckTimer ??= Timer.periodic(const Duration(seconds: 2), (Timer timer) async {
          isPermissionDenied = await CommonUtils.isPermissionDenied();
          if(isPermissionDenied && !isPermissionCheckPopStarted){
            CommonUtils.log("W","req");
            await _requestPermissions();
          }else if(!isPermissionDenied && isPermissionCheckPopStarted){
            if(permissionCheckTimer != null) permissionCheckTimer!.cancel();
            if(context.mounted && isPopOn) Navigator.pop(context);
            _callInitApis();
          }
        });
      }else{
        _callInitApis();
      }

    }else if(Config.appState == Config.stateInfoMap["update"]){
      if(context.mounted){
        UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, false, 100.w, Config.isAndroid ? 18.h : 23.h, 0.5, (context, setState){
          return Center(child: Column(children: [
            UiUtils.getMarginBox(0, 1.h),
            UiUtils.getTextWithFixedScale("앱 업데이트가 필요합니다!", 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null),
            UiUtils.getMarginBox(0, 3.h),
            UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                UiUtils.getTextWithFixedScale("업데이트", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null), () {
                  launchUrl(Uri.parse(Config.appStoreUrl));
                }),
            Config.isAndroid? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 5.h)
          ]));
        });
      }
    }else if(Config.appState == Config.stateInfoMap["close"]){
      if(context.mounted){
        UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, false, 100.w, Config.isAndroid ? 30.h : 35.h, 0.5, (context, setState){
          return Column(children: [
            UiUtils.getMarginBox(0, 3.h),
            Center(child: UiUtils.getTextWithFixedScale("시스템 점검중입니다.", 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.center, null)),
            UiUtils.getMarginBox(0, 3.h),
            UiUtils.getExpandedScrollView(Axis.vertical,
                SizedBox(width : 80.w, child: UiUtils.getTextWithFixedScale2(Config.appInfoTextMap["close_text"].replaceAll("@@", "\n"), 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null))),
            UiUtils.getMarginBox(0, 1.h)
          ]);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      CommonUtils.hideKeyBoard();
      if(Config.isControllerLoadFinished && Config.isEmergencyRoot){
        if(CommonUtils.isValidStateByApiExpiredDate() && !isAutoLogin){
          isAutoLogin = true;

          String isSnsLogin = SharedPreferenceController.getSharedPreferenceValue(SharedPreferenceController.sharedPreferenceIsSnsLogin);
          String emailId = SharedPreferenceController.getSharedPreferenceValue(SharedPreferenceController.sharedPreferenceIdKey);
          UiUtils.showLoadingPop(context);

          if(isSnsLogin == "Y"){
            String token = SharedPreferenceController.getSharedPreferenceValue(SharedPreferenceController.sharedPreferenceSnsToken);
            String id = SharedPreferenceController.getSharedPreferenceValue(SharedPreferenceController.sharedPreferenceSnsId);
            String provider = SharedPreferenceController.getSharedPreferenceValue(SharedPreferenceController.sharedPreferenceSnsType);
            Map<String, String> inputJson = {
              "email": emailId,
              "token": token,
              "user_id": id,
              "provider": provider
            };

            await LogfinController.callLogfinApi(LogfinApis.socialLogin, inputJson, (isSuccessToLogin, outputJson) async {
              if(isSuccessToLogin){
                SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceIsSnsLogin, "Y");
                await LogfinController.getMainViewInfo((isSuccessToGetMainInfo){
                  UiUtils.closeLoadingPop(context);
                  if(isSuccessToGetMainInfo){
                    CommonUtils.flutterToast("환영합니다!");
                    CommonUtils.goToMain(context, null, null);
                  }
                });
              }else{
                UiUtils.closeLoadingPop(context);
                CommonUtils.flutterToast("오류가 발생했어요.");
              }
            });
          }else{
            String pw = SharedPreferenceController.getSharedPreferenceValue(SharedPreferenceController.sharedPreferencePwKey);
            Map<String, dynamic> inputJson = {
              "user" : {
                "email": emailId,
                "password": pw
              }
            };

            LogfinController.callLogfinApi(LogfinApis.signIn, inputJson, (isSuccessToLogin, outputJson) async {
              if(isSuccessToLogin){
                SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceIsSnsLogin, "N");
                await LogfinController.getMainViewInfo((isSuccessToGetMainInfo){
                  UiUtils.closeLoadingPop(context);
                  if(isSuccessToGetMainInfo){
                    CommonUtils.flutterToast("환영합니다!");
                    CommonUtils.goToMain(context, null, null);
                  }
                });
              }else{
                UiUtils.closeLoadingPop(context);
                CommonUtils.flutterToast("오류가 발생했어요.");
              }
            });
          }
        }
      }else{
        if(!Config.isAppMainInit){
          _initAtFirst();
        }
      }
    });

    Widget? view;
    if(!Config.isAppMainInit){
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
            UiUtils.getTextWithFixedScale("나에게 꼭 맞는", 24.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, null),
            UiUtils.getMarginBox(0, 0.5.h),
            UiUtils.getTextWithFixedScale("다이렉트 대출신는청!", 24.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, null),
            UiUtils.getMarginBox(0, 10.h)
          ])),
          UiUtils.getExpandedScrollView(Axis.vertical, SizedBox(width: 100.w, child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                UiUtils.getTextWithFixedScale("로그인", 16.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
                  SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceSnsToken, "");
                  SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceSnsId, "");
                  SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceIsSnsLogin, "N");
                  CommonUtils.moveTo(context, AppView.appLoginView.value, null);
                }),
            UiUtils.getMarginBox(0, 1.5.h),
            UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinWhiteSky,
                UiUtils.getTextWithFixedScale("회원가입 ", 16.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, null), () {
                  SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceSnsToken, "");
                  SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceSnsId, "");
                  SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceIsSnsLogin, "N");
                  CommonUtils.moveTo(context, AppView.appSignupView.value, null);
                }),
            UiUtils.getMarginBox(0, 4.h),
            SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("소셜계정으로 로그인", 12.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.center, null)),
            UiUtils.getMarginBox(0, 1.h),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SnsLoginController.getKakaoLoginButton(context, 12.w, (isSuccessToLogin) async {
                if(isSuccessToLogin != null){
                  if(isSuccessToLogin){
                    CommonUtils.flutterToast("환영합니다!");
                    UiUtils.showLoadingPop(context);
                    await LogfinController.getMainViewInfo((isSuccessToGetMainInfo){
                      UiUtils.closeLoadingPop(context);
                      if(isSuccessToGetMainInfo){
                        CommonUtils.goToMain(context, null, null);
                      }
                    });
                  }else{
                    UiUtils.closeLoadingPop(context);
                    await CommonUtils.moveToWithResult(context, AppView.appSignupView.value, null);
                  }
                }else{
                  UiUtils.closeLoadingPop(context);
                }
              }),
              SnsLoginController.getAppleLoginButton(context, 12.w, (isSuccessToLogin) async {
                if(isSuccessToLogin != null){
                  if(isSuccessToLogin){
                    CommonUtils.flutterToast("환영합니다!");
                    UiUtils.showLoadingPop(context);
                    await LogfinController.getMainViewInfo((isSuccessToGetMainInfo){
                      UiUtils.closeLoadingPop(context);
                      if(isSuccessToGetMainInfo){
                        CommonUtils.goToMain(context, null, null);
                      }
                    });
                  }else{
                    UiUtils.closeLoadingPop(context);
                    await CommonUtils.moveToWithResult(context, AppView.appSignupView.value, null);
                  }
                }else{
                  UiUtils.closeLoadingPop(context);
                }
              })
            ])
          ])))
        ])
        );
      }
    }

    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}