import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/controllers/aws_controller.dart';
import 'package:upfin/controllers/firebase_controller.dart';
import 'package:upfin/controllers/get_controller.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/controllers/websocket_controller.dart';
import 'package:upfin/datas/chat_message_info_data.dart';
import 'package:upfin/datas/loan_info_data.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:upfin/styles/TextStyles.dart';
import 'package:upfin/views/app_main_view.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class AppChatView extends StatefulWidget{
  @override
  AppChatViewState createState() => AppChatViewState();
}

class AppChatViewState extends State<AppChatView> with WidgetsBindingObserver{
  bool backPossibleFlag = true;
  final ScrollController _chatScrollController = ScrollController();
  final _chatTextFocus = FocusNode();
  final _chatTextController = TextEditingController();
  static String currentRoomId = "";
  String currentLoanUid = "";
  String currentCompany = "";
  String currentCompanyLogo = "";
  String currentStatus = "";
  bool isBuild = false;
  bool isTextFieldFocus = false;
  bool inputTextHide = true;
  static bool isViewHere = false;

  final ReceivePort _port = ReceivePort();
  static String savedFileName = "";

  @override
  void initState(){
    CommonUtils.log("i", "AppChatViewState 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    currentRoomId = GetController.to.chatMessageInfoDataList[0].chatRoomId;
    for(var each in MyData.getLoanInfoList()){
      if(each.chatRoomId == currentRoomId){
        currentLoanUid = each.loanUid;
        currentCompany = each.companyName;
        currentCompanyLogo = each.companyLogo;
        currentStatus = each.statueId;
        if(LoanInfoData.getStatusName(currentStatus) == "접수"){
          GetController.to.updateChatStatusTick(1);
        }else if(LoanInfoData.getStatusName(currentStatus) == "심사"){
          GetController.to.updateChatStatusTick(2);
        }else if(LoanInfoData.getStatusName(currentStatus) == "통보"){
          GetController.to.updateChatStatusTick(3);
        }
      }
    }
    Config.contextForEmergencyBack = context;
    Config.isEmergencyRoot = false;
    _keyboardVisibilityController = CommonUtils.getKeyboardViewController(_functionForKeyboardShow, _functionForKeyboardHide);
    FireBaseController.setStateForForeground = null;
    isViewHere = true;
    _setAutoAnswerWidgetList();
    GetController.to.updateInputTextHide(true);
    GetController.to.updateShowPickedFile(false);
    GetController.to.updateShowStatus(true);
    currentKey = "";

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) async {
      try{
        String id = data[0];
        int status = data[1];
        int progress = data[2];
        if(status == 3 && progress == 100){
          await FlutterDownloader.open(taskId: id);
          if(context.mounted) UiUtils.closeLoadingPop(context);
        }
      }catch(error){
        CommonUtils.log("e", "port.listen error : $error");
        UiUtils.closeLoadingPop(context);
      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }


  @pragma('vm:entry-point')
  static Future<void> downloadCallback(String id, int status, int progress) async {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }


  KeyboardVisibilityController? _keyboardVisibilityController;
  void _functionForKeyboardHide(){
    _scrollToBottom(true,400);
  }
  void _functionForKeyboardShow() {
    _scrollToBottom(true,400);
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppChatViewState 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _chatScrollController.dispose();
    _chatTextFocus.dispose();
    _chatTextController.dispose();
    currentRoomId = "";
    Config.contextForEmergencyBack = null;
    _keyboardVisibilityController = null;
    AppMainViewState.isStart = false;
    isViewHere = false;
    widgetList.clear();
    GetController.to.resetChatAutoAnswerWidgetList();
    GetController.to.updateInputTextHide(true);
    GetController.to.updateShowPickedFile(false);
    GetController.to.updateShowStatus(true);
    currentKey = "";
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('i','AppChatViewState resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('i','AppChatViewState inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('i','AppChatViewState detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('i','AppChatViewState paused');
        break;
      default:
        break;
    }
  }
  
  Widget _getHtmlView(String message, String sender, String type){
    bool isImage = true;
    String htmlTag = "";
    String htmlTextTag = "";
    String extension = "";
    String buttonId = "";
    String fileName = "";
    if(sender == "UPFIN") {
      htmlTextTag = "<div id='typeOther'>";
      buttonId = "buttonTypeOther";
    }else{
      htmlTextTag = "<div id='typeMe'>";
      buttonId = "buttonTypeMe";
    }

    if(type == "file"){
      List<String> fileInfo = message.split('.');
      extension = fileInfo.last.toLowerCase();
      fileName = fileInfo[fileInfo.length-2].split("/").last;
      List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp'];
      if (imageExtensions.contains(extension.toLowerCase())) {
        isImage = true;
      } else {
        isImage = false;
      }

      if(isImage){
        htmlTag = """
        <a href='$message'><img src='$message'/></a>
        """;
      }else{
        htmlTag = """
        <center>
        <p>$fileName</p>
     
        <a href='$message'><button id='$buttonId'>${extension.toUpperCase()} 열기</button></a>
        </center>
        """;
      }
    }else{
      List<String> tempMsg = message.split("다.");
      message = "";
      for(int i = 0 ; i < tempMsg.length ; i++){
        if(i != tempMsg.length-1){
          tempMsg[i] +="다.<br>";
          if(i != tempMsg.length-2) {
            if(tempMsg[i].length > 20) tempMsg[i] += "<br>";
          }
        }

        if(tempMsg[i].contains("요!")){
          String temp = tempMsg[i].split("요!")[0] +="요!<br>${tempMsg[i].split("요!")[1]}";
          tempMsg[i] = temp;
        }

        if(tempMsg[i].contains("요.")){
          String temp = tempMsg[i].split("요.")[0] +="요.<br>${tempMsg[i].split("요.")[1]}";
          tempMsg[i] = temp;
        }

        if(tempMsg[i].contains("요?")){
          String temp = tempMsg[i].split("요?")[0] +="요?<br>${tempMsg[i].split("요?")[1]}";
          tempMsg[i] = temp;
        }

        message += tempMsg[i];
      }
      htmlTag = message;
      isImage = false;
    }

    String htmlString = "$htmlTextTag $htmlTag </div>";
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      HtmlWidget(
        htmlString,
        onLoadingBuilder: (context, element, progress){
            CommonUtils.log("", "html : $progress");
            _scrollToBottom(true,100);
        },
        customStylesBuilder: (element) {
          if(element.id == 'typeMe') {
            return {
              "color" : "white",
              "font-size": "15px",
              "line-height" : "120%",
              "font-weight": "normal",
            };
          }else if(element.id == 'typeOther') {
            return {
              "color" : "black",
              "font-size": "15px",
              "line-height" : "120%",
              "font-weight": "normal",
            };
          }

          if (element.localName == 'button') {
            if(element.id == 'buttonTypeOther') {
              return {
                "text-align":"center",
                "background-color":"#3a6cff",
                "color" : "white",
                "font-size": "15px",
                "line-height" : "250%",
                "font-weight": "normal",
                "border-radius":"0.1em",
                "padding":"5px 20px"
              };
            }else if(element.id == 'buttonTypeMe'){
              return {
                "text-align":"center",
                "background-color":"white",
                "color" : "#3a6cff",
                "font-size": "15px",
                "line-height" : "250%",
                "font-weight": "normal",
                "border-radius":"0.1em",
                "padding":"5px 20px",
                "width": "500px",
              };
            }
          }
        },

        onTapUrl: (url) async {
          String dir = "";
          if(Config.isAndroid){
            dir = '/storage/emulated/0/Download';
            CommonUtils.log("", "document dir : ${(await getApplicationDocumentsDirectory()).path}");
          }else{
            dir = (await getApplicationDocumentsDirectory()).path;
            CommonUtils.log("", "document dir : ${(await getApplicationDocumentsDirectory()).path}");
          }
          try{
            await FlutterDownloader.enqueue(
              url: url, 	// file url
              savedDir: '$dir/',	// 저장할 dir
              fileName: '${CommonUtils.convertTimeToString(CommonUtils.getCurrentLocalTime())}_doc.$extension',	// 파일명
              saveInPublicStorage: true ,	// 동일한 파일 있을 경우 덮어쓰기 없으면 오류발생함!
              showNotification: true,
              openFileFromNotification: true,
            );
            String fileRealName = "${CommonUtils.convertTimeToString(CommonUtils.getCurrentLocalTime())}_doc.$extension";
            String fileName = "$dir/$fileRealName";
            savedFileName = fileName;

            if(context.mounted) UiUtils.showLoadingPop(context);
            if(!isImage){
              CommonUtils.flutterToast("문서를 다운로드합니다.");
            }

          }catch(e){
            CommonUtils.log("", "fail download");
          }

          return true;
        },
        renderMode: RenderMode.column,
        textStyle: TextStyles.upFinHtmlTextStyle,
      )
    ]);
  }

  Widget _getOtherView(ChatMessageInfoData otherInfo){
    return Container(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.w, bottom: 2.w),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              CustomPaint(
                painter: ChatBubbleTriangleForOther(),
              ),
              Container(
                  constraints: BoxConstraints(maxWidth: 70.w),
                  padding: EdgeInsets.all(3.w),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                    color: ColorStyles.upFinWhiteGray,
                  ),
                  child: _getHtmlView(otherInfo.message, "UPFIN", otherInfo.messageType)
              ),
              UiUtils.getMarginBox(1.w, 0),
              UiUtils.getTextWithFixedScale(CommonUtils.getFormattedLastMsgTime(otherInfo.messageTime), 8.sp, FontWeight.w400, ColorStyles.upFinDarkGray, TextAlign.start, null)
            ]),
            UiUtils.getMarginBox(0, 1.h)
          ]),
        ])
    );
  }

  Widget _getOtherForLoadingView(){
    return Container(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.w, bottom: 2.w),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              CustomPaint(
                painter: ChatBubbleTriangleForOther(),
              ),
              Container(
                  constraints: BoxConstraints(maxWidth: 70.w),
                  padding: EdgeInsets.all(3.w),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                    color: ColorStyles.upFinWhiteGray,
                  ),
                  child: UiUtils.getImage(5.w, 5.w, Image.asset(fit: BoxFit.fill,'assets/images/chat_loading.gif'))
              ),
            ]),
            UiUtils.getMarginBox(0, 1.h)
          ]),
        ])
    );
  }

  Widget _getMeView(ChatMessageInfoData meInfo){
    Widget? meInfoWidget;
    if(meInfo.messageType == "text"){
      meInfoWidget = UiUtils.getTextWithFixedScale(meInfo.message, 12.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null);
    }else{
      meInfoWidget = _getHtmlView(meInfo.message, "ME", meInfo.messageType);
    }

    return Container(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.w, bottom: 2.w),
        width: 100.w,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            UiUtils.getTextWithFixedScale(CommonUtils.getFormattedLastMsgTime(meInfo.messageTime), 8.sp, FontWeight.w400, ColorStyles.upFinDarkGray, TextAlign.start, null),
            UiUtils.getMarginBox(1.w, 0),
            Container(
                constraints: BoxConstraints(maxWidth: 70.w),
                padding: EdgeInsets.all(3.w),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                  color: ColorStyles.upFinTextAndBorderBlue,
                ),
                child: meInfoWidget
            ),
            CustomPaint(
              painter: ChatBubbleTriangleForMe(),
            ),
          ]),
        ])
    );
  }

  Widget _getMeViewForLoading(){
    return Container(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.w, bottom: 2.w),
        width: 100.w,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
                constraints: BoxConstraints(maxWidth: 70.w),
                padding: EdgeInsets.all(3.w),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                  color: ColorStyles.upFinTextAndBorderBlue
                ),
                child: UiUtils.getImage(5.w, 5.w, Image.asset(fit: BoxFit.fill,'assets/images/chat_loading.gif'))
            ),
            CustomPaint(
              painter: ChatBubbleTriangleForMe(),
            )
          ]),
        ])
    );
  }

  List<Widget> _getChatList(){
    List<Widget> chatList = [];
    CommonUtils.log("i", "re draw chat messages");
    for(var each in GetController.to.chatMessageInfoDataList){
      if(each.senderName == "UPFIN"){
        chatList.add(_getOtherView(each));
      }else{
        chatList.add(_getMeView(each));
      }
    }

    if(WebSocketController.isWaitingForAnswerState(currentRoomId, "ME")){
      chatList.add(_getMeViewForLoading());
    }

    if(WebSocketController.isWaitingForAnswerState(currentRoomId, "UPFIN")){
      chatList.add(_getOtherForLoadingView());
    }

    _scrollToBottom(true,400);
    return chatList;
  }

  Future<void> _back() async {
    if(backPossibleFlag){
      backPossibleFlag = false;
      var inputJson = {
        "pr_room_id" : currentRoomId
      };
      UiUtils.showLoadingPop(context);
      await CommonUtils.saveSettingsToFile("push_from", "");
      await CommonUtils.saveSettingsToFile("push_room_id", "");
      CommonUtils.log("", "delete file");
      await LogfinController.callLogfinApi(LogfinApis.checkMessage, inputJson, (isSuccess, outputJson){
        backPossibleFlag =true;
        if(isSuccess){

        }else{
          CommonUtils.flutterToast("메시지를 읽는중\n오류가 발생했습니다.");
        }
      });

      if(context.mounted) {
        isViewHere = false;
        _chatTextFocus.unfocus();
        CommonUtils.hideKeyBoard();
        UiUtils.closeLoadingPop(context);
        Navigator.pop(context);
      }
    }
  }

  Future<void> _scrollToBottom(bool doDelay, int delayTime) async {
    if(isBuild){
      if(doDelay){
        await Future.delayed(Duration(milliseconds: delayTime), () async {});
      }

      if(_chatScrollController.hasClients){
        _chatScrollController.jumpTo(_chatScrollController.position.maxScrollExtent);
      }
    }
  }

  Widget _getTimelineWidget(){
    return Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GetController.to.chatStatusTick.value>0?_stepTick(0, true):_stepTick(0, false),
        GetController.to.chatStatusTick.value>1? _stepLine(true) : _stepLine(false),
        GetController.to.chatStatusTick.value>1?_stepTick(1, true):_stepTick(1, false),
        GetController.to.chatStatusTick.value>2? _stepLine(true) : _stepLine(false),
        GetController.to.chatStatusTick.value>2?_stepTick(2, true):_stepTick(2, false)
      ],
    );
  }
  Widget _stepTick(int type, bool isChecked){
    String typeString = "";
    bool passed = false;
    if(type == 0){
      typeString = "접수";
      if(GetController.to.chatStatusTick.value > 1){
        passed = true;
      }
    }else if(type == 1){
      typeString = "심사";
      if(GetController.to.chatStatusTick.value > 2){
        passed = true;
      }
    }else{
      typeString = "통보";
    }

    return Column(children: [
      isChecked? passed? UiUtils.getIcon(3.w, 3.w, Icons.radio_button_checked_rounded, 3.w, ColorStyles.upFinButtonBlue)
          : UiUtils.getIcon(3.w, 3.w, Icons.circle, 3.w, ColorStyles.upFinButtonBlue)
            : UiUtils.getIcon(3.w, 3.w, Icons.radio_button_unchecked_rounded, 3.w, ColorStyles.upFinWhiteSky),
      UiUtils.getMarginBox(0, 1.5.h),
      UiUtils.getTextWithFixedScale(typeString, 9.sp, FontWeight.w600, ColorStyles.upFinRealGray, TextAlign.center, null),
    ]);
  }

  Widget _stepTick1() {
    return GetController.to.chatStatusTick.value>0?_stepTick(0, true):_stepTick(0, false);
  }
  Widget _stepTick2() {
    return GetController.to.chatStatusTick.value>1?_stepTick(1, true):_stepTick(1, false);
  }
  Widget _stepTick3() {
    return GetController.to.chatStatusTick.value>2?_stepTick(2, true):_stepTick(2, false);
  }

  Widget _stepLine(bool isReached) {
    return Column(children: [
      UiUtils.getMarginBox(0, 0.5.h),
      Container(
        color: isReached? ColorStyles.upFinButtonBlue : ColorStyles.upFinWhiteSky,
        height: 0.15.h,
        width: 36.w,
      )
    ]);
  }

  Future<void> _setPickedImgFromCamera() async {
    if(pickedFiles.length <= maximumSize){
      if(pickedFiles.length == maximumSize){
        CommonUtils.flutterToast("최대 $maximumSize개의 파일만\n전송할 수 있습니다.");
      }else{
        XFile? image = await CommonUtils.getCameraImage();
        if(image != null){
          isShowPickedFile = true;
          GetController.to.updateShowPickedFile(isShowPickedFile);
          inputHelpHeight = inputHelpPickedFileHeight;
          GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
          pickedFiles.add(File(image.path));
        }else{
          if(pickedFiles.isEmpty){
            isShowPickedFile = false;
            GetController.to.updateShowPickedFile(isShowPickedFile);
            inputHelpHeight = inputHelpMinHeight;
            GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
          }else{
            isShowPickedFile = true;
            GetController.to.updateShowPickedFile(isShowPickedFile);
            inputHelpHeight = inputHelpPickedFileHeight;
            GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
          }
        }
        setState(() {});
      }
    }else{
      CommonUtils.flutterToast("최대 $maximumSize개의 파일만\n전송할 수 있습니다.");
    }
  }

  Future<void> _setPickedFileFromDevice() async {
    if(pickedFiles.length <= maximumSize){
      if(pickedFiles.length == maximumSize){
        CommonUtils.flutterToast("최대 $maximumSize개의 파일만\n전송할 수 있습니다.");
      }else{
        List<File>? files = await CommonUtils.getFiles();
        if(files != null){
          if(files.length <= maximumSize){
            if(files.length+pickedFiles.length <= maximumSize){
              isShowPickedFile = true;
              GetController.to.updateShowPickedFile(isShowPickedFile);
              inputHelpHeight = inputHelpPickedFileHeight;
              GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
              for(var each in files){
                pickedFiles.add(each);
              }
            }else{
              CommonUtils.flutterToast("최대 $maximumSize개의 파일만\n전송할 수 있습니다.");
            }
          }else{
            CommonUtils.flutterToast("최대 $maximumSize개의 파일만\n전송할 수 있습니다.");
          }
        }else{
          if(pickedFiles.isEmpty){
            isShowPickedFile = false;
            GetController.to.updateShowPickedFile(isShowPickedFile);
            inputHelpHeight = inputHelpMinHeight;
            GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
          }else{
            isShowPickedFile = true;
            GetController.to.updateShowPickedFile(isShowPickedFile);
            inputHelpHeight = inputHelpPickedFileHeight;
            GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
          }
        }
        setState(() {});
      }
    }else{
      CommonUtils.flutterToast("최대 $maximumSize개의 파일만\n전송할 수 있습니다.");
    }
  }

  String currentKey = "";
  Map<String, dynamic> test3 = {
    "대출관리" :
    {
      "대출상품" : "a1",
      "제출정보" : "a2",
      "상환일정" : "a3",
      "취소,철회" : "a4"
    },

    "심사결과" :
    {
      "대출현황": "b1",
      "요청서류": "b2"
    },
    "나의정보" :
    {
      "사건정보": "c1",
    },
    "자주하는 질문" :
    {
      "대출상환":
      {
        "수수료" : "d11",
        "일정" : "d12",
        "이자율" : "d13",
        "미납" : "d14",
        "연장" : "d15",
        "추가대출" : "d16",
        "상환액" : "d17",
      },
      "신용점수": "d2",
      "금융사기": "d3"
    },
    "상담원 연결": "e"
  };
  String _findValueForKey(Map<String, dynamic> map, String targetKey) {
    String resultValue = "";

    void searchValue(Map<String, dynamic> currentMap, String currentKey) {
      if (currentMap.containsKey(currentKey)) {
        resultValue = currentMap[currentKey];
        return;
      }

      currentMap.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          searchValue(value, targetKey);
        }
      });
    }

    searchValue(map, targetKey);
    return resultValue;
  }
  List<String> _getAnswerListMap(String targetKey){
    List<String> childKeys = [];
    if(targetKey == ""){
      LogfinController.autoAnswerMap.forEach((key, value) {
        childKeys.add(key);
      });
      return childKeys;
    }else{
      void searchChildKeys(Map<String, dynamic> currentMap) {
        currentMap.forEach((key, value) {
          if (key == targetKey && value is Map<String, dynamic>) {
            childKeys.addAll(value.keys);
          }
          if (value is Map<String, dynamic>) {
            searchChildKeys(value);
          }
        });
      }

      searchChildKeys(LogfinController.autoAnswerMap);

      return childKeys;
    }
  }
  String _findPrevKey(String targetKey) {
    String parentKey = "";

    void searchParentKey(Map<String, dynamic> currentMap, String currentParent) {
      if (currentMap.containsKey(targetKey)) {
        parentKey = currentParent;
      }else{
        currentMap.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            searchParentKey(value, key);
          }
        });
      }
    }

    searchParentKey(LogfinController.autoAnswerMap, "");
    CommonUtils.log("", "parentKey : $parentKey");
    return parentKey;
  }

  int _getLineFromAutoAnswerWidgetList(List<Widget> listWidget){
    int cnt = 1;
    for(int i = 0 ; i < listWidget.length ; i++){
      if(listWidget[i].key != null){
        cnt++;
      }
    }

    return cnt;
  }
  List<Widget> widgetList = [];
  void _setAutoAnswerWidgetList(){
    widgetList.clear();
    GetController.to.resetChatAutoAnswerWidgetList();
    //List<String> answerList = ["자주하는 질문 💬", "나의정보 🔒", "대출현황 🏦", "심사결과 📑", "상담원 연결 🤓", "사진 📷", "가져오기 📤"];
    List<String> answerList = _getAnswerListMap(currentKey);
    CommonUtils.log("", "answerList : ${answerList.length}");
    if(currentKey == ""){
      answerList.add("사진");
      answerList.add("가져오기");
      answerList.add("AI 채팅");
    }else{
      answerList.add("이전");
    }
    for(var each in answerList){
      Color borderColor = ColorStyles.upFinGray;
      Color fillColor = ColorStyles.upFinWhite;
      Color textColor = ColorStyles.upFinBlack;
      if(each.contains("이전")){
        borderColor = ColorStyles.upFinKakaoYellow;
        fillColor = ColorStyles.upFinKakaoYellow;
        textColor = ColorStyles.upFinBlack;
      }else if(each.contains("채팅")){
        borderColor = ColorStyles.upFinButtonBlue;
        fillColor = ColorStyles.upFinButtonBlue;
        textColor = ColorStyles.upFinWhite;
      }else if(each.contains("사진")){
        borderColor = ColorStyles.upFinBlack;
        fillColor = ColorStyles.upFinBlack;
        textColor = ColorStyles.upFinWhite;
      }else if(each.contains("가져오기")){
        borderColor = ColorStyles.upFinBlack;
        fillColor = ColorStyles.upFinBlack;
        textColor = ColorStyles.upFinWhite;
      }

      if(each.contains("자주하는 질문")){
        widgetList.add(Container(key: UniqueKey()));
      }

      if(each.contains("상환일정")){
        widgetList.add(Container(key: UniqueKey()));
      }

      if(each.contains("미납")){
        widgetList.add(Container(key: UniqueKey()));
      }

      if(each.contains("사진")){
        widgetList.add(Container(key: UniqueKey()));
      }

      if(each.contains("이전")){
        if(answerList.length != 1){
          widgetList.add(Container(key: UniqueKey()));
        }
      }

      widgetList.add(
          GestureDetector(
              child: UiUtils.getRoundedBoxTextWithFixedScale(each, 11.sp, FontWeight.w500, TextAlign.center, borderColor, fillColor, textColor),
      onTap: () async {
        currentKey = each;
        if(each.contains("사진")){
          _setPickedImgFromCamera();
        }else if(each.contains("가져오기")){
          _setPickedFileFromDevice();
        }else if(each.contains("채팅")){
          inputTextHide = false;
          GetController.to.updateInputTextHide(inputTextHide);
          _setAutoAnswerWidgetList();
        }else if(each.contains("이전")){
          inputTextHide = true;
          GetController.to.updateInputTextHide(inputTextHide);
          String tempKey = _findPrevKey(answerList[0]);
          currentKey = _findPrevKey(tempKey);
          _setAutoAnswerWidgetList();
          setState(() {});
        }else{
          if(_getAnswerListMap(each).isNotEmpty){
            _setAutoAnswerWidgetList();
            setState(() {});
          }else{
            String result = _findValueForKey(LogfinController.autoAnswerMap, currentKey);
            _sendMessage(currentKey, result);
          }
        }
      }));
    }

    _setAutoAnswerLineHeight();
    GetController.to.updateChatAutoAnswerWidgetList(widgetList);
    CommonUtils.log("", "updateChatAutoAnswerWidgetList : ${GetController.to.autoAnswerWidgetList.length}");
  }

  static Future<bool> checkFileExists(String filePath) async {
    File file = File(filePath);
    return await file.exists();
  }

  void _setAutoAnswerLineHeight(){
    if(_getLineFromAutoAnswerWidgetList(widgetList) == 1){
      inputHelpHeight = 6.h;
      GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
    }else if(_getLineFromAutoAnswerWidgetList(widgetList) == 2){
      inputHelpHeight = 12.h;
      GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
    }else{
      inputHelpHeight = 17.5.h;
      GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
    }
  }

  void _sendFileToAws(){
    int cnt = 0;
    int failCnt = 0;
    UiUtils.showLoadingPop(context);
    for(var each in pickedFiles){
      AwsController.uploadFileToAWS(each.path, "${MyData.email}/${CommonUtils.convertTimeToString(CommonUtils.getCurrentLocalTime())}", (isSuccess, resultUrl){
        cnt++;
        if(!isSuccess){
          failCnt++;
        }
        if(cnt == pickedFiles.length){
          if(failCnt > 0){
            CommonUtils.flutterToast("파일 전송중 에러가\n발생했습니다.");
          }else{
            _sendMessage(resultUrl,"");
            pickedFiles.clear();
            inputHelpHeight = inputHelpMinHeight;
            GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
            isShowPickedFile = false;
            GetController.to.updateShowPickedFile(isShowPickedFile);
            UiUtils.closeLoadingPop(context);
            setState(() {});
          }
        }
      });
    }
  }

  void _sendMessage(String message, String customMessageType){
    CommonUtils.hideKeyBoard();
    if(!WebSocketController.isWaitingForAnswerState(currentRoomId, "ME")){
      var inputJson = {
        "loan_uid" : currentLoanUid,
        "message" : message
      };

      WebSocketController.setWaitingState(currentRoomId, "ME", true);
      if(pickedFiles.isEmpty){
        // message, custom message
        if(customMessageType != ""){
          inputJson["type"] = "custom";
        }else{
          inputJson["type"] = "text";
        }
        WebSocketController.setWaitingState(currentRoomId, "UPFIN", true);
      }else{
        // file
        inputJson["type"] = "file";
      }

      LogfinController.callLogfinApi(LogfinApis.sendMessage, inputJson, (isSuccess, _){
        if(!isSuccess){
          CommonUtils.flutterToast("메시지 전송중\n오류가 발생했습니다.");
        }
        WebSocketController.setWaitingState(currentRoomId, "ME", false);
        WebSocketController.setWaitingState(currentRoomId, "UPFIN", false);
      });
    }else{
      CommonUtils.flutterToast("응답을 기다리는 중입니다.");
    }
  }

  bool isShowPickedFile = false;
  List<File> pickedFiles = [];
  int maximumSize = 1;
  Widget _getPickedFilesWidget(){
    List<Widget> widgetList = [];
    for(int i = 0 ; i < pickedFiles.length ; i++){
      bool isImage = true;
      CommonUtils.log("","picked file : ${pickedFiles[i].path}");
      String extension = pickedFiles[i].path.split('.').last.toLowerCase();
      List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp'];
      if (imageExtensions.contains(extension)) {
        isImage = true;
      } else {
        isImage = false;
      }

      String fileName = pickedFiles[i].uri.pathSegments.last; // 파일명 + 확장자
      String basename = pickedFiles[i].uri.pathSegments.last.split('.').first; // 파일명\
      widgetList.add(
          Stack(alignment:Alignment.bottomLeft, children: [
            Container(width: 22.5.w, height: 17.h,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: ColorStyles.upFinWhite
                )),
            Positioned(
                left: 1.w,
                bottom: 1.w,
                child: Container(
                  width: 20.w,
                  height: 16.h,
                  padding: EdgeInsets.zero,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      color: ColorStyles.upFinBlack
                  ),
                  child: isImage? Padding(padding: EdgeInsets.only(left: 1.w, right: 1.w, top: 2.w, bottom: 2.w), child: Image.file(File(pickedFiles[i].path),fit: BoxFit.fitWidth))
                      : Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                        UiUtils.getMarginBox(0, 1.5.h),
                        //UiUtils.getTextWithFixedScaleAndOverFlow(extension.toUpperCase(), 10.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null),
                        UiUtils.getMarginBox(0, 0.5.h),
                        UiUtils.getIcon(19.5.w, 5.5.h, Icons.folder_copy_outlined, 5.5.h, ColorStyles.upFinWhite),
                        UiUtils.getMarginBox(0, 1.h),
                        UiUtils.getTextWithFixedScale(fileName, 9.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null)
                  ]),
                )),
            Positioned(top: 0.1.h, right: -3.3.w, child: UiUtils.getIconButtonWithHeight(2.h, Icons.cancel_rounded, 2.h, ColorStyles.upFinWhiteSky, () {
              pickedFiles.removeAt(i);
              if(pickedFiles.isEmpty){
                inputHelpHeight = inputHelpMinHeight;
                GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
                isShowPickedFile = false;
                GetController.to.updateShowPickedFile(isShowPickedFile);
              }else{
                inputHelpHeight = inputHelpPickedFileHeight;
                GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
                isShowPickedFile = true;
                GetController.to.updateShowPickedFile(isShowPickedFile);
              }
              setState(() {});
            }))
          ])
      );
    }

    if(widgetList.isEmpty){
      return Container();
    }else{
      return Row(children: widgetList);
    }
  }

  double inputMinHeight = 9.2.h;
  double inputHeight = 9.2.h;
  double inputMaxHeight = 20.h;
  double inputHelpMinHeight = 17.5.h;
  double inputHelpPickedFileHeight = 45.h;
  double inputHelpHeight = 17.5.h;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(isViewHere){
        isBuild = true;
        _scrollToBottom(false, 0);
      }
    });

    Widget view =
    Container(
        color: ColorStyles.upFinWhite,
        width: 100.w,
        height: 100.h,
        child: Column(children: [
          UiUtils.getMarginBox(0, 0.5.h),
          Stack(children: [
            Positioned(
              top: 1.h,
              left: 5.w,
              child: UiUtils.getBackButton(() {
                _back();
              }),
            ),
            Positioned(
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    UiUtils.getMarginBox(0, 2.5.h),
                    UiUtils.getTextWithFixedScale(currentCompany, 16.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.center, 1),
                    UiUtils.getMarginBox(0, 1.h),
                    Obx((){
                      String statusName = LoanInfoData.getDetailStatusName(GetController.to.chatStatusTick.value.toString());
                      return UiUtils.getTextWithFixedScale(statusName, 12.sp, FontWeight.w600, ColorStyles.upFinTextAndBorderBlue, TextAlign.center, null);
                    })
                  ])
              ),
            ),
            Positioned(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Obx((){
                    return Padding(padding: EdgeInsets.only(right: 3.w), child: Column(children: [
                      UiUtils.getMarginBox(0, 1.8.h),
                      UiUtils.getIconButtonWithHeight(8.w, GetController.to.isShowStatus.value? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, 8.w, ColorStyles.upFinDarkGray, () {
                            GetController.to.updateShowStatus(!GetController.to.isShowStatus.value);
                          })
                    ]));
                  })
              ),
            ),
          ]),
          Obx((){
            if(GetController.to.isShowStatus.value){
              return Column(children:[
                UiUtils.getMarginBox(0, 3.h),
                Obx(()=>_getTimelineWidget())
              ]);
            }else{
              return Container();
            }
          }),
          UiUtils.getMarginBox(0, 1.h),
          UiUtils.getExpandedScrollViewWithController(Axis.vertical, Obx(()=>Column(mainAxisAlignment: MainAxisAlignment.start, children: _getChatList())), _chatScrollController),
          UiUtils.getMarginBox(0, 1.h),
          Obx((){
            return SizedBox(width: 100.w, height: GetController.to.chatAutoAnswerHeight.value, child: Column(children: [
              Align(alignment: Alignment.topRight, child: Padding(padding: EdgeInsets.only(right: 5.w),
                  child: Wrap(runSpacing: 0.4.h, spacing: 1.5.w, alignment: WrapAlignment.end, direction: Axis.horizontal, children: GetController.to.autoAnswerWidgetList))),
              GetController.to.isShowPickedFile.value? Column(children: [
                UiUtils.getSizedScrollView(90.w, inputHelpMinHeight+2.h, Axis.horizontal, _getPickedFilesWidget()),
                UiUtils.getMarginBox(0, 1.3.h),
                UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                    UiUtils.getTextWithFixedScale("전송", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null), () async{
                      _sendFileToAws();
                    }),
              ]) : Container()
            ]));
          }),
          UiUtils.getMarginBox(0, 0.8.h),
          Obx((){
            return GetController.to.isInputTextHide.value? Container() : AnimatedContainer(
                duration: const Duration(milliseconds:200),
                width: 100.w,
                height: inputHeight,
                constraints: BoxConstraints(
                  minHeight: inputMinHeight,
                  maxHeight: inputMaxHeight,
                ),
                color: ColorStyles.upFinWhite,
                child: Padding(padding: EdgeInsets.only(left: 3.w,right: 3.w,bottom: 2.w,top: 0.5.w), child:
                Container(
                    decoration: BoxDecoration(
                      color: ColorStyles.upFinGray, // 배경색 설정
                      borderRadius: BorderRadius.circular(20.0), // 모서리를 둥글게 하는 부분
                    ),
                    padding: EdgeInsets.all(0.35.w),
                    child: Container(
                        decoration: BoxDecoration(
                          color: ColorStyles.upFinWhite, // 배경색 설정
                          borderRadius: BorderRadius.circular(18.0), // 모서리를 둥글게 하는 부분
                        ),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                          UiUtils.getMarginBox(1.5.w, 0),
                          Expanded(flex: 75, child: Column(children: [UiUtils.getExpandedScrollView(Axis.vertical,
                              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                UiUtils.getMarginBox(0, 0.7.h),
                                UiUtils.getChatTextField(70.w, TextStyles.upFinTextFormFieldTextStyle, _chatTextFocus, _chatTextController, TextInputType.multiline,
                                    UiUtils.getChatInputDecoration(), (textValue) {
                                      if(textValue != ""){
                                        isTextFieldFocus = true;
                                        final textLinePainter = TextPainter(
                                          text: TextSpan(text: textValue, style: TextStyles.upFinTextFormFieldTextStyle),
                                          maxLines: null,
                                          textDirection: TextDirection.ltr,
                                        )..layout(minWidth: 0, maxWidth: 67.w);

                                        if(inputHeight <= inputMaxHeight){
                                          final desiredHeight = inputMinHeight*0.7+textLinePainter.height;
                                          final height = desiredHeight.clamp(inputMinHeight, inputMaxHeight);
                                          setState(() {
                                            inputHeight = height;
                                          });
                                        }
                                      }else{
                                        setState(() {
                                          isTextFieldFocus = false;
                                          inputHeight = inputMinHeight;
                                        });
                                      }
                                    })
                              ]))])),
                          Expanded(flex: 1, child: Container(color: ColorStyles.upFinWhite)),
                          Expanded(flex: 15, child:
                          UiUtils.getIconButtonWithHeight(14.w, Icons.arrow_circle_up_rounded, 14.w,
                              isTextFieldFocus? ColorStyles.upFinButtonBlue : ColorStyles.upFinWhiteSky, () {
                                if(_chatTextController.text.toString().trim() != ""){
                                  _sendMessage(_chatTextController.text, "");
                                  setState(() {
                                    _chatTextController.text = "";
                                    isTextFieldFocus = false;
                                  });
                                }else{
                                  CommonUtils.flutterToast("메시지를 입력하세요.");
                                }
                              })
                          ),
                        ]))))
            );
          })
        ])
    );
    return UiUtils.getViewWithAllowBackForAndroid(context, view, _back);

  }

}

class ChatBubbleTriangleForOther extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = ColorStyles.upFinWhiteGray;

    var path = Path();
    path.lineTo(0, -2.w);
    path.lineTo(-1.2.w, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ChatBubbleTriangleForMe extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = ColorStyles.upFinTextAndBorderBlue;

    var path = Path();
    path.lineTo(0, -2.w);
    path.lineTo(1.2.w, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}