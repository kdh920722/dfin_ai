import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwebchat/controllers/api_controller.dart';
import 'package:flutterwebchat/styles/ColorStyles.dart';
import '../styles/TextStyles.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class ChatView extends StatefulWidget{
  @override
  ChatViewState createState() => ChatViewState();
}

class ChatViewState extends State<ChatView> with WidgetsBindingObserver{
  List<Map<String, String>> messages = [];
  final messageListViewController = ScrollController();
  final inputTextController = TextEditingController();
  final String thisId = "ME";
  final String aiId = "GPT";
  
  @override
  void initState(){
    CommonUtils.log("i", "새 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    messages.add({
      'id': thisId,
      'text': "안녕. 만나서 반가워!",
    });
    messages.add({
      'id': aiId,
      'text': "나도 반가워!",
    });
  }

  @override
  void dispose(){
    CommonUtils.log("i", "새 화면 파괴");
    messages.clear();
    inputTextController.dispose();
    messageListViewController.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
    MainAxisAlignment boxAlignType = MainAxisAlignment.start;
    Color chatTextColor = ColorStyles.finAppGreen;
    BorderRadiusDirectional borderType = BorderRadiusDirectional.only(topEnd: Radius.circular(15.r), bottomEnd: Radius.circular(15.r), bottomStart: Radius.circular(15.r));
    if (thisId == messageId) {
      boxAlignType = MainAxisAlignment.end;
      chatTextColor = ColorStyles.finAppGray4;
      borderType = BorderRadiusDirectional.only(topStart: Radius.circular(15.r), bottomEnd: Radius.circular(15.r), bottomStart: Radius.circular(15.r));
    }

      return Container(padding: const EdgeInsets.only(bottom: 3),
          child : Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: boxAlignType,
              children: [
                Card(
                    shape: RoundedRectangleBorder(borderRadius: borderType),
                    elevation: 3,
                    shadowColor: Colors.grey,
                    child: Container(padding: const EdgeInsets.all(15),
                        constraints: BoxConstraints(maxWidth: Config.appRealSize[0]-100, maxHeight: Config.appRealSize[1]-50),
                        child: Text(messageText, style: TextStyle(color: chatTextColor, fontSize: 18.sp, fontWeight: FontWeight.bold))
            )
        )
      ])
      );
  }

  Future<void> _sendMessage(String message) async {
    CommonUtils.hideKeyBoard(context);
    messages.add({
      'id': thisId,
      'text': message,
    });
    setState(() {});

    UiUtils.showLoadingPop(context);
    String receivedMessage = await ApiController.sendAndReceiveTextToGPTUsingLib(message);
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
  }

  @override
  Widget build(BuildContext context) {
    if(messageListViewController.positions.isNotEmpty){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        messageListViewController.jumpTo(messageListViewController.position.maxScrollExtent);
      });
    }

    Widget view = Container(width: Config.appRealSize[0], color: ColorStyles.finAppWhite, child:Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        /// 채팅 메인 화면
        Container(height: Config.appRealSize[1]*0.9, color: ColorStyles.finAppGreen, padding : const EdgeInsets.all(10),
            child: messages.isEmpty? Container() : ListView.builder(
              controller: messageListViewController,
              scrollDirection: Axis.vertical,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _getChatBox(messages[index]);
              },
            )),

        /// 채팅 상하 여백
        UiUtils.getMarginBox(Config.appRealSize[1]*0.005, 0),

        /// 채팅 글 입력 칸
        Container(width: Config.appRealSize[0]*0.95, height: Config.appRealSize[1]*0.095, color: ColorStyles.finAppWhite,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(width: Config.appRealSize[0]*0.95*0.75, child: TextField(
                  style: TextStyles.subTitleTextStyle,
                  controller: inputTextController,
                  textAlign: TextAlign.start,
                  cursorColor: Colors.grey,
                  decoration: UiUtils.getInputDecorationWithNoErrorMessage("INPUT")
              )),
              UiUtils.getMarginBox(0, Config.appRealSize[0]*0.95*0.02),
              UiUtils.getIconButtonBox(Config.appRealSize[0]*0.95*0.2, Icons.send, "", ColorStyles.finAppGreen, () {
                if(inputTextController.text.trim() != ""){
                  String message = inputTextController.text;
                  inputTextController.text = "";
                  _sendMessage(message);
                }
              })
            ])
        ),
      ],
    ));

    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}