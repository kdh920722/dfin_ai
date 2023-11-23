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
  static ActionCable? cable;
  static bool isInit = false;
  static bool isRetry = false;
  static Map<String,dynamic> connectionInfoMap = {};
  static bool isMessageReceived = false;
  static final AssetsAudioPlayer assetsChatSendAudioPlayer = AssetsAudioPlayer.newPlayer();

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

  static void resetRetry(){
    isInit = false;
    isMessageReceived = false;
    if(retryCheckTimer != null) retryCheckTimer!.cancel();
    retryCheckTimer = null;
    retryTimerCount = 0;
    isRetryStarted = false;
    connectionInfoMap = {};
  }

  static void resetConnectWebSocketCable(){
    isInit = false;
    isMessageReceived = false;
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
        connectionInfoMap = {connectionKey : true};
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
        CommonUtils.log("w", "websocket onConnectionLost error");
        _retryToConnectNewVer(connectionKey);
      };

      cable!.onCannotConnect = () {
        CommonUtils.log("w", "websocket onCannotConnect error");
        _retryToConnectNewVer(connectionKey);
      };
    }catch(error){
      CommonUtils.log("w", "websocket connect error : ${error.toString()}");
      _retryToConnectNewVer(connectionKey);
    }
  }

  static Timer? retryCheckTimer;
  static int retryTimerCount = 0;
  static bool isRetryStarted = false;
  static int maxTryCnt = 110;
  static void _retryToConnectNewVer(String connectedKey){
    retryCheckTimer ??= Timer.periodic(const Duration(milliseconds: 200), (Timer timer) {
      if(!isRetryStarted){
        isRetryStarted = true;
        GetController.to.updateAllSubScribed(false);
        if(AppChatViewState.isViewHere){
          AppChatViewState.isViewHere = false;
          AppMainViewState.isViewHere = true;
          CommonUtils.flutterToast("재접속 중입니다.\n잠시만 기다려 주세요.");
          CommonUtils.moveWithUntil(Config.contextForEmergencyBack!, AppView.appMainView.value);
          Config.contextForEmergencyBack = AppMainViewState.mainContext;
        }
      }
      retryTimerCount++;
      if(retryTimerCount >= maxTryCnt){
        if(retryCheckTimer != null) retryCheckTimer!.cancel();
        retryCheckTimer = null;
        retryTimerCount = 0;
        isRetryStarted = false;

      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if(connectionInfoMap.containsKey(connectedKey)){
        if(connectionInfoMap[connectedKey]){
          connectionInfoMap[connectedKey] = false;
          CommonUtils.log("w", "in1");
          LogfinController.getLoanInfo((isSuccess, isNotEmpty){
            if(isSuccess){
              CommonUtils.log("w", "in2");
              if(!isNotEmpty){
                if(isRetryStarted){
                  CommonUtils.log("w", "in2-2");
                  if(retryTimerCount > maxTryCnt-15){
                    _emergencyBack();
                  }else{
                    connectionInfoMap[connectedKey] = true;
                    _retryToConnectNewVer(connectedKey);
                  }
                }else{
                  CommonUtils.log("w", "in2-3");
                  _emergencyBack();
                }
              }else{
                CommonUtils.log("w", "in2 s");
                connectionInfoMap[connectedKey] = true;
                if(retryCheckTimer != null) retryCheckTimer!.cancel();
                retryCheckTimer = null;
                retryTimerCount = 0;
                isRetryStarted = false;
                connectionInfoMap = {};
              }
            }else{
              CommonUtils.log("w", "in3");
              if(isRetryStarted){
                CommonUtils.log("w", "in3-2");
                if(retryTimerCount > maxTryCnt-15){
                  _emergencyBack();
                }else{
                  connectionInfoMap[connectedKey] = true;
                  _retryToConnectNewVer(connectedKey);
                }
              }else{
                CommonUtils.log("w", "in3-3");
                _emergencyBack();
              }
            }
          });
        }else{
          _emergencyBack();
        }
      }else{
        _emergencyBack();
      }
    });


  }

  static void _emergencyBack(){
    AppChatViewState.isViewHere = false;
    AppMainViewState.isViewHere = false;
    CommonUtils.emergencyBackToHome();
  }

  static bool isSubscribe(String roomId){
    bool isAlreadySubscribe = false;
    for(var eachSubscribeRoomId in subscribedRoomIds){
      if(eachSubscribeRoomId["room_id"] == roomId) isAlreadySubscribe = true;
    }

    return isAlreadySubscribe;
  }
}