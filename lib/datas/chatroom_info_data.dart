class ChatRoomInfoData {
  String chatRoomId; // uid
  String chatLoanUid; // uid
  String chatRoomType; // 1 : accident,  3 : car
  String chatRoomIconPath; // company icon or path
  String chatRoomTitle;
  String chatRoomSubTitle;
  String chatRoomMsgInfo;
  String chatRoomLoanStatus;
  String loanMinRate;
  String loanMaxLimit;

  ChatRoomInfoData(this.chatRoomId, this.chatLoanUid, this.chatRoomType, this.chatRoomIconPath, this.chatRoomTitle, this.chatRoomSubTitle,
      this.chatRoomMsgInfo, this.chatRoomLoanStatus, this.loanMinRate, this.loanMaxLimit);
  String printAiChatRoomInfoData(){
    return "chatRoomId: $chatRoomId\nchatLoanUid: $chatLoanUid\nchatRoomType: $chatRoomType\chatRoomIconPath: $chatRoomIconPath\n"
        "chatRoomAdditionalTitle: $chatRoomTitle\nchatRoomAdditionalContents: $chatRoomSubTitle"
        "\nchatRoomLoanStatus: $chatRoomLoanStatus";
  }
}