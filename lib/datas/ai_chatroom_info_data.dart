class AiChatRoomInfoData {
  int chatRoomId; // uid
  int chatRoomType; //0 : upfin chat room  1: other chat room
  String chatRoomIconPath;
  String chatRoomAdditionalTitle;
  String chatRoomAdditionalContents;
  String chatRoomLastMsg;
  String chatRoomLastMsgTime;
  int chatRoomLastMsgCnt;

  AiChatRoomInfoData(this.chatRoomId, this.chatRoomType, this.chatRoomIconPath, this.chatRoomAdditionalTitle, this.chatRoomAdditionalContents,
      this.chatRoomLastMsg, this.chatRoomLastMsgTime, this.chatRoomLastMsgCnt);
  String printAiChatRoomInfoData(){
    return "chatRoomId: $chatRoomId\nchatRoomType: $chatRoomType\chatRoomIconPath: $chatRoomIconPath\n"
        "chatRoomAdditionalTitle: $chatRoomAdditionalTitle\nchatRoomAdditionalContents: $chatRoomAdditionalContents"
        "\nchatRoomLastMsg: $chatRoomLastMsg\nchatRoomLastMsgTime: $chatRoomLastMsgTime\nchatRoomLastMsgCnt: $chatRoomLastMsgCnt";
  }
}