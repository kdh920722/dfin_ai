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

import 'app_chat_view.dart';

class AppApplyPrView extends StatefulWidget{
  @override
  AppApplyPrViewState createState() => AppApplyPrViewState();
}

class AppApplyPrViewState extends State<AppApplyPrView> with WidgetsBindingObserver{
  static bool isRetry = false;
  double scrollScreenHeight = 57.h;
  double itemHeight2 = 0;
  double itemFullHeight2 = 0;
  int maxVisibleItemCnt2 = 0;
  int lastVisibleItem1 = 0;
  bool isScrolling2= false;
  final ScrollController _bankScrollController = ScrollController();

  final _dlNumInfoFocus1 = FocusNode();
  final _dlNumInfoTextController1 = TextEditingController();
  final _dlNumInfoFocus2 = FocusNode();
  final _dlNumInfoTextController2 = TextEditingController();
  final _dlNumInfoFocus3 = FocusNode();
  final _dlNumInfoTextController3 = TextEditingController();
  final _dlNumInfoFocus4 = FocusNode();
  final _dlNumInfoTextController4 = TextEditingController();
  final _dlNumInfoFocusSerial = FocusNode();
  final _dlNumInfoTextControllerSerial = TextEditingController();

  int reUseTargetViewId = -1;

  CameraController? _cameraController;
  GlobalKey repaintKey = GlobalKey();
  bool _isCameraReady = false;

  final String errorMsg = "정보를 입력해주세요";
  bool isInputValid = true;

  int currentViewId = 1;
  int addedDocsInfoIntroViewId = 700;
  bool isHist = false;

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
  int cameraTakePhotoId = 1000;
  String cameraName = "신분증 확인";
  bool isDriveCardForImageType = false;
  String pickedFilePath = "";
  String awsUploadUrl = "";

  int lastId = 999;
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

  Future<void> _initDocsList() async {
    currentViewId = 1;
    addedDocsList.clear();
    savedDocsList.clear();
    unSavedDocsList.clear();
    int addedIndexId = currentViewId;
    gov24Count = 0;
    nhisCount = 0;
    ntsCount = 0;

    if(MyData.getLoanInfoList().isNotEmpty){
      String savedValue = SharedPreferenceController.getSharedPreferenceValue(SharedPreferenceController.sharedPreferenceApplyPrKey);
      if(savedValue != ""){
        savedDocsList = List<Map<String, dynamic>>.from(jsonDecode(savedValue));
        if(savedDocsList.isNotEmpty){
          currentViewId = addedDocsInfoIntroViewId;
        }
      }
    }

    if(!isRetry){
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
    }

    //gov24 : 1:주민등록등본           2:주민등록초본        15:지방세납세증명서
    //nhis  : 3:건강보험자격득실확인서    4:건강보험납부확인서
    //nts   : 6:사업자등록증(*테스트불가) 10:소득금액증명       11:부가세과세표준증명원(*테스트불가)      14:납세증명서
    for(var each in MyData.getPrDocsInfoList()){
      CommonUtils.log("", "each docs : ${each.productDocsId}  ${each.productDocsName}");
      if(each.productDocsId == 1 || each.productDocsId == 2 || each.productDocsId == 15
          || each.productDocsId == 3 || each.productDocsId == 4
          || each.productDocsId == 6 || each.productDocsId == 10 || each.productDocsId == 11 || each.productDocsId == 14){
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
      }else if(each["id"] == 14){
        addedIndexId++;
        each["view_id"] = addedIndexId;
      }
    }

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

    /*
    if(!isReApply){
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
    }
     */

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
    if(_isIdHereFromListById(14)) ntsCount++;

    for(var each in savedDocsList){
      Map<String, dynamic> resultMap = each["result"];
      CommonUtils.log("", "!!!!saved check\n"
          "view_id:${each["view_id"]}\n"
          "id:${each["id"]}\n"
          "name:${each["name"]}\n"
          "is_confirmed:${each["is_confirmed"]}\n"
          "is_docs:${each["is_docs"]}\n"
          "docs_type:${each["docs_type"]}\n"
          "result:${resultMap.isEmpty? "" : each["result"]["resultValue"]}\n"
      );
    }


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

    for(var each in unSavedDocsList){
      Map<String, dynamic> resultMap = each["result"];
      CommonUtils.log("", "!!!!unsaved check\n"
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
  Future<void> _setValidImg() async {
    bool isSavedImgValid = true;
    String imgFilePath = _getSavedData(cameraId);
    if(imgFilePath != ""){
      if(!await CommonUtils.isFileExists(pickedFilePath)){
        pickedFilePath = "";
        isSavedImgValid = false;
      }
    }else{
      isSavedImgValid = false;
    }

    if(!isSavedImgValid){
      int targetIdx = -1;
      for(int i = 0 ; i < savedDocsList.length ; i++){
        if(savedDocsList[i]["id"] == cameraId){
          targetIdx = i;
        }
      }

      if(targetIdx != -1){
        savedDocsList.removeAt(targetIdx);
        for(var each in addedDocsList){
          if(each["id"] == cameraId){
            each["is_confirmed"] = false;
            each["result"] = <String, dynamic>{};
            unSavedDocsList.add(each);
          }
        }
      }
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

  @override
  void initState(){
    CommonUtils.log("d", "AppApplyPrView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initDocsList();
    _addressInfoTextController.addListener(_addressTextControllerListener);
    _bankAccountInfoTextController.addListener(_bankAccountInfoTextControllerListener);
    _businessNumberInfoTextController.addListener(_businessNumberTextControllerListener);

    availableCameras().then((cameras) {
      if (cameras.isNotEmpty && _cameraController == null) {
        _cameraController = CameraController(
          cameras.first,
          ResolutionPreset.medium,
          enableAudio: false
        );

        _cameraController!.initialize().then((_) {
          _cameraController!.setFlashMode(FlashMode.off);
          setState(() {
            _isCameraReady = true;
          });
        });
      }
    });

    itemFullHeight2 = scrollScreenHeight*2;
    itemHeight2 = itemFullHeight2/LogfinController.bankList.length;
    maxVisibleItemCnt2 = (scrollScreenHeight/itemHeight2).ceil();
    int firstVisibleItem2 = 0;
    int lastVisibleItem2 = firstVisibleItem2+maxVisibleItemCnt2;
    if(firstVisibleItem2 <=0 ) firstVisibleItem2 = 0;
    if(lastVisibleItem2 >= LogfinController.bankList.length-1) lastVisibleItem2 = LogfinController.bankList.length-1;

    GetController.to.updateFirstIndex2_3(firstVisibleItem2);
    GetController.to.updateLastIndex2_3(lastVisibleItem2);
    Config.contextForEmergencyBack = context;
    Config.isEmergencyRoot = false;
    FireBaseController.setStateForForeground = null;
  }

  @override
  void dispose(){
    CommonUtils.log("d", "AppApplyPrView 화면 파괴");
    _unFocusAllNodesForDl();
    _disposeAllTextControllersForDl();
    WidgetsBinding.instance.removeObserver(this);
    _bankScrollController.dispose();
    Config.contextForEmergencyBack = null;
    if(_cameraController != null){
      _cameraController!.dispose();
    }
    isRetry = false;
    MyData.clearPrDocsInfoList();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('d','AppApplyPrView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('d','AppApplyPrView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('d','AppApplyPrView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('d','AppApplyPrView paused');
        break;
      default:
        break;
    }
  }

  void _unFocusAllNodesForDl(){
    _dlNumInfoFocus1.unfocus();
    _dlNumInfoFocus2.unfocus();
    _dlNumInfoFocus3.unfocus();
    _dlNumInfoFocus4.unfocus();
    _dlNumInfoFocusSerial.unfocus();
  }

  void _disposeAllTextControllersForDl(){
    _dlNumInfoTextController1.dispose();
    _dlNumInfoTextController2.dispose();
    _dlNumInfoTextController3.dispose();
    _dlNumInfoTextController4.dispose();
    _dlNumInfoTextControllerSerial.dispose();
  }

  Future<void> backInputView() async {
    if(isInputValid){
      bool isPrevDocs = false;
      String prevDocsType = "";
      int prevDocsCount = 0;
      int prevId = _getIdFromListByViewId(currentViewId-1);

      if(reUseTargetViewId != -1){
        if(currentViewId == reUseTargetViewId){
          CommonUtils.hideKeyBoard();
          setState(() {
            _resetSavedData();
            _initDocsList();
            currentViewId = addedDocsInfoIntroViewId;
          });
        }else{
          for(var each in addedDocsList){
            if(each["id"] == prevId && each["is_docs"]){
              CommonUtils.log("i", " is prev");
              isPrevDocs = true;
              prevDocsType = each["docs_type"];
              if(prevDocsType == "gov24") prevDocsCount = gov24Count;
              if(prevDocsType == "nhis") prevDocsCount = nhisCount;
              if(prevDocsType == "nts") prevDocsCount = ntsCount;

              if(prevId == 1 || prevId == 2 || prevId == 15 || prevId == 3 || prevId == 4 || prevId == 6 || prevId == 10 || prevId == 11 || prevId == 14){
                if(isPrevDocs){
                  currentViewId = currentViewId-prevDocsCount+1;
                }
              }
            }
          }

          isInputValid = false;
          CommonUtils.hideKeyBoard();
          if(currentViewId-1 == 0){
            Navigator.pop(context);
          }else{
            await Future.delayed(const Duration(milliseconds: 120), () async {});
            setState(() {
              currentViewId--;
              isInputValid = true;
            });
          }
        }
      }else{
        for(var each in addedDocsList){
          if(each["id"] == prevId && each["is_docs"]){
            isPrevDocs = true;
            prevDocsType = each["docs_type"];
            if(prevDocsType == "gov24") prevDocsCount = gov24Count;
            if(prevDocsType == "nhis") prevDocsCount = nhisCount;
            if(prevDocsType == "nts") prevDocsCount = ntsCount;

            if(prevId == 1 || prevId == 2 || prevId == 15 || prevId == 3 || prevId == 4 || prevId == 6 || prevId == 10 || prevId == 11 || prevId == 14){
              if(isPrevDocs){
                currentViewId = currentViewId-prevDocsCount+1;
              }
            }
          }
        }

        isInputValid = false;
        CommonUtils.hideKeyBoard();
        if(currentViewId-1 == 0){
          if(isHist){
            setState(() {
              _resetSavedData();
              _initDocsList();
              currentViewId = addedDocsInfoIntroViewId;
            });
            isInputValid = true;
          }else{
            Navigator.pop(context);
          }
        }else{
          await Future.delayed(const Duration(milliseconds: 120), () async {});
          setState(() {
            currentViewId--;
            isInputValid = true;
          });
        }
      }
    }
  }

  Future<void> nextInputView() async {
    if(isInputValid){
      if(_getIdFromListByViewId(currentViewId) == 1 || _getIdFromListByViewId(currentViewId) == 2 || _getIdFromListByViewId(currentViewId) == 15){
        if(gov24Count != 1){
          currentViewId = currentViewId+gov24Count-1;
        }
      }else if(_getIdFromListByViewId(currentViewId) == 3 || _getIdFromListByViewId(currentViewId) == 4){
        if(nhisCount != 1){
          currentViewId = currentViewId+nhisCount-1;
        }
      }else if(_getIdFromListByViewId(currentViewId) == 6 || _getIdFromListByViewId(currentViewId) == 10
          || _getIdFromListByViewId(currentViewId) == 11 || _getIdFromListByViewId(currentViewId) == 14){
        if(ntsCount != 1){
          currentViewId = currentViewId+ntsCount-1;
        }
      }
      isInputValid = false;
      CommonUtils.hideKeyBoard();
      if(_getIdFromListByViewId(currentViewId+1) != confirmedId){
        bool isAllConfirmed = true;
        for(var each in addedDocsList){
          if(each["id"] != 999 && each["id"] != 1000 && each["view_id"] > currentViewId){
            if(!each["is_confirmed"]) isAllConfirmed = false;
          }
        }

        if(isAllConfirmed){
          setState(() {
            currentViewId = _getViewIdFromListById(lastId);
            isInputValid = true;
          });
        }else{
          await Future.delayed(const Duration(milliseconds: 120), () async {});
          setState(() {
            currentViewId++;
            isInputValid = true;
          });
        }
      }else{
        await Future.delayed(const Duration(milliseconds: 120), () async {});
        setState(() {
          currentViewId++;
          isInputValid = true;
        });
      }
    }
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

  /// added info intro view
  Widget _getIntroView(){
    isHist = true;
    for(var each in savedDocsList){
      Map<String, dynamic> resultMap = each["result"];
      CommonUtils.log("", "saved check\n"
          "view_id:${each["view_id"]}\n"
          "id:${each["id"]}\n"
          "name:${each["name"]}\n"
          "is_confirmed:${each["is_confirmed"]}\n"
          "is_docs:${each["is_docs"]}\n"
          "docs_type:${each["docs_type"]}\n"
          "result:${resultMap.isEmpty? "" : each["result"]["resultValue"]}\n"
      );
    }

    for(var each in unSavedDocsList){
      Map<String, dynamic> resultMap = each["result"];
      CommonUtils.log("", "unsaved check\n"
          "view_id:${each["view_id"]}\n"
          "id:${each["id"]}\n"
          "name:${each["name"]}\n"
          "is_confirmed:${each["is_confirmed"]}\n"
          "is_docs:${each["is_docs"]}\n"
          "docs_type:${each["docs_type"]}\n"
          "result:${resultMap.isEmpty? "" : each["result"]["resultValue"]}\n"
      );
    }

    for(var each in addedDocsList){
      Map<String, dynamic> resultMap = each["result"];
      CommonUtils.log("", "addedDoc check\n"
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

    introWidgetList.add(
        UiUtils.getMarginBox(0, 1.h)
    );

    if(unSavedDocsList.isEmpty){
      if(!isRetry){
        introWidgetList.add(
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(width: 90.w, child: Row(children: [
                UiUtils.getImage(12.w, 12.w, Image.asset(MyData.selectedPrInfoData!.productCompanyLogo)),
                UiUtils.getMarginBox(3.w, 0),
                Column(children: [
                  SizedBox(width: 75.w, child: UiUtils.getTextWithFixedScaleAndOverFlow(MyData.selectedPrInfoData!.productCompanyName, 15.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, 1)),
                  UiUtils.getMarginBox(0, 1.h),
                  SizedBox(width: 75.w, child: UiUtils.getTextWithFixedScaleAndOverFlow(MyData.selectedPrInfoData!.productName, 10.sp, FontWeight.w600, ColorStyles.upFinRealGray, TextAlign.start, 1)),
                ])
              ])),
              UiUtils.getMarginBox(0, 3.h),
              SizedBox(width: 90.w, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                UiUtils.getBorderButtonBoxWithZeroPadding(42.w, ColorStyles.upFinRealWhite, ColorStyles.upFinGray,
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      UiUtils.getMarginBox(0, 2.h),
                      SizedBox(width: 30.w, child: UiUtils.getTextWithFixedScale("최저금리", 10.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, 1)),
                      UiUtils.getMarginBox(0, 1.h),
                      SizedBox(width: 35.w, child: UiUtils.getTextWithFixedScale("${MyData.selectedPrInfoData!.productLoanMinRates}%", 15.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1)),
                      UiUtils.getMarginBox(0, 2.h),
                    ]), () {}),
                UiUtils.getMarginBox(2.w, 0),
                UiUtils.getBorderButtonBoxWithZeroPadding(42.w, ColorStyles.upFinRealWhite, ColorStyles.upFinGray,
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      UiUtils.getMarginBox(0, 2.h),
                      SizedBox(width: 30.w, child: UiUtils.getTextWithFixedScale("최대한도", 10.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, 1)),
                      UiUtils.getMarginBox(0, 1.h),
                      SizedBox(width: 35.w, child: UiUtils.getTextWithFixedScale(CommonUtils.getPriceFormattedString(double.parse(MyData.selectedPrInfoData!.productLoanLimit)), 15.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1)),
                      UiUtils.getMarginBox(0, 2.h),
                    ]), () {})
              ]))

            ])
        );

        introWidgetList.add(
            UiUtils.getMarginBox(0, 5.h)
        );
      }
    }

    if(!isRetry){
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: UiUtils.getTextWithFixedScale("기본정보", 14.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)
          )
      );
      introWidgetList.add(
          UiUtils.getMarginBox(0, 3.h)
      );
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getMarginBox(3.w, 0),
                UiUtils.getTextButtonWithFixedScale("•  ${MyData.name}", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})
              ])
          )
      );
      introWidgetList.add(
          UiUtils.getMarginBox(0, 3.h)
      );
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getMarginBox(3.w, 0),
                UiUtils.getTextButtonWithFixedScale("•  ${MyData.phoneNumber.substring(0,3)} ${MyData.phoneNumber.substring(3,7)} ${MyData.phoneNumber.substring(7)}",
                    13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})
              ])
          )
      );
      introWidgetList.add(
          UiUtils.getMarginBox(0, 3.h)
      );
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getMarginBox(3.w, 0),
                UiUtils.getTextButtonWithFixedScale("•  ${MyData.idNumber.split("-")[0]}-${MyData.idNumber.split("-")[1].substring(0,1)}******", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})
              ])
          )
      );
      introWidgetList.add(
          UiUtils.getMarginBox(0, 3.h)
      );
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getMarginBox(3.w, 0),
                UiUtils.getTextButtonWithFixedScale("•  기대출 ${MyData.selectedAccidentInfoData!.accidentLendCount.split("@")[0]}", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})
              ])
          )
      );
      introWidgetList.add(
          UiUtils.getMarginBox(0, 3.h)
      );
      if(MyData.selectedAccidentInfoData!.accidentLendAmount != "0"){
        introWidgetList.add(
            SizedBox(width: 90.w,
                child: Row(children: [
                  UiUtils.getMarginBox(3.w, 0),
                  UiUtils.getTextButtonWithFixedScale("•  인가후대출금액 ${CommonUtils.getPriceFormattedString(double.parse(MyData.selectedAccidentInfoData!.accidentLendAmount))}",
                      13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})

                ])
            )
        );
      }else{
        introWidgetList.add(
            SizedBox(width: 90.w,
                child: Row(children: [
                  UiUtils.getMarginBox(3.w, 0),
                  UiUtils.getTextButtonWithFixedScale("•  인가후대출금액 0원", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})

                ])
            )
        );
      }
      introWidgetList.add(
          UiUtils.getMarginBox(0, 3.h)
      );
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getMarginBox(3.w, 0),
                UiUtils.getTextButtonWithFixedScale("•  [환급] ${MyData.selectedAccidentInfoData!.accidentBankInfo.split("@")[0]} ${MyData.selectedAccidentInfoData!.accidentBankAccount}",
                    13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})
              ])
          )
      );
      introWidgetList.add(
          UiUtils.getMarginBox(0, 3.h)
      );
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getMarginBox(3.w, 0),
                UiUtils.getTextButtonWithFixedScale("•  ${MyData.jobInfo.split("@")[0]}", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})
              ])
          )
      );

      if(MyData.jobInfo.split("@")[1] == "1" && _isSavedData(businessNumberId)){
        String tempBusinessNumberIdInfo = _getSavedData(businessNumberId);
        /*
      introWidgetList.add(
          UiUtils.getMarginBox(0, 3.h)
      );
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getMarginBox(3.w, 0),
                UiUtils.getTextButtonWithFixedScale("•  [주거래 은행] ${tempSelectedBankCodeInfo.split("@")[0]} $tempSelectedBankAccountInfo", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})

              ])
          )
      );
      */
        introWidgetList.add(
            UiUtils.getMarginBox(0, 3.h)
        );
        introWidgetList.add(
            SizedBox(width: 90.w,
                child: Row(children: [
                  UiUtils.getMarginBox(3.w, 0),
                  UiUtils.getTextButtonWithFixedScale("•  사업자번호 $tempBusinessNumberIdInfo", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})

                ])
            )
        );
      }
      introWidgetList.add(
          UiUtils.getMarginBox(0, 3.h)
      );
      if(MyData.selectedAccidentInfoData!.accidentWishAmount != "0"){
        introWidgetList.add(
            SizedBox(width: 90.w,
                child: Row(children: [
                  UiUtils.getMarginBox(3.w, 0),
                  UiUtils.getTextButtonWithFixedScale("•  대출희망금액 ${CommonUtils.getPriceFormattedString(double.parse(MyData.selectedAccidentInfoData!.accidentWishAmount))}",
                      13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})

                ])
            )
        );
      }else{
        introWidgetList.add(
            SizedBox(width: 90.w,
                child: Row(children: [
                  UiUtils.getMarginBox(3.w, 0),
                  UiUtils.getTextButtonWithFixedScale("•  대출희망금액 0원", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})

                ])
            )
        );
      }

      if(unSavedDocsList.isNotEmpty){
        introWidgetList.add(
            UiUtils.getMarginBox(0, 5.h)
        );
        introWidgetList.add(
            SizedBox(width: 90.w,
                child: UiUtils.getTextWithFixedScale("미제출정보", 14.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)
            )
        );
        introWidgetList.add(
            UiUtils.getMarginBox(0, 1.h)
        );
        for(int i = 0 ; i < unSavedDocsList.length ; i++){
          Key key = UniqueKey();
          introWidgetList.add(
              SizedBox(width: 90.w,
                  child: Row(children: [
                    UiUtils.getCustomCheckBox(key, 1.5, true, ColorStyles.upFinGray, ColorStyles.upFinWhite,
                        ColorStyles.upFinGray,  ColorStyles.upFinWhite, (checkedValue){}),
                    UiUtils.getTextButtonWithFixedScale(unSavedDocsList[i]["name"], 13.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.center, null, (){})
                  ])
              )
          );
        }
      }

      introWidgetList.add(
          UiUtils.getMarginBox(0, 5.h)
      );
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: UiUtils.getTextWithFixedScale("제출정보", 14.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)
          )
      );
      introWidgetList.add(
          UiUtils.getMarginBox(0, 1.h)
      );
      for(int i = 0 ; i < addedDocsList.length ; i++){
        // 95~99
        if(addedDocsList[i]["id"] != 999 && addedDocsList[i]["id"] != 1000){
          bool isSaved = false;
          for(var each in savedDocsList){
            if(addedDocsList[i]["id"] == each["id"]){
              isSaved = true;
            }
          }

          if(isSaved){
            Key key = UniqueKey();
            introWidgetList.add(
                SizedBox(width: 90.w,
                    child: Row(children: [
                      UiUtils.getCustomCheckBox(key, 1.2, true, ColorStyles.upFinBlack, ColorStyles.upFinWhite,
                          ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){}),
                      UiUtils.getTextButtonWithFixedScale(addedDocsList[i]["name"], 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})
                    ])
                )
            );
          }
        }
      }

      // apply pr
    }else{
      introWidgetList.add(
          UiUtils.getMarginBox(0, 1.h)
      );

      introWidgetList.add(
          SizedBox(width: 90.w,
              child: UiUtils.getTextWithFixedScale("저장된 정보", 14.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)
          )
      );
      introWidgetList.add(
          UiUtils.getMarginBox(0, 1.h)
      );
      for(int i = 0 ; i < addedDocsList.length ; i++){
        // 95~99
        if(addedDocsList[i]["id"] != 999 && addedDocsList[i]["id"] != 1000){
          bool isSaved = false;
          for(var each in savedDocsList){
            if(addedDocsList[i]["id"] == each["id"]){
              isSaved = true;
            }
          }

          if(isSaved){
            Key key = UniqueKey();
            introWidgetList.add(
                SizedBox(width: 90.w,
                    child: Row(children: [
                      UiUtils.getCustomCheckBox(key, 1.2, true, ColorStyles.upFinBlack, ColorStyles.upFinWhite,
                          ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){}),
                      UiUtils.getTextButtonWithFixedScale(addedDocsList[i]["name"], 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})
                    ])
                )
            );
          }
        }
      }

      introWidgetList.add(
          UiUtils.getMarginBox(0, 5.h)
      );
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: UiUtils.getTextWithFixedScale("미제출정보", 14.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)
          )
      );
      introWidgetList.add(
          UiUtils.getMarginBox(0, 1.h)
      );
      for(var eachDoc in MyData.getPrDocsInfoList()){
        for(int i = 0 ; i < addedDocsList.length ; i++){
          if(eachDoc.productDocsId == addedDocsList[i]["id"]){
            Key key = UniqueKey();
            introWidgetList.add(
                SizedBox(width: 90.w,
                    child: Row(children: [
                      UiUtils.getCustomCheckBox(key, 1.2, true, ColorStyles.upFinGray, ColorStyles.upFinWhite,
                          ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){}),
                      UiUtils.getTextButtonWithFixedScale(addedDocsList[i]["name"], 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})
                    ])
                )
            );
          }
        }
      }
    }

    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButton(() async {
          Navigator.pop(context);
        }),
      ])),
      UiUtils.getMarginBox(0, 3.w),
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("기존에 제출하셨던 정보로", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 0.8.h),
      isRetry? SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("서류접수를 진행할까요?", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null))
          : SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("상품접수를 진행할까요?", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: introWidgetList)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
          UiUtils.getTextWithFixedScale("네 좋아요!", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null), () async {
            await _setSavedData();
            if(unSavedDocsList.isEmpty){
              _applyPr();
            }else{
              setState(() {
                var targetDoc = unSavedDocsList[0];
                if(targetDoc["is_docs"]){
                  if(targetDoc["docs_type"] == "gov24"){
                    for(int i = addedDocsList.length-1 ; i >= 0 ; i--){
                      if(addedDocsList[i]["docs_type"] == "gov24"){
                        reUseTargetViewId = addedDocsList[i]["view_id"];
                      }
                    }
                  }else if(targetDoc["docs_type"] == "nhis"){
                    for(int i = addedDocsList.length-1 ; i >= 0 ; i--){
                      if(addedDocsList[i]["docs_type"] == "nhis"){
                        reUseTargetViewId = addedDocsList[i]["view_id"];
                      }
                    }
                  }else{
                    for(int i = addedDocsList.length-1 ; i >= 0 ; i--){
                      if(addedDocsList[i]["docs_type"] == "nts"){
                        reUseTargetViewId = addedDocsList[i]["view_id"];
                      }
                    }
                  }
                }else{
                  reUseTargetViewId = targetDoc["view_id"];
                }

                currentViewId = reUseTargetViewId;
              });
              CommonUtils.flutterToast("미제출 정보를\n입력해야합니다.");

            }
          }),
      UiUtils.getMarginBox(0, 0.5.h),
      UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinWhiteSky,
          UiUtils.getTextWithFixedScale("다시 입력할게요", 14.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.center, null), () {
            setState(() {
              if(isRetry){
                currentViewId = _getViewIdFromListById(addressId);
              }else{
                currentViewId = _getViewIdFromListById(cameraId);
              }
            });
          })
    ]);
  }

  Future<void> _setSavedData() async {
    for(int eachAddedDocIdx = 0 ; eachAddedDocIdx < addedDocsList.length ; eachAddedDocIdx++){
      for(var eachSavedDoc in savedDocsList){
        if(addedDocsList[eachAddedDocIdx]["id"] == eachSavedDoc["id"]){
          if(addedDocsList[eachAddedDocIdx]["id"] == mainBankId){
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
          }else if(addedDocsList[eachAddedDocIdx]["id"] == cameraId){
            String imgFilePath = _getSavedData(cameraId);
            if(imgFilePath != ""){
              pickedFilePath = imgFilePath;
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
          //gov24 : 1:주민등록등본           2:주민등록초본        15:지방세납세증명서
          //nhis  : 3:건강보험자격득실확인서    4:건강보험납부확인서
          //nts   : 6:사업자등록증(*테스트불가) 10:소득금액증명       11:부가세과세표준증명원(*테스트불가)
          else if(addedDocsList[eachAddedDocIdx]["id"] == 1 || addedDocsList[eachAddedDocIdx]["id"] == 2 || addedDocsList[eachAddedDocIdx]["id"] == 15 ||
              addedDocsList[eachAddedDocIdx]["id"] == 3 || addedDocsList[eachAddedDocIdx]["id"] == 4
              || addedDocsList[eachAddedDocIdx]["id"] == 6 || addedDocsList[eachAddedDocIdx]["id"] == 10
              || addedDocsList[eachAddedDocIdx]["id"] == 11 || addedDocsList[eachAddedDocIdx]["id"] == 14){
            addedDocsList[eachAddedDocIdx]["is_confirmed"] = true;
            addedDocsList[eachAddedDocIdx]["result"] = eachSavedDoc["result"];
          }
        }
      }
    }

    for(var each in addedDocsList){
      Map<String, dynamic> resultMap = each["result"];
      CommonUtils.log("i", "set addedDoc check\n"
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
  void _resetSavedData(){
    selectedBankCodeInfo = "";
    selectedBankCodeKey = Key("");
    selectedBankAccountInfo = "";
    _bankAccountInfoTextController.text = "";
    selectedBusinessNumberInfo = "";
    _businessNumberInfoTextController.text = "";
    pickedFilePath = "";
    selectedAddressInfo = "";
    _addressInfoTextController.text = "";
  }
  /// added info intro view end

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
      UiUtils.getTextField(context, 90.w, TextStyles.upFinTextFormFieldTextStyle, _bankAccountInfoFocus,
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
      UiUtils.getTextField(context, 90.w, TextStyles.upFinTextFormFieldTextStyle, _businessNumberInfoFocus,
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

    CommonUtils.log("w", "textf : ${12.sp} || ${MediaQuery.of(context).textScaleFactor}");


    return Stack(children: [
      UiUtils.getRowColumnWithAlignCenter([
        SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UiUtils.getBackButton(() async {
            backInputView();
          }),
        ])),
        UiUtils.getMarginBox(0, 3.w),
        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("주소를 입력해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 5.h),
        SizedBox(width: 85.w, height: 10.h,
            child: UiUtils.getTextField(context, 80.w, TextStyles.upFinTextFormFieldTextStyle, _addressInfoFocus,
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

  /// camera for id check view
  Widget _getCameraForIdCheckView(){
    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButton(() async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.w),
      pickedFilePath != "" ? SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("촬영하신 주민등록증", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)) : Container(),
      pickedFilePath != "" ? UiUtils.getMarginBox(0, 1.h) : Container(),
      pickedFilePath != "" ? SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("이미지를 확인해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)) : Container(),
      pickedFilePath != "" ? Container() : SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("신분증을 준비해주세요.", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 2.h),

      pickedFilePath != "" ? SizedBox(width: 85.w,height: 2.5.h , child: UiUtils.getTextWithFixedScale("주민등록증 뒷자리가", 12.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)) :
      SizedBox(width: 85.w,height: 2.5.h , child: UiUtils.getTextWithFixedScale("주민등록증 또는 운전면허증 중", 12.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
      pickedFilePath != "" ? UiUtils.getMarginBox(0, 0.5.h) : Container(),
      pickedFilePath != "" ? SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("잘 가려졌는지 확인해주세요.", 12.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)) :
      SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("하나를 촬영 해 주세요.", 12.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),

      UiUtils.getMarginBox(0, 10.h),
      pickedFilePath != "" ? Container(decoration: BoxDecoration(color: ColorStyles.upFinBlack, borderRadius: BorderRadius.circular(10)), child: UiUtils.getImage(80.w, 22.h, Image.file(File(pickedFilePath))))
          : UiUtils.getImage(85.w, 24.h, Image.asset(fit: BoxFit.fitHeight,'assets/images/img_id_card.png')),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Container()),
      pickedFilePath != "" ? SizedBox(width: 90.w, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
            UiUtils.getTextWithFixedScale("다음", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
              if(_isDocItemConfirmedByViewId(currentViewId)){
                nextInputView();
              }
            }),
      ])) : Container(),
      UiUtils.getMarginBox(0, 1.5.h),
      SizedBox(width: 90.w, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        UiUtils.getBorderButtonBox(90.w, pickedFilePath != "" ? ColorStyles.upFinWhiteSky : ColorStyles.upFinButtonBlue, pickedFilePath != "" ? ColorStyles.upFinWhiteSky : ColorStyles.upFinButtonBlue,
            UiUtils.getTextWithFixedScale(pickedFilePath != "" ? "다시 촬영하기" : "촬영하기", 14.sp, FontWeight.w500, pickedFilePath != "" ? ColorStyles.upFinButtonBlue : ColorStyles.upFinWhite, TextAlign.start, null), () {
              setState(() { currentViewId = cameraTakePhotoId; });
            }),
      ])),
    ]);
  }
  Widget _takeCustomCamera() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
            child: SizedBox(width: 100.w, height: Config.isAndroid? 70.h : 63.h, child: _cameraController != null && _isCameraReady ? CameraPreview(_cameraController!) : Container(color: ColorStyles.upFinBlack))
        ),
        Positioned(
          top: 0,
          child: Container(
            width: 100.w,
            height: 35.4.h,
            color: Colors.black,
          ),
        ),
        Positioned(
          top: 59.595.h,
          child: Container(
            width: 100.w,
            height: 40.4.h,
            color: Colors.black,
          ),
        ),
        Positioned(
          top: 35.4.h,
          left: 0,
          child: Container(
            width: 8.w,
            height: 24.2.h,
            color: Colors.black,
          ),
        ),
        Positioned(
          top: 35.4.h,
          right: 0,
          child: Container(
            width: 8.w,
            height: 24.2.h,
            color: Colors.black,
          ),
        ),
        Positioned(
          top: 3.w,
          right: 3.w,
          child: UiUtils.getCloseButton(ColorStyles.upFinWhite, () {
            setState(() {
              currentViewId = _getViewIdFromListById(cameraId);
            });
          })
        ),
        Positioned(
            top: 31.7.h,
            child: SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale2("아래 영역에 신분증을 위치해주세요", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null))
        ),
        Positioned(
            top: 8.h,
            child: SizedBox(width: 85.w, child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
              UiUtils.getRoundBoxTextWithFixedScale(" 🚨 안내사항 ", 11.sp, FontWeight.w600, TextAlign.start, ColorStyles.upFinWhite, ColorStyles.upFinBlack),
              UiUtils.getMarginBox(0, 0.7.h),
              UiUtils.getTextWithFixedScale2(
                  "1.신분증은 반드시 신분증 원본을 준비해주세요."
                      "\n   신분증 사본(모니터/휴대폰 화면 촬영 등)으로 확인될 경우,\n   인식이 되지 않을 수 있습니다."
                      "\n2.신분증을 어두운 배경에 두고, 밝은곳에서 촬영해주세요."
                      "\n   신분증의 홀로그램 부분에 빛이 반사되지 않도록\n   카메라 방향을 조정해주세요.", 10.sp, FontWeight.w300, ColorStyles.upFinWhite, TextAlign.start, null),
            ]))
        ),
        Positioned(
            top: 35.h,
            child: Container(
              width: 85.w,
              height: 25.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: ColorStyles.upFinButtonBlue,
                  width: 1.w,
                ),
              ),
            ),
        ),
        Positioned(
            top: Config.isAndroid? 87.5.h : 80.h,
            child: UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                UiUtils.getTextWithFixedScale("촬영", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null), () {
                  if(_cameraController != null){
                    _onTakePicture(context);
                  }
                })
        ),
      ],
    );
  }

  Future<void> _onTakePicture(BuildContext context) async {
    UiUtils.showLoadingPop(context);
    _cameraController!.setFlashMode(FlashMode.off);
    await _cameraController!.setFocusMode(FocusMode.locked);
    await _cameraController!.setExposureMode(ExposureMode.locked);
    final imageFile = await _cameraController!.takePicture();
    setState(() {
      currentViewId = _getViewIdFromListById(cameraId);
    });
    await _cameraController!.setFocusMode(FocusMode.auto);
    await _cameraController!.setExposureMode(ExposureMode.auto);
    if(context.mounted){
      if(imageFile.path != ""){
        _checkValidCertImage(imageFile);
      }else{
        if(context.mounted) UiUtils.closeLoadingPop(context);
      }
    }
  }

  Future<void> _checkValidCertImage(XFile image) async {
    try{
      CommonUtils.flutterToast("신분증을 인식중입니다.");
      await CLOVAController.uploadImageToCLOVA(image.path, (isSuccess, map) async {
        if(map != null){
          if(isSuccess){
            String maskedImagePath = await CommonUtils.makeMaskingImageAndGetPath(image.path, map);
            if(maskedImagePath != ""){
              String checkId = map['personalNum'][0]["text"];
              if(checkId != ""){
                if(checkId.split("-").length == 2){
                  if(checkId.split("-")[0].length == 6 && checkId.split("-")[1].length == 7){
                    MyData.idNumber = map['personalNum'][0]["formatted"]["value"];
                    String croppedImagePath = await CommonUtils.makeCroppedImageAndGetPath(maskedImagePath, map);

                    try{
                      if(map['id_type'] == "dl"){
                        CommonUtils.log("d", "dl : infos\n${map["code"][0]["formatted"]["value"]} || ${map["num"][0]["formatted"]["value"]}");
                        String licenseNum = map["num"][0]["formatted"]["value"];
                        List<String> licenseNumList = licenseNum.split("-");
                        Map<String, dynamic> inputJson = {};
                        bool isCheckNeeded = false;
                        if(licenseNumList.length == 4){
                          inputJson = {
                            "ownerNm": MyData.name,
                            "juminNo": MyData.birth,
                            "licence01": licenseNum.split("-")[0],
                            "licence02": licenseNum.split("-")[1],
                            "licence03": licenseNum.split("-")[2],
                            "licence04": licenseNum.split("-")[3],
                            "serialNo": map["code"][0]["formatted"]["value"]
                          };
                        }else if(licenseNumList.length == 3){
                          inputJson = {
                            "ownerNm": MyData.name,
                            "juminNo": MyData.birth,
                            "licence01": licenseNum.split(" ")[0],
                            "licence02": licenseNum.split(" ")[1].split("-")[0],
                            "licence03": licenseNum.split(" ")[1].split("-")[1],
                            "licence04": licenseNum.split(" ")[1].split("-")[2],
                            "serialNo": map["code"][0]["formatted"]["value"]
                          };
                        }else{
                          isCheckNeeded = true;
                          inputJson = {
                            "ownerNm": MyData.name,
                            "juminNo": MyData.birth,
                            "licence01": "",
                            "licence02": "",
                            "licence03": "",
                            "licence04": "",
                            "serialNo": map["code"][0]["formatted"]["value"]
                          };
                        }

                        if(isCheckNeeded){
                          if(context.mounted){
                            UiUtils.closeLoadingPop(context);
                            UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, false, 100.w, 80.h, 0.5, (slideContext, slideSetState){
                              _dlNumInfoTextController1.addListener((){
                                if(_dlNumInfoTextController1.text.trim().length > 2){
                                  _dlNumInfoTextController1.text = _dlNumInfoTextController1.text.trim().substring(0,2);
                                }
                              });
                              _dlNumInfoTextController2.addListener((){
                                if(_dlNumInfoTextController2.text.trim().length > 2){
                                  _dlNumInfoTextController2.text = _dlNumInfoTextController2.text.trim().substring(0,2);
                                }
                              });
                              _dlNumInfoTextController3.addListener((){
                                if(_dlNumInfoTextController3.text.trim().length > 7){
                                  _dlNumInfoTextController3.text = _dlNumInfoTextController3.text.trim().substring(0,7);
                                }
                              });
                              _dlNumInfoTextController4.addListener((){
                                if(_dlNumInfoTextController4.text.trim().length > 2){
                                  _dlNumInfoTextController4.text = _dlNumInfoTextController4.text.trim().substring(0,2);
                                }
                              });

                              _dlNumInfoTextControllerSerial.addListener((){
                                if(_dlNumInfoTextControllerSerial.text.trim().length > 7){
                                  _dlNumInfoTextControllerSerial.text = _dlNumInfoTextControllerSerial.text.trim().substring(0,8);
                                }
                              });

                              _dlNumInfoTextController1.text = inputJson["licence01"].toString();
                              _dlNumInfoTextController2.text = inputJson["licence02"].toString();
                              _dlNumInfoTextController3.text = inputJson["licence03"].toString();
                              _dlNumInfoTextController4.text = inputJson["licence04"].toString();
                              _dlNumInfoTextControllerSerial.text = inputJson["serialNo"].toString();
                              return Material(
                                  child: Container(color: ColorStyles.upFinWhite,
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children:
                                      [
                                        Row(children: [
                                          const Spacer(flex: 2),
                                          UiUtils.getIconButton(Icons.close, 7.w, ColorStyles.upFinRealGray, () {
                                            CommonUtils.hideKeyBoard();
                                            Navigator.pop(slideContext);
                                            _setConfirmedToDocItemByViewId(currentViewId, false);
                                            setState(() {
                                              pickedFilePath = "";
                                            });
                                          }),
                                        ]),
                                        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("인식된 신분증 정보입니다.", 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)),
                                        UiUtils.getMarginBox(0, 0.5.w),
                                        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("정보가 맞다면, 확인을 눌러주세요!", 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)),
                                        UiUtils.getMarginBox(0, 5.h),
                                        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("운전면허 번호", 14.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, null)),
                                        SizedBox(width: 90.w, height: 6.h, child: Row(crossAxisAlignment:CrossAxisAlignment.center, children: [
                                          UiUtils.getTextField(slideContext, 15.w, TextStyles.upFinTextFormFieldTextStyle, _dlNumInfoFocus1, _dlNumInfoTextController1, TextInputType.text,
                                              UiUtils.getInputDecoration("", 0.sp, "", 0.sp), (value) { }),
                                          Column(mainAxisAlignment:MainAxisAlignment.center, children: [UiUtils.getMarginBox(0, 1.6.w), UiUtils.getTextWithFixedScale("-", 15.sp, FontWeight.w400, ColorStyles.upFinRealGray, TextAlign.center, null)]),
                                          UiUtils.getTextField(slideContext, 13.w, TextStyles.upFinTextFormFieldTextStyle, _dlNumInfoFocus2, _dlNumInfoTextController2, TextInputType.text,
                                              UiUtils.getInputDecoration("", 0.sp, "", 0.sp), (value) { }),
                                          Column(mainAxisAlignment:MainAxisAlignment.center, children: [UiUtils.getMarginBox(0, 1.6.w), UiUtils.getTextWithFixedScale("-", 15.sp, FontWeight.w400, ColorStyles.upFinRealGray, TextAlign.center, null)]),
                                          UiUtils.getTextField(slideContext, 30.w, TextStyles.upFinTextFormFieldTextStyle, _dlNumInfoFocus3, _dlNumInfoTextController3, TextInputType.text,
                                              UiUtils.getInputDecoration("", 0.sp, "", 0.sp), (value) { }),
                                          Column(mainAxisAlignment:MainAxisAlignment.center, children: [UiUtils.getMarginBox(0, 1.6.w), UiUtils.getTextWithFixedScale("-", 15.sp, FontWeight.w400, ColorStyles.upFinRealGray, TextAlign.center, null)]),
                                          UiUtils.getTextField(slideContext, 13.w, TextStyles.upFinTextFormFieldTextStyle, _dlNumInfoFocus4, _dlNumInfoTextController4, TextInputType.text,
                                              UiUtils.getInputDecoration("", 0.sp, "", 0.sp), (value) { }),
                                        ])),
                                        UiUtils.getMarginBox(0, 7.w),
                                        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("시리얼 번호", 14.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, null)),
                                        SizedBox(width: 30.w, height: 6.h, child: UiUtils.getTextField(slideContext, 30.w, TextStyles.upFinTextFormFieldTextStyle, _dlNumInfoFocusSerial, _dlNumInfoTextControllerSerial, TextInputType.text,
                                            UiUtils.getInputDecoration("", 0.sp, "", 0.sp), (value) { })),
                                        UiUtils.getMarginBox(0, 7.w),
                                        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("이름", 14.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, null)),
                                        UiUtils.getMarginBox(0, 2.w),
                                        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(MyData.name, 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null)),
                                        UiUtils.getMarginBox(0, 7.w),
                                        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("주민등록번호", 14.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, null)),
                                        UiUtils.getMarginBox(0, 2.w),
                                        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("${MyData.idNumber.substring(0,8)} ••••••", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null)),
                                        UiUtils.getMarginBox(0, 7.w),
                                        UiUtils.getExpandedScrollView(Axis.vertical, Container()),
                                        UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                                            UiUtils.getTextWithFixedScale("확인", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), (){
                                              CommonUtils.hideKeyBoard();
                                              inputJson["licence01"] = _dlNumInfoTextController1.text.trim();
                                              inputJson["licence02"] = _dlNumInfoTextController2.text.trim();
                                              inputJson["licence03"] = _dlNumInfoTextController3.text.trim();
                                              inputJson["licence04"] = _dlNumInfoTextController4.text.trim();
                                              inputJson["serialNo"] = _dlNumInfoTextControllerSerial.text.trim();
                                              UiUtils.showLoadingPop(slideContext);
                                              HyphenController.callHyphenApiForCert(HyphenApis.driveIdCert, inputJson, (isSuccessToCertId){
                                                UiUtils.closeLoadingPop(slideContext);
                                                Navigator.pop(slideContext);
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
                                                  Map<String, dynamic> resultMap = {
                                                    "resultValue" : {}
                                                  };
                                                  _setResultToListById(cameraId, resultMap);
                                                  setState(() {
                                                    pickedFilePath = "";
                                                  });
                                                }
                                              });
                                            }),
                                        Config.isAndroid? Container() : UiUtils.getMarginBox(0, 3.h),
                                      ])
                                  )
                              );
                            });
                          }
                        }else{
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
                              Map<String, dynamic> resultMap = {
                                "resultValue" : {}
                              };
                              _setResultToListById(cameraId, resultMap);
                              setState(() {
                                pickedFilePath = "";
                              });
                            }
                          });
                        }
                      }else{
                        CommonUtils.log("d", "ic : infos\n${map["issueDate"][0]["formatted"]["year"]}${map["issueDate"][0]["formatted"]["month"]}${map["issueDate"][0]["formatted"]["day"]}");
                        Map<String, dynamic> inputJson = {
                          "ownerNm": MyData.name,
                          "juminNo": MyData.idNumber.replaceAll("-", ""),
                          "issueDt": "${map["issueDate"][0]["formatted"]["year"]}${map["issueDate"][0]["formatted"]["month"]}${map["issueDate"][0]["formatted"]["day"]}"
                        };

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
                            Map<String, dynamic> resultMap = {
                              "resultValue" : {}
                            };
                            _setResultToListById(cameraId, resultMap);
                            setState(() {
                              pickedFilePath = "";
                            });
                          }
                        });
                      }
                    }catch(imageError){
                      if(context.mounted) UiUtils.closeLoadingPop(context);
                      _setConfirmedToDocItemByViewId(currentViewId, false);
                      setState(() {
                        pickedFilePath = "";
                      });
                      CommonUtils.flutterToast("신분증 인식실패\n다시 시도해주세요");
                      CommonUtils.log("e", "tage imageError : $imageError");
                    }
                  }
                }else{
                  if(context.mounted) UiUtils.closeLoadingPop(context);
                  _setConfirmedToDocItemByViewId(currentViewId, false);
                  setState(() {
                    pickedFilePath = "";
                  });
                  CommonUtils.flutterToast("신분증 인식실패\n다시 시도해주세요");
                }
              }else{
                if(context.mounted) UiUtils.closeLoadingPop(context);
                _setConfirmedToDocItemByViewId(currentViewId, false);
                setState(() {
                  pickedFilePath = "";
                });
                CommonUtils.flutterToast("신분증 인식실패\n다시 시도해주세요");
              }
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
      if(context.mounted) UiUtils.closeLoadingPop(context);
      _setConfirmedToDocItemByViewId(currentViewId, false);
      setState(() {
        pickedFilePath = "";
      });
      CommonUtils.log("e", "tage image error : $error");
      CommonUtils.flutterToast("사진을 가져오는 중\n에러가 발생했습니다.");
    }
  }
  Future<void> _uploadCertImageToAwsServer(String croppedImagePath, Function(bool isSuccess) callback) async {
    try{
      String filePath = "${AwsController.maskedImageDir}/${MyData.email}/${CommonUtils.convertTimeToString(CommonUtils.getCurrentLocalTime())}";
      await AwsController.uploadFileToAWS(croppedImagePath,filePath, (isSuccessToSave, resultUrl) async {
        if(isSuccessToSave){
          awsUploadUrl = "${AwsController.uploadedUrl}/$filePath/${resultUrl.split("/").last}";
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

  void _showAuth(String subTitle, String docsType,  List<ApiInfoData> apiInfoDataList){
    UiUtils.showLoadingPop(context);
    CodeFController.callApisWithCert2(context, setState, certType, apiInfoDataList, (isSuccess, resultApiInfoDataList) {
      UiUtils.closeLoadingPop(context);
      if(isSuccess){
        for(var each in resultApiInfoDataList!){
          Map<String, dynamic> resultMap = {
            "result_codef_code" : each.errorCode ?? "",
            "resultValue" : each.resultFullMap
          };
          _setResultToListById(each.apiId, resultMap);
          if(each.isResultSuccess){
            _setConfirmedToDocItemByViewId(_getViewIdFromListById(each.apiId), true);
          }else{
            _setConfirmedToDocItemByViewId(_getViewIdFromListById(each.apiId), false);
          }
        }

        if(_isDocsAllConfirmed(docsType)){
          CommonUtils.flutterToast("$subTitle에서\n서류를 가져왔습니다");
          nextInputView();
        }else{
          certType = 0;
          isCertTypeSelected = false;
          CommonUtils.flutterToast("에러내용을 확인해주세요.");
        }
      }else{
        certType = 0;
        isCertTypeSelected = false;
        String errorMsgCode = "";
        if(resultApiInfoDataList != null){
          for(var each in resultApiInfoDataList){
            if(each.errorCode != null && each.errorCode != ""){
              errorMsgCode = each.errorCode!;
            }
          }
          for(var each in resultApiInfoDataList){
            Map<String, dynamic> resultMap = {
              "result_codef_code" : errorMsgCode,
              "resultValue" : each.resultFullMap
            };
            _setResultToListById(each.apiId, resultMap);
            _setConfirmedToDocItemByViewId(_getViewIdFromListById(each.apiId), false);
          }
        }
      }

      setState(() {});
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
          UiUtils.getTextWithFixedScale(!_isDocsAllConfirmed(docsType)? "인증하기" : "다음", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
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
                            GetController.to.updateWait(false);
                            CodeFController.isTimeOutException = false;
                            onPressedCallback();
                            isCertTypeSelected = true;
                          }else{
                            CommonUtils.flutterToast("인증서를 선택해주세요");
                          }
                        }),
                    Config.isAndroid? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 3.h)
                  ]);
                });
              }else{
                onPressedCallback();
              }
            }else{
              nextInputView();
            }
          }),
      UiUtils.getMarginBox(0, 1.2.h),
      isRetry? Container() : !_isDocsAllConfirmed(docsType)? UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinWhiteSky,
          UiUtils.getTextWithFixedScale(isErrorResult? "다음에 할게요" : "다음에 할게요", 12.sp, FontWeight.w500, isErrorResult? ColorStyles.upFinRed : ColorStyles.upFinButtonBlue, TextAlign.start, null), () {
            nextInputView();
          }) : Container()
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

          Map<String, dynamic> resultMap = each["result"];
          String errorMsg = "";
          if(resultMap.containsKey("result_codef_code") && resultMap["result_codef_code"] != ""){
            errorMsg = CodeFController.getErrorMsg(resultMap["result_codef_code"]);
            textColor = errorTextColor;
            checkColor = errorTextColor;
            fontWeight = FontWeight.w500;
            name += " 실패";
            isError = true;
          }else{
            if(_setDocResultText(each["result"]) == 1){
              textColor = successTextColor;
              checkColor = successCheckedColor;
              fontWeight = FontWeight.w600;
            }
          }

          docsWidgetList.add(
              SizedBox(width: 90.w,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      UiUtils.getCustomCheckBox(key, 1.5, true, checkColor, ColorStyles.upFinWhite, ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){}),
                      UiUtils.getTextButtonWithFixedScale(name, 15.sp, fontWeight, textColor, TextAlign.center, null, (){})
                    ]),
                    errorMsg != "" ? Row(children: [
                      UiUtils.getMarginBox(12.w, 0),
                      UiUtils.getTextButtonWithFixedScale("* $errorMsg", 11.sp, FontWeight.w300, textColor, TextAlign.start, null, (){})
                    ]) : UiUtils.getMarginBox(0, 0),
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
/*
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

 */

          Map<String, dynamic> resultMap = each["result"];
          String errorMsg = "";
          if(resultMap.containsKey("result_codef_code") && resultMap["result_codef_code"] != ""){
            errorMsg = CodeFController.getErrorMsg(resultMap["result_codef_code"]);
            textColor = errorTextColor;
            checkColor = errorTextColor;
            fontWeight = FontWeight.w500;
            name += " 실패";
            isError = true;
          }else{
            if(_setDocResultText(each["result"]) == 1){
              textColor = successTextColor;
              checkColor = successCheckedColor;
              fontWeight = FontWeight.w600;
            }
          }

          docsWidgetList.add(
              SizedBox(width: 90.w,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      UiUtils.getCustomCheckBox(key, 1.5, true, checkColor, ColorStyles.upFinWhite, ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){}),
                      UiUtils.getTextButtonWithFixedScale(name, 15.sp, fontWeight, textColor, TextAlign.center, null, (){})
                    ]),
                    errorMsg != "" ? Row(children: [
                      UiUtils.getMarginBox(12.w, 0),
                      UiUtils.getTextButtonWithFixedScale("* $errorMsg", 11.sp, FontWeight.w300, textColor, TextAlign.start, null, (){})
                    ]) : UiUtils.getMarginBox(0, 0),
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
          if(each["id"] == 14){
            name = "국세납세증명서";
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

          Map<String, dynamic> resultMap = each["result"];
          String errorMsg = "";
          if(resultMap.containsKey("result_codef_code") && resultMap["result_codef_code"] != ""){
            errorMsg = CodeFController.getErrorMsg(resultMap["result_codef_code"]);
            textColor = errorTextColor;
            checkColor = errorTextColor;
            fontWeight = FontWeight.w500;
            name += " 실패";
            isError = true;
          }else{
            if(_setDocResultText(each["result"]) == 1){
              textColor = successTextColor;
              checkColor = successCheckedColor;
              fontWeight = FontWeight.w600;
            }
          }

          docsWidgetList.add(
              SizedBox(width: 90.w,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      UiUtils.getCustomCheckBox(key, 1.5, true, checkColor, ColorStyles.upFinWhite, ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){}),
                      UiUtils.getTextButtonWithFixedScale(name, 15.sp, fontWeight, textColor, TextAlign.center, null, (){})
                    ]),
                    errorMsg != "" ? Row(children: [
                      UiUtils.getMarginBox(12.w, 0),
                      UiUtils.getTextButtonWithFixedScale("* $errorMsg", 11.sp, FontWeight.w300, textColor, TextAlign.start, null, (){})
                    ]) : UiUtils.getMarginBox(0, 0),
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

  /// nts(id:6,10,11,14) view 국세청 사업자등록증 소득금액증명 부가세과세표준증명원
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
            }else if(each["id"] == 14){
              // 국세납세증명서
              Map<String, dynamic> inputJson = CodeFController.makeInputJsonForCertApis(Apis.ntsTaxCert,
                  identity, selectedBusinessNumberInfo, birth, name, phoneNo, telecom, address, loginCertType, randomKey);
              apiInfoDataList.add(ApiInfoData(each["id"], inputJson, Apis.ntsTaxCert, true));
            }
          }
        }
        if(!isCertTypeSelected) Navigator.of(context).pop();
        _showAuth(subTitle, "nts", apiInfoDataList);
      }
    });
  }
  /// nts(id:6,10,11,14) view end

  /// finish view
  Widget _getFinishConfirmView(){
    List<Widget> introWidgetList = [];

    introWidgetList.add(
        UiUtils.getMarginBox(0, 1.h)
    );
    if(!isRetry){
      introWidgetList.add(
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 90.w, child: Row(children: [
              UiUtils.getImage(12.w, 12.w, Image.asset(MyData.selectedPrInfoData!.productCompanyLogo)),
              UiUtils.getMarginBox(3.w, 0),
              Column(children: [
                SizedBox(width: 75.w, child: UiUtils.getTextWithFixedScaleAndOverFlow(MyData.selectedPrInfoData!.productCompanyName, 15.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, 1)),
                UiUtils.getMarginBox(0, 1.h),
                SizedBox(width: 75.w, child: UiUtils.getTextWithFixedScaleAndOverFlow(MyData.selectedPrInfoData!.productName, 10.sp, FontWeight.w600, ColorStyles.upFinRealGray, TextAlign.start, 1)),
              ])
            ])),
            UiUtils.getMarginBox(0, 3.h),
            SizedBox(width: 90.w, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              UiUtils.getBorderButtonBoxWithZeroPadding(42.w, ColorStyles.upFinRealWhite, ColorStyles.upFinGray,
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    UiUtils.getMarginBox(0, 2.h),
                    SizedBox(width: 30.w, child: UiUtils.getTextWithFixedScale("최저금리", 10.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, 1)),
                    UiUtils.getMarginBox(0, 1.h),
                    SizedBox(width: 35.w, child: UiUtils.getTextWithFixedScale("${MyData.selectedPrInfoData!.productLoanMinRates}%", 15.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1)),
                    UiUtils.getMarginBox(0, 2.h),
                  ]), () {}),
              UiUtils.getMarginBox(2.w, 0),
              UiUtils.getBorderButtonBoxWithZeroPadding(42.w, ColorStyles.upFinRealWhite, ColorStyles.upFinGray,
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    UiUtils.getMarginBox(0, 2.h),
                    SizedBox(width: 30.w, child: UiUtils.getTextWithFixedScale("최대한도", 10.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, 1)),
                    UiUtils.getMarginBox(0, 1.h),
                    SizedBox(width: 35.w, child: UiUtils.getTextWithFixedScale(CommonUtils.getPriceFormattedString(double.parse(MyData.selectedPrInfoData!.productLoanLimit)), 15.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1)),
                    UiUtils.getMarginBox(0, 2.h),
                  ]), () {})
            ]))

          ])
      );

      introWidgetList.add(
          UiUtils.getMarginBox(0, 5.h)
      );

      introWidgetList.add(
          SizedBox(width: 90.w,
              child: UiUtils.getTextWithFixedScale("기본정보", 14.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)
          )
      );
      introWidgetList.add(
          UiUtils.getMarginBox(0, 3.h)
      );
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getMarginBox(3.w, 0),
                UiUtils.getTextButtonWithFixedScale("•  ${MyData.name}", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})
              ])
          )
      );
      introWidgetList.add(
          UiUtils.getMarginBox(0, 3.h)
      );
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getMarginBox(3.w, 0),
                UiUtils.getTextButtonWithFixedScale("•  ${MyData.phoneNumber.substring(0,3)} ${MyData.phoneNumber.substring(3,7)} ${MyData.phoneNumber.substring(7)}", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})
              ])
          )
      );
      introWidgetList.add(
          UiUtils.getMarginBox(0, 3.h)
      );
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getMarginBox(3.w, 0),
                UiUtils.getTextButtonWithFixedScale("•  ${MyData.idNumber.split("-")[0]}-${MyData.idNumber.split("-")[1].substring(0,1)}******", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})
              ])
          )
      );
      introWidgetList.add(
          UiUtils.getMarginBox(0, 3.h)
      );
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getMarginBox(3.w, 0),
                UiUtils.getTextButtonWithFixedScale("•  기대출 ${MyData.selectedAccidentInfoData!.accidentLendCount.split("@")[0]}", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})
              ])
          )
      );
      introWidgetList.add(
          UiUtils.getMarginBox(0, 3.h)
      );
      if(MyData.selectedAccidentInfoData!.accidentLendAmount != "0"){
        introWidgetList.add(
            SizedBox(width: 90.w,
                child: Row(children: [
                  UiUtils.getMarginBox(3.w, 0),
                  UiUtils.getTextButtonWithFixedScale("•  인가후대출금액 ${CommonUtils.getPriceFormattedString(double.parse(MyData.selectedAccidentInfoData!.accidentLendAmount))}", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})

                ])
            )
        );
      }else{
        introWidgetList.add(
            SizedBox(width: 90.w,
                child: Row(children: [
                  UiUtils.getMarginBox(3.w, 0),
                  UiUtils.getTextButtonWithFixedScale("•  인가후대출금액 0원", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})

                ])
            )
        );
      }
      introWidgetList.add(
          UiUtils.getMarginBox(0, 3.h)
      );
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getMarginBox(3.w, 0),
                UiUtils.getTextButtonWithFixedScale("•  [환급] ${MyData.selectedAccidentInfoData!.accidentBankInfo.split("@")[0]} ${MyData.selectedAccidentInfoData!.accidentBankAccount}", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})
              ])
          )
      );
      introWidgetList.add(
          UiUtils.getMarginBox(0, 3.h)
      );
      introWidgetList.add(
          SizedBox(width: 90.w,
              child: Row(children: [
                UiUtils.getMarginBox(3.w, 0),
                UiUtils.getTextButtonWithFixedScale("•  ${MyData.jobInfo.split("@")[0]}", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})
              ])
          )
      );
      if(MyData.jobInfo.split("@")[1] == "1"){
        introWidgetList.add(
            UiUtils.getMarginBox(0, 3.h)
        );
        introWidgetList.add(
            SizedBox(width: 90.w,
                child: Row(children: [
                  UiUtils.getMarginBox(3.w, 0),
                  UiUtils.getTextButtonWithFixedScale("•  [주거래 은행] ${selectedBankCodeInfo.split("@")[0]} $selectedBankAccountInfo", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})

                ])
            )
        );
        introWidgetList.add(
            UiUtils.getMarginBox(0, 3.h)
        );
        introWidgetList.add(
            SizedBox(width: 90.w,
                child: Row(children: [
                  UiUtils.getMarginBox(3.w, 0),
                  UiUtils.getTextButtonWithFixedScale("•  사업자번호 $selectedBusinessNumberInfo", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})

                ])
            )
        );
      }
      introWidgetList.add(
          UiUtils.getMarginBox(0, 3.h)
      );
      if(MyData.selectedAccidentInfoData!.accidentWishAmount != "0"){
        introWidgetList.add(
            SizedBox(width: 90.w,
                child: Row(children: [
                  UiUtils.getMarginBox(3.w, 0),
                  UiUtils.getTextButtonWithFixedScale("•  대출희망금액 ${CommonUtils.getPriceFormattedString(double.parse(MyData.selectedAccidentInfoData!.accidentWishAmount))}", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})

                ])
            )
        );
      }else{
        introWidgetList.add(
            SizedBox(width: 90.w,
                child: Row(children: [
                  UiUtils.getMarginBox(3.w, 0),
                  UiUtils.getTextButtonWithFixedScale("•  대출희망금액 0원", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})

                ])
            )
        );
      }

      introWidgetList.add(
          UiUtils.getMarginBox(0, 5.h)
      );
      // apply pr
    }

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
    introWidgetList.add(
        SizedBox(width: 90.w,
            child: UiUtils.getTextWithFixedScale("제출정보", 14.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)
        )
    );
    introWidgetList.add(
        UiUtils.getMarginBox(0, 1.h)
    );
    for(int i = 0 ; i < addedDocsList.length ; i++){
      if(addedDocsList[i]["is_confirmed"] && addedDocsList[i]["id"] != 999 && addedDocsList[i]["id"] != 1000){
        Key key = UniqueKey();
        introWidgetList.add(
            SizedBox(width: 90.w,
                child: Row(children: [
                  UiUtils.getCustomCheckBox(key, 1.2, true, ColorStyles.upFinBlack, ColorStyles.upFinWhite,
                      ColorStyles.upFinWhite,  ColorStyles.upFinWhite, (checkedValue){}),
                  UiUtils.getTextButtonWithFixedScale(addedDocsList[i]["name"], 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null, (){})
                ])
            )
        );
      }
    }

    return UiUtils.getRowColumnWithAlignCenter([
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButton( () async {
          backInputView();
        }),
      ])),
      UiUtils.getMarginBox(0, 3.w),
      isRetry? Container() : SizedBox(width: 85.w,height: 4.5.h , child: UiUtils.getTextWithFixedScale("해당 대출상품으로", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      isRetry? SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("서류를 접수하시겠어요?", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null))
          : SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("접수를 진행하시겠어요?", 22.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: introWidgetList)),
      UiUtils.getMarginBox(0, 5.h),
      UiUtils.getTextButtonBox(90.w, "접수하기", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () async {
        _applyPr();
      }),
      UiUtils.getMarginBox(0, 1.2.h),
    ]);
  }
  Future<void> _applyPr() async {
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

    if(isRetry){
      UiUtils.showLoadingPop(context);
      List<dynamic> docResultList = [];
      for(var each in addedDocsList){
        if(each["is_docs"] && each["is_confirmed"]){
          var resultMap  =  each["result"]["resultValue"]["data"];
          //gov24 : 1:주민등록등본           2:주민등록초본        15:지방세납세증명서
          //nhis  : 3:건강보험자격득실확인서    4:건강보험납부확인서
          //nts   : 6:사업자등록증(*테스트불가) 10:소득금액증명       11:부가세과세표준증명원(*테스트불가)      14:국세납세증명서
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

      Map<String, dynamic> applyInputMap = {
        "loan_uid": AppChatViewState.currentLoanUid,
        "documents": docResultList
      };

      LogfinController.callLogfinApi(LogfinApis.retryDocs, applyInputMap, (isSuccess, outputJson){
        UiUtils.closeLoadingPop(context);
        if(isSuccess){
          List<Map<String, dynamic>> addedDocsListForSave = [];
          List<Map<String, dynamic>> addedDupleDocsListForSave = [];
          for(var eachAdded in addedDocsList){
            if(eachAdded["is_confirmed"] && eachAdded["id"] != 1000 && eachAdded["id"] != 999){
              for(var each in savedDocsList){
                if(each["id"] == eachAdded["id"]){
                  addedDupleDocsListForSave.add(eachAdded);
                }
              }
            }
          }
          for(var eachAdded in addedDocsList){
            if(eachAdded["is_confirmed"] && eachAdded["id"] != 1000 && eachAdded["id"] != 999){
              addedDocsListForSave.add(eachAdded);
            }
          }
          if(addedDupleDocsListForSave.isNotEmpty){
            for(var each in savedDocsList){
              bool isDuple = false;
              for(var eachDuple in addedDupleDocsListForSave){
                if(each["id"] == eachDuple["id"]){
                  isDuple = true;
                }
              }
              if(!isDuple){
                addedDocsListForSave.add(each);
              }
            }
          }else{
            addedDocsListForSave.addAll(savedDocsList);
          }

          for(var each in addedDocsListForSave){
            Map<String, dynamic> resultMap = each["result"];
            CommonUtils.log("", "docs cache save!!! ===============================>\n"
                "view_id:${each["view_id"]}\n"
                "id:${each["id"]}\n"
                "name:${each["name"]}\n"
                "is_confirmed:${each["is_confirmed"]}\n"
                "is_docs:${each["is_docs"]}\n"
                "docs_type:${each["docs_type"]}\n"
                "result:${resultMap.isEmpty? "" : each["result"]["resultValue"]}\n"
            );
          }

          SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceApplyPrKey, jsonEncode(addedDocsListForSave));
          setState(() {
            currentViewId = _getViewIdFromListById(confirmedId);
          });
        }else{
          CommonUtils.flutterToast("접수에 실패했습니다.\n다시 시도해주세요.");
        }
      });
    }else{
      UiUtils.showLoadingPop(context);
      if(await CommonUtils.isFileExists(pickedFilePath)){
        _uploadCertImageToAwsServer(pickedFilePath, (isSuccessToUpload){
          if(isSuccessToUpload){
            List<dynamic> docResultList = [];
            Map<String, dynamic> eachMap = {
              "pr_document_id" : "12",
              "response_data" : awsUploadUrl
            };
            docResultList.add(eachMap);
            for(var each in addedDocsList){
              if(each["is_docs"] && each["is_confirmed"]){
                var resultMap  =  each["result"]["resultValue"]["data"];
                //gov24 : 1:주민등록등본           2:주민등록초본        15:지방세납세증명서
                //nhis  : 3:건강보험자격득실확인서    4:건강보험납부확인서
                //nts   : 6:사업자등록증(*테스트불가) 10:소득금액증명       11:부가세과세표준증명원(*테스트불가)      14:국세납세증명서
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
            String address = _getResultFromListById(addressId)["resultValue"];
            Map<String, dynamic> applyInputMap = {
              "offer_id": MyData.selectedPrInfoData!.productOfferId,
              "offer_rid": MyData.selectedPrInfoData!.productOfferRid,
              "lender_pr_id": MyData.selectedPrInfoData!.productOfferLenderPrId,
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
              if(isSuccess){
                LogfinController.getLoanInfo((isSuccessToGetLoanInfo, isNotEmpty){
                  if(isSuccessToGetLoanInfo){
                    if(isNotEmpty){
                      List<Map<String, dynamic>> addedDocsListForSave = [];
                      List<Map<String, dynamic>> addedDupleDocsListForSave = [];
                      for(var eachAdded in addedDocsList){
                        if(eachAdded["is_confirmed"] && eachAdded["id"] != 1000 && eachAdded["id"] != 999){
                          for(var each in savedDocsList){
                            if(each["id"] == eachAdded["id"]){
                              addedDupleDocsListForSave.add(eachAdded);
                            }
                          }
                        }
                      }
                      for(var eachAdded in addedDocsList){
                        if(eachAdded["is_confirmed"] && eachAdded["id"] != 1000 && eachAdded["id"] != 999){
                          addedDocsListForSave.add(eachAdded);
                        }
                      }
                      if(addedDupleDocsListForSave.isNotEmpty){
                        for(var each in savedDocsList){
                          bool isDuple = false;
                          for(var eachDuple in addedDupleDocsListForSave){
                            if(each["id"] == eachDuple["id"]){
                              isDuple = true;
                            }
                          }
                          if(!isDuple){
                            addedDocsListForSave.add(each);
                          }
                        }
                      }else{
                        addedDocsListForSave.addAll(savedDocsList);
                      }

                      for(var each in addedDocsListForSave){
                        Map<String, dynamic> resultMap = each["result"];
                        CommonUtils.log("", "apply cache save!!! ===============================>\n"
                            "view_id:${each["view_id"]}\n"
                            "id:${each["id"]}\n"
                            "name:${each["name"]}\n"
                            "is_confirmed:${each["is_confirmed"]}\n"
                            "is_docs:${each["is_docs"]}\n"
                            "docs_type:${each["docs_type"]}\n"
                            "result:${resultMap.isEmpty? "" : each["result"]["resultValue"]}\n"
                        );
                      }

                      SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceApplyPrKey, jsonEncode(addedDocsListForSave));
                      UiUtils.closeLoadingPop(context);
                      setState(() {
                        currentViewId = _getViewIdFromListById(confirmedId);
                      });
                    }else{
                      UiUtils.closeLoadingPop(context);
                      CommonUtils.flutterToast("접수에 실패했습니다.\n다시 시도해주세요.");
                    }
                  }else{
                    UiUtils.closeLoadingPop(context);
                    CommonUtils.flutterToast("접수에 실패했습니다.\n다시 시도해주세요.");
                  }
                });
              }else{
                UiUtils.closeLoadingPop(context);
                CommonUtils.flutterToast("접수에 실패했습니다.\n다시 시도해주세요.");
              }
            });
          }else{
            UiUtils.closeLoadingPop(context);
            CommonUtils.flutterToast("접수에 실패했습니다.\n다시 시도해주세요.");
          }
        });
      }else{
        if(context.mounted) {
          UiUtils.closeLoadingPop(context);
          CommonUtils.flutterToast("신분증정보가 만료되었습니다.\n다시 시도해주세요.");
          await _setValidImg();
          setState(() {});
        }
      }
    }
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
            if(isRetry){
              Navigator.pop(context);
            }else{
              CommonUtils.moveWithUntil(context, AppView.appMainView.value);
            }
          })
    ]);
  }

  void _back(){
    CommonUtils.hideKeyBoard();
    if(currentViewId == addedDocsInfoIntroViewId){
      Navigator.pop(context);
    }else{
      if(_getIdFromListByViewId(currentViewId) != lastId){
        backInputView();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? view;
    if(currentViewId == addedDocsInfoIntroViewId){
      view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getIntroView());
    }else {
      if(_getIdFromListByViewId(currentViewId) == mainBankId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: Obx(()=>_getBankCodeView()));
      }else if(_getIdFromListByViewId(currentViewId) == mainBankAccountId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getBankAccountView());
      }else if(_getIdFromListByViewId(currentViewId) == businessNumberId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getBusinessNumberView());
      }else if(_getIdFromListByViewId(currentViewId) == addressId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getAddressView());
      }else if(_getIdFromListByViewId(currentViewId) == cameraId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getCameraForIdCheckView());
      }else if(_getIdFromListByViewId(currentViewId) == 1 || _getIdFromListByViewId(currentViewId) == 2 || _getIdFromListByViewId(currentViewId) == 15){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getGov24View());
      }else if(_getIdFromListByViewId(currentViewId) == 3 || _getIdFromListByViewId(currentViewId) == 4){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getNhisView());
      }else if(_getIdFromListByViewId(currentViewId) == 6 || _getIdFromListByViewId(currentViewId) == 10 || _getIdFromListByViewId(currentViewId) == 11 || _getIdFromListByViewId(currentViewId) == 14){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getNtsView());
      }else if(_getIdFromListByViewId(currentViewId) == lastId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getFinishConfirmView());
      }else if(_getIdFromListByViewId(currentViewId) == confirmedId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhite, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: _getConfirmedView());
      }else if(currentViewId == cameraTakePhotoId){
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinBlack, padding: EdgeInsets.zero, child: _takeCustomCamera());
      }else{
        view = Container(height: 100.h, width: 100.w, color: ColorStyles.upFinWhiteSky);
      }
    }

    return UiUtils.getViewWithAllowBackForAndroid(context, view, _back);
  }

}