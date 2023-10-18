import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:upfin/utils/common_utils.dart';
import 'package:upfin/utils/ui_utils.dart';

class StringConfig{
  static String agreeContents1 = "제 1 조 (목적)\n이 약관은 YSMETA(이하 \'사이트\'라 합니다)에서 제공하는 인터넷서비스(이하 \'서비스\'라 합니다)의 이용 조건 및 절차에 관한 기본적인 사항을 규정함을 목적으로 합니다."
      "\n\n제 2 조 (약관의 효력 및 변경)\n\n① 이 약관은 서비스 화면이나 기타의 방법으로 이용고객에게 공지함으로써 효력을 발생합니다."
      "\n② 사이트는 이 약관의 내용을 변경할 수 있으며, 변경된 약관은 제1항과 같은 방법으로 공지 또는 통지함으로써 효력을 발생합니다."
      "\n\n제 3 조 (용어의 정의)\n이 약관에서 사용하는 용어의 정의는 다음과 같습니다."
      "\n① 회원 : 사이트와 서비스 이용계약을 체결하거나 이용자 아이디(ID)를 부여받은 개인 또는 단체를 말합니다."
      "\n② 신청자 : 을 신청하는 개인 또는 단체를 말합니다."
      "\n③ 아이디(ID) : 회원의 식별과 서비스 이용을 위하여 회원이 정하고 사이트가 승인하는 문자와 숫자의 조합을 말합니다."
      "\n④ 비밀번호 : 회원이 부여 받은 아이디(ID)와 일치된 회원임을 확인하고, 회원 자신의 비밀을 보호하기 위하여 회원이 정한 문자와 숫자의 조합을 말합니다."
      "\n⑤ 해지 : 사이트 또는 회원이 서비스 이용계약을 취소하는것을 말합니다.";

  static String bannerTextForTest = "대출금리 연 20%이내 (연체금리는 약정금리 +3% 이내, 최대 연20% 이내)l연체금 보유, 신용점수 등 낮음등의 사유로 대출이 제한될 수 있습니다."
      "l담보 물건, 담보종류 등에 따라 대출조건(이자율,기한등)이 차등 적용되며, 담보물이 부적합할 경우 대출이 제한될 수 있습니다.l담보대출의 경우 중도상환수수료, "
      "담보권설정비용이 발생 될 수 있습니다.l중도상환수수료는 최대3%로 대부업법에 따른 최고 이자율이내에서 대출기간에 따라 차등 적용 됩니다."
      "l예시:이자는 매월 약정일에 부과. 100만원을 연 20%로 12개월 동안 원리금균등상환 시 총 납부금액 1,111,662원l일정기간 납부해야 할 원리금이 "
      "연체될 경우에 계약만료 기한이 도래하기 전에 모든 원리금을 변제해야 할 의무가 발생할 수 있습니다.l금융소비자는 금소법 제19조제1항에 따라 해당상품 또는 서비스에 대하여 설명을 받을 권리가 있으며, "
      "그 설명을 듣고 내용을 충분히 이해한 후 거래하시기 바랍니다.l계약을 체결하기 전 자세한 내용은 상품설명서와 약관을 읽어보시기 바랍니다.과도한 빚은 당신에게 큰 불행을 안겨줄 수 있습니다."
      "대출 시, 상환능력에 비해 대출금이 과도할 경우 귀하의 신용등급 또는 개인신용평점이 하락할 수 있습니다."
      "중개수수료를 요구하거나 받는 것은 불법 입니다.";

  /*
/n간격/n --> 치환
@제목
@소제목
@본문
   */
  static String testAgreeText =
          "@제목큰제목1여기에@제목"+
              "@소제목큰제목1의소제목1여기에@소제목"+
              "@본문소제목1의본문내용여기에@본문"+
              "@소제목큰제목1의소제목2여기에@소제목"+
              "@본문소제목2의본문내용여기에@본문"+
              "@소제목큰제목1의소제목3여기에@소제목"+
              "@본문소제목3의본문내용여기에@본문"+
              "@소안내큰제목1의안내문구여기에@소안내"+ //(*각 제목 부분의 맨 마지막에 위치)

          "@제목큰제목2여기에@제목"+
              "@소제목큰제목2의소제목1여기에@소제목"+
              "@본문큰제목2의소제목2의본문내용여기에@본문"+
              "@소제목큰제목2의소제목2여기에@소제목"+
              "@본문큰제목2의소제목2의본문내용여기에@본문"+
              "@소제목큰제목2의소제목3여기에@소제목"+
              "@본문큰제목2의소제목3의본문내용여기에@본문"+
              "@소안내큰제목2의안내문구여기에@소안내"+ //(*각 제목 부분의 맨 마지막에 위치)

          "@제목큰제목3여기에@제목"+
              "@소제목큰제목3의소제목1여기에@소제목"+
              "@본문큰제목3의소제목2의본문내용여기에@본문"+
              "@소제목큰제목3의소제목2여기에@소제목"+
              "@본문큰제목3의소제목2의본문내용여기에@본문"+
              "@소제목큰제목3의소제목3여기에@소제목"+
              "@본문큰제목3의소제목3의본문내용여기에@본문"+
              "@소안내큰제목3의안내문구여기에@소안내"+ //(*각 제목 부분의 맨 마지막에 위치)

          "@안내전체주의사항안내여기에@안내" //(*전체의 맨 마지막에 위치)
  ;
  static Widget getAgreeContents(String agreeText){
    List<Widget> widgetList = [];
    try{
      List<String> textList = agreeText.split("@제목");
      for (int i = 0; i < textList.length; i++) {
        if (i % 2 != 0) {
          if(textList[i] != ""){
            // @제목 위간격
            if(i != 1) widgetList.add(UiUtils.getMarginBox(0, 3.h));

            // @제목 문구
            widgetList.add(Padding(padding: EdgeInsets.only(left: 2.w, right: 0.w, top: 0.w, bottom: 0.w),
                child: UiUtils.getTextWithFixedScale(textList[i], 22.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)));

            // @제목 아래간격
            widgetList.add(UiUtils.getMarginBox(0, 1.h));
          }
        } else {
          if(textList[i] != ""){
            List<String> subTextList = textList[i].split("@소제목");
            for(int i2 = 0; i2 < subTextList.length; i2++){
              if (i2 % 2 != 0) {
                if(subTextList[i2] != ""){
                  // @소제목 위간격
                  if(i2 != 1) widgetList.add(UiUtils.getMarginBox(0, 2.h));

                  // @소제목 문구
                  widgetList.add(Padding(padding: EdgeInsets.only(left: 4.w, right: 0.w, top: 0.w, bottom: 0.w),
                      child: UiUtils.getTextWithFixedScale(subTextList[i2], 16.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null)));

                  // @소제목 아래간격
                  widgetList.add(UiUtils.getMarginBox(0, 0.5.h));
                }
              }else{
                if(subTextList[i2] != ""){
                  List<String> contentsTextList = subTextList[i2].split("@본문");
                  for(int i3 = 0; i3 < contentsTextList.length; i3++){
                    if (i3 % 2 != 0) {
                      if(contentsTextList[i3] != ""){
                        // @본문 위간격
                        widgetList.add(UiUtils.getMarginBox(0, 1.h));

                        // @본문 문구
                        widgetList.add(Padding(padding: EdgeInsets.only(left: 8.w, right: 0.w, top: 0.w, bottom: 0.w),
                            child: UiUtils.getTextWithFixedScale(contentsTextList[i3], 12.sp, FontWeight.w400, ColorStyles.upFinBlack, TextAlign.start, null)));

                        // @본문 아래간격
                        widgetList.add(UiUtils.getMarginBox(0, 1.h));
                      }
                    }else if(i2 == subTextList.length-1 && i3 == contentsTextList.length-1){
                      List<String> alarmContentsTextList = contentsTextList[i3].split("@소안내");
                      for(int i4 = 0; i4 < alarmContentsTextList.length; i4++){
                        if(i4 % 2 != 0){
                          if(contentsTextList[i3] != ""){
                            // @소안내 위간격
                            widgetList.add(UiUtils.getMarginBox(0, 1.h));

                            // @소안내 문구
                            widgetList.add(Padding(padding: EdgeInsets.only(left: 4.w, right: 0.w, top: 0.w, bottom: 0.w),
                                child: UiUtils.getTextWithFixedScale(alarmContentsTextList[i4], 12.sp, FontWeight.w400, ColorStyles.upFinRed, TextAlign.start, null)));

                            // @소안내 아래간격
                            widgetList.add(UiUtils.getMarginBox(0, 0.5.h));
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          if(i == textList.length-1){
            // @안내 문구(전체 주의사항 문구)
            List<String> bigAlarmContentsTextList = textList[i].split("@안내");
            for(int i5 = 0; i5 < bigAlarmContentsTextList.length; i5++){
              if(i5 % 2 != 0){
                if(bigAlarmContentsTextList[i5] != ""){
                  // @안내 위간격
                  widgetList.add(UiUtils.getMarginBox(0, 3.h));

                  // @안내 문구
                  widgetList.add(Padding(padding: EdgeInsets.only(left: 2.w, right: 0.w, top: 0.w, bottom: 0.w),
                      child: UiUtils.getTextWithFixedScale(bigAlarmContentsTextList[i5], 18.sp, FontWeight.w600, ColorStyles.upFinRed, TextAlign.start, null)));

                  // @안내 아래간격
                  widgetList.add(UiUtils.getMarginBox(0, 2.h));
                }
              }
            }
          }
        }
      }
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: widgetList);
    }catch(error){
      CommonUtils.log("e", "agree contents parsing error : $error");
      return Container();
    }
  }
}