import 'dart:async';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:firebase_database/firebase_database.dart';
import '../utils/common_utils.dart';

class GptController{
  static final GptController _instance = GptController._internal();
  factory GptController() => _instance;
  GptController._internal();

  static String resultSplitPattern = "@@@";
  static String carNumResultSplitPattern = "CAR???";
  static String houseAddressResultSplitPattern = "HOUSE???";
  static String deletedResultSplitPattern = "DELETED???";
  static String gptApiKey = "";
  static OpenAI? openAI;

  static Future<String> sendAndReceiveTextToGPTUsingLib(List<Messages> messageList) async {
    try{
      openAI = OpenAI.instance.build(token: gptApiKey, baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 60)),enableLog: true);
      final request = ChatCompleteText(messages: messageList, model: GptTurbo0631Model(), temperature: 0.4);
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

  static Future<void> initGPT(Function(bool) callback) async{
    try{
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('UPFIN/API/gpt/key').get();
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

  static String convertGptAnswerToSystemAnswer(String gptAnswer){
    CommonUtils.log('i', 'gptAnswer : $gptAnswer');
    String systemAnswer = "";
    if(gptAnswer.contains("[1]?")){
      systemAnswer = gptAnswer.replaceAll("[1]?","구입 하시려는 차량의 모델을 알려 주시겠어요?");
    }else if(gptAnswer.contains("[2]?")){
      systemAnswer = gptAnswer.replaceAll("[2]?","구입 하시려는 차량이 신차 인가요? 아니면 중고차 인가요?");
    }else if(gptAnswer.contains("[3]?")){
      systemAnswer = gptAnswer.replaceAll("[3]?","고객님의 나이를 알려 주시겠어요?");
    }else if(gptAnswer.contains("[4]?")){
      systemAnswer = gptAnswer.replaceAll("[4]?","고객님의 신용점수를 알려 주시겠어요?");
    }else if(gptAnswer.contains("[5]?")){
      systemAnswer = gptAnswer.replaceAll("[5]?","현재 고객님께서 가지고 계신 부채 금액이 얼마인지 알려 주시겠어요?");
    }else if(gptAnswer.contains("[6]?")){
      systemAnswer = gptAnswer.replaceAll("[6]?","고객님의 현재 직장(직업)의 재직기간을 알려 주시겠어요?");
    }else if(gptAnswer.contains("[7]?")){
      systemAnswer = gptAnswer.replaceAll("[7]?","고객님은 근로소득자,사업소득자,연금소득자 중 어떤 소득자 이신가요?");
    }else if(gptAnswer.contains("[8]?")){
      systemAnswer = gptAnswer.replaceAll("[8]?","고객님의 연 소득 금액을 알려 주시겠어요?");
    }else if(gptAnswer.contains("[9]?")){
      systemAnswer = gptAnswer.replaceAll("[9]?","고객님께서 소유중인 차량이 있으시다면, 차량번호를 알려주시겠어요?");
    }else if(gptAnswer.contains("[9A]")){
      String extraResult = CommonUtils.extractStringAfterTarget(gptAnswer, "[9A]");
      List<String> carNumResult = extraResult.split("?");
      systemAnswer = carNumResult[0] + carNumResultSplitPattern;
    }else if(gptAnswer.contains("[10]?")){
      systemAnswer = gptAnswer.replaceAll("[10]?","고객님의 소유중인 주택이 있으시다면, 주소를 알려주시겠어요?");
    }else if(gptAnswer.contains("[10A]")){
      String extraResult = CommonUtils.extractStringAfterTarget(gptAnswer, "[10A]");
      List<String> houseAddressResult = extraResult.split("?");
      systemAnswer = houseAddressResult[0] + houseAddressResultSplitPattern;
    }else if(gptAnswer.contains("[98]?")){
      systemAnswer = gptAnswer.replaceAll("[98]?","욕하지마라잉..-_-;;");
    }else if(gptAnswer.contains("[99]?")){
      systemAnswer = gptAnswer.replaceAll("[99]?","차량 담보 대출과 관련된 질문을 해주시겠어요?");
    }else if(gptAnswer.contains("[0]결과정리")){
      String extraResult = CommonUtils.extractStringAfterTarget(gptAnswer, "[11]");
      extraResult = CommonUtils.getFirstWord(extraResult);
      String realResult = CommonUtils.extractStringAfterTarget(gptAnswer, "[0]결과정리");
      realResult = CommonUtils.extractStringBeforeTarget(realResult, "[11]");
      if(extraResult == "X"){
        systemAnswer = "결과를 알려 드립니다.$resultSplitPattern$realResult$resultSplitPattern입력하신 정보가 맞는지 확인 해 주새요.";
      }else{
        systemAnswer = "미완성 결과를 알려 드립니다.$resultSplitPattern$realResult$resultSplitPattern${CommonUtils.extractStringAfterTarget(gptAnswer, "[11]")}";
      }
    }else if(gptAnswer.contains("exception")){
      systemAnswer = "잠시 오류가 발생했습니다.\n다시 답변 해 주시겠어요?";
    }

    systemAnswer = CommonUtils.deleteLastEnter(systemAnswer);
    return systemAnswer;
  }

  static String deleteUnnecessaryGptAnswer(String gptAnswer){
    String deletedGptAnswer = "";
    if(gptAnswer.contains("[1]?")){
      String frontMessage = CommonUtils.extractStringBeforeTarget(gptAnswer, "[1]?");
      String backMessage = CommonUtils.extractStringAfterTarget(gptAnswer, frontMessage);
      frontMessage = CommonUtils.deleteLastEnter(frontMessage);
      backMessage = CommonUtils.deleteLastEnter(backMessage);
      deletedGptAnswer = frontMessage+deletedResultSplitPattern+backMessage;
    }else if(gptAnswer.contains("[2]?")){
      String frontMessage = CommonUtils.extractStringBeforeTarget(gptAnswer, "[2]?");
      String backMessage = CommonUtils.extractStringAfterTarget(gptAnswer, frontMessage);
      frontMessage = CommonUtils.deleteLastEnter(frontMessage);
      backMessage = CommonUtils.deleteLastEnter(backMessage);
      deletedGptAnswer = frontMessage+deletedResultSplitPattern+backMessage;
    }else if(gptAnswer.contains("[3]?")){
      String frontMessage = CommonUtils.extractStringBeforeTarget(gptAnswer, "[3]?");
      String backMessage = CommonUtils.extractStringAfterTarget(gptAnswer, frontMessage);
      frontMessage = CommonUtils.deleteLastEnter(frontMessage);
      backMessage = CommonUtils.deleteLastEnter(backMessage);
      deletedGptAnswer = frontMessage+deletedResultSplitPattern+backMessage;
    }else if(gptAnswer.contains("[4]?")){
      String frontMessage = CommonUtils.extractStringBeforeTarget(gptAnswer, "[4]?");
      String backMessage = CommonUtils.extractStringAfterTarget(gptAnswer, frontMessage);
      frontMessage = CommonUtils.deleteLastEnter(frontMessage);
      backMessage = CommonUtils.deleteLastEnter(backMessage);
      deletedGptAnswer = frontMessage+deletedResultSplitPattern+backMessage;
    }else if(gptAnswer.contains("[5]?")){
      String frontMessage = CommonUtils.extractStringBeforeTarget(gptAnswer, "[5]?");
      String backMessage = CommonUtils.extractStringAfterTarget(gptAnswer, frontMessage);
      frontMessage = CommonUtils.deleteLastEnter(frontMessage);
      backMessage = CommonUtils.deleteLastEnter(backMessage);
      deletedGptAnswer = frontMessage+deletedResultSplitPattern+backMessage;
    }else if(gptAnswer.contains("[6]?")){
      String frontMessage = CommonUtils.extractStringBeforeTarget(gptAnswer, "[6]?");
      String backMessage = CommonUtils.extractStringAfterTarget(gptAnswer, frontMessage);
      frontMessage = CommonUtils.deleteLastEnter(frontMessage);
      backMessage = CommonUtils.deleteLastEnter(backMessage);
      deletedGptAnswer = frontMessage+deletedResultSplitPattern+backMessage;
    }else if(gptAnswer.contains("[7]?")){
      String frontMessage = CommonUtils.extractStringBeforeTarget(gptAnswer, "[7]?");
      String backMessage = CommonUtils.extractStringAfterTarget(gptAnswer, frontMessage);
      frontMessage = CommonUtils.deleteLastEnter(frontMessage);
      backMessage = CommonUtils.deleteLastEnter(backMessage);
      deletedGptAnswer = frontMessage+deletedResultSplitPattern+backMessage;
    }else if(gptAnswer.contains("[8]?")){
      String frontMessage = CommonUtils.extractStringBeforeTarget(gptAnswer, "[8]?");
      String backMessage = CommonUtils.extractStringAfterTarget(gptAnswer, frontMessage);
      frontMessage = CommonUtils.deleteLastEnter(frontMessage);
      backMessage = CommonUtils.deleteLastEnter(backMessage);
      deletedGptAnswer = frontMessage+deletedResultSplitPattern+backMessage;
    }else if(gptAnswer.contains("[9]?")){
      String frontMessage = CommonUtils.extractStringBeforeTarget(gptAnswer, "[9]?");
      String backMessage = CommonUtils.extractStringAfterTarget(gptAnswer, frontMessage);
      frontMessage = CommonUtils.deleteLastEnter(frontMessage);
      backMessage = CommonUtils.deleteLastEnter(backMessage);
      deletedGptAnswer = frontMessage+deletedResultSplitPattern+backMessage;
    }else if(gptAnswer.contains("[9A]")){
      String frontMessage = CommonUtils.extractStringBeforeTarget(gptAnswer, "[9A]");
      String backMessage = CommonUtils.extractStringAfterTarget(gptAnswer, frontMessage);
      frontMessage = CommonUtils.deleteLastEnter(frontMessage);
      backMessage = CommonUtils.deleteLastEnter(backMessage);
      deletedGptAnswer = frontMessage+deletedResultSplitPattern+backMessage;
    }else if(gptAnswer.contains("[10]?")){
      String frontMessage = CommonUtils.extractStringBeforeTarget(gptAnswer, "[10]?");
      String backMessage = CommonUtils.extractStringAfterTarget(gptAnswer, frontMessage);
      frontMessage = CommonUtils.deleteLastEnter(frontMessage);
      backMessage = CommonUtils.deleteLastEnter(backMessage);
      deletedGptAnswer = frontMessage+deletedResultSplitPattern+backMessage;
    }else if(gptAnswer.contains("[10A]")){
      String frontMessage = CommonUtils.extractStringBeforeTarget(gptAnswer, "[10A]");
      String backMessage = CommonUtils.extractStringAfterTarget(gptAnswer, frontMessage);
      frontMessage = CommonUtils.deleteLastEnter(frontMessage);
      backMessage = CommonUtils.deleteLastEnter(backMessage);
      deletedGptAnswer = frontMessage+deletedResultSplitPattern+backMessage;
    }else if(gptAnswer.contains("[98]?")){
      String frontMessage = CommonUtils.extractStringBeforeTarget(gptAnswer, "[98]?");
      String backMessage = CommonUtils.extractStringAfterTarget(gptAnswer, frontMessage);
      frontMessage = CommonUtils.deleteLastEnter(frontMessage);
      backMessage = CommonUtils.deleteLastEnter(backMessage);
      deletedGptAnswer = frontMessage+deletedResultSplitPattern+backMessage;
    }else if(gptAnswer.contains("[99]?")){
      String frontMessage = CommonUtils.extractStringBeforeTarget(gptAnswer, "[99]?");
      String backMessage = CommonUtils.extractStringAfterTarget(gptAnswer, frontMessage);
      frontMessage = CommonUtils.deleteLastEnter(frontMessage);
      backMessage = CommonUtils.deleteLastEnter(backMessage);
      deletedGptAnswer = frontMessage+deletedResultSplitPattern+backMessage;
    }else if(gptAnswer.contains("[0]결과정리")){
      deletedGptAnswer = "끝$deletedResultSplitPattern$gptAnswer";
    }else if(gptAnswer.contains("exception")){
      deletedGptAnswer = "";
    }

    return deletedGptAnswer;
  }

  static const String systemInput = "";
}