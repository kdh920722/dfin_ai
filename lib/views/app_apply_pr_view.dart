import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/configs/app_config.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/datas/pr_docs_info_data.dart';
import 'package:upfin/datas/pr_info_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:upfin/styles/TextStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppApplyPrView extends StatefulWidget{
  @override
  AppApplyPrViewState createState() => AppApplyPrViewState();
}

class AppApplyPrViewState extends State<AppApplyPrView> with WidgetsBindingObserver{
  PrInfoData? selectedPrInfoData;
  int currentViewId = 1;
  int addedInfoIntroViewId = 1;

  /// 개인사업자인 경우
  int addedInfoMainBankViewId = 0;
  int mainBankId = 96;
  String mainBankName = "주거래 은행";
  Key? selectedBankCodeKey;
  String selectedBankCodeInfo = "";

  /// 개인사업자인 경우
  int addedInfoMainBankAccountViewId = 0;
  int mainBankAccountId = 97;
  String mainBankAccountName = "주거래 계좌번호";
  String selectedBankAccountInfo = "";
  final _bankAccountInfoFocus = FocusNode();
  final _bankAccountInfoTextController = TextEditingController();
  void _bankAccountInfoTextControllerListener() {
    if(_bankAccountInfoTextController.text.trim().length > 14){
      _bankAccountInfoTextController.text = _bankAccountInfoTextController.text.trim().substring(0,14);
    }
  }

  /// 개인사업자인 경우
  int addedInfoBusinessNumberViewId = 0;
  int businessNumberId = 98;
  String businessNumberName = "사업자번호";
  String selectedBusinessNumberInfo = "";
  final _businessNumberInfoFocus = FocusNode();
  final _businessNumberInfoTextController = TextEditingController();
  void _businessNumberTextControllerListener() {
    if(_businessNumberInfoTextController.text.trim().length > 14){
      _businessNumberInfoTextController.text = _businessNumberInfoTextController.text.trim().substring(0,14);
    }
  }

  /// 공통
  int cameraForIdCheckViewId = 0;
  int cameraId = 99;
  String cameraName = "신분증 확인";
  bool cameraForIdCheckConfirmed = false;

  final List<Map<String, dynamic>> addedDocsList = [];
  void _initDocsList(){
    int addedIndexId = addedInfoIntroViewId+1;

    if(MyData.jobInfo.split("@")[1] == "1"){
      Map<String, dynamic> mainBankInfo = {
        "id" : 0,
        "name" : "",
        "view_id" : 0,
        "is_confirmed" : false
      };
      mainBankInfo["id"] = mainBankId;
      mainBankInfo["name"] = mainBankAccountName;
      mainBankInfo["view_id"] = addedIndexId;
      mainBankInfo["is_confirmed"] = false;
      addedDocsList.add(mainBankInfo);
      addedIndexId++;

      Map<String, dynamic> mainBankAccountInfo = {
        "id" : 0,
        "name" : "",
        "view_id" : 0,
        "is_confirmed" : false
      };
      mainBankAccountInfo["id"] = mainBankAccountId;
      mainBankAccountInfo["name"] = mainBankAccountName;
      mainBankAccountInfo["view_id"] = addedIndexId;
      mainBankAccountInfo["is_confirmed"] = false;
      addedDocsList.add(mainBankAccountInfo);
      addedIndexId++;

      Map<String, dynamic> businessNumberInfo = {
        "id" : 0,
        "name" : "",
        "view_id" : 0,
        "is_confirmed" : false
      };
      businessNumberInfo["id"] = businessNumberId;
      businessNumberInfo["name"] = businessNumberName;
      businessNumberInfo["view_id"] = addedIndexId;
      businessNumberInfo["is_confirmed"] = false;
      addedDocsList.add(businessNumberInfo);
      addedIndexId++;
    }

    Map<String, dynamic> cameraInfo = {
      "id" : 0,
      "name" : "",
      "view_id" : 0,
      "is_confirmed" : false
    };
    cameraInfo["id"] = cameraId;
    cameraInfo["name"] = cameraName;
    cameraInfo["view_id"] = addedIndexId;
    cameraInfo["is_confirmed"] = false;
    addedDocsList.add(cameraInfo);
    addedIndexId++;

    for(var each in MyData.getPrDocsInfoList()){
      Map<String, dynamic> addedDocsInfo = {
        "id" : 0,
        "name" : "",
        "view_id" : 0,
        "is_confirmed" : false
      };
      addedDocsInfo["id"] = each.productDocsId;
      addedDocsInfo["name"] = each.productDocsName;
      addedDocsInfo["view_id"] = addedIndexId;
      addedDocsInfo["is_confirmed"] = false;
      addedDocsList.add(addedDocsInfo);
      addedIndexId++;
    }

    Map<String, dynamic> lastInfo = {
      "id" : 0,
      "name" : "",
      "view_id" : 0,
      "is_confirmed" : false
    };
    lastInfo["id"] = lastId;
    lastInfo["name"] = lastName;
    lastInfo["view_id"] = addedIndexId;
    lastInfo["is_confirmed"] = false;
    addedDocsList.add(lastInfo);
    addedIndexId++;

    finishedViewId = addedIndexId;
  }
  int _getIdFromListByViewId(int viewId){
    int id = -1;
    for(var each in addedDocsList){
      if(each["view_id"] == viewId){
        id = each["id"];
      }
    }

    return id;
  }

  int lastId = 100;
  String lastName = "서류 준비 완료";

  int finishedViewId = 0;
  bool finishedConfirmed = false;

  @override
  void initState(){
    CommonUtils.log("i", "AppApplyPrView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initDocsList();
    _checkView();
    _bankAccountInfoTextController.addListener(_bankAccountInfoTextControllerListener);
    _businessNumberInfoTextController.addListener(_businessNumberTextControllerListener);
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppApplyPrView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _unFocusAllNodes();
    _disposeAllTextControllers();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('i','AppApplyPrView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('i','AppApplyPrView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('i','AppApplyPrView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('i','AppApplyPrView paused');
        break;
      default:
        break;
    }
  }

  void _unFocusAllNodes(){
    _bankAccountInfoFocus.unfocus();
    _businessNumberInfoFocus.unfocus();
  }

  void _disposeAllTextControllers(){
    _bankAccountInfoTextController.dispose();
    _businessNumberInfoTextController.dispose();
  }

  void _checkView(){
    if(!finishedConfirmed){
      for(int i = 0 ; i < addedDocsList.length ; i++){
        Map<String, dynamic> addedDocsInfo = addedDocsList[i];
        if(!addedDocsInfo["is_confirmed"]){
          if(i == 0){
            currentViewId = 1;
          }else{
            currentViewId = addedDocsInfo["view_id"];
          }
          return;
        }
      }
    }else{
      currentViewId = finishedViewId;
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

  /// added info intro view
  Widget _getIntroView(){
    List<Map<String, dynamic>> introList = addedDocsList;
    List<Widget> introWidgetList = [];
    for(var each in introList){
      Key key = UniqueKey();
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getCustomCircleCheckBox(key, 1.5, true, ColorStyles.upFinRealGray, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){}),
                UiUtils.getTextStyledButtonWithFixedScale(each["name"], 13.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.center, null, (){})
              ])
          )
      );
    }

    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () {
          Navigator.pop(context);
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("${MyData.selectedPrInfoData!.productCompanyName}에", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("접수하기 위해서는", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("추가정보가 필요합니다.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: introWidgetList)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        nextInputView();
      })
    ]);
  }
  /// added info intro view end

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
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("개인사업자인 경우", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("주거래 은행정보가 필요해요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
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
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("주거래 계좌번호를", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
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

  /// business number view
  Widget _getBusinessNumberView(){
    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("사업자 번호를", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("입력해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextField(90.w, TextStyles.upFinTextFormFieldTextStyle, _businessNumberInfoFocus, _businessNumberInfoTextController, TextInputType.number,
          UiUtils.getInputDecoration("", 0.sp, "", 0.sp), (value) { }),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        selectedBusinessNumberInfo = _businessNumberInfoTextController.text.trim();
        CommonUtils.log("i", "selectedBusinessNumberInfo : $selectedBusinessNumberInfo");
        if(selectedBusinessNumberInfo.isNotEmpty){
          nextInputView();
        }
      })
    ]);
  }
  /// business number view end

  /// camera for id check view
  Widget _getCameraForIdCheckView(){
    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("신분증을 준비해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("입력해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),

      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        selectedBusinessNumberInfo = _businessNumberInfoTextController.text.trim();
        CommonUtils.log("i", "selectedBusinessNumberInfo : $selectedBusinessNumberInfo");
        if(selectedBusinessNumberInfo.isNotEmpty){
          nextInputView();
        }
      })
    ]);
  }
  /// camera for id check view end

  /// last view
  Widget _getLastView(){
    List<Map<String, dynamic>> introList = addedDocsList;
    List<Widget> introWidgetList = [];
    for(var each in introList){
      Key key = UniqueKey();
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getCustomCircleCheckBox(key, 1.5, true, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){}),
                UiUtils.getTextStyledButtonWithFixedScale(each["name"], 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})
              ])
          )
      );
    }

    return UiUtils.getRowColumnWithAlignCenter([
      UiUtils.getMarginBox(0, 10.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("상품 가입 신청을 위한", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("모든 준비를 마쳤습니다.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: introWidgetList)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        nextInputView();
      })
    ]);
  }
  /// last view end

  /// finish view
  Widget _getFinishConfirmView(){
    List<Map<String, dynamic>> introList = addedDocsList;
    List<Widget> introWidgetList = [];
    for(var each in introList){
      Key key = UniqueKey();
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getCustomCircleCheckBox(key, 1.5, true, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){}),
                UiUtils.getTextStyledButtonWithFixedScale(each["name"], 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})
              ])
          )
      );
    }

    return UiUtils.getRowColumnWithAlignCenter([
      UiUtils.getMarginBox(0, 10.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("해당 대출상품으로", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("접수를 진행하시겠어요?", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: introWidgetList)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {

      })
    ]);
  }
  /// finish view end

  @override
  Widget build(BuildContext context) {
    Widget? view;
    if(currentViewId == addedInfoIntroViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getIntroView());
    }else {
      if(_getIdFromListByViewId(currentViewId) == mainBankId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getBankCodeView());
      }else if(_getIdFromListByViewId(currentViewId) == mainBankAccountId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getBankAccountView());
      }else if(_getIdFromListByViewId(currentViewId) == businessNumberId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getBusinessNumberView());
      }else if(_getIdFromListByViewId(currentViewId) == cameraId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getCameraForIdCheckView());
      }else if(_getIdFromListByViewId(currentViewId) == lastId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getLastView());
      }else {
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getFinishConfirmView());
      }
    }

    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}