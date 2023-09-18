import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/configs/app_config.dart';
import 'package:upfin/controllers/hyphen_controller.dart';
import 'package:upfin/controllers/juso_controller.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/datas/pr_info_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:upfin/styles/TextStyles.dart';
import '../controllers/aws_controller.dart';
import '../controllers/clova_controller.dart';
import '../controllers/codef_controller.dart';
import '../datas/api_info_data.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';
import 'dart:io';

class AppApplyPrView extends StatefulWidget{
  @override
  AppApplyPrViewState createState() => AppApplyPrViewState();
}

class AppApplyPrViewState extends State<AppApplyPrView> with WidgetsBindingObserver{
  final String errorMsg = "정보를 입력해주세요";
  bool isInputValid = true;

  int currentViewId = 1;
  int addedInfoIntroViewId = 1;

  /// 개인사업자인 경우
  int addedInfoMainBankViewId = 0;
  int mainBankId = 96;
  String mainBankName = "주거래 은행";
  Key? selectedBankCodeKey;
  String selectedBankCodeInfo = "";

  /// 개인사업자인 경우
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
  int addressId = 95;
  String addressName = "등본상 주소";
  final List<Map<String, String>> addressList = [];
  Key? selectedAddressKey;
  String selectedAddressInfo = "";
  String selectedSearchCertAddressInfo = "";
  final _addressInfoFocus = FocusNode();
  final _addressInfoTextController = TextEditingController();
  void _addressTextControllerListener() {

  }

  int cameraId = 99;
  String cameraName = "신분증 확인";
  bool isDriveCardForImageType = false;
  String pickedFilePath = "";
  String awsUploadUrl = "";

  int niceId = 94;
  String niceName = "나이즈Key 인증";

  int lastId = 999;

  int certType = 1; //1: 카카오 인증, 6:네이버 인증, 5:PASS 인증
  final List<Map<String, dynamic>> addedDocsList = [];
  int gov24Count = 0;
  int nhisCount = 0;
  int ntsCount = 0;
  void _initDocsList(){
    int addedIndexId = addedInfoIntroViewId+1;
    if(MyData.jobInfo.split("@")[1] == "1"){
      Map<String, dynamic> mainBankInfo = {
        "id" : 0,
        "name" : "",
        "view_id" : 0,
        "result" : <String, dynamic>{},
        "is_confirmed" : false,
        "is_docs" : false,
        "docs_type" : ""
      };
      mainBankInfo["id"] = mainBankId;
      mainBankInfo["name"] = mainBankName;
      mainBankInfo["view_id"] = addedIndexId;
      mainBankInfo["is_confirmed"] = false;
      addedDocsList.add(mainBankInfo);
      addedIndexId++;

      Map<String, dynamic> mainBankAccountInfo = {
        "id" : 0,
        "name" : "",
        "view_id" : 0,
        "result" : <String, dynamic>{},
        "is_confirmed" : false,
        "is_docs" : false,
        "docs_type" : ""
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
        "result" : <String, dynamic>{},
        "is_confirmed" : false,
        "is_docs" : false,
        "docs_type" : ""
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
      "result" : <String, dynamic>{},
      "is_confirmed" : false,
      "is_docs" : false,
      "docs_type" : ""
    };
    cameraInfo["id"] = cameraId;
    cameraInfo["name"] = cameraName;
    cameraInfo["view_id"] = addedIndexId;
    cameraInfo["is_confirmed"] = false;
    addedDocsList.add(cameraInfo);
    addedIndexId++;

    Map<String, dynamic> addressInfo = {
      "id" : 0,
      "name" : "",
      "view_id" : 0,
      "result" : <String, dynamic>{},
      "is_confirmed" : false,
      "is_docs" : false,
      "docs_type" : ""
    };
    addressInfo["id"] = addressId;
    addressInfo["name"] = addressName;
    addressInfo["view_id"] = addedIndexId;
    addressInfo["is_confirmed"] = false;
    addedDocsList.add(addressInfo);

    //gov24 : 1:주민등록등본           2:주민등록초본        15:지방세납세증명서
    //nhis  : 3:건강보험자격득실확인서    4:건강보험납부확인서
    //nts   : 6:사업자등록증(*테스트불가) 10:소득금액증명       11:부가세과세표준증명원(*테스트불가)
    for(var each in MyData.getPrDocsInfoList()){
      CommonUtils.log("i", "each docs : ${each.productDocsId}  ${each.productDocsName}");
      if(each.productDocsId == 1 || each.productDocsId == 2 || each.productDocsId == 15
          //|| each.productDocsId == 3 || each.productDocsId == 4
          || each.productDocsId == 10){
        String docsType = "";
        if(each.productDocsId == 1 || each.productDocsId == 2 || each.productDocsId == 15){
          docsType = "gov24";
        }else if(each.productDocsId == 3 || each.productDocsId == 4){
          docsType = "nhis";
        }else{
          docsType = "nts";
        }
        Map<String, dynamic> addedDocsInfo = {
          "id" : 0,
          "name" : "",
          "result" : <String, dynamic>{},
          "view_id" : 0,
          "is_confirmed" : false,
          "is_docs" : true,
          "docs_type" : docsType
        };
        addedDocsInfo["id"] = each.productDocsId;
        addedDocsInfo["name"] = each.productDocsName;
        addedDocsInfo["is_confirmed"] = false;
        addedDocsList.add(addedDocsInfo);
      }
    }
    for(var each in addedDocsList){
      if(each["id"] == 1){
        addedIndexId++;
        each["view_id"] = addedIndexId;
      }else if(each["id"] == 2){
        addedIndexId++;
        each["view_id"] = addedIndexId;
      }else if(each["id"] == 15){
        addedIndexId++;
        each["view_id"] = addedIndexId;
      }
    }
    for(var each in addedDocsList){
      if(each["id"] == 3){
        addedIndexId++;
        each["view_id"] = addedIndexId;
      }else if(each["id"] == 4){
        addedIndexId++;
        each["view_id"] = addedIndexId;
      }
    }
    for(var each in addedDocsList){
      if(each["id"] == 6){
        addedIndexId++;
        each["view_id"] = addedIndexId;
      }else if(each["id"] == 10){
        addedIndexId++;
        each["view_id"] = addedIndexId;
      }else if(each["id"] == 11){
        addedIndexId++;
        each["view_id"] = addedIndexId;
      }
    }

    addedIndexId++;
    Map<String, dynamic> niceInfo = {
      "id" : 0,
      "name" : "",
      "view_id" : 0,
      "result" : <String, dynamic>{},
      "is_confirmed" : false,
      "is_docs" : false,
      "docs_type" : ""
    };
    niceInfo["id"] = niceId;
    niceInfo["name"] = niceName;
    niceInfo["view_id"] = addedIndexId;
    niceInfo["is_confirmed"] = false;
    addedDocsList.add(niceInfo);

    addedIndexId++;
    Map<String, dynamic> lastInfo = {
      "id" : 0,
      "name" : "",
      "view_id" : 0,
      "result" : <String, dynamic>{},
      "is_confirmed" : false,
      "is_docs" : false,
      "docs_type" : ""
    };
    lastInfo["id"] = lastId;
    lastInfo["name"] = "";
    lastInfo["view_id"] = addedIndexId;
    lastInfo["is_confirmed"] = false;
    addedDocsList.add(lastInfo);

    addedDocsList.sort((a,b)=>a["view_id"].compareTo(b["view_id"]));
    for(var each in addedDocsList){
      CommonUtils.log("i", "each added doc :  ${each["view_id"]} ${each["id"]} ${each["name"]}");
    }

    if(_isIdHereFromListById(1)) gov24Count++;
    if(_isIdHereFromListById(2)) gov24Count++;
    if(_isIdHereFromListById(15)) gov24Count++;
    if(_isIdHereFromListById(3)) nhisCount++;
    if(_isIdHereFromListById(4)) nhisCount++;
    if(_isIdHereFromListById(6)) ntsCount++;
    if(_isIdHereFromListById(10)) ntsCount++;
    if(_isIdHereFromListById(11)) ntsCount++;
  }
  bool _isIdHereFromListById(int id){
    bool isHere = false;
    for(var each in addedDocsList){
      if(each["id"] == id){
        isHere = true;
      }
    }

    return isHere;
  }
  void _setResultToListById(int id, Map<String, dynamic>? resultMap){
    for(var eachMap in addedDocsList){
      if(eachMap["id"] == id){
        eachMap["result"] = resultMap;
      }
    }
  }
  Map<String, dynamic> _getResultFromListById(int id){
    Map<String, dynamic> resultMap = {};
    for(var each in addedDocsList){
      if(each["id"] == id){
        resultMap = each["result"];
      }
    }

    return resultMap;
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
  void _setConfirmedToDocItemByViewId(int viewId, bool value){
    for(var each in addedDocsList){
      if(each["view_id"] == viewId){
        each["is_confirmed"] = value;
      }
    }
  }
  bool _isDocItemConfirmedByViewId(int viewId){
    bool result = false;
    for(var each in addedDocsList){
      if(each["view_id"] == viewId){
        result = each["is_confirmed"];
      }
    }

    return result;
  }

  @override
  void initState(){
    CommonUtils.log("i", "AppApplyPrView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initDocsList();
    _addressInfoTextController.addListener(_addressTextControllerListener);
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
    _addressInfoFocus.unfocus();
    _bankAccountInfoFocus.unfocus();
    _businessNumberInfoFocus.unfocus();
  }

  void _disposeAllTextControllers(){
    _addressInfoTextController.dispose();
    _bankAccountInfoTextController.dispose();
    _businessNumberInfoTextController.dispose();
  }

  Future<void> backInputView() async {
    if(isInputValid){
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
      _unFocusAllNodes();
      CommonUtils.hideKeyBoard();
      await Future.delayed(const Duration(milliseconds: 120), () async {});
      setState(() {
        currentViewId++;
        isInputValid = true;
      });
    }
  }

  /// added info intro view
  Widget _getIntroView(){
    List<Map<String, dynamic>> introList = addedDocsList;
    List<Widget> introWidgetList = [];
    for(int i = 0 ; i < introList.length-1 ; i++){
      Key key = UniqueKey();
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getCustomCircleCheckBox(key, 0.1, true, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){}),
                UiUtils.getTextStyledButtonWithFixedScale(introList[i]["name"], 13.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.center, null, (){})
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
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("${MyData.selectedPrInfoData!.productCompanyName}에", 20.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("접수하기 위해서는", 20.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("추가정보가 필요합니다.", 20.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
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
                selectedBankCodeKey == key?
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
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("개인사업자인 경우", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("주거래 은행정보가", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("필요해요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: bankCodeList)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        CommonUtils.log("i", "bank code : $selectedBankCodeInfo");
        if(selectedBankCodeInfo.isNotEmpty){
          _setConfirmedToDocItemByViewId(currentViewId, true);
          Map<String, dynamic> resultMap = {
            "resultValue" : selectedBankCodeInfo
          };
          _setResultToListById(mainBankId, resultMap);
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
      UiUtils.getTextField(90.w, TextStyles.upFinTextFormFieldTextStyle, _bankAccountInfoFocus,
          _bankAccountInfoTextController, TextInputType.number, UiUtils.getInputDecoration("", 0.sp, "", 0.sp), (value) { }),
      UiUtils.getExpandedScrollView(Axis.vertical, Container()),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        selectedBankAccountInfo = _bankAccountInfoTextController.text.trim();
        CommonUtils.log("i", "selectedBankAccountInfo : $selectedBankAccountInfo");
        if(selectedBankAccountInfo.isNotEmpty){
          _setConfirmedToDocItemByViewId(currentViewId, true);
          Map<String, dynamic> resultMap = {
            "resultValue" : selectedBankAccountInfo
          };
          _setResultToListById(mainBankAccountId, resultMap);
          nextInputView();
        }else{
          CommonUtils.flutterToast(errorMsg);
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
      UiUtils.getTextField(90.w, TextStyles.upFinTextFormFieldTextStyle, _businessNumberInfoFocus,
          _businessNumberInfoTextController, TextInputType.number, UiUtils.getInputDecoration("", 0.sp, "", 0.sp), (value) { }),
      UiUtils.getExpandedScrollView(Axis.vertical, Container()),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        selectedBusinessNumberInfo = _businessNumberInfoTextController.text.trim();
        CommonUtils.log("i", "selectedBusinessNumberInfo : $selectedBusinessNumberInfo");
        if(selectedBusinessNumberInfo.isNotEmpty){
          _setConfirmedToDocItemByViewId(currentViewId, true);
          Map<String, dynamic> resultMap = {
            "resultValue" : selectedBusinessNumberInfo
          };
          _setResultToListById(businessNumberId, resultMap);
          nextInputView();
        }else{
          CommonUtils.flutterToast(errorMsg);
        }
      })
    ]);
  }
  /// business number view end

  /// address view
  Widget _getAddressView(){
    List<Widget> addressWidgetList = [];
    Color textColor = ColorStyles.upFinBlack;
    Color textSubColor = ColorStyles.upFinRealGray;
    for(var each in addressList){
      Key key = Key(each["roadAddr"]!+each["jibunAddr"]!);
      if(selectedAddressKey == key) {
        textColor = ColorStyles.upFinTextAndBorderBlue;
        textSubColor = ColorStyles.upFinTextAndBorderBlue;
      }
      else{
        textColor = ColorStyles.upFinBlack;
        textSubColor = ColorStyles.upFinRealGray;
      }
      addressWidgetList.add(
          SizedBox(width: 85.w,
              child: Row(mainAxisSize : MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 5.w, child:
                selectedAddressKey == key? UiUtils.getCustomCircleCheckBox(key, 1.2, selectedAddressKey == key, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                      setState(() {
                        if(checkedValue != null){
                          if(checkedValue) {
                            selectedAddressKey = key;
                            selectedAddressInfo = each["roadAddrPart1"]!;
                            _addressInfoTextController.text = selectedAddressInfo;
                            if(selectedSearchCertAddressInfo != "" && selectedSearchCertAddressInfo != selectedAddressInfo){
                              CommonUtils.flutterToast("주소정보를 바꾸시면\n서류인증을 다시 받아야합니다.");
                            }
                          }
                        }
                      });
                    }) : UiUtils.getCustomCircleCheckBox(key, 1.2, true, ColorStyles.upFinGray, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){
                      setState(() {
                        if(checkedValue != null){
                          if(!checkedValue) {
                            selectedAddressKey = key;
                            selectedAddressInfo = each["roadAddrPart1"]!;
                            _addressInfoTextController.text = selectedAddressInfo;
                            if(selectedSearchCertAddressInfo != "" && selectedSearchCertAddressInfo != selectedAddressInfo){
                              CommonUtils.flutterToast("주소정보를 바꾸시면\n서류인증을 다시 받아야합니다.");
                            }
                          }
                        }
                      });
                    })
                ),
                UiUtils.getMarginBox(3.w, 0),
                SizedBox(width: 77.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  UiUtils.getTextStyledButtonWithFixedScale(each["roadAddr"]!, 14.sp, FontWeight.w500, textColor, TextAlign.start, null, (){
                    setState(() {
                      selectedAddressKey = key;
                      selectedAddressInfo = each["roadAddrPart1"]!;
                      _addressInfoTextController.text = selectedAddressInfo;
                      if(selectedSearchCertAddressInfo != "" && selectedSearchCertAddressInfo != selectedAddressInfo){
                        CommonUtils.flutterToast("주소정보를 바꾸시면\n서류인증을 다시 받아야합니다.");
                      }
                    });
                  }),
                  UiUtils.getTextWithFixedScale(each["jibunAddr"]!, 12.sp, FontWeight.w500, textSubColor, TextAlign.start, null)
                ])),
              ])
          )
      );
      addressWidgetList.add(UiUtils.getMarginBox(0, 3.h));
    }

    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("등본상 주소를", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("입력해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextField(85.w, TextStyles.upFinSmallTextFormFieldTextStyle, _addressInfoFocus,
          _addressInfoTextController, TextInputType.text, UiUtils.getInputDecoration("", 0.sp, "", 0.sp), (value) { }),
      UiUtils.getMarginBox(0, 1.h),
      UiUtils.getBorderButtonBox(85.w, ColorStyles.upFinWhite, ColorStyles.upFinTextAndBorderBlue,
          UiUtils.getTextWithFixedScale("주소 찾기", 12.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null), () {
              if(_addressInfoTextController.text.trim() != ""){
                CommonUtils.hideKeyBoard();
                selectedAddressKey = null;
                selectedAddressInfo = "";
                addressList.clear();
                UiUtils.showLoadingPop(context);
                JusoController.getAddressFromJuso(_addressInfoTextController.text,(bool isSuccess, outputList){
                  UiUtils.closeLoadingPop(context);
                  if(isSuccess){
                    if(outputList!.isNotEmpty){
                      for(var eachAddress in outputList){
                        addressList.add(<String, String>
                        {"jibunAddr" : eachAddress["jibunAddr"],
                          "roadAddr" : eachAddress["roadAddr"],
                          "roadAddrPart1" : eachAddress["roadAddrPart1"]});
                      }
                      setState(() {});
                    }else{
                      CommonUtils.flutterToast("검색 결과가 없습니다.");
                    }
                  }
                });
              }else{
                CommonUtils.flutterToast("주소를 입력해주세요.");
              }
          }),
      UiUtils.getMarginBox(0, 2.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: addressWidgetList)),
      UiUtils.getMarginBox(0, 3.h),
      selectedAddressKey != null ?
      UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        _setConfirmedToDocItemByViewId(currentViewId, true);
        if(selectedSearchCertAddressInfo != "" && selectedSearchCertAddressInfo != selectedAddressInfo){
          for(var each in addedDocsList){
            if(each["is_docs"]){
              each["is_confirmed"] = false;
              Map<String, dynamic> resultMap = each["result"];
              resultMap.clear();
              each["result"] = resultMap;
              each["result"] = <String, dynamic>{};
            }
          }
        }
        Map<String, dynamic> resultMap = {
          "resultValue" : selectedAddressInfo
        };
        _setResultToListById(addressId, resultMap);
        nextInputView();
      }) : Container()
    ]);
  }
  /// address view end

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
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("주민등록증과 운전면허증 중", 12.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("하나를 선택 해 주세요.", 12.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 10.h),
      SizedBox(width: 85.w, height: 30.h,
          child: ConstrainedBox(constraints: BoxConstraints(maxWidth: 85.w, maxHeight: 30.h),
            child: pickedFilePath != "" ? Container(decoration: BoxDecoration(color: ColorStyles.upFinBlack, borderRadius: BorderRadius.circular(10)), child: UiUtils.getImage(85.w, 30.h, Image.file(File(pickedFilePath))))
                : Container(decoration: BoxDecoration(color: ColorStyles.upFinBlack, borderRadius: BorderRadius.circular(10)), child: UiUtils.getIcon(85.w, 30.h, Icons.photo_camera_front_outlined, 50.w, ColorStyles.upFinWhite)))
      ),
      UiUtils.getMarginBox(0, 0.5.h),
      SizedBox(width: 85.w, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        UiUtils.getBorderButtonBox(42.w, ColorStyles.upFinWhite, ColorStyles.upFinTextAndBorderBlue,
            UiUtils.getTextWithFixedScale("촬영하기", 11.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null),
                () {
                  _takeImage(true);
                }),
        UiUtils.getMarginBox(1.w, 0),
        UiUtils.getBorderButtonBox(42.w, ColorStyles.upFinWhite, ColorStyles.upFinTextAndBorderBlue,
            UiUtils.getTextWithFixedScale("앨범에서 가져오기", 11.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null),
                () {
              _takeImage(false);
            }),
      ])),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Container()),
      pickedFilePath != "" ? UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        if(_isDocItemConfirmedByViewId(currentViewId)){
          nextInputView();
        }
      }) : Container()
    ]);
  }
  Future<void> _takeImage(bool isGetImageFromCamera) async {
    try{
      UiUtils.showLoadingPop(context);
      XFile? image = isGetImageFromCamera? await CommonUtils.getCameraImage() : await CommonUtils.getGalleryImage();

      if(image != null){
        String imagePath = await CommonUtils.cropImageAndGetPath(image);
        if(imagePath != ""){
          _checkValidCertImage(imagePath);
        }else{
          if(context.mounted) UiUtils.closeLoadingPop(context);
        }
      }else{
        if(context.mounted) UiUtils.closeLoadingPop(context);
      }
    }catch(error){
      UiUtils.closeLoadingPop(context);
      CommonUtils.log("i", "tage image error : $error");
      CommonUtils.flutterToast("사진을 가져오는 중\n에러가 발생했습니다.");
    }
  }
  Future<void> _checkValidCertImage(String imagePath) async {
    try{
      CommonUtils.flutterToast("신분증을 인식중입니다..");
      await CLOVAController.uploadImageToCLOVA(imagePath, (isSuccess, map) async {
        if(map != null){
          if(isSuccess){
            CommonUtils.flutterToast("인식된 신분증을\n마스킹 중입니다..");
            String croppedImagePath = await CommonUtils.makeMaskingImageAndGetPath(imagePath, map);
            if(croppedImagePath != ""){
              MyData.idNumber = map['personalNum'][0]["formatted"]["value"];
              CommonUtils.log("i", "id : ${MyData.idNumber}");

              //test
              if(context.mounted) UiUtils.closeLoadingPop(context);
              _setConfirmedToDocItemByViewId(currentViewId, true);
              Map<String, dynamic> resultMap = {
                "resultValue" : croppedImagePath
              };
              _setResultToListById(cameraId, resultMap);
              setState(() {
                pickedFilePath = croppedImagePath;
              });
              //test end

              /*
              CommonUtils.flutterToast("신분증 진위확인 중입니다..");
              if(map['id_type'] == "dl"){
                CommonUtils.log("i", "dl : infos\n${map["code"][0]["formatted"]["value"]}${map["num"][0]["formatted"]["value"]}");
                String licenseNum = map["num"][0]["formatted"]["value"];
                Map<String, dynamic> inputJson = {
                  "ownerNm": MyData.name,
                  "juminNo": MyData.birth,
                  "licence01": licenseNum.split("-")[0],
                  "licence02": licenseNum.split("-")[1],
                  "licence03": licenseNum.split("-")[2],
                  "licence04": licenseNum.split("-")[3],
                  "serialNo": map["code"][0]["formatted"]["value"]
                };
                _setConfirmedToDocItemByViewId(currentViewId, true);
                Map<String, dynamic> resultMap = {
                  "resultValue" : croppedImagePath
                };
                _setResultToListById(cameraId, resultMap);
                setState(() {
                  pickedFilePath = croppedImagePath;
                });

                HyphenController.callHyphenApiForCert(HyphenApis.driveIdCert, inputJson, (isSuccessToCertId){
                  UiUtils.closeLoadingPop(context);
                  if(isSuccessToCertId){
                    _setConfirmedToDocItemByViewId(currentViewId, true);
                    Map<String, dynamic> resultMap = {
                      "resultValue" : croppedImagePath
                    };
                    _setResultToListById(cameraId, resultMap);
                    setState(() {
                      pickedFilePath = croppedImagePath;
                    });
                  }else{
                    _setConfirmedToDocItemByViewId(currentViewId, false);
                    setState(() {
                      pickedFilePath = "";
                    });
                  }
                });
              }else{
                CommonUtils.log("i", "ic : infos\n${map["issueDate"][0]["formatted"]["year"]}${map["issueDate"][0]["formatted"]["month"]}${map["issueDate"][0]["formatted"]["day"]}");
                Map<String, dynamic> inputJson = {
                  "ownerNm": MyData.name,
                  "juminNo": MyData.idNumber.replaceAll("-", ""),
                  "issueDt": "${map["issueDate"][0]["formatted"]["year"]}${map["issueDate"][0]["formatted"]["month"]}${map["issueDate"][0]["formatted"]["day"]}"
                };
                _setConfirmedToDocItemByViewId(currentViewId, true);
                Map<String, dynamic> resultMap = {
                  "resultValue" : croppedImagePath
                };
                _setResultToListById(cameraId, resultMap);
                setState(() {
                  pickedFilePath = croppedImagePath;
                });

                HyphenController.callHyphenApiForCert(HyphenApis.idCert, inputJson, (isSuccessToCertId){
                  UiUtils.closeLoadingPop(context);
                  if(isSuccessToCertId){
                    _setConfirmedToDocItemByViewId(currentViewId, true);
                    Map<String, dynamic> resultMap = {
                      "resultValue" : croppedImagePath
                    };
                    _setResultToListById(cameraId, resultMap);
                    setState(() {
                      pickedFilePath = croppedImagePath;
                    });
                  }else{
                    _setConfirmedToDocItemByViewId(currentViewId, false);
                    setState(() {
                      pickedFilePath = "";
                    });
                  }
                });
              }
              */

            }else{
              // failed to masking
              if(context.mounted) UiUtils.closeLoadingPop(context);
              _setConfirmedToDocItemByViewId(currentViewId, false);
              setState(() {
                pickedFilePath = "";
              });
              CommonUtils.flutterToast("마스킹 중\n에러가 발생했습니다.");
            }
          }else{
            // failed to check clova ocr
            UiUtils.closeLoadingPop(context);
            _setConfirmedToDocItemByViewId(currentViewId, false);
            setState(() {
              pickedFilePath = "";
            });
            CommonUtils.flutterToast("신분증 확인 중\n에러가 발생했습니다.");
          }
        }else{
          UiUtils.closeLoadingPop(context);
          _setConfirmedToDocItemByViewId(currentViewId, false);
          setState(() {
            pickedFilePath = "";
          });
          CommonUtils.flutterToast("신분증을 확인할 수 없습니다.");
        }
      });
    }catch(error){
      UiUtils.closeLoadingPop(context);
      _setConfirmedToDocItemByViewId(currentViewId, false);
      setState(() {
        pickedFilePath = "";
      });
      CommonUtils.log("i", "tage image error : $error");
      CommonUtils.flutterToast("사진을 가져오는 중\n에러가 발생했습니다.");
    }
  }
  Future<void> _uploadCertImageToAwsServer(String croppedImagePath, Function(bool isSuccess) callback) async {
    try{
      await AwsController.uploadImageToAWS(croppedImagePath, (isSuccessToSave, resultUrl) async {
        if(isSuccessToSave){
          awsUploadUrl = "${AwsController.uploadedUrl}/${AwsController.maskedImageDir}/${resultUrl.split(AwsController.maskedImageDir)[1]}";
          callback(true);
        }else{
          // failed to aws s3 save
          callback(false);
        }
      });
    }catch(error){
      CommonUtils.log("i", "tage image error : $error");
      callback(false);
    }
  }
  /// camera for id check view end

  /// gov24(id:1,2,15) view
  Widget _getGov24View(){
    String subTitle = "'정부24'";
    String title1 = "간편인증을 통해";
    String title2 = "비대면 서류 제출이";
    String title3 = "가능합니다.";
    bool isErrorResult = false;

    for(var each in addedDocsList){
      if(each["view_id"] < currentViewId){
        if(each["is_docs"]){
          title1 = "아직 받지 못한 서류들은";
          title2 = "정부기관이 달라서";
          title3 = "다시 한번 인증을 해야해요";
        }
      }
    }
    List<Widget> docsWidgetList = [];
    for(var each in addedDocsList){
      if(each["docs_type"] == "gov24"){
        Key key = UniqueKey();
        String name = "";
        Color textColor = ColorStyles.upFinRealGray;
        Color errorTextColor = ColorStyles.upFinRed;
        Color successTextColor = ColorStyles.upFinTextAndBorderBlue;
        if(each["id"] == 1){
          name = "주민등록등본";
          Map<String, dynamic> resultMap = each["result"];
          if(resultMap.containsKey("resultValue")){
            CommonUtils.log("i", "result ==> ${each["result"]["resultValue"]}");
            var dataMap = each["result"]["resultValue"]["data"];
            if(dataMap.isEmpty){
              textColor = errorTextColor;
              name += " 실패";
              isErrorResult = true;
            }else{
              textColor = successTextColor;
            }
          }
        }
        if(each["id"] == 2){
          name = "주민등록초본";
          Map<String, dynamic> resultMap = each["result"];
          if(resultMap.containsKey("resultValue")){
            CommonUtils.log("i", "result ==> ${each["result"]["resultValue"]}");
            var dataMap = each["result"]["resultValue"]["data"];
            if(dataMap.isEmpty){
              textColor = errorTextColor;
              name += " 실패";
              isErrorResult = true;
            }else{
              textColor = successTextColor;
            }
          }
        }
        if(each["id"] == 15){
          name = "지방세납세증명서";
          Map<String, dynamic> resultMap = each["result"];
          if(resultMap.containsKey("resultValue")){
            CommonUtils.log("i", "result ==> ${each["result"]["resultValue"]}");
            var dataMap = each["result"]["resultValue"]["data"];
            if(dataMap.isEmpty){
              textColor = errorTextColor;
              name += " 실패";
              isErrorResult = true;
            }else{
              textColor = successTextColor;
            }
          }
        }

        docsWidgetList.add(
            SizedBox(width: 90.w,
                child: Row(children: [
                  UiUtils.getCustomCircleCheckBox(key, 1.5, true, textColor, ColorStyles.upFinWhite, ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){}),
                  UiUtils.getTextStyledButtonWithFixedScale(name, 15.sp, FontWeight.w600,textColor, TextAlign.center, null, (){})
                ])
            )
        );
      }
    }
    if(!_isDocItemConfirmedByViewId(currentViewId)){
      docsWidgetList.add(SizedBox(width: 90.w, child: Column(children: [
        UiUtils.getMarginBox(0, 2.h),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("민간 인증서를 선택하세요", 14.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 1.5.h),
        SizedBox(width: 85.w, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(children: [
            Container(padding: EdgeInsets.zero, decoration: BoxDecoration(color: certType == 1? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhite, borderRadius: BorderRadius.circular(20)),
                child: UiUtils.getImageButton(Image.asset('assets/images/kakao_icon.png'), 20.w, ColorStyles.upFinBlack, () async {
                  setState(() { certType = 1; });
                })),
            UiUtils.getMarginBox(0, 1.h),
            UiUtils.getTextWithFixedScale("카카오톡", 14.sp, FontWeight.w500, certType == 1? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinDarkGray, TextAlign.start, null)
          ]),
          UiUtils.getMarginBox(5.w, 0),
          Column(children: [
            Container(padding: EdgeInsets.zero, decoration: BoxDecoration(color: certType == 6? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhite, borderRadius: BorderRadius.circular(20)),
                child: UiUtils.getImageButton(Image.asset('assets/images/apple_icon.png'), 20.w, ColorStyles.upFinBlack, () async {
                  setState(() { certType = 6; });
                })),
            UiUtils.getMarginBox(0, 1.h),
            UiUtils.getTextWithFixedScale("네이버", 14.sp, FontWeight.w500, certType == 6? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinDarkGray, TextAlign.start, null)
          ]),
          UiUtils.getMarginBox(5.w, 0),
          Column(children: [
            Container(padding: EdgeInsets.zero, decoration: BoxDecoration(color: certType == 5? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhite, borderRadius: BorderRadius.circular(20)),
                child: UiUtils.getImageButton(Image.asset('assets/images/iamport_logo.png'), 20.w, ColorStyles.upFinBlack, () async {
                  setState(() { certType = 5; });
                })),
            UiUtils.getMarginBox(0, 1.h),
            UiUtils.getTextWithFixedScale("PASS", 14.sp, FontWeight.w500, certType == 5? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinDarkGray, TextAlign.start, null)
          ]),
        ])),
        UiUtils.getMarginBox(0, 2.h),
        UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinTextAndBorderBlue,
            UiUtils.getTextWithFixedScale(_isDocItemConfirmedByViewId(currentViewId)? "인증완료" : !isErrorResult? "간편인증 진행하기" : "서류 다시 가져오기", 11.sp, FontWeight.w500, !isErrorResult? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinRed, TextAlign.start, null), () {
              if(!_isDocItemConfirmedByViewId(currentViewId)){
                String loginCertType = certType.toString();
                String name = MyData.name;
                String birth = MyData.birth;
                String phoneNo = MyData.phoneNumber;
                String identity = MyData.idNumber.split("-")[0]+MyData.idNumber.split("-")[1];
                String address = selectedAddressInfo;
                String telecom = (int.parse(MyData.telecom)-1).toString();
                if(int.parse(telecom) >= 3){
                  telecom = (int.parse(telecom)-3).toString();
                }

                CommonUtils.log("i", "$identity\n$telecom\n$phoneNo\n$birth\n$address");
                String randomKey = gov24Count==1 ? "" : CommonUtils.getRandomKey().toString();
                List<ApiInfoData> apiInfoDataList = [];
                for(var each in addedDocsList){
                  if(each["docs_type"] == "gov24"){
                    if(each["id"] == 1){
                      CommonUtils.log("i", "here1");
                      // 등본
                      Map<String, dynamic> inputJson = CodeFController.makeInputJsonForCertApis(Apis.gov24residentRegistrationCopy,
                          identity, birth, name, phoneNo, telecom, address, loginCertType, randomKey);
                      apiInfoDataList.add(ApiInfoData(each["id"], inputJson, Apis.gov24residentRegistrationCopy, true));
                    }else if(each["id"] == 2){
                      CommonUtils.log("i", "here2");
                      // 초본
                      Map<String, dynamic> inputJson = CodeFController.makeInputJsonForCertApis(Apis.gov24residentRegistrationAbstract,
                          identity, birth, name, phoneNo, telecom, address, loginCertType, randomKey);
                      apiInfoDataList.add(ApiInfoData(each["id"], inputJson, Apis.gov24residentRegistrationAbstract, true));
                    }else if(each["id"] == 15){
                      CommonUtils.log("i", "here3");
                      // 지방세
                      Map<String, dynamic> inputJson = CodeFController.makeInputJsonForCertApis(Apis.gov24localTaxPaymentCert,
                          identity, birth, name, phoneNo, telecom, address, loginCertType, randomKey);
                      apiInfoDataList.add(ApiInfoData(each["id"], inputJson, Apis.gov24localTaxPaymentCert, true));
                    }
                  }
                }
                UiUtils.showLoadingPop(context);
                CodeFController.callApisWithCert(context, setState, certType, apiInfoDataList, (isSuccess, resultApiInfoDataList) {
                  UiUtils.closeLoadingPop(context);
                  if(isSuccess){
                    bool isResultSuccess = true;
                    for(var each in resultApiInfoDataList!){
                      Map<String, dynamic> resultMap = {
                        "resultValue" : each.resultFullMap
                      };
                      _setResultToListById(each.apiId, resultMap);
                      CommonUtils.log("i", "${each.apiId}\n${each.resultFullMap}");
                      if(each.resultMap == null && each.resultListMap == null){
                        isResultSuccess = false;
                      }
                    }

                    if(isResultSuccess){
                      CommonUtils.flutterToast("$subTitle에서\n서류를 가져왔습니다");
                      selectedSearchCertAddressInfo = address;
                      setState(() {
                        for(int i = 0 ; i < gov24Count ; i++){
                          _setConfirmedToDocItemByViewId(currentViewId+i, true);
                        }
                      });
                    }else{
                      CommonUtils.flutterToast("입력하셨던 정보를\n다시 확인해주세요");
                      setState(() {
                        for(int i = 0 ; i < gov24Count ; i++){
                          _setConfirmedToDocItemByViewId(currentViewId+i, false);
                        }
                      });
                    }
                  }else{
                    CommonUtils.log("i", "call fail");
                    setState(() {
                      for(int i = 0 ; i < gov24Count ; i++){
                        _setConfirmedToDocItemByViewId(currentViewId+i, false);
                      }
                    });
                  }
                });
              }else{
                CommonUtils.flutterToast("이미 인증을\n완료하셨습니다.");
              }
            })
      ])));
    }

    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale(title1, 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale(title2, 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale(title3, 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("$subTitle에서 해당 서류들을 가져옵니다.", 12.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: docsWidgetList)),
      UiUtils.getMarginBox(0, 5.h),
      _isDocItemConfirmedByViewId(currentViewId)? UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        if(gov24Count == 1){
          nextInputView();
        }else{
          currentViewId = currentViewId+gov24Count-1;
          nextInputView();
        }
      }) : Container()
    ]);
  }
  /// gov24(id:1,2,15) view end

  /// nhis(id:3,4) view
  Widget _getNhisView(){
    String subTitle = "'건강보험공단'";
    String title1 = "간편인증을 통해";
    String title2 = "비대면 서류 제출이";
    String title3 = "가능합니다.";
    bool isErrorResult = false;

    for(var each in addedDocsList){
      if(each["view_id"] < currentViewId){
        if(each["is_docs"]){
          title1 = "아직 받지 못한 서류들은";
          title2 = "정부기관이 달라서";
          title3 = "다시 한번 인증을 해야해요";
        }
      }
    }
    List<Widget> docsWidgetList = [];
    for(var each in addedDocsList){
      if(each["docs_type"] == "nhis"){
        Key key = UniqueKey();
        String name = "";
        Color textColor = ColorStyles.upFinRealGray;
        Color errorTextColor = ColorStyles.upFinRed;
        Color successTextColor = ColorStyles.upFinTextAndBorderBlue;
        if(each["id"] == 3){
          name = "건강보험자격득실확인서";
          Map<String, dynamic> resultMap = each["result"];
          if(resultMap.containsKey("resultValue")){
            CommonUtils.log("i", "result ==> ${each["result"]["resultValue"]}");
            var dataMap = each["result"]["resultValue"]["data"];
            if(dataMap.isEmpty){
              textColor = errorTextColor;
              name += " 실패";
              isErrorResult = true;
            }else{
              textColor = successTextColor;
            }
          }
        }
        if(each["id"] == 4){
          name = "건강보험납부확인서";
          Map<String, dynamic> resultMap = each["result"];
          if(resultMap.containsKey("resultValue")){
            CommonUtils.log("i", "result ==> ${each["result"]["resultValue"]}");
            var dataMap = each["result"]["resultValue"]["data"];
            if(dataMap.isEmpty){
              textColor = errorTextColor;
              name += " 실패";
              isErrorResult = true;
            }else{
              textColor = successTextColor;
            }
          }
        }

        docsWidgetList.add(
            SizedBox(width: 90.w,
                child: Row(children: [
                  UiUtils.getCustomCircleCheckBox(key, 1.5, true, textColor, ColorStyles.upFinWhite, ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){}),
                  UiUtils.getTextStyledButtonWithFixedScale(name, 15.sp, FontWeight.w600, textColor, TextAlign.center, null, (){})
                ])
            )
        );
      }
    }

    if(!_isDocItemConfirmedByViewId(currentViewId)){
      docsWidgetList.add(SizedBox(width: 90.w, child: Column(children: [
        UiUtils.getMarginBox(0, 2.h),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("민간 인증서를 선택하세요", 14.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 1.5.h),
        SizedBox(width: 85.w, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(children: [
            Container(padding: EdgeInsets.zero, decoration: BoxDecoration(color: certType == 1? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhite, borderRadius: BorderRadius.circular(20)),
                child: UiUtils.getImageButton(Image.asset('assets/images/kakao_icon.png'), 20.w, ColorStyles.upFinBlack, () async {
                  setState(() { certType = 1; });
                })),
            UiUtils.getMarginBox(0, 1.h),
            UiUtils.getTextWithFixedScale("카카오톡", 14.sp, FontWeight.w500, certType == 1? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinDarkGray, TextAlign.start, null)
          ]),
          UiUtils.getMarginBox(5.w, 0),
          Column(children: [
            Container(padding: EdgeInsets.zero, decoration: BoxDecoration(color: certType == 6? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhite, borderRadius: BorderRadius.circular(20)),
                child: UiUtils.getImageButton(Image.asset('assets/images/apple_icon.png'), 20.w, ColorStyles.upFinBlack, () async {
                  setState(() { certType = 6; });
                })),
            UiUtils.getMarginBox(0, 1.h),
            UiUtils.getTextWithFixedScale("네이버", 14.sp, FontWeight.w500, certType == 6? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinDarkGray, TextAlign.start, null)
          ]),
          UiUtils.getMarginBox(5.w, 0),
          Column(children: [
            Container(padding: EdgeInsets.zero, decoration: BoxDecoration(color: certType == 5? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhite, borderRadius: BorderRadius.circular(20)),
                child: UiUtils.getImageButton(Image.asset('assets/images/iamport_logo.png'), 20.w, ColorStyles.upFinBlack, () async {
                  setState(() { certType = 5; });
                })),
            UiUtils.getMarginBox(0, 1.h),
            UiUtils.getTextWithFixedScale("PASS", 14.sp, FontWeight.w500, certType == 5? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinDarkGray, TextAlign.start, null)
          ]),
        ])),
        UiUtils.getMarginBox(0, 2.h),
        UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinTextAndBorderBlue,
            UiUtils.getTextWithFixedScale(_isDocItemConfirmedByViewId(currentViewId)? "인증완료" : !isErrorResult? "간편인증 진행하기" : "서류 다시 가져오기", 11.sp, FontWeight.w500, !isErrorResult? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinRed, TextAlign.start, null), () {
              if(!_isDocItemConfirmedByViewId(currentViewId)){
                String loginCertType = certType.toString();
                String name = MyData.name;
                String birth = MyData.birth;
                String phoneNo = MyData.phoneNumber;
                String identity = MyData.idNumber.split("-")[0]+MyData.idNumber.split("-")[1];
                String address = selectedAddressInfo;
                String telecom = (int.parse(MyData.telecom)-1).toString();
                if(int.parse(telecom) >= 3){
                  telecom = (int.parse(telecom)-3).toString();
                }
                String randomKey = nhisCount==1 ? "" : CommonUtils.getRandomKey().toString();
                List<ApiInfoData> apiInfoDataList = [];
                for(var each in addedDocsList){
                  if(each["docs_type"] == "nhis"){
                    if(each["id"] == 3){
                      // 자격득실확인서
                      Map<String, dynamic> inputJson = CodeFController.makeInputJsonForCertApis(Apis.nhisIdentifyConfirmation,
                          identity, birth, name, phoneNo, telecom, address, loginCertType, randomKey);
                      apiInfoDataList.add(ApiInfoData(each["id"], inputJson, Apis.nhisIdentifyConfirmation, true));
                    }else if(each["id"] == 4){
                      // 납부확인서
                      Map<String, dynamic> inputJson = CodeFController.makeInputJsonForCertApis(Apis.nhisConfirmation,
                          identity, birth, name, phoneNo, telecom, address, loginCertType, randomKey);
                      apiInfoDataList.add(ApiInfoData(each["id"], inputJson, Apis.nhisConfirmation, true));
                    }
                  }
                }

                UiUtils.showLoadingPop(context);
                CodeFController.callApisWithCert(context, setState, certType, apiInfoDataList, (isSuccess, resultApiInfoDataList) {
                  UiUtils.closeLoadingPop(context);
                  if(isSuccess){
                    bool isResultSuccess = true;
                    for(var each in resultApiInfoDataList!){
                      Map<String, dynamic> resultMap = {
                        "resultValue" : each.resultFullMap
                      };
                      _setResultToListById(each.apiId, resultMap);
                      CommonUtils.log("i", "${each.apiId}\n${each.resultFullMap}");
                      if(each.resultMap == null && each.resultListMap == null){
                        isResultSuccess = false;
                      }
                    }

                    if(isResultSuccess){
                      CommonUtils.flutterToast("$subTitle에서 서류를 가져왔습니다");
                      setState(() {
                        for(int i = 0 ; i < nhisCount ; i++){
                          _setConfirmedToDocItemByViewId(currentViewId+i, true);
                        }
                      });
                    }else{
                      CommonUtils.flutterToast("입력하셨던 정보를\n다시 확인해주세요");
                      setState(() {
                        for(int i = 0 ; i < nhisCount ; i++){
                          _setConfirmedToDocItemByViewId(currentViewId+i, false);
                        }
                      });
                    }
                  }else{
                    CommonUtils.log("i", "call fail");
                    setState(() {
                      for(int i = 0 ; i < nhisCount ; i++){
                        _setConfirmedToDocItemByViewId(currentViewId+i, false);
                      }
                    });
                  }
                });
              }else{
                CommonUtils.flutterToast("이미 인증을\n완료하셨습니다.");
              }
            })
      ])));
    }

    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () async {
          if(gov24Count>0){
            currentViewId = currentViewId-gov24Count+1;
          }else{
            currentViewId = currentViewId-gov24Count;
          }
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale(title1, 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale(title2, 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale(title3, 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("$subTitle에서\n해당 서류들을 가져옵니다.", 12.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: docsWidgetList)),
      UiUtils.getMarginBox(0, 5.h),
      _isDocItemConfirmedByViewId(currentViewId)? UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        if(nhisCount == 1){
          nextInputView();
        }else{
          currentViewId = currentViewId+nhisCount-1;
          nextInputView();
        }
      }) : Container()
    ]);
  }
  /// nhis(id:3,4) view end

  /// nts(id:6,10,11) view
  Widget _getNtsView(){
    String subTitle = "'국세청'";
    String title1 = "간편인증을 통해";
    String title2 = "비대면 서류 제출이";
    String title3 = "가능합니다.";
    bool isErrorResult = false;

    for(var each in addedDocsList){
      if(each["view_id"] < currentViewId){
        if(each["is_docs"]){
          title1 = "아직 받지 못한 서류들은";
          title2 = "정부기관이 달라서";
          title3 = "다시 한번 인증을 해야해요";
        }
      }
    }
    List<Widget> docsWidgetList = [];
    for(var each in addedDocsList){
      if(each["docs_type"] == "nts"){
        Key key = UniqueKey();
        String name = "";
        Color textColor = ColorStyles.upFinRealGray;
        Color errorTextColor = ColorStyles.upFinRed;
        Color successTextColor = ColorStyles.upFinTextAndBorderBlue;
        if(each["id"] == 6){
          name = "사업자등록증";
          Map<String, dynamic> resultMap = each["result"];
          if(resultMap.containsKey("resultValue")){
            CommonUtils.log("i", "result ==> ${each["result"]["resultValue"]}");
            var dataMap = each["result"]["resultValue"]["data"];
            if(dataMap.isEmpty){
              textColor = errorTextColor;
              name += " 실패";
              isErrorResult = true;
            }else{
              textColor = successTextColor;
            }
          }
        }
        if(each["id"] == 10){
          name = "소득금액증명";
          Map<String, dynamic> resultMap = each["result"];
          if(resultMap.containsKey("resultValue")){
            CommonUtils.log("i", "result ==> ${each["result"]["resultValue"]}");
            var dataMap = each["result"]["resultValue"]["data"];
            if(dataMap.isEmpty){
              textColor = errorTextColor;
              name += " 실패";
              isErrorResult = true;
            }else{
              textColor = successTextColor;
            }
          }
        }
        if(each["id"] == 11){
          name = "부가세과세표준증명원";
          Map<String, dynamic> resultMap = each["result"];
          if(resultMap.containsKey("resultValue")){
            CommonUtils.log("i", "result ==> ${each["result"]["resultValue"]}");
            var dataMap = each["result"]["resultValue"]["data"];
            if(dataMap.isEmpty){
              textColor = errorTextColor;
              name += " 실패";
              isErrorResult = true;
            }else{
              textColor = successTextColor;
            }
          }
        }

        docsWidgetList.add(
            SizedBox(width: 90.w,
                child: Row(children: [
                  UiUtils.getCustomCircleCheckBox(key, 1.5, true, textColor, ColorStyles.upFinWhite, ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){}),
                  UiUtils.getTextStyledButtonWithFixedScale(name, 15.sp, FontWeight.w600,textColor, TextAlign.center, null, (){})
                ])
            )
        );
      }
    }
    if(!_isDocItemConfirmedByViewId(currentViewId)){
      docsWidgetList.add(SizedBox(width: 90.w, child: Column(children: [
        UiUtils.getMarginBox(0, 2.h),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("민간 인증서를 선택하세요", 14.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 1.5.h),
        SizedBox(width: 85.w, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(children: [
            Container(padding: EdgeInsets.zero, decoration: BoxDecoration(color: certType == 1? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhite, borderRadius: BorderRadius.circular(20)),
                child: UiUtils.getImageButton(Image.asset('assets/images/kakao_icon.png'), 20.w, ColorStyles.upFinBlack, () async {
                  setState(() { certType = 1; });
                })),
            UiUtils.getMarginBox(0, 1.h),
            UiUtils.getTextWithFixedScale("카카오톡", 14.sp, FontWeight.w500, certType == 1? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinDarkGray, TextAlign.start, null)
          ]),
          UiUtils.getMarginBox(5.w, 0),
          Column(children: [
            Container(padding: EdgeInsets.zero, decoration: BoxDecoration(color: certType == 6? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhite, borderRadius: BorderRadius.circular(20)),
                child: UiUtils.getImageButton(Image.asset('assets/images/apple_icon.png'), 20.w, ColorStyles.upFinBlack, () async {
                  setState(() { certType = 6; });
                })),
            UiUtils.getMarginBox(0, 1.h),
            UiUtils.getTextWithFixedScale("네이버", 14.sp, FontWeight.w500, certType == 6? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinDarkGray, TextAlign.start, null)
          ]),
          UiUtils.getMarginBox(5.w, 0),
          Column(children: [
            Container(padding: EdgeInsets.zero, decoration: BoxDecoration(color: certType == 5? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhite, borderRadius: BorderRadius.circular(20)),
                child: UiUtils.getImageButton(Image.asset('assets/images/iamport_logo.png'), 20.w, ColorStyles.upFinBlack, () async {
                  setState(() { certType = 5; });
                })),
            UiUtils.getMarginBox(0, 1.h),
            UiUtils.getTextWithFixedScale("PASS", 14.sp, FontWeight.w500, certType == 5? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinDarkGray, TextAlign.start, null)
          ]),
        ])),
        UiUtils.getMarginBox(0, 2.h),
        UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinTextAndBorderBlue,
            UiUtils.getTextWithFixedScale(_isDocItemConfirmedByViewId(currentViewId)? "인증완료" : !isErrorResult? "간편인증 진행하기" : "서류 다시 가져오기", 11.sp, FontWeight.w500, !isErrorResult? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinRed, TextAlign.start, null), () {
              if(!_isDocItemConfirmedByViewId(currentViewId)){
                String loginCertType = certType.toString();
                String name = MyData.name;
                String birth = MyData.birth;
                String phoneNo = MyData.phoneNumber;
                String identity = MyData.idNumber.split("-")[0]+MyData.idNumber.split("-")[1];
                String address = selectedAddressInfo;
                String telecom = (int.parse(MyData.telecom)-1).toString();
                if(int.parse(telecom) >= 3){
                  telecom = (int.parse(telecom)-3).toString();
                }

                CommonUtils.log("i", "$identity\n$telecom\n$phoneNo\n$birth\n$address");
                String randomKey = ntsCount==1 ? "" : CommonUtils.getRandomKey().toString();
                List<ApiInfoData> apiInfoDataList = [];
                for(var each in addedDocsList){
                  if(each["docs_type"] == "nts"){
                    if(each["id"] == 6){
                      // 사업자등록증
                      Map<String, dynamic> inputJson = CodeFController.makeInputJsonForCertApis(Apis.ntsProofCorporateRegistration,
                          identity, birth, name, phoneNo, telecom, address, loginCertType, randomKey);
                      apiInfoDataList.add(ApiInfoData(each["id"], inputJson, Apis.ntsProofCorporateRegistration, true));
                    }else if(each["id"] == 10){
                      // 소득금액증명
                      Map<String, dynamic> inputJson = CodeFController.makeInputJsonForCertApis(Apis.ntsProofIssue,
                          identity, birth, name, phoneNo, telecom, address, loginCertType, randomKey);
                      apiInfoDataList.add(ApiInfoData(each["id"], inputJson, Apis.ntsProofIssue, true));
                    }else if(each["id"] == 11){
                      // 부가세증명
                      Map<String, dynamic> inputJson = CodeFController.makeInputJsonForCertApis(Apis.ntsProofAdditionalTasStandard,
                          identity, birth, name, phoneNo, telecom, address, loginCertType, randomKey);
                      apiInfoDataList.add(ApiInfoData(each["id"], inputJson, Apis.ntsProofAdditionalTasStandard, true));
                    }
                  }
                }
                UiUtils.showLoadingPop(context);
                CodeFController.callApisWithCert(context, setState, certType, apiInfoDataList, (isSuccess, resultApiInfoDataList) {
                  UiUtils.closeLoadingPop(context);
                  if(isSuccess){
                    bool isResultSuccess = true;
                    for(var each in resultApiInfoDataList!){
                      Map<String, dynamic> resultMap = {
                        "resultValue" : each.resultFullMap
                      };
                      _setResultToListById(each.apiId, resultMap);
                      CommonUtils.log("i", "${each.apiId}\n${each.resultFullMap}");
                      if(each.resultMap == null && each.resultListMap == null){
                        isResultSuccess = false;
                      }
                    }

                    if(isResultSuccess){
                      CommonUtils.flutterToast("$subTitle에서\n서류를 가져왔습니다");
                      selectedSearchCertAddressInfo = address;
                      setState(() {
                        for(int i = 0 ; i < ntsCount ; i++){
                          _setConfirmedToDocItemByViewId(currentViewId+i, true);
                        }
                      });
                    }else{
                      CommonUtils.flutterToast("입력하셨던 정보를\n다시 확인해주세요");
                      setState(() {
                        for(int i = 0 ; i < ntsCount ; i++){
                          _setConfirmedToDocItemByViewId(currentViewId+i, false);
                        }
                      });
                    }
                  }else{
                    CommonUtils.log("i", "call fail");
                    setState(() {
                      for(int i = 0 ; i < ntsCount ; i++){
                        _setConfirmedToDocItemByViewId(currentViewId+i, false);
                      }
                    });
                  }
                });
              }else{
                CommonUtils.flutterToast("이미 인증을\n완료하셨습니다.");
              }
            })
      ])));
    }

    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () async {
          if(ntsCount>0){
            currentViewId = currentViewId-ntsCount+1;
          }else{
            currentViewId = currentViewId-ntsCount;
          }
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale(title1, 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale(title2, 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale(title3, 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("$subTitle에서 해당 서류들을 가져옵니다.", 12.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: docsWidgetList)),
      UiUtils.getMarginBox(0, 5.h),
      _isDocItemConfirmedByViewId(currentViewId)? UiUtils.getTextButtonBox(90.w, "다음", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        if(ntsCount == 1){
          nextInputView();
        }else{
          currentViewId = currentViewId+ntsCount-1;
          nextInputView();
        }
      }) : Container()
    ]);
  }
  /// nts(id:6,10,11) view end

  /// nice key cert web view
  Widget _getNiceKeyCertView(){
    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("고객님의 민감한 정보를", 20.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("보호하기 위해", 20.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("NICE신용평가 기관을 통해", 20.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("Safe-Key를 생성하세요.", 20.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 15.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Container(child: UiUtils.getImage(30.w, 30.w, Image.asset('assets/images/deutsche_bank_icon.png')))),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, _isDocItemConfirmedByViewId(currentViewId)? "다음" : "Safe-Key 만들기", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        if(_isDocItemConfirmedByViewId(currentViewId)){
          //nextInputView();
        }else{

        }

        UiUtils.showLoadingPop(context);
        Map<String, String> urlInfoMap = {
          "url" : "${LogfinController.niceUrl}/${MyData.customerUidForNiceCert}?checklist=1"
        };
        bool isSuccess = false;
        var result = await CommonUtils.moveToWithResult(context, AppView.webView.value, urlInfoMap);
        if(context.mounted) UiUtils.closeLoadingPop(context);
        if(result != null){
          isSuccess = result as bool;
          if(isSuccess){
            CommonUtils.log("i", "success returned");
            _setConfirmedToDocItemByViewId(currentViewId, true);
            nextInputView();
          }
        }

      })
    ]);
  }
  /// nice key cert web view end

  /// finish view
  Widget _getFinishConfirmView(){
    for(var each in addedDocsList){
      Map<String, dynamic> resultMap = each["result"];
      CommonUtils.log("i", "finish check\n"
          "view_id:${each["view_id"]}\n"
          "id:${each["id"]}\n"
          "name:${each["name"]}\n"
          "is_confirmed:${each["is_confirmed"]}\n"
          "is_docs:${each["is_docs"]}\n"
          "docs_type:${each["docs_type"]}\n"
          "result:${resultMap.isEmpty? "" : each["result"]["resultValue"]}\n"
      );
    }

    List<Widget> introWidgetList = [];
    for(int i = 0 ; i < addedDocsList.length-1 ; i++){
      Key key = UniqueKey();
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getCustomCircleCheckBox(key, 1.5, true, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinWhite,
                    ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){}),
                UiUtils.getTextStyledButtonWithFixedScale(addedDocsList[i]["name"], 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})
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
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("해당 대출상품으로", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("접수를 진행하시겠어요?", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: introWidgetList)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "접수하기", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        UiUtils.showLoadingPop(context);
        _uploadCertImageToAwsServer(pickedFilePath, (isSuccessToUpload){
          if(isSuccessToUpload){
            List<dynamic> docResultList = [];
            Map<String, dynamic> eachMap = {
              "pr_document_id" : "12",
              "response_data" : awsUploadUrl
            };
            docResultList.add(eachMap);
            for(var each in addedDocsList){
              if(each["is_docs"]){
                var resultMap  =  each["result"]["resultValue"]["data"];
                if(resultMap is List<dynamic>){
                  Map<String, dynamic> eachMap = {
                    "pr_document_id" : each["id"],
                    "response_data" : json.encode(resultMap)
                  };
                  docResultList.add(eachMap);
                }else{
                  Map<String, dynamic> eachMap = {
                    "pr_document_id" : each["id"],
                    "response_data" : resultMap
                  };
                  docResultList.add(eachMap);
                }
              }
            }
            String address = _getResultFromListById(addressId)["resultValue"];
            Map<String, dynamic> applyInputMap = {
              "offer_id": MyData.selectedPrInfoData!.productOfferId,
              "offer_rid": MyData.selectedPrInfoData!.productOfferRid,
              "address": address,
              "contact_no1": MyData.phoneNumber.substring(0,3),
              "contact_no2": MyData.phoneNumber.substring(3,7),
              "contact_no3": MyData.phoneNumber.substring(7),
              "jumin_no1": MyData.idNumber.split("-")[0],
              "jumin_no2": MyData.idNumber.split("-")[1],
              "memo": '모바일 신청',
              "documents": docResultList
            };

            LogfinController.callLogfinApi(LogfinApis.applyProduct, applyInputMap, (isSuccess, outputJson){
              UiUtils.closeLoadingPop(context);
              if(isSuccess){
                UiUtils.showSlideMenu(context, SlideType.bottomToTop, false, null, 25.h, 0.5, (context, setState){
                  return Column(mainAxisAlignment: MainAxisAlignment.start, children:
                  [
                    UiUtils.getMarginBox(0, 3.h),
                    UiUtils.getStyledTextWithFixedScale("상품신청 접수를 완료했습니다.", TextStyles.upFinBasicTextStyle, TextAlign.center, null),
                    Column(children: [
                      UiUtils.getMarginBox(0, 2.h),
                      UiUtils.getStyledTextWithFixedScale("메인 화면으로 돌아갑니다.", TextStyles.upFinBasicTextStyle, TextAlign.center, null),
                      UiUtils.getMarginBox(0, 3.h),
                      UiUtils.getBorderButtonBox(85.w, ColorStyles.upFinWhite, ColorStyles.upFinTextAndBorderBlue,
                          UiUtils.getTextWithFixedScale("확인", 15.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null), () {
                            UiUtils.showLoadingPop(context);
                            MyData.resetMyData();
                            LogfinController.getMainOrSearchView(context, (isSuccessToGetViewInfo, viewInfo){
                              UiUtils.closeLoadingPop(context);
                              if(isSuccessToGetViewInfo){
                                CommonUtils.moveWithRemoveUntil(context, AppView.mainView.value, null);
                              }else{
                                CommonUtils.flutterToast("화면을 불러오는데 실패했습니다.\n다시 실행해주세요.");
                              }
                            });
                          })
                    ])]);
                });
              }else{
                CommonUtils.flutterToast("접수에 실패했습니다.\n다시 시도해주세요.");
              }
            });
          }else{
            UiUtils.closeLoadingPop(context);
            CommonUtils.flutterToast("접수에 실패했습니다.\n다시 시도해주세요.");
          }
        });
        /*

        */

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
      }else if(_getIdFromListByViewId(currentViewId) == addressId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getAddressView());
      }else if(_getIdFromListByViewId(currentViewId) == cameraId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getCameraForIdCheckView());
      }else if(_getIdFromListByViewId(currentViewId) == 1 || _getIdFromListByViewId(currentViewId) == 2 || _getIdFromListByViewId(currentViewId) == 15){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getGov24View());
      }else if(_getIdFromListByViewId(currentViewId) == 3 || _getIdFromListByViewId(currentViewId) == 4){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getNhisView());
      }else if(_getIdFromListByViewId(currentViewId) == 6 || _getIdFromListByViewId(currentViewId) == 10 || _getIdFromListByViewId(currentViewId) == 11){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getNtsView());
      }else if(_getIdFromListByViewId(currentViewId) == niceId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getNiceKeyCertView());
      }else if(_getIdFromListByViewId(currentViewId) == lastId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.all(5.w), child: _getFinishConfirmView());
      }else{
        view = Container();
      }
    }

    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}