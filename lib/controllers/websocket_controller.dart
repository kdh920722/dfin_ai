import 'dart:async';
import 'dart:convert';
import 'package:action_cable/action_cable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:upfin/controllers/get_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/views/app_chat_view.dart';
import 'package:upfin/views/app_main_view.dart';
import '../configs/app_config.dart';
import '../datas/chat_message_info_data.dart';
import '../utils/common_utils.dart';
import 'logfin_controller.dart';

class WebSocketController {
  static final WebSocketController _instance = WebSocketController._internal();
  factory WebSocketController() => _instance;
  WebSocketController._internal();

  static String wsUrl = "";
  static String wsOriginUrl = "";
  static String channelName = "";
  static List<Map<String,dynamic>> subscribedRoomIds = [];
  static bool isReSubScribe = false;
  static ActionCable? cable;
  static bool isInit = false;
  static bool isRetry = false;
  static Timer? reSubScribeCheckTimer;
  static Timer? reSubScribeTimer;

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
        callback(true);
      } else {
        callback(false);
      }
    }catch(error){
      CommonUtils.log("e", "get websocket info error : ${error.toString()}");
      callback(false);
    }
  }

  static void setWaitingState(String roomId, String type, bool isWaiting){
    for(int i = 0 ; i < subscribedRoomIds.length ; i++){
      if(roomId == ""){
        subscribedRoomIds[i]["isWaitingForAnswer"] = isWaiting;
        subscribedRoomIds[i]["isWaitingForMe"] = isWaiting;
      }else{
        if(subscribedRoomIds[i]["room_id"] == roomId){
          if(type == "UPFIN"){
            subscribedRoomIds[i]["isWaitingForAnswer"] = isWaiting;
          }else{
            subscribedRoomIds[i]["isWaitingForMe"] = isWaiting;
          }
        }
      }
    }
  }

  static bool isWaitingForAnswerState(String roomId, String type){
    bool isWaiting = false;
    for(int i = 0 ; i < subscribedRoomIds.length ; i++){
      if(subscribedRoomIds[i]["room_id"] == roomId){
        if(type == "UPFIN"){
          isWaiting = subscribedRoomIds[i]["isWaitingForAnswer"];
        }else{
          isWaiting = subscribedRoomIds[i]["isWaitingForMe"];
        }
      }
    }

    return isWaiting;
  }

  static void resetConnectWebSocketCable(){
    isInit = false;
    isReSubScribe = false;
    if(reSubScribeTimer != null) reSubScribeTimer!.cancel();
    if(reSubScribeCheckTimer != null) reSubScribeCheckTimer!.cancel();
    GetController.to.updateAllSubScribed(false);
    subscribedRoomIds.clear();
    if(cable != null) cable!.disconnect();
    cable = null;
  }

  static void connectToWebSocketCable() {
    try {
      // ActionCable 서버 정보 설정
      cable = ActionCable.Connect(
          wsUrl,
          headers: {
            "Origin": wsOriginUrl,
          }
      );

      cable!.onConnected = () {
        isInit = true;
        const Duration intervalForReSubScribe = Duration(seconds: 20);
        reSubScribeCheckTimer = Timer.periodic(intervalForReSubScribe, (Timer timer) {
          isReSubScribe = true;
        });
        isReSubScribe = true;
        const Duration interval = Duration(seconds: 1);
        reSubScribeTimer = Timer.periodic(interval, (Timer timer) {
          if(isReSubScribe){
            CommonUtils.log("i", "re subScribe connect");
            isReSubScribe = false;
            int subCnt = 0;
            for(var eachRoom in MyData.getChatRoomInfoList()){
              String roomId = eachRoom.chatRoomId;
              cable!.subscribe(
                  channelName, channelParams: { "room": roomId },
                  onSubscribed: (){
                    CommonUtils.log("i", "onConnected : $roomId");
                    if(!isSubscribe(roomId)){
                      subscribedRoomIds.add({"room_id" : roomId, "isWaitingForAnswer" : false, "isWaitingForMe" : false});
                    }

                    subCnt++;
                    if(MyData.getChatRoomInfoList().length == subCnt){
                      GetController.to.updateAllSubScribed(true);
                    }

                  },
                  onDisconnected: (){
                    CommonUtils.log("i", "onDisconnected : $roomId");
                    int idx = -1;
                    for(int i = 0 ; i < subscribedRoomIds.length ; i++){
                      if(subscribedRoomIds[i]["room_id"] == roomId) idx = i;
                    }
                    if(idx != -1) subscribedRoomIds.removeAt(idx);
                  },
                  onMessage: (Map message) {
                    CommonUtils.log("", "arrived message : $message");
                    var eachMsg = message;
                    for(int i = 0 ; i < MyData.getChatRoomInfoList().length ; i++){
                      if(MyData.getChatRoomInfoList()[i].chatRoomId == roomId){
                        Map<String, dynamic> msgInfo = jsonDecode(MyData.getChatRoomInfoList()[i].chatRoomMsgInfo);
                        List<dynamic> msgList = msgInfo["data"];
                        msgList.add(eachMsg);
                        msgInfo.remove("data");
                        msgInfo["data"] = msgList;
                        MyData.getChatRoomInfoList()[i].chatRoomMsgInfo = jsonEncode(msgInfo);
                      }
                    }
                    GetController.to.updateChatLoanInfoList(MyData.getChatRoomInfoList());

                    WebSocketController.setWaitingState(eachMsg["pr_room_id"].toString(), eachMsg["username"].toString(), false);
                    if(AppChatViewState.currentRoomId == eachMsg["pr_room_id"].toString()){
                      var messageItem = ChatMessageInfoData(eachMsg["id"].toString(), eachMsg["pr_room_id"].toString(), eachMsg["message"].toString(),
                          CommonUtils.convertTimeToString(CommonUtils.parseToLocalTime(eachMsg["created_at"])),
                          eachMsg["message_type"].toString(), eachMsg["username"].toString(), jsonEncode(eachMsg));
                      GetController.to.addChatMessageInfoList(messageItem);
                    }
                  }
              );
            }
          }
        });
      };

      cable!.onConnectionLost = () {
        CommonUtils.log("i", "websocket onConnectionLost error");
        _retryToConnectNewVer();
      };

      cable!.onCannotConnect = () {
        CommonUtils.log("i", "websocket onCannotConnect error");
        _retryToConnectNewVer();
      };
    }catch(error){
      CommonUtils.log("e", "websocket connect error : ${error.toString()}");
      _retryToConnectNewVer();
    }
  }

  static void _retryToConnect(){
    if(isInit){
      GetController.to.updateAllSubScribed(false);
      if(reSubScribeTimer != null) reSubScribeTimer!.cancel();
      if(reSubScribeCheckTimer != null) reSubScribeCheckTimer!.cancel();
      subscribedRoomIds.clear();
      Future.delayed(const Duration(seconds: 2), () {
        connectToWebSocketCable(); // 다시 연결
      });
    }else{
      resetConnectWebSocketCable();
    }
  }

  static void _retryToConnectNewVer(){
    if(!isRetry){
      isRetry = true;
      GetController.to.updateAllSubScribed(false);

      if(AppChatViewState.isViewHere){
        AppChatViewState.isViewHere = false;
        CommonUtils.moveWithUntil(Config.contextForEmergencyBack!, AppView.appMainView.value);
      }

      LogfinController.getLoanInfo((isSuccess, isNotEmpty){
        isRetry = false;
      });
    }
  }

  static bool isSubscribe(String roomId){
    bool isAlreadySubscribe = false;
    CommonUtils.log("i", "connected subscribe : ${subscribedRoomIds.length}");
    for(var eachSubscribeRoomId in subscribedRoomIds){
      CommonUtils.log("i", "connected subscribe : $roomId || ${eachSubscribeRoomId["room_id"]}");
      if(eachSubscribeRoomId["room_id"] == roomId) isAlreadySubscribe = true;
    }

    return isAlreadySubscribe;
  }
}