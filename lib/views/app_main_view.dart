import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:upfin/configs/app_config.dart';
import 'package:upfin/configs/string_config.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/controllers/websocket_controller.dart';
import 'package:upfin/datas/accident_info_data.dart';
import 'package:upfin/datas/chat_message_info_data.dart';
import 'package:upfin/datas/loan_info_data.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import '../controllers/get_controller.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';
import 'app_update_accident_view.dart';

class AppMainView extends StatefulWidget{
  @override
  AppMainViewState createState() => AppMainViewState();
}

class AppMainViewState extends State<AppMainView> with WidgetsBindingObserver{
  final PageController _pageController = PageController();
  final PageController _pageControllerForPop = PageController();
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setImagePreLoad();
    });

    Config.contextForEmergencyBack = context;
    Config.isEmergencyRoot = false;
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppMainView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    Config.contextForEmergencyBack = null;
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

  void _setImagePreLoad(){
    precacheImage(const AssetImage('assets/images/img_man_banner.png'), context);
    precacheImage(const AssetImage('assets/images/img_man_welcome.png'), context);
    precacheImage(const AssetImage('assets/images/img_man_searcher.png'), context);
    precacheImage(const AssetImage('assets/images/img_woman_searcher.png'), context);
    precacheImage(const AssetImage('assets/images/img_woman_coffee.png'), context);
    precacheImage(const AssetImage('assets/images/img_woman_sports.png'), context);
    precacheImage(const AssetImage('assets/images/accident_icon.png'), context);
    precacheImage(const AssetImage('assets/images/bank_logo_default.png'), context);
    precacheImage(const AssetImage('assets/images/bank_logo_safe.png'), context);
    precacheImage(const AssetImage('assets/images/ani_man_search.gif'), context);
  }

  bool isScrolling = false;
  Widget _getMyView(){
    return Column(children: [
      Expanded(child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification) {
              if(!isScrolling){
                isScrolling = true;
                setState(() {
                  bottomBarHeight = 0;
                });
              }
            } else if (scrollNotification is ScrollEndNotification) {
              if(isScrolling){
                isScrolling = false;
                setState(() {
                  bottomBarHeight = 0;
                });
              }
            }
            return true;
          },
          child: ListView(shrinkWrap: true,physics: const BouncingScrollPhysics(),children: [
            SizedBox(width: 100.w, height: 16.h, child:Stack(alignment: Alignment.topCenter, children: [
              Positioned(
                  child: Column(children: [
                    UiUtils.getMarginBox(0, 3.h),
                    UiUtils.getTopBannerButtonBox(90.w, 6.5.h, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                        UiUtils.getTextWithFixedScale("업핀! 다이렉트 대출의시작!", 12.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, 1), () {

                        })
                  ])),
              Positioned(
                  left: 1.w,
                  child: UiUtils.getImage(25.w, 15.h, Image.asset(fit: BoxFit.fitHeight,'assets/images/img_man_banner.png'))),
              Positioned(
                  top: 11.h,
                  right: 5.w,
                  child: SizedBox(width: 90.w, child: Row(children: [
                    const Spacer(flex: 2),
                    UiUtils.getIconButton(Icons.refresh_rounded, 8.w, ColorStyles.upFinTextAndBorderBlue, () {
                      _refreshMyView(context);
                    }),
                    UiUtils.getMarginBox(2.w, 0),
                    UiUtils.getIconButton(Icons.settings, 8.w, ColorStyles.upFinGray, () {
                      setState(() {viewTypeId = 3;});
                    })
                  ]))
              ),
            ])),
            UiUtils.getMarginBox(0, 1.h),
            Container(padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 0.h, bottom: 1.h), child: Row(mainAxisSize: MainAxisSize.max, children: [
              UiUtils.getTextWithFixedScale("사건기록", 15.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, 1),
              const Spacer(flex: 2)
            ])),
            Obx((){
              List<Widget> accidentWidgetList = _getAccidentWidgetList();
              return SizedBox(width: 90.w, height: accidentWidgetList.isEmpty ? 8.h : accidentWidgetList.length > 1 ? 27.h : 22.h,
                  child: accidentWidgetList.isNotEmpty ? Column(
                    children: <Widget>[
                      // PageView
                      SizedBox(width: 90.w, height: 21.h,
                        child: PageView(
                          controller: _pageController,
                          children: accidentWidgetList,
                        ),
                      ),
                      accidentWidgetList.length>1? UiUtils.getMarginBox(0, 3.h) : Container(),
                      accidentWidgetList.length>1? SmoothPageIndicator(
                        controller: _pageController,
                        count: accidentWidgetList.length, // 페이지 수
                        effect: WormEffect(dotWidth: 1.h, dotHeight: 1.h, dotColor: ColorStyles.upFinWhiteSky, activeDotColor: ColorStyles.upFinTextAndBorderBlue), // 페이지 인디케이터 스타일
                      ):Container(),
                    ],
                  ) : Column(children: [
                    UiUtils.getBorderButtonBoxWithZeroPadding(100.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
                        Row(children: [
                          UiUtils.getMarginBox(5.w, 0),
                          UiUtils.getTextWithFixedScale("현재 등록된 사건이없습니다.", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, null),
                          const Spacer(flex: 2),
                          UiUtils.getBorderButtonBox(27.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
                              UiUtils.getTextWithFixedScale("등록하기", 12.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.end, null), () {
                                CommonUtils.moveTo(context, AppView.appSearchAccidentView.value, null);
                              })
                        ]), () { })
                  ]));
            }),
            UiUtils.getMarginBox(100.w, 2.h),
            UiUtils.getMarginColoredBox(100.w, 2.h, ColorStyles.upFinWhiteGray),
            UiUtils.getMarginBox(100.w, 2.h),
            Container(padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h, bottom: 1.h), child: Row(mainAxisSize: MainAxisSize.max, children: [
              UiUtils.getTextWithFixedScale("접수내역", 15.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, 1),
              const Spacer(flex: 2)
            ])),
            Obx((){
              List<Widget> loanWidgetList = _getLoanChatWidgetList();
              return loanWidgetList.isNotEmpty ? Column(children: loanWidgetList)
                  : Column(children: [
                    UiUtils.getMarginBox(0, 1.h),
                UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinGray,
                    UiUtils.getTextWithFixedScale("접수내역이 없습니다.", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, null), () { })
              ]);
            }),
            UiUtils.getMarginBox(100.w, 2.h),
            UiUtils.getMarginColoredBox(100.w, 2.h, ColorStyles.upFinWhiteGray),
            UiUtils.getMarginBox(100.w, 2.h),
            Stack(alignment: Alignment.center, children: [
              Positioned(
                  child: UiUtils.getBannerButtonBox(90.w, 50.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        SizedBox(width: 70.w, child: UiUtils.getTextWithFixedScale("위기는", 25.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.start, 1)),
                        SizedBox(width: 70.w, child: UiUtils.getTextWithFixedScale("기회다!", 25.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.start, 1)),
                        UiUtils.getMarginBox(0, 10.h)
                      ]), () {})),
              Positioned(
                  right: 1.w,
                  child: UiUtils.getImage(55.w, 55.w, Image.asset(fit: BoxFit.fill,'assets/images/ani_man_search.gif'))),
            ]),
            UiUtils.getMarginBox(0, 1.h),
          ])
      )),

    ]);
  }
  List<Widget> _getAccidentWidgetList(){
    List<Widget> accidentWidgetList = [];
    CommonUtils.log("i", "accident view redraw!");
    List<String> accidentList = [];
    List<String> accidentIdList = [];
    List<AccidentInfoData> accidentInfoList = [];
    for(var each in GetController.to.accidentInfoDataList){
      String eachAccidentNum = each.accidentCaseNumberYear+each.accidentCaseNumberType+each.accidentCaseNumberNumber;
      for(var each2 in GetController.to.accidentInfoDataList){
        String each2AccidentNum = each2.accidentCaseNumberYear+each2.accidentCaseNumberType+each2.accidentCaseNumberNumber;
        if(eachAccidentNum == each2AccidentNum){
          bool isHere = false;
          for(var eachTemp in accidentList){
            if(eachTemp == eachAccidentNum) isHere = true;
          }
          if(!isHere) accidentList.add(eachAccidentNum);
        }
      }
    }

    for(var eachTemp in accidentList){
      int maxId = -1;
      for(var each in GetController.to.accidentInfoDataList){
        String eachAccidentNum = each.accidentCaseNumberYear+each.accidentCaseNumberType+each.accidentCaseNumberNumber;
        if(eachTemp == eachAccidentNum){
          int eachId = int.parse(each.id);
          if(eachId > maxId) maxId = eachId;
        }
      }
      accidentIdList.add("$eachTemp@$maxId");
    }

    for(var eachIdTemp in accidentIdList){
      String accidentNum = eachIdTemp.split("@")[0];
      String id = eachIdTemp.split("@")[1];
      for(var each in GetController.to.accidentInfoDataList){
        String eachAccidentNum = each.accidentCaseNumberYear+each.accidentCaseNumberType+each.accidentCaseNumberNumber;
        if(accidentNum == eachAccidentNum && id == each.id) accidentInfoList.add(each);
      }
    }

    for(var each in accidentInfoList){
      CommonUtils.log("i", "accdient uid@@@@ : ${each.accidentUid}");
      accidentWidgetList.add(
          UiUtils.getAccidentBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinGray,
              Column(children: [
                Row(children: [
                  Expanded(flex: 15, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      UiUtils.getMarginBox(1.w, 0),
                      UiUtils.getBoxTextWithFixedScale("개인회생", 8.sp, FontWeight.w500, TextAlign.center, ColorStyles.upFinButtonBlue, ColorStyles.upFinWhite),
                      UiUtils.getMarginBox(2.w, 0),
                      !MyData.isPossibleAccidentInfo(each)? UiUtils.getTextWithFixedScale("*환급계좌정보 오류", 9.sp, FontWeight.w600, ColorStyles.upFinRed, TextAlign.start, null) : Container()
                    ]),
                    UiUtils.getMarginBox(0, 0.4.h),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      UiUtils.getImage(16.w, 16.w, Image.asset('assets/images/accident_icon.png', fit: BoxFit.fill)),
                      UiUtils.getMarginBox(0.2.w, 0),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        UiUtils.getTextWithFixedScale(each.accidentCourtInfo.split("@")[0], 10.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, 1),
                        UiUtils.getMarginBox(0, 0.5.h),
                        UiUtils.getTextWithFixedScale("${each.accidentCaseNumberYear}${each.accidentCaseNumberType}${each.accidentCaseNumberNumber}", 18.sp,
                            FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, null),
                      ])
                    ]),
                    //UiUtils.getTextWithFixedScale("${each.accidentBankInfo.split("@")[0]} ${each.accidentBankAccount} / ${each.resData["resRepaymentList"][0]["resRoundNo2"]}회 납부", 10.sp, FontWeight.w600, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, 1),
                  ])),
                  Expanded(flex: 1, child: Icon(Icons.arrow_forward_ios_rounded, color: ColorStyles.upFinDarkGray, size: 5.5.w))
                ]),

                UiUtils.getMarginBox(0, 1.h),
                UiUtils.getBorderButtonBox(80.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                    UiUtils.getTextWithFixedScale("대출상품 찾기", 12.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null), () {
                      MyData.selectedAccidentInfoData = each;
                      AppUpdateAccidentViewState.isAccountEditMode = false;
                      AppUpdateAccidentViewState.startViewId = AppUpdateAccidentViewState.confirmedViewId;
                      AppUpdateAccidentViewState.endViewId = AppUpdateAccidentViewState.jobViewId;
                      CommonUtils.moveTo(context, AppView.appUpdateAccidentView.value, null);
                    })
              ]), () {
                CommonUtils.log("i", "accdient uid : ${each.accidentUid}"); // be  :m-PYw9Qm5gvLonWRrCUAbQ  af : 5L5zVL98TsNC-1uz4xednA
                MyData.selectedAccidentInfoData = each;
                CommonUtils.moveTo(context, AppView.appAccidentDetailInfoView.value, null);
              })
      );
    }

    return accidentWidgetList;
  }

  List<Widget> _getLoanChatWidgetList(){
    List<Widget> loanChatRoomWidgetList = [];
    CommonUtils.log("i", "loan view redraw!");
    for(var each in GetController.to.chatLoanInfoDataList){
      var jsonData = jsonDecode(each.chatRoomMsgInfo);
      Map<String, dynamic> msg = jsonData;
      List<dynamic> listMsg = msg["data"];
      CommonUtils.log("i", "each msg info : \nmsg: $msg\nlistMsg: $listMsg");
      listMsg.sort((a,b) => DateTime.parse(a["created_at"]).compareTo(DateTime.parse(b["created_at"])));
      String lastMsg = listMsg[listMsg.length-1]["message"].toString();
      if(lastMsg.contains(" / ")){
        lastMsg = lastMsg.split(" / ")[1];
      }
      String lastDateString = CommonUtils.convertTimeToString(CommonUtils.parseToLocalTime(listMsg[listMsg.length-1]["created_at"]));
      int lastReadId = int.parse(msg["last_read_message_id"].toString());
      int cnt = 0;
      for(Map<String, dynamic> eachMsg in listMsg){
        if(int.parse(eachMsg["id"].toString()) > lastReadId){
          cnt++;
        }
      }

      loanChatRoomWidgetList.add(
          Column(children: [
            UiUtils.getMarginBox(0, 2.h),
            UiUtils.getBorderButtonBoxWithZeroPadding(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
                Row(mainAxisSize: MainAxisSize.max, children: [
                  Expanded(flex: 2, child: each.chatRoomType == 0? UiUtils.getIcon(12.w, 12.w, Icons.account_box_rounded, 12.w, ColorStyles.upFinButtonBlue) : UiUtils.getImage(12.w, 12.w, Image.asset(each.chatRoomIconPath))),
                  UiUtils.getMarginBox(1.w, 0),
                  Expanded(flex: 8, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      UiUtils.getMarginBox(0, 1.h),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        UiUtils.getTextWithFixedScale(each.chatRoomTitle, 16.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, null),
                        UiUtils.getMarginBox(0, 1.h),
                        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                          UiUtils.getRoundBoxTextWithFixedScale(LoanInfoData.getDetailStatusName(each.chatRoomLoanStatus), 8.sp, FontWeight.w600, TextAlign.center,  ColorStyles.upFinWhiteSky, ColorStyles.upFinButtonBlue),
                          UiUtils.getMarginBox(2.w, 0),
                          //each.chatRoomType != 0? UiUtils.getTextWithFixedScale("${each.loanMinRate}  ${each.loanMaxLimit}", 10.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null) : Container()
                        ]),
                      ]),
                      UiUtils.getMarginBox(0, 1.h),
                      UiUtils.getTextWithFixedScaleAndOverFlow(lastMsg, 10.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, 1)
                    ])
                  ])),
                  Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    UiUtils.getTextWithFixedScale(CommonUtils.getFormattedLastMsgTime(lastDateString), 8.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null),
                    UiUtils.getMarginBox(0,0.5.h),
                    cnt > 0? Row(mainAxisSize: MainAxisSize.min, children: [
                      UiUtils.getCountCircleBox(6.w, cnt, 7.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.center, 1), UiUtils.getMarginBox(0.3.w, 0)]) : Container()
                  ]))
                ]), () async {
                  GetController.to.resetChatMessageInfoList();
                  for(Map<String, dynamic> eachMsg in listMsg){
                    var messageItem = ChatMessageInfoData(eachMsg["id"].toString(), eachMsg["pr_room_id"].toString(), eachMsg["message"].toString(),
                        CommonUtils.convertTimeToString(CommonUtils.parseToLocalTime(eachMsg["created_at"])),
                        eachMsg["message_type"].toString(), eachMsg["username"].toString(), jsonEncode(eachMsg));
                    GetController.to.addChatMessageInfoList(messageItem);
                  }
                  await CommonUtils.moveToWithResult(context, AppView.appChatView.value, null);
                  if(context.mounted){
                    listMsg.clear();
                    for(var eachMessage in GetController.to.chatMessageInfoDataList){
                      listMsg.add(jsonDecode(eachMessage.messageInfo));
                    }
                    listMsg.sort((a,b) => DateTime.parse(a["created_at"]).compareTo(DateTime.parse(b["created_at"])));
                    for(int i = 0 ; i < MyData.getChatRoomInfoList().length ; i++){
                      if(MyData.getChatRoomInfoList()[i].chatRoomId == each.chatRoomId){
                        Map<String, dynamic> msgInfo = jsonDecode(MyData.getChatRoomInfoList()[i].chatRoomMsgInfo);
                        msgInfo.remove("data");
                        msgInfo["data"] = listMsg;
                        msgInfo["last_read_message_id"] = listMsg[listMsg.length-1]["id"];
                        MyData.getChatRoomInfoList()[i].chatRoomMsgInfo = jsonEncode(msgInfo);
                      }
                    }
                    GetController.to.updateChatLoanInfoList(MyData.getChatRoomInfoList());
                  }
                }),
            UiUtils.getMarginBox(0, 2.h),
            UiUtils.getMarginColoredBox(90.w, 0.15.h, ColorStyles.upFinWhiteGray)
          ])
      );
      loanChatRoomWidgetList.add(UiUtils.getMarginBox(0, 1.h));
    }

    return loanChatRoomWidgetList;
  }

  void _refreshMyView(BuildContext context){
    UiUtils.showLoadingPop(context);
    LogfinController.getMainViewInfo((isSuccessToGetMainInfo){
      UiUtils.closeLoadingPop(context);
    });
  }

  Widget _getApplyView(){
    return Stack(alignment: Alignment.center, children: [
      Container(
          color: ColorStyles.upFinButtonBlue,
          width: 100.w,
          height: 100.h,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            UiUtils.getMarginBox(0, 10.h),
            SizedBox(width: 80.w, child: UiUtils.getTextWithFixedScale("빠르고", 30.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.start, 1)),
            UiUtils.getMarginBox(0, 2.h),
            SizedBox(width: 80.w, child: UiUtils.getTextWithFixedScale("쉽게", 30.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.start, 1)),
            UiUtils.getMarginBox(0, 2.h),
            SizedBox(width: 80.w, child: UiUtils.getTextWithFixedScale("대출받자!", 30.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.start, 1)),
            UiUtils.getMarginBox(0, 5.h),
            UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
                MyData.getAccidentInfoList().isNotEmpty ?
                UiUtils.getTextWithFixedScale("대출상품 검색하기", 14.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.center, 1) :
                UiUtils.getTextWithFixedScale("사건 등록하기", 14.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.center, 1), () async {
                  if(MyData.getAccidentInfoList().isNotEmpty){
                    UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, true, 100.w, 45.h, 0.5, (slideContext, slideSetState){
                      List<Widget> accidentWidgetList = [];
                      for(var each in MyData.getAccidentInfoList()){
                        accidentWidgetList.add(
                            UiUtils.getAccidentBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinGray,
                                Column(children: [
                                  Row(children: [
                                    Expanded(flex: 15, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Row(children: [
                                        UiUtils.getMarginBox(1.w, 0),
                                        UiUtils.getBoxTextWithFixedScale("개인회생", 8.sp, FontWeight.w500, TextAlign.center, ColorStyles.upFinButtonBlue, ColorStyles.upFinWhite),
                                      ]),
                                      UiUtils.getMarginBox(0, 0.4.h),
                                      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                        UiUtils.getImage(16.w, 16.w, Image.asset('assets/images/accident_icon.png', fit: BoxFit.fill)),
                                        UiUtils.getMarginBox(0.2.w, 0),
                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          UiUtils.getTextWithFixedScale(each.accidentCourtInfo.split("@")[0], 10.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, 1),
                                          UiUtils.getMarginBox(0, 0.5.h),
                                          UiUtils.getTextWithFixedScale("${each.accidentCaseNumberYear}${each.accidentCaseNumberType}${each.accidentCaseNumberNumber}", 18.sp,
                                              FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, null),
                                        ])
                                      ]),
                                      //UiUtils.getTextWithFixedScale("${each.accidentBankInfo.split("@")[0]} ${each.accidentBankAccount} / ${each.resData["resRepaymentList"][0]["resRoundNo2"]}회 납부", 10.sp, FontWeight.w600, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, 1),
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
                                      CommonUtils.moveTo(context, AppView.appResultPrView.value, null);
                                    }else{
                                      // findUidInAccidentInfoList 실패
                                      CommonUtils.flutterToast("에러가 발생했습니다.");
                                    }
                                  });
                                })
                        );
                      }

                      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        UiUtils.getMarginBox(0, 3.h),
                        UiUtils.getTextWithFixedScale("사건정보를 선택해주세요.", 16.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.center, 1),
                        UiUtils.getMarginBox(0, 3.h),
                        SizedBox(width: 90.w, height: 21.h, child: Column(
                          children: <Widget>[
                            // PageView
                            SizedBox(width: 90.w, height: 16.h,
                              child: PageView(
                                controller: _pageControllerForPop,
                                children: accidentWidgetList,
                              ),
                            ),
                            UiUtils.getMarginBox(0, 3.h),
                            accidentWidgetList.length>1? SmoothPageIndicator(
                              controller: _pageControllerForPop,
                              count: accidentWidgetList.length, // 페이지 수
                              effect: WormEffect(dotWidth: 2.2.w, dotHeight: 2.2.w, dotColor: ColorStyles.upFinWhiteSky, activeDotColor: ColorStyles.upFinTextAndBorderBlue), // 페이지 인디케이터 스타일
                            ):Container(),
                          ],
                        )),
                        UiUtils.getExpandedScrollView(Axis.vertical, const Column(children: [])),
                        UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
                            UiUtils.getTextWithFixedScale("사건 추가하기", 12.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.center, 1), () {
                              Navigator.pop(slideContext);
                              setState(() {
                                viewTypeId = 2;
                              });
                              CommonUtils.moveTo(context, AppView.appSearchAccidentView.value, null);
                            })
                      ]);
                    });
                  }else{
                    setState(() {
                      viewTypeId = 2;
                    });
                    CommonUtils.moveTo(context, AppView.appSearchAccidentView.value, null);
                  }
                }),
            UiUtils.getMarginBox(0, 0.6.h),
            UiUtils.getExpandedScrollView(Axis.vertical, MyData.getAccidentInfoList().isNotEmpty ?
            Align(alignment: Alignment.bottomCenter, child: Image.asset(fit: BoxFit.fitHeight,'assets/images/ani_man_search.gif')) :
            Align(alignment: Alignment.bottomCenter, child: Image.asset(fit: BoxFit.fitHeight,'assets/images/img_woman_searcher.png'))),
          ])
      ),
    ]);
  }
  void _back(){
    if(viewTypeId != 2){
      setState(() {viewTypeId = 2;});
    }
  }
  Widget _getSettingView(){
    return Container(color: ColorStyles.upFinWhite, width: 100.w, height: 100.h, padding: EdgeInsets.all(5.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UiUtils.getBackButton(() async {
            _back();
          }),
          UiUtils.getMarginBox(0, 3.h),
          UiUtils.getBorderButtonBoxWithZeroPadding(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
              Row(children: [UiUtils.getTextWithFixedScale("설정", 22.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, null)]), () {}),
          UiUtils.getMarginBox(0, 5.h),
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
              Row(children: [UiUtils.getTextWithFixedScale("사용자정보", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)]), () {
                CommonUtils.moveTo(context, AppView.appSignOutView.value, null);
              }),
          UiUtils.getMarginBox(0, 1.h),
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
              Row(children: [
                UiUtils.getTextWithFixedScale("버전", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null),
                const Spacer(flex: 2),
                UiUtils.getTextWithFixedScale("(${Config.appVersion})", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)
              ]), () {}),
          UiUtils.getMarginBox(0, 1.h),
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
              Row(children: [UiUtils.getTextWithFixedScale("로그아웃", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)]), () {
                CommonUtils.backToHome(context);
              })
        ])
    );
  }

  double bottomBarHeight = 0;
  @override
  Widget build(BuildContext context) {
    if(CommonUtils.isValidStateByAPiExpiredDate()){
      Widget view = Stack(
        children: [
          Positioned(
              child: Container(color: ColorStyles.upFinWhite, width: 100.w, height: 100.h, child: Column(children: [
                Expanded(child: viewTypeId == 1? _getApplyView() : viewTypeId == 2? _getMyView() : _getSettingView()),
                AnimatedContainer(width: 100.w, height: bottomBarHeight, duration: const Duration(milliseconds:100),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: [
                      GestureDetector(child: Container(width: 30.w, color: ColorStyles.upFinWhiteGray, padding: EdgeInsets.only(left: 0, right: 0, top: 0.1.h, bottom: 0),
                          child: Container(color: ColorStyles.upFinWhite, child: Center(child: UiUtils.getTextButtonWithFixedScale("대출", 13.sp, viewTypeId == 1? FontWeight.w800 : FontWeight.w300,
                              viewTypeId == 1? ColorStyles.upFinButtonBlue : ColorStyles.upFinTextAndBorderBlue, TextAlign.center, 1,(){setState(() {viewTypeId = 1;});})))
                      ),onTap: (){ setState(() {viewTypeId = 1;});}),
                      GestureDetector(child: Container(width: 40.w, color: ColorStyles.upFinWhiteGray, padding: EdgeInsets.only(left: 0, right: 0, top: 0.1.h, bottom: 0),
                          child: Container(color: ColorStyles.upFinWhite, child: Center(child: UiUtils.getTextButtonWithFixedScale("MY", 13.sp, viewTypeId == 2? FontWeight.w800 : FontWeight.w300,
                              viewTypeId == 2? ColorStyles.upFinButtonBlue : ColorStyles.upFinTextAndBorderBlue, TextAlign.center, 1,(){setState(() {viewTypeId = 2;});})))
                      ), onTap: () {setState(() {viewTypeId = 2;});}),
                      GestureDetector(child: Container(width: 30.w, color: ColorStyles.upFinWhiteGray, padding: EdgeInsets.only(left: 0, right: 0, top: 0.1.h, bottom: 0),
                          child: Container(color: ColorStyles.upFinWhite, child: Center(child: UiUtils.getTextButtonWithFixedScale("설정", 13.sp, viewTypeId == 3? FontWeight.w800 : FontWeight.w300,
                              viewTypeId == 3? ColorStyles.upFinButtonBlue : ColorStyles.upFinTextAndBorderBlue, TextAlign.center, 1,(){setState(() {viewTypeId = 3;});})))
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
                    SizedBox(width: 80.w, child: UiUtils.getTextWithFixedScale("환영합니다! ", 22.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.start, null)),
                    UiUtils.getMarginBox(0, 1.h),
                    SizedBox(width: 80.w, child: UiUtils.getTextWithFixedScale("가입이 완료되었네요.", 22.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.start, null)),
                    UiUtils.getMarginBox(0, 1.h),
                    SizedBox(width: 80.w, child: UiUtils.getTextWithFixedScale("이제 개인회생 대출상품을", 22.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.start, null)),
                    UiUtils.getMarginBox(0, 1.h),
                    SizedBox(width: 80.w, child: UiUtils.getTextWithFixedScale("찾으실 수 있어요~ ", 22.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.start, null)),
                    UiUtils.getMarginBox(0, 3.h),
                    UiUtils.getBorderButtonBox(80.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
                        UiUtils.getTextWithFixedScale("시작하기", 14.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.center, null), () {
                          setState(() {
                            doCheckToSearchAccident = false;
                          });
                          CommonUtils.moveTo(context, AppView.appSearchAccidentView.value, null);
                        }),
                    UiUtils.getMarginBox(0, 2.5.h),
                    SizedBox(width: 80.w, child: UiUtils.getTextButtonWithFixedScale("넘어가기", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null, (){
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
      return UiUtils.getViewWithAllowBackForAndroid(context, view, _back);
    }else{
      CommonUtils.flutterToast("접속시간이 만료되었습니다.\n재로그인 해주세요");
      CommonUtils.backToHome(context);
      return Container();
    }

  }

}