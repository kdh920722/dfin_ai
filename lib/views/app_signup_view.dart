import 'package:upfin/controllers/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
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
  final _pwdTextController = TextEditingController();
  final _pwdConfirmTextController = TextEditingController();
  final _loanWantPriceTextController = TextEditingController();

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
    _loanWantPriceTextController.addListener(_formatInputValue);
    _keyboardVisibilityController = CommonUtils.getKeyboardViewController(_functionForKeyboardShow, _functionForKeyboardHide);
  }

  @override
  void dispose(){
    CommonUtils.log("i", "새 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _loanWantPriceTextController.dispose();
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

  void _formatInputValue() {
    final text = _loanWantPriceTextController.text;
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

  @override
  Widget build(BuildContext context) {
    CommonUtils.log('i','build?');
    Widget view = Container(width: 100.w, height: 100.h, color: ColorStyles.upFinWhite, padding: const EdgeInsets.all(20),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Form(key: _formKey, child:
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(width: 80.w, child: UiUtils.getTextWithFixedScale("본인정보", 24.sp, FontWeight.w700, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
              UiUtils.getMarginBox(0, 5.h),
              UiUtils.getEnabledTextField(80.w, MyData.name, UiUtils.getInputDecoration("이름","")),
              UiUtils.getMarginBox(0, 1.h),
              UiUtils.getEnabledTextField(80.w, MyData.email, UiUtils.getInputDecoration("이메일","")),
              UiUtils.getMarginBox(0, 1.h),
              SizedBox(width: 80.w, child: Row(children: [
                UiUtils.getEnabledTextField(40.w, MyData.phoneNumber, UiUtils.getInputDecoration("휴대전화 번호","")),
                UiUtils.getMarginBox(2.w, 0),
                  Obx(()=>!GetController.to.isConfirmed.value?
                  Expanded(child: UiUtils.getTextCustomPaddingButtonBox(38.w, "본인인증", TextStyles.upFinSmallButtonTextStyle,
                    const EdgeInsets.only(left: 10, right: 10, top: 21, bottom: 21), ColorStyles.upFinButtonBlue, () async {
                        Map<String, String> inputJson = {
                          "carrier": "",
                          "name" : MyData.name,
                          "phone" : MyData.phoneNumber
                        };
                        var result = await CommonUtils.moveToWithResult(context, AppView.certificationView.value, inputJson);
                        CommonUtils.log("i","${result as bool}");
                        MyData.confirmed = result as bool;
                        if(MyData.confirmed) {
                          CommonUtils.flutterToast("인증 성공");
                        }else{
                          CommonUtils.flutterToast("인증 실패");
                        }
                        GetController.to.updateConfirmed(MyData.confirmed);
                    })) :
                  Expanded(child: UiUtils.getTextCustomPaddingButtonBox(38.w, "인증완료", TextStyles.upFinSmallButtonTextStyle,
                    const EdgeInsets.only(left: 10, right: 10, top: 21, bottom: 21), ColorStyles.upFinGray, () {})))
              ])),
              UiUtils.getMarginBox(0, 4.h),
              UiUtils.getTextFormField(80.w, _pwdTextController, TextInputType.visiblePassword, true, UiUtils.getInputDecoration("비밀번호", ""), (text) { }, (value){
                if(value != null && value.trim().isEmpty){
                  return "비밀번호를 입력하세요.";
                }else{
                  return null;
                }
              }),
              UiUtils.getMarginBox(0, 2.h),
              UiUtils.getTextFormField(80.w, _pwdConfirmTextController, TextInputType.visiblePassword, true, UiUtils.getInputDecoration("비밀번호 확인", ""), (text) { }, (value){
                if(value != null && value.trim().isEmpty){
                  return "비밀번호를 한번 더 입력하세요.";
                }else{
                  if(_pwdTextController.text.toString() != _pwdConfirmTextController.text.toString()){
                    return "비밀번호가 일치하지 않습니다.";
                  }else{
                    return null;
                  }
                }
              }),
              UiUtils.getMarginBox(0, 2.h),
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
              UiUtils.getMarginBox(0, 10.h),
              UiUtils.getTextButtonBox(80.w, "네 맞아요!", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () {
                if(_formKey.currentState!.validate() && MyData.confirmed){
                  CommonUtils.log("i", "OK");
                }
              })
            ])
          )
        ]),
    );

    return UiUtils.getViewWithScroll(context, view, _scrollController, CommonUtils.onWillPopForPreventBackButton);
  }

}