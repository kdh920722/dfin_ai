import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/configs/app_config.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/datas/ai_chatroom_info_data.dart';
import 'package:upfin/datas/loan_info_data.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import '../controllers/get_controller.dart';
import '../utils/common_utils.dart';
import '../utils/pop_result.dart';
import '../utils/ui_utils.dart';

class AppMainView extends StatefulWidget{
  @override
  AppMainViewState createState() => AppMainViewState();
}

class AppMainViewState extends State<AppMainView> with WidgetsBindingObserver{
  int viewTypeId = 1; // 1: MY / 2: AI어드바이저 / 3: 설정

  @override
  void initState(){
    CommonUtils.log("i", "AppMainView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppMainView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('i','AppMainView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('i','AppMainView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('i','AppMainView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('i','AppMainView paused');
        break;
      default:
        break;
    }
  }

  Widget _getMyView(){
    List<Widget> accidentWidgetList = [];
    for(var each in MyData.getAccidentInfoList()){
      bool isLoanHere = false;
      String accidentUid = "";
      String loanUid = "";
      List<LoanInfoData> loanInfoList = [];
      LoanInfoData? loanInfoData;
      for(var eachLoan in MyData.getLoanInfoList()){
        if(eachLoan.accidentUid == each.accidentUid){
          loanInfoList.add(eachLoan);
        }
      }
      loanInfoList.sort((a,b) => DateTime.parse(a.updatedDate).compareTo(DateTime.parse(b.updatedDate)));
      for(var eachLoan in loanInfoList){
        CommonUtils.log("i", eachLoan.printLoanData());
      }

      accidentWidgetList.add(
          Column(children: [
            UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinRealWhite, ColorStyles.upFinGray,
                Row(mainAxisSize: MainAxisSize.max, children: [
                  Expanded(flex: 15, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    UiUtils.getTextWithFixedScale(each.accidentCourtName, 14.sp, FontWeight.w600, ColorStyles.upFinTextAndBorderBlue, TextAlign.center, 1),
                    UiUtils.getMarginBox(0, 0.7.h),
                    UiUtils.getTextWithFixedScale("${each.accidentCaseNumberYear}${each.accidentCaseNumberType}${each.accidentCaseNumberNumber}", 16.sp,
                        FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null),
                    UiUtils.getMarginBox(0, 0.7.h),
                    UiUtils.getTextWithFixedScale("${each.accidentBankName} ${each.accidentBankAccount}", 10.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, 1),
                  ])),
                  Expanded(flex: 1, child: Icon(Icons.arrow_forward_ios_rounded, color: ColorStyles.upFinDarkGray, size: 5.5.w)),
                ]), () {
                  UiUtils.showLoadingPop(context);
                  LogfinController.getPrList("${each.accidentCaseNumberYear}${each.accidentCaseNumberType}${each.accidentCaseNumberNumber}", (isSuccessToGetOffers, _){
                    UiUtils.closeLoadingPop(context);
                    if(isSuccessToGetOffers){
                      Navigator.of(context).pushNamed(AppView.resultPrView.value).then((results) {
                        if (results is PopWithResults) {
                          PopWithResults popResult = results;
                          Map<String, dynamic> resultMap = popResult.results;
                          if(resultMap.containsKey("pop_result") && resultMap["pop_result"] == "update"){
                            setState(() {});
                          }
                        }
                      });
                    }else{
                      // findUidInAccidentInfoList 실패
                      CommonUtils.flutterToast("에러가 발생했습니다.");
                    }
                  });
                }),
            UiUtils.getMarginBox(0, 0.5.h),
            UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinWhiteSky,
                Row(mainAxisSize: MainAxisSize.max, children: [
                  Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(width: 50.w, child: Row(children: [
                      UiUtils.getImage(10.w, 10.w, Image.asset('assets/images/apple_icon.png')),
                      UiUtils.getMarginBox(2.w, 0),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        UiUtils.getTextWithFixedScale("OK 저축은행", 15.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null),
                        UiUtils.getMarginBox(0, 0.1.h),
                        UiUtils.getTextWithFixedScale("특별론 대출상품1", 10.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null),
                      ])
                    ])),
                    UiUtils.getMarginBox(0, 2.h),
                    UiUtils.getTextWithFixedScale("신청일자 : 2023.08.29", 10.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null),
                    UiUtils.getMarginBox(0, 2.h),
                    UiUtils.getTextWithFixedScale("심사 대기중", 20.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, null),
                  ])
                ]), () {})
          ])
      );
      accidentWidgetList.add(UiUtils.getMarginBox(0, 3.h));
    }
    return Column(children: [
      Container(padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 4.h, bottom: 1.h),
          child: Row(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center, children: [
            UiUtils.getIconButton(Icons.home_filled, 8.w, ColorStyles.upFinBlack, () {
              CommonUtils.moveWithUntil(context, AppView.rootLoginView.value);
            }),
            UiUtils.getTextWithFixedScale("${MyData.name}님, ", 19.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1),
            UiUtils.getTextWithFixedScale("안녕하세요!", 18.sp, FontWeight.w400, ColorStyles.upFinBlack, TextAlign.start, 1),
            const Spacer(flex: 2),
            UiUtils.getIconButton(Icons.refresh, 7.w, ColorStyles.upFinSky, () {
              UiUtils.showLoadingPop(context);
              MyData.resetMyData();
              LogfinController.getMainOrSearchView((isSuccessToGetViewInfo, viewInfo){
                UiUtils.closeLoadingPop(context);
                if(isSuccessToGetViewInfo){
                  setState(() {});
                }else{
                  CommonUtils.flutterToast("화면을 불러오는데 실패했습니다.\n다시 실행해주세요.");
                }
              });
            })
          ])),
      Container(padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h, bottom: 1.h), child: Row(mainAxisSize: MainAxisSize.max, children: [
        UiUtils.getTextWithFixedScale("사건기록", 18.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1),
        const Spacer(flex: 2),
        UiUtils.getIconButtonBox(18.w, ColorStyles.upFinWhiteSky, Icons.add, 3.h, ColorStyles.upFinButtonBlue, () {
          CommonUtils.moveTo(context, AppView.searchAccidentView.value, null);
        })
      ])),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(children: accidentWidgetList))
    ]);
  }

  Widget _getAiAdvisorView(){
    List<AiChatRoomInfoData> aiChatRoomList = [];
    aiChatRoomList.add(AiChatRoomInfoData(1, 0, "", "업핀 AI 어드바이저", "", "현재 고객님은 2건의 심사 결과를 대기중입니다. 조금더 알아보시렵니까?", "20231009145230", 1));
    aiChatRoomList.add(AiChatRoomInfoData(2, 1, "assets/images/apple_icon.png", "OK 저축은행", "OK 무조건 대출론\n최저금리:19.3%   한도 3,000만원", "현재 OK 저축은행 기표상태는 대기중입니다. 조금더 알아보시렵니까?", "20231009155230", 12));
    aiChatRoomList.add(AiChatRoomInfoData(3, 1, "assets/images/apple_icon.png", "도이치뱅크", "도이치뱅크 기본대출\n최저금리:21.3%   한도 2,500만원", "현재 도이치뱅크 기표상태는 대기중입니다. 조금더 알아보시렵니까?", "20231009175230", 0));
    List<Widget> aiChatRoomWidgetList = [];
    for(var each in aiChatRoomList){
      aiChatRoomWidgetList.add(
        Column(children: [
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, each.chatRoomType == 0? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinRealGray,
              Row(mainAxisSize: MainAxisSize.max, children: [
                Expanded(flex: 3, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(width: 60.w, child: Row(children: [
                      each.chatRoomType == 0? UiUtils.getIcon(10.w, 10.w, Icons.account_box_rounded, 10.w, ColorStyles.upFinButtonBlue) : UiUtils.getImage(10.w, 10.w, Image.asset(each.chatRoomIconPath)),
                      UiUtils.getMarginBox(2.w, 0),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        UiUtils.getTextWithFixedScale(each.chatRoomAdditionalTitle, 15.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null),
                        UiUtils.getMarginBox(0, 0.2.h),
                        each.chatRoomType != 0? UiUtils.getTextWithFixedScale(each.chatRoomAdditionalContents, 8.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null) : Container(),
                      ])
                    ])),
                    UiUtils.getMarginBox(0, 2.h),
                    UiUtils.getTextWithFixedScaleAndOverFlow(each.chatRoomLastMsg, 10.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, 1)
                  ])
                ])),
                Expanded(flex: 1, child: Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  each.chatRoomLastMsgCnt > 0? UiUtils.getCountCircleBox(5.w, each.chatRoomLastMsgCnt, 6.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, 1) : Container(),
                  UiUtils.getMarginBox(2.w, 0),
                  UiUtils.getTextWithFixedScale("${each.chatRoomLastMsgTime.substring(2,4)}.${each.chatRoomLastMsgTime.substring(4,6)}.${each.chatRoomLastMsgTime.substring(6,8)}\n${each.chatRoomLastMsgTime.substring(8,10)}시${each.chatRoomLastMsgTime.substring(10,12)}분", 8.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.end, null),
                ]))
              ]), () {})
        ])
      );
      aiChatRoomWidgetList.add(UiUtils.getMarginBox(0, 1.h));
    }

    return Column(children: [
      Container(padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 4.h, bottom: 1.h),
          child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
            UiUtils.getTextWithFixedScale("AI 어드바이저와 상담하기", 18.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.center, 1),
          ])),
      UiUtils.getMarginBox(0, 2.h),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(children: aiChatRoomWidgetList))
    ]);
  }

  Widget _getSettingView(){
    return Container(color: ColorStyles.upFinTextAndBorderBlue);
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Container(color: ColorStyles.upFinWhite, width: 100.w, height: 100.h, child: Column(children: [
      viewTypeId == 1? Expanded(child: _getMyView()) : viewTypeId == 2? Expanded(child: _getAiAdvisorView()) : Expanded(child: _getSettingView()),
      SizedBox(width: 100.w, height: 7.h, child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: [
        Container(width: 30.w, height: 7.h, color: ColorStyles.upFinWhiteSky,
            child: Center(child: UiUtils.getTextStyledButtonWithFixedScale("MY", 13.sp, viewTypeId == 1? FontWeight.w800 : FontWeight.w400,
                viewTypeId == 1? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhite, TextAlign.center, 1,(){
                  setState(() {viewTypeId = 1;});
                }))
        ),
        Container(width: 40.w, height: 7.h, color: ColorStyles.upFinWhiteSky,
            child: Center(child: UiUtils.getTextStyledButtonWithFixedScale("AI 어드바이저", 13.sp, viewTypeId == 2? FontWeight.w800 : FontWeight.w400,
                viewTypeId == 2? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhite, TextAlign.center, 1,(){
                  setState(() {viewTypeId = 2;});
                }))
        ),
        Container(width: 30.w, height: 7.h, color: ColorStyles.upFinWhiteSky,
            child: Center(child: UiUtils.getTextStyledButtonWithFixedScale("설정", 13.sp, viewTypeId == 3? FontWeight.w800 : FontWeight.w400,
                viewTypeId == 3? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhite, TextAlign.center, 1,(){
                  setState(() {viewTypeId = 3;});
                }))
        ),
      ])),
    ]));
    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}