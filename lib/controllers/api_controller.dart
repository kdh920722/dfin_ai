import 'dart:async';
import 'dart:convert';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:openai_client/openai_client.dart';
import 'package:http/http.dart' as http;
import '../utils/common_utils.dart';

class ApiController{

  static final ApiController _instance = ApiController._internal();
  factory ApiController() => _instance;
  ApiController._internal();

  static const String apiKey = "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";


  /// ------------------------------------------------------------------------------------------------------------------------ ///
  // Create the configuration
  static const conf = OpenAIConfiguration(
    apiKey: apiKey,
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
  /// ------------------------------------------------------------------------------------------------------------------------ ///

  static final openAI = OpenAI.instance.build(token: apiKey,baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),enableLog: true);

  /// work only with gpt-turbo-0613,gpt-4-0613
  static Future<String> sendAndReceiveTextToGPT3(String message) async {
    try{
      final request = ChatCompleteText(messages: [Messages(role: Role.user, content: message)], maxToken: 200, model: Gpt4ChatModel());
      final response = await openAI.onChatCompletion(request: request);
      String resultMessage = "";
      for (var element in response!.choices) {
        resultMessage += "${element.message!.content}\n";
      }
      return resultMessage.replaceAll('\n\n', '');
    }catch(ex){
      return "exception : ${ex.toString()}";
    }

  }

  /// ------------------------------------------------------------------------------------------------------------------------ ///
  static Future<String> sendAndReceiveTextToGPT2(String message) async {
    String model = "text-davinci-003";
    try{
      var response = await http.post(
        Uri.parse('https://api.openai.com/v1/engines/$model/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'prompt': message,
          'max_tokens': 100,
          'temperature': 0.4,
          'n': 1,
          'stop': '.',
          'top_p': 1,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes))['choices'][0]['text'].replaceAll('\n\n', '');
      } else {
        return "${response.statusCode} error";
      }
    }catch(ex){
      return "exception : ${ex.toString()}";
    }
  }
  /// ------------------------------------------------------------------------------------------------------------------------ ///

}