import 'dart:async';
import 'package:upfin/controllers/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import '../configs/app_config.dart';
import '../styles/TextStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppSearchAccidentView extends StatefulWidget{
  @override
  AppSearchAccidentViewState createState() => AppSearchAccidentViewState();
}

class AppSearchAccidentViewState extends State<AppSearchAccidentView> with WidgetsBindingObserver{
  double scrollScreenHeight = 57.h;
  double itemHeight1 = 0;
  double itemHeight2 = 0;
  double itemFullHeight1 = 0;
  double itemFullHeight2 = 0;
  int maxVisibleItemCnt1 = 0;
  int maxVisibleItemCnt2 = 0;
  int firstVisibleItem1 = 0;
  int lastVisibleItem1 = 0;
  bool isScrolling1 = false;
  bool isScrolling2= false;

  bool isInputValid = true;

  final String errorMsg = "정보를 입력해주세요";
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
    }else if(_accidentInfoTextController1.text.trim().length == 4){
      FocusScope.of(context).requestFocus(_accidentInfoFocus2);
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
    GetController.to.resetPreLoanPrice();
    GetController.to.resetWantLoanPrice();
    GetController.to.resetFirstIndex1();
    GetController.to.resetLastIndex1();
    GetController.to.resetFirstIndex2();
    GetController.to.resetLastIndex2();

    GetController.to.updateFirstIndex1(0);
    GetController.to.updateLastIndex1(12);

    GetController.to.updateFirstIndex2(0);
    GetController.to.updateLastIndex2(10);
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppSearchAccidentView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _unFocusAllNodes();
    _disposeAllTextControllers();
    GetController.to.resetPreLoanPrice();
    GetController.to.resetWantLoanPrice();
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
    if(isInputValid) {
      isInputValid = false;
      _unFocusAllNodes();
      CommonUtils.hideKeyBoard();
      await Future.delayed(const Duration(milliseconds: 120), () async {});
      setState(() {
        currentViewId--;
        isInputValid = true;
      });
    }
  }

  Future<void> nextInputView() async {
    if(isInputValid){
      isInputValid = false;
      _unFocusAllNodes();
      CommonUtils.hideKeyBoard();
      await Future.delayed(const Duration(milliseconds: 120), () async {});
      setState(() {
        currentViewId++;
        isInputValid = true;
      });
    }
  }

  /// court view
  Widget _getCourtView(){
    List<Widget> courtList = [];
    Color textColor = ColorStyles.upFinBlack;
    for(int i=0; i<LogfinController.courtList.length ; i++){
      Key key = Key(LogfinController.courtList[i]);
      if(selectedCourtKey == key){
        textColor = ColorStyles.upFinTextAndBorderBlue;
      }else{
        textColor = ColorStyles.upFinBlack;
        if(GetController.to.firstVisibleItem1.value >= 3){
          if(GetController.to.firstVisibleItem1.value-2 <= i && i <= GetController.to.firstVisibleItem1.value+1){
            textColor = Colors.black12;
            if(GetController.to.firstVisibleItem1.value+1 <= i && i <= GetController.to.firstVisibleItem1.value+1){
              textColor = Colors.black38;
            }
          }
        }

        if(GetController.to.lastVisibleItem1.value <= LogfinController.courtList.length-3){
          if(GetController.to.lastVisibleItem1.value-3 <= i && i <= GetController.to.lastVisibleItem1.value-1){
            textColor = Colors.black12;
            if(GetController.to.lastVisibleItem1.value-3 <= i && i <= GetController.to.lastVisibleItem1.value-3){
              textColor = Colors.black38;
            }
          }
        }
      }
      courtList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                selectedCourtKey == key? UiUtils.getCustomCheckBox(key, 1.5, selectedCourtKey == key, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                  setState(() {
                    if(checkedValue != null){
                      if(checkedValue) {
                        selectedCourtKey = key;
                        selectedCourtInfo = LogfinController.courtList[i];
                      }
                    }
                  });
                }) : UiUtils.getCustomCheckBox(key, 1.5, true, ColorStyles.upFinGray, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                      setState(() {
                        if(checkedValue != null){
                          if(!checkedValue) {
                            selectedCourtKey = key;
                            selectedCourtInfo = LogfinController.courtList[i];
                          }
                        }
                      });
                    }),
                Expanded(child: UiUtils.getTextButtonWithFixedScale(LogfinController.courtList[i].split("@")[0], 15.sp, FontWeight.w500, textColor, TextAlign.start, null, (){
                  setState(() {
                    selectedCourtKey = key;
                    selectedCourtInfo = LogfinController.courtList[i];
                  });
                }))
              ])
          )
      );
      courtList.add(
          UiUtils.getMarginBox(0, 0.8.h),
      );
    }

    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButton(() {
          Navigator.pop(context, "back");
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w,  height: 5.h,child: UiUtils.getTextWithFixedScale("우선 ", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w,  height: 5.h,child: UiUtils.getTextWithFixedScale("사건정보가 필요합니다.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("해당 법원을 선택해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification) {
              if(!isScrolling1){
                isScrolling1 = true;
                itemFullHeight1 = scrollNotification.metrics.maxScrollExtent+scrollScreenHeight;
                itemHeight1 = itemFullHeight1/LogfinController.courtList.length;
                maxVisibleItemCnt1 = (scrollScreenHeight/itemHeight1).ceil();
              }

              double scrollPosition = scrollNotification.metrics.pixels.abs();
              int firstVisibleItem1 = (scrollPosition/itemHeight1).ceil();
              int lastVisibleItem1 = firstVisibleItem1+maxVisibleItemCnt1;
              if(firstVisibleItem1 <=0 ) firstVisibleItem1 = 0;
              if(lastVisibleItem1 >= LogfinController.courtList.length-1) lastVisibleItem1 = LogfinController.courtList.length-1;
              print('보이는 아이템 ====> ${LogfinController.courtList.length} : $firstVisibleItem1 | $lastVisibleItem1');

              GetController.to.updateFirstIndex1(firstVisibleItem1);
              GetController.to.updateLastIndex1(lastVisibleItem1);
            } else if (scrollNotification is ScrollEndNotification) {
              if(isScrolling1){
                isScrolling1 = false;
                itemFullHeight1 = scrollNotification.metrics.maxScrollExtent+scrollScreenHeight;
                itemHeight1 = scrollNotification.metrics.maxScrollExtent/LogfinController.courtList.length;
                maxVisibleItemCnt1 = (scrollScreenHeight/itemHeight1).ceil();
              }
            }
            return true;
          },
          child: UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: courtList))),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        CommonUtils.log("i", "court : $selectedCourtInfo");
        if(selectedCourtInfo.isNotEmpty){
          nextInputView();
        }else{
          CommonUtils.flutterToast(errorMsg);
        }
      })
    ]);
  }
  /// court view end

  /// accident view
  Widget _getAccidentView(){
    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButton(() async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("사건번호 ", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("예) 2023개회1234567", 14.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical,
          SizedBox(width: 85.w, child: Row(children: [
            UiUtils.getTextField(20.w, TextStyles.upFinTextFormFieldTextStyle, _accidentInfoFocus1, _accidentInfoTextController1, TextInputType.number,
                UiUtils.getInputDecoration("", 0.sp, "", 0.sp), (value) { }),
            UiUtils.getTextWithFixedScale("개회", 16.sp, FontWeight.w400, ColorStyles.upFinRealGray, TextAlign.center, null),
            UiUtils.getTextField(32.w, TextStyles.upFinTextFormFieldTextStyle, _accidentInfoFocus2, _accidentInfoTextController2, TextInputType.number,
                UiUtils.getInputDecoration("", 0.sp, "", 0.sp), (value) { }),
          ]))
      ),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        selectedAccidentInfo = "${_accidentInfoTextController1.text.trim()}개회${_accidentInfoTextController2.text.trim()}";
        CommonUtils.log("i", "selectedAccidentInfo : $selectedAccidentInfo");
        if(selectedAccidentInfo != "개회" && _accidentInfoTextController1.text.trim() != "" && _accidentInfoTextController2.text.trim() != ""){
          bool isValid = true;
          for(var eachAccident in MyData.getAccidentInfoList()){
            if(eachAccident.accidentCaseNumberYear+eachAccident.accidentCaseNumberType+eachAccident.accidentCaseNumberNumber == selectedAccidentInfo){
              selectedAccidentInfo = "";
              isValid = false;
            }
          }

          if(isValid){
            nextInputView();
          }else{
            CommonUtils.flutterToast("이미 조회하신 사건번호입니다.");
          }
        }else{
          CommonUtils.flutterToast(errorMsg);
        }
      })
    ]);
  }
  /// accident view end

  /// bank code view
  Widget _getBankCodeView(){
    List<Widget> bankCodeList = [];
    Color textColor = ColorStyles.upFinBlack;
    for(int i=0 ; i<LogfinController.bankList.length ; i++){
      Key key = Key(LogfinController.bankList[i]);
      if(selectedBankCodeKey == key){
        textColor = ColorStyles.upFinTextAndBorderBlue;
      }else{
        textColor = ColorStyles.upFinBlack;
        if(GetController.to.firstVisibleItem2.value >= 3){
          if(GetController.to.firstVisibleItem2.value-2 <= i && i <= GetController.to.firstVisibleItem2.value+1){
            textColor = Colors.black12;
            if(GetController.to.firstVisibleItem2.value+1 <= i && i <= GetController.to.firstVisibleItem2.value+1){
              textColor = Colors.black38;
            }
          }
        }

        if(GetController.to.lastVisibleItem2.value <= LogfinController.bankList.length-3){
          if(GetController.to.lastVisibleItem2.value-3 <= i && i <= GetController.to.lastVisibleItem2.value-1){
            textColor = Colors.black12;
            if(GetController.to.lastVisibleItem2.value-3 <= i && i <= GetController.to.lastVisibleItem2.value-3){
              textColor = Colors.black38;
            }
          }
        }
      }
      bankCodeList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                selectedBankCodeKey == key? UiUtils.getCustomCheckBox(key, 1.5, selectedBankCodeKey == key, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                      setState(() {
                        if(checkedValue != null){
                          if(checkedValue) {
                            selectedBankCodeKey = key;
                            selectedBankCodeInfo = LogfinController.bankList[i];
                          }
                        }
                      });
                    }) : UiUtils.getCustomCheckBox(key, 1.5, true, ColorStyles.upFinGray, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                      setState(() {
                        if(checkedValue != null){
                          if(!checkedValue) {
                            selectedBankCodeKey = key;
                            selectedBankCodeInfo = LogfinController.bankList[i];
                          }
                        }
                      });
                    }),
                Expanded(child: UiUtils.getTextButtonWithFixedScale(LogfinController.bankList[i].split("@")[0], 15.sp, FontWeight.w500, textColor, TextAlign.start, null, (){
                  setState(() {
                    selectedBankCodeKey = key;
                    selectedBankCodeInfo = LogfinController.bankList[i];
                  });
                }))
              ])
          )
      );
      bankCodeList.add(
          UiUtils.getMarginBox(0, 0.8.h)
      );
    }

    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButton(() async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("환급계좌 은행 ", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      // SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("선택해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("개인회생 신청시 제출했던 본인의 계좌", 14.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification) {
              if(!isScrolling2){
                isScrolling2 = true;
                itemFullHeight2 = scrollNotification.metrics.maxScrollExtent+scrollScreenHeight;
                itemHeight2 = itemFullHeight2/LogfinController.bankList.length;
                maxVisibleItemCnt2 = (scrollScreenHeight/itemHeight2).ceil();
              }

              double scrollPosition = scrollNotification.metrics.pixels.abs();
              int firstVisibleItem2 = (scrollPosition/itemHeight2).ceil();
              int lastVisibleItem2 = firstVisibleItem2+maxVisibleItemCnt2;
              if(firstVisibleItem2 <=0 ) firstVisibleItem2 = 0;
              if(lastVisibleItem2 >= LogfinController.bankList.length-1) lastVisibleItem2 = LogfinController.bankList.length-1;
              print('보이는 아이템 ====> ${LogfinController.bankList.length} : $firstVisibleItem2 | $lastVisibleItem2');

              GetController.to.updateFirstIndex2(firstVisibleItem2);
              GetController.to.updateLastIndex2(lastVisibleItem2);
            } else if (scrollNotification is ScrollEndNotification) {
              if(isScrolling2){
                isScrolling2 = false;
                itemFullHeight2 = scrollNotification.metrics.maxScrollExtent+scrollScreenHeight;
                itemHeight2 = scrollNotification.metrics.maxScrollExtent/LogfinController.bankList.length;
                maxVisibleItemCnt2 = (scrollScreenHeight/itemHeight2).ceil();
              }
            }
            return true;
          },
          child: UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: bankCodeList))),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        CommonUtils.log("i", "bank code : $selectedBankCodeInfo");
        if(selectedBankCodeInfo.isNotEmpty){
          nextInputView();
        }else{
          CommonUtils.flutterToast(errorMsg);
        }
      })
    ]);
  }
  /// bank code view end

  /// bank account view
  Widget _getBankAccountView(){
    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButton(() async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("환급계좌 번호", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      // SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("입력해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextField(90.w, TextStyles.upFinTextFormFieldTextStyle, _bankAccountInfoFocus, _bankAccountInfoTextController, TextInputType.number,
          UiUtils.getInputDecoration("계좌번호 8자리", 14.sp, "", 0.sp), (value) { }),
      UiUtils.getExpandedScrollView(Axis.vertical, Container()),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        selectedBankAccountInfo = _bankAccountInfoTextController.text.trim();
        CommonUtils.log("i", "selectedBankAccountInfo : $selectedBankAccountInfo");
        if(selectedBankAccountInfo.isNotEmpty){
          nextInputView();
        }else{
          CommonUtils.flutterToast(errorMsg);
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
                selectedPreLoanCountKey == key? UiUtils.getCustomCheckBox(key, 1.5, selectedPreLoanCountKey == key, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                      setState(() {
                        if(checkedValue != null){
                          if(checkedValue) {
                            selectedPreLoanCountKey = key;
                            selectedPreLoanCountInfo = each;
                          }
                        }
                      });
                    }) : UiUtils.getCustomCheckBox(key, 1.5, true, ColorStyles.upFinGray, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                      setState(() {
                        if(checkedValue != null){
                          if(!checkedValue) {
                            selectedPreLoanCountKey = key;
                            selectedPreLoanCountInfo = each;
                          }
                        }
                      });
                    }),
                Expanded(child: UiUtils.getTextButtonWithFixedScale(each.split("@")[0], 15.sp, FontWeight.w500, textColor, TextAlign.start, null, (){
                  setState(() {
                    selectedPreLoanCountKey = key;
                    selectedPreLoanCountInfo = each;
                  });
                }))
              ])
          )
      );
      loanCountList.add(
          UiUtils.getMarginBox(0, 0.8.h)
      );
    }

    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButton(() async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, height: 4.5.h , child: UiUtils.getTextWithFixedScale("이미 받고 있는", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("대출 횟수를 알려주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: loanCountList)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        CommonUtils.log("i", "loan count : $selectedPreLoanCountInfo");
        if(selectedPreLoanCountInfo.isNotEmpty){
          if(selectedPreLoanCountInfo.split("@")[1] == "0"){
            selectedPreLoanPriceInfo = "0";
            currentViewId++;
            nextInputView();
          }else{
            nextInputView();
          }
        }else{
          CommonUtils.flutterToast(errorMsg);
        }
      })
    ]);
  }
  /// pre loan count view end

  /// pre loan price view
  Widget _getPreLoanPriceView(){
    return Stack(children: [
      UiUtils.getRowColumnWithAlignCenter([
        SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UiUtils.getBackButton(() async {
            backInputView();
          }),
        ])),
        UiUtils.getMarginBox(0, 3.h),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("인가후 대출 총금액", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
        // SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("알려주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
        // UiUtils.getMarginBox(0, 1.h),
        // SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("입력단위(*만원)", 12.sp, FontWeight.w600, ColorStyles.upFinRealGray, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 5.h),
        Obx(()=>
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              UiUtils.getTextFormField(90.w, TextStyles.upFinTextFormFieldTextStyle, _preLoanPriceFocus, _preLoanPriceTextController, TextInputType.number, false,
                  UiUtils.getInputDecorationForPrice("", 0.sp, GetController.to.preLoanPrice.value, 11.sp), (text) {
                    if(text.trim() != ""){
                      final number = double.tryParse(text.replaceAll(',', '')); // 콤마 제거 후 숫자 변환
                      GetController.to.updatePreLoanPrice(CommonUtils.getPriceFormattedString(number!));
                    }else{
                      GetController.to.updatePreLoanPrice("만원");
                    }
                  }, (value){})
            ])
        ),
        UiUtils.getMarginBox(0, 5.h),
        UiUtils.getExpandedScrollView(Axis.vertical, Container()),
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
      ])
    ]);
  }
  /// pre loan price end

  /// want loan price view
  Widget _getWantLoanPriceView(){
    return Stack(children: [
      UiUtils.getRowColumnWithAlignCenter([
        SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UiUtils.getBackButton(() async {
            if(selectedPreLoanCountInfo.split("@")[1] == "0"){
              currentViewId--;
              backInputView();
            }else{
              backInputView();
            }
          }),
        ])),
        UiUtils.getMarginBox(0, 3.h),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("희망대출 금액", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
        // SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("알려주세요.", 2출2.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
        // UiUtils.getMarginBox(0, 1.h),
        // SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("입력단위(*만원)", 12.sp, FontWeight.w600, ColorStyles.upFinRealGray, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 5.h),
        Obx(()=>UiUtils.getTextFormField(90.w, TextStyles.upFinTextFormFieldTextStyle, _wantLoanPriceFocus, _wantLoanPriceTextController, TextInputType.number, false,
            UiUtils.getInputDecorationForPrice("", 0.sp, GetController.to.wantLoanPrice.value, 11.sp), (text) {
              if(text.trim() != ""){
                final number = double.tryParse(text.replaceAll(',', '')); // 콤마 제거 후 숫자 변환
                GetController.to.updateWantLoanPrice(CommonUtils.getPriceFormattedString(number!));
              }else{
                GetController.to.updateWantLoanPrice("만원");
              }
            }, (value){})
        ),
        UiUtils.getMarginBox(0, 5.h),
        UiUtils.getExpandedScrollView(Axis.vertical, Container()),
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
      ])
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
                selectedJobKey == key? UiUtils.getCustomCheckBox(key, 1.5, selectedJobKey == key, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                      setState(() {
                        if(checkedValue != null){
                          if(checkedValue) {
                            selectedJobKey = key;
                            selectedJobInfo = each;
                          }
                        }
                      });
                    }) : UiUtils.getCustomCheckBox(key, 1.5, true, ColorStyles.upFinGray, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                      setState(() {
                        if(checkedValue != null){
                          if(!checkedValue) {
                            selectedJobKey = key;
                            selectedJobInfo = each;
                          }
                        }
                      });
                    }),
                Expanded(child: UiUtils.getTextButtonWithFixedScale(each.split("@")[0], 15.sp, FontWeight.w500, textColor, TextAlign.start, null, (){
                  setState(() {
                    selectedJobKey = key;
                    selectedJobInfo = each;
                  });
                }))
              ])
          )
      );
      jobList.add(
          UiUtils.getMarginBox(0, 0.8.h)
      );
    }

    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButton(() async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("직업 ", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: jobList)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        CommonUtils.log("i", "selectedJobInfo : $selectedJobInfo");
        if(selectedJobInfo.isNotEmpty){
          nextInputView();
        }else{
          CommonUtils.flutterToast(errorMsg);
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
    confirmDataList.add("•  ${MyData.name}");
    confirmDataList.add("•  ${MyData.birth.substring(0,4)}년 $birthMonth월 $birthDay일");
    confirmDataList.add("•  [환급]  ${selectedBankCodeInfo.split("@")[0]} $selectedBankAccountInfo");
    confirmDataList.add("•  기대출  ${selectedPreLoanCountInfo.split("@")[0]}");
    if(selectedPreLoanPriceInfo != "0"){
      confirmDataList.add("•  인가후 대출금액  ${CommonUtils.getPriceFormattedString(double.parse(selectedPreLoanPriceInfo))}");
    }else{
      confirmDataList.add("•  인가후 대출금액  0원");
    }
    if(selectedWantLoanPriceInfo != "0"){
      confirmDataList.add("•  희망 대출금액  ${CommonUtils.getPriceFormattedString(double.parse(selectedWantLoanPriceInfo))}");
    }else{
      confirmDataList.add("•  희망 대출금액  0원");
    }
    confirmDataList.add("•  ${selectedJobInfo.split("@")[0]}");

    List<Widget> confirmWidgetList = [];
    Color textColor = ColorStyles.upFinBlack;
    for(var each in confirmDataList){
      textColor = ColorStyles.upFinBlack;
      confirmWidgetList.add(
          SizedBox(width: 80.w, child: UiUtils.getTextButtonWithFixedScale(each, 16.sp, FontWeight.w500, textColor, TextAlign.start, null, (){})),
      );
      confirmWidgetList.add(
        UiUtils.getMarginBox(0, 3.h),
      );
    }

    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButton(() {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, height: 4.5.h , child: UiUtils.getTextWithFixedScale("해당 정보로 ", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("대출상품을 찾아볼까요?", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: confirmWidgetList)),
      UiUtils.getMarginBox(0, 5.h),
      Row(children: [
        UiUtils.getBorderButtonBox(42.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
            UiUtils.getTextWithFixedScale("네 좋아요!", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
              Map<String, dynamic> inputJson = {
                "court_name": selectedCourtInfo.split("@")[0],
                "caseNumberYear": selectedAccidentInfo.split("개회")[0],
                "caseNumberType": "개회",
                "caseNumberNumber": selectedAccidentInfo.split("개회")[1],
                "userName": MyData.name,
                "bankCode": selectedBankCodeInfo.split("@")[1],
                "account": selectedBankAccountInfo,
                "birthday": MyData.birth,
                "job": selectedJobInfo.split("@")[1],
                "lend_count": selectedPreLoanCountInfo.split("@")[1],
                "lend_amount": selectedPreLoanPriceInfo,
                "wish_amount": selectedWantLoanPriceInfo,

              };
              CommonUtils.log("i", "pr search info:\n$inputJson");

              selectedAccidentInfo = "2023개회1000794";
              Map<String, dynamic> inputJsonForTest = {
                "court_name": "서울회생법원",
                "caseNumberYear": selectedAccidentInfo.split("개회")[0],
                "caseNumberType": "개회",
                "caseNumberNumber": selectedAccidentInfo.split("개회")[1],
                "userName": "정혜경",
                "bankCode": selectedBankCodeInfo.split("@")[1],
                "account": selectedBankAccountInfo,
                "birthday": MyData.birth,
                "job": selectedJobInfo.split("@")[1],
                "lend_count": selectedPreLoanCountInfo.split("@")[1],
                "lend_amount": selectedPreLoanPriceInfo,
                "wish_amount": selectedWantLoanPriceInfo,
              };
              UiUtils.showLoadingPop(context);
              LogfinController.callLogfinApi(LogfinApis.prSearch, inputJsonForTest, (isSuccess, outputJson){
                if(isSuccess){
                  LogfinController.getUserInfo((isSuccessToGetUserInfo){
                    if(isSuccessToGetUserInfo){
                      LogfinController.getAccidentInfo((isSuccessToGetAccidentInfo, isNotEmpty){
                        if(isSuccessToGetAccidentInfo){
                          if(isNotEmpty){
                            for(var each in MyData.getAccidentInfoList()){
                              if(each.accidentCaseNumberYear == selectedAccidentInfo.split("개회")[0] && each.accidentCaseNumberNumber == selectedAccidentInfo.split("개회")[1]){
                                MyData.selectedAccidentInfoData = each;
                              }
                            }
                            LogfinController.getPrList("${MyData.selectedAccidentInfoData!.accidentCaseNumberYear}${MyData.selectedAccidentInfoData!.accidentCaseNumberType}${MyData.selectedAccidentInfoData!.accidentCaseNumberNumber}", (isSuccessToGetOffers, _){
                              UiUtils.closeLoadingPop(context);
                              if(isSuccessToGetOffers){
                                CommonUtils.moveWithReplacementTo(context, AppView.appResultPrView.value, null);
                              }else{
                                // findUidInAccidentInfoList 실패
                                CommonUtils.flutterToast("에러가 발생했습니다.\n다시 실행해주세요.");
                              }
                            });
                          }else{
                            UiUtils.closeLoadingPop(context);
                            CommonUtils.flutterToast("사건정보 찾기 실패\n다시 실행해주세요.");
                          }
                        }else{
                          UiUtils.closeLoadingPop(context);
                          CommonUtils.flutterToast("사건정보 찾기 실패\n다시 실행해주세요.");
                        }
                      });
                    }else{
                      UiUtils.closeLoadingPop(context);
                      CommonUtils.flutterToast("사건정보 찾기 실패\n다시 실행해주세요.");
                    }
                  });
                }else{
                  // prSearch 실패
                  UiUtils.closeLoadingPop(context);
                  String errorMsg = outputJson!["error"];
                  CommonUtils.flutterToast(errorMsg.replaceAll("+", "").replaceAll("()", "").replaceAll(".", "\n"));
                }
              });
            }),
        UiUtils.getMarginBox(2.w, 0),
        UiUtils.getBorderButtonBox(42.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinWhiteSky,
            UiUtils.getTextWithFixedScale("아니오", 14.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, null), () {
              Map<String, dynamic> inputJson = {
                "court_name": selectedCourtInfo.split("@")[0],
                "caseNumberYear": selectedAccidentInfo.split("개회")[0],
                "caseNumberType": "개회",
                "caseNumberNumber": selectedAccidentInfo.split("개회")[1],
                "userName": MyData.name,
                "bankCode": selectedBankCodeInfo.split("@")[1],
                "account": selectedBankAccountInfo,
                "birthday": MyData.birth,
                "job": selectedJobInfo.split("@")[1],
                "lend_count": selectedPreLoanCountInfo.split("@")[1],
                "lend_amount": selectedPreLoanPriceInfo,
                "wish_amount": selectedWantLoanPriceInfo,

              };
              CommonUtils.log("i", "pr search info:\n$inputJson");

              selectedAccidentInfo = "2023개회1000794";
              Map<String, dynamic> inputJsonForTest = {
                "court_name": "서울회생법원",
                "caseNumberYear": selectedAccidentInfo.split("개회")[0],
                "caseNumberType": "개회",
                "caseNumberNumber": selectedAccidentInfo.split("개회")[1],
                "userName": "정혜경",
                "bankCode": "004",
                "account": "40240104",
                "birthday": "19690710",
                "job": "2",
                "lend_count": "1",
                "lend_amount": "500",
                "wish_amount": "300",
              };
              UiUtils.showLoadingPop(context);
              LogfinController.callLogfinApi(LogfinApis.prSearch, inputJsonForTest, (isSuccess, outputJson){
                if(isSuccess){
                  LogfinController.getUserInfo((isSuccessToGetUserInfo){
                    if(isSuccessToGetUserInfo){
                      LogfinController.getAccidentInfo((isSuccessToGetAccidentInfo, isNotEmpty){
                        if(isSuccessToGetAccidentInfo){
                          if(isNotEmpty){
                            CommonUtils.moveWithUntil(context, AppView.appMainView.value);
                          }else{
                            UiUtils.closeLoadingPop(context);
                            CommonUtils.flutterToast("사건정보 찾기 실패\n다시 실행해주세요.");
                          }
                        }else{
                          UiUtils.closeLoadingPop(context);
                          CommonUtils.flutterToast("사건정보 찾기 실패\n다시 실행해주세요.");
                        }
                      });
                    }else{
                      UiUtils.closeLoadingPop(context);
                      CommonUtils.flutterToast("사건정보 찾기 실패\n다시 실행해주세요.");
                    }
                  });
                }else{
                  // prSearch 실패
                  UiUtils.closeLoadingPop(context);
                  String errorMsg = outputJson!["error"];
                  CommonUtils.flutterToast(errorMsg.replaceAll("+", "").replaceAll("()", "").replaceAll(".", "\n"));
                }
              });
            })
      ])
    ]);
  }
  /// finish confirm view end

  void back(){
    CommonUtils.hideKeyBoard();
    if(currentViewId == courtViewId){
      Navigator.pop(context);
    }else{
      backInputView();
    }

  }

  @override
  Widget build(BuildContext context) {
    if(CommonUtils.isValidStateByAPiExpiredDate()){
      Widget? view;
      if(currentViewId == courtViewId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: Obx(()=>_getCourtView()));
      }else if(currentViewId == accidentViewId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getAccidentView());
      }else if(currentViewId == bankCodeViewId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: Obx(()=>_getBankCodeView()));
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

      return UiUtils.getViewWithAllowBackForAndroid(context, view, back);
    }else{
      CommonUtils.flutterToast("접속시간이 만료되었습니다.\n재로그인 해주세요");
      CommonUtils.backToHome(context);
      return Container();
    }
  }

}