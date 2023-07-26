import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwebchat/controllers/api_controller.dart';
import 'package:flutterwebchat/controllers/firebase_controller.dart';
import 'package:flutterwebchat/styles/ColorStyles.dart';
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
  bool isInit = false;

  KeyboardVisibilityController? _keyboardVisibilityController;
  void _functionForKeyboardHide(){
    FocusManager.instance.primaryFocus?.unfocus();
  }
  void _functionForKeyboardShow(){
    Future.delayed(const Duration(milliseconds: 300), () {
      scrollToBottom();
    });
  }

  final ScrollController viewScrollController = ScrollController();
  KeyboardVisibilityController? _keyboardVisibilityController2;
  void _functionForKeyboardHide2(){
    FocusManager.instance.primaryFocus?.unfocus();
    viewScrollController.jumpTo(0);
  }

  @override
  void initState(){
    CommonUtils.log("i", "새 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _keyboardVisibilityController= CommonUtils.getKeyboardViewController(_functionForKeyboardShow, _functionForKeyboardHide);
    messagesHistory.add(Messages(role: Role.system, content: "항상 반말로 대답해."));
    messages.add({
      'id': firstId,
      'text': "AI 상담사",
    });
  }

  Future<void> _initGptApiKEy() async {
    await FireBaseController.initializeFirebase();
    String gptAPiKey = await FireBaseController.getGPTApiKey();
    ApiController.gptApiKey = gptAPiKey;
    print(gptAPiKey);
    isInit = true;
  }

  @override
  void dispose(){
    CommonUtils.log("i", "새 화면 파괴");
    messages.clear();
    inputTextController.dispose();
    messageListViewController.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
    BorderRadiusDirectional borderType = BorderRadiusDirectional.only(topEnd: Radius.circular(15.r), bottomEnd: Radius.circular(15.r), bottomStart: Radius.circular(15.r));
    if (messageId == firstId) {
      chatTextColor = Colors.black;
      boxColor = Colors.amberAccent;
      borderType = BorderRadiusDirectional.all(Radius.circular(30.r));
      fontSize = 22.sp;

      return Container(padding: const EdgeInsets.only(bottom: 10),
          child :Card(
              color: boxColor,
              shape: RoundedRectangleBorder(borderRadius: borderType),
              elevation: 2,
              shadowColor: Colors.grey,
              child: Container(padding: const EdgeInsets.all(10),
                  child: Text(messageText, style: TextStyle(color: chatTextColor, fontSize: fontSize, fontWeight: FontWeight.bold), textAlign: TextAlign.center)
              )
          )
      );
    }else{
      if(messageId == thisId){
        boxAlignType = MainAxisAlignment.end;
        chatTextColor = ColorStyles.darkGray;
        borderType = BorderRadiusDirectional.only(topStart: Radius.circular(15.r), bottomEnd: Radius.circular(15.r), bottomStart: Radius.circular(15.r));
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
                    elevation: 4,
                    shadowColor: Colors.grey,
                    child: Container(padding: const EdgeInsets.all(15),
                        constraints: BoxConstraints(maxWidth: Config.appRealSize[0]-100, maxHeight: Config.appRealSize[1]-50),
                        child: Text(messageText, style: TextStyle(color: chatTextColor, fontSize: fontSize))
                    )
                )
              ])
      );
    }
  }

  Future<void> _sendMessage(String message) async {
    CommonUtils.hideKeyBoard(context);
    UiUtils.showLoadingPop(context);
    if(!isInit){
      await FireBaseController.initializeFirebase();
      String gptAPiKey = await FireBaseController.getGPTApiKey();
      ApiController.gptApiKey = gptAPiKey;
      isInit = true;
    }

    messages.add({
      'id': thisId,
      'text': message,
    });

    setState(() {});

    messagesHistory.add(Messages(role: Role.user, content: message));
    String receivedMessage = await ApiController.sendAndReceiveTextToGPTUsingLib(messagesHistory);
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
        print("bottom move");
      });
    }
  }

  double inputMinHeight = Config.appRealSize[1] * 0.1;
  double inputHeight = Config.appRealSize[1] * 0.1;
  double inputMaxHeight = Config.appRealSize[1] * 0.3;

  @override
  Widget build(BuildContext context) {
    scrollToBottom();

    Widget view = Container(width: Config.appRealSize[0], color: ColorStyles.finAppWhite, child:Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        /// 채팅 메인 화면
        Expanded(
            child: Container(
                constraints: BoxConstraints(maxHeight: Config.appRealSize[1]*0.9),
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
        UiUtils.getMarginBox(Config.appRealSize[1]*0.01, 0),

        /// 채팅 글 입력 칸
        AnimatedContainer(
          duration: const Duration(milliseconds: 700), // Optional: Add a duration for smooth animation
          width: Config.appRealSize[0] * 0.95,
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
                width: Config.appRealSize[0] * 0.95 * 0.75,
                child: TextField(
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
                    )..layout(minWidth: 0, maxWidth: Config.appRealSize[0] * 0.95 * 0.75);
                    final desiredHeight = inputMinHeight + textHeight.height;
                    // Limit the height to the maxHeight constraint
                    final height = desiredHeight.clamp(inputMinHeight, inputMaxHeight);
                    // Update the container height
                    setState(() {
                      inputHeight = height;
                    });
                  },
                  decoration: UiUtils.getInputDecorationWithNoErrorMessage("INPUT"),
                ),
              ),
              UiUtils.getMarginBox(0, Config.appRealSize[0] * 0.95 * 0.03),
              UiUtils.getIconButtonBox(
                Config.appRealSize[0] * 0.95 * 0.2,
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
        UiUtils.getMarginBox(Config.appRealSize[1]*0.01, 0),
      ]
    ));

    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}