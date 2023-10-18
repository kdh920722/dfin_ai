class ChatMessageInfoData {
  String chatId;
  String chatRoomId;
  String message;
  String messageTime;
  String messageType;
  String senderName;
  String messageInfo;

  ChatMessageInfoData(this.chatId, this.chatRoomId, this.message, this.messageTime, this.messageType, this.senderName, this.messageInfo);
  String printChatMessageRoomInfoData(){
    return "chatId: $chatId\n"
        "chatRoomId: $chatRoomId\n"
        "message: $message\n"
        "messageTime: $messageTime\n"
        "messageType: $messageType\n"
        "senderName: $senderName";
  }
}