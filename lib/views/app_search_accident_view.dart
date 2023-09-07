import 'package:upfin/controllers/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import '../controllers/sharedpreference_controller.dart';
import '../styles/TextStyles.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

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
    if(_accidentInfoTextController2.text.trim().length > 6){
      _accidentInfoTextController2.text = _accidentInfoTextController2.text.trim().substring(0,6);
    }
  }

  final int bankCodeViewId = 3;
  Key? selectedBankCodeKey;
  String selectedBankCodeInfo = "";

  final int bankAccountViewId = 4;
  String selectedBankAccountInfo = "";
  final _bankAccountInfoFocus = FocusNode();
  final _bankAccountInfoTextController = TextEditingController();

  final int preLoanCountViewId = 5;
  Key? selectedPreLoanCountKey;
  String selectedPreLoanCount = "";

  final int preLoanPriceViewId = 6;
  String selectedPreLoanPrice = "";
  final _preLoanPriceFocus = FocusNode();
  final _preLoanPriceTextController = TextEditingController();

  final int wantLoanPriceViewId = 7;
  String selectedWantLoanPrice = "";
  final _wantLoanPriceFocus = FocusNode();
  final _wantLoanPriceTextController = TextEditingController();

  final int jobViewId = 8;
  Key? selectedJobKey;
  String selectedJob = "";

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
      }else if(selectedPreLoanCount.isEmpty){
        currentViewId = preLoanCountViewId;
      }else if(selectedPreLoanPrice.isEmpty){
        currentViewId = preLoanPriceViewId;
      }else if(selectedWantLoanPrice.isEmpty){
        currentViewId = wantLoanPriceViewId;
      }else if(selectedJob.isEmpty){
        currentViewId = jobViewId;
      }
    }else{
      currentViewId = finishedViewId;
    }
  }

  @override
  void initState(){
    CommonUtils.log("i", "새 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _accidentInfoTextController1.addListener(_accidentInfoTextController1Listener);
    _accidentInfoTextController2.addListener(_accidentInfoTextController2Listener);
    _checkView();
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
                        selectedCourtInfo = each.split("@")[0];
                      }
                    }
                  });
                }),
                UiUtils.getTextStyledButtonWithFixedScale(each.split("@")[0], 15.sp, FontWeight.w600, textColor, TextAlign.center, null, (){
                  setState(() {
                    selectedCourtKey = key;
                    selectedCourtInfo = each.split("@")[0];
                  });
                })
              ])
          )
      );
    }

    return UiUtils.getRowColumnWithAlignCenter([
      UiUtils.getMarginBox(0, 10.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("개인회생 사건정보", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("법원을 선택해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: courtList)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () {
        CommonUtils.log("i", "court : $selectedCourtInfo");
        if(selectedCourtInfo.isNotEmpty){
          setState(() { currentViewId++; });
        }
      })
    ]);
  }
  /// court view end


  /// accident view
  Widget _getAccidentView(){
    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () {
          setState(() { currentViewId--; });
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("사건번호를 입력해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("예) 2023개회123456", 14.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical,
          SizedBox(width: 85.w, child: Row(children: [
            UiUtils.getTextField(20.w, TextStyles.upFinTextFormFieldTextStyle, _accidentInfoFocus1, _accidentInfoTextController1, TextInputType.number, UiUtils.getInputDecoration("", ""), (value) { }),
            UiUtils.getDisabledTextField(18.w, "개회", TextStyles.upFinDisabledTextFormFieldTextStyle, UiUtils.getInputDecoration("", "")),
            UiUtils.getTextField(26.w, TextStyles.upFinTextFormFieldTextStyle, _accidentInfoFocus2, _accidentInfoTextController2, TextInputType.number, UiUtils.getInputDecoration("", ""), (value) { }),
          ]))
      ),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () {
        selectedAccidentInfo = "${_accidentInfoTextController1.text.trim()}개회${_accidentInfoTextController2.text.trim()}";
        CommonUtils.log("i", "selectedAccidentInfo : $selectedAccidentInfo");
        if(selectedAccidentInfo.isNotEmpty){
          setState(() { currentViewId++; });
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
                            selectedBankCodeInfo = each.split("@")[0];
                          }
                        }
                      });
                    }),
                UiUtils.getTextStyledButtonWithFixedScale(each.split("@")[0], 15.sp, FontWeight.w600, textColor, TextAlign.center, null, (){
                  setState(() {
                    selectedBankCodeKey = key;
                    selectedBankCodeInfo = each.split("@")[0];
                  });
                })
              ])
          )
      );
    }

    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () {
          setState(() { currentViewId--; });
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
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () {
        CommonUtils.log("i", "bank code : $selectedBankCodeInfo");
        if(selectedBankCodeInfo.isNotEmpty){
          setState(() { currentViewId++; });
        }
      })
    ]);
  }
  /// bank code view end

  /// bank account view
  Widget _getBankAccountView(){
    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () {
          setState(() { currentViewId--; });
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("환급계좌번호를", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("입력해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextField(90.w, TextStyles.upFinTextFormFieldTextStyle, _bankAccountInfoFocus, _bankAccountInfoTextController, TextInputType.number, UiUtils.getInputDecoration("", ""), (value) { }),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () {
        selectedBankAccountInfo = _bankAccountInfoTextController.text.trim();
        CommonUtils.log("i", "selectedBankAccountInfo : $selectedBankAccountInfo");
        if(selectedBankAccountInfo.isNotEmpty){
          setState(() { currentViewId++; });
        }
      })
    ]);
  }
  /// bank account view end

  @override
  Widget build(BuildContext context) {
    CommonUtils.hideKeyBoard();

    Widget? view;
    if(currentViewId == courtViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getCourtView());
    }else if(currentViewId == accidentViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getAccidentView());
    }else if(currentViewId == bankCodeViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getBankCodeView());
    }else if(currentViewId == bankAccountViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getBankAccountView());
    }else{
      view = Container();
    }

    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}