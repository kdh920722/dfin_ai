import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:dfin/configs/app_config.dart';
import 'package:dfin/controllers/codef_controller.dart';
import 'package:dfin/datas/accident_info_data.dart';
import 'package:dfin/datas/chat_message_info_data.dart';
import 'package:dfin/datas/chatroom_info_data.dart';
import '../datas/car_info_data.dart';
import '../utils/common_utils.dart';
import 'package:get/get.dart';

class GetController extends GetxController {
  static GetController get to => Get.find();
  RxInt loadingPercent = 0.obs;
  RxBool isWait = false.obs;
  RxBool isConfirmed = false.obs;
  RxBool isAllSubscribed = false.obs;
  RxBool isAutoAnswerWaiting = false.obs;
  RxString preLoanPrice = "만원".obs;
  RxString wantLoanPrice = "만원".obs;

  RxList<AccidentInfoData> accidentInfoDataList = <AccidentInfoData>[].obs;
  RxList<CarInfoData> carInfoDataList = <CarInfoData>[].obs;
  RxList<ChatRoomInfoData> chatLoanInfoDataList = <ChatRoomInfoData>[].obs;
  RxList<ChatMessageInfoData> chatMessageInfoDataList = <ChatMessageInfoData>[].obs;

  RxInt firstVisibleItem1 = 0.obs;
  RxInt lastVisibleItem1 = 0.obs;
  RxInt firstVisibleItem2 = 0.obs;
  RxInt lastVisibleItem2 = 0.obs;

  RxInt firstVisibleItem1_2 = 0.obs;
  RxInt lastVisibleItem1_2 = 0.obs;
  RxInt firstVisibleItem2_2= 0.obs;
  RxInt lastVisibleItem2_2 = 0.obs;
  RxInt firstVisibleItem2_3= 0.obs;
  RxInt lastVisibleItem2_3 = 0.obs;

  RxDouble chatAutoAnswerHeight = 0.0.obs;
  RxBool isInputTextHide = false.obs;
  RxList<Widget> autoAnswerWidgetList = <Widget>[].obs;
  RxBool isShowPickedFile = false.obs;
  RxBool isShowStatus = false.obs;
  RxBool isShowScrollBottom = false.obs;
  RxBool isHtmlLoad = false.obs;
  RxInt chatStatusTick = 0.obs;

  @override
  void onInit() {
    CommonUtils.log("i", 'get 컨트롤러가 생성됩니다.');
    super.onInit();
  }

  @override
  void onClose() {
    CommonUtils.log("i", '컨트롤러가 삭제됩니다.');
    super.onClose();
  }

  void setPercent(int newValue) {
    loadingPercent.value = newValue;
  }
  void updatePercent(int newValue) {
    loadingPercent.value += newValue;
  }
  void resetPercent() {
    loadingPercent = 0.obs;
  }

  void updateWait(bool newValue) {
    isWait.value = newValue;
    if(!newValue){
      resetPercent();
      CodeFController.apiTimerCount = 0;
    }
  }
  void resetIsWait() {
    isWait = false.obs;
  }


  void updateConfirmed(bool newValue) {
    isConfirmed.value = newValue;
  }
  void resetConfirmed() {
    isConfirmed = false.obs;
  }

  void updateAllSubScribed(bool newValue) {
    isAllSubscribed.value = newValue;
  }

  void updateWantLoanPrice(String newValue) {
    wantLoanPrice.value = newValue;

  }
  void resetWantLoanPrice() {
    wantLoanPrice = "만원".obs;
  }


  void updatePreLoanPrice(String newValue) {
    preLoanPrice.value = newValue;
  }
  void resetPreLoanPrice() {
    preLoanPrice = "만원".obs;
  }

  void updateAccidentInfoList(List<AccidentInfoData> newList) {
    accidentInfoDataList.clear();
    accidentInfoDataList.assignAll(newList);
    accidentInfoDataList.sort((a,b) => int.parse(b.id).compareTo(int.parse(a.id)));
  }
  void resetAccdientInfoList() {
    List<AccidentInfoData> emptyList = [];
    accidentInfoDataList.clear();
    accidentInfoDataList.assignAll(emptyList);
  }

  void updateCarInfoList(List<CarInfoData> newList) {
    carInfoDataList.clear();
    carInfoDataList.assignAll(newList);
    carInfoDataList.sort((a,b) => int.parse(b.id).compareTo(int.parse(a.id)));
  }
  void resetCarInfoList() {
    List<CarInfoData> emptyList = [];
    carInfoDataList.clear();
    carInfoDataList.assignAll(emptyList);
  }

  void updateChatLoanInfoList(List<ChatRoomInfoData> newList) {
    chatLoanInfoDataList.clear();
    if(newList.isNotEmpty){
      for(int i=0; i < newList.length; i++){
        var jsonData = jsonDecode(newList[i].chatRoomMsgInfo);
        Map<String, dynamic> msg = jsonData;
        List<dynamic> listMsg = msg["data"];
        listMsg.sort((a,b) => b["id"].compareTo(a["id"]));
        msg.remove("data");
        msg["data"] = listMsg;
        newList[i].chatRoomMsgInfo = jsonEncode(msg);
      }
      List<ChatRoomInfoData> userChatRoomList = [];
      List<ChatRoomInfoData> chatRoomList = [];
      for(var each in newList){
        if(each.chatRoomType == "0"){
          userChatRoomList.add(each);
        }else{
          chatRoomList.add(each);
        }
      }
      chatRoomList.sort((a,b) => jsonDecode(b.chatRoomMsgInfo)["data"][0]["id"].compareTo(jsonDecode(a.chatRoomMsgInfo)["data"][0]["id"]));

      newList.clear();
      newList.addAll(userChatRoomList);
      newList.addAll(chatRoomList);
    }

    chatLoanInfoDataList.assignAll(newList);
  }
  void resetChatLoanInfoList() {
    List<ChatRoomInfoData> emptyList = [];
    chatLoanInfoDataList.clear();
    chatLoanInfoDataList.assignAll(emptyList);
  }

  void addPrevChatMessageInfoList(List<ChatMessageInfoData> newItemList) {
    chatMessageInfoDataList.insertAll(0, newItemList);
  }
  void addChatMessageInfoList(ChatMessageInfoData newItem) {
    chatMessageInfoDataList.add(newItem);
  }
  void resetChatMessageInfoList() {
    List<ChatMessageInfoData> emptyList = [];
    chatMessageInfoDataList.clear();
    chatMessageInfoDataList.assignAll(emptyList);
  }

  void updateFirstIndex1(int newValue) {
    firstVisibleItem1.value = newValue;
  }
  void resetFirstIndex1() {
    firstVisibleItem1 = 0.obs;
  }
  void updateLastIndex1(int newValue) {
    lastVisibleItem1.value = newValue;
  }
  void resetLastIndex1() {
    lastVisibleItem1 = 0.obs;
  }

  void updateFirstIndex2(int newValue) {
    firstVisibleItem2.value = newValue;
  }
  void resetFirstIndex2() {
    firstVisibleItem2 = 0.obs;
  }
  void updateLastIndex2(int newValue) {
    lastVisibleItem2.value = newValue;
  }
  void resetLastIndex2() {
    lastVisibleItem2 = 0.obs;
  }

  void updateFirstIndex1_2(int newValue) {
    firstVisibleItem1_2.value = newValue;
  }
  void resetFirstIndex1_2() {
    firstVisibleItem1_2 = 0.obs;
  }
  void updateLastIndex1_2(int newValue) {
    lastVisibleItem1_2.value = newValue;
  }
  void resetLastIndex1_2() {
    lastVisibleItem1_2 = 0.obs;
  }

  void updateFirstIndex2_2(int newValue) {
    firstVisibleItem2_2.value = newValue;
  }
  void resetFirstIndex2_2() {
    firstVisibleItem2_2 = 0.obs;
  }
  void updateLastIndex2_2(int newValue) {
    lastVisibleItem2_2.value = newValue;
  }
  void resetLastIndex2_2() {
    lastVisibleItem2_2 = 0.obs;
  }

  void updateFirstIndex2_3(int newValue) {
    firstVisibleItem2_3.value = newValue;
  }
  void resetFirstIndex2_3() {
    firstVisibleItem2_3 = 0.obs;
  }
  void updateLastIndex2_3(int newValue) {
    lastVisibleItem2_3.value = newValue;
  }
  void resetLastIndex2_3() {
    lastVisibleItem2_3 = 0.obs;
  }

  void updateChatAutoAnswerHeight(double newValue) {
    //chatAutoAnswerHeight.value = newValue;
  }
  void updateChatStatusTick(int newValue) {
    chatStatusTick.value = newValue;
  }
  void updateInputTextHide(bool newValue) {
    isInputTextHide.value = newValue;
  }
  void updateChatAutoAnswerWidgetList(List<Widget> newList) {
    if(Config.contextForEmergencyBack != null){
      if(Config.contextForEmergencyBack!.mounted){
        autoAnswerWidgetList.clear();
        autoAnswerWidgetList.assignAll(newList);
      }else{
        Future.delayed(const Duration(milliseconds: 700), () {
          autoAnswerWidgetList.clear();
          autoAnswerWidgetList.assignAll(newList);
        });
      }
    }
  }
  void resetChatAutoAnswerWidgetList() {
    List<Widget> emptyList = [];
    autoAnswerWidgetList.clear();
    autoAnswerWidgetList.assignAll(emptyList);
  }
  void updateShowPickedFile(bool newValue) {
    if(Config.contextForEmergencyBack != null){
      if(Config.contextForEmergencyBack!.mounted){
        isShowPickedFile.value = newValue;
      }else{
        Future.delayed(const Duration(milliseconds: 700), () {
          isShowPickedFile.value = newValue;
        });
      }
    }

  }
  void updateShowStatus(bool newValue) {
    if(Config.contextForEmergencyBack != null){
      if(Config.contextForEmergencyBack!.mounted){
        isShowStatus.value = newValue;
      }else{
        Future.delayed(const Duration(milliseconds: 700), () {
          isShowStatus.value = newValue;
        });
      }
    }

  }
  void updateShowScrollBottom(bool newValue) {
    if(Config.contextForEmergencyBack != null){
      if(Config.contextForEmergencyBack!.mounted){
        isShowScrollBottom.value = newValue;
      }else{
        Future.delayed(const Duration(milliseconds: 700), () {
          isShowScrollBottom.value = newValue;
        });
      }
    }

  }
  void updateAutoAnswerWaiting(bool newValue) {
    if(Config.contextForEmergencyBack != null){
      if(Config.contextForEmergencyBack!.mounted){
        isAutoAnswerWaiting.value = newValue;
      }else{
        Future.delayed(const Duration(milliseconds: 700), () {
          isAutoAnswerWaiting.value = newValue;
        });
      }
    }

  }
  void updateHtmlLoad(bool newValue) {
    if(Config.contextForEmergencyBack != null){
      if(Config.contextForEmergencyBack!.mounted){
        isHtmlLoad.value = newValue;
      }else{
        Future.delayed(const Duration(milliseconds: 700), () {
          isHtmlLoad.value = newValue;
        });
      }
    }

  }

}