import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
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
    //add accident info
    for(var each in MyData.getAccidentInfoList()){
      accidentWidgetList.add(
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinRealWhite, ColorStyles.upFinGray,
              Column(children: [
                Row(children: [
                  Expanded(flex: 15, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    UiUtils.getTextWithFixedScale(each.accidentCourtInfo.split("@")[0], 14.sp, FontWeight.w600, ColorStyles.upFinTextAndBorderBlue, TextAlign.center, 1),
                    UiUtils.getMarginBox(0, 0.7.h),
                    UiUtils.getTextWithFixedScale("${each.accidentCaseNumberYear}${each.accidentCaseNumberType}${each.accidentCaseNumberNumber}", 16.sp,
                        FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null),
                    UiUtils.getMarginBox(0, 0.7.h),
                    UiUtils.getTextWithFixedScale("${each.accidentBankInfo.split("@")[0]} ${each.accidentBankAccount}", 10.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, 1),
                  ])),
                  Expanded(flex: 1, child: Icon(Icons.arrow_forward_ios_rounded, color: ColorStyles.upFinDarkGray, size: 5.5.w))
                ]),
                UiUtils.getMarginBox(0, 2.h),
                UiUtils.getBorderButtonBox(84.w, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinTextAndBorderBlue,
                    UiUtils.getTextWithFixedScale("대출상품 찾기", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
                      UiUtils.showLoadingPop(context);
                      LogfinController.getPrList("${each.accidentCaseNumberYear}${each.accidentCaseNumberType}${each.accidentCaseNumberNumber}", (isSuccessToGetOffers, _){
                        UiUtils.closeLoadingPop(context);
                        if(isSuccessToGetOffers){
                          CommonUtils.moveTo(context, AppView.resultPrView.value, null);
                        }else{
                          // findUidInAccidentInfoList 실패
                          CommonUtils.flutterToast("에러가 발생했습니다.");
                        }
                      });
                    })
              ]), () {
                // 사건정보 수정
                MyData.selectedAccidentInfoData = each;
                CommonUtils.moveTo(context, AppView.updateAccidentView.value, null);
              })
      );
      accidentWidgetList.add(UiUtils.getMarginBox(0, 0.5.h));

      //set loan info
      List<LoanInfoData> loanInfoList = [];
      for(var eachLoan in GetController.to.loanInfoDataList){
        if(eachLoan.accidentUid == each.accidentUid){
          loanInfoList.add(eachLoan);
        }
      }
      loanInfoList.sort((a,b) => DateTime.parse(a.createdDate).compareTo(DateTime.parse(b.createdDate)));
      //add loan info
      for(var eachSortedLoan in loanInfoList){
        accidentWidgetList.add(
            UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinSky,
                SizedBox(width: 90.w,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        UiUtils.getImage(12.w, 12.w, Image.asset('assets/images/apple_icon.png')),
                        UiUtils.getMarginBox(2.w, 0),
                        SizedBox(width: 65.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          UiUtils.getTextWithFixedScale(eachSortedLoan.companyName, 14.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null),
                          UiUtils.getMarginBox(0, 0.5.h),
                          UiUtils.getTextWithFixedScaleAndOverFlow(eachSortedLoan.productName, 10.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, null),
                          UiUtils.getMarginBox(0, 0.5.h),
                          UiUtils.getSelectableTextWithFixedScale(eachSortedLoan.contactNo, 10.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null),
                        ]))
                      ]),

                      UiUtils.getMarginBox(0, 2.h),
                      UiUtils.getTextWithFixedScale("${_getFormattedDateString(eachSortedLoan.createdDate)}에 접수", 10.sp, FontWeight.w300, ColorStyles.upFinDarkGray, TextAlign.start, null),
                      UiUtils.getMarginBox(0, 1.h),
                      UiUtils.getTextWithFixedScale(_getStatusName(eachSortedLoan.statueId), 20.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, null)
                    ])
                )
                , () {})
        );
        accidentWidgetList.add(UiUtils.getMarginBox(0, 0.5.h));
      }

      accidentWidgetList.add(UiUtils.getMarginBox(0, 3.h));
    }
    return Column(children: [
      Container(padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 4.h, bottom: 1.h),
          child: Row(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center, children: [
            UiUtils.getTextWithFixedScale("${MyData.name}님, ", 20.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1),
            UiUtils.getTextWithFixedScale("안녕하세요!", 20.sp, FontWeight.w400, ColorStyles.upFinBlack, TextAlign.start, 1),
            const Spacer(flex: 2),
            UiUtils.getIconButton(Icons.refresh, 7.w, ColorStyles.upFinSky, () {
              _refreshMyView(context);
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
  String _getStatusName(String statueId){
    String status = "";
    switch(statueId){
      case "1" : status = "접수 후 심사 대기중";
      case "2" : status = "심사중";
      case "3" : status = "가승인 후 승인 대기중";
      case "4" : status = "승인완료";
      case "5" : status = "보류";
      case "6" : status = "부결";
      case "7" : status = "본인취소";
    }
    
    return status;
  }
  String _getFormattedDateString(String targetString){
    // 문자열을 DateTime 객체로 변환
    DateTime dateTime = DateTime.parse(targetString);

    // 대한민국 시간대로 설정
    dateTime = dateTime.toLocal();

    // 오전과 오후를 구분하여 표시
    String period = dateTime.hour < 12 ? '오전' : '오후';

    // 시간, 분을 0이 붙은 두 자리로 포맷팅
    String formattedHour = DateFormat('h', 'ko_KR').format(dateTime);
    String formattedMinute = DateFormat('m', 'ko_KR').format(dateTime);

    // 날짜와 시간을 원하는 형식으로 포맷팅
    var formatter = DateFormat('yyyy년 M월 d일 $period$formattedHour시 $formattedMinute분', 'ko_KR');
    String formattedDate = formatter.format(dateTime);

    return formattedDate;
  }
  void _bankToHome(BuildContext context){
    MyData.resetMyData();
    GetController.to.resetLoanInfoList();
    CommonUtils.moveWithUntil(context, AppView.rootLoginView.value);
  }
  void _refreshMyView(BuildContext context){
    UiUtils.showLoadingPop(context);
    MyData.resetMyData();
    LogfinController.getMainOrSearchView((isSuccessToGetViewInfo, viewInfo){
      UiUtils.closeLoadingPop(context);
      if(!isSuccessToGetViewInfo){
        CommonUtils.flutterToast("화면을 불러오는데 실패했습니다.\n다시 실행해주세요.");
      }
    });
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
      viewTypeId == 1? Expanded(child: Obx(()=>_getMyView())) : viewTypeId == 2? Expanded(child: _getAiAdvisorView()) : Expanded(child: _getSettingView()),
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