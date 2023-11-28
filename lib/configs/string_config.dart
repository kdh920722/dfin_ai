import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:upfin/utils/common_utils.dart';
import 'package:upfin/utils/ui_utils.dart';

class StringConfig{
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