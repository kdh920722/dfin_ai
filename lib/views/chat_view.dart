import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutterwebchat/controllers/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutterwebchat/controllers/gpt_controller.dart';
import 'package:flutterwebchat/controllers/firebase_controller.dart';
import 'package:flutterwebchat/styles/ColorStyles.dart';
import '../controllers/codef_controller.dart';
import '../observers/keyboard_observer.dart';
import '../styles/TextStyles.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class ChatView extends StatefulWidget{
  @override
  ChatViewState createState() => ChatViewState();
}

class ChatViewState extends State<ChatView> with WidgetsBindingObserver{
  List<Map<String, String>> messages = [];
  List<Messages> messagesHistory = [];
  final messageListViewController = ScrollController();
  final inputTextController = TextEditingController();
  final String firstId = "FIRST";
  final String thisId = "ME";
  final String aiId = "GPT";

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
    scrollToBottom();
  }

  final ScrollController viewScrollController = ScrollController();
  KeyboardVisibilityController? _keyboardVisibilityController2;
  void _functionForKeyboardHide2(){
    FocusManager.instance.primaryFocus?.unfocus();
    viewScrollController.jumpTo(0);
  }

  Future<void> _initFirebase() async {
    // init
    await FireBaseController.initFirebase((bool isSuccess){
      if(isSuccess){
        CommonUtils.log("i", "firebase credential : ${FireBaseController.userCredential.toString()}");
      }else{
        CommonUtils.flutterToast("firebase init 에러가 발생했습니다.");
      }
    });
  }

  Future<void> _initGPT() async {
    // init
    await GptController.getGPTApiKey((bool isSuccess){
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

  void _initUiValue(){
    currentScreenHeight = screenHeight;
    switchBarHeight = currentScreenHeight*0.05;
  }

  Future<void> _init(BuildContext context) async {
    Config.isAppMainInit = true;
    Get.put(GetController());
    await _initFirebase();
    await _initGPT();
    await _initCodeF();
    _initUiValue();
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
        content: "assistant는 '대출 상담자' 역할이고, user는 '대출 상담을 받는 고객' 역할 입니다.\nassistant는 user에게 항상 '고객님'이라는 호칭을 사용하며, 친절하고 상냥하게 대합니다.\nassistant는 user에게 말할 때 항상 보기 편하게 문장을 표현해야 합니다. 예를들어 문장이 바뀔 때 마다 줄바꿈을 해야하고, 공백 줄바꿈을 통해 문장, 문단 단락을 구분해야 합니다.\nuser가 assistant에게 대출과 관련없는 질문을 한다면, assistant는 user에게 대출 관련 질문을 해달라고 요청해야 합니다.\nuser가 assistant에게 나쁜 말을 하거나 비속어를 사용한다면, assistant는 user에게 비속어를 사용하지 말아달라고 요청해야 합니다.\n\nassistant는 user로부터 아래 5가지 필수정보를 반드시 얻어야 합니다.(필요한 정보를 모두 얻기 위해서 assistant는 user에게 질문해야 합니다.)\n1.user의 '생년월일' 정보\n2.user의 '직업' 정보\n3.user의 '신용' 정보\n4.user의 '대출목적' 정보\n5.user의 '신용점수' 정보(0이상, 1000이하 숫자)\n\n이 5가지 정보들 중 2번,3번,4번은 각각 타입들을 갖고 있습니다. assistant는 user에게 얻은 정보로 부터 해당 정보가 어떤 타입에 해당 하는지 구분 해야 합니다.\n'직업'정보의 타입 6가지\n1.개인사업자\n2.직장인\n3.프리랜서\n4.주부\n5.무직자\n6.법인대표\n\n'신용'정보의 타입 4가지\n1.정상(연체된 대출이 없을 때)\n2.연체(연체된 대출이 있을 떄)\n3.회생 또는 회복 또는 파산이 3회 미만\n4.회생 또는 회복 또는 파산이 3회 이상\n\n'대출목적'정보의 타입 5가지\n1.주택구입\n2.생활자금\n3.대환대출\n4.세입자 보증금 반환\n5.사업자금\n\nassistant가 user에게 받은 정보들 중 5가지 필수정보에 속하지 않는 정보를 얻게 된다면, assistant는 이런 정보들을 '기타정보'로 분류하여 기억합니다.\nassistant가 user에게 받은 정보들 중에 5가지 필수정보 중 1번 또는 5번 정보를 얻지 못했다면, assistant는 user에게 아래 '예시)'와 '예시 끝)'사이의 문장처럼 질문해야 합니다.\n예시)\n고객님의 '생년월일'정보가 필요합니다. 알려주시겠어요?\n예시 끝)\nassistant가 user에게 받은 정보들 중에 5가지 필수정보 중 2번,3번,4번 정보를 얻지 못했다면 assistant는 user에게 아래 '예시)'와 '예시 끝)'사이의 문장처럼 질문해야 합니다.\n예시)\n고객님의 '대출목적'정보가 필요합니다.\n1.주택구입\n2.생활자금\n3.대환대출\n4.세입자 보증금 반환\n이 중에 어떤것인지 알려주시겠어요?\n예시 끝)\nassistant가 user로부터 5가지 정보를 모두 얻었다면, 얻은 정보를 아래 '예시)'와 '예시 끝)'사이의 문장처럼 그 결과를 user에게 알려줘야 합니다.\n예시)\n고객님의 정보를 정리 해 보았습니다.\n고객님의 '생년월일'은 92년 7월 22일 입니다.\n고객님의 '직업'은 '직장인'으로 구분 됩니다.(IT회사 컴퓨터 프로그래머)\n고객님의 '신용'은 '정상'상태 입니다.\n고객님은 '주택구입'을 위한 대출을 희망하고 계십니다.\n고객님의 '신용점수'는 980점 입니다.\n*비고(assistant가 user로부터 얻은 정보들 중 '기타정보'가 있을 때 표시) : 고객님은 여자친구가 있고, 성격은 게으릅니다.\n\n이 정보가 맞는지 확인 해 주세요.\n예시 끝)\nassistant가 user에게 알려준 결과에 대해 user가 문제를 제기하거나 수정을 요청하면, 수정 될 내용을 user에게 질문한 다음 그 정보를 얻어서 수정 된 결과 내용을 user에게 다시 알려줘. user가 만족할 때 까지.\n"
    ));
    messages.add({
      'id': firstId,
      'text': "AI 상담사",
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
      fontSize = 26.sp;

      return Container(padding: const EdgeInsets.only(bottom: 20),
          child : Column(children: [
            UiUtils.getTextWithFixedScale(messageText, TextStyle(color: chatTextColor, fontSize: fontSize, fontWeight: FontWeight.bold), TextAlign.center, null),
            UiUtils.getTextWithFixedScale("대출 신청을 위한 고객님의 정보를 자유롭게 말씀 해 주세요.", TextStyle(color: ColorStyles.finAppWhite, fontSize: fontSize*0.4, fontWeight: FontWeight.normal), TextAlign.center, null)
          ])
      );
    }else{
      if(messageId == thisId){
        boxAlignType = MainAxisAlignment.end;
        chatTextColor = ColorStyles.darkGray;
        borderType = const BorderRadiusDirectional.only(topStart: Radius.circular(15), bottomEnd: Radius.circular(15), bottomStart: Radius.circular(15));
      }else{
        boxColor = Colors.amberAccent;
        chatTextColor = Colors.black;
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
    messages.add({
      'id': thisId,
      'text': message,
    });
    setState(() {});

    CommonUtils.hideKeyBoard(context);
    UiUtils.showLoadingPop(context);
    messagesHistory.add(Messages(role: Role.user, content: message));
    String receivedMessage = await GptController.sendAndReceiveTextToGPTUsingLib(messagesHistory);
    if(context.mounted){
      _receiveMessage(receivedMessage);
      UiUtils.closeLoadingPop(context);
    }

  }

  void _receiveMessage(String message){
    messages.add({
      'id': aiId,
      'text': message,
    });
    setState(() {});

    messagesHistory.add(Messages(role: Role.assistant, content: message));
  }

  void scrollToBottom(){
    if(messageListViewController.positions.isNotEmpty){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        messageListViewController.jumpTo(messageListViewController.position.maxScrollExtent);
      });
    }
  }

  double inputMinHeight = 10.h;
  double inputHeight = 10.h;
  double inputMaxHeight = 30.h;
  double screenHeight = 100.h;
  double screenHeightWhenKeyboardUp = 0;
  double currentScreenHeight = 0;
  double keyboardHeight = 0;
  double switchBarHeight = 0;
  bool isWebMobile = false;

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

  @override
  Widget build(BuildContext context) {
    if(!Config.isAppMainInit){
      _init(context);
    }

    scrollToBottom();

    Widget view =
    AnimatedContainer(duration: const Duration(milliseconds: 100), width: 100.w, height: currentScreenHeight, color: ColorStyles.finAppWhite, child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
          UiUtils.getMarginBox(0, currentScreenHeight*0.01),

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
                      // Calculate the desired height based on the text content
                      final textHeight = TextPainter(
                        text: TextSpan(text: text, style: TextStyles.subTitleTextStyle),
                        maxLines: null,
                        textDirection: TextDirection.ltr,
                      )..layout(minWidth: 0, maxWidth: 85.w);
                      final desiredHeight = inputMinHeight + textHeight.height;
                      // Limit the height to the maxHeight constraint
                      final height = desiredHeight.clamp(inputMinHeight, inputMaxHeight);
                      // Update the container height
                      setState(() {
                        inputHeight = height;
                      });
                    },
                    decoration: UiUtils.getInputDecorationWithNoErrorMessage("입력"),
                  ),
                ),
                UiUtils.getMarginBox(3.w, 0),
                UiUtils.getIconButtonBox(
                  20.w,
                  Icons.send,
                  "",
                  ColorStyles.finAppGreen,
                      () {
                    if (inputTextController.text.trim() != "") {
                      String message = inputTextController.text;
                      inputTextController.text = "";
                      inputHeight = inputMinHeight;
                      _sendMessage(message);

                    }
                  },
                ),
              ],
            ),
          ),

          /// 채팅 상하 여백
          UiUtils.getMarginBox(0, currentScreenHeight*0.01),
        ])
    );

    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}