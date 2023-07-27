import 'dart:async';
import 'dart:convert';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:http/http.dart' as http;

class ApiController{

  static final ApiController _instance = ApiController._internal();
  factory ApiController() => _instance;
  ApiController._internal();

  /// ------------------------------------------------------------------------------------------------------------------------ ///
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
    }catch(ex){
      return "exception : ${ex.toString()}";
    }
  }

  /// ------------------------------------------------------------------------------------------------------------------------ ///
  static Future<String> sendAndReceiveTextToGPTUsingHttp(String message) async {
    String model = "text-davinci-003";
    try{
      var response = await http.post(
        Uri.parse('https://api.openai.com/v1/engines/$model/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $gptApiKey',
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