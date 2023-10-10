class ChatRoomInfoData {
  String chatRoomId; // uid
  int chatRoomType; //0 : upfin chat room  1: other chat room
  String chatRoomIconPath;
  String chatRoomTitle;
  String chatRoomSubTitle;
  String chatRoomLastMsg;
  String chatRoomLastMsgTime;
  int chatRoomLastMsgCnt;
  String chatRoomLoanStatus;

  ChatRoomInfoData(this.chatRoomId, this.chatRoomType, this.chatRoomIconPath, this.chatRoomTitle, this.chatRoomSubTitle,
      this.chatRoomLastMsg, this.chatRoomLastMsgTime, this.chatRoomLastMsgCnt, this.chatRoomLoanStatus);
  String printAiChatRoomInfoData(){
    return "chatRoomId: $chatRoomId\nchatRoomType: $chatRoomType\chatRoomIconPath: $chatRoomIconPath\n"
        "chatRoomAdditionalTitle: $chatRoomTitle\nchatRoomAdditionalContents: $chatRoomSubTitle"
        "\nchatRoomLastMsg: $chatRoomLastMsg\nchatRoomLastMsgTime: $chatRoomLastMsgTime\nchatRoomLastMsgCnt: $chatRoomLastMsgCnt\nchatRoomLoanStatus: $chatRoomLoanStatus";
  }
}