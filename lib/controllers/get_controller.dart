import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:upfin/datas/accident_info_data.dart';
import 'package:upfin/datas/chat_message_info_data.dart';
import 'package:upfin/datas/chatroom_info_data.dart';
import '../utils/common_utils.dart';
import 'package:get/get.dart';

class GetController extends GetxController {
  static GetController get to => Get.find();
  RxInt loadingPercent = 0.obs;
  RxBool isWait = false.obs;
  RxBool isConfirmed = false.obs;
  RxBool isAllSubscribed = false.obs;
  RxString preLoanPrice = "만원".obs;
  RxString wantLoanPrice = "만원".obs;

  RxList<AccidentInfoData> accidentInfoDataList = <AccidentInfoData>[].obs;
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

  void updatePercent(int newValue) {
    loadingPercent.value += newValue;
  }
  void resetPercent() {
    loadingPercent = 0.obs;
  }


  void updateWait(bool newValue) {
    isWait.value = newValue;
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
    CommonUtils.log("i", "accidentInfoDataList length : ${accidentInfoDataList.length}");
  }
  void resetAccdientInfoList() {
    List<AccidentInfoData> emptyList = [];
    accidentInfoDataList.clear();
    accidentInfoDataList.assignAll(emptyList);
    CommonUtils.log("i", "accidentInfoDataList length : ${accidentInfoDataList.length}");
  }

  void updateChatLoanInfoList(List<ChatRoomInfoData> newList) {
    chatLoanInfoDataList.clear();
    for(int i=0; i < newList.length; i++){
      var jsonData = jsonDecode(newList[i].chatRoomMsgInfo);
      Map<String, dynamic> msg = jsonData;
      List<dynamic> listMsg = msg["data"];
      listMsg.sort((a,b) => b["id"].compareTo(a["id"]));
      msg.remove("data");
      msg["data"] = listMsg;
      newList[i].chatRoomMsgInfo = jsonEncode(msg);
    }
    newList.sort((a,b) => jsonDecode(b.chatRoomMsgInfo)["data"][0]["id"].compareTo(jsonDecode(a.chatRoomMsgInfo)["data"][0]["id"]));

    chatLoanInfoDataList.assignAll(newList);
    CommonUtils.log("i", "loanInfoDataList length : ${chatLoanInfoDataList.length}");
  }
  void resetChatLoanInfoList() {
    List<ChatRoomInfoData> emptyList = [];
    chatLoanInfoDataList.clear();
    chatLoanInfoDataList.assignAll(emptyList);
    CommonUtils.log("i", "loanInfoDataList length : ${chatLoanInfoDataList.length}");
  }

  void addChatMessageInfoList(ChatMessageInfoData newItem) {
    chatMessageInfoDataList.add(newItem);
    CommonUtils.log("i", "chatMessageInfoDataList length : ${chatLoanInfoDataList.length}");
  }
  void resetChatMessageInfoList() {
    List<ChatMessageInfoData> emptyList = [];
    chatMessageInfoDataList.clear();
    chatMessageInfoDataList.assignAll(emptyList);
    CommonUtils.log("i", "chatMessageInfoDataList length : ${chatMessageInfoDataList.length}");
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
    chatAutoAnswerHeight.value = newValue;
  }
  void updateChatStatusTick(int newValue) {
    chatStatusTick.value = newValue;
  }
  void updateInputTextHide(bool newValue) {
    isInputTextHide.value = newValue;
  }
  void updateChatAutoAnswerWidgetList(List<Widget> newList) {
    autoAnswerWidgetList.clear();
    autoAnswerWidgetList.assignAll(newList);
  }
  void resetChatAutoAnswerWidgetList() {
    List<Widget> emptyList = [];
    autoAnswerWidgetList.clear();
    autoAnswerWidgetList.assignAll(emptyList);
  }
  void updateShowPickedFile(bool newValue) {
    isShowPickedFile.value = newValue;
  }
  void updateShowStatus(bool newValue) {
    isShowStatus.value = newValue;
  }

}