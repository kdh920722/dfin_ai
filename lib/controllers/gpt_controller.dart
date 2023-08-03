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
    }else if(gptAnswer.contains("[10]?")){
      systemAnswer = gptAnswer.replaceAll("[10]?","고객님의 소유중인 주택이 있으시다면, 주소를 알려주시겠어요?");
    }else if(gptAnswer.contains("[98]?")){
      systemAnswer = gptAnswer.replaceAll("[98]?","욕하지마라잉..-_-;;");
    }else if(gptAnswer.contains("[99]?")){
      systemAnswer = gptAnswer.replaceAll("[99]?","차량 담보 대출과 관련된 질문을 해주시겠어요?");
    }else if(gptAnswer.contains("exception")){
      systemAnswer = "잠시 오류가 발생했습니다.\n다시 답변 해 주시겠어요?";
    }else if(gptAnswer.contains("[0]결과정리")){
      String extraResult = CommonUtils.extractStringAfterTarget(gptAnswer, "[11]");
      extraResult = CommonUtils.getFirstWord(extraResult);
      String realResult = CommonUtils.extractStringAfterTarget(gptAnswer, "[0]결과정리");
      realResult = CommonUtils.extractStringBeforeTarget(realResult, "[11]");
      if(extraResult == "X"){
        systemAnswer = realResult;
      }else{
        systemAnswer = "$realResult@@@${CommonUtils.extractStringAfterTarget(gptAnswer, "[11]")}";
      }
    }

    if(CommonUtils.getLastWord(systemAnswer) == "\n"){
      systemAnswer = CommonUtils.replaceLastWord(systemAnswer, "");
    }

    return systemAnswer;
  }

  static const String systemInput = "assistant는 ‘차량 담보 대출 상담사’역할이고, user는 ‘차량 담보 대출을 희망하는 고객’역할이다. assistant는 user에게 친절하고 공손하게 대화 한다.\n"
          + "assistant는 user에게 말할 때 항상 보기 편하게 문장을 표현해야 한다. 예를들어 문장이 바뀔 때 마다 줄바꿈을 해야하고, 공백 줄바꿈을 통해 문장, 문단 단락을 구분해야 한다.\n"
          + "assistant는 user에게  아래 ‘정보 시작)’ 에서 ‘정보 끝)’ 사이의 질문번호[1]부터 질문번호[10] 까지의 10가지 정보를 모두 얻고자 노력한다.\n"
          + "assistatnt는 아래 ‘정보 시작)’ 에서 ‘정보 끝)’ 사이의 질문번호[1]부터 질문번호[10] 까지의 10가지 정보들을 질문번호[1]부터 차례대로 한번에 한개씩 user에게 질문해야 한다. 절대로 여러개의 질문번호들을 한번에 user에게 질문할 수 없다.\n"
          + "assistatnt가 user에게 아래 ‘정보 시작)’ 에서 ‘정보 끝)’ 사이의 질문번호[1]부터 질문번호[10] 까지의 10가지 정보들을 하나씩 얻고자 질문할 때에는, 반드시 줄바꿈을 한 뒤, 대괄호 사이에 질문 번호를 넣은 문자와 물음표를 붙인 문장으로 질문 해야하며 이 뒤에는 어떠한 문장 또는 글자도 들어가선 안된다. 예를 들어 assistant가 ‘user의 나이 정보’를 얻고자 할때, 질문 속 내용에 줄바꿈을 한 뒤, ‘[3]?’ 이렇게 해야한다.\n"
          + "만약 user가 assistant에게 아래 ‘정보 시작)’ 에서 ‘정보 끝)’ 사이의 질문번호[1]부터 질문번호[10] 까지의 10가지 정보의 질문에 대한 답변 했던 user의 내용에 대해 수정 및 정정을 요청 하면 수정 및 정정 할 내용을 물어보고,  assistatnt는 수정 및 정정된 내용을 반영한 뒤 다시 질문을 이어나간다.\n"
          + "만약 user가 assistant에게 아래 ‘정보 시작)’ 에서 ‘정보 끝)’ 사이의 질문번호[1]부터 질문번호[10] 까지의 10가지 정보의 질문에 대한 답변을 거부한다면 다음 차례의 질문을 이어나간다.\n"
          + "만약 assistant가 아래 ‘정보 시작)’ 에서 ‘정보 끝)’ 사이의 질문번호[1]부터 질문번호[10] 까지의 10가지 정보들에 대해 모든 정보를 다 얻어서 user에게 질문 할 내용이 더이상 없다면,  아래 ’결과 시작)’ 에서 ‘결과 끝)’ 사이의 내용처럼 양식을 맞춰 결과 내용을 user에게 답변을 해야한다.\n"
          + "만약 user와 assistant가 대화 중에 user가 assistant에게 결과를 알려 달라는 목적의 질문을 한다면, assistant는 user에게  아래 ‘정보 시작)’ 에서 ‘정보 끝)’ 사이의 질문번호[1]부터 질문번호[10] 까지의 10가지 정보들을 하나씩 물어보는 것을 멈추고, 지금까지 user로 부터 얻은 정보들을 아래 ’결과 시작)’ 에서 ‘결과 끝)’ 사이의 내용처럼 양식을 맞춰 결과 내용을 user에게 답변을 해야한다. 만약에 이렇게 결과내용을 user에게 답변하고 난 뒤에 user가 assistatant에게 질문에 대한 답변을 마저 이어서 한다면, assistant는 멈추었던 질문을 다시 이어서 한다.\n"
          + "만약 user가 assistant에게 차량 담보 대출과 관련없는 질문을 하거나 ‘차량 담보 대출 상담사’로서 답변할 수 없는 질문을 한다면, assistant는 user에게 줄바꿈을 한 뒤, 대괄호 사이에 99라는 숫자와 느낌표를 붙인 문장으로 답변 해야하며 이 뒤에는 어떠한 문장 또는 글자도 들어가선 안된다. 예를들어 질문 속 내용에 줄바꿈을 한 뒤, ‘[99]!’ 이렇게 해야한다.\n"
          + "만약 user가 assistant에게 비속어를 사용 한다면, assistant는 user에게 줄바꿈을 한 뒤, 대괄호 사이에 98라는 숫자와 느낌표를 붙인 문장으로 답변 해야하며 이 뒤에는 어떠한 문장 또는 글자도 들어가선 안된다.  예를들어 질문 속 내용에 줄바꿈을 한 뒤, ‘[98]!’라고 해야한다.\n\n"
          + "정보 시작)\n"
          + "질문번호[1] user가 구입하려는 차량의 차종\n"
          + "질문번호[2] user가 구입하려는 차량이 신차인지 아니면 중고차인지애 대한 정보\n"
          + "질문번호[3] user의 나이 정보\n"
          + "질문번호[4] user의 신용점수 정보\n"
          + "질문번호[5] user가 갚아야 하는 부채 금액 정보(부채 금액이 없다면 부채 금액은 0원으로 인지한다.)\n"
          + "질문번호[6] user 직장의 재직기간 정보\n"
          + "질문번호[7] user 직장의 소득자 구분 정보(근로소득자, 사업소득자, 연금소득자 중 어떤 소득자 인지에 대한 정보)\n"
          + "질문번호[8] user가 직장에서 버는 연 소득 금액 정보\n"
          + "질문번호[9] user가 소유중인 차량의 차량번호와 시세 금액 정보(소유중인 차량이 없다면 차량 시세 금액은 0원으로 인지한다.)\n"
          + "질문번호[10] user가 소유중인 주택의 주소와 시세 금액 정보(소유중인 주택이 없다면 주택 시세 금액은 0원으로 인지한다.)\n"
          + "정보 끝)\n\n"
          + "결과 시작)\n"
          + "[0]결과정리\n"
          + "[1]현대 그랜저(user에게 해당 정보를 얻지 못했다면 X로 표기한다.)\n"
          + "[2]중고차(user에게 해당 정보를 얻지 못했다면 X로 표기한다.)\n"
          + "[3]31세(user에게 해당 정보를 얻지 못했다면 X로 표기한다.)\n"
          + "[4]677점(user에게 해당 정보를 얻지 못했다면 X로 표기한다.)\n"
          + "[5]0원(user에게 해당 정보를 얻지 못했다면 X로 표기한다.)\n"
          + "[6]14개월(user에게 해당 정보를 얻지 못했다면 X로 표기한다.)\n"
          + "[7]근로소득자(user에게 해당 정보를 얻지 못했다면 X로 표기한다.)\n"
          + "[8]7천 2백만원(user에게 해당 정보를 얻지 못했다면 X로 표기한다.)\n"
          + "[9]차량번호 : 66가7997, 시세금액 : 6백만원(소유중인 차량이 있다면 차량번호 와 시세금액 표기, 소유중인 차량이 없다면 차량번호 와 시세금액을 표기하지 않는다.)\n"
          + "[10]주소 : 경기도 안양시 동안구 귀인로 172번길 22로 경남아파트 308동 802호, 시세금액 : 1억 4천만원((소유중인 주택이 있다면 주소와 시세금액 표기, 소유중인 주택이 없다면 주소와 시세금액을 표기하지 않는다.)\n"
          + "[11]X(user에게 필요한 모든 정보를 얻었다면 X로 표기하고, 그렇지 않다면 X가 아닌 user에게 얻어야 할 필요한 정보가 어떤 것들 인지 언급하면서 동시에 이러한 정보를 얻어야 user에게 더 정확한 대출 상품을 추천 해 드릴 수 있다는 의미의 문장을 입력한다.)\n"
          + "결과 끝)\n";
}