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
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _phoneNumberTextController = TextEditingController();
  final _pwdTextController = TextEditingController();
  final _pwdConfirmTextController = TextEditingController();
  final _loanWantPriceTextController = TextEditingController();

  final _nameTextFocus = FocusNode();
  final _emailTextFocus = FocusNode();
  final _phoneNumberTextFocus = FocusNode();
  final _pwdTextFocus = FocusNode();
  final _pwdConfirmFocus = FocusNode();

  String confirmedName = "";
  String confirmedPhone = "";
  bool? allAgreed = false;
  bool? item1Agreed = false;
  bool? item2Agreed = false;

  void _unFocusAllNodes(){
    _nameTextFocus.unfocus();
    _emailTextFocus.unfocus();
    _phoneNumberTextFocus.unfocus();
    _pwdTextFocus.unfocus();
    _pwdConfirmFocus.unfocus();
  }

  void _disposeAllTextControllers(){
    _loanWantPriceTextController.dispose();
    _nameTextController.dispose();
    _phoneNumberTextController.dispose();
    _emailTextController.dispose();
    _keyboardVisibilityController = null;
  }

  KeyboardVisibilityController? _keyboardVisibilityController;
  void _functionForKeyboardHide(){
    CommonUtils.log("i", "HIDE");
    CommonUtils.hideKeyBoard();
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
    _loanWantPriceTextController.addListener(_formatInputValue);
    _nameTextController.addListener(_nameListener);
    _phoneNumberTextController.addListener(_phoneListener);
    _keyboardVisibilityController = CommonUtils.getKeyboardViewController(_functionForKeyboardShow, _functionForKeyboardHide);
    _nameTextController.text = MyData.name;
    _emailTextController.text = MyData.email;
    _phoneNumberTextController.text = MyData.phoneNumber;
  }

  @override
  void dispose(){
    CommonUtils.log("i", "새 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _unFocusAllNodes();
    _disposeAllTextControllers();
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

  void _nameListener() {
    if(_nameTextController.text.trim() != confirmedName){
      MyData.confirmed = false;
      GetController.to.updateConfirmed(MyData.confirmed);
    }else{
      MyData.confirmed = true;
      GetController.to.updateConfirmed(MyData.confirmed);
    }
  }

  void _phoneListener() {
    if(_phoneNumberTextController.text.trim() != confirmedPhone){
      MyData.confirmed = false;
      GetController.to.updateConfirmed(MyData.confirmed);
    }else{
      MyData.confirmed = true;
      GetController.to.updateConfirmed(MyData.confirmed);
    }
  }

  void _formatInputValue() {
    final text = _loanWantPriceTextController.text.trim();
    final number = double.tryParse(text.replaceAll(',', '')); // 콤마 제거 후 숫자 변환
    if (number != null) {
      final formattedText = CommonUtils.getPriceCommaFormattedString(number);
      if (formattedText != text) {
        _loanWantPriceTextController.value = TextEditingValue(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      }
    }
  }

  Widget makeAgreeWidget(BuildContext thisContext, StateSetter thisSetState){
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
          Container(color: ColorStyles.upFinWhiteGray, child: Row(
            children: [
              UiUtils.getCircleCheckBox(1.4, allAgreed!, (isChanged) {
                thisSetState(() {
                  allAgreed = isChanged;
                  item1Agreed = isChanged;
                  item2Agreed = isChanged;
                });
              }),
              UiUtils.getTextWithFixedScale("전체동의", 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null)
            ],
          )),
          UiUtils.getMarginBox(0, 2.h),
          Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
            Container(padding: EdgeInsets.only(left: 5.w), height: 3.h, child: Row(
              children: [
                UiUtils.getCircleCheckBox(1, item1Agreed!, (isChanged) {
                  thisSetState(() {
                    item1Agreed = isChanged;
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
            Container(padding: EdgeInsets.only(left: 20.w), height: 3.5.h, child: Row(children: [
              UiUtils.getTextWithIconStyledButtonWithFixedScale(TextDirection.rtl, "업핀 서비스 이용약관", 12.sp, FontWeight.w500, ColorStyles.upFinDarkWhiteGray, TextAlign.start, null,
                  Icons.arrow_back_ios, 3.5.w, ColorStyles.upFinDarkWhiteGray, (){

              }),
            ])),
            Container(padding: EdgeInsets.only(left: 20.w), height: 3.5.h, child: Row(children: [
              UiUtils.getTextWithIconStyledButtonWithFixedScale(TextDirection.rtl, "개인(신용)정보 수집 이용 제공 동의서", 12.sp, FontWeight.w500, ColorStyles.upFinDarkWhiteGray, TextAlign.start, null,
                  Icons.arrow_back_ios, 3.5.w, ColorStyles.upFinDarkWhiteGray, (){

                  }),
            ]))
          ]),
          UiUtils.getMarginBox(0, 2.h),
          Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
            Container(padding: EdgeInsets.only(left: 5.w), height: 3.h, child: Row(
              children: [
                UiUtils.getCircleCheckBox(1, item2Agreed!, (isChanged) {
                  thisSetState(() {
                    item2Agreed = isChanged;
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
            Container(padding: EdgeInsets.only(left: 20.w), height: 3.5.h, child: Row(children: [
              UiUtils.getTextWithIconStyledButtonWithFixedScale(TextDirection.rtl, "마케팅 정보 수신 동의", 12.sp, FontWeight.w500, ColorStyles.upFinDarkWhiteGray, TextAlign.start, null,
                  Icons.arrow_back_ios, 3.5.w, ColorStyles.upFinDarkWhiteGray, (){

                  }),
            ])),
            Container(padding: EdgeInsets.only(left: 20.w), height: 3.5.h, child: Row(children: [
              UiUtils.getTextWithIconStyledButtonWithFixedScale(TextDirection.rtl, "야간 마케팅 정보 수신 동의", 12.sp, FontWeight.w500, ColorStyles.upFinDarkWhiteGray, TextAlign.start, null,
                  Icons.arrow_back_ios, 3.5.w, ColorStyles.upFinDarkWhiteGray, (){

                  }),
            ]))
          ]),
          UiUtils.getMarginBox(0, 5.h),
          item1Agreed!? UiUtils.getTextButtonBox(90.w, "동의하기", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () {
            // 1) 가입 & 로그인
            Map<String, dynamic> inputJson = {
              "user" : {
                "email": _emailTextController.text.trim(),
                "password": _pwdTextController.text.trim(),
                "password_confirmation": _pwdConfirmTextController.text.trim(),
                "name" : _nameTextController.text.trim(),
                "contact_no" : _phoneNumberTextController.text.trim(),
                "telecom" : MyData.carrierType
              }
            };
            CommonUtils.log("i", "${UiUtils.isLoadingPopOn}");
            UiUtils.showLoadingPop(thisContext);
            LogfinController.callLogfinApi(LogfinApis.signUp, inputJson, (isSuccessToSignup, outputJson) async {
              if(isSuccessToSignup){
                CommonUtils.flutterToast("환영합니다!");
                // 캐시 데이터 저장
                SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceIdKey, _emailTextController.text.trim());
                SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferencePwKey, _pwdTextController.text.trim());
                await LogfinController.getMainOrSearchView(context, (isSuccessToGetViewInfo, viewInfo){
                  UiUtils.closeLoadingPop(thisContext);
                  if(isSuccessToGetViewInfo){
                    CommonUtils.moveWithRemoveUntil(context, viewInfo!.value, null);
                  }
                });
              }else{
                UiUtils.closeLoadingPop(thisContext);
                CommonUtils.flutterToast("회원가입에 실패했습니다.");
              }
            });
          }) : UiUtils.getTextButtonBox(90.w, "동의하기", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinGray, () {})
        ])
    ));
  }

  @override
  Widget build(BuildContext context) {
    CommonUtils.hideKeyBoard();
    CommonUtils.log("i", "signup : ${UiUtils.isLoadingPopOn}");

    Widget view = Container(width: 100.w, height: 100.h, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UiUtils.getIconButton(Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () {
            Navigator.pop(context);
          }),
          Form(key: _formKey, child: UiUtils.getRowColumnWithAlignCenter([
            UiUtils.getMarginBox(0, 3.h),
            SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("회원가입", 24.sp, FontWeight.w700, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
            UiUtils.getMarginBox(0, 5.h),
            UiUtils.getTextFormField(90.w, TextStyles.upFinTextFormFieldTextStyle, _nameTextFocus, _nameTextController, TextInputType.text, false, UiUtils.getInputDecoration("이름", ""), (text) { }, (value){
              if(value != null && value.trim().isEmpty){
                return "이름을 입력하세요.";
              }else{
                return null;
              }
            }),
            UiUtils.getMarginBox(0, 2.h),
            UiUtils.getTextFormField(90.w, TextStyles.upFinTextFormFieldTextStyle, _emailTextFocus, _emailTextController, TextInputType.emailAddress, false, UiUtils.getInputDecoration("이메일", ""), (text) { }, (value){
              if(value != null && value.trim().isEmpty){
                return "이메일을 입력하세요.";
              }else{
                return null;
              }
            }),
            UiUtils.getMarginBox(0, 2.h),
            SizedBox(width: 90.w, child: Row(children: [
              UiUtils.getTextFormField(50.w, TextStyles.upFinTextFormFieldTextStyle, _phoneNumberTextFocus, _phoneNumberTextController, TextInputType.phone, false, UiUtils.getInputDecoration("휴대전화 번호", ""), (text) { }, (value){
                if(value != null && value.trim().isEmpty){
                  return "휴대전화 번호를 입력하세요.";
                }else{
                  return null;
                }
              }),
              UiUtils.getMarginBox(2.w, 0),
              Obx(()=>!GetController.to.isConfirmed.value?
              Expanded(child: UiUtils.getTextCustomPaddingButtonBox(38.w, "본인인증", TextStyles.upFinSmallButtonTextStyle,
                  EdgeInsets.only(left: 2.5.w, right: 2.5.w, top: 5.w, bottom: 5.w), ColorStyles.upFinButtonBlue, () async {
                    if(_phoneNumberTextController.text.trim() != ""){
                      Map<String, String> inputJson = {
                        "carrier": "",
                        "name" : _nameTextController.text.trim(),
                        "phone" : _phoneNumberTextController.text.trim()
                      };
                      var result = await CommonUtils.moveToWithResult(context, AppView.certificationView.value, inputJson);
                      if(result != null){
                        MyData.confirmed = true;
                        Map<String, dynamic> resultMap = result as Map<String, dynamic>;
                        for(var each in IamportController.carrierList){
                          if(each.split("@")[0] == resultMap["carrier"]){
                            MyData.carrierType = each.split("@")[1];
                            CommonUtils.log('i', 'carrierType : ${MyData.carrierType}');
                          }
                        }
                      }else{
                        MyData.confirmed = false;
                      }

                      if(MyData.confirmed) {
                        CommonUtils.flutterToast("인증 성공");
                        confirmedName = _nameTextController.text.trim();
                        confirmedPhone = _phoneNumberTextController.text.trim();
                      }else{
                        CommonUtils.flutterToast("인증 실패");
                      }
                      GetController.to.updateConfirmed(MyData.confirmed);
                    }else{
                      CommonUtils.flutterToast("휴대전화 번호를 입력하세요.");
                    }
                  })) :
              Expanded(child: UiUtils.getTextCustomPaddingButtonBox(38.w, "인증완료", TextStyles.upFinSmallButtonTextStyle,
                  EdgeInsets.only(left: 2.5.w, right: 2.5.w, top: 5.w, bottom: 5.w), ColorStyles.upFinGray, () {})))
            ])),
            UiUtils.getMarginBox(0, 2.h),
            UiUtils.getTextFormField(90.w, TextStyles.upFinTextFormFieldTextStyle, _pwdTextFocus, _pwdTextController, TextInputType.visiblePassword, true, UiUtils.getInputDecoration("비밀번호", ""), (text) { }, (value){
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
            UiUtils.getTextFormField(90.w, TextStyles.upFinTextFormFieldTextStyle, _pwdConfirmFocus, _pwdConfirmTextController, TextInputType.visiblePassword, true, UiUtils.getInputDecoration("비밀번호 확인", ""), (text) { }, (value){
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
            UiUtils.getMarginBox(0, 2.h),

            /*
              Obx(()=>UiUtils.getTextFormField(80.w, _loanWantPriceTextController, TextInputType.number, false,
                  UiUtils.getInputDecoration("대출희망금액(단위:만원)", GetController.to.wantLoanPrice.value),
                  (text) {
                     if(text.trim() != ""){
                       final number = double.tryParse(text.replaceAll(',', '')); // 콤마 제거 후 숫자 변환
                       GetController.to.updateWantLoanPrice(CommonUtils.getPriceFormattedString(number!));
                     }else{
                       GetController.to.updateWantLoanPrice("만원");
                     }
                  }, (value){
                    if(value != null && value.trim().isEmpty){
                      return "희망하시는 대출금액을 입력하세요.";
                    }else{
                      return null;
                    }
              })),
               */
            UiUtils.getMarginBox(0, 10.h),
            UiUtils.getTextButtonBox(90.w, "가입하기", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () {
              if(_formKey.currentState!.validate() && MyData.confirmed){
                CommonUtils.log("i", "OK");
                CommonUtils.hideKeyBoard();
                _unFocusAllNodes();
                CommonUtils.log("i", "${UiUtils.isLoadingPopOn}");
                UiUtils.showSlideMenu(context, SlideType.bottomToTop, false, 100.w, 70.h, 0.5, makeAgreeWidget);
              }else{
                if(!MyData.confirmed){
                  CommonUtils.flutterToast("휴대전화 본인인증이 필요합니다.");
                }else{
                  if(_pwdTextController.text.trim() == _pwdConfirmTextController.text.trim() && _pwdTextController.text.length <= 6){
                    CommonUtils.flutterToast("비밀번호는 6자를 넘어야 합니다.");
                  }else{
                    CommonUtils.flutterToast("입력하신 정보를\n다시 확인 해 주세요.");
                  }
                }
              }
            })
          ])),
        ])
    );

    return UiUtils.getViewWithScroll(context, view, _scrollController, CommonUtils.onWillPopForPreventBackButton);
  }

}