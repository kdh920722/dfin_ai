import 'dart:convert';
import 'package:action_cable/action_cable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:upfin/controllers/get_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/views/app_chat_view.dart';
import '../datas/chat_message_info_data.dart';
import '../utils/common_utils.dart';

class WebSocketController {
  static final WebSocketController _instance = WebSocketController._internal();
  factory WebSocketController() => _instance;
  WebSocketController._internal();

  static String wsUrl = "";
  static String wsOriginUrl = "";
  static String channelName = "";
  static late ActionCable cable;

  static Future<void> initWebSocket(Function(bool isSuccess) callback) async{
    try{
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('UPFIN/API/websocket').get();
      if (snapshot.exists) {
        for(var each in snapshot.children){
          switch(each.key){
            case "ws_url" : wsUrl = each.value.toString();
            case "ws_origin_url" : wsOriginUrl = each.value.toString();
            case "channel_name" : channelName = each.value.toString();
          }
        }

        _connectSocket((isSuccessToConnect){
          if(isSuccessToConnect){
            callback(true);
          }else{
            CommonUtils.emergencyBackToHome();
            //callback(false);
          }
        });
      } else {
        callback(false);
      }
    }catch(error){
      CommonUtils.log("e", "get websocket info error : ${error.toString()}");
      callback(false);
    }
  }

  static Future<void> _connectSocket(Function(bool isSuccess) callback) async {
    try {
      cable = ActionCable.Connect(
          wsUrl,
          headers: {
            "Origin": wsOriginUrl,
          },
          onConnected: () {
            CommonUtils.log("i", "websocket connected");
            callback(true);
          },
          onConnectionLost: () {
            CommonUtils.log("e", "websocket connect lost");
            callback(false);
          },
          onCannotConnect: () {
            CommonUtils.log("e", "websocket cannot connect");
            callback(false);
          });
    } catch (error) {
      CommonUtils.log("e", "get websocket error : ${error.toString()}");
      callback(false);
    }
  }

  static void subscribeChatroom(){
    WebSocketController.disconnectSubscribe((isSuccessToResetSub){
      if(isSuccessToResetSub){
        WebSocketController.connectSubscribe((isSuccessToSubscribe){
          if(!isSuccessToSubscribe){
            CommonUtils.flutterToast("채팅방연결에 실패했습니다.\n다시 시작해주세요.");
            CommonUtils.emergencyBackToHome();
          }
        });
      }else{
        CommonUtils.flutterToast("채팅방해제에 실패했습니다.\n다시 시작해주세요.");
      }
    });
  }

  static Future<void> connectSubscribe(Function(bool isSuccess) callback) async {
    CommonUtils.log("i", "connect subscribe");
    try{
      int subSuccessCnt = 0;
      for(var each in MyData.getChatRoomInfoList()){
        CommonUtils.log("i", "room: ${each.chatRoomId}");
        cable.subscribe(
            channelName, channelParams: { "room": each.chatRoomId },
            onSubscribed: (){
              subSuccessCnt++;
              if(subSuccessCnt == MyData.getChatRoomInfoList().length){
                CommonUtils.log("i", "websocket sub connect success!!");
              }
            },
            onDisconnected: (){
              CommonUtils.log("e", "websocket sub connect failed");
              callback(false);
            },
            onMessage: (Map message) {
              CommonUtils.log("i", "arrived message : $message");
              var eachMsg = message;
              for(int i = 0 ; i < MyData.getChatRoomInfoList().length ; i++){
                if(MyData.getChatRoomInfoList()[i].chatRoomId == each.chatRoomId){
                  Map<String, dynamic> msgInfo = jsonDecode(MyData.getChatRoomInfoList()[i].chatRoomMsgInfo);
                  List<dynamic> msgList = msgInfo["data"];
                  msgList.add(eachMsg);
                  msgInfo.remove("data");
                  msgInfo["data"] = msgList;
                  MyData.getChatRoomInfoList()[i].chatRoomMsgInfo = jsonEncode(msgInfo);
                }
              }
              GetController.to.updateChatLoanInfoList(MyData.getChatRoomInfoList());
              if(AppChatViewState.currentRoomId == eachMsg["pr_room_id"].toString()){
                var messageItem = ChatMessageInfoData(eachMsg["id"].toString(), eachMsg["pr_room_id"].toString(), eachMsg["message"].toString(),
                    CommonUtils.convertTimeToString(CommonUtils.parseToLocalTime(eachMsg["created_at"])),
                    eachMsg["message_type"].toString(), eachMsg["username"].toString(), jsonEncode(eachMsg));
                GetController.to.addChatMessageInfoList(messageItem);
              }
            }
        );
      }
    }catch(error){
      CommonUtils.log("e", "get websocket sub error : ${error.toString()}");
      callback(false);
    }
  }

  static void disconnectSubscribe(Function(bool isSuccess) callback){
    try{
     /*
      for(var each in MyData.getChatRoomInfoList()){
        cable.unsubscribe(
            channelName,
            channelParams: {"room": each.chatRoomId}
        );
      }
     */
      callback(true);
    }catch(error){
      CommonUtils.log("e", "websocket disconnect sub error : ${error.toString()}");
      callback(false);
    }
  }

  static void disposeSocket() async {
    try{
      //disconnectSubscribe((isSuccess){});
      cable.disconnect();
    }catch(error){
      CommonUtils.log("e", "disconnect websocket error : ${error.toString()}");
    }
  }
}