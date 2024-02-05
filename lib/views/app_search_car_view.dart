import 'dart:async';
import 'package:upfin/controllers/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:upfin/views/app_main_view.dart';
import '../configs/app_config.dart';
import '../controllers/firebase_controller.dart';
import '../styles/TextStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppSearchCarView extends StatefulWidget{
  @override
  AppSearchCarViewState createState() => AppSearchCarViewState();
}

class AppSearchCarViewState extends State<AppSearchCarView> with WidgetsBindingObserver{
  bool isInputValid = true;

  final String errorMsg = "정보를 입력해주세요";
  int currentViewId = 1;

  final int carViewId = 1;
  String selectedCarNum = "";
  String selectedCarOwner = "";
  final _carInfoFocus1 = FocusNode();
  final _carInfoFocus2 = FocusNode();
  final _carInfoTextController1 = TextEditingController();
  final _carInfoTextController2 = TextEditingController();
  void _carInfoTextController1Listener() {
    if(_carInfoTextController1.text.trim().length >= 9){
      _carInfoTextController1.text = _carInfoTextController1.text.substring(0,8);
    }
  }
  void _carInfoTextController2Listener() {
    if(_carInfoTextController2.text.trim().length >= 18){
      _carInfoTextController2.text = _carInfoTextController1.text.substring(0,17);
    }
  }

  final int preLoanCountViewId = 999;
  Key? selectedPreLoanCountKey;
  String selectedPreLoanCountInfo = "";

  final int preLoanPriceViewId = 999;
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

  final int wantLoanPriceViewId = 999;
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

  final int jobViewId = 2;
  Key? selectedJobKey;
  String selectedJobInfo = "";

  final int finishedViewId = 3;
  bool finishedConfirmed = false;

  void _unFocusAllNodes(){
    _carInfoFocus1.unfocus();
    _carInfoFocus2.unfocus();
    _preLoanPriceFocus.unfocus();
    _wantLoanPriceFocus.unfocus();
  }

  void _disposeAllTextControllers(){
    _carInfoTextController1.dispose();
    _carInfoTextController2.dispose();
    _preLoanPriceTextController.dispose();
    _wantLoanPriceTextController.dispose();
  }

  void _checkView(){
    if(!finishedConfirmed){
      if(selectedCarNum.isEmpty){
        currentViewId = carViewId;
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
    CommonUtils.log("d", "AppSearchCarView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _carInfoTextController1.addListener(_carInfoTextController1Listener);
    _carInfoTextController2.addListener(_carInfoTextController2Listener);
    _preLoanPriceTextController.addListener(_preLoanPriceInfoTextControllerListener);
    _wantLoanPriceTextController.addListener(_wantLoanPriceInfoTextControllerListener);

    _checkView();
    GetController.to.resetPreLoanPrice();
    GetController.to.resetWantLoanPrice();

    Config.contextForEmergencyBack = context;
    Config.isEmergencyRoot = false;
    FireBaseController.setStateForForeground = null;
  }

  @override
  void dispose(){
    CommonUtils.log("d", "AppSearchCarView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _unFocusAllNodes();
    _disposeAllTextControllers();
    GetController.to.resetPreLoanPrice();
    GetController.to.resetWantLoanPrice();
    Config.contextForEmergencyBack = AppMainViewState.mainContext;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('i','AppSearchCarView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('i','AppSearchCarView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('i','AppSearchCarView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('i','AppSearchCarView paused');
        break;
      default:
        break;
    }
  }

  Future<void> backInputView() async {
    /*
    if(currentViewId == jobViewId){
      if(selectedPreLoanCountInfo.split("@")[1] == "0"){
        currentViewId--;
      }
    }
     */

    if(isInputValid) {
      CommonUtils.log("w", "curr view id : $currentViewId");
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

  /// car view
  Widget _getCarView(){
    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButton(() async {
          _back();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("차량번호를 입력하세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("예) 12가3456", 14.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),

      //test for input name
      MyData.isTestUser? SizedBox(width: 85.w, child:
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getTextWithFixedScale("테스트용) 차량 소유자 입력", 10.sp, FontWeight.w600, ColorStyles.upFinRed, TextAlign.center, null),
        UiUtils.getTextField(context, 30.w, TextStyles.upFinTextFormFieldTextStyle, _carInfoFocus2, _carInfoTextController2, TextInputType.text,
            UiUtils.getInputDecoration("이름", 10.sp, "", 0.sp), (value) { }),
        UiUtils.getMarginBox(0, 5.h),
      ])) : UiUtils.getMarginBox(0, 0),

      UiUtils.getExpandedScrollView(Axis.vertical,
          SizedBox(width: 85.w, child: Row(children: [
            UiUtils.getTextField(context, 85.w, TextStyles.upFinTextFormFieldTextStyle, _carInfoFocus1, _carInfoTextController1, TextInputType.text,
                UiUtils.getInputDecoration("번호", 10.sp, "", 0.sp), (value) { }),
          ]))
      ),

      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        if(_carInfoTextController1.text.trim() != ""){
          selectedCarNum = _carInfoTextController1.text.trim();
          selectedCarOwner = MyData.isTestUser? _carInfoTextController2.text.trim() : "";

          bool isValid = true;
          for(var eachCar in MyData.getCarInfoList()){
            if(eachCar.carNum == selectedCarNum){
              selectedCarNum = "";
              isValid = false;
            }
          }

          if(isValid){
            nextInputView();
          }else{
            CommonUtils.flutterToast("이미 조회하신 차량번호에요.");
          }
        }else{
          CommonUtils.flutterToast(errorMsg);
        }
      })
    ]);
  }
  /// car view end

  /// car owner view
  Widget _getCarOwnerView(){
    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButton(() async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("차량 소유자를 입력하세요. ", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("예) 홍길동", 14.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),

      UiUtils.getExpandedScrollView(Axis.vertical,
          SizedBox(width: 85.w, child: Row(children: [
            UiUtils.getTextField(context, 35.w, TextStyles.upFinTextFormFieldTextStyle, _carInfoFocus2, _carInfoTextController2, TextInputType.text,
                UiUtils.getInputDecoration("", 0.sp, "", 0.sp), (value) { }),
          ]))
      ),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        if(_carInfoTextController2.text.trim() != ""){
          selectedCarOwner = _carInfoTextController2.text.trim();
          nextInputView();
        }else{
          CommonUtils.flutterToast(errorMsg);
        }
      })
    ]);
  }
  /// car owner view end

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
        fontWeight = FontWeight.w500;
        textColor = ColorStyles.upFinBlack;
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
      UiUtils.getMarginBox(0, 3.h),
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
        UiUtils.getMarginBox(0, 3.h),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("이미 받고 있는", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 0.5.h),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("대출 잔액을 알려주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 5.h),
        Obx(()=>
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              UiUtils.getTextFormField(context, 90.w, TextStyles.upFinTextFormFieldTextStyle, _preLoanPriceFocus, _preLoanPriceTextController, TextInputType.number, false,
                  UiUtils.getInputDecorationForPrice("", 0.sp, GetController.to.preLoanPrice.value), (text) {
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
        UiUtils.getMarginBox(0, 3.h),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("희망대출 금액", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
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
      UiUtils.getMarginBox(0, 3.h),
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
    confirmDataList.add("•  차량번호 $selectedCarNum");
    /*
    if(selectedPreLoanCountInfo.split("@")[1] != "0"){
      confirmDataList.add("•  기대출  ${selectedPreLoanCountInfo.split("@")[0]}");
      confirmDataList.add("•  기대출 잔액  ${CommonUtils.getPriceFormattedString(double.parse(selectedPreLoanPriceInfo))}");
    }else{
      confirmDataList.add("•  기대출 없음");
    }
     */

    confirmDataList.add("•  ${selectedJobInfo.split("@")[0]}");
    /*
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
    */

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
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("해당 정보로 ", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 0.5.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("대출상품을 찾아볼까요?", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: confirmWidgetList)),
      UiUtils.getMarginBox(0, 5.h),
      Row(children: [
        UiUtils.getBorderButtonBox(42.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
            UiUtils.getTextWithFixedScale("네 좋아요!", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
              Map<String, dynamic> inputJson = {
                "car_no": selectedCarNum.replaceAll(" ", "").trim(),
                "owner_name": MyData.isTestUser? selectedCarOwner : MyData.name,
                "job": selectedJobInfo.split("@")[1],
                "lend_count": "0", // selectedPreLoanCountInfo.split("@")[1]
                "lend_amount": "0", // selectedPreLoanPriceInfo
                /*
                "birthday": MyData.birth,
                "wish_amount": selectedWantLoanPriceInfo,
                 */

              };
              CommonUtils.log("i", "car search info yes :\n$inputJson");

              UiUtils.showLoadingPercentPop(context, "상품 조회를 위해 차량정보를 분석중입니다.");
              LogfinController.callLogfinApi(LogfinApis.addAndSearchCar, inputJson, (isSuccess, outputJson){
                if(isSuccess){
                  LogfinController.getUserInfo((isSuccessToGetUSerInfo){
                    if(isSuccessToGetUSerInfo){
                      LogfinController.getCarInfo((isSuccessToGetCarInfo, isNotEmpty){
                        if(isSuccessToGetCarInfo){
                          if(isNotEmpty){
                            String thisCarNum = selectedCarNum;
                            String updatedCarUid = MyData.findUidInCarInfoList(thisCarNum);
                            for(var each in MyData.getCarInfoList()){
                              if(each.carUid == updatedCarUid){
                                MyData.selectedCarInfoData = each;
                              }
                            }

                            LogfinController.getCarPrList(MyData.selectedCarInfoData!.carNum, selectedJobInfo.split("@")[1],
                                "0", // selectedPreLoanCountInfo.split("@")[1]
                                "0", // selectedPreLoanPriceInfo
                                    (isSuccessToGetOffers, _){
                                  if(isSuccessToGetOffers){
                                    UiUtils.closeLoadingPercentPopForSuccess(context, (isEnd){
                                      if(isEnd){
                                        CommonUtils.moveWithReplacementTo(context, AppView.appResultPrView.value, null);
                                      }
                                    });
                                  }else{
                                    UiUtils.closeLoadingPercentPop(context);
                                    CommonUtils.flutterToast("상품정보 찾기 실패");
                                  }
                                });
                          }else{
                            UiUtils.closeLoadingPercentPop(context);
                            CommonUtils.flutterToast("차량정보 찾기 실패");
                          }
                        }else{
                          UiUtils.closeLoadingPercentPop(context);
                          CommonUtils.flutterToast("차량정보 찾기 실패");
                        }
                      });
                    }else{
                      UiUtils.closeLoadingPercentPop(context);
                      CommonUtils.flutterToast("사용자정보 찾기 실패");
                    }
                  });
                }else{
                  // prSearch 실패
                  UiUtils.closeLoadingPercentPop(context);
                  String errorMsg = outputJson!["error"];
                  if(errorMsg == "no implicit conversion of String into Integer"){
                    CommonUtils.flutterToast("차량정보를 확인해주세요.");
                  }else{
                    if(errorMsg.split(".").length > 2){
                      CommonUtils.flutterToast(errorMsg.replaceAll("+", "").replaceAll("()", "").replaceAll(".", "\n"));
                    }else{
                      CommonUtils.flutterToast(errorMsg.replaceAll("+", "").replaceAll("()", ""));
                    }
                  }
                  setState(() {
                    currentViewId = 1;
                  });
                }
              });
            }),
        UiUtils.getMarginBox(2.w, 0),
        UiUtils.getBorderButtonBox(42.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinWhiteSky,
            UiUtils.getTextWithFixedScale("아니오", 14.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, null), () async {
              Future.delayed(const Duration(milliseconds: 200), () async {
                Navigator.pop(context);
                await Future.delayed(const Duration(seconds: 2), () async {});
                await FireBaseController.setNotificationTorF(true);
              });

          /*
              Map<String, dynamic> inputJson = {
                "car_no": selectedCarNum.replaceAll(" ", "").trim(),
                "owner_name": MyData.isTestUser? selectedCarOwner : MyData.name,
                "job": selectedJobInfo.split("@")[1],
                "lend_count": "0", // selectedPreLoanCountInfo.split("@")[1]
                "lend_amount": "0", // selectedPreLoanPriceInfo
                /*
                "birthday": MyData.birth,
                "wish_amount": selectedWantLoanPriceInfo,
                 */

              };
              CommonUtils.log("i", "car search info no :\n$inputJson");
              UiUtils.showLoadingPercentPop(context);

              await FireBaseController.setNotificationTorF(false);
              LogfinController.callLogfinApi(LogfinApis.addAndSearchCar, inputJson, (isSuccess, outputJson){
                if(isSuccess){
                  LogfinController.getUserInfo((isSuccessToGetUserInfo) async {
                    if(isSuccessToGetUserInfo){
                      LogfinController.getCarInfo((isSuccessToGetCarInfo, isNotEmpty) async {
                        if(isSuccessToGetCarInfo){
                          if(isNotEmpty){
                            UiUtils.closeLoadingPercentPopForSuccess(context, (isEnd) async {
                              if(isEnd){
                                CommonUtils.moveWithUntil(context, AppView.appMainView.value);
                                await Future.delayed(const Duration(seconds: 2), () async {});
                                await FireBaseController.setNotificationTorF(true);
                              }
                            });
                          }else{
                            UiUtils.closeLoadingPercentPop(context);
                            CommonUtils.flutterToast("차량정보 찾기 실패");
                            await FireBaseController.setNotificationTorF(true);
                          }
                        }else{
                          UiUtils.closeLoadingPercentPop(context);
                          CommonUtils.flutterToast("차량정보 찾기 실패");
                          await FireBaseController.setNotificationTorF(true);
                        }
                      });
                    }else{
                      UiUtils.closeLoadingPercentPop(context);
                      CommonUtils.flutterToast("사용자정보 찾기 실패");
                      await FireBaseController.setNotificationTorF(true);
                    }
                  });
                }else{
                  // prSearch 실패
                  UiUtils.closeLoadingPercentPop(context);
                  String errorMsg = outputJson!["error"];
                  if(errorMsg == "no implicit conversion of String into Integer"){
                    CommonUtils.flutterToast("차량정보를 확인해주세요.");
                  }else{
                    if(errorMsg.split(".").length > 2){
                      CommonUtils.flutterToast(errorMsg.replaceAll("+", "").replaceAll("()", "").replaceAll(".", "\n"));
                    }else{
                      CommonUtils.flutterToast(errorMsg.replaceAll("+", "").replaceAll("()", ""));
                    }
                  }
                  setState(() {
                    currentViewId = 1;
                  });
                }
              });
              */

            })
      ])
    ]);
  }
  /// finish confirm view end

  void _back(){
    CommonUtils.hideKeyBoard();
    if(currentViewId == carViewId){
      Navigator.pop(context);
    }else{
      backInputView();
    }

  }

  @override
  Widget build(BuildContext context) {
    Widget? view;
    if(currentViewId == carViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getCarView());
    }else if(currentViewId == preLoanCountViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getPreLoanCountView());
    }else if(currentViewId == preLoanPriceViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getPreLoanPriceView());
    }else if(currentViewId == wantLoanPriceViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getWantLoanPriceView());
    }else if(currentViewId == jobViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getJobView());
    }else{
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getFinishConfirmView());
    }

    return UiUtils.getViewWithAllowBackForAndroid(context, view, _back);
  }

}