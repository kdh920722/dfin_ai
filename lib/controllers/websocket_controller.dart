import 'dart:async';
import 'dart:convert';
import 'package:action_cable/action_cable.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:upfin/controllers/get_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/views/app_chat_view.dart';
import 'package:upfin/views/app_main_view.dart';
import '../configs/app_config.dart';
import '../datas/chat_message_info_data.dart';
import '../datas/loan_info_data.dart';
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
  static Map<String,dynamic> connectionInfoMap = {};
  static bool isMessageReceived = false;
  static final AssetsAudioPlayer assetsChatSendAudioPlayer = AssetsAudioPlayer.newPlayer();
  static final AssetsAudioPlayer assetsChatPushAudioPlayer = AssetsAudioPlayer.newPlayer();

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

        assetsChatSendAudioPlayer.open(
          Audio("assets/sounds/msg_send.mp3"),
          loopMode: LoopMode.none, //반복 여부 (LoopMode.none : 없음)
          autoStart: false, //자동 시작 여부
          showNotification: false, //스마트폰 알림 창에 띄울지 여부
        );
        assetsChatPushAudioPlayer.open(
          Audio("assets/sounds/msg_push.mp3"),
          loopMode: LoopMode.none, //반복 여부 (LoopMode.none : 없음)
          autoStart: false, //자동 시작 여부
          showNotification: false, //스마트폰 알림 창에 띄울지 여부
        );

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
            if(!isWaiting && AppChatViewState.currentRoomId == roomId) assetsChatPushAudioPlayer.play();
            subscribedRoomIds[i]["isWaitingForAnswer"] = isWaiting;
          }else{
            if(!isWaiting && AppChatViewState.currentRoomId == roomId) assetsChatSendAudioPlayer.play();
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
    isMessageReceived = false;
    if(reSubScribeTimer != null) reSubScribeTimer!.cancel();
    if(reSubScribeCheckTimer != null) reSubScribeCheckTimer!.cancel();
    GetController.to.updateAllSubScribed(false);
    subscribedRoomIds.clear();
    if(cable != null) cable!.disconnect();
    cable = null;
  }

  static void connectToWebSocketCable() {
    String connectionKey = "";

    try {
      // ActionCable 서버 정보 설정
      cable = ActionCable.Connect(
          wsUrl,
          headers: {
            "Origin": wsOriginUrl,
          }
      );

      cable!.onConnected = () {
        connectionKey = CommonUtils.convertTimeToString(CommonUtils.getCurrentLocalTime());
        connectionInfoMap = {"connection_key" : connectionKey, "is_connected": true};
        if(!isInit){
          isInit = true;
          int subCnt = 0;
          for(var eachRoom in MyData.getChatRoomInfoList()){
            String roomId = eachRoom.chatRoomId;
            cable!.subscribe(
                channelName, channelParams: { "room": roomId },
                onSubscribed: (){

                  if(!isSubscribe(roomId)){
                    subscribedRoomIds.add({"room_id" : roomId, "isWaitingForAnswer" : false, "isWaitingForMe" : false});
                  }

                  subCnt++;

                  CommonUtils.log("", "onConnected : $roomId : $subCnt || ${MyData.getChatRoomInfoList().length}");

                  if(MyData.getChatRoomInfoList().length == subCnt){
                    GetController.to.updateAllSubScribed(true);
                  }

                },
                onDisconnected: (){
                  CommonUtils.log("e", "websocket subscribe onDisconnected error");
                  _retryToConnectNewVer(connectionKey);
                },
                onMessage: (Map message) {
                  var eachMsg = message;
                  CommonUtils.log("", "arrived message : ${eachMsg["pr_room_id"].toString()} || $roomId \n $message");

                  if(AppChatViewState.isScrollMove && eachMsg["username"].toString() == "UPFIN"){
                    String lastMsg = eachMsg["message"].toString();
                    lastMsg = "${lastMsg.substring(0,8)}...";
                    CommonUtils.flutterToast("새로운 메시지\n$lastMsg");
                  }

                  for(int i = 0 ; i < MyData.getChatRoomInfoList().length ; i++){
                    if(MyData.getChatRoomInfoList()[i].chatRoomId == eachMsg["pr_room_id"].toString()){
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
                  if(WebSocketController.isWaitingForAnswerState(eachMsg["pr_room_id"].toString(), "ME") == WebSocketController.isWaitingForAnswerState(eachMsg["pr_room_id"].toString(), "UPFIN")){
                    if(WebSocketController.isWaitingForAnswerState(eachMsg["pr_room_id"].toString(), "ME")){
                      GetController.to.updateAutoAnswerWaiting(true);
                    }else{
                      GetController.to.updateAutoAnswerWaiting(false);
                    }
                  }else{
                    GetController.to.updateAutoAnswerWaiting(true);
                  }

                  if(eachMsg["status_flg"].toString() == "1"){
                    String statusId = eachMsg["status_id"].toString();
                    MyData.updateStatusToLoanInfoAndChatRoomInfo(eachMsg["pr_room_id"].toString(), statusId);
                    GetController.to.updateChatLoanInfoList(MyData.getChatRoomInfoList());
                  }

                  if(AppChatViewState.currentRoomId == eachMsg["pr_room_id"].toString()){
                    isMessageReceived = true;
                    var messageItem = ChatMessageInfoData(eachMsg["id"].toString(), eachMsg["pr_room_id"].toString(), eachMsg["message"].toString(),
                        CommonUtils.convertTimeToString(CommonUtils.parseToLocalTime(eachMsg["created_at"])),
                        eachMsg["message_type"].toString(), eachMsg["username"].toString(), jsonEncode(eachMsg));
                    GetController.to.addChatMessageInfoList(messageItem);
                    if(eachMsg["status_flg"].toString() == "1"){
                      String statusId = eachMsg["status_id"].toString();
                      if(LoanInfoData.getStatusName(statusId) == "접수"){
                        GetController.to.updateChatStatusTick(1);
                      }else if(LoanInfoData.getStatusName(statusId) == "심사"){
                        GetController.to.updateChatStatusTick(2);
                      }else if(LoanInfoData.getStatusName(statusId) == "통보"){
                        GetController.to.updateChatStatusTick(3);
                      }
                    }

                    if(eachMsg["message_type"] == "file" && !AppChatViewState.isScrollMove){
                      GetController.to.updateHtmlLoad(false);
                    }
                  }else{
                    isMessageReceived = false;
                  }
                }
            );
          }
        }
      };

      cable!.onConnectionLost = () {
        CommonUtils.log("e", "websocket onConnectionLost error");
        _retryToConnectNewVer(connectionKey);
      };

      cable!.onCannotConnect = () {
        CommonUtils.log("e", "websocket onCannotConnect error");
        _retryToConnectNewVer(connectionKey);
      };
    }catch(error){
      CommonUtils.log("e", "websocket connect error : ${error.toString()}");
      _retryToConnectNewVer(connectionKey);
    }
  }

  /*
  static void connectToWebSocketCable() {
    String connectionKey = "";

    try {
      // ActionCable 서버 정보 설정
      cable = ActionCable.Connect(
          wsUrl,
          headers: {
            "Origin": wsOriginUrl,
          }
      );

      cable!.onConnected = () {
        connectionKey = CommonUtils.convertTimeToString(CommonUtils.getCurrentLocalTime());
        connectionInfoMap = {"connection_key" : connectionKey, "is_connected": true};
        isInit = true;
        const Duration intervalForReSubScribe = Duration(seconds: 20);
        reSubScribeCheckTimer = Timer.periodic(intervalForReSubScribe, (Timer timer) {
          isReSubScribe = true;
        });
        isReSubScribe = true;
        const Duration interval = Duration(seconds: 1);
        reSubScribeTimer = Timer.periodic(interval, (Timer timer) {
          if(isReSubScribe){
            isReSubScribe = false;
            int subCnt = 0;
            for(var eachRoom in MyData.getChatRoomInfoList()){
              String roomId = eachRoom.chatRoomId;
              cable!.subscribe(
                  channelName, channelParams: { "room": roomId },
                  onSubscribed: (){

                    if(!isSubscribe(roomId)){
                      subscribedRoomIds.add({"room_id" : roomId, "isWaitingForAnswer" : false, "isWaitingForMe" : false});
                    }

                    subCnt++;

                    CommonUtils.log("", "onConnected : $roomId : $subCnt || ${MyData.getChatRoomInfoList().length}");

                    if(MyData.getChatRoomInfoList().length == subCnt){
                      GetController.to.updateAllSubScribed(true);
                    }

                  },
                  onDisconnected: (){
                    CommonUtils.log("i", "onDisconnected : $roomId");
                    // int idx = -1;
                    // for(int i = 0 ; i < subscribedRoomIds.length ; i++){
                    //   if(subscribedRoomIds[i]["room_id"] == roomId) idx = i;
                    // }
                    // if(idx != -1) subscribedRoomIds.removeAt(idx);
                    CommonUtils.log("e", "websocket subscribe onDisconnected error");
                    _retryToConnectNewVer(connectionKey);
                  },
                  onMessage: (Map message) {
                    var eachMsg = message;
                    CommonUtils.log("", "arrived message : ${eachMsg["pr_room_id"].toString()} || $roomId \n $message");

                    if(AppChatViewState.isScrollMove && eachMsg["username"].toString() == "UPFIN"){
                      String lastMsg = eachMsg["message"].toString();
                      lastMsg = "${lastMsg.substring(0,8)}...";
                      CommonUtils.flutterToast("새로운 메시지\n$lastMsg");
                    }

                    for(int i = 0 ; i < MyData.getChatRoomInfoList().length ; i++){
                      if(MyData.getChatRoomInfoList()[i].chatRoomId == eachMsg["pr_room_id"].toString()){
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
                    if(WebSocketController.isWaitingForAnswerState(eachMsg["pr_room_id"].toString(), "ME") == WebSocketController.isWaitingForAnswerState(eachMsg["pr_room_id"].toString(), "UPFIN")){
                      if(WebSocketController.isWaitingForAnswerState(eachMsg["pr_room_id"].toString(), "ME")){
                        GetController.to.updateAutoAnswerWaiting(true);
                      }else{
                        GetController.to.updateAutoAnswerWaiting(false);
                      }
                    }else{
                      GetController.to.updateAutoAnswerWaiting(true);
                    }

                    if(eachMsg["status_flg"].toString() == "1"){
                      String statusId = eachMsg["status_id"].toString();
                      MyData.updateStatusToLoanInfoAndChatRoomInfo(eachMsg["pr_room_id"].toString(), statusId);
                      GetController.to.updateChatLoanInfoList(MyData.getChatRoomInfoList());
                    }

                    if(AppChatViewState.currentRoomId == eachMsg["pr_room_id"].toString()){
                      isMessageReceived = true;
                      var messageItem = ChatMessageInfoData(eachMsg["id"].toString(), eachMsg["pr_room_id"].toString(), eachMsg["message"].toString(),
                          CommonUtils.convertTimeToString(CommonUtils.parseToLocalTime(eachMsg["created_at"])),
                          eachMsg["message_type"].toString(), eachMsg["username"].toString(), jsonEncode(eachMsg));
                      GetController.to.addChatMessageInfoList(messageItem);
                      if(eachMsg["status_flg"].toString() == "1"){
                        String statusId = eachMsg["status_id"].toString();
                        if(LoanInfoData.getStatusName(statusId) == "접수"){
                          GetController.to.updateChatStatusTick(1);
                        }else if(LoanInfoData.getStatusName(statusId) == "심사"){
                          GetController.to.updateChatStatusTick(2);
                        }else if(LoanInfoData.getStatusName(statusId) == "통보"){
                          GetController.to.updateChatStatusTick(3);
                        }
                      }

                      if(eachMsg["message_type"] == "file" && !AppChatViewState.isScrollMove){
                        GetController.to.updateHtmlLoad(false);
                      }
                    }else{
                      isMessageReceived = false;
                    }
                  }
              );
            }
          }
        });
      };

      cable!.onConnectionLost = () {
        CommonUtils.log("e", "websocket onConnectionLost error");
        _retryToConnectNewVer(connectionKey);
      };

      cable!.onCannotConnect = () {
        CommonUtils.log("e", "websocket onCannotConnect error");
        _retryToConnectNewVer(connectionKey);
      };
    }catch(error){
      CommonUtils.log("e", "websocket connect error : ${error.toString()}");
      _retryToConnectNewVer(connectionKey);
    }
  }
  */

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

  static void _retryToConnectNewVer(String connectedKey){
    String key = connectionInfoMap["connection_key"];
    if(connectedKey != "" && connectionInfoMap["is_connected"] && key == connectedKey){
      connectionInfoMap["is_connected"] = false;
      GetController.to.updateAllSubScribed(false);

      if(!AppMainViewState.isViewHere){
        AppChatViewState.isViewHere = false;
        AppMainViewState.isViewHere = true;
        CommonUtils.flutterToast("재접속 중입니다.\n잠시만 기다려 주세요.");
        CommonUtils.moveWithUntil(Config.contextForEmergencyBack!, AppView.appMainView.value);
      }

      LogfinController.getLoanInfo((isSuccess, isNotEmpty){
        connectionInfoMap["is_connected"] = true;
        if(isSuccess){
          GetController.to.updateAllSubScribed(true);
          if(!isNotEmpty){
            Future.delayed(const Duration(seconds: 5), () {
              _retryToConnectNewVer(connectedKey);
            });
          }
        }else{
          // fail
          Future.delayed(const Duration(seconds: 5), () {
            _retryToConnectNewVer(connectedKey);
          });
        }
      });
    }
  }

  /*
  static void _retryToConnectNewVer(String connectedKey){
    String key = connectionInfoMap["connection_key"];
    if(connectedKey != "" && connectionInfoMap["is_connected"] && key == connectedKey){
      connectionInfoMap["is_connected"] = false;
      if(!isRetry){
        isRetry = true;
        GetController.to.updateAllSubScribed(false);

        if(!AppMainViewState.isViewHere){
          AppChatViewState.isViewHere = false;
          AppMainViewState.isViewHere = true;
          CommonUtils.flutterToast("재접속 중입니다.\n잠시만 기다려 주세요.");
          CommonUtils.moveWithUntil(Config.contextForEmergencyBack!, AppView.appMainView.value);
        }

        LogfinController.getLoanInfo((isSuccess, isNotEmpty){
          isRetry = false;
          if(isSuccess){
            if(isNotEmpty){
              // success
              connectionInfoMap["is_connected"] = true;
            }else{
              // fail
              Future.delayed(const Duration(seconds: 5), () {
                connectionInfoMap["is_connected"] = true;
                _retryToConnectNewVer(connectedKey);
              });
            }
          }else{
            // fail
            Future.delayed(const Duration(seconds: 5), () {
              connectionInfoMap["is_connected"] = true;
              _retryToConnectNewVer(connectedKey);
            });
          }
        });
      }
    }
  }
   */

  static bool isSubscribe(String roomId){
    bool isAlreadySubscribe = false;
    for(var eachSubscribeRoomId in subscribedRoomIds){
      if(eachSubscribeRoomId["room_id"] == roomId) isAlreadySubscribe = true;
    }

    return isAlreadySubscribe;
  }
}