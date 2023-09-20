import 'dart:async';
import 'package:flutter/scheduler.dart';
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

class AppUpdateAccidentView extends StatefulWidget{
  @override
  AppUpdateAccidentViewState createState() => AppUpdateAccidentViewState();
}

class AppUpdateAccidentViewState extends State<AppUpdateAccidentView> with WidgetsBindingObserver{
  bool isInputValid = true;

  final String errorMsg = "정보를 입력해주세요";
  int currentViewId = 1;

  final int bankCodeViewId = 1;
  Key? selectedBankCodeKey;
  final ScrollController _bankScrollController = ScrollController();
  String selectedBankCodeInfo = "";

  final int bankAccountViewId = 2;
  String selectedBankAccountInfo = "";
  final _bankAccountInfoFocus = FocusNode();
  final _bankAccountInfoTextController = TextEditingController();
  void _bankAccountInfoTextControllerListener() {
    if(_bankAccountInfoTextController.text.trim().length > 8){
      _bankAccountInfoTextController.text = _bankAccountInfoTextController.text.trim().substring(0,8);
    }
  }

  final int preLoanCountViewId = 3;
  Key? selectedPreLoanCountKey;
  String selectedPreLoanCountInfo = "";

  final int preLoanPriceViewId = 4;
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

  final int wantLoanPriceViewId = 5;
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

  final int jobViewId = 6;
  Key? selectedJobKey;
  String selectedJobInfo = "";

  final int finishedViewId = 7;
  bool finishedConfirmed = false;

  void _unFocusAllNodes(){
    _bankAccountInfoFocus.unfocus();
    _preLoanPriceFocus.unfocus();
    _wantLoanPriceFocus.unfocus();
  }

  void _disposeAllTextControllers(){
    _bankScrollController.dispose();
    _bankAccountInfoTextController.dispose();
    _preLoanPriceTextController.dispose();
    _wantLoanPriceTextController.dispose();
  }

  void _checkView(){
    if(!finishedConfirmed){
      if(selectedBankCodeInfo.isEmpty){
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
    _bankAccountInfoTextController.addListener(_bankAccountInfoTextControllerListener);
    _preLoanPriceTextController.addListener(_preLoanPriceInfoTextControllerListener);
    _wantLoanPriceTextController.addListener(_wantLoanPriceInfoTextControllerListener);
    _checkView();
    GetController.to.resetPreLoanPrice();
    GetController.to.resetWantLoanPrice();
    selectedBankCodeKey = Key(MyData.selectedAccidentInfoData!.accidentBankInfo);
    selectedBankCodeInfo = MyData.selectedAccidentInfoData!.accidentBankInfo;

    _bankAccountInfoTextController.text = MyData.selectedAccidentInfoData!.accidentBankAccount;

    _preLoanPriceTextController.text = MyData.selectedAccidentInfoData!.accidentLendAmount;
    final number = double.tryParse(_preLoanPriceTextController.text.trim().replaceAll(',', ''));
    GetController.to.updatePreLoanPrice(CommonUtils.getPriceFormattedString(number!));

    _wantLoanPriceTextController.text = MyData.selectedAccidentInfoData!.accidentWishAmount;
    if(_wantLoanPriceTextController.text.trim() != ""){
      final number = double.tryParse(_wantLoanPriceTextController.text.trim().replaceAll(',', ''));
      GetController.to.updateWantLoanPrice(CommonUtils.getPriceFormattedString(number!));
    }

    selectedPreLoanCountInfo = MyData.selectedAccidentInfoData!.accidentLendCount;
    selectedPreLoanCountKey = Key(MyData.selectedAccidentInfoData!.accidentLendCount);

    selectedJobInfo = MyData.selectedAccidentInfoData!.accidentJobInfo;
    selectedJobKey = Key(MyData.selectedAccidentInfoData!.accidentJobInfo);
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

  void _scrollTo(ScrollController controller, double pos) {
    controller.jumpTo(pos);
  }

  Future<void> backInputView() async {
    if(isInputValid){
      isInputValid = false;
      _unFocusAllNodes();
      CommonUtils.hideKeyBoard();
      await Future.delayed(const Duration(milliseconds: 120), () async {});
      if(currentViewId-1 == 0){
        if(context.mounted) Navigator.pop(context);
      }else{
        setState(() {
          isInputValid = true;
          currentViewId--;
        });
      }
    }
  }

  Future<void> nextInputView() async {
    if(isInputValid){
      isInputValid = false;
      _unFocusAllNodes();
      CommonUtils.hideKeyBoard();
      await Future.delayed(const Duration(milliseconds: 120), () async {});
      setState(() {
        isInputValid = true;
        currentViewId++;
      });
    }
  }

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
                selectedBankCodeKey == key? UiUtils.getCustomCircleCheckBox(key, 1.5, selectedBankCodeKey == key, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                      setState(() {
                        if(checkedValue != null){
                          if(checkedValue) {
                            selectedBankCodeKey = key;
                            selectedBankCodeInfo = each;
                          }
                        }
                      });
                    }) : UiUtils.getCustomCircleCheckBox(key, 1.5, true, ColorStyles.upFinGray, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                      setState(() {
                        if(checkedValue != null){
                          if(!checkedValue) {
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
      UiUtils.getExpandedScrollViewWithController(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: bankCodeList), _bankScrollController),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        CommonUtils.log("i", "bank code : $selectedBankCodeInfo");
        if(selectedBankCodeInfo.isNotEmpty){
          isAutoScrollableForTarget = true;
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
                selectedPreLoanCountKey == key? UiUtils.getCustomCircleCheckBox(key, 1.5, selectedPreLoanCountKey == key, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                      setState(() {
                        if(checkedValue != null){
                          if(checkedValue) {
                            selectedPreLoanCountKey = key;
                            selectedPreLoanCountInfo = each;
                          }
                        }
                      });
                    }) : UiUtils.getCustomCircleCheckBox(key, 1.5, true, ColorStyles.upFinGray, ColorStyles.upFinWhite,
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
                UiUtils.getTextStyledButtonWithFixedScale(each.split("@")[0], 15.sp, FontWeight.w600, textColor, TextAlign.start, null, (){
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
        }else{
          CommonUtils.flutterToast(errorMsg);
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
        if(selectedPreLoanPriceInfo != "0"){
          nextInputView();
        }else{
          CommonUtils.flutterToast(errorMsg);
        }
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
        if(selectedWantLoanPriceInfo != "0"){
          nextInputView();
        }else{
          CommonUtils.flutterToast(errorMsg);
        }
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
                selectedJobKey == key? UiUtils.getCustomCircleCheckBox(key, 1.5, selectedJobKey == key, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                      setState(() {
                        if(checkedValue != null){
                          if(checkedValue) {
                            selectedJobKey = key;
                            selectedJobInfo = each;
                          }
                        }
                      });
                    }) : UiUtils.getCustomCircleCheckBox(key, 1.5, true, ColorStyles.upFinGray, ColorStyles.upFinWhite,
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
        }else{
          CommonUtils.flutterToast(errorMsg);
        }
      })
    ]);
  }
  /// job view end

  /// finish confirm view
  Widget _getFinishConfirmView(){
    String court = MyData.selectedAccidentInfoData!.accidentCourtInfo.split("@")[0];
    String accidentNo = "${MyData.selectedAccidentInfoData!.accidentCaseNumberYear}${MyData.selectedAccidentInfoData!.accidentCaseNumberType}${MyData.selectedAccidentInfoData!.accidentCaseNumberNumber}";
    List<String> confirmDataList = [];
    confirmDataList.add("[환급]  ${selectedBankCodeInfo.split("@")[0]} $selectedBankAccountInfo");
    confirmDataList.add("기대출  ${selectedPreLoanCountInfo.split("@")[0]}");
    if(selectedPreLoanPriceInfo != "0"){
      confirmDataList.add("인가후 대출금액  ${CommonUtils.getPriceFormattedString(double.parse(selectedPreLoanPriceInfo))}");
    }else{
      confirmDataList.add("인가후 대출금액  0원");
    }
    if(selectedWantLoanPriceInfo != "0"){
      confirmDataList.add("희망 대출금액  ${CommonUtils.getPriceFormattedString(double.parse(selectedWantLoanPriceInfo))}");
    }else{
      confirmDataList.add("희망 대출금액  0원");
    }
    confirmDataList.add(selectedJobInfo.split("@")[0]);

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
                UiUtils.getTextStyledButtonWithFixedScale(each, 13.sp, FontWeight.w800, textColor, TextAlign.center, null, (){})
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
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale(court, 20.sp, FontWeight.w800, ColorStyles.upFinBlack, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 0.5.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale(accidentNo, 20.sp, FontWeight.w800, ColorStyles.upFinBlack, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("해당 사건번호의 정보를", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("수정할까요?", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: confirmWidgetList)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "네 좋아요!", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () {
        Map<String, dynamic> inputJson = {
          "bankCode": selectedBankCodeInfo.split("@")[1],
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
          "lend_count": "1",
          "lend_amount": "500",
          "wish_amount": "300",
        };

        UiUtils.showLoadingPop(context);
        LogfinController.callLogfinApi(LogfinApis.prSearch, inputJsonForTest, (isSuccess, outputJson){
          if(isSuccess){
            // 메인뷰로 이동
            MyData.resetMyData();
            LogfinController.getMainOrSearchView((isSuccessToGetViewInfo, viewInfo){
              UiUtils.closeLoadingPop(context);
              if(isSuccessToGetViewInfo){
                CommonUtils.moveWithReplacementTo(context, viewInfo!.value, null);
              }else{
                CommonUtils.flutterToast("화면을 불러오는데 실패했습니다.\n다시 실행해주세요.");
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
    ]);
  }
  /// finish confirm view end

  void _scrollBankCode(){
    double scrollSize = _bankScrollController.position.maxScrollExtent;
    int size = LogfinController.bankList.length;
    double eachSize = scrollSize/size;
    int posIdx = LogfinController.bankList.indexOf(selectedBankCodeInfo);
    if(posIdx != -1){
      double pos = eachSize*posIdx;
      _scrollTo(_bankScrollController, pos);
    }else{
      CommonUtils.log("e", "!!!!!");
    }
  }

  bool isAutoScrollableForTarget = true;
  @override
  Widget build(BuildContext context) {
    Widget? view;

    if(currentViewId == bankCodeViewId){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(isAutoScrollableForTarget) {
          isAutoScrollableForTarget = false;
          _scrollBankCode();
        }
      });
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