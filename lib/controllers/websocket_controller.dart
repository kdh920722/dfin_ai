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
  static ActionCable? cable;
  static List<String> subscribedRoomIds = [];
  static List<String> tempMsgList = [];

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
        disposeSocket();
        _connectSocket((isSuccessToConnect){
          if(isSuccessToConnect){
            callback(true);
          }else{
            CommonUtils.flutterToast("채팅서버연결에 실패했습니다.\n다시 시작해주세요.");
            CommonUtils.emergencyBackToHome();
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
            subscribedRoomIds.clear();
            disposeSocket();
            _connectSocket((isSuccessToConnect){
              if(isSuccessToConnect){
                callback(true);
              }
            });
            //callback(false);
          },
          onCannotConnect: () {
            CommonUtils.log("e", "websocket cannot connect");
            disposeSocket();
            _connectSocket((isSuccessToConnect){
              if(isSuccessToConnect){
                callback(true);
              }
            });
            //callback(false);
          });
    } catch (error) {
      CommonUtils.log("e", "get websocket error : ${error.toString()}");
      disposeSocket();
      _connectSocket((isSuccessToConnect){
        if(isSuccessToConnect){
          callback(true);
        }
      });
      //callback(false);
    }
  }

  static bool isSubscribe(String roomId){
    bool isAlreadySubscribe = false;
    CommonUtils.log("i", "connected subscribe : ${subscribedRoomIds.length}");
    for(var eachSubscribeRoomId in subscribedRoomIds){
      CommonUtils.log("i", "connected subscribe : $roomId || $eachSubscribeRoomId");
      if(eachSubscribeRoomId == roomId) isAlreadySubscribe = true;
    }

    return isAlreadySubscribe;
  }

  static Future<void> connectSubscribe(String roomId, Function(bool isSuccess) callback) async {
    CommonUtils.log("i", "connect subscribe");
    try{
      CommonUtils.log("i", "room: $roomId");
      if(!isSubscribe(roomId)){
        cable!.subscribe(
            channelName, channelParams: { "room": roomId },
            onSubscribed: (){
              CommonUtils.log("i", "websocket sub connect success!!");
              subscribedRoomIds.add(roomId);
              callback(true);
            },
            onDisconnected: (){
              CommonUtils.log("e", "websocket sub connect failed");
              int idx = -1;
              for(int i = 0 ; i < subscribedRoomIds.length ; i++){
                if(subscribedRoomIds[i] == roomId) idx = i;
              }
              if(idx != -1) subscribedRoomIds.removeAt(idx);
              CommonUtils.flutterToast("채팅방 재접속");
              //callback(false);
              disposeSocket();
              _connectSocket((isSuccess){
                connectSubscribe(roomId, (isSuccessToReTry){
                  if(isSuccessToReTry){
                    callback(true);
                  }
                });
              });

            },
            onMessage: (Map message) {
              CommonUtils.log("i", "arrived message : $message");
              bool isHere = false;
              var eachMsg = message;
              for(int i = 0 ; i < MyData.getChatRoomInfoList().length ; i++){
                if(MyData.getChatRoomInfoList()[i].chatRoomId == roomId){
                  isHere = true;
                  Map<String, dynamic> msgInfo = jsonDecode(MyData.getChatRoomInfoList()[i].chatRoomMsgInfo);
                  List<dynamic> msgList = msgInfo["data"];
                  msgList.add(eachMsg);
                  msgInfo.remove("data");
                  msgInfo["data"] = msgList;
                  MyData.getChatRoomInfoList()[i].chatRoomMsgInfo = jsonEncode(msgInfo);
                }
              }
              if(isHere){
                GetController.to.updateChatLoanInfoList(MyData.getChatRoomInfoList());

                if(AppChatViewState.currentRoomId == eachMsg["pr_room_id"].toString()){
                  var messageItem = ChatMessageInfoData(eachMsg["id"].toString(), eachMsg["pr_room_id"].toString(), eachMsg["message"].toString(),
                      CommonUtils.convertTimeToString(CommonUtils.parseToLocalTime(eachMsg["created_at"])),
                      eachMsg["message_type"].toString(), eachMsg["username"].toString(), jsonEncode(eachMsg));
                  GetController.to.addChatMessageInfoList(messageItem);
                }
              }else{
                tempMsgList.add(jsonEncode(eachMsg));
              }
            }
        );
      }
    }catch(error){
      CommonUtils.log("e", "get websocket sub error : ${error.toString()}");
      disposeSocket();
      _connectSocket((isSuccess){
        connectSubscribe(roomId, (isSuccessToReTry){
          if(isSuccessToReTry){
            callback(true);
          }
        });
      });
      //callback(false);
    }
  }

  static void disposeSocket() async {
    try{
      subscribedRoomIds.clear();
      if(cable != null){
        cable!.disconnect();
        cable = null;
      }
    }catch(error){
      CommonUtils.log("e", "disconnect websocket error : ${error.toString()}");
    }
  }
}