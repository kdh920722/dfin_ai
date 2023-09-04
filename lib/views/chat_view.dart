import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutterwebchat/controllers/aws_controller.dart';
import 'package:flutterwebchat/controllers/clova_controller.dart';
import 'package:flutterwebchat/controllers/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutterwebchat/controllers/iamport_controller.dart';
import 'package:flutterwebchat/controllers/logfin_controller.dart';
import 'package:flutterwebchat/controllers/sharedpreference_controller.dart';
import 'package:flutterwebchat/datas/api_info_data.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutterwebchat/controllers/gpt_controller.dart';
import 'package:flutterwebchat/controllers/firebase_controller.dart';
import 'package:flutterwebchat/styles/ColorStyles.dart';
import 'package:uni_links/uni_links.dart';
import '../controllers/codef_controller.dart';
import '../observers/keyboard_observer.dart';
import '../styles/TextStyles.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'dart:io';

class ChatView extends StatefulWidget{
  @override
  ChatViewState createState() => ChatViewState();
}

class ChatViewState extends State<ChatView> with WidgetsBindingObserver{
  List<Map<String, String>> messages = [];
  List<Messages> messagesHistory = [];
  final messageListViewController = ScrollController();
  final inputTextController = TextEditingController();
  String currentWord = '';
  String currentText = '';
  final String firstId = "FIRST";
  final String thisId = "ME";
  final String aiId = "GPT";
  final String aiResultId = "GPT_RESULT";

  /// keyboard check for Web Platform
  final FocusNode _focusNode = FocusNode();
  bool isKeyboardVisible = false;

  /// only work on Native Platform(Android/IOS)
  KeyboardVisibilityController? _keyboardVisibilityController;
  void _functionForKeyboardHide(){
    currentScreenHeight = screenHeight;
    inputHeight = inputMinHeight;
  }
  void _functionForKeyboardShow(){
    currentScreenHeight = screenHeight*0.55;
    _scrollToBottom();
  }

  final ScrollController viewScrollController = ScrollController();
  KeyboardVisibilityController? _keyboardVisibilityController2;
  void _functionForKeyboardHide2(){
    FocusManager.instance.primaryFocus?.unfocus();
    viewScrollController.jumpTo(0);
  }

  Future<void> _initFirebase() async {
    // init
    await FireBaseController.initFcm((bool isSuccess, String fcmToken){
      if(isSuccess){
        CommonUtils.log("i", "firebase credential : ${FireBaseController.userCredential.toString()}");
      }else{
        CommonUtils.flutterToast("firebase init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initGPT() async {
    // init
    await GptController.initGPT((bool isSuccess){
      if(isSuccess){
        CommonUtils.log("i", "gpt key : ${GptController.gptApiKey}");
      }else{
        CommonUtils.flutterToast("gpt init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initCodeF() async {
    // set host : prod or dev
    CodeFController.setHostStatus(HostStatus.prod);

    // init
    await CodeFController.initAccessToken((bool isSuccess){
      if(isSuccess){
        CommonUtils.log("i", "codef token : ${CodeFController.token}");
      }else{
        CommonUtils.flutterToast("codef init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initCLOVA() async {
    // init
    await CLOVAController.initCLOVA((bool isSuccess){
      if(isSuccess){
        CommonUtils.log("i", "clova url : ${CLOVAController.apiURL}\nclova secretKey : ${CLOVAController.secretKey}");
      }else{
        CommonUtils.flutterToast("clova init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initAWS() async {
    // init
    await AwsController.initAWS((bool isSuccess){
      if(isSuccess){
        CommonUtils.log("i", "aws keys : ${AwsController.awsAccessKey}\naws secretKey : ${AwsController.awsSecretKey}");
      }else{
        CommonUtils.flutterToast("aws init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initLogfin() async {
    // init
    await LogfinController.initLogfin((bool isSuccess){
      if(isSuccess){
        CommonUtils.log("i", "logfin url : ${LogfinController.url}\naws headerKey : ${LogfinController.headerKey}");
      }else{
        CommonUtils.flutterToast("logfin init 에러가 발생했습니다.");
      }
    });
  }

  Future<String?> _initDeepLink() async {
    try{
      final initialLink = await getInitialLink();
      return initialLink;
    }catch(e){
      CommonUtils.log("e", "init deep link error : ${e.toString()}");
      return null;
    }
  }

  Future<String?> _initIamport() async {
    // init
    await IamportController.initIamport((bool isSuccess){
      if(isSuccess){
        CommonUtils.log("i", "iamport user_code : ${IamportController.iamportUserCode}");
      }else{
        CommonUtils.flutterToast("iamport init 에러가 발생했습니다.");
      }
    });
  }

  Future<String?> _initSharedPreference() async {
    // init
    await SharedPreferenceController.initSharedPreference((bool isSuccess){
      if(!isSuccess){
        CommonUtils.flutterToast("sharedPreference init 에러가 발생했습니다.");
      }
    });
  }

  void _initUiValue(){
    currentScreenHeight = screenHeight;
    switchBarHeight = currentScreenHeight*0.05;
    _scrollToBottom();
  }

  Future<void> _initAtFirst() async {
    Config.isAppMainInit = true;
    Get.put(GetController());
    await _initSharedPreference();
    await _initFirebase();
    await _initGPT();
    await _initCodeF();
    await _initCLOVA();
    await _initAWS();
    await _initLogfin();
    await _initIamport();
    await _initDeepLink().then((value){
      if(value != null){
        Config.deppLinkInfo = value;
        String paramValue = CommonUtils.getValueFromDeepLink(Config.deppLinkInfo, "param1");
        CommonUtils.log("i", "init deep link paramValue : $paramValue");
      }else{
        Config.deppLinkInfo = "XXX";
      }
    });
    await _requestPermissions();
    Config.isControllerLoadFinished = true;
    setState(() {});
  }

  @override
  void initState(){
    CommonUtils.log("i", "새 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _focusNode.addListener(_onFocusChange);
    _keyboardObserver.addListener(_onKeyboardHeightChanged);

    // only work for mobile platform
    //_keyboardVisibilityController= CommonUtils.getKeyboardViewController(_functionForKeyboardShow, _functionForKeyboardHide);
    messagesHistory.add(Messages(
        role: Role.system,
        content: GptController.systemInput
    ));

    messagesHistory.add(Messages(
        role: Role.user,
        content: "안녕하세요, 저는 자동차담보대출 상품을 추천받고 싶습니다."
    ));
    messagesHistory.add(Messages(
        role: Role.assistant,
        content: "안녕하세요! 고객님.\n저는 AI 상담사 입니다.\n[1]?"
    ));
    messages.add({
      'id': firstId,
      'text': "AI 상담사",
    });
    messages.add({
      'id': aiId,
      'text': GptController.convertGptAnswerToSystemAnswer("안녕하세요! 고객님.\n저는 AI 상담사 입니다.\n[1]?"),
    });
  }

  @override
  void dispose(){
    CommonUtils.log("i", "새 화면 파괴");
    messages.clear();
    inputTextController.dispose();
    _focusNode.removeListener(_onFocusChange);
    messageListViewController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _keyboardObserver.removeListener();
    _keyboardVisibilityController = null;
    messagesHistory.clear();
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

  Widget _getChatBox(Map<String, String> message){
    String messageId = message['id']!;
    String messageText = message['text']!;
    Color boxColor = ColorStyles.finAppWhite;
    double fontSize = 18.sp;
    MainAxisAlignment boxAlignType = MainAxisAlignment.start;
    Color chatTextColor = ColorStyles.finAppGreen;
    BorderRadiusDirectional borderType = const BorderRadiusDirectional.only(topEnd: Radius.circular(15), bottomEnd: Radius.circular(15), bottomStart: Radius.circular(15));
    if (messageId == firstId) {
      chatTextColor = ColorStyles.darkGray;
      boxColor = Colors.transparent;
      borderType = const BorderRadiusDirectional.all(Radius.circular(30));
      fontSize = 20.sp;

      return Container(padding: const EdgeInsets.only(bottom: 20),
          child : Column(children: [
            UiUtils.getTextWithFixedScale(messageText, TextStyle(color: chatTextColor, fontSize: fontSize, fontWeight: FontWeight.bold), TextAlign.center, null),
            //UiUtils.getTextWithFixedScale("대출 신청을 위한 고객님의 정보를 자유롭게 말씀 해 주세요.", TextStyle(color: ColorStyles.finAppWhite, fontSize: fontSize*0.4, fontWeight: FontWeight.normal), TextAlign.center, null)
            UiUtils.getTextWithFixedScale(Config.deppLinkInfo, TextStyle(color: ColorStyles.finAppWhite, fontSize: fontSize*0.4, fontWeight: FontWeight.normal), TextAlign.center, null)
          ])
      );
    }else{
      fontSize = 18.sp*0.55;
      if(messageId == thisId){
        boxAlignType = MainAxisAlignment.end;
        chatTextColor = ColorStyles.darkGray;
        borderType = const BorderRadiusDirectional.only(topStart: Radius.circular(15), bottomEnd: Radius.circular(15), bottomStart: Radius.circular(15));
      }else if(messageId == aiId){
        boxColor = Colors.amberAccent;
        chatTextColor = Colors.black;
      }else{
        // aiResultId
        boxColor = Colors.green;
        chatTextColor = ColorStyles.finAppWhite;
      }

      return Container(padding: const EdgeInsets.only(bottom: 10),
          child : Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: boxAlignType,
              children: [
                Card(
                    color: boxColor,
                    shape: RoundedRectangleBorder(borderRadius: borderType),
                    elevation: 20,
                    shadowColor: Colors.grey,
                    child: Container(padding: const EdgeInsets.all(15),
                        constraints: BoxConstraints(maxWidth: 80.w),
                        child: UiUtils.getSelectableTextWithFixedScale(messageText, TextStyle(color: chatTextColor, fontSize: fontSize), null, null)
                    )
                )
              ])
      );
    }
  }

  Future<void> _sendMessage(String message) async {
    String d1 = CommonUtils.convertTimeToString(CommonUtils.getCurrentLocalTime());
    String d2 = "20230825150101";
    int result = d1.compareTo(d2);
    if(result == -1){
      SharedPreferenceController.saveSharedPreference("testKey", "123412431aa");
    }else{
      SharedPreferenceController.getSharedPreferenceValue("testKey");
    }

    String randomKey = CommonUtils.getRandomKey().toString();
    Map<String, dynamic> inputJson1 = {
      "organization": "0001",
      "loginType": "6",
      "identity": "9207221199215",
      "timeout": "120",
      "addrSido": "경기도",
      "addrSiGunGu": "안양시",
      "id": randomKey,
      "userName": "김동환",
      "loginTypeLevel": "1",
      "phoneNo": "01054041099",
      "personalInfoChangeYN": "0",
      "pastAddrChangeYN": "0",
      "nameRelationYN": "1",
      "militaryServiceYN": "0",
      "overseasKoreansIDYN": "0",
      "isIdentityViewYn": "0",
      "originDataYN": "0",
      "telecom": ""
    };

    Map<String, dynamic> inputJson2 = {
      "organization": "0001",
      "loginType": "6",
      "identity": "9207221199215",
      "timeout": "120",
      "addrSido": "경기도",
      "addrSiGunGu": "안양시",
      "id": randomKey,
      "userName": "김동환",
      "loginTypeLevel": "1",
      "phoneNo": "01054041099",
      "pastAddrChangeYN": "0",
      "inmateYN": "0",
      "relationWithHHYN": "1",
      "changeDateYN": "0",
      "compositionReasonYN": "0",
      "isIdentityViewYn": "1",
      "isNameViewYn": "1",
      "originDataYN": "0",
      "telecom": ""
    };

    List<ApiInfoData> apiInfoDataList = [];
    apiInfoDataList.add(ApiInfoData(0, inputJson1, Apis.residentRegistrationAbstract, true));
    apiInfoDataList.add(ApiInfoData(1, inputJson2, Apis.residentRegistrationCopy, true));
    UiUtils.showLoadingPop(context);
    CodeFController.callApisWithCert(context, setState, apiInfoDataList, (isSuccess, resultApiInfoDataList) {
      CommonUtils.log("i", "CALL FINISHED");
      UiUtils.closeLoadingPop(context);
      if(isSuccess){
        for(var each in resultApiInfoDataList!){
          CommonUtils.log("i", each.resultMap.toString());
        }
      }
    });


    /*
    _getResidentRegistrationAbstract2();
    await Future.delayed(const Duration(milliseconds: 500), () async {
      _getResidentRegistrationCopy2();
    });
    */


    /*
    Map<String, dynamic> inputJson = {
      "organization": "0001",
      "court_name": "부산회생법원",
      "caseNumberYear": "2021",
      "caseNumberType": "개회",
      "caseNumberNumber": "105645",
      "userName": "양미정",
      "timeout": "",
      "bankCode": "",
      "account": "",
      "userName1": ""
    };

    await CodeFController.getDataFromApi(Apis.bankruptApi2, inputJson, (bool isSuccess, map, listMap){
      if(isSuccess){
        if(map != null){
          CommonUtils.log('i', 'out : is map');
        }else if(listMap != null){
          CommonUtils.log('i', 'out : is list map (size):${listMap.length}');
          for(Map<String, dynamic> each in listMap){
            String name = each['resDebtor'];
            String num = each['resCaseNumber'];
            if(name == "양미정"){
              CommonUtils.log('i', 'out $name ### $num');
            }
          }
        }
      }else{
        CommonUtils.flutterToast("에러가 발생했습니다.");
      }
    });

     */


    /*
    message = CommonUtils.deleteLastEnter(message);
    messages.add({
      'id': thisId,
      'text': message,
    });
    messages.add({
      'id': aiId,
      'text': "....",
    });
    setState(() {});

    CommonUtils.hideKeyBoard(context);
    UiUtils.showLoadingPop(context);
    messagesHistory.add(Messages(role: Role.user, content: message));
    await Future.delayed(const Duration(milliseconds: 1100), () async {
      String receivedMessage = await GptController.sendAndReceiveTextToGPTUsingLib(messagesHistory);
      await _receiveMessage(receivedMessage);

      if(context.mounted){
        UiUtils.closeLoadingPop(context);
        setState(() {});
      }
    });
    */

    /*
    CommonUtils.hideKeyBoard(context);
    UiUtils.showLoadingPop(context);
    await _callCarRegistration1();
    if(context.mounted){
      UiUtils.closeLoadingPop(context);
    }
    */
  }

  Future<void> _receiveMessage(String message) async{

    String messageForHistory = GptController.deleteUnnecessaryGptAnswer(message);
    if(messageForHistory.contains(GptController.deletedResultSplitPattern)){
      List<String> messageForHistoryList = messageForHistory.split(GptController.deletedResultSplitPattern);
      messagesHistory.add(
          Messages(
              role: Role.assistant,
              content: messageForHistoryList[1])
      );
    }

    String convertedMessage = GptController.convertGptAnswerToSystemAnswer(message);
    if(convertedMessage.contains(GptController.carNumResultSplitPattern)){
      List<String> result = convertedMessage.split(GptController.carNumResultSplitPattern);
      print(result[0]);

      // get price from api
      String price = "6,000 만원";
      messagesHistory.add(
          Messages(
              role: Role.user,
              content: "차량 시세 금액은 $price 입니다.")
      );

      await Future.delayed(const Duration(milliseconds: 1100), () async {
        String receivedMessage = await GptController.sendAndReceiveTextToGPTUsingLib(messagesHistory);
        await _receiveMessage(receivedMessage);
      });
    }else if(convertedMessage.contains(GptController.houseAddressResultSplitPattern)){
      List<String> result = convertedMessage.split(GptController.houseAddressResultSplitPattern);
      print(result[0]);

      // get price from api
      String price = "2억 3,500 만원";
      messagesHistory.add(
          Messages(
              role: Role.user,
              content: "주탹의 시세 금액은 $price 입니다.")
      );

      await Future.delayed(const Duration(milliseconds: 1100), () async {
        String receivedMessage = await GptController.sendAndReceiveTextToGPTUsingLib(messagesHistory);
        await _receiveMessage(receivedMessage);
      });
    }else if(convertedMessage.contains(GptController.resultSplitPattern)){
      List<String> resultMessages = convertedMessage.split(GptController.resultSplitPattern);
      messages.last['text'] = resultMessages[0];
      messages.add({
        'id': aiResultId,
        'text': resultMessages[1],
      });
      messages.add({
        'id': aiId,
        'text': resultMessages[2],
      });
    }else{
      messages.last['text'] = convertedMessage;
    }
  }

  void _scrollToBottom(){
    if(messageListViewController.positions.isNotEmpty){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        messageListViewController.jumpTo(messageListViewController.position.maxScrollExtent);
      });
    }
  }

  double inputMinHeight = 10.h;
  double inputHeight = 5.h;
  double inputMaxHeight = 30.h;
  double screenHeight = 100.h;
  double screenHeightWhenKeyboardUp = 0;
  double currentScreenHeight = 0;
  double keyboardHeight = 0;
  double switchBarHeight = 0;
  bool isWebMobile = false;

  String pickedFilePath = "";

  final KeyboardObserver _keyboardObserver = KeyboardObserver();
  void _onKeyboardHeightChanged() {
    //keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
  }

  void _onFocusChange() {
    if(_focusNode.hasFocus){
      switchBarHeight = 0;
      if(isWebMobile){
        _functionForKeyboardShow();
      }
    }else{
      switchBarHeight = screenHeight*0.05;
      _functionForKeyboardHide();
    }
    inputMaxHeight = currentScreenHeight*0.3;
    setState(() {});
  }
  
  Future<void> _requestPermissions() async {
    await CommonUtils.requestPermissions((isDenied, deniedPermissionsList){
      if(isDenied){
        String deniedPermissionsString = "";
        for(int i = 0; i < deniedPermissionsList!.length; i++){
          deniedPermissionsString += deniedPermissionsList[i];
          if(i != deniedPermissionsList.length-1){
            deniedPermissionsString += ", ";
          }
        }

        UiUtils.showSlideMenu(context, SlideType.toTop, true, 0.5, (context, setState) =>
            Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UiUtils.getTextWithFixedScale("[$deniedPermissionsString] 권한이 필요합니다. ", TextStyles.slidePopPermissionText, TextAlign.center, null),
                  UiUtils.getMarginBox(100.w, 2.h),
                  UiUtils.getTextButtonBox(70.w, "설정 바로가기", TextStyles.slidePopButtonText, ColorStyles.finAppGreen, () {
                    openAppSettings();
                    Navigator.of(context).pop();
                  })
                ]
            ));
        CommonUtils.log("i", "denied permissions : $deniedPermissionsString");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? view;
    if(!Config.isAppMainInit){
      _initAtFirst();
      view = UiUtils.getInitView();
    }else{
      if(!Config.isControllerLoadFinished){
        view = UiUtils.getInitView();
      }else{
        _initUiValue();
        view = AnimatedContainer(duration: const Duration(milliseconds: 100), width: 100.w, height: currentScreenHeight, color: ColorStyles.finAppWhite, child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /*
          AnimatedContainer(height: switchBarHeight, duration: const Duration(milliseconds: 100),
              child: Row(mainAxisAlignment : MainAxisAlignment.center, children: [
                UiUtils.getTextWithFixedScale("WEB", TextStyles.basicTextStyle, null, null),
                UiUtils.getMarginBox(2.w, 0),
                CupertinoSwitch(
                  activeColor: ColorStyles.finAppGreen,
                  value: isWebMobile,
                  onChanged: (value) {
                    setState(() {isWebMobile = value;});
                  },
                ),
                UiUtils.getMarginBox(2.w, 0),
                UiUtils.getTextWithFixedScale("MOBILE WEB", TextStyles.basicTextStyle, null, null)
              ])
          ),
          */

              SizedBox(height: 30.h,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 100.w,
                      maxHeight: 30.h,
                    ),
                    child: pickedFilePath != "" ? Image.file(File(pickedFilePath)) : Container(),
                  )
              ),

              /// 채팅 메인 화면
              Expanded(
                  child: Container(
                      constraints: BoxConstraints(maxHeight: currentScreenHeight*0.9),
                      color: ColorStyles.finAppGreen, padding : const EdgeInsets.all(10),
                      child: messages.isEmpty? Container() : ListView.builder(
                          controller: messageListViewController,
                          scrollDirection: Axis.vertical,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return _getChatBox(messages[index]);
                          })
                  )
              ),

              /// 채팅 상하 여백
              UiUtils.getMarginBox(0, screenHeight*0.01),

              /// 채팅 글 입력 칸
              AnimatedContainer(
                duration: const Duration(milliseconds: 400), // Optional: Add a duration for smooth animation
                width: 95.w,
                color: ColorStyles.finAppWhite,
                height: inputHeight,
                constraints: BoxConstraints(
                  minHeight: inputMinHeight,
                  maxHeight: inputMaxHeight,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 70.w,
                      child: TextField(
                        focusNode: _focusNode,
                        maxLines: null,
                        style: TextStyles.subTitleTextStyle,
                        controller: inputTextController,
                        textAlign: TextAlign.start,
                        cursorColor: Colors.grey,
                        onChanged: (text) {
                          currentWord = CommonUtils.getLastWord(text);
                          currentText += currentWord;
                          if(currentWord == " " || currentWord == "\n" || currentWord == "." || currentWord == ","){

                            print(currentText);
                            final textLinePainterForWidth = TextPainter(
                              text: TextSpan(text: currentText, style: TextStyles.subTitleTextStyle),
                              maxLines: null,
                              textDirection: TextDirection.ltr,
                            )..layout(minWidth: 0, maxWidth: 85.w);

                            if(textLinePainterForWidth.width >= 70.w){
                              print("${textLinePainterForWidth.width}");
                              currentText = "";

                              final textPainterForHeight = TextPainter(
                                text: TextSpan(text: text, style: TextStyles.subTitleTextStyle),
                                maxLines: null,
                                textDirection: TextDirection.ltr,
                              )..layout(minWidth: 0, maxWidth: 85.w);
                              final desiredHeight = inputMinHeight*0.3 + textPainterForHeight.height;
                              final height = desiredHeight.clamp(inputMinHeight, inputMaxHeight);
                              setState(() {
                                inputHeight = height;
                              });
                            }
                          }
                        },
                        decoration: UiUtils.getInputDecorationWithNoErrorMessage("입력"),
                      ),
                    ),
                    UiUtils.getMarginBox(3.w, 0),
                    UiUtils.getIconButtonBox(
                      20.w,
                      Icons.send,
                      ColorStyles.finAppGreen, () async {
                      if (inputTextController.text.trim() != "") {
                        /*
                      String message = inputTextController.text;
                      inputTextController.text = "";
                      currentText = "";
                      inputHeight = inputMinHeight;
                      _sendMessage(message);
                      */
                      }else if(inputTextController.text.trim() == ""){
                        //_sendMessage("");
                        Map<String, String> inputJson = {
                          "url" : "www.google.com",
                        };
                        CommonUtils.moveTo(context, AppView.webView.value, inputJson);
                        /*
                      Map<String, String> inputJson = {
                        "carrier": "",
                        "name" : "김동환",
                        "phone" : "01054041099"
                      };
                      CommonUtils.moveTo(context, AppView.certificationView.value, inputJson);
                      */

                        /*
                      XFile? image = await CommonUtils.getGalleryImage();
                      if(image != null){
                        String imagePath = await CommonUtils.cropImageAndGetPath(image);
                        if(imagePath == ""){
                          // pass image crop
                          imagePath = image.path;
                        }

                        await CLOVAController.uploadImageToCLOVA(imagePath, (isSuccess, map) async {
                          if(isSuccess){
                            CommonUtils.log('i', map.toString());
                            String path = await CommonUtils.makeMaskingImageAndGetPath(imagePath, map!);
                            if(path != ""){
                              await AwsController.uploadImageToAWS(path, (isSuccessToSave, resultUrl) async {
                                if(isSuccessToSave){
                                  setState(() {
                                    pickedFilePath = path;
                                  });
                                }else{
                                  // failed to aws s3 save
                                }
                              });
                            }else{
                              // failed to masking
                            }
                          }else{
                            // failed to check clova ocr
                          }
                        });
                      }
                      */

                        //_sendMessage("");
                        //inputTextController.text = "";
                        //currentText = "";
                      }
                    },
                    ),
                  ],
                ),
              ),

              /// 채팅 상하 여백
              UiUtils.getMarginBox(0, screenHeight*0.01),
            ])
        );
      }
    }

    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}