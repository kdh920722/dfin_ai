import 'dart:convert';
import 'package:upfin/controllers/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import '../configs/app_config.dart';
import '../datas/accident_info_data.dart';
import '../datas/pr_info_data.dart';
import '../styles/TextStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppSearchAccidentView extends StatefulWidget{
  @override
  AppSearchAccidentViewState createState() => AppSearchAccidentViewState();
}

class AppSearchAccidentViewState extends State<AppSearchAccidentView> with WidgetsBindingObserver{
  int currentViewId = 1;

  final int courtViewId = 1;
  Key? selectedCourtKey;
  String selectedCourtInfo = "";

  final int accidentViewId = 2;
  String selectedAccidentInfo = "";
  final _accidentInfoFocus1 = FocusNode();
  final _accidentInfoFocus2 = FocusNode();
  final _accidentInfoTextController1 = TextEditingController();
  final _accidentInfoTextController2 = TextEditingController();
  void _accidentInfoTextController1Listener() {
    if(_accidentInfoTextController1.text.trim().length > 4){
      _accidentInfoTextController1.text = _accidentInfoTextController1.text.trim().substring(0,4);
    }
  }
  void _accidentInfoTextController2Listener() {
    if(_accidentInfoTextController2.text.trim().length > 7){
      _accidentInfoTextController2.text = _accidentInfoTextController2.text.trim().substring(0,7);
    }
  }

  final int bankCodeViewId = 3;
  Key? selectedBankCodeKey;
  String selectedBankCodeInfo = "";

  final int bankAccountViewId = 4;
  String selectedBankAccountInfo = "";
  final _bankAccountInfoFocus = FocusNode();
  final _bankAccountInfoTextController = TextEditingController();
  void _bankAccountInfoTextControllerListener() {
    if(_bankAccountInfoTextController.text.trim().length > 8){
      _bankAccountInfoTextController.text = _bankAccountInfoTextController.text.trim().substring(0,8);
    }
  }

  final int preLoanCountViewId = 5;
  Key? selectedPreLoanCountKey;
  String selectedPreLoanCountInfo = "";

  final int preLoanPriceViewId = 6;
  String selectedPreLoanPriceInfo = "";
  final _preLoanPriceFocus = FocusNode();
  final _preLoanPriceTextController = TextEditingController();
  void _preLoanPriceInfoTextControllerListener() {
    if(_preLoanPriceTextController.text.trim().length > 10){
      _preLoanPriceTextController.text = _preLoanPriceTextController.text.trim().substring(0, 10);
    }else{
      final text = _preLoanPriceTextController.text.trim();
      final number = double.tryParse(text.replaceAll(',', '')); // 콤마 제거 후 숫자 변환
      if (number != null) {
        final formattedText = CommonUtils.getPriceCommaFormattedString(number);
        if (formattedText != text) {
          _preLoanPriceTextController.value = TextEditingValue(text: formattedText, selection: TextSelection.collapsed(offset: formattedText.length));
        }
      }
    }
  }

  final int wantLoanPriceViewId = 7;
  String selectedWantLoanPriceInfo = "";
  final _wantLoanPriceFocus = FocusNode();
  final _wantLoanPriceTextController = TextEditingController();
  void _wantLoanPriceInfoTextControllerListener() {
    if(_wantLoanPriceTextController.text.trim().length > 10){
      _wantLoanPriceTextController.text = _wantLoanPriceTextController.text.trim().substring(0, 10);
    }else{
      final text = _wantLoanPriceTextController.text.trim();
      final number = double.tryParse(text.replaceAll(',', '')); // 콤마 제거 후 숫자 변환
      if (number != null) {
        final formattedText = CommonUtils.getPriceCommaFormattedString(number);
        if (formattedText != text) {
          _wantLoanPriceTextController.value = TextEditingValue(text: formattedText, selection: TextSelection.collapsed(offset: formattedText.length));
        }
      }
    }
  }

  final int jobViewId = 8;
  Key? selectedJobKey;
  String selectedJobInfo = "";

  final int finishedViewId = 9;
  bool finishedConfirmed = false;

  void _unFocusAllNodes(){
    _accidentInfoFocus1.unfocus();
    _accidentInfoFocus2.unfocus();
    _bankAccountInfoFocus.unfocus();
    _preLoanPriceFocus.unfocus();
    _wantLoanPriceFocus.unfocus();
  }

  void _disposeAllTextControllers(){
    _accidentInfoTextController1.dispose();
    _accidentInfoTextController2.dispose();
    _bankAccountInfoTextController.dispose();
    _preLoanPriceTextController.dispose();
    _wantLoanPriceTextController.dispose();
  }

  void _checkView(){
    if(!finishedConfirmed){
      if(selectedCourtInfo.isEmpty){
        currentViewId = courtViewId;
      }else if(selectedAccidentInfo.isEmpty){
        currentViewId = accidentViewId;
      }else if(selectedBankCodeInfo.isEmpty){
        currentViewId = bankCodeViewId;
      }else if(selectedBankAccountInfo.isEmpty){
        currentViewId = bankAccountViewId;
      }else if(selectedPreLoanCountInfo.isEmpty){
        currentViewId = preLoanCountViewId;
      }else if(selectedPreLoanPriceInfo.isEmpty){
        currentViewId = preLoanPriceViewId;
      }else if(selectedWantLoanPriceInfo.isEmpty){
        currentViewId = wantLoanPriceViewId;
      }else if(selectedJobInfo.isEmpty){
        currentViewId = jobViewId;
      }
    }else{
      currentViewId = finishedViewId;
    }
  }

  @override
  void initState(){
    CommonUtils.log("i", "AppSearchAccidentView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _accidentInfoTextController1.addListener(_accidentInfoTextController1Listener);
    _accidentInfoTextController2.addListener(_accidentInfoTextController2Listener);
    _bankAccountInfoTextController.addListener(_bankAccountInfoTextControllerListener);
    _preLoanPriceTextController.addListener(_preLoanPriceInfoTextControllerListener);
    _wantLoanPriceTextController.addListener(_wantLoanPriceInfoTextControllerListener);
    _checkView();
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppSearchAccidentView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _unFocusAllNodes();
    _disposeAllTextControllers();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('i','AppSearchAccidentView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('i','AppSearchAccidentView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('i','AppSearchAccidentView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('i','AppSearchAccidentView paused');
        break;
      default:
        break;
    }
  }

  Future<void> backInputView() async {
    _unFocusAllNodes();
    CommonUtils.hideKeyBoard();
    await Future.delayed(const Duration(milliseconds: 120), () async {});
    setState(() {
      currentViewId--;
    });
  }

  Future<void> nextInputView() async {
    _unFocusAllNodes();
    CommonUtils.hideKeyBoard();
    await Future.delayed(const Duration(milliseconds: 120), () async {});
    setState(() {
      currentViewId++;
    });
  }

  /// court view
  Widget _getCourtView(){
    List<Widget> courtList = [];
    Color textColor = ColorStyles.upFinBlack;
    for(var each in LogfinController.courtList){
      Key key = Key(each);
      if(selectedCourtKey == key) {
        textColor = ColorStyles.upFinTextAndBorderBlue;
      }
      else{
        textColor = ColorStyles.upFinBlack;
      }
      courtList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getCustomCircleCheckBox(key, 1.5, selectedCourtKey == key, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                  setState(() {
                    if(checkedValue != null){
                      if(checkedValue) {
                        selectedCourtKey = key;
                        selectedCourtInfo = each;
                      }
                    }
                  });
                }),
                UiUtils.getTextStyledButtonWithFixedScale(each.split("@")[0], 15.sp, FontWeight.w600, textColor, TextAlign.center, null, (){
                  setState(() {
                    selectedCourtKey = key;
                    selectedCourtInfo = each;
                  });
                })
              ])
          )
      );
    }


    if(MyData.initSearchViewFromMainView){
      return UiUtils.getRowColumnWithAlignCenter([
        SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () {
            Navigator.pop(context);
          }),
        ])),
        UiUtils.getMarginBox(0, 3.h),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("개인회생 사건정보", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("법원을 선택해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 5.h),
        UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: courtList)),
        UiUtils.getMarginBox(0, 5.h),
        UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
          CommonUtils.log("i", "court : $selectedCourtInfo");
          if(selectedCourtInfo.isNotEmpty){
            nextInputView();
          }
        })
      ]);
    }else{
      return UiUtils.getRowColumnWithAlignCenter([
        UiUtils.getMarginBox(0, 10.h),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("개인회생 사건정보", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("법원을 선택해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 5.h),
        UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: courtList)),
        UiUtils.getMarginBox(0, 5.h),
        UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
          CommonUtils.log("i", "court : $selectedCourtInfo");
          if(selectedCourtInfo.isNotEmpty){
            nextInputView();
          }
        })
      ]);
    }
  }
  /// court view end


  /// accident view
  Widget _getAccidentView(){
    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("사건번호를 입력해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("예) 2023개회1234567", 14.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical,
          SizedBox(width: 85.w, child: Row(children: [
            UiUtils.getTextField(20.w, TextStyles.upFinTextFormFieldTextStyle, _accidentInfoFocus1, _accidentInfoTextController1, TextInputType.number,
                UiUtils.getInputDecoration("", 0.sp, "", 0.sp), (value) { }),
            UiUtils.getDisabledTextField(18.w, "개회", TextStyles.upFinDisabledTextFormFieldTextStyle,
                UiUtils.getInputDecoration("", 0.sp, "", 0.sp)),
            UiUtils.getTextField(28.w, TextStyles.upFinTextFormFieldTextStyle, _accidentInfoFocus2, _accidentInfoTextController2, TextInputType.number,
                UiUtils.getInputDecoration("", 0.sp, "", 0.sp), (value) { }),
          ]))
      ),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        selectedAccidentInfo = "${_accidentInfoTextController1.text.trim()}개회${_accidentInfoTextController2.text.trim()}";
        CommonUtils.log("i", "selectedAccidentInfo : $selectedAccidentInfo");
        if(selectedAccidentInfo.isNotEmpty){
          nextInputView();
        }
      })
    ]);
  }
  /// accident view end

  /// bank code view
  Widget _getBankCodeView(){
    List<Widget> bankCodeList = [];
    Color textColor = ColorStyles.upFinBlack;
    for(var each in LogfinController.bankList){
      Key key = Key(each);
      if(selectedBankCodeKey == key) {
        textColor = ColorStyles.upFinTextAndBorderBlue;
      }
      else{
        textColor = ColorStyles.upFinBlack;
      }
      bankCodeList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getCustomCircleCheckBox(key, 1.5, selectedBankCodeKey == key, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                      setState(() {
                        if(checkedValue != null){
                          if(checkedValue) {
                            selectedBankCodeKey = key;
                            selectedBankCodeInfo = each;
                          }
                        }
                      });
                    }),
                UiUtils.getTextStyledButtonWithFixedScale(each.split("@")[0], 15.sp, FontWeight.w600, textColor, TextAlign.center, null, (){
                  setState(() {
                    selectedBankCodeKey = key;
                    selectedBankCodeInfo = each;
                  });
                })
              ])
          )
      );
    }

    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("환급계좌 은행을", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("선택해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("개인회생 신청 시 제출했던 본인의 계좌", 14.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: bankCodeList)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        CommonUtils.log("i", "bank code : $selectedBankCodeInfo");
        if(selectedBankCodeInfo.isNotEmpty){
          nextInputView();
        }
      })
    ]);
  }
  /// bank code view end

  /// bank account view
  Widget _getBankAccountView(){
    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("환급계좌번호를", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("입력해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextField(90.w, TextStyles.upFinTextFormFieldTextStyle, _bankAccountInfoFocus, _bankAccountInfoTextController, TextInputType.number,
          UiUtils.getInputDecoration("", 0.sp, "", 0.sp), (value) { }),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        selectedBankAccountInfo = _bankAccountInfoTextController.text.trim();
        CommonUtils.log("i", "selectedBankAccountInfo : $selectedBankAccountInfo");
        if(selectedBankAccountInfo.isNotEmpty){
          nextInputView();
        }
      })
    ]);
  }
  /// bank account view end

  /// pre loan count view
  Widget _getPreLoanCountView(){
    List<Widget> loanCountList = [];
    Color textColor = ColorStyles.upFinBlack;
    for(var each in LogfinController.preLoanCountList){
      Key key = Key(each);
      if(selectedPreLoanCountKey == key) {
        textColor = ColorStyles.upFinTextAndBorderBlue;
      }
      else{
        textColor = ColorStyles.upFinBlack;
      }
      loanCountList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getCustomCircleCheckBox(key, 1.5, selectedPreLoanCountKey == key, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                      setState(() {
                        if(checkedValue != null){
                          if(checkedValue) {
                            selectedPreLoanCountKey = key;
                            selectedPreLoanCountInfo = each;
                          }
                        }
                      });
                    }),
                UiUtils.getTextStyledButtonWithFixedScale(each.split("@")[0], 15.sp, FontWeight.w600, textColor, TextAlign.center, null, (){
                  setState(() {
                    selectedPreLoanCountKey = key;
                    selectedPreLoanCountInfo = each;
                  });
                })
              ])
          )
      );
    }

    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("이미 받고 있는", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("대출 횟수를 알려주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: loanCountList)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        CommonUtils.log("i", "loan count : $selectedPreLoanCountInfo");
        if(selectedPreLoanCountInfo.isNotEmpty){
          nextInputView();
        }
      })
    ]);
  }
  /// pre loan count view end

  /// pre loan price view
  Widget _getPreLoanPriceView(){
    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("인가후 대출 총금액을", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("알려주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("입력단위(*만원)", 12.sp, FontWeight.w600, ColorStyles.upFinRealGray, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      Obx(()=>UiUtils.getTextFormField(90.w, TextStyles.upFinTextFormFieldTextStyle, _preLoanPriceFocus, _preLoanPriceTextController, TextInputType.number, false,
          UiUtils.getInputDecoration("", 0.sp, GetController.to.preLoanPrice.value, 14.sp), (text) {
            if(text.trim() != ""){
              final number = double.tryParse(text.replaceAll(',', '')); // 콤마 제거 후 숫자 변환
              GetController.to.updatePreLoanPrice(CommonUtils.getPriceFormattedString(number!));
            }else{
              GetController.to.updatePreLoanPrice("만원");
            }
          }, (value){})
      ),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        if(_preLoanPriceTextController.text.trim() != ""){
          final number = double.tryParse(_preLoanPriceTextController.text.trim().replaceAll(',', '')); // 콤마 제거 후 숫자 변환
          String price = number.toString();
          if(price.contains(".")){
            price = price.split(".")[0];
          }
          selectedPreLoanPriceInfo = price;
        }else{
          selectedPreLoanPriceInfo = "0";
        }
        CommonUtils.log("i", "selectedPreLoanPriceInfo : $selectedPreLoanPriceInfo");
        nextInputView();
      })
    ]);
  }
  /// pre loan price end

  /// want loan price view
  Widget _getWantLoanPriceView(){
    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("희망하시는 대출금액을", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("알려주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("입력단위(*만원)", 12.sp, FontWeight.w600, ColorStyles.upFinRealGray, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      Obx(()=>UiUtils.getTextFormField(90.w, TextStyles.upFinTextFormFieldTextStyle, _wantLoanPriceFocus, _wantLoanPriceTextController, TextInputType.number, false,
          UiUtils.getInputDecoration("", 0.sp, GetController.to.wantLoanPrice.value, 14.sp), (text) {
            if(text.trim() != ""){
              final number = double.tryParse(text.replaceAll(',', '')); // 콤마 제거 후 숫자 변환
              GetController.to.updateWantLoanPrice(CommonUtils.getPriceFormattedString(number!));
            }else{
              GetController.to.updateWantLoanPrice("만원");
            }
          }, (value){})
      ),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        if(_wantLoanPriceTextController.text.trim() != ""){
          final number = double.tryParse(_wantLoanPriceTextController.text.trim().replaceAll(',', '')); // 콤마 제거 후 숫자 변환
          String price = number.toString();
          if(price.contains(".")){
            price = price.split(".")[0];
          }
          selectedWantLoanPriceInfo = price;
        }else{
          selectedWantLoanPriceInfo = "0";
        }
        CommonUtils.log("i", "selectedWantLoanPriceInfo : $selectedWantLoanPriceInfo");
        nextInputView();
      })
    ]);
  }
  /// want loan price end

  /// job view
  Widget _getJobView(){
    List<Widget> jobList = [];
    Color textColor = ColorStyles.upFinBlack;
    for(var each in LogfinController.jobList){
      Key key = Key(each);
      if(selectedJobKey == key) {
        textColor = ColorStyles.upFinTextAndBorderBlue;
      }
      else{
        textColor = ColorStyles.upFinBlack;
      }
      jobList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getCustomCircleCheckBox(key, 1.5, selectedJobKey == key, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                      setState(() {
                        if(checkedValue != null){
                          if(checkedValue) {
                            selectedJobKey = key;
                            selectedJobInfo = each;
                          }
                        }
                      });
                    }),
                UiUtils.getTextStyledButtonWithFixedScale(each.split("@")[0], 15.sp, FontWeight.w600, textColor, TextAlign.center, null, (){
                  setState(() {
                    selectedJobKey = key;
                    selectedJobInfo = each;
                  });
                })
              ])
          )
      );
    }

    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("직업을 선택해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: jobList)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        CommonUtils.log("i", "selectedJobInfo : $selectedJobInfo");
        if(selectedJobInfo.isNotEmpty){
          nextInputView();
        }
      })
    ]);
  }
  /// job view end

  /// finish confirm view
  Widget _getFinishConfirmView(){
    String birthMonth = MyData.birth.substring(4,6);
    if(birthMonth.substring(0,1) == "0"){
      birthMonth = birthMonth.substring(1);
    }

    String birthDay = MyData.birth.substring(6);
    if(birthDay.substring(0,1) == "0"){
      birthDay = birthDay.substring(1);
    }
    List<String> confirmDataList = [];
    confirmDataList.add(MyData.name);
    confirmDataList.add("${MyData.birth.substring(0,4)}년 $birthMonth월 $birthDay일");
    confirmDataList.add("[법원]  ${selectedCourtInfo.split("@")[0]}");
    confirmDataList.add("[사건번호]  $selectedAccidentInfo");
    confirmDataList.add("[환급계]  ${selectedBankCodeInfo.split("@")[0]} $selectedBankAccountInfo");
    confirmDataList.add("[기대출]  ${selectedPreLoanCountInfo.split("@")[0]}");
    if(selectedPreLoanPriceInfo != "0"){
      confirmDataList.add("[인가후 대출금액]  ${CommonUtils.getPriceFormattedString(double.parse(selectedPreLoanPriceInfo))}");
    }else{
      confirmDataList.add("[인가후 대출금액]  0원");
    }
    if(selectedWantLoanPriceInfo != "0"){
      confirmDataList.add("[희망 대출금액]  ${CommonUtils.getPriceFormattedString(double.parse(selectedWantLoanPriceInfo))}");
    }else{
      confirmDataList.add("[희망 대출금액]  0원");
    }
    confirmDataList.add("[직업]  ${selectedJobInfo.split("@")[0]}");

    List<Widget> confirmWidgetList = [];
    Color textColor = ColorStyles.upFinBlack;
    for(var each in confirmDataList){
      Key key = UniqueKey();
      textColor = ColorStyles.upFinBlack;
      confirmWidgetList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getCustomCircleCheckBox(key, 1.5, true, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){}),
                UiUtils.getTextStyledButtonWithFixedScale(each, 13.sp, FontWeight.w500, textColor, TextAlign.center, null, (){})
              ])
          )
      );
    }

    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("해당 조건으로.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("대출상품을 찾아볼까요?", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: confirmWidgetList)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "네 좋아요!", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () {
        Map<String, dynamic> inputJson = {
          "court_name": selectedCourtInfo.split("@")[0],
          "caseNumberYear": selectedAccidentInfo.split("개회")[0],
          "caseNumberType": "개회",
          "caseNumberNumber": selectedAccidentInfo.split("개회")[1],
          "userName": MyData.name,
          "bankCode": selectedBankCodeInfo.split("@")[1].substring(1),
          "account": selectedBankAccountInfo,
          "birthday": MyData.birth,
          "job": selectedJobInfo.split("@")[1],
          "lend_count": selectedPreLoanCountInfo.split("@")[1],
          "lend_amount": selectedPreLoanPriceInfo,
          "wish_amount": selectedWantLoanPriceInfo,

        };
        CommonUtils.log("i", "pr search info:\n$inputJson");

        String caseYear = "2023";
        String caseType = "개회";
        String caseNumber = "1000794";
        Map<String, dynamic> inputJsonForTest = {
          "court_name": "서울회생법원",
          "caseNumberYear": caseYear,
          "caseNumberType": caseType,
          "caseNumberNumber": caseNumber,
          "userName": "정혜경",
          "bankCode": "004",
          "account": "40240104",
          "birthday": "19690710",
          "job": "2",
          "lend_count": "500",
          "lend_amount": "1",
          "wish_amount": "300",

        };

        UiUtils.showLoadingPop(context);
        LogfinController.callLogfinApi(LogfinApis.prSearch, inputJsonForTest, (isSuccess, outputJson){
          if(isSuccess){
            // 1) 한도금리 목록 조회 후 사건정보 재조회
            LogfinController.callLogfinApi(LogfinApis.getAccidentInfo, <String, dynamic>{}, (isSuccessToGetAccidentInfo, accidentInfoOutputJson){
              if(isSuccessToGetAccidentInfo){
                List<dynamic> accidentList = accidentInfoOutputJson!["accidents"];
                String bankName = "";
                for(var each in accidentList){
                  var dataResult = jsonDecode(each["req_data"].toString())["pr"];
                  for(var eachBank in LogfinController.bankList){
                    if(eachBank.split("@")[1].substring(1) == dataResult["bankCode"]){
                      bankName = eachBank.split("@")[0];
                    }
                  }
                  MyData.addToAccidentInfoList(AccidentInfoData(each["uid"], dataResult["caseNumberYear"], dataResult["caseNumberType"], dataResult["caseNumberNumber"],
                      dataResult["court_name"], bankName, dataResult["bankCode"], dataResult["account"]));
                }

                // 2) 한도금리 목록 화면으로 이동(저장한 accident uid로 한도금리 조회한 뒤 저장하여 보여줌)
                LogfinController.getPrList(caseYear+caseType+caseNumber, (isSuccessToGetOffers, outputJsonForGetOffers){
                  UiUtils.closeLoadingPop(context);
                  if(isSuccessToGetOffers){
                    CommonUtils.moveWithReplacementTo(context, AppView.resultPrView.value, null);
                  }else{
                    // findUidInAccidentInfoList 실패
                    CommonUtils.flutterToast("에러가 발생했습니다.");
                  }
                });
              }else{
                // getAccidentInfo 실패
                UiUtils.closeLoadingPop(context);
                CommonUtils.flutterToast(accidentInfoOutputJson!["error"]);
              }
            });
          }else{
            // prSearch 실패
            UiUtils.closeLoadingPop(context);
            CommonUtils.flutterToast(outputJson!["error"]);
          }
        });
      })
    ]);
  }
  /// finish confirm view end

  @override
  Widget build(BuildContext context) {
    Widget? view;
    if(currentViewId == courtViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getCourtView());
    }else if(currentViewId == accidentViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getAccidentView());
    }else if(currentViewId == bankCodeViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getBankCodeView());
    }else if(currentViewId == bankAccountViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getBankAccountView());
    }else if(currentViewId == preLoanCountViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getPreLoanCountView());
    }else if(currentViewId == preLoanPriceViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getPreLoanPriceView());
    }else if(currentViewId == wantLoanPriceViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getWantLoanPriceView());
    }else if(currentViewId == jobViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getJobView());
    }else{
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getFinishConfirmView());
    }

    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}