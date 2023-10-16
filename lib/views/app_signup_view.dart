import 'package:upfin/configs/string_config.dart';
import 'package:upfin/controllers/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/controllers/iamport_controller.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import '../controllers/sharedpreference_controller.dart';
import '../styles/TextStyles.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

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
  bool? allAgreed = false;
  bool? item1Agreed = false;
  bool? item1SubAgreed1 = false;
  bool? item1SubAgreed2 = false;
  bool? item2Agreed = false;
  bool? item2SubAgreed1 = false;
  bool? item2SubAgreed2 = false;

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
    _keyboardVisibilityController = null;
  }

  KeyboardVisibilityController? _keyboardVisibilityController;
  void _functionForKeyboardHide(){
    CommonUtils.hideKeyBoard();
    _scrollController.jumpTo(0);
  }
  void _functionForKeyboardShow(){
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
    _keyboardVisibilityController = CommonUtils.getKeyboardViewController(_functionForKeyboardShow, _functionForKeyboardHide);
    if(MyData.isSnsLogin){
      _nameTextController.text = MyData.nameFromSns;
      _emailTextController.text = MyData.emailFromSns;
      _phoneNumberTextController.text = MyData.phoneNumberFromSns;
    }
    isConfirmed = false;
    GetController.to.resetConfirmed();
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppSignUpViewState 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _unFocusAllNodes();
    _disposeAllTextControllers();
    GetController.to.resetConfirmed();
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

  void _getSmallAgree1Sub1Act(bool checkedValue){
    item1SubAgreed1 = checkedValue;
    if(item1SubAgreed1!){
      if(item1SubAgreed1! == item1SubAgreed2!){
        item1Agreed = true;
        if(item1Agreed == item2Agreed){
          allAgreed = true;
        }else{
          allAgreed = false;
        }
      }
    }else{
      item1Agreed = false;
      if(item1Agreed == item2Agreed){
        allAgreed = false;
      }
    }
  }
  void _getSmallAgree1Sub2Act(bool checkedValue){
    item1SubAgreed2 = checkedValue;
    if(item1SubAgreed2!){
      if(item1SubAgreed2! == item1SubAgreed1!){
        item1Agreed = true;
        if(item1Agreed == item2Agreed){
          allAgreed = true;
        }else{
          allAgreed = false;
        }
      }
    }else{
      item1Agreed = false;
      if(item1Agreed == item2Agreed){
        allAgreed = false;
      }
    }
  }
  void _getSmallAgree2Sub1Act(bool checkedValue){
    item2SubAgreed1 = checkedValue;
    if(item2SubAgreed1!){
      if(item2SubAgreed1! == item2SubAgreed2!){
        item2Agreed = true;
        if(item2Agreed == item1Agreed){
          allAgreed = true;
        }else{
          allAgreed = false;
        }
      }
    }else{
      item2Agreed = false;
      if(item2Agreed == item1Agreed){
        allAgreed = false;
      }
    }
  }
  void _getSmallAgree2Sub2Act(bool checkedValue){
    item2SubAgreed2 = checkedValue;
    if(item2SubAgreed2!){
      if(item2SubAgreed2! == item2SubAgreed1!){
        item2Agreed = true;
        if(item2Agreed == item1Agreed){
          allAgreed = true;
        }else{
          allAgreed = false;
        }
      }
    }else{
      item2Agreed = false;
      if(item2Agreed == item1Agreed){
        allAgreed = false;
      }
    }
  }
  Widget _getSmallAgreeInfoWidget(StateSetter thisSetState, String titleString, String contentsString, bool isAgreeCheck, Function(bool isCheck) callAct){
    return SizedBox(width: 100.w, height: 4.h, child: Row(children: [
      UiUtils.getMarginBox(10.w, 0),
      UiUtils.getBorderButtonBoxWithZeroPadding(80.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite, Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        isAgreeCheck? UiUtils.getCustomCheckBox(UniqueKey(), 1, isAgreeCheck, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinWhite,
            ColorStyles.upFinWhite, ColorStyles.upFinWhite, (checkedValue){
              thisSetState(() {
                if(checkedValue != null){
                  callAct(checkedValue);
                }
              });
            }) : UiUtils.getCustomCheckBox(UniqueKey(), 1, true, ColorStyles.upFinGray, ColorStyles.upFinWhite,
            ColorStyles.upFinWhite, ColorStyles.upFinWhite, (checkedValue){
              thisSetState(() {
                if(checkedValue != null){
                  if(!checkedValue) {
                    callAct(true);
                  }
                }
              });
            }),
        UiUtils.getTextButtonWithFixedScale(titleString, 10.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null, () async {
          Widget contentsWidget = Column(children: [
            SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(contentsString, 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null))
          ]);
          bool isAgree = await CommonUtils.moveToWithResult(context, AppView.appAgreeDetailInfoView.value, {"title": titleString, "contents" : contentsWidget}) as bool;
          thisSetState(() {
            callAct(isAgree);
          });
        }),
        const Spacer(flex: 2),
        UiUtils.getIconButton(Icons.arrow_forward_ios_rounded, 4.w, ColorStyles.upFinRealGray, () async {
          Widget contentsWidget = Column(children: [
            SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(contentsString, 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null))
          ]);
          bool isAgree = await CommonUtils.moveToWithResult(context, AppView.appAgreeDetailInfoView.value, {"title": titleString, "contents" : contentsWidget}) as bool;
          thisSetState(() {
            callAct(isAgree);
          });
        })
      ]), () async {})
    ]));
  }

  Widget _makeAgreeWidget(BuildContext thisContext, StateSetter thisSetState){
    return Material(child: Container(color: ColorStyles.upFinWhite,
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.end,children: [
            UiUtils.getIconButton(Icons.close, 7.w, ColorStyles.upFinDarkGray, () {
              Navigator.pop(thisContext);
            })
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start,children: [
            UiUtils.getTextWithFixedScale("업핀 서비스 약관동의", 16.sp, FontWeight.w800, ColorStyles.upFinBlack, TextAlign.center, null)
          ]),
          UiUtils.getMarginBox(0, 1.5.h),
          Wrap(children: [
            UiUtils.getTextWithFixedScale("서비스를 이용하기 위해 고객님의 서비스 이용약관에 동의가 필요합니다.", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)
          ]),
          UiUtils.getMarginBox(0, 3.h),
          GestureDetector(child: Container(color: ColorStyles.upFinWhiteGray, child: Row(
            children: [
              UiUtils.getCheckBox(1.2, allAgreed!, (isChanged) {
                thisSetState(() {
                  allAgreed = isChanged;
                  item1Agreed = isChanged;
                  item2Agreed = isChanged;
                  item1SubAgreed1 = isChanged;
                  item1SubAgreed2 = isChanged;
                  item2SubAgreed1 = isChanged;
                  item2SubAgreed2 = isChanged;
                });
              }),
              UiUtils.getTextWithFixedScale("전체동의", 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null)
            ],
          )),onTap: (){
            thisSetState(() {
              if(allAgreed!){
                allAgreed = false;
                item1Agreed = false;
                item1SubAgreed1 = false;
                item1SubAgreed2 = false;
                item2Agreed = false;
                item2SubAgreed1 = false;
                item2SubAgreed2 = false;
              }else{
                allAgreed = true;
                item1Agreed = true;
                item1SubAgreed1 = true;
                item1SubAgreed2 = true;
                item2Agreed = true;
                item2SubAgreed1 = true;
                item2SubAgreed2 = true;
              }
            });
          }),
          UiUtils.getMarginBox(0, 2.h),
          UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
            Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
              Container(padding: EdgeInsets.zero, height: 3.h, child: Row(
                children: [
                  UiUtils.getCheckBox(1.2, item1Agreed!, (isChanged) {
                    thisSetState(() {
                      item1Agreed = isChanged;
                      item1SubAgreed1 = isChanged;
                      item1SubAgreed2 = isChanged;
                      if(item1Agreed == item2Agreed){
                        allAgreed = isChanged;
                      }else{
                        allAgreed = false;
                      }
                    });
                  }),
                  UiUtils.getTextWithFixedScale("(필수)전체 동의하기", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null)
                ],
              )),
              _getSmallAgreeInfoWidget(thisSetState, "업핀 서비스 이용약관", StringConfig.agreeContents1, item1SubAgreed1!, _getSmallAgree1Sub1Act),
              _getSmallAgreeInfoWidget(thisSetState, "개인(신용)정보 수집 이용 제공 동의서", StringConfig.agreeContents1, item1SubAgreed2!, _getSmallAgree1Sub2Act),
            ]),
            UiUtils.getMarginBox(0, 2.h),
            Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
              Container(padding: EdgeInsets.zero, height: 3.h, child: Row(
                children: [
                  UiUtils.getCheckBox(1.2, item2Agreed!, (isChanged) {
                    thisSetState(() {
                      item2Agreed = isChanged;
                      item2SubAgreed1 = isChanged;
                      item2SubAgreed2 = isChanged;
                      if(item1Agreed == item2Agreed){
                        allAgreed = isChanged;
                      }else{
                        allAgreed = false;
                      }
                    });
                  }),
                  UiUtils.getTextWithFixedScale("(선택)전체 동의하기", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null)
                ],
              )),
              _getSmallAgreeInfoWidget(thisSetState, "마케팅 정보 수신 동의", StringConfig.agreeContents1, item2SubAgreed1!, _getSmallAgree2Sub1Act),
              _getSmallAgreeInfoWidget(thisSetState, "야간 마케팅 정보 수신 동의", StringConfig.agreeContents1, item2SubAgreed2!, _getSmallAgree2Sub2Act)
            ]),
          ])),
          UiUtils.getMarginBox(0, 3.h),
          item1Agreed!? UiUtils.getTextButtonBox(90.w, "동의하기", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {

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
              if(thisContext.mounted){
                Navigator.pop(thisContext);
                if(context.mounted){
                  UiUtils.showLoadingPop(context);
                  LogfinController.callLogfinApi(LogfinApis.signUp, inputJson, (isSuccessToSignup, outputJson) async {
                    if(isSuccessToSignup){
                      isConfirmed = true;
                      GetController.to.updateConfirmed(isConfirmed);
                      CommonUtils.flutterToast("환영합니다!");
                      // 캐시 데이터 저장
                      SharedPreferenceController.deleteAllData();
                      SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceIdKey, _emailTextController.text.trim());
                      SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferencePwKey, _pwdTextController.text.trim());
                      await LogfinController.getMainViewInfo((isSuccessToGetMainInfo){
                        UiUtils.closeLoadingPop(context);
                        if(isSuccessToGetMainInfo){
                          CommonUtils.moveWithReplacementTo(context, AppView.appMainView.value, null);
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
              }
            }else{
              isConfirmed = false;
              CommonUtils.flutterToast("본인인증에 실패했습니다.");
            }
          }) : UiUtils.getTextButtonBox(90.w, "동의하기", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinGray, () {})
        ])
    ));
  }

  Widget _getEmailAndPwInfoView(){
    return Form(key: _formKey1, child: UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButton(() {
          CommonUtils.hideKeyBoard();
          Navigator.pop(context);
        })
      ])),
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getMarginBox(0, 3.h),
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
          UiUtils.getInputDecoration("비밀번호 확인", 12.sp, "", 0.sp), (text) { }, (value){
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
          CommonUtils.hideKeyBoard();
          setState(() {
            viewId = 1;
          });
        }),
      ])) : UiUtils.getMarginBox(0, 7.h)),
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getMarginBox(0, 3.h),
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
              UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, true, 100.w, 62.h, 0.5, _makeAgreeWidget);
            }else{
              CommonUtils.flutterToast("휴대전화 번호를 입력하세요.");
            }
          }) : Container()
    ]));
  }

  void back(){
    CommonUtils.hideKeyBoard();
    if(viewId == 1){
      Navigator.pop(context);
    }else{
      setState(() {
        viewId = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Container(width: 100.w, height: 95.h, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w),
        child: viewId == 1 ? _getEmailAndPwInfoView() : _getPhoneValidView()
    );

    return UiUtils.getScrollViewWithAllowBackForAndroid(context, view, _scrollController, back);
  }

}