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
  bool doCheckToSearchAccident = false;
  int viewTypeId = 2; // 1: 대출 / 2: MY / 3: 설정

  @override
  void initState(){
    CommonUtils.log("i", "AppMainView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    MyData.selectedAccidentInfoData = null;
    if(MyData.getAccidentInfoList().isEmpty){
      doCheckToSearchAccident = true;
    }else{
      doCheckToSearchAccident = false;
    }
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
    List<Widget> aiPrChatRoomWidgetList = [];
    //set loan info
    if(GetController.to.isMainDataChanged.value){
      CommonUtils.log("e", "changed!");
      //add accident info
      for(var each in MyData.getAccidentInfoList()){
        accidentWidgetList.add(
            UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinGray,
                Column(children: [
                  Row(children: [
                    Expanded(flex: 15, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        UiUtils.getImage(12.w, 12.w, Image.asset('assets/images/accident_icon.png')),
                        UiUtils.getMarginBox(2.w, 0),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          UiUtils.getTextWithFixedScale(each.accidentCourtInfo.split("@")[0], 14.sp, FontWeight.w600, ColorStyles.upFinTextAndBorderBlue, TextAlign.center, 1),
                          UiUtils.getMarginBox(0, 0.7.h),
                          UiUtils.getTextWithFixedScale("${each.accidentCaseNumberYear}${each.accidentCaseNumberType}${each.accidentCaseNumberNumber}", 16.sp,
                              FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null),
                        ])
                      ]),
                      UiUtils.getMarginBox(0, 0.7.h),
                      UiUtils.getTextWithFixedScale("${each.accidentBankInfo.split("@")[0]} ${each.accidentBankAccount}", 10.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, 1),
                    ])),
                    Expanded(flex: 1, child: Icon(Icons.arrow_forward_ios_rounded, color: ColorStyles.upFinDarkGray, size: 5.5.w))
                  ]),
                ]), () {
                  // 사건정보 수정
                  //MyData.selectedAccidentInfoData = each;
                  //CommonUtils.moveTo(context, AppView.updateAccidentView.value, null);
                })
        );
        accidentWidgetList.add(UiUtils.getMarginBox(0, 0.5.h));
      }

      //add loan info
      List<LoanInfoData> loanInfoList = [];
      for(var eachLoan in MyData.getLoanInfoList()){
        loanInfoList.add(eachLoan);
      }
      loanInfoList.sort((a,b) => DateTime.parse(a.createdDate).compareTo(DateTime.parse(b.createdDate)));

      List<AiChatRoomInfoData> aiChatRoomList = [];
      for(var eachSortedLoan in loanInfoList){
        aiChatRoomList.add(AiChatRoomInfoData(int.parse(eachSortedLoan.lenderPrId), 1, "assets/images/temp_bank_logo.png",
            eachSortedLoan.companyName, eachSortedLoan.productName, "현재 고객님은 2건의 심사 결과를 대기중입니다. 조금더 알아보시렵니까?", "20231008145230", 12));
      }
      aiChatRoomList.sort((a,b){
        int yearA = int.parse(a.chatRoomLastMsgTime.substring(0, 4));
        int monthA = int.parse(a.chatRoomLastMsgTime.substring(4, 6));
        int dayA = int.parse(a.chatRoomLastMsgTime.substring(6, 8));
        int hourA = int.parse(a.chatRoomLastMsgTime.substring(8, 10));
        int minuteA = int.parse(a.chatRoomLastMsgTime.substring(10, 12));
        int secondA = int.parse(a.chatRoomLastMsgTime.substring(12, 14));
        var dateA = DateTime(yearA, monthA, dayA, hourA, minuteA, secondA);

        int yearB = int.parse(b.chatRoomLastMsgTime.substring(0, 4));
        int monthB = int.parse(b.chatRoomLastMsgTime.substring(4, 6));
        int dayB = int.parse(b.chatRoomLastMsgTime.substring(6, 8));
        int hourB = int.parse(b.chatRoomLastMsgTime.substring(8, 10));
        int minuteB = int.parse(b.chatRoomLastMsgTime.substring(10, 12));
        int secondB = int.parse(b.chatRoomLastMsgTime.substring(12, 14));
        var dateB = DateTime(yearB, monthB, dayB, hourB, minuteB, secondB);

        return dateA.compareTo(dateB);
      });

      for(var each in aiChatRoomList){
        aiPrChatRoomWidgetList.add(
            Column(children: [
              UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhiteSky, each.chatRoomType == 0? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhiteSky,
                  Row(mainAxisSize: MainAxisSize.max, children: [
                    Expanded(flex: 3, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        SizedBox(width: 60.w, child: Row(children: [
                          each.chatRoomType == 0? UiUtils.getIcon(10.w, 10.w, Icons.account_box_rounded, 10.w, ColorStyles.upFinButtonBlue) : UiUtils.getImage(10.w, 10.w, Image.asset(each.chatRoomIconPath)),
                          UiUtils.getMarginBox(2.w, 0),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            UiUtils.getTextWithFixedScale(each.chatRoomTitle, 12.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null),
                            UiUtils.getMarginBox(0, 0.2.h),
                            each.chatRoomType != 0? UiUtils.getTextWithFixedScale(each.chatRoomSubTitle, 10.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null) : Container(),
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
        aiPrChatRoomWidgetList.add(UiUtils.getMarginBox(0, 1.h));
      }
    }

    return Column(children: [
      Container(padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 4.h, bottom: 1.h),
          child: Row(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center, children: [
            UiUtils.getTextWithFixedScale("${MyData.name}님, ", 18.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1),
            UiUtils.getTextWithFixedScale("안녕하세요!", 18.sp, FontWeight.w400, ColorStyles.upFinBlack, TextAlign.start, 1),
            const Spacer(flex: 2),
            UiUtils.getIconButton(Icons.refresh, 7.w, ColorStyles.upFinSky, () {
              _refreshMyView(context);
            })
          ])),
      Expanded(child: ListView(shrinkWrap: true,physics: const BouncingScrollPhysics(),children: [
        Container(padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h, bottom: 1.h), child: Row(mainAxisSize: MainAxisSize.max, children: [
          UiUtils.getTextWithFixedScale("사건기록", 15.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, 1),
          const Spacer(flex: 2),
          UiUtils.getIconButtonWithBoxSize(ColorStyles.upFinWhiteSky, 10.w, 10.w, Icons.add, 5.w, ColorStyles.upFinButtonBlue, () {
            CommonUtils.moveTo(context, AppView.searchAccidentView.value, null);
          })
        ])),
        accidentWidgetList.isNotEmpty ? Column(children: accidentWidgetList)
            : Column(children: [
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinRealGray,
              UiUtils.getTextWithFixedScale("사건기록이 없습니다.", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, null), () { })
        ]),
        UiUtils.getMarginBox(0, 4.h),
        Container(padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h, bottom: 1.h), child: Row(mainAxisSize: MainAxisSize.max, children: [
          UiUtils.getTextWithFixedScale("접수내역", 15.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, 1),
          const Spacer(flex: 2)
        ])),
        aiPrChatRoomWidgetList.isNotEmpty ? Column(children: aiPrChatRoomWidgetList)
            : Column(children: [
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinRealGray,
              UiUtils.getTextWithFixedScale("접수내역이 없습니다.", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, null), () { })
        ]),
        UiUtils.getMarginBox(0, 4.h),
        Container(padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h, bottom: 1.h), child: Row(mainAxisSize: MainAxisSize.max, children: [
          UiUtils.getTextWithFixedScale("서류지갑", 15.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, 1),
          const Spacer(flex: 2)
        ])),
        Column(children: [
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinRealGray,
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                UiUtils.getTextWithFixedScale("총", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, null),
                UiUtils.getTextWithFixedScale("12개", 12.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.center, null),
                UiUtils.getTextWithFixedScale("의 문서가 존재합니다.", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, null)
              ]), () { })
        ]),
        UiUtils.getMarginBox(0, 4.h),
        Stack(alignment: Alignment.center, children: [
          Positioned(
              child: UiUtils.getBannerButtonBox(90.w, 90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite, Container(), () { })),
          Positioned(
              top: 0,
              child: UiUtils.getBannerButtonBox(90.w, 50.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue, Container(), () {

              })),
          Positioned(
              top: 2.h,
              right: 1.w,
              child: UiUtils.getImage(60.w, 60.w, Image.asset(fit: BoxFit.fill,'assets/images/img_man_banner.png'))),
        ])
      ])),

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
    CommonUtils.moveWithUntil(context, AppView.rootView.value);
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
                        UiUtils.getTextWithFixedScale(each.chatRoomTitle, 15.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null),
                        UiUtils.getMarginBox(0, 0.2.h),
                        each.chatRoomType != 0? UiUtils.getTextWithFixedScale(each.chatRoomSubTitle, 8.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null) : Container(),
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

  Widget _getApplyView(){
    return Stack(alignment: Alignment.center, children: [
      Positioned(
          top: 0,
          child: Container(
              width: 90.w,
              height: 65.h,
              decoration: const BoxDecoration(
                  color: ColorStyles.upFinButtonBlue,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                SizedBox(width: 80.w, child: UiUtils.getTextWithFixedScale("위기는 기회다!", 24.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.start, 1)),
                MyData.getAccidentInfoList().isNotEmpty ? UiUtils.getMarginBox(0, 10.h) : UiUtils.getMarginBox(0, 50.h),
                MyData.getAccidentInfoList().isNotEmpty ?
                  Align(alignment: Alignment.bottomCenter, child: Image.asset(fit: BoxFit.fill,'assets/images/img_man_searcher.png')) : Container()
              ])
          )),
      MyData.getAccidentInfoList().isNotEmpty ? Positioned(child: Container()) : Positioned(
          bottom: 12.h,
          child: Center(child: UiUtils.getImage(100.w, 50.h, Image.asset(fit: BoxFit.fill,'assets/images/img_woman_searcher.png')))),
      Positioned(
          bottom: 3.h,
          child: UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
              MyData.getAccidentInfoList().isNotEmpty ? UiUtils.getTextWithFixedScale("대출상품 찾아보기", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, 1) :
              UiUtils.getTextWithFixedScale("사건 등록하기", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, 1), () async {
                if(MyData.getAccidentInfoList().isNotEmpty){
                  if(MyData.getAccidentInfoList().length == 1){
                    UiUtils.showLoadingPop(context);
                    LogfinController.getPrList("${MyData.getAccidentInfoList()[0].accidentCaseNumberYear}${MyData.getAccidentInfoList()[0].accidentCaseNumberType}${MyData.getAccidentInfoList()[0].accidentCaseNumberNumber}", (isSuccessToGetOffers, _){
                      UiUtils.closeLoadingPop(context);
                      if(isSuccessToGetOffers){
                        MyData.selectedAccidentInfoData = MyData.getAccidentInfoList()[0];
                        setState(() {
                          viewTypeId = 2;
                        });
                        CommonUtils.moveTo(context, AppView.resultPrView.value, null);
                      }else{
                        // findUidInAccidentInfoList 실패
                        CommonUtils.flutterToast("에러가 발생했습니다.");
                      }
                    });
                  }else{
                    UiUtils.showSlideMenu(context, SlideType.bottomToTop, true, 100.w, 30.h, 0.5, (slideContext, slideSetState){
                      List<Widget> accidentWidgetList = [];
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
                                ]), () {
                                  Navigator.pop(slideContext);
                                  UiUtils.showLoadingPop(context);
                                  LogfinController.getPrList("${each.accidentCaseNumberYear}${each.accidentCaseNumberType}${each.accidentCaseNumberNumber}", (isSuccessToGetOffers, _){
                                    UiUtils.closeLoadingPop(context);
                                    if(isSuccessToGetOffers){
                                      MyData.selectedAccidentInfoData = each;
                                      setState(() {
                                        viewTypeId = 2;
                                      });
                                      CommonUtils.moveTo(context, AppView.resultPrView.value, null);
                                    }else{
                                      // findUidInAccidentInfoList 실패
                                      CommonUtils.flutterToast("에러가 발생했습니다.");
                                    }
                                  });
                                })
                        );
                        accidentWidgetList.add(UiUtils.getMarginBox(0, 1.h));
                      }

                      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        UiUtils.getMarginBox(0, 2.h),
                        UiUtils.getTextWithFixedScale("사건번호를 선택해주세요", 16.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.center, 1),
                        UiUtils.getMarginBox(0, 0.5.h),
                        UiUtils.getTextWithFixedScale("해당 사건번호로 대출상품을 찾아드립니다", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, 1),
                        UiUtils.getMarginBox(0, 3.h),
                        UiUtils.getExpandedScrollView(Axis.vertical, Column(children: accidentWidgetList))
                      ]);
                    });
                  }
                }else{
                  setState(() {
                    viewTypeId = 2;
                  });
                  CommonUtils.moveTo(context, AppView.searchAccidentView.value, null);
                }
              }))
    ]);
  }

  Widget _getSettingView(){
    return Container(color: ColorStyles.upFinTextAndBorderBlue);
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Stack(
      children: [
        Positioned(
          child: Container(color: ColorStyles.upFinWhite, width: 100.w, height: 100.h, child: Column(children: [
            Expanded(child: viewTypeId == 1? _getApplyView(): viewTypeId == 2? Obx(()=>_getMyView()) : _getSettingView()),
            SizedBox(width: 100.w, height: 7.h, child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: [
              GestureDetector(child: Container(width: 30.w, height: 7.h, color: ColorStyles.upFinWhiteSky,
                  child: Center(child: UiUtils.getTextStyledButtonWithFixedScale("대출", 13.sp, viewTypeId == 1? FontWeight.w800 : FontWeight.w400,
                      viewTypeId == 1? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhite, TextAlign.center, 1,(){setState(() {viewTypeId = 1;});}))),onTap: (){
                setState(() {viewTypeId = 1;});
              }),
              GestureDetector(child: Container(width: 40.w, height: 7.h, color: ColorStyles.upFinWhiteSky,
                  child: Center(child: UiUtils.getTextStyledButtonWithFixedScale("MY", 13.sp, viewTypeId == 2? FontWeight.w800 : FontWeight.w400,
                      viewTypeId == 2? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhite, TextAlign.center, 1,(){setState(() {viewTypeId = 2;});}))
              ), onTap: () {setState(() {viewTypeId = 2;});}),
              GestureDetector(child: Container(width: 30.w, height: 7.h, color: ColorStyles.upFinWhiteSky,
                  child: Center(child: UiUtils.getTextStyledButtonWithFixedScale("설정", 13.sp, viewTypeId == 3? FontWeight.w800 : FontWeight.w400,
                      viewTypeId == 3? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinWhite, TextAlign.center, 1,(){setState(() {viewTypeId = 3;});}))
              ), onTap: (){ setState(() {viewTypeId = 3;});}),
            ])),
          ]))
        ),
        Positioned(
          child: doCheckToSearchAccident? Stack(alignment: Alignment.center, children: [
            Positioned(child: Container(
              width: 100.w,
              height: 100.h,
              color: ColorStyles.upFinButtonBlue,
              padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 15.h, bottom: 0),
              child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
                SizedBox(width: 80.w, child: UiUtils.getTextWithFixedScale("환영합니다", 22.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 1.h),
                SizedBox(width: 80.w, child: UiUtils.getTextWithFixedScale("고객님께 딱 알맞는", 22.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 1.h),
                SizedBox(width: 80.w, child: UiUtils.getTextWithFixedScale("개인회생 대출상품을", 22.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 1.h),
                SizedBox(width: 80.w, child: UiUtils.getTextWithFixedScale("이제 찾으실 수 있습니다!", 22.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 3.h),
                UiUtils.getBorderButtonBox(80.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
                    UiUtils.getTextWithFixedScale("시작하기", 14.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.center, null), () {
                      CommonUtils.moveTo(context, AppView.searchAccidentView.value, null);
                    }),
                UiUtils.getMarginBox(0, 2.h),
                SizedBox(width: 80.w, child: UiUtils.getTextStyledButtonWithFixedScale("넘어가기", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null, (){
                  setState(() {
                    doCheckToSearchAccident = false;
                  });
                })),
              ]),
            )),
            Positioned(
                top: 50.h,
                child: UiUtils.getImage(150.w, 150.w, Image.asset(fit: BoxFit.fitWidth,'assets/images/img_woman_coffee.png')))
          ]) : Container()
        ),
      ],
    );
    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}