import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/configs/app_config.dart';
import 'package:upfin/controllers/juso_controller.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/controllers/sharedpreference_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:upfin/styles/TextStyles.dart';
import 'package:upfin/views/app_chat_view.dart';
import '../controllers/aws_controller.dart';
import '../controllers/clova_controller.dart';
import '../controllers/codef_controller.dart';
import '../controllers/firebase_controller.dart';
import '../controllers/get_controller.dart';
import '../controllers/hyphen_controller.dart';
import '../datas/api_info_data.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';
import 'dart:io';

class AppApplyDocView extends StatefulWidget{
  @override
  AppApplyDocViewState createState() => AppApplyDocViewState();
}

class AppApplyDocViewState extends State<AppApplyDocView> with WidgetsBindingObserver{
  double scrollScreenHeight = 57.h;
  double itemHeight2 = 0;
  double itemFullHeight2 = 0;
  int maxVisibleItemCnt2 = 0;
  int lastVisibleItem1 = 0;
  bool isScrolling2= false;
  final ScrollController _bankScrollController = ScrollController();

  final String errorMsg = "정보를 입력해주세요";
  bool isInputValid = true;
  int currentViewId = 1;

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

  /// 주소
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

  int confirmedId = 1000;

  bool isCertTypeSelected = false;
  int certType = 0; //1: 카카오 인증, 6:네이버 인증, 5:PASS 인증
  int confirmedCertType = 0; //1: 카카오 인증, 6:네이버 인증, 5:PASS 인증

  final List<Map<String, dynamic>> addedDocsList = [];
  List<Map<String, dynamic>> savedDocsList = [];
  List<Map<String, dynamic>> unSavedDocsList = [];
  int gov24Count = 0;
  int nhisCount = 0;
  int ntsCount = 0;

  void _initDocsList(){
    addedDocsList.clear();
    savedDocsList.clear();
    unSavedDocsList.clear();
    int addedIndexId = 1;
    gov24Count = 0;
    nhisCount = 0;
    ntsCount = 0;

    if(MyData.getLoanInfoList().isNotEmpty){
      String savedValue = SharedPreferenceController.getSharedPreferenceValue(SharedPreferenceController.sharedPreferenceApplyPrKey);
      if(savedValue != ""){
        savedDocsList = List<Map<String, dynamic>>.from(jsonDecode(savedValue));
      }
    }

    for(var each in savedDocsList){
      Map<String, dynamic> resultMap = each["result"];
      CommonUtils.log("", "each saved docs\n"
          "view_id:${each["view_id"]}\n"
          "id:${each["id"]}\n"
          "name:${each["name"]}\n"
          "is_confirmed:${each["is_confirmed"]}\n"
          "is_docs:${each["is_docs"]}\n"
          "docs_type:${each["docs_type"]}\n"
          "result:${resultMap.isEmpty? "" : each["result"]["resultValue"]}\n"
      );
    }

    bool isJobType1 = false;
    if(MyData.jobInfo.split("@")[1] == "1") isJobType1 = true;

    if(isJobType1){
      /*
      addedIndexId++;
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
      */

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
    for(var each in MyData.getPrRetryDocsInfoList()){
      CommonUtils.log("", "each retry docs : ${each.productDocsId}  ${each.productDocsName}");
      if(each.productDocsId == 1 || each.productDocsId == 2 || each.productDocsId == 15
          || each.productDocsId == 3 || each.productDocsId == 4
          || each.productDocsId == 6 || each.productDocsId == 10 || each.productDocsId == 11){
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
    Map<String, dynamic> confirmedInfo = {
      "id" : 0,
      "name" : "",
      "view_id" : 0,
      "result" : <String, dynamic>{},
      "is_confirmed" : false,
      "is_docs" : false,
      "docs_type" : ""
    };
    confirmedInfo["id"] = confirmedId;
    confirmedInfo["name"] = "";
    confirmedInfo["view_id"] = addedIndexId;
    confirmedInfo["is_confirmed"] = false;
    addedDocsList.add(confirmedInfo);

    addedDocsList.sort((a,b)=>a["view_id"].compareTo(b["view_id"]));
    for(var each in addedDocsList){
      CommonUtils.log("", "each sorted retry docs :  ${each["view_id"]} ${each["id"]} ${each["name"]}");
    }

    if(_isIdHereFromListById(1)) gov24Count++;
    if(_isIdHereFromListById(2)) gov24Count++;
    if(_isIdHereFromListById(15)) gov24Count++;
    if(_isIdHereFromListById(3)) nhisCount++;
    if(_isIdHereFromListById(4)) nhisCount++;
    if(_isIdHereFromListById(6)) ntsCount++;
    if(_isIdHereFromListById(10)) ntsCount++;
    if(_isIdHereFromListById(11)) ntsCount++;

    for(int addedDocIndex = 0 ; addedDocIndex < addedDocsList.length ; addedDocIndex++){
      if(addedDocsList[addedDocIndex]["id"] != 999 && addedDocsList[addedDocIndex]["id"] != 1000){
        bool isSaved = false;
        for(int savedDocIndex = 0 ; savedDocIndex < savedDocsList.length ; savedDocIndex++){
          if(addedDocsList[addedDocIndex]["id"] == savedDocsList[savedDocIndex]["id"]){
            isSaved = true;
          }
        }

        if(!isSaved){
          unSavedDocsList.add(addedDocsList[addedDocIndex]);
        }
      }
    }

    _setSavedData();
    for(var each in unSavedDocsList){
      CommonUtils.log("", "each unsaved docs :  ${each["view_id"]} ${each["id"]} ${each["name"]}");
    }

  }
  bool _isDocsAllConfirmed(String docsType){
    bool allConfirmed = true;
    for(var each in addedDocsList){
      if(each["docs_type"] == docsType && !each["is_confirmed"]){
        allConfirmed = false;
      }
    }

    return allConfirmed;
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
  int _getViewIdFromListById(int id){
    int viewId = -1;
    for(var each in addedDocsList){
      if(each["id"] == id){
        viewId = each["view_id"];
      }
    }

    return viewId;
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

  @override
  void initState(){
    CommonUtils.log("i", "AppApplyPrView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initDocsList();
    Config.contextForEmergencyBack = context;
    Config.isEmergencyRoot = false;
    FireBaseController.setStateForForeground = null;
    _addressInfoTextController.addListener(_addressTextControllerListener);
    _bankAccountInfoTextController.addListener(_bankAccountInfoTextControllerListener);
    _businessNumberInfoTextController.addListener(_businessNumberTextControllerListener);
    itemFullHeight2 = scrollScreenHeight*2;
    itemHeight2 = itemFullHeight2/LogfinController.bankList.length;
    maxVisibleItemCnt2 = (scrollScreenHeight/itemHeight2).ceil();
    int firstVisibleItem2 = 0;
    int lastVisibleItem2 = firstVisibleItem2+maxVisibleItemCnt2;
    if(firstVisibleItem2 <=0 ) firstVisibleItem2 = 0;
    if(lastVisibleItem2 >= LogfinController.bankList.length-1) lastVisibleItem2 = LogfinController.bankList.length-1;
    GetController.to.updateFirstIndex2_3(firstVisibleItem2);
    GetController.to.updateLastIndex2_3(lastVisibleItem2);
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppApplyDocView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _unFocusAllNodes();
    _disposeAllTextControllers();
    _bankScrollController.dispose();
    Config.contextForEmergencyBack = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('i','AppApplyDocView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('i','AppApplyDocView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('i','AppApplyDocView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('i','AppApplyDocView paused');
        break;
      default:
        break;
    }
  }

  Future<void> backInputView() async {
    if(isInputValid){
      isInputValid = false;
      CommonUtils.log("", "current id : $currentViewId");
      bool isPrevDocs = false;
      String prevDocsType = "";
      int prevDocsCount = 0;
      int prevId = _getIdFromListByViewId(currentViewId-1);
      CommonUtils.log("", "prev id : $prevId");

      for(var each in addedDocsList){
        if(each["id"] == prevId && each["is_docs"]){
          CommonUtils.log("i", " is prev");
          isPrevDocs = true;
          prevDocsType = each["docs_type"];
          if(prevDocsType == "gov24") prevDocsCount = gov24Count;
          if(prevDocsType == "nhis") prevDocsCount = nhisCount;
          if(prevDocsType == "nts") prevDocsCount = ntsCount;

          if(prevId == 1 || prevId == 2 || prevId == 15 || prevId == 3 || prevId == 4 || prevId == 6 || prevId == 10 || prevId == 11 ){
            if(isPrevDocs){
              currentViewId = currentViewId-prevDocsCount+1;
            }
          }
        }
      }

      if(currentViewId-1 <= 0){
        isInputValid = true;
        Navigator.pop(context);
      }else{
        await Future.delayed(const Duration(milliseconds: 120), () async {});
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
      CommonUtils.log("", "current id : $currentViewId");

      if(_getIdFromListByViewId(currentViewId) == 1 || _getIdFromListByViewId(currentViewId) == 2 || _getIdFromListByViewId(currentViewId) == 15){
        if(gov24Count != 1){
          currentViewId = currentViewId+gov24Count-1;
        }
      }else if(_getIdFromListByViewId(currentViewId) == 3 || _getIdFromListByViewId(currentViewId) == 4){
        if(nhisCount != 1){
          currentViewId = currentViewId+nhisCount-1;
        }
      }else if(_getIdFromListByViewId(currentViewId) == 6 || _getIdFromListByViewId(currentViewId) == 10 || _getIdFromListByViewId(currentViewId) == 11){
        if(ntsCount != 1){
          currentViewId = currentViewId+ntsCount-1;
        }
      }
      CommonUtils.log("", "next id : ${currentViewId+1}");

      CommonUtils.hideKeyBoard();
      if(_getIdFromListByViewId(currentViewId+1) == confirmedId){
        _applyPr();
      }else{
        await Future.delayed(const Duration(milliseconds: 120), () async {});
        setState(() {
          isInputValid = true;
          currentViewId++;
        });
      }
    }
  }

  bool _isNextAllConfirmed(){
    bool isAllConfirmed = true;
    if(_getIdFromListByViewId(currentViewId+1) != confirmedId){
      for(var each in addedDocsList){
        if(each["id"] != 999 && each["id"] != 1000 && each["view_id"] > currentViewId){
          if(!each["is_confirmed"]) isAllConfirmed = false;
        }
      }
    }

    return isAllConfirmed;
  }

  bool _isSavedData(int targetId){
    bool isSaved = true;
    for(var each in unSavedDocsList){
      if(each["id"] == targetId){
        isSaved = false;
      }
    }

    return isSaved;
  }

  String _getSavedData(int targetId){
    String result = "";
    for(var each in savedDocsList){
      if(each["id"] == targetId){
        result = each["result"]["resultValue"];
      }
    }

    return result;
  }

  void _setSavedData(){
    for(int eachAddedDocIdx = 0 ; eachAddedDocIdx < addedDocsList.length ; eachAddedDocIdx++){
      for(var eachSavedDoc in savedDocsList){
        if(addedDocsList[eachAddedDocIdx]["id"] == eachSavedDoc["id"]){
          if(addedDocsList[eachAddedDocIdx]["id"] == 1 || addedDocsList[eachAddedDocIdx]["id"] == 2 || addedDocsList[eachAddedDocIdx]["id"] == 15 ||
              addedDocsList[eachAddedDocIdx]["id"] == 3 || addedDocsList[eachAddedDocIdx]["id"] == 4
              || addedDocsList[eachAddedDocIdx]["id"] == 6 || addedDocsList[eachAddedDocIdx]["id"] == 10 || addedDocsList[eachAddedDocIdx]["id"] == 11){
            addedDocsList[eachAddedDocIdx]["is_confirmed"] = true;
            addedDocsList[eachAddedDocIdx]["result"] = eachSavedDoc["result"];
          }else if(addedDocsList[eachAddedDocIdx]["id"] == mainBankId){
            String bankCode = _getSavedData(mainBankId);
            if(bankCode != ""){
              selectedBankCodeInfo = bankCode;
              selectedBankCodeKey = Key(selectedBankCodeInfo);
              addedDocsList[eachAddedDocIdx]["is_confirmed"] = true;
              addedDocsList[eachAddedDocIdx]["result"] = eachSavedDoc["result"];
            }
          }else if(addedDocsList[eachAddedDocIdx]["id"] == mainBankAccountId){
            String bankAccount = _getSavedData(mainBankAccountId);
            if(bankAccount != ""){
              selectedBankAccountInfo = bankAccount;
              _bankAccountInfoTextController.text = selectedBankAccountInfo;
              addedDocsList[eachAddedDocIdx]["is_confirmed"] = true;
              addedDocsList[eachAddedDocIdx]["result"] = eachSavedDoc["result"];
            }
          }else if(addedDocsList[eachAddedDocIdx]["id"] == businessNumberId){
            String businessNumber = _getSavedData(businessNumberId);
            if(businessNumber != ""){
              selectedBusinessNumberInfo = businessNumber;
              _businessNumberInfoTextController.text = selectedBusinessNumberInfo;
              addedDocsList[eachAddedDocIdx]["is_confirmed"] = true;
              addedDocsList[eachAddedDocIdx]["result"] = eachSavedDoc["result"];
            }
          }else if(addedDocsList[eachAddedDocIdx]["id"] == addressId){
            String addressInfo = _getSavedData(addressId);
            if(addressInfo != ""){
              selectedAddressInfo = addressInfo;
              _addressInfoTextController.text = selectedAddressInfo;
              addedDocsList[eachAddedDocIdx]["is_confirmed"] = true;
              addedDocsList[eachAddedDocIdx]["result"] = eachSavedDoc["result"];
            }
          }
        }
      }
    }

    for(var each in addedDocsList){
      Map<String, dynamic> resultMap = each["result"];
      CommonUtils.log("", "each set saved to retry docs\n"
          "view_id:${each["view_id"]}\n"
          "id:${each["id"]}\n"
          "name:${each["name"]}\n"
          "is_confirmed:${each["is_confirmed"]}\n"
          "is_docs:${each["is_docs"]}\n"
          "docs_type:${each["docs_type"]}\n"
          "result:${resultMap.isEmpty? "" : each["result"]["resultValue"]}\n"
      );
    }
  }

  /// bank code view
  Widget _getBankCodeView(){
    List<Widget> bankCodeList = [];
    Color textColor = ColorStyles.upFinBlack;
    FontWeight fontWeight = FontWeight.w500;
    for(int i=0 ; i<LogfinController.bankList.length ; i++){
      Key key = Key(LogfinController.bankList[i]);
      if(selectedBankCodeKey == key) {
        textColor = ColorStyles.upFinBlack;
        fontWeight = FontWeight.w600;
      }
      else{
        textColor = ColorStyles.upFinBlack;
        fontWeight = FontWeight.w500;
        if(GetController.to.firstVisibleItem2_3.value >= 3){
          if(GetController.to.firstVisibleItem2_3.value-2 <= i && i <= GetController.to.firstVisibleItem2_3.value+1){
            textColor = Colors.black12;
            if(GetController.to.firstVisibleItem2_3.value+1 <= i && i <= GetController.to.firstVisibleItem2_3.value+1){
              textColor = Colors.black38;
            }
          }
        }

        if(GetController.to.lastVisibleItem2_3.value <= LogfinController.bankList.length-3){
          if(GetController.to.lastVisibleItem2_3.value-3 <= i && i <= GetController.to.lastVisibleItem2_3.value-1){
            textColor = Colors.black12;
            if(GetController.to.lastVisibleItem2_3.value-3 <= i && i <= GetController.to.lastVisibleItem2_3.value-3){
              textColor = Colors.black38;
            }
          }
        }
      }
      bankCodeList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                selectedBankCodeKey == key?
                UiUtils.getCustomCheckBox(key, 1.5, selectedBankCodeKey == key, ColorStyles.upFinButtonBlue, ColorStyles.upFinWhite,
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
      SizedBox(width: 85.w,height: 4.5.h , child: UiUtils.getTextWithFixedScale("개인사업자인 경우", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w,height: 4.5.h , child: UiUtils.getTextWithFixedScale("주거래 은행정보가", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("필요해요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
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

              GetController.to.updateFirstIndex2_3(firstVisibleItem2);
              GetController.to.updateLastIndex2_3(lastVisibleItem2);
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
          child: UiUtils.getExpandedScrollViewWithController(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: bankCodeList), _bankScrollController)
      ),
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
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButton(() async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.w),
      SizedBox(width: 85.w,height: 4.h, child: UiUtils.getTextWithFixedScale("#개인사업자", 14.sp,  FontWeight.w500, ColorStyles.upFinTextAndBorderBlue,TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("주거래은행 계좌번호", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextField(90.w, TextStyles.upFinTextFormFieldTextStyle, _bankAccountInfoFocus,
          _bankAccountInfoTextController, TextInputType.number, UiUtils.getInputDecoration("계좌번호", 14.sp, "", 0.sp), (value) { }),
      UiUtils.getExpandedScrollView(Axis.vertical, Container()),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
          UiUtils.getTextWithFixedScale("다음", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
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
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButton(() async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.w),
      SizedBox(width: 85.w,height: 4.h, child: UiUtils.getTextWithFixedScale("#개인사업자", 14.sp,  FontWeight.w500, ColorStyles.upFinTextAndBorderBlue,TextAlign.start, null)),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("사업자등록번호", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextField(90.w, TextStyles.upFinTextFormFieldTextStyle, _businessNumberInfoFocus,
          _businessNumberInfoTextController, TextInputType.number, UiUtils.getInputDecoration("사업자번호", 14.sp, "", 0.sp), (value) { }),
      UiUtils.getExpandedScrollView(Axis.vertical, Container()),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
          UiUtils.getTextWithFixedScale("다음", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
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
    FontWeight fontWeight = FontWeight.w500;
    for(var each in addressList){
      Key key = Key(each["roadAddr"]!+each["jibunAddr"]!);
      if(selectedAddressKey == key) {
        textColor = ColorStyles.upFinBlack;
        fontWeight = FontWeight.w600;
      }
      else{
        textColor = ColorStyles.upFinBlack;
        fontWeight = FontWeight.w500;
      }
      addressWidgetList.add(
          SizedBox(width: 85.w,
              child: Row(mainAxisSize : MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 5.w, child:
                selectedAddressKey == key? UiUtils.getCustomCheckBox(key, 1.2, selectedAddressKey == key, ColorStyles.upFinButtonBlue, ColorStyles.upFinWhite,
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
                    }) : UiUtils.getCustomCheckBox(key, 1.2, true, ColorStyles.upFinGray, ColorStyles.upFinWhite,
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
                  UiUtils.getTextButtonWithFixedScaleForAddress(each["roadAddr"]!, 14.sp, fontWeight, textColor, TextAlign.start, null, (){
                    setState(() {
                      selectedAddressKey = key;
                      selectedAddressInfo = each["roadAddrPart1"]!;
                      _addressInfoTextController.text = selectedAddressInfo;
                      if(selectedSearchCertAddressInfo != "" && selectedSearchCertAddressInfo != selectedAddressInfo){
                        CommonUtils.flutterToast("주소정보를 바꾸시면\n서류인증을 다시 받아야합니다.");
                      }
                    });
                  }),
                  UiUtils.getMarginBox(0, 0.8.h),
                  GestureDetector(onTap: (){
                    setState(() {
                      selectedAddressKey = key;
                      selectedAddressInfo = each["roadAddrPart1"]!;
                      _addressInfoTextController.text = selectedAddressInfo;
                      if(selectedSearchCertAddressInfo != "" && selectedSearchCertAddressInfo != selectedAddressInfo){
                        CommonUtils.flutterToast("주소정보를 바꾸시면\n서류인증을 다시 받아야합니다.");
                      }
                    });

                  }, child: UiUtils.getTextWithFixedScale(each["jibunAddr"]!, 12.sp, FontWeight.w500, textSubColor, TextAlign.start, null))
                ])),
              ])
          )
      );
      addressWidgetList.add(UiUtils.getMarginBox(0, 3.h));
    }

    return Stack(children: [
      UiUtils.getRowColumnWithAlignCenter([
        SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UiUtils.getBackButton(() async {
            backInputView();
          }),
        ])),
        UiUtils.getMarginBox(0, 3.w),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("주소를 입력해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
        // SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("입력해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 5.h),
        SizedBox(width: 85.w, height: 10.h,
            child: UiUtils.getTextField(80.w, TextStyles.upFinSmallTextFormFieldTextStyle, _addressInfoFocus,
                _addressInfoTextController, TextInputType.text, UiUtils.getInputDecorationForAddress("등본상 주소", 12.sp,
                    UiUtils.getIconButton(Icons.search, 8.w, ColorStyles.upFinButtonBlue, () {
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
                    })
                ), (value) { })
        ),
        UiUtils.getMarginBox(0, 2.h),
        UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: addressWidgetList)),
        UiUtils.getMarginBox(0, 3.h),
        selectedAddressKey != null ? UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
            UiUtils.getTextWithFixedScale("다음", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
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
      ])
    ]);
  }
  /// address view end

  void _showAuth(String subTitle, String docsType,  List<ApiInfoData> apiInfoDataList){
    UiUtils.showLoadingPop(context);
    CodeFController.callApisWithCert(context, setState, certType, apiInfoDataList, (isSuccess, resultApiInfoDataList) {
      UiUtils.closeLoadingPop(context);
      if(isSuccess){
        for(var each in resultApiInfoDataList!){
          CommonUtils.log("i", "${each.apiId}\n${each.resultFullMap}${each.resultListMap?.length}");
          Map<String, dynamic> resultMap = {
            "resultValue" : each.resultFullMap
          };
          _setResultToListById(each.apiId, resultMap);
          if(each.isResultSuccess){
            _setConfirmedToDocItemByViewId(_getViewIdFromListById(each.apiId), true);
          }else{
            _setConfirmedToDocItemByViewId(_getViewIdFromListById(each.apiId), false);
          }
        }

        setState(() {});
        if(_isDocsAllConfirmed(docsType)){
          CommonUtils.flutterToast("$subTitle에서\n서류를 가져왔습니다");
          nextInputView();
        }else{
          certType = 0;
          isCertTypeSelected = false;
          CommonUtils.flutterToast("입력하신 정보를\n확인해주세요");
        }
      }else{
        certType = 0;
        isCertTypeSelected = false;
        for(var each in resultApiInfoDataList!){
          _setConfirmedToDocItemByViewId(_getViewIdFromListById(each.apiId), false);
        }
      }
    });
  }

  Widget _getCertWidget(String docsType, String title1, String title2, String title3, String subTitle, List<Widget> docsWidgetList, bool isErrorResult, VoidCallback onPressedCallback){
    subTitle = subTitle.replaceAll("'", "");
    double depWidth = 0.0;
    if(docsType == "gov24"){
      depWidth = 42.w;
    }else if(docsType == "nhis"){
      depWidth = 54.w;
    }else if(docsType == "nts"){
      depWidth = 41.w;
    }
    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
        UiUtils.getBackButton(() async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.w),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale(title1, 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 0.8.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale(title2, 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 0.8.h),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale(title3, 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 85.w, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBorderButtonBoxForRound(depWidth, ColorStyles.upFinBlack, ColorStyles.upFinBlack,
            Row(children: [
              UiUtils.getTextWithFixedScale("제공기관: ", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null),
              UiUtils.getTextWithFixedScale(subTitle, 14.sp, FontWeight.w500, ColorStyles.upFinKakaoYellow, TextAlign.start, null)
            ]), () { })
      ])),
      UiUtils.getMarginBox(0, 2.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: docsWidgetList)),
      UiUtils.getMarginBox(0, 2.h),
      UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
          UiUtils.getTextWithFixedScale(_isNextAllConfirmed()? "제출하기" : !_isDocsAllConfirmed(docsType)? "인증하기" : "다음", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
            if(!_isDocsAllConfirmed(docsType)){
              if(certType == 0){
                UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, false, null, 40.h, 0.5, (slideContext, setState){
                  return Column(mainAxisAlignment: MainAxisAlignment.start, children:
                  [
                    Row(children: [
                      const Spacer(flex: 2),
                      UiUtils.getIconButton(Icons.close, 7.w, ColorStyles.upFinRealGray, () {
                        certType = 0;
                        isCertTypeSelected = false;
                        Navigator.pop(slideContext);
                      }),
                    ]),
                    UiUtils.getMarginBox(0, 1.5.h),
                    SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("민간 인증서를 선택하세요", 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)),
                    UiUtils.getMarginBox(0, 3.h),
                    SizedBox(width: 85.w, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Column(children: [
                        Container(padding: EdgeInsets.zero, decoration: BoxDecoration(color: certType == 1? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhite, borderRadius: BorderRadius.circular(15)),
                            child: UiUtils.getImageButton(Image.asset('assets/images/kakao_icon.png'), 16.w, ColorStyles.upFinBlack, () async {
                              setState(() { certType = 1; });
                            })),
                        UiUtils.getMarginBox(0, 1.h),
                        UiUtils.getTextWithFixedScale("카카오톡", 12.sp, FontWeight.w500, certType == 1? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinRealGray, TextAlign.start, null)
                      ]),
                      UiUtils.getMarginBox(5.w, 0),
                      Column(children: [
                        Container(padding: EdgeInsets.zero, decoration: BoxDecoration(color: certType == 6? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhite, borderRadius: BorderRadius.circular(15)),
                            child: UiUtils.getRoundImageButton(Image.asset('assets/images/naver_icon.png', fit: BoxFit.cover), 16.w, ColorStyles.upFinBlack, () async {
                              setState(() { certType = 6; });
                            })),
                        UiUtils.getMarginBox(0, 1.h),
                        UiUtils.getTextWithFixedScale("네이버", 12.sp, FontWeight.w500, certType == 6? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinRealGray, TextAlign.start, null)
                      ]),
                      UiUtils.getMarginBox(5.w, 0),
                      Column(children: [
                        Container(padding: EdgeInsets.zero, decoration: BoxDecoration(color: certType == 8? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhite, borderRadius: BorderRadius.circular(15)),
                            child: UiUtils.getRoundImageButton(Image.asset('assets/images/toss_icon.png', fit: BoxFit.cover), 16.w, ColorStyles.upFinBlack, () async {
                              setState(() { certType = 8; });
                            })),
                        UiUtils.getMarginBox(0, 1.h),
                        UiUtils.getTextWithFixedScale("토스", 12.sp, FontWeight.w500, certType == 8? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinRealGray, TextAlign.start, null)
                      ]),
                      UiUtils.getMarginBox(5.w, 0),
                      Column(children: [
                        Container(padding: EdgeInsets.zero, decoration: BoxDecoration(color: certType == 5? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhite, borderRadius: BorderRadius.circular(15)),
                            child: UiUtils.getRoundImageButton(Image.asset('assets/images/pass_icon.png', fit: BoxFit.cover), 16.w, ColorStyles.upFinBlack, () async {
                              setState(() { certType = 5; });
                            })),
                        UiUtils.getMarginBox(0, 1.h),
                        UiUtils.getTextWithFixedScale("PASS", 12.sp, FontWeight.w500, certType == 5? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinRealGray, TextAlign.start, null)
                      ])
                    ])),
                    UiUtils.getExpandedScrollView(Axis.vertical, const Column(children: [])),
                    UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinTextAndBorderBlue,
                        UiUtils.getTextWithFixedScale(_isDocsAllConfirmed(docsType) ? "인증완료" : !isErrorResult? "간편인증 진행하기" : "서류 다시 가져오기",
                            14.sp, FontWeight.w500, !isErrorResult? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinRed, TextAlign.start, null), (){
                          if(certType != 0){
                            onPressedCallback();
                            isCertTypeSelected = true;
                          }else{
                            CommonUtils.flutterToast("인증서를 선택해주세요");
                          }
                        })
                  ]);
                });
              }else{
                onPressedCallback();
              }
            }else{
              nextInputView();
            }
          }),
      UiUtils.getMarginBox(0, 1.2.h)
    ]);
  }

  int _setDocResultText(Map<String, dynamic> resultMap){
    //0 : no result
    //1 : success result
    //2 : fail result
    int resultType = 0;
    if(resultMap.containsKey("resultValue")){
      if(resultMap["resultValue"] != null){
        CommonUtils.log("i", "result ==> ${resultMap["resultValue"]}");
        Map<String, dynamic> resultDataMap = resultMap["resultValue"];
        if(resultDataMap.isNotEmpty){
          if(resultDataMap.containsKey("result") && resultDataMap.containsKey("data")){
            Map<String, dynamic> resultDataMapForResult = resultMap["resultValue"]["result"];
            var resultDataMapForData = resultMap["resultValue"]["data"];
            if(resultDataMapForResult.isNotEmpty && resultDataMapForData.isNotEmpty){
              if(resultDataMapForResult.containsKey("code")){
                if(resultDataMapForResult["code"] != "CF-03002"){
                  resultType = 1;
                }else{
                  resultType = 2;
                }
              }else{
                resultType = 2;
              }
            }else{
              resultType = 2;
            }
          }else{
            resultType = 2;
          }
        }else{
          resultType = 2;
        }
      }else{
        resultType = 2;
      }
    }

    return resultType;
  }

  void _setDocStatus(String docType, Function(bool isSuccess, List<Widget> widgetList) callback){
    bool isError = false;
    List<Widget> docsWidgetList = [];
    for(var each in addedDocsList){
      if(each["docs_type"] == docType){
        Key key = UniqueKey();
        String name = "";
        Color checkColor = ColorStyles.upFinGray;
        Color textColor = ColorStyles.upFinGray;
        Color errorTextColor = ColorStyles.upFinRed;
        Color successTextColor = ColorStyles.upFinBlack;
        Color successCheckedColor = ColorStyles.upFinButtonBlue;
        FontWeight fontWeight = FontWeight.w500;
        if(each["docs_type"] == "gov24"){
          if(each["id"] == 1){
            name = "주민등록등본";
          }
          if(each["id"] == 2){
            name = "주민등록초본";
          }
          if(each["id"] == 15){
            name = "지방세납세증명서";
          }

          if(docType == "gov24"){
            checkColor = ColorStyles.upFinGray;
            textColor = ColorStyles.upFinBlack;
          }

          if(_setDocResultText(each["result"]) == 1){
            textColor = successTextColor;
            checkColor = successCheckedColor;
            fontWeight = FontWeight.w600;
          }else if(_setDocResultText(each["result"]) == 2){
            textColor = errorTextColor;
            checkColor = errorTextColor;
            fontWeight = FontWeight.w500;
            name += " 실패";
            isError = true;
          }

          docsWidgetList.add(
              SizedBox(width: 90.w,
                  child: Row(children: [
                    UiUtils.getCustomCheckBox(key, 1.5, true, checkColor, ColorStyles.upFinWhite, ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){}),
                    UiUtils.getTextButtonWithFixedScale(name, 15.sp, fontWeight, textColor, TextAlign.center, null, (){})
                  ])
              )
          );
        }else if(each["docs_type"] == "nhis"){
          if(each["id"] == 3){
            name = "건강보험자격득실확인서";
          }
          if(each["id"] == 4){
            name = "건강보험납부확인서";
          }

          if(docType == "nhis"){
            checkColor = ColorStyles.upFinGray;
            textColor = ColorStyles.upFinBlack;
          }

          if(_setDocResultText(each["result"]) == 1){
            textColor = successTextColor;
            checkColor = successCheckedColor;
            fontWeight = FontWeight.w600;
          }else if(_setDocResultText(each["result"]) == 2){
            textColor = errorTextColor;
            checkColor = errorTextColor;
            fontWeight = FontWeight.w500;
            name += " 실패";
            isError = true;
          }

          docsWidgetList.add(
              SizedBox(width: 90.w,
                  child: Row(children: [
                    UiUtils.getCustomCheckBox(key, 1.5, true, checkColor, ColorStyles.upFinWhite, ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){}),
                    UiUtils.getTextButtonWithFixedScale(name, 15.sp, fontWeight, textColor, TextAlign.center, null, (){})
                  ])
              )
          );
        } else if(each["docs_type"] == "nts"){
          if(each["id"] == 6){
            name = "사업자등록증";
          }
          if(each["id"] == 10){
            name = "소득금액증명";
          }
          if(each["id"] == 11){
            name = "부가세과세표준증명원";
          }

          if(docType == "nts"){
            checkColor = ColorStyles.upFinGray;
            textColor = ColorStyles.upFinBlack;
          }

          if(_setDocResultText(each["result"]) == 1){
            textColor = successTextColor;
            checkColor = successCheckedColor;
            fontWeight = FontWeight.w600;
          }else if(_setDocResultText(each["result"]) == 2){
            textColor = errorTextColor;
            checkColor = errorTextColor;
            fontWeight = FontWeight.w500;
            name += " 실패";
            isError = true;
          }

          docsWidgetList.add(
              SizedBox(width: 90.w,
                  child: Row(children: [
                    UiUtils.getCustomCheckBox(key, 1.5, true, checkColor, ColorStyles.upFinWhite, ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){}),
                    UiUtils.getTextButtonWithFixedScale(name, 15.sp, fontWeight, textColor, TextAlign.center, null, (){})
                  ])
              )
          );
        }
      }
    }

    callback(isError, docsWidgetList);
  }

  /// gov24(id:1,2,15) view
  Widget _getGov24View(){
    String subTitle = "'정부24'";
    String title1 = "금융사가 요청하는";
    String title2 = "서류를 간편인증을 통해";
    String title3 = "가져올 수 있습니다. ";
    bool isErrorResult = false;

    for(var each in addedDocsList){
      if(each["view_id"] < currentViewId){
        if(each["is_docs"]){
          title1 = "🙏 아직 받지 못한 서류들은";
          title2 = "정부기관이 달라서";
          title3 = "다시 한번 인증을 해야해요.";
        }
      }
    }

    if(_isDocsAllConfirmed("gov24")){
      title1 = "정부24에서 ";
      title2 = "서류들을 모두 가져왔어요";
      title3 = "다음 절차를 진행해주세요";
    }

    List<Widget> docsWidgetList = [];
    _setDocStatus("gov24", (isError, resultDocsWidgetList){
      isErrorResult = isError;
      docsWidgetList = resultDocsWidgetList;
    });

    return _getCertWidget("gov24", title1, title2, title3, subTitle, docsWidgetList, isErrorResult, () async {
      if(_isDocsAllConfirmed("gov24")){
        CommonUtils.flutterToast("이미 인증을 완료하셨습니다.");
      }else{
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
              // 등본
              Map<String, dynamic> inputJson = CodeFController.makeInputJsonForCertApis(Apis.gov24residentRegistrationCopy,
                  identity, selectedBusinessNumberInfo, birth, name, phoneNo, telecom, address, loginCertType, randomKey);
              apiInfoDataList.add(ApiInfoData(each["id"], inputJson, Apis.gov24residentRegistrationCopy, true));
            }else if(each["id"] == 2){
              // 초본
              Map<String, dynamic> inputJson = CodeFController.makeInputJsonForCertApis(Apis.gov24residentRegistrationAbstract,
                  identity, selectedBusinessNumberInfo, birth, name, phoneNo, telecom, address, loginCertType, randomKey);
              apiInfoDataList.add(ApiInfoData(each["id"], inputJson, Apis.gov24residentRegistrationAbstract, true));
            }else if(each["id"] == 15){
              // 지방세
              Map<String, dynamic> inputJson = CodeFController.makeInputJsonForCertApis(Apis.gov24localTaxPaymentCert,
                  identity, selectedBusinessNumberInfo, birth, name, phoneNo, telecom, address, loginCertType, randomKey);
              apiInfoDataList.add(ApiInfoData(each["id"], inputJson, Apis.gov24localTaxPaymentCert, true));
            }
          }
        }
        if(!isCertTypeSelected) Navigator.of(context).pop();
        _showAuth(subTitle, "gov24", apiInfoDataList);
      }
    });
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
          title1 = "🙏 아직 받지 못한 서류들은";
          title2 = "정부기관이 달라서";
          title3 = "다시 한번 인증을 해야해요.";
        }
      }
    }
    if(_isDocsAllConfirmed("nhis")){
      title1 = "건강보험공단에서 ";
      title2 = "서류들을 모두 가져왔어요";
      title3 = "다음 절차를 진행해주세요";
    }

    List<Widget> docsWidgetList = [];
    _setDocStatus("nhis", (isError, resultDocsWidgetList){
      isErrorResult = isError;
      docsWidgetList = resultDocsWidgetList;
    });

    return _getCertWidget("nhis", title1, title2, title3, subTitle, docsWidgetList, isErrorResult, () async {
      if(_isDocsAllConfirmed("nhis")){
        CommonUtils.flutterToast("이미 인증을 완료하셨습니다.");
      }else{
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
        String randomKey = nhisCount==1 ? "" : CommonUtils.getRandomKey().toString();
        List<ApiInfoData> apiInfoDataList = [];
        for(var each in addedDocsList){
          if(each["docs_type"] == "nhis"){
            if(each["id"] == 3){
              // 건강보험자격득실확인서
              Map<String, dynamic> inputJson = CodeFController.makeInputJsonForCertApis(Apis.nhisIdentifyConfirmation,
                  identity, selectedBusinessNumberInfo, birth, name, phoneNo, telecom, address, loginCertType, randomKey);
              apiInfoDataList.add(ApiInfoData(each["id"], inputJson, Apis.nhisIdentifyConfirmation, true));
            }else if(each["id"] == 4){
              // 건강보험납부확인서
              Map<String, dynamic> inputJson = CodeFController.makeInputJsonForCertApis(Apis.nhisConfirmation,
                  identity, selectedBusinessNumberInfo, birth, name, phoneNo, telecom, address, loginCertType, randomKey);
              apiInfoDataList.add(ApiInfoData(each["id"], inputJson, Apis.nhisConfirmation, true));
            }
          }
        }
        if(!isCertTypeSelected) Navigator.of(context).pop();
        _showAuth(subTitle, "nhis", apiInfoDataList);
      }
    });
  }
  /// nhis(id:3,4) view end

  /// nts(id:6,10,11) view 국세청 사업자등록증 소득금액증명 부가세과세표준증명원
  Widget _getNtsView(){
    String subTitle = "'국세청'";
    String title1 = "간편인증을 통해";
    String title2 = "비대면 서류 제출이";
    String title3 = "가능합니다.";
    bool isErrorResult = false;

    for(var each in addedDocsList){
      if(each["view_id"] < currentViewId){
        if(each["is_docs"]){
          title1 = "🙏 아직 받지 못한 서류들은";
          title2 = "정부기관이 달라서";
          title3 = "다시 한번 인증을 해야해요.";
        }
      }
    }
    if(_isDocsAllConfirmed("nts")){
      title1 = "국세청에서 ";
      title2 = "서류들을 모두 가져왔어요";
      title3 = "다음 절차를 진행해주세요";
    }

    List<Widget> docsWidgetList = [];
    _setDocStatus("nts", (isError, resultDocsWidgetList){
      isErrorResult = isError;
      docsWidgetList = resultDocsWidgetList;
    });

    return _getCertWidget("nts", title1, title2, title3, subTitle, docsWidgetList, isErrorResult, () async {
      if(_isDocsAllConfirmed("nts")){
        CommonUtils.flutterToast("이미 인증을 완료하셨습니다.");
      }else{
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
                  identity, selectedBusinessNumberInfo, birth, name, phoneNo, telecom, address, loginCertType, randomKey);
              apiInfoDataList.add(ApiInfoData(each["id"], inputJson, Apis.ntsProofCorporateRegistration, true));
            }else if(each["id"] == 10){
              // 소득금액증명
              Map<String, dynamic> inputJson = CodeFController.makeInputJsonForCertApis(Apis.ntsProofIssue,
                  identity, selectedBusinessNumberInfo, birth, name, phoneNo, telecom, address, loginCertType, randomKey);
              apiInfoDataList.add(ApiInfoData(each["id"], inputJson, Apis.ntsProofIssue, true));
            }else if(each["id"] == 11){
              // 부가세과세표준증명원
              Map<String, dynamic> inputJson = CodeFController.makeInputJsonForCertApis(Apis.ntsProofAdditionalTasStandard,
                  identity, selectedBusinessNumberInfo, birth, name, phoneNo, telecom, address, loginCertType, randomKey);
              apiInfoDataList.add(ApiInfoData(each["id"], inputJson, Apis.ntsProofAdditionalTasStandard, true));
            }
          }
        }
        if(!isCertTypeSelected) Navigator.of(context).pop();
        _showAuth(subTitle, "nts", apiInfoDataList);
      }
    });
  }
  /// nts(id:6,10,11) view end

  void _applyPr(){
    for(var each in addedDocsList){
      Map<String, dynamic> resultMap = each["result"];
      CommonUtils.log("", "finish check ===============================>\n"
          "view_id:${each["view_id"]}\n"
          "id:${each["id"]}\n"
          "name:${each["name"]}\n"
          "is_confirmed:${each["is_confirmed"]}\n"
          "is_docs:${each["is_docs"]}\n"
          "docs_type:${each["docs_type"]}\n"
          "result:${resultMap.isEmpty? "" : each["result"]["resultValue"]}\n"
      );
    }

    UiUtils.showLoadingPop(context);
    List<dynamic> docResultList = [];
    for(var each in addedDocsList){
      if(each["is_docs"] && each["is_confirmed"] && !_isSavedData(each["id"])){
        var resultMap  =  each["result"]["resultValue"]["data"];
        //gov24 : 1:주민등록등본           2:주민등록초본        15:지방세납세증명서
        //nhis  : 3:건강보험자격득실확인서    4:건강보험납부확인서
        //nts   : 6:사업자등록증(*테스트불가) 10:소득금액증명       11:부가세과세표준증명원(*테스트불가)
        if(each["id"] == 3 || each["id"] == 4){
          if(resultMap is List<dynamic>){
            Map<String, dynamic> eachMap = {
              "pr_document_id" : each["id"],
              "response_data" : json.encode(resultMap)
            };
            docResultList.add(eachMap);
          }else{
            List<dynamic> wrapListMap = [];
            wrapListMap.add(resultMap);
            Map<String, dynamic> eachMap = {
              "pr_document_id" : each["id"],
              "response_data" : json.encode(wrapListMap)
            };
            docResultList.add(eachMap);
          }
        }else{
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
    }

    for(var each in docResultList){
      Map<String, dynamic> resultMap = each["result"];
      CommonUtils.log("", "docResultList check ===============================>\n"
          "view_id:${each["view_id"]}\n"
          "id:${each["id"]}\n"
          "name:${each["name"]}\n"
          "is_confirmed:${each["is_confirmed"]}\n"
          "is_docs:${each["is_docs"]}\n"
          "docs_type:${each["docs_type"]}\n"
          "result:${resultMap.isEmpty? "" : each["result"]["resultValue"]}\n"
      );
    }

    Map<String, dynamic> applyInputMap = {
      "loan_uid": AppChatViewState.currentLoanUid,
      "documents": docResultList
    };

    LogfinController.callLogfinApi(LogfinApis.retryDocs, applyInputMap, (isSuccess, outputJson){
      UiUtils.closeLoadingPop(context);
      if(isSuccess){
        List<Map<String, dynamic>> addedDocsListForSave = [];
        for(var each in addedDocsList){
          if(each["is_confirmed"]){
            addedDocsListForSave.add(each);
          }
        }
        SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceApplyPrKey, jsonEncode(addedDocsListForSave));
        setState(() {
          currentViewId = _getViewIdFromListById(confirmedId);
        });
      }else{
        CommonUtils.flutterToast("접수에 실패했습니다.\n다시 시도해주세요.");
      }
    });
  }
  /// finish view end

  Widget _getConfirmedView(){
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      UiUtils.getMarginBox(0, 36.h),
      UiUtils.getCustomCircleCheckBox(UniqueKey(),4, true, ColorStyles.upFinWhite, ColorStyles.upFinButtonBlue,
          ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue, (checkedValue){}),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextWithFixedScale("접수가 완료되었습니다.", 14.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, null),
      UiUtils.getExpandedScrollView(Axis.vertical, Container()),
      UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
          UiUtils.getTextWithFixedScale("확인", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null), () {
            Navigator.pop(context);
          })
    ]);
  }

  void _back(){
    CommonUtils.hideKeyBoard();
    backInputView();
  }

  @override
  Widget build(BuildContext context) {
    Widget? view;
    if(_getIdFromListByViewId(currentViewId) == 1 || _getIdFromListByViewId(currentViewId) == 2 || _getIdFromListByViewId(currentViewId) == 15){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getGov24View());
    }else if(_getIdFromListByViewId(currentViewId) == 3 || _getIdFromListByViewId(currentViewId) == 4){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getNhisView());
    }else if(_getIdFromListByViewId(currentViewId) == 6 || _getIdFromListByViewId(currentViewId) == 10 || _getIdFromListByViewId(currentViewId) == 11){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getNtsView());
    }else if(_getIdFromListByViewId(currentViewId) == confirmedId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getConfirmedView());
    }else if(_getIdFromListByViewId(currentViewId) == mainBankId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: Obx(()=>_getBankCodeView()));
    }else if(_getIdFromListByViewId(currentViewId) == mainBankAccountId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getBankAccountView());
    }else if(_getIdFromListByViewId(currentViewId) == businessNumberId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getBusinessNumberView());
    }else if(_getIdFromListByViewId(currentViewId) == addressId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getAddressView());
    }else{
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhiteSky);
    }

    return UiUtils.getViewWithAllowBackForAndroid(context, view, _back);
  }

}