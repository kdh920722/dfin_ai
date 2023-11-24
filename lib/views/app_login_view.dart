import 'package:flutter/material.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/controllers/sharedpreference_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:upfin/views/app_findpw_view.dart';
import '../controllers/firebase_controller.dart';
import '../styles/TextStyles.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppLoginView extends StatefulWidget{
  @override
  AppLoginViewState createState() => AppLoginViewState();
}

class AppLoginViewState extends State<AppLoginView> with WidgetsBindingObserver{
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _pwdTextController = TextEditingController();
  final _emailTextFocus = FocusNode();
  final _pwdTextFocus = FocusNode();

  void _unFocusAllNodes(){
    _emailTextFocus.unfocus();
    _pwdTextFocus.unfocus();
  }

  void _disposeAllTextControllers(){
    _emailTextController.dispose();
    _pwdTextController.dispose();
  }

  @override
  void initState(){
    CommonUtils.log("i", "AppLoginView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _emailTextController.text = SharedPreferenceController.getSharedPreferenceValue(SharedPreferenceController.sharedPreferenceIdKey);
    _pwdTextController.text = SharedPreferenceController.getSharedPreferenceValue(SharedPreferenceController.sharedPreferencePwKey);
    Config.contextForEmergencyBack = context;
    Config.isEmergencyRoot = false;
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppLoginView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _unFocusAllNodes();
    _disposeAllTextControllers();
    Config.contextForEmergencyBack = null;
    _emailTextController.text = "";
    _pwdTextController.text = "";
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('i','AppLoginView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('i','AppLoginView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('i','AppLoginView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('i','AppLoginView paused');
        break;
      default:
        break;
    }
  }

  void back(){
    CommonUtils.hideKeyBoard();
    Future.delayed(const Duration(milliseconds: 400), () async {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Container(color: ColorStyles.upFinWhite, width: 100.w, height: 100.h, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child:
    Form(key: _formKey,
        child: UiUtils.getRowColumnWithAlignCenter([
          SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            UiUtils.getBackButtonForMainView(() async {
              back();
            }),
          ])),
          SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            UiUtils.getMarginBox(0, 3.w),
            UiUtils.getTextWithFixedScale("로그인", 26.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, null),
            UiUtils.getMarginBox(0, 3.h)
          ])),
          UiUtils.getTextFormField(context, 90.w, TextStyles.upFinTextFormFieldTextStyle, _emailTextFocus, _emailTextController, TextInputType.emailAddress, false,
              UiUtils.getInputDecoration("이메일", 12.sp, "", 0.sp), (text) { }, (value){
                if(value != null && value.trim().isEmpty){
                  return "이메일을 입력하세요.";
                }else{
                  return null;
                }
              }),
          UiUtils.getMarginBox(0, 2.h),
          UiUtils.getTextFormField(context, 90.w, TextStyles.upFinTextFormFieldTextStyle, _pwdTextFocus, _pwdTextController, TextInputType.visiblePassword, true,
              UiUtils.getInputDecoration("비밀번호", 12.sp, "", 0.sp), (text) { }, (value){
                if(value != null && value.trim().isEmpty){
                  return "비밀번호를 입력하세요.";
                }else{
                  return null;
                }
              }),
          UiUtils.getMarginBox(0, 4.h),
          UiUtils.getExpandedScrollView(Axis.vertical, const Column(children: [])),
          UiUtils.getTextButtonBox(90.w, "로그인", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () {
            if(_formKey.currentState!.validate() && Config.isControllerLoadFinished){
              CommonUtils.log("i", "OK");
              Map<String, dynamic> inputJson = {
                "user" : {
                  "email": _emailTextController.text.trim(),
                  "password": _pwdTextController.text.trim()
                }
              };

              UiUtils.showLoadingPop(context);
              LogfinController.callLogfinApi(LogfinApis.signIn, inputJson, (isSuccessToLogin, outputJson) async {
                if(isSuccessToLogin){
                  CommonUtils.flutterToast("환영합니다!");
                  await LogfinController.getMainViewInfo((isSuccessToGetMainInfo){
                    UiUtils.closeLoadingPop(context);
                    if(isSuccessToGetMainInfo){
                      // 캐시 데이터 저장
                      if(SharedPreferenceController.getSharedPreferenceValue(SharedPreferenceController.sharedPreferenceIdKey) == "" ||
                          SharedPreferenceController.getSharedPreferenceValue(SharedPreferenceController.sharedPreferenceIdKey) != _emailTextController.text.trim()){
                      }
                      SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceSnsToken, "");
                      SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceSnsId, "");
                      SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceIsSnsLogin, "N");
                      CommonUtils.goToMain(context, _emailTextController.text.trim(), _pwdTextController.text.trim());
                    }
                  });
                }else{
                  UiUtils.closeLoadingPop(context);
                  CommonUtils.flutterToast(outputJson!["error"]);
                  if(outputJson["error"] == "회원가입이 필요합니다."){
                    SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceSnsToken, "");
                    SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceSnsId, "");
                    SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceIsSnsLogin, "N");
                    CommonUtils.moveWithReplacementTo(context, AppView.appSignupView.value, null);
                  }
                }
              });
            }else{
              if(!Config.isControllerLoadFinished){
                CommonUtils.flutterToast("데이터 로딩 실패\n다시 실행 해 주세요.");
              }else{
                CommonUtils.flutterToast("입력하신 정보를\n다시 확인 해 주세요.");
              }
            }
          }),
          UiUtils.getMarginBox(0, 2.w),
          UiUtils.getBorderButtonBoxWithZeroPadding(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
              Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment:MainAxisAlignment.center, children: [
                UiUtils.getBorderButtonBox(44.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinWhiteSky,
                    UiUtils.getTextWithFixedScale("아이디 찾기", 12.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.center, null), () {
                      AppFindPwViewState.viewId = 4;
                      CommonUtils.moveTo(context, AppView.appFindPwView.value, null);
                    }),
                UiUtils.getMarginBox(2.w, 0),
                UiUtils.getBorderButtonBox(44.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinWhiteSky,
                    UiUtils.getTextWithFixedScale("비밀번호 찾기", 12.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.center, null), () {
                      AppFindPwViewState.viewId = 1;
                      CommonUtils.moveTo(context, AppView.appFindPwView.value, null);
                    })
              ]), () {})
        ])
    )
    );

    return UiUtils.getViewWithAllowBackForAndroid(context, view, back);
  }

}