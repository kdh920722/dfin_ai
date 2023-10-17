class ChatRoomInfoData {
  String chatRoomId; // uid
  String chatLoanUid; // uid
  int chatRoomType; //0 : upfin chat room  1: other chat room
  String chatRoomIconPath;
  String chatRoomTitle;
  String chatRoomSubTitle;
  String chatRoomMsgInfo;
  String chatRoomLastMsg;
  String chatRoomLastMsgTime;
  int chatRoomLastMsgCnt;
  String chatRoomLoanStatus;
  String loanMinRate;
  String loanMaxLimit;

  ChatRoomInfoData(this.chatRoomId, this.chatLoanUid, this.chatRoomType, this.chatRoomIconPath, this.chatRoomTitle, this.chatRoomSubTitle,
      this.chatRoomMsgInfo, this.chatRoomLastMsg, this.chatRoomLastMsgTime, this.chatRoomLastMsgCnt, this.chatRoomLoanStatus, this.loanMinRate, this.loanMaxLimit);
  String printAiChatRoomInfoData(){
    return "chatRoomId: $chatRoomId\nchatLoanUid: $chatLoanUid\nchatRoomType: $chatRoomType\chatRoomIconPath: $chatRoomIconPath\n"
        "chatRoomAdditionalTitle: $chatRoomTitle\nchatRoomAdditionalContents: $chatRoomSubTitle"
        "\nchatRoomLastMsg: $chatRoomLastMsg\nchatRoomLastMsgTime: $chatRoomLastMsgTime\nchatRoomLastMsgCnt: $chatRoomLastMsgCnt\nchatRoomLoanStatus: $chatRoomLoanStatus";
  }
}