import 'dart:async';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:firebase_database/firebase_database.dart';
import '../utils/common_utils.dart';

class GptController{
  static final GptController _instance = GptController._internal();
  factory GptController() => _instance;
  GptController._internal();

  static String gptApiKey = "";
  static OpenAI? openAI;
  static Future<String> sendAndReceiveTextToGPTUsingLib(List<Messages> messageList) async {
    try{
      openAI = OpenAI.instance.build(token: gptApiKey, baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 60)),enableLog: true);
      final request = ChatCompleteText(messages: messageList, maxToken: 1024, model: Gpt4ChatModel());
      final response = await openAI!.onChatCompletion(request: request);
      String resultMessage = "";
      for (var element in response!.choices) {
        resultMessage += "${element.message!.content}\n";
      }
      return resultMessage;
    }catch(e){
      CommonUtils.log("e", "gpt req error : ${e.toString()}");
      return "exception : ${e.toString()}";
    }
  }

  static Future<void> getGPTApiKey(Function(bool) callback) async{
    try{
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('WEBCHAT/API/gpt').get();
      if (snapshot.exists) {
        GptController.gptApiKey =  snapshot.value.toString();
        callback(true);
      } else {
        callback(false);
      }
    }catch(e){
      CommonUtils.log("e", "gpt init error : ${e.toString()}");
      callback(false);
    }
  }
}