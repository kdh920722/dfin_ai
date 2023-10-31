import 'package:upfin/controllers/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/controllers/iamport_controller.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import '../styles/TextStyles.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppSignUpView extends StatefulWidget{
  @override
  AppSignUpViewState createState() => AppSignUpViewState();
}

class AppSignUpViewState extends State<AppSignUpView> with WidgetsBindingObserver{
  int viewId = 1;
  bool isPwShowValid = false;
  bool isPhoneShowValid = false;
  bool isButtonValid = false;
  bool isView1Valid = false;

  final ScrollController _scrollController = ScrollController();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _phoneNumberTextController = TextEditingController();
  final _pwdTextController = TextEditingController();
  final _pwdConfirmTextController = TextEditingController();

  final _nameTextFocus = FocusNode();
  final _emailTextFocus = FocusNode();
  final _phoneNumberTextFocus = FocusNode();
  final _pwdTextFocus = FocusNode();
  final _pwdConfirmFocus = FocusNode();

  bool isConfirmed = false;
  String confirmedName = "";
  String confirmedPhone = "";

  void _unFocusAllNodes(){
    _nameTextFocus.unfocus();
    _emailTextFocus.unfocus();
    _phoneNumberTextFocus.unfocus();
    _pwdTextFocus.unfocus();
    _pwdConfirmFocus.unfocus();
  }

  void _disposeAllTextControllers(){
    _nameTextController.dispose();
    _phoneNumberTextController.dispose();
    _emailTextController.dispose();
    _pwdTextController.dispose();
    _pwdConfirmTextController.dispose();
  }

  @override
  void initState(){
    CommonUtils.log("i", "AppSignUpViewState 화면 입장");
    super.initState();
    confirmedName = "X";
    confirmedPhone = "X";
    WidgetsBinding.instance.addObserver(this);
    _emailTextController.addListener(_emailListener);
    _pwdConfirmTextController.addListener(_pwListener);
    _nameTextController.addListener(_nameListener);
    _phoneNumberTextController.addListener(_phoneListener);
    if(MyData.isSnsLogin){
      _nameTextController.text = MyData.nameFromSns;
      _emailTextController.text = MyData.emailFromSns;
      _phoneNumberTextController.text = MyData.phoneNumberFromSns;
    }
    isConfirmed = false;
    GetController.to.resetConfirmed();
    Config.contextForEmergencyBack = context;
    Config.isEmergencyRoot = false;
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppSignUpViewState 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _unFocusAllNodes();
    _disposeAllTextControllers();
    GetController.to.resetConfirmed();
    Config.contextForEmergencyBack = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('i','AppSignUpView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('i','AppSignUpView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('i','AppSignUpView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('i','AppSignUpView paused');
        break;
      default:
        break;
    }
  }

  void _emailListener() {
    if(_emailTextController.text.trim() != ""){
      setState(() {
        isPwShowValid = true;
      });
    }else{
      setState(() {
        isPwShowValid = false;
      });
    }
  }

  void _pwListener() {
    if(_pwdConfirmTextController.text.trim() != ""){
      setState(() {
        isView1Valid = true;
      });
    }else{
      setState(() {
        isView1Valid = false;
      });
    }
  }

  void _nameListener() {
    if(_nameTextController.text.trim() != ""){
      setState(() {
        isPhoneShowValid = true;
      });
    }else{
      setState(() {
        isPhoneShowValid = false;
      });
    }
    if(_nameTextController.text.trim() != confirmedName){
      isConfirmed = false;
      GetController.to.updateConfirmed(isConfirmed);
    }else{
      isConfirmed = true;
      GetController.to.updateConfirmed(isConfirmed);
    }
  }

  void _phoneListener() {
    if(_phoneNumberTextController.text.trim() != confirmedPhone){
      isConfirmed = false;
      GetController.to.updateConfirmed(isConfirmed);
    }else{
      isConfirmed = true;
      GetController.to.updateConfirmed(isConfirmed);
    }

    if(_phoneNumberTextController.text.trim().length > 8){
      setState(() {
        isButtonValid = true;
      });
    }else{
      setState(() {
        isButtonValid = false;
      });
    }
  }

  Widget _getEmailAndPwInfoView(){
    return Form(key: _formKey1, child: UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButton(() {
          back();
        })
      ])),
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getMarginBox(0, 3.w),
        UiUtils.getTextWithFixedScale("회원가입", 26.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, null),
        UiUtils.getMarginBox(0, 3.h)
      ])),
      UiUtils.getTextFormField(90.w, TextStyles.upFinTextFormFieldTextStyle, _emailTextFocus, _emailTextController, TextInputType.emailAddress, false,
          UiUtils.getInputDecoration("이메일", 12.sp, "", 0.sp), (text) { }, (value){
            if(value != null && value.trim().isEmpty){
              return "이메일을 입력하세요.";
            }else if((value != null && value.trim().isNotEmpty && value.trim().length <4)
                || (value != null && value.trim().isNotEmpty && !value.trim().contains("@"))
                || (value != null && value.trim().isNotEmpty && !value.trim().contains("."))){
              return "이메일 형식이 잘못되었습니다.";
            }else{
              return null;
            }
          }),
      UiUtils.getMarginBox(0, 2.h),
      isPwShowValid? UiUtils.getTextFormField(90.w, TextStyles.upFinTextFormFieldTextStyle, _pwdTextFocus, _pwdTextController, TextInputType.visiblePassword, true,
          UiUtils.getInputDecoration("비밀번호", 12.sp, "", 0.sp), (text) { }, (value){
            if(value != null && value.trim().isEmpty){
              return "비밀번호를 입력하세요.";
            }else{
              if(value!.trim().length <= 6){
                return "비밀번호는 6자를 넘어야 합니다.";
              }else{
                return null;
              }
            }
          }) : Container(),
      UiUtils.getMarginBox(0, 2.h),
      isPwShowValid? UiUtils.getTextFormField(90.w, TextStyles.upFinTextFormFieldTextStyle, _pwdConfirmFocus, _pwdConfirmTextController, TextInputType.visiblePassword, true,
          UiUtils.getInputDecoration("비밀번호 확인", 12.sp, "", 0.sp), (text) { }, (value){
            if(value != null && value.trim().isEmpty){
              return "비밀번호를 한번 더 입력하세요.";
            }else{
              if(_pwdTextController.text.toString() != _pwdConfirmTextController.text.toString()){
                return "비밀번호가 일치하지 않습니다.";
              }else{
                if(value!.trim().length <= 6){
                  return "비밀번호는 6자를 넘어야 합니다.";
                }else{
                  return null;
                }
              }
            }
          }) : Container(),
      UiUtils.getExpandedScrollView(Axis.vertical, Container()),
      isView1Valid? UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () {
        if(_formKey1.currentState!.validate()){
          CommonUtils.hideKeyBoard();
          Map<String, dynamic> inputJson = {
            "email": _emailTextController.text.trim(),
          };
          UiUtils.showLoadingPop(context);
          LogfinController.callLogfinApi(LogfinApis.checkMember, inputJson, (isSuccess, outputJson){
            UiUtils.closeLoadingPop(context);
            if(isSuccess){
              _unFocusAllNodes();
              setState(() {
                viewId = 2;
              });
            }else{
              CommonUtils.flutterToast("이미 존재하는 이메일 입니다.");
            }
          });
        }else{
          if(_pwdTextController.text.trim() == _pwdConfirmTextController.text.trim() && _pwdTextController.text.length <= 6){
            CommonUtils.flutterToast("비밀번호는 6자를 넘어야 합니다.");
          }else{
            CommonUtils.flutterToast("입력하신 정보를\n다시 확인 해 주세요.");
          }
        }
      }) : Container()
    ]));
  }

  Widget _getPhoneValidView(){
    return Form(key: _formKey2, child: UiUtils.getRowColumnWithAlignCenter([
      Obx(()=>!GetController.to.isConfirmed.value? SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButton(() async {
          back();
        }),
      ])) : UiUtils.getMarginBox(0, 7.h)),
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getMarginBox(0, 3.w),
        UiUtils.getTextWithFixedScale("본인인증", 26.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, null),
        UiUtils.getMarginBox(0, 3.h)
      ])),
      UiUtils.getTextFormField(90.w, TextStyles.upFinTextFormFieldTextStyle, _nameTextFocus, _nameTextController, TextInputType.text, false,
          UiUtils.getInputDecoration("이름", 12.sp, "", 0.sp), (text) { }, (value){
            if(value != null && value.trim().isEmpty){
              return "이름을 입력하세요.";
            }else{
              return null;
            }
          }),
      UiUtils.getMarginBox(0, 2.h),
      isPhoneShowValid? UiUtils.getTextFormField(90.w, TextStyles.upFinTextFormFieldTextStyle, _phoneNumberTextFocus, _phoneNumberTextController, TextInputType.phone, false,
          UiUtils.getInputDecoration("휴대전화 번호", 12.sp, "", 0.sp), (text) { }, (value){
            if(value != null && value.trim().isEmpty){
              return "휴대전화 번호를 입력하세요.";
            }else{
              return null;
            }
          }): Container(),
      UiUtils.getExpandedScrollView(Axis.vertical, const Column(children: [])),
      isButtonValid? UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
          UiUtils.getTextWithFixedScale("다음", 12.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null), () async {
            CommonUtils.hideKeyBoard();
            if(_phoneNumberTextController.text.trim() != ""){
              //UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, true, 100.w, 62.h, 0.5, _makeAgreeWidget);
              UiUtils.showAgreePop(context, "A", () async {
                Map<String, String> inputJsonForCert = {
                  "carrier": "",
                  "name" : _nameTextController.text.trim(),
                  "phone" : _phoneNumberTextController.text.trim()
                };
                var result = await CommonUtils.moveToWithResult(context, AppView.appCertificationView.value, inputJsonForCert);
                if(result != null){
                  CommonUtils.flutterToast("인증 성공");
                  Map<String, dynamic> resultMap = result as Map<String, dynamic>;
                  for(var each in IamportController.carrierList){
                    if(each.split("@")[0] == resultMap["carrier"]){
                      MyData.telecomTypeFromPhoneCert = each.split("@")[1];
                    }
                  }

                  if(resultMap["gender"] == "male"){
                    MyData.isMaleFromPhoneCert = true;
                  }else{
                    MyData.isMaleFromPhoneCert = false;
                  }
                  MyData.birthFromPhoneCert = (resultMap["birth"] as String).split("-")[0]+(resultMap["birth"] as String).split("-")[1]+(resultMap["birth"] as String).split("-")[2];

                  confirmedName = _nameTextController.text.trim();
                  confirmedPhone = _phoneNumberTextController.text.trim();

                  // 가입 & 로그인
                  Map<String, dynamic> inputJson = {
                    "user" : {
                      "email": _emailTextController.text.trim(),
                      "password": _pwdTextController.text.trim(),
                      "password_confirmation": _pwdConfirmTextController.text.trim(),
                      "name" : _nameTextController.text.trim(),
                      "contact_no" : _phoneNumberTextController.text.trim(),
                      "telecom" : MyData.telecomTypeFromPhoneCert,
                      "birthday" : MyData.birthFromPhoneCert,
                      "gender" : MyData.isMaleFromPhoneCert? "1" : "2",
                    }
                  };
                  CommonUtils.log("i", "signup input :\n$inputJson");
                  if(context.mounted){
                    UiUtils.showLoadingPop(context);
                    LogfinController.callLogfinApi(LogfinApis.signUp, inputJson, (isSuccessToSignup, outputJson) async {
                      if(isSuccessToSignup){
                        isConfirmed = true;
                        GetController.to.updateConfirmed(isConfirmed);
                        CommonUtils.flutterToast("환영합니다!");
                        // 캐시 데이터 저장
                        await CommonUtils.saveSettingsToFile("push_from", "");
                        await CommonUtils.saveSettingsToFile("push_room_id", "");
                        await LogfinController.getMainViewInfo((isSuccessToGetMainInfo){
                          UiUtils.closeLoadingPop(context);
                          if(isSuccessToGetMainInfo){
                            CommonUtils.goToMain(context, _emailTextController.text.trim(), _pwdTextController.text.trim());
                          }
                        });
                      }else{
                        isConfirmed = false;
                        GetController.to.updateConfirmed(isConfirmed);
                        UiUtils.closeLoadingPop(context);
                        CommonUtils.flutterToast(outputJson!["error"]);
                      }
                    });
                  }
                }else{
                  isConfirmed = false;
                  CommonUtils.flutterToast("본인인증에 실패했습니다.");
                }
              });
            }else{
              CommonUtils.flutterToast("휴대전화 번호를 입력하세요.");
            }
          }) : Container()
    ]));
  }

  void back(){
    CommonUtils.hideKeyBoard();
    if(viewId == 1){
      Future.delayed(const Duration(milliseconds: 400), () async {
        Navigator.pop(context);
      });
    }else{
      setState(() {
        viewId = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Container(width: 100.w, height: 95.h, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w),
        child: viewId == 1 ? _getEmailAndPwInfoView() : _getPhoneValidView()
    );

    return UiUtils.getScrollViewWithAllowBackForAndroid(context, view, _scrollController, back);
  }

}