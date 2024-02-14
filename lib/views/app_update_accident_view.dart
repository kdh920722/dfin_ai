import 'dart:async';
import 'package:dfin/controllers/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:dfin/controllers/logfin_controller.dart';
import 'package:dfin/datas/my_data.dart';
import 'package:dfin/styles/ColorStyles.dart';
import 'package:dfin/views/app_accident_detail_view.dart';
import 'package:dfin/views/app_main_view.dart';
import '../configs/app_config.dart';
import '../controllers/firebase_controller.dart';
import '../styles/TextStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppUpdateAccidentView extends StatefulWidget{
  @override
  AppUpdateAccidentViewState createState() => AppUpdateAccidentViewState();
}

class AppUpdateAccidentViewState extends State<AppUpdateAccidentView> with WidgetsBindingObserver{
  static BuildContext? mainContext;

  static bool isAccountEditMode = true;
  static int startViewId = 0;
  static int endViewId = 0;
  bool isPassToSearch = true;

  double scrollScreenHeight = 57.h;
  double itemHeight2 = 0;
  double itemFullHeight2 = 0;
  int maxVisibleItemCnt2 = 0;
  int lastVisibleItem1 = 0;
  bool isScrolling2= false;

  bool isInputValid = true;
  bool isViewHere = false;

  final _nameForTestTextFocus = FocusNode();
  final _nameForTestTextController = TextEditingController();


  final String errorMsg = "정보를 입력해주세요";
  int currentViewId = 1;

  static const int bankCodeViewId = 1;
  Key? selectedBankCodeKey;
  final ScrollController _bankScrollController = ScrollController();
  String selectedBankCodeInfo = "";

  static const int bankAccountViewId = 2;
  String selectedBankAccountInfo = "";
  final _bankAccountInfoFocus = FocusNode();
  final _bankAccountInfoTextController = TextEditingController();
  void _bankAccountInfoTextControllerListener() {
    if(_bankAccountInfoTextController.text.trim().length > 8){
      _bankAccountInfoTextController.text = _bankAccountInfoTextController.text.trim().substring(0,8);
    }
  }

  static const  int preLoanCountViewId = 4;
  Key? selectedPreLoanCountKey;
  String selectedPreLoanCountInfo = "";

  static const  int preLoanPriceViewId = 5;
  String selectedPreLoanPriceInfo = "";
  final _preLoanPriceFocus = FocusNode();
  final _preLoanPriceTextController = TextEditingController();
  void _preLoanPriceInfoTextControllerListener() {
    if(_preLoanPriceTextController.text.trim().length > 8){
      _preLoanPriceTextController.text = _preLoanPriceTextController.text.trim().substring(0, 8);
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

  static const  int wantLoanPriceViewId = 6;
  String selectedWantLoanPriceInfo = "";
  final _wantLoanPriceFocus = FocusNode();
  final _wantLoanPriceTextController = TextEditingController();
  void _wantLoanPriceInfoTextControllerListener() {
    if(_wantLoanPriceTextController.text.trim().length > 8){
      _wantLoanPriceTextController.text = _wantLoanPriceTextController.text.trim().substring(0, 8);
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

  static const  int jobViewId = 7;
  Key? selectedJobKey;
  String selectedJobInfo = "";

  static const  int confirmedViewId = 3;
  bool isFinishedConfirmed = false;

  void _unFocusAllNodes(){
    _bankAccountInfoFocus.unfocus();
    _preLoanPriceFocus.unfocus();
    _wantLoanPriceFocus.unfocus();
    _nameForTestTextFocus.unfocus();
  }

  void _disposeAllTextControllers(){
    _bankScrollController.dispose();
    _bankAccountInfoTextController.dispose();
    _preLoanPriceTextController.dispose();
    _wantLoanPriceTextController.dispose();
    _nameForTestTextController.dispose();
  }

  void _checkView(){
    if(!isFinishedConfirmed){
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
      currentViewId = confirmedViewId;
    }
  }

  void _setSelectedInfo(){
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

    selectedBankAccountInfo = MyData.selectedAccidentInfoData!.accidentBankAccount;
    selectedPreLoanPriceInfo = MyData.selectedAccidentInfoData!.accidentLendAmount;
    selectedWantLoanPriceInfo = MyData.selectedAccidentInfoData!.accidentWishAmount;
    selectedPreLoanCountInfo = MyData.selectedAccidentInfoData!.accidentLendCount;
    selectedPreLoanCountKey = Key(MyData.selectedAccidentInfoData!.accidentLendCount);

    selectedJobInfo = MyData.jobInfo;
    selectedJobKey = Key(MyData.jobInfo);

    itemFullHeight2 = scrollScreenHeight*2;
    itemHeight2 = itemFullHeight2/LogfinController.bankList.length;
    maxVisibleItemCnt2 = (scrollScreenHeight/itemHeight2).ceil();
    int firstVisibleItem2 = 0;
    int lastVisibleItem2 = firstVisibleItem2+maxVisibleItemCnt2;
    if(firstVisibleItem2 <=0 ) firstVisibleItem2 = 0;
    if(lastVisibleItem2 >= LogfinController.bankList.length-1) lastVisibleItem2 = LogfinController.bankList.length-1;
    GetController.to.updateFirstIndex2_2(firstVisibleItem2);
    GetController.to.updateLastIndex2_2(lastVisibleItem2);
  }

  @override
  void initState(){
    CommonUtils.log("d", "AppUpdateAccidentView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bankAccountInfoTextController.addListener(_bankAccountInfoTextControllerListener);
    _preLoanPriceTextController.addListener(_preLoanPriceInfoTextControllerListener);
    _wantLoanPriceTextController.addListener(_wantLoanPriceInfoTextControllerListener);
    _checkView();
    GetController.to.resetPreLoanPrice();
    GetController.to.resetWantLoanPrice();

    _setSelectedInfo();

    currentViewId = startViewId;
    mainContext = context;
    Config.contextForEmergencyBack = context;
    Config.isEmergencyRoot = false;
    FireBaseController.setStateForForeground = null;
    isViewHere = true;
  }

  @override
  void dispose(){
    CommonUtils.log("d", "AppUpdateAccidentView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _unFocusAllNodes();
    _disposeAllTextControllers();
    GetController.to.resetPreLoanPrice();
    GetController.to.resetWantLoanPrice();
    if(startViewId != bankCodeViewId){
      Config.contextForEmergencyBack = AppMainViewState.mainContext;
    }else{
      Config.contextForEmergencyBack = AppAccidentDetailViewState.mainContext;
    }
    startViewId = 0;
    endViewId = 0;
    isViewHere = false;
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await CommonUtils.checkUpdate(context);
        CommonUtils.log('d','AppUpdateAccidentView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('d','AppUpdateAccidentView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('d','AppUpdateAccidentView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('d','AppUpdateAccidentView paused');
        break;
      default:
        break;
    }
  }

  void _scrollTo(ScrollController controller, double pos) {
    controller.jumpTo(pos);
  }

  Future<void> backInputView() async {
    if(currentViewId == wantLoanPriceViewId){
      if(selectedPreLoanCountInfo.split("@")[1] == "0"){
        currentViewId--;
      }
    }

    if(isInputValid){
      isInputValid = false;
      _unFocusAllNodes();
      CommonUtils.hideKeyBoard();
      await Future.delayed(const Duration(milliseconds: 120), () async {});
      if(currentViewId == startViewId){
        if(context.mounted) Navigator.pop(context, false);
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
      if(currentViewId == endViewId){
        _updateData();
      }else{
        setState(() {
          isInputValid = true;
          currentViewId++;
        });
      }
    }
  }

  /// bank code view
  Widget _getBankCodeView(){
    List<Widget> bankCodeList = [];
    Color textColor = ColorStyles.upFinBlack;
    FontWeight fontWeight = FontWeight.w500;
    for(int i=0 ; i<LogfinController.bankList.length ; i++){
      Key key = Key(LogfinController.bankList[i]);
      if(selectedBankCodeKey == key){
        textColor = ColorStyles.upFinBlack;
        fontWeight = FontWeight.w600;
      }else{
        textColor = ColorStyles.upFinBlack;
        fontWeight = FontWeight.w500;
        if(GetController.to.firstVisibleItem2_2.value >= 3){
          if(GetController.to.firstVisibleItem2_2.value-2 <= i && i <= GetController.to.firstVisibleItem2_2.value+1){
            textColor = Colors.black12;
            if(GetController.to.firstVisibleItem2_2.value+1 <= i && i <= GetController.to.firstVisibleItem2_2.value+1){
              textColor = Colors.black38;
            }
          }
        }

        if(GetController.to.lastVisibleItem2_2.value <= LogfinController.bankList.length-3){
          if(GetController.to.lastVisibleItem2_2.value-3 <= i && i <= GetController.to.lastVisibleItem2_2.value-1){
            textColor = Colors.black12;
            if(GetController.to.lastVisibleItem2_2.value-3 <= i && i <= GetController.to.lastVisibleItem2_2.value-3){
              textColor = Colors.black38;
            }
          }
        }
      }
      bankCodeList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                selectedBankCodeKey == key? UiUtils.getCustomCheckBox(key, 1.5, selectedBankCodeKey == key, ColorStyles.upFinButtonBlue, ColorStyles.upFinWhite,
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
                Expanded(child: UiUtils.getTextButtonWithFixedScale(LogfinController.bankList[i].split("@")[0], 15.sp, fontWeight, textColor, TextAlign.start, null, (){
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
      UiUtils.getMarginBox(0, 3.w),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("수정하실", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 0.5.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("환급계좌 은행을", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 0.5.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("선택해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("개인회생 신청 시 제출했던 본인의 계좌", 14.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
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

              GetController.to.updateFirstIndex2_2(firstVisibleItem2);
              GetController.to.updateLastIndex2_2(lastVisibleItem2);
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
        child: UiUtils.getExpandedScrollViewWithController(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: bankCodeList), _bankScrollController)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
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
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButton(() async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.w),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("수정하실", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("환급계좌번호를", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("입력해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextField(context, 90.w, TextStyles.upFinTextFormFieldTextStyle, _bankAccountInfoFocus, _bankAccountInfoTextController, TextInputType.number,
          UiUtils.getInputDecoration("", 0.sp, "", 0.sp), (value) { }),
      UiUtils.getExpandedScrollView(Axis.vertical, Container()),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, currentViewId == endViewId ? "수정하기" : "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        selectedBankAccountInfo = _bankAccountInfoTextController.text.trim();
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
    FontWeight fontWeight = FontWeight.w500;
    for(var each in LogfinController.preLoanCountList){
      Key key = Key(each);
      if(selectedPreLoanCountKey == key) {
        textColor = ColorStyles.upFinBlack;
        fontWeight = FontWeight.w600;
      }
      else{
        textColor = ColorStyles.upFinBlack;
        fontWeight = FontWeight.w500;
      }
      loanCountList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                selectedPreLoanCountKey == key? UiUtils.getCustomCheckBox(key, 1.5, selectedPreLoanCountKey == key, ColorStyles.upFinButtonBlue, ColorStyles.upFinWhite,
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
                Expanded(child: UiUtils.getTextButtonWithFixedScale(each.split("@")[0], 15.sp, fontWeight, textColor, TextAlign.start, null, (){
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
      UiUtils.getMarginBox(0, 3.w),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("이미 받고 있는", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 0.5.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("대출 횟수를 알려주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale2("개인회생 신청 이후에 받은 회생대출 횟수", 14.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: loanCountList)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
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
        UiUtils.getMarginBox(0, 3.w),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("개인회생 신청 이후", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 0.5.h),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("대출 잔액", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 5.h),
        Obx(()=>UiUtils.getTextFormField(context, 90.w, TextStyles.upFinTextFormFieldTextStyle, _preLoanPriceFocus, _preLoanPriceTextController, TextInputType.number, false,
            UiUtils.getInputDecorationForPrice("", 0.sp, GetController.to.preLoanPrice.value), (text) {
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
            backInputView();
          }),
        ])),
        UiUtils.getMarginBox(0, 3.w),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("희망 대출금액을", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 0.5.h),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("알려주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 5.h),
        Obx(()=>UiUtils.getTextFormField(context, 90.w, TextStyles.upFinTextFormFieldTextStyle, _wantLoanPriceFocus, _wantLoanPriceTextController, TextInputType.number, false,
            UiUtils.getInputDecorationForPrice("", 0.sp, GetController.to.wantLoanPrice.value), (text) {
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
    FontWeight fontWeight = FontWeight.w500;
    for(var each in LogfinController.jobList){
      Key key = Key(each);
      if(selectedJobKey == key) {
        textColor = ColorStyles.upFinBlack;
        fontWeight = FontWeight.w600;
      }
      else{
        textColor = ColorStyles.upFinBlack;
        fontWeight = FontWeight.w500;
      }
      jobList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                selectedJobKey == key? UiUtils.getCustomCheckBox(key, 1.5, selectedJobKey == key, ColorStyles.upFinButtonBlue, ColorStyles.upFinWhite,
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
                Expanded(child: UiUtils.getTextButtonWithFixedScale(each.split("@")[0], 15.sp, fontWeight, textColor, TextAlign.start, null, (){
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
      UiUtils.getMarginBox(0, 3.w),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("직업 구분을 선택해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),

      //test for input name
      MyData.isTestUser? SizedBox(width: 85.w, child:
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getTextWithFixedScale("테스트용) 사건번호 이름 입력", 10.sp, FontWeight.w600, ColorStyles.upFinRed, TextAlign.center, null),
        UiUtils.getTextField(context, 30.w, TextStyles.upFinTextFormFieldTextStyle, _nameForTestTextFocus, _nameForTestTextController, TextInputType.text,
            UiUtils.getInputDecoration("이름", 10.sp, "", 0.sp), (value) { }),
        UiUtils.getMarginBox(0, 5.h),
      ])) : UiUtils.getMarginBox(0, 0),

      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: jobList)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
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
  Widget _getConfirmView(){
    _setSelectedInfo();
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
    if(selectedPreLoanPriceInfo != "0"){
      confirmDataList.add("•  인가후 대출  ${selectedPreLoanCountInfo.split("@")[0]}");
      confirmDataList.add("•  인가후 대출 잔액  ${CommonUtils.getPriceFormattedString(double.parse(selectedPreLoanPriceInfo))}");
    }else{
      confirmDataList.add("•  인가후 대출 없음");
    }
    if(selectedWantLoanPriceInfo != "0"){
      confirmDataList.add("•  희망 대출금액  ${CommonUtils.getPriceFormattedString(double.parse(selectedWantLoanPriceInfo))}");
    }else{
      //confirmDataList.add("•  희망 대출금액  0원");
    }
    confirmDataList.add("•  ${selectedJobInfo.split("@")[0]}");

    List<Widget> confirmWidgetList = [];
    Color textColor = ColorStyles.upFinBlack;

    confirmWidgetList.add(
      SizedBox(width: 80.w, child: UiUtils.getTextButtonWithFixedScale("기본정보", 16.sp, FontWeight.w600, textColor, TextAlign.start, null, (){})),
    );
    confirmWidgetList.add(
      UiUtils.getMarginBox(0, 3.h),
    );
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
      UiUtils.getMarginBox(0, 3.w),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("해당 정보로", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 0.5.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("대출상품을 찾아볼까요?", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: confirmWidgetList)),
      UiUtils.getMarginBox(0, 5.h),
      Row(children: [
        UiUtils.getBorderButtonBox(42.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
            UiUtils.getTextWithFixedScale("네 좋아요!", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
              isPassToSearch = true;
              _updateData();
            }),
        UiUtils.getMarginBox(2.w, 0),
        UiUtils.getBorderButtonBox(42.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinWhiteSky,
            UiUtils.getTextWithFixedScale("정보변경", 14.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, null), () {
              isPassToSearch = false;
              nextInputView();
            })
      ])
    ]);
  }
  /// finish confirm view end

  void _updateData(){
    if(isAccountEditMode){
      var inputJson = {
        "bankCode": selectedBankCodeInfo.split("@")[1],
        "account": selectedBankAccountInfo,
        "uid": MyData.selectedAccidentInfoData!.accidentUid,
        "court_name": MyData.selectedAccidentInfoData!.accidentCourtInfo.split("@")[0],
        "accident_no": MyData.selectedAccidentInfoData!.accidentCaseNumberYear+
            MyData.selectedAccidentInfoData!.accidentCaseNumberType+
            MyData.selectedAccidentInfoData!.accidentCaseNumberNumber,
      };
      UiUtils.showLoadingPop(context);
      LogfinController.callLogfinApi(LogfinApis.bankUpdateInfo, inputJson, (isSuccess, outputJson){
        if(isSuccess){
          _setAccidentAndUserInfo((isSuccessToUpdate){
            UiUtils.closeLoadingPop(context);
            if(isSuccessToUpdate){
              Navigator.pop(context, true);
              CommonUtils.flutterToast("수정 완료했어요.");
            }else{
              Navigator.pop(context, false);
              CommonUtils.flutterToast("수정된정보 불러오기에\n실패했어요.");
            }
          });
        }else{
          UiUtils.closeLoadingPop(context);
          Navigator.pop(context, false);
          CommonUtils.flutterToast("은행코드,계좌정보가\n일치하지 않아요.");
        }
      });
    }else{
      Map<String, dynamic> inputJsonForTest = {
        "court_name": MyData.selectedAccidentInfoData!.accidentCourtInfo.split("@")[0],
        "caseNumberYear": MyData.selectedAccidentInfoData!.accidentCaseNumberYear,
        "caseNumberType": "개회",
        "caseNumberNumber": MyData.selectedAccidentInfoData!.accidentCaseNumberNumber,
        "userName": MyData.isTestUser? _nameForTestTextController.text.trim() : MyData.name,// for test : MyData.name
        "bankCode": selectedBankCodeInfo.split("@")[1],
        "account": selectedBankAccountInfo,
        "birthday": MyData.birth,
        "job": selectedJobInfo.split("@")[1],
        "lend_count": selectedPreLoanCountInfo.split("@")[1],
        "lend_amount": selectedPreLoanPriceInfo,
        "wish_amount": selectedWantLoanPriceInfo,
      };
      UiUtils.showLoadingPop(context);
      if(isPassToSearch){
        LogfinController.getAccidentPrList("${MyData.selectedAccidentInfoData!.accidentCaseNumberYear}${MyData.selectedAccidentInfoData!.accidentCaseNumberType}${MyData.selectedAccidentInfoData!.accidentCaseNumberNumber}", (isSuccessToGetOffers, _){
          UiUtils.closeLoadingPop(context);
          if(isSuccessToGetOffers){
            CommonUtils.moveWithReplacementTo(context, AppView.appResultPrView.value, null);
          }else{
            CommonUtils.flutterToast("에러가 발생했습니다.\n다시 실행해주세요.");
            Navigator.pop(context);
          }
        });
      }else{
        LogfinController.callLogfinApi(LogfinApis.prSearch, inputJsonForTest, (isSuccess, outputJson){
          if(isSuccess){
            _setAccidentAndUserInfo((isSuccessToUpdate){
              if(isSuccessToUpdate){
                LogfinController.getAccidentPrList("${MyData.selectedAccidentInfoData!.accidentCaseNumberYear}${MyData.selectedAccidentInfoData!.accidentCaseNumberType}${MyData.selectedAccidentInfoData!.accidentCaseNumberNumber}", (isSuccessToGetOffers, _){
                  UiUtils.closeLoadingPop(context);
                  if(isSuccessToGetOffers){
                    String thisAccidentNum = MyData.selectedAccidentInfoData!.accidentCaseNumberYear+MyData.selectedAccidentInfoData!.accidentCaseNumberType+MyData.selectedAccidentInfoData!.accidentCaseNumberNumber;
                    String updatedAccidentUid = MyData.findUidInAccidentInfoList(thisAccidentNum);
                    for(var each in MyData.getAccidentInfoList()){
                      if(each.accidentUid == updatedAccidentUid){
                        MyData.selectedAccidentInfoData = each;
                      }
                    }
                    CommonUtils.moveWithReplacementTo(context, AppView.appResultPrView.value, null);
                  }else{
                    CommonUtils.flutterToast("상품정보가 없어요.");
                    Navigator.pop(context);
                  }
                });
              }else{
                UiUtils.closeLoadingPop(context);
                CommonUtils.flutterToast("등록된 사건정보가 없습니다.");
                Navigator.pop(context);
              }
            });
          }else{
            UiUtils.closeLoadingPop(context);
            CommonUtils.flutterToast("등록된 사건정보가 없습니다.");
            Navigator.pop(context);
          }
        });
      }
    }
  }

  Future<void> _setAccidentAndUserInfo(Function(bool isSuccess) callback)async{
    LogfinController.getAccidentInfo((isSuccessToGetAccidentInfo, isNotEmpty){
      if(isSuccessToGetAccidentInfo){
        if(isNotEmpty){
          LogfinController.getUserInfo((isSuccessToGetUserInfo){
            if(isSuccessToGetUserInfo){
              callback(true);
            }else{
              callback(false);
            }
          });
        }else{
          callback(false);
        }
      }else{
        callback(false);
      }
    });
  }

  void _scrollBankCode(){
    double scrollSize = _bankScrollController.position.maxScrollExtent;
    int size = LogfinController.bankList.length;
    double eachSize = scrollSize/size;
    int posIdx = LogfinController.bankList.indexOf(selectedBankCodeInfo);
    if(posIdx != -1){
      double pos = eachSize*posIdx;
      _scrollTo(_bankScrollController, pos);
    }
  }

  void _back(){
    CommonUtils.hideKeyBoard();
    if(currentViewId == startViewId){
      isViewHere = false;
      Navigator.pop(context, false);
    }else{
      backInputView();
    }
  }

  bool isAutoScrollableForTarget = true;
  @override
  Widget build(BuildContext context) {
    Widget? view;
    if(currentViewId == bankCodeViewId){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(isViewHere){
          if(isAutoScrollableForTarget) {
            isAutoScrollableForTarget = false;
            _scrollBankCode();
          }
        }
      });
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: Obx(()=>_getBankCodeView()));
    }else if(currentViewId == bankAccountViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getBankAccountView());
    }else if(currentViewId == preLoanCountViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getPreLoanCountView());
    }else if(currentViewId == preLoanPriceViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getPreLoanPriceView());
    }else if(currentViewId == wantLoanPriceViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getWantLoanPriceView());
    }else if(currentViewId == jobViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getJobView());
    }else{
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getConfirmView());
    }
    return UiUtils.getViewWithAllowBackForAndroid(context, view, _back);
  }

}