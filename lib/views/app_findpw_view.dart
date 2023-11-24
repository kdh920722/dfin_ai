import 'package:upfin/controllers/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/controllers/iamport_controller.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import '../controllers/firebase_controller.dart';
import '../controllers/sharedpreference_controller.dart';
import '../styles/TextStyles.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppFindPwView extends StatefulWidget{
  @override
  AppFindPwViewState createState() => AppFindPwViewState();
}

class AppFindPwViewState extends State<AppFindPwView> with WidgetsBindingObserver{
  static int viewId = 1;
  bool isPwShowValid = false;
  bool isPhoneShowValid = false;
  bool isButtonValid = false;
  bool isView1Valid = false;

  final ScrollController _scrollController = ScrollController();
  final _formKeyForEmail = GlobalKey<FormState>();
  bool isEmailValid = false;
  bool isEmailViewValid = false;
  String confirmedEmail = "";
  String foundedEmail = "";
  final _formKeyForVerify = GlobalKey<FormState>();
  bool isVerifyViewValid = false;
  final _formKeyForSignIn = GlobalKey<FormState>();
  bool isSignInViewValid = false;

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _verifyCodeTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _phoneNumberTextController = TextEditingController();
  final _pwdTextController = TextEditingController();
  final _pwdConfirmTextController = TextEditingController();

  final _nameTextFocus = FocusNode();
  final _verifyCodeTextFocus = FocusNode();
  final _emailTextFocus = FocusNode();
  final _phoneNumberTextFocus = FocusNode();
  final _pwdTextFocus = FocusNode();
  final _pwdConfirmFocus = FocusNode();

  bool isConfirmed = false;
  String confirmedName = "";
  String confirmedPhone = "";

  void _unFocusAllNodes(){
    _nameTextFocus.unfocus();
    _verifyCodeTextFocus.unfocus();
    _emailTextFocus.unfocus();
    _phoneNumberTextFocus.unfocus();
    _pwdTextFocus.unfocus();
    _pwdConfirmFocus.unfocus();
  }

  void _disposeAllTextControllers(){
    _nameTextController.dispose();
    _verifyCodeTextController.dispose();
    _phoneNumberTextController.dispose();
    _emailTextController.dispose();
    _pwdTextController.dispose();
    _pwdConfirmTextController.dispose();
  }

  @override
  void initState(){
    CommonUtils.log("i", "AppFindPwViewState 화면 입장");
    super.initState();
    confirmedName = "X";
    confirmedPhone = "X";
    WidgetsBinding.instance.addObserver(this);
    _emailTextController.addListener(_emailListener);
    _verifyCodeTextController.addListener(_verifyCodeListener);
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
    CommonUtils.log("i", "AppFindPwViewState 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _unFocusAllNodes();
    _disposeAllTextControllers();
    GetController.to.resetConfirmed();
    Config.contextForEmergencyBack = null;
    _emailTextController.text = "";
    _pwdTextController.text = "";
    _pwdConfirmTextController.text = "";
    _phoneNumberTextController.text = "";
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('i','AppFindPwViewState resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('i','AppFindPwViewState inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('i','AppFindPwViewState detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('i','AppFindPwViewState paused');
        break;
      default:
        break;
    }
  }

  void _verifyCodeListener() {
    if(_verifyCodeTextController.text.trim() != ""){

    }
  }

  void _emailListener() {
    String email = _emailTextController.text.trim();
    if(email != "" && email.length >= 5){
      if(confirmedEmail != "" && email == confirmedEmail){
        setState(() {
          isVerifyViewValid = true;
          isEmailValid = true;
          isEmailViewValid = true;
        });
      }else{
        setState(() {
          isVerifyViewValid = false;
          isEmailValid = false;
          isEmailViewValid = true;
        });
      }
    }else{
      setState(() {
        isVerifyViewValid = false;
        isEmailValid = false;
        isEmailViewValid = false;
      });
    }
  }

  void _pwListener() {
    if(_pwdConfirmTextController.text.trim() != ""){

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

  Widget _getEmailView(){
    return Form(key: _formKeyForEmail, child: UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButtonForMainView(() {
          back();
        })
      ])),
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getMarginBox(0, 3.w),
        isVerifyViewValid? UiUtils.getTextWithFixedScale("이메일로 전송된", 26.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, null)
            : UiUtils.getTextWithFixedScale("비밀번호 찾기", 26.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, null),
        isVerifyViewValid? UiUtils.getMarginBox(0, 0.5.h)
            : UiUtils.getMarginBox(0, 0),
        isVerifyViewValid? UiUtils.getTextWithFixedScale("인증번호를 입력하세요.", 26.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, null)
            : UiUtils.getMarginBox(0, 0),
        UiUtils.getMarginBox(0, 3.h)
      ])),
      UiUtils.getTextFormField(context, 90.w, TextStyles.upFinTextFormFieldTextStyle, _emailTextFocus, _emailTextController, TextInputType.emailAddress, false,
          UiUtils.getInputDecoration("이메일", 12.sp, "", 0.sp), (text) { }, (value){
            return null;
          }),
      UiUtils.getMarginBox(0, 2.h),
      isVerifyViewValid? Column(children: [
        UiUtils.getTextFormField(context, 90.w, TextStyles.upFinTextFormFieldTextStyle, _verifyCodeTextFocus, _verifyCodeTextController, TextInputType.number, false,
            UiUtils.getInputDecoration("인증번호", 12.sp, "", 0.sp), (text) { }, (value){
              return null;
            }),
        UiUtils.getMarginBox(0, 2.h),
        SizedBox(width: 90.w, child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
          UiUtils.getTextWithFixedScale2(
              "• 인증번호 수신까지 시간이 1~2분 정도 소요될 수 있어요.", 10.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null),
          UiUtils.getMarginBox(0, 0.5.h),
          UiUtils.getTextWithFixedScale2(
              "• 수신이 되지 않는 경우, 스팸 메일함을 확인 해 주세요.", 10.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null),
        ]))
      ]) : Container(),
      UiUtils.getExpandedScrollView(Axis.vertical, Container()),
      isEmailValid? UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () {
        if(_verifyCodeTextController.text.trim() != "" && _verifyCodeTextController.text.trim().length >=5){
          Map<String, dynamic> inputJson3 = {
            "email": _emailTextController.text.trim(),
            "verification_code": _verifyCodeTextController.text.trim(),
          };
          UiUtils.showLoadingPop(context);
          LogfinController.callLogfinApi(LogfinApis.checkEmailCode, inputJson3, (isSuccess, outputJson){
            UiUtils.closeLoadingPop(context);
            if(isSuccess){
              CommonUtils.flutterToast("인증되었어요.");
              setState(() {
                viewId = 2;
              });
            }else{
              CommonUtils.flutterToast("인증번호를 확인해주세요.");
            }
          });
        }else{
          CommonUtils.flutterToast("인증번호를 확인해주세요.");
        }

      }) : Container(),
      UiUtils.getMarginBox(0, 1.h),
      isEmailViewValid? UiUtils.getBorderButtonBox(90.w, isEmailValid? ColorStyles.upFinWhiteSky : ColorStyles.upFinButtonBlue,
          isEmailValid? ColorStyles.upFinWhiteSky : ColorStyles.upFinButtonBlue,
          UiUtils.getTextWithFixedScale(isEmailValid? "인증번호 재발송":"인증번호 발송", 14.sp, FontWeight.w500,
              isEmailValid? ColorStyles.upFinButtonBlue : ColorStyles.upFinWhite, TextAlign.center, null), () {
            if(CommonUtils.isEmailValid(_emailTextController.text.trim())){
              CommonUtils.hideKeyBoard();
              Map<String, dynamic> inputJson = {
                "email": _emailTextController.text.trim(),
              };
              UiUtils.showLoadingPop(context);
              LogfinController.callLogfinApi(LogfinApis.checkMember, inputJson, (isSuccess, outputJson){
                if(!isSuccess){
                  CommonUtils.flutterToast("인증번호를 발송해요.");
                  _verifyCodeTextController.text = "";
                  LogfinController.callLogfinApi(LogfinApis.sendEmailCode, inputJson, (isSuccess, outputJson){
                    UiUtils.closeLoadingPop(context);
                    if(isSuccess){
                      setState(() {
                        confirmedEmail = _emailTextController.text.trim();
                        isEmailValid = true;
                        isVerifyViewValid = true;
                      });
                    }else{
                      setState(() {
                        confirmedEmail = "";
                        isEmailValid = false;
                        isVerifyViewValid = false;
                      });
                    }
                  });
                }else{
                  UiUtils.closeLoadingPop(context);
                  setState(() {
                    confirmedEmail = "";
                    isEmailValid = false;
                    isVerifyViewValid = false;
                  });
                  CommonUtils.flutterToast("존재하지 않는 이메일이에요.");
                }
              });
            }else{
              setState(() {
                confirmedEmail = "";
                isEmailValid = false;
                isVerifyViewValid = false;
              });
              CommonUtils.flutterToast("이메일을 확인해주세요.");
            }
          }) : Container(),
    ]));
  }

  Widget _getPwInfoView(){
    return Form(key: _formKeyForSignIn, child: UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButtonForMainView(() {
          back();
        })
      ])),
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getMarginBox(0, 3.w),
        UiUtils.getTextWithFixedScale("비밀번호 변경", 26.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, null),
        UiUtils.getMarginBox(0, 3.h)
      ])),
      UiUtils.getTextFormField(context, 90.w, TextStyles.upFinTextFormFieldTextStyle, _pwdTextFocus, _pwdTextController, TextInputType.visiblePassword, true,
          UiUtils.getInputDecoration("새로운 비밀번호", 12.sp, "", 0.sp), (text) { }, (value){
            if(value != null && value.trim().isEmpty){
              return "비밀번호를 입력하세요.";
            }else{
              if(value!.trim().length <= 6){
                return "비밀번호는 6자를 넘어야 합니다.";
              }else{
                return null;
              }
            }
      }),
      UiUtils.getMarginBox(0, 2.h),
      UiUtils.getTextFormField(context, 90.w, TextStyles.upFinTextFormFieldTextStyle, _pwdConfirmFocus, _pwdConfirmTextController, TextInputType.visiblePassword, true,
          UiUtils.getInputDecoration("새로운 비밀번호 확인", 12.sp, "", 0.sp), (text) { }, (value){
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
      }),
      UiUtils.getExpandedScrollView(Axis.vertical, Container()),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () {
        if(_formKeyForSignIn.currentState!.validate()){
          CommonUtils.hideKeyBoard();
          Map<String, dynamic> inputJson4 = {
            "user":{
              "email": confirmedEmail, // 사용자의 이메일 주소
              "password": _pwdTextController.text.trim(),             // 새 비밀번호
              "password_confirmation": _pwdConfirmTextController.text.trim() // 새 비밀번호 확인
            }
          };
          UiUtils.showLoadingPop(context);
          LogfinController.callLogfinApi(LogfinApis.updatePassword, inputJson4, (isSuccess, outputJson){
            if(isSuccess){
              SharedPreferenceController.deleteValidAutoLoginData();
              DateTime thirtyMinutesLater = CommonUtils.addTimeToTargetTime(CommonUtils.getCurrentLocalTime());
              SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceValidDateKey, CommonUtils.convertTimeToString(thirtyMinutesLater));
              SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferencePwKey, "");
              SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceIsSnsLogin, "N");
              UiUtils.closeLoadingPop(context);
              setState(() {
                viewId = 3;
              });
            }else{
              UiUtils.closeLoadingPop(context);
              CommonUtils.flutterToast("비밀번호 변경에 실패했어요.");
            }
          });
        }else{
          if(_pwdTextController.text.trim() == _pwdConfirmTextController.text.trim() && _pwdTextController.text.length <= 6){
            CommonUtils.flutterToast("비밀번호는 6자를 넘어야 해요.");
          }else{
            CommonUtils.flutterToast("입력하신 정보를\n다시 확인 해 주세요.");
          }
        }
      })
    ]));
  }

  Widget _getConfirmedView(){
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      UiUtils.getMarginBox(0, 36.h),
      UiUtils.getCustomCircleCheckBox(UniqueKey(),4, true, ColorStyles.upFinWhite, ColorStyles.upFinButtonBlue,
          ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue, (checkedValue){}),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextWithFixedScale("변경이 완료되었습니다.", 14.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, null),
      UiUtils.getExpandedScrollView(Axis.vertical, Container()),
      UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
          UiUtils.getTextWithFixedScale("확인", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null), () {
            Navigator.pop(context);
          })
    ]);
  }

  Widget _getConfirmedViewForId(){
    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getMarginBox(0, 11.w),
        UiUtils.getTextWithFixedScale("등록된 아이디", 26.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, null),
        UiUtils.getMarginBox(0, 3.h)
      ])),
      UiUtils.getDisabledTextField(context, 90.w, foundedEmail, TextStyles.upFinTextFormFieldTextStyle, UiUtils.getInputDecoration("이메일", 12.sp, "", 0.sp)),
      UiUtils.getExpandedScrollView(Axis.vertical, Container()),
      UiUtils.getTextButtonBox(90.w, "확인", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () {
        CommonUtils.backToHome(context);
      })
    ]);
  }

  Widget _getPhoneValidView(){
    return Form(key: _formKey2, child: UiUtils.getRowColumnWithAlignCenter([
      Obx(()=>!GetController.to.isConfirmed.value? SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButtonForMainView(() async {
          back();
        }),
      ])) : UiUtils.getMarginBox(0, 7.h)),
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getMarginBox(0, 3.w),
        UiUtils.getTextWithFixedScale("아이디 찾기", 26.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, null),
        UiUtils.getMarginBox(0, 3.h)
      ])),
      UiUtils.getTextFormField(context, 90.w, TextStyles.upFinTextFormFieldTextStyle, _nameTextFocus, _nameTextController, TextInputType.text, false,
          UiUtils.getInputDecoration("이름", 12.sp, "", 0.sp), (text) { }, (value){
            if(value != null && value.trim().isEmpty){
              return "이름을 입력하세요.";
            }else{
              return null;
            }
          }),
      UiUtils.getMarginBox(0, 2.h),
      isPhoneShowValid? UiUtils.getTextFormField(context, 90.w, TextStyles.upFinTextFormFieldTextStyle, _phoneNumberTextFocus, _phoneNumberTextController, TextInputType.phone, false,
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
              Map<String, dynamic> inputJson4 = {
                "contact_no": _phoneNumberTextController.text.trim(),
              };
              UiUtils.showLoadingPop(context);
              LogfinController.callLogfinApi(LogfinApis.checkMemberByPhone, inputJson4, (isSuccess, outputJson) async {
                UiUtils.closeLoadingPop(context);
                if(!isSuccess){
                  Map<String, String> inputJsonForCert = {
                    "carrier": "",
                    "name" : _nameTextController.text.trim(),
                    "phone" : _phoneNumberTextController.text.trim()
                  };
                  var result = await CommonUtils.moveToWithResult(context, AppView.appCertificationView.value, inputJsonForCert);
                  if(result != null){
                    CommonUtils.flutterToast("인증 성공");
                    confirmedName = _nameTextController.text.trim();
                    confirmedPhone = _phoneNumberTextController.text.trim();

                    if(context.mounted){
                      UiUtils.showLoadingPop(context);
                      Map<String, dynamic> inputJson1 = {
                        "contact_no": confirmedPhone,
                        "name": confirmedName
                      };
                      LogfinController.callLogfinApi(LogfinApis.findEmail, inputJson1, (isSuccess, outputJson){
                        UiUtils.closeLoadingPop(context);
                        if(isSuccess){
                          setState(() {
                            String tempEmail = outputJson!["email"];
                            List<String> tempEmailList = tempEmail.split("@");
                            if(tempEmailList[0].length == 2){
                              tempEmail = "${tempEmailList[0].substring(0,1)}•";
                            }else if(tempEmailList[0].length == 3){
                              tempEmail = "${tempEmailList[0].substring(0,1)}•${tempEmailList[0].substring(2)}";
                            }else if(tempEmailList[0].length == 4){
                              tempEmail = "${tempEmailList[0].substring(0,2)}•${tempEmailList[0].substring(3)}";
                            }else if(tempEmailList[0].length == 5){
                              tempEmail = "${tempEmailList[0].substring(0,2)}••${tempEmailList[0].substring(4)}";
                            }else if(tempEmailList[0].length == 6){
                              tempEmail = "${tempEmailList[0].substring(0,2)}•••${tempEmailList[0].substring(5)}";
                            }else if(tempEmailList[0].length == 7){
                              tempEmail = "${tempEmailList[0].substring(0,3)}•••${tempEmailList[0].substring(6)}";
                            }else{
                              tempEmail = "${tempEmailList[0].substring(0,3)}•••${tempEmailList[0].substring(7)}";
                            }
                            foundedEmail = "$tempEmail@${tempEmailList[1]}";
                            viewId = 5;
                          });
                        }else{
                          CommonUtils.flutterToast("이메일을 찾지 못했어요.");
                        }
                      });
                    }
                  }else{
                    isConfirmed = false;
                    CommonUtils.flutterToast("본인인증에 실패했어요.");
                  }
                }else{
                  CommonUtils.flutterToast("등록되지 않은 전화번호에요.");
                }
              });
            }else{
              CommonUtils.flutterToast("휴대전화 번호를 입력하세요.");
            }
          }) : Container()
    ]));
  }

  bool backValid = true;
  void back(){
    if(viewId < 3){
      if(backValid){
        backValid = false;
        CommonUtils.hideKeyBoard();
        if(viewId == 1){
          Navigator.pop(context);
        }else{
          viewId--;
          setState(() {});
        }
        Future.delayed(const Duration(milliseconds: 200), () async {
          backValid = true;
        });
      }
    }else if(viewId == 4){
      if(backValid){
        backValid = false;
        CommonUtils.hideKeyBoard();
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: 200), () async {
          backValid = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Container(width: 100.w, height: Config.isAndroid? 95.h: 90.h, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w),
        child: viewId == 1 ? _getEmailView() : viewId == 2 ? _getPwInfoView() : viewId == 3 ? _getConfirmedView() : viewId == 4 ? _getPhoneValidView() : _getConfirmedViewForId());


    return UiUtils.getScrollViewWithAllowBackForAndroid(context, view, _scrollController, back);
  }

}