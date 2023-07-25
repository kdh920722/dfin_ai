import 'dart:async';
import 'dart:convert';
import 'package:openai_client/openai_client.dart';

import '../utils/common_utils.dart';

class ApiController{

  static final ApiController _instance = ApiController._internal();
  factory ApiController() => _instance;
  ApiController._internal();

  // Create the configuration
  static const conf = OpenAIConfiguration(
    apiKey: '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',
  );
  // Create a new client
  static final client = OpenAIClient(
    configuration: conf,
    enableLogging: true,
  );

  static bool isFirstConversation = true;
  static String prompt = "Hi, my name is 'KDH'";

  static Future<String> sendAndReceiveTextToGPT(String message) async {
    try{
      if(isFirstConversation) {
        prompt += "Human: $message";
      } else {
        prompt = message;
      }
      var result = await client.completions.create(
          model: 'text-davinci-003',
          prompt: prompt,
          temperature: 0.47,
          maxTokens: 150,
          topP: 1,
          frequencyPenalty: 0.0,
          presencePenalty: 0.6,
      ).data;
      String resultMessage = result.choices[0].text.replaceAll('\n\n', '');
      CommonUtils.log("i", "result : $resultMessage");
      isFirstConversation = false;
      return resultMessage;
    }catch(ex){
      return "error";
    }
  }
}