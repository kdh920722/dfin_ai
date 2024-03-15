import 'dart:async';
import 'package:dfin/controllers/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:dfin/controllers/logfin_controller.dart';
import 'package:dfin/datas/my_data.dart';
import 'package:dfin/styles/ColorStyles.dart';
import '../configs/app_config.dart';
import '../controllers/firebase_controller.dart';
import '../styles/TextStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';
import 'app_car_detail_view.dart';

class AppUpdateCarView extends StatefulWidget{
  @override
  AppUpdateCarViewState createState() => AppUpdateCarViewState();
}

class AppUpdateCarViewState extends State<AppUpdateCarView> with WidgetsBindingObserver{
  static BuildContext? mainContext;

  static int startViewId = 0;
  static int endViewId = 0;

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
  int currentViewId = 0;

  static const  int preLoanCountViewId = 99;
  Key? selectedPreLoanCountKey;
  String selectedPreLoanCountInfo = "";

  static const  int preLoanPriceViewId = 99;
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

  static int preLoanInfoViewId = 5;
  static int eachPreLoanPriceViewId = 10;
  List<Map<String,dynamic>> selectedEachPreLoanPriceInfo = [];
  final _eachPreLoanPriceFocus = FocusNode();
  final _eachPreLoanPriceTextController = TextEditingController();
  void _eachPreLoanPriceInfoTextControllerListener() {
    if(!isChecked){
      if(_eachPreLoanPriceTextController.text.trim().length > 8){
        _eachPreLoanPriceTextController.text = _eachPreLoanPriceTextController.text.trim().substring(0, 8);
      }else{
        final text = _eachPreLoanPriceTextController.text.trim();
        final number = double.tryParse(text.replaceAll(',', '')); // 콤마 제거 후 숫자 변환
        if (number != null) {
          final formattedText = CommonUtils.getPriceCommaFormattedString(number);
          if (formattedText != text) {
            _eachPreLoanPriceTextController.value = TextEditingValue(text: formattedText, selection: TextSelection.collapsed(offset: formattedText.length));
          }
        }
      }
    }else{
      _eachPreLoanPriceTextController.text = "0";
      _setEachPreLoanInfo("0");
      for(Map<String, dynamic> eachMap in savedRegBInfoList){
        if(currRegBInfo["resLedgerBNo"] == eachMap["resLedgerBNo"]){
          eachMap["preLoanPrice"] = "0";
        }
      }
    }

  }

  static const  int jobViewId = 4;
  Key? selectedJobKey;
  String selectedJobInfo = "";

  static const  int confirmedViewId = 3;
  bool isFinishedConfirmed = false;

  void _unFocusAllNodes(){
    _preLoanPriceFocus.unfocus();
    _eachPreLoanPriceFocus.unfocus();
    _nameForTestTextFocus.unfocus();
  }

  void _disposeAllTextControllers(){
    _preLoanPriceTextController.dispose();
    _eachPreLoanPriceTextController.dispose();
    _nameForTestTextController.dispose();
  }

  void _checkView(){
    if(!isFinishedConfirmed){
      if(selectedJobInfo.isEmpty){
        currentViewId = jobViewId;
      }
    }else{
      currentViewId = confirmedViewId;
    }
  }

  void _setEachPreLoanInfo(String loanAmount){
    _eachPreLoanPriceTextController.text = loanAmount;
    if(_eachPreLoanPriceTextController.text.trim() != ""){
      final number = double.tryParse(_eachPreLoanPriceTextController.text.trim().replaceAll(',', ''));
      GetController.to.updatePreLoanPrice(CommonUtils.getPriceFormattedString(number!));
    }else{
      GetController.to.updatePreLoanPrice("만원");
    }
  }

  void _setSelectedInfo(){
    _preLoanPriceTextController.text = MyData.selectedCarInfoData!.carLendAmount;
    final number = double.tryParse(_preLoanPriceTextController.text.trim().replaceAll(',', ''));
    GetController.to.updatePreLoanPrice(CommonUtils.getPriceFormattedString(number!));

    selectedPreLoanPriceInfo = MyData.selectedCarInfoData!.carLendAmount;
    selectedEachPreLoanPriceInfo = MyData.selectedCarInfoData!.regBData;
    selectedPreLoanCountInfo = MyData.selectedCarInfoData!.carLendCount;
    selectedPreLoanCountKey = Key(MyData.selectedCarInfoData!.carLendCount);

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
    CommonUtils.log("d", "AppUpdateCarView 화면 입장");
    super.initState();
    isEditMode = false;
    WidgetsBinding.instance.addObserver(this);
    _preLoanPriceTextController.addListener(_preLoanPriceInfoTextControllerListener);
    _eachPreLoanPriceTextController.addListener(_eachPreLoanPriceInfoTextControllerListener);
    _checkView();
    GetController.to.resetPreLoanPrice();
    _setSelectedInfo();

    if(MyData.selectedCarInfoData!.regBData.isEmpty){
      preLoanInfoViewId = 99;
      eachPreLoanPriceViewId = 99;
    }

    savedRegBInfoList = MyData.selectedCarInfoData!.regBData;

    currentViewId = startViewId;
    mainContext = context;
    Config.contextForEmergencyBack = context;
    Config.isEmergencyRoot = false;
    FireBaseController.setStateForForeground = null;
    isViewHere = true;
  }

  @override
  void dispose(){
    CommonUtils.log("d", "AppUpdateCarView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    isEditMode = false;
    _unFocusAllNodes();
    _disposeAllTextControllers();
    GetController.to.resetPreLoanPrice();
    GetController.to.resetWantLoanPrice();
    Config.contextForEmergencyBack = AppCarDetailViewState.mainContext;
    preLoanInfoViewId = 5;
    eachPreLoanPriceViewId = 10;
    startViewId = 0;
    endViewId = 0;
    isViewHere = false;
    currRegBInfo = {};
    savedRegBInfoList = [];
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await CommonUtils.checkUpdate(context);
        CommonUtils.log('d','AppUpdateCarView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('d','AppUpdateCarView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('d','AppUpdateCarView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('d','AppUpdateCarView paused');
        break;
      default:
        break;
    }
  }

  void _scrollTo(ScrollController controller, double pos) {
    controller.jumpTo(pos);
  }

  Future<void> backInputView() async {
    /*
    if(currentViewId == jobViewId){
      if(selectedPreLoanCountInfo.split("@")[1] == "0"){
        currentViewId--;
      }
    }
     */

    if(isInputValid){
      isInputValid = false;
      _unFocusAllNodes();
      CommonUtils.hideKeyBoard();
      await Future.delayed(const Duration(milliseconds: 120), () async {});
      if(currentViewId == startViewId){
        if(context.mounted) Navigator.pop(context, false);
      }else{
        if(!isEditMode && currentViewId == preLoanInfoViewId){
          currentViewId--;
        }
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
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("이미 받고 있는", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 0.5.h),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("대출 잔액을 알려주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
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

  /// pre loan info view
  bool isChecked = false;
  Widget _getPreLoanInfoView(){
    List<Widget> confirmWidgetList = [];
    Color textColor = ColorStyles.upFinBlack;

    confirmWidgetList.add(
      UiUtils.getMarginBox(0, 3.h),
    );

    // todo : [저당] [표시] 저당에 대한 기대출 잔액 있다면, 표시(잔액 또는 미입력).
    if(MyData.selectedCarInfoData!.regBData.isNotEmpty){
      confirmWidgetList.add(
        UiUtils.getMarginBox(0, 2.h),
      );
      confirmWidgetList.add(
        SizedBox(width: 80.w, child: UiUtils.getTextButtonWithFixedScale("저당정보 ${MyData.selectedCarInfoData!.regBData.length}개", 16.sp, FontWeight.w600, textColor, TextAlign.start, null, (){})),
      );
      confirmWidgetList.add(
        UiUtils.getMarginBox(0, 2.h),
      );

      List<Widget> regBWidgetList = [];
      for(Map<String,dynamic> each in savedRegBInfoList){
        String eachPreLoanPrice = each["preLoanPrice"].toString();
        String eachPreLoanPriceTxt = "";
        if(eachPreLoanPrice == ""){
          eachPreLoanPriceTxt = "미입력";
        }else if(eachPreLoanPrice == "0"){
          eachPreLoanPriceTxt = "없음";
        }else{
          eachPreLoanPriceTxt = CommonUtils.getPriceFormattedString(double.parse(eachPreLoanPrice));
        }
        regBWidgetList.add(
          SizedBox(width: 85.w, child: UiUtils.getBorderButtonBoxForRound3(ColorStyles.upFinWhite, ColorStyles.upFinGray,
              Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                UiUtils.getMarginBox(0, 0.5.h),
                SizedBox(width: 80.w, child: UiUtils.getTextWithFixedScaleAndOverFlow("${each["resUserNm"]}", 14.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 1.5.h),
                UiUtils.getTextButtonWithFixedScale("•  을부번호 ${each["resLedgerBNo"]}", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null, (){}),
                UiUtils.getMarginBox(0, 0.5.h),
                UiUtils.getTextButtonWithFixedScale("•  채권가액 ${each["resBondPriceTxt"]}", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null, (){}),
                UiUtils.getMarginBox(0, 0.5.h),
                UiUtils.getTextButtonWithFixedScale("•  대출잔액 $eachPreLoanPriceTxt", 12.sp, FontWeight.w500, eachPreLoanPriceTxt == "미입력" ? ColorStyles.upFinRed : ColorStyles.upFinButtonBlue, TextAlign.start, null, (){}),
                UiUtils.getMarginBox(0, 1.h),
                Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                  const Spacer(flex: 2),
                  UiUtils.getTextButtonWithFixedScale("${each["commStartDateTxt2"]}", 9.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null, (){})
                ]),
                UiUtils.getMarginBox(0, 1.5.h),
                UiUtils.getBorderButtonBox(79.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinWhiteSky,
                    UiUtils.getTextWithFixedScale("입력하기", 12.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, null), () {
                      currRegBInfo = {};
                      currRegBInfo = each;
                      _setEachPreLoanInfo(each["preLoanPrice"].toString());

                      if(_eachPreLoanPriceTextController.text == "0"){
                        isChecked = true;
                      }else{
                        isChecked = false;
                      }
                      UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, true, 100.w, 80.h, 0.5, (slideContext, slideSetState){
                        return Material(
                            color: ColorStyles.upFinWhite,
                            child: GestureDetector(onTap: (){
                              if(_eachPreLoanPriceFocus.hasFocus){
                                CommonUtils.hideKeyBoard();
                              }
                            },
                            child: UiUtils.getRowColumnWithAlignCenter([
                              UiUtils.getMarginBox(85.w, 5.w),
                              SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("대출잔액을 알려주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
                              UiUtils.getMarginBox(85.w, 1.h),
                              SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("입력단위(*만원)", 12.sp, FontWeight.w600, ColorStyles.upFinRealGray, TextAlign.start, null)),
                              UiUtils.getMarginBox(85.w, 5.h),
                              Obx(()=>UiUtils.getTextFormField(context, 90.w, TextStyles.upFinTextFormFieldTextStyle, _eachPreLoanPriceFocus, _eachPreLoanPriceTextController, TextInputType.number, false,
                                  UiUtils.getInputDecorationForPrice("", 0.sp, GetController.to.preLoanPrice.value), (text) {
                                    if(!isChecked){
                                      if(text.trim() != ""){
                                        final number = double.tryParse(text.replaceAll(',', '')); // 콤마 제거 후 숫자 변환
                                        GetController.to.updatePreLoanPrice(CommonUtils.getPriceFormattedString(number!));
                                      }else{
                                        GetController.to.updatePreLoanPrice("만원");
                                      }
                                    }
                                  }, (value){})
                              ),
                              UiUtils.getMarginBox(85.w, 1.h),
                              SizedBox(width: 83.w, child: UiUtils.getTextWithFixedScale("•  을부번호 ${currRegBInfo["resLedgerBNo"]}", 12.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
                              UiUtils.getMarginBox(85.w, 0.5.h),
                              SizedBox(width: 83.w, child: UiUtils.getTextWithFixedScale("•  채권가액 ${currRegBInfo["resBondPriceTxt"]}", 12.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
                              SizedBox(width: 90.w, child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                UiUtils.getCustomCheckBox(UniqueKey(), 1.2, isChecked, ColorStyles.upFinWhite, ColorStyles.upFinButtonBlue,
                                    ColorStyles.upFinGray, ColorStyles.upFinButtonBlue, (checkedValue){
                                      slideSetState(() {
                                        CommonUtils.hideKeyBoard();
                                        if(checkedValue != null){
                                          isChecked = checkedValue;
                                          if(isChecked){
                                            _eachPreLoanPriceTextController.text = "0";
                                            _setEachPreLoanInfo("0");
                                            for(Map<String, dynamic> eachMap in savedRegBInfoList){
                                              if(currRegBInfo["resLedgerBNo"] == eachMap["resLedgerBNo"]){
                                                eachMap["preLoanPrice"] = eachPreLoanPrice;
                                              }
                                            }
                                          }else{
                                            _setEachPreLoanInfo("");
                                            _eachPreLoanPriceTextController.text = "";
                                          }
                                        }
                                      });
                                    }),
                                UiUtils.getTextWithFixedScale("대출잔액이 없어요.", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null),
                              ])),
                              Expanded(child: Container(color: ColorStyles.upFinWhite, width: 85.w,)),
                              UiUtils.getTextButtonBox(90.w, "확인", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
                                String eachPreLoanPrice = "";
                                if(_eachPreLoanPriceTextController.text.trim() != ""){
                                  final number = double.tryParse(_eachPreLoanPriceTextController.text.trim().replaceAll(',', '')); // 콤마 제거 후 숫자 변환
                                  String price = number.toString();
                                  if(price.contains(".")){
                                    price = price.split(".")[0];
                                  }
                                  eachPreLoanPrice = price;

                                  for(Map<String, dynamic> eachMap in savedRegBInfoList){
                                    if(currRegBInfo["resLedgerBNo"] == eachMap["resLedgerBNo"]){
                                      eachMap["preLoanPrice"] = eachPreLoanPrice;
                                    }
                                  }
                                  currRegBInfo = {};
                                  Navigator.pop(slideContext);
                                  setState(() {});
                                }else{
                                  CommonUtils.flutterToast("대출 잔액을 입력하세요.");
                                }
                              }),
                              UiUtils.getMarginBox(0, 1.h),
                              UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinWhiteSky,
                                  UiUtils.getTextWithFixedScale("다음에 할게요", 14.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, null), (){
                                    for(Map<String, dynamic> eachMap in savedRegBInfoList){
                                      if(currRegBInfo["resLedgerBNo"] == eachMap["resLedgerBNo"]){
                                        eachMap["preLoanPrice"] = "";
                                      }
                                    }
                                    currRegBInfo = {};
                                    Navigator.pop(slideContext);
                                    setState(() {});
                                  }),
                              Config.isAndroid ?UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 5.h)
                            ]))
                        );
                      });
                    }),
                UiUtils.getMarginBox(0, 0.5.h),
              ]), () { })),
        );
        regBWidgetList.add(UiUtils.getMarginBox(0, 1.5.h));
      }

      confirmWidgetList.add(Column(children: regBWidgetList));
    }

    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        startViewId == preLoanInfoViewId ? UiUtils.getMarginBox(0, 5.w) : UiUtils.getBackButton(() async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.w),
      savedRegBInfoList.length == 1 ? SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("저당에 대한", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null))
       : SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("각 저당에 대한", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 0.5.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("대출잔액을 입력하세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: confirmWidgetList)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        if(startViewId == preLoanInfoViewId){
          isEditMode = true;
        }

        if(isEditMode){
          CommonUtils.log("w","수정모드");
          bool isAllInput = true;
          for(Map<String, dynamic> eachMap in savedRegBInfoList){
            if(eachMap["preLoanPrice"].toString() == ""){
              isAllInput = false;
            }
          }

          if(!isAllInput){
            _checkInputRegBData();
          }else{
            nextInputView();
          }
        }else{
          CommonUtils.log("w","수정모드 아님");
          nextInputView();
        }
      })
    ]);
  }
  /// pre loan info view end
  bool isEditMode = false;
  void _checkInputRegBData(){
    UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, true, 100.w, Config.isAndroid ? Config.isPad()? 45.h : 35.h : Config.isPad()? 50.h : 40.h, 0.5, (slideContext, slideSetState){
      return Column(mainAxisAlignment: MainAxisAlignment.start, children:
      [
        UiUtils.getMarginBox(0, 2.h),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("아직 입력하지 않은 대출잔액이 있어요!", 14.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 3.h),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale2("대출잔액을 입력하시면,고객님에게 맞는\n더욱 정확한 대출상품을 찾으실 수 있습니다.", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 2.h),
        UiUtils.getExpandedScrollView(Axis.vertical, Container()),
        UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
            UiUtils.getTextWithFixedScale("대출잔액 입력하기", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), (){
              Navigator.pop(slideContext);
              if(!isEditMode){
                currentViewId++;
                nextInputView();
              }
            }),
        UiUtils.getMarginBox(0, 1.h),
        UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinWhiteSky,
            UiUtils.getTextWithFixedScale("대출상품 찾아보기", 14.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, null), (){
              Navigator.pop(slideContext);
              _updateData();
            }),
        Config.isAndroid? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 3.h)
      ]);
    });
  }

  /// each pre loan price view
  Map<String, dynamic> currRegBInfo = {};
  List<Map<String, dynamic>> savedRegBInfoList = [];

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
    confirmDataList.add("•  차량번호 ${MyData.selectedCarInfoData!.carNum}");
    confirmDataList.add("•  차량 시세금액 ${CommonUtils.getPriceFormattedStringForFullPrice(double.parse(MyData.selectedCarInfoData!.carPrice))}");

    /*
    if(selectedPreLoanCountInfo.split("@")[1] != "0"){
      confirmDataList.add("•  기대출  ${selectedPreLoanCountInfo.split("@")[0]}");
      confirmDataList.add("•  기대출 잔액  ${CommonUtils.getPriceFormattedString(double.parse(selectedPreLoanPriceInfo))}");
    }else{
      confirmDataList.add("•  기대출 없음");
    }
     */
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

    // todo : [저당] [표시] 저당에 대한 기대출 잔액 있다면, 표시(잔액 또는 미입력).
    if(MyData.selectedCarInfoData!.regBData.isNotEmpty){
      confirmWidgetList.add(
        UiUtils.getMarginBox(0, 2.h),
      );
      confirmWidgetList.add(
        SizedBox(width: 80.w, child: UiUtils.getTextButtonWithFixedScale("저당정보 ${MyData.selectedCarInfoData!.regBData.length}개", 16.sp, FontWeight.w600, textColor, TextAlign.start, null, (){})),
      );
      confirmWidgetList.add(
        UiUtils.getMarginBox(0, 2.h),
      );

      List<Widget> regBWidgetList = [];
      for(Map<String,dynamic> each in MyData.selectedCarInfoData!.regBData){
        String eachPreLoanPrice = each["preLoanPrice"].toString();
        String eachPreLoanPriceTxt = "";
        if(eachPreLoanPrice == ""){
          eachPreLoanPriceTxt = "미입력";
        }else if(eachPreLoanPrice == "0"){
          eachPreLoanPriceTxt = "없음";
        }else{
          eachPreLoanPriceTxt = CommonUtils.getPriceFormattedString(double.parse(eachPreLoanPrice));
        }
        regBWidgetList.add(
          SizedBox(width: 80.w, child: UiUtils.getBorderButtonBoxForRound3(ColorStyles.upFinWhite, ColorStyles.upFinGray,
              Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                UiUtils.getMarginBox(0, 0.5.h),
                SizedBox(width: 75.w, child: UiUtils.getTextWithFixedScaleAndOverFlow("${each["resUserNm"]}", 14.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 1.5.h),
                UiUtils.getTextButtonWithFixedScale("•  을부번호 ${each["resLedgerBNo"]}", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null, (){}),
                UiUtils.getMarginBox(0, 0.5.h),
                UiUtils.getTextButtonWithFixedScale("•  채권가액 ${each["resBondPriceTxt"]}", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null, (){}),
                UiUtils.getMarginBox(0, 0.5.h),
                UiUtils.getTextButtonWithFixedScale("•  대출잔액 $eachPreLoanPriceTxt", 12.sp, FontWeight.w500, eachPreLoanPriceTxt == "미입력" ? ColorStyles.upFinRed : ColorStyles.upFinButtonBlue, TextAlign.start, null, (){}),
                UiUtils.getMarginBox(0, 1.h),
                Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                  const Spacer(flex: 2),
                  UiUtils.getTextButtonWithFixedScale("${each["commStartDateTxt2"]}", 9.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null, (){})
                ]),
                UiUtils.getMarginBox(0, 0.5.h),
              ]), () { })),
        );
        regBWidgetList.add(UiUtils.getMarginBox(0, 1.5.h));
      }
      confirmWidgetList.add(Column(children: regBWidgetList));
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
      UiUtils.getMarginBox(0, 4.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: confirmWidgetList)),
      UiUtils.getMarginBox(0, 4.h),
      Row(children: [
        UiUtils.getBorderButtonBox(42.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
            UiUtils.getTextWithFixedScale("네 좋아요!", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
              bool isAllInput = true;
              for(Map<String, dynamic> eachMap in savedRegBInfoList){
                CommonUtils.log("w", "preLoanPrice : ${eachMap["preLoanPrice"]}");
                if(eachMap["preLoanPrice"].toString() == ""){
                  isAllInput = false;
                }
              }



              if(!isAllInput){
                _checkInputRegBData();
              }else{
                _updateData();
              }
            }),
        UiUtils.getMarginBox(2.w, 0),
        UiUtils.getBorderButtonBox(42.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinWhiteSky,
            UiUtils.getTextWithFixedScale("정보변경", 14.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, null), () {
              isEditMode = true;
              nextInputView();
            })
      ])
    ]);
  }
  /// finish confirm view end

  void _updateData(){
    UiUtils.showLoadingPop(context);
    // todo : [저당] [저장] 기대출 잔액 입력된 값 있으면 저장.
    List<Map<String, dynamic>> savedList = [];
    for(Map<String, dynamic> each in savedRegBInfoList){
      savedList.add({
        "res_ledger_b_no" : each["resLedgerBNo"].toString(),
        "rm_amount" : each["preLoanPrice"].toString()
      });
    }

    LogfinController.getCarPrList(MyData.selectedCarInfoData!.carNum, selectedJobInfo.split("@")[1],
        "0", // selectedPreLoanCountInfo.split("@")[1]
        "0", // selectedPreLoanPriceInfo
        savedList, (isSuccessToGetOffers, _){
      UiUtils.closeLoadingPop(context);
      if(isSuccessToGetOffers){
        CommonUtils.moveWithReplacementTo(context, AppView.appResultPrView.value, null);
      }else{
        CommonUtils.flutterToast("에러가 발생했습니다.\n다시 실행해주세요.");
        Navigator.pop(context);
      }
    });
  }

  void _back(){
    CommonUtils.hideKeyBoard();
    if(currentViewId == startViewId){
      if(startViewId != preLoanInfoViewId){
        isViewHere = false;
        Navigator.pop(context, false);
      }
    }else{
      if(!isEditMode && currentViewId == preLoanInfoViewId){
        currentViewId--;
      }
      backInputView();
    }
  }

  bool isAutoScrollableForTarget = true;
  @override
  Widget build(BuildContext context) {
    Widget? view;
    if(currentViewId == preLoanCountViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getPreLoanCountView());
    }else if(currentViewId == preLoanPriceViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getPreLoanPriceView());
    }else if(currentViewId == preLoanInfoViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getPreLoanInfoView());
    }else if(currentViewId == jobViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getJobView());
    }else{
      isEditMode = false;
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getConfirmView());
    }
    return UiUtils.getViewWithAllowBackForAndroid(context, view, _back);
  }

}