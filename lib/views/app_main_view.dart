import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:upfin/configs/app_config.dart';
import 'package:upfin/controllers/firebase_controller.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/controllers/websocket_controller.dart';
import 'package:upfin/datas/accident_info_data.dart';
import 'package:upfin/datas/chat_message_info_data.dart';
import 'package:upfin/datas/loan_info_data.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import '../controllers/get_controller.dart';
import '../controllers/sharedpreference_controller.dart';
import '../styles/TextStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';
import 'app_update_accident_view.dart';

class AppMainView extends StatefulWidget{
  @override
  AppMainViewState createState() => AppMainViewState();
}

class AppMainViewState extends State<AppMainView> with WidgetsBindingObserver{
  final PageController _pageController = PageController();
  bool doCheckToSearchAccident = false;
  int viewTypeId = 2; // 1: 대출 / 2: MY / 3: 설정
  int tryOut = 0;
  String retryChatRoomId = "";
  static bool isViewHere = false;

  @override
  void initState(){
    CommonUtils.log("d", "AppMainView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    MyData.selectedAccidentInfoData = null;
    if(MyData.getAccidentInfoList().isEmpty){
      doCheckToSearchAccident = true;
    }else{
      doCheckToSearchAccident = false;
    }

    Config.contextForEmergencyBack = context;
    Config.isEmergencyRoot = false;
    FireBaseController.setStateForForeground = setState;
    AppMainViewState.isStart = false;
    isViewHere = true;
    FireBaseController.analytics!.logLogin();

  }

  @override
  void dispose() {
    CommonUtils.log("d", "AppMainView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    Config.contextForEmergencyBack = null;
    WebSocketController.resetConnectWebSocketCable();
    AppMainViewState.isStart = false;
    FireBaseController.setStateForForeground = null;
    isViewHere = false;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('d','AppMainView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('d','AppMainView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('d','AppMainView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('d','AppMainView paused');
        break;
      default:
        break;
    }
  }

  bool isScrolling = false;
  Widget _getMyView(){
    return Column(children: [
      Expanded(child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification) {
              if(!isScrolling){
                isScrolling = true;
              }
            } else if (scrollNotification is ScrollEndNotification) {
              if(isScrolling){
                isScrolling = false;
              }
            }
            return true;
          },
          child: ListView(shrinkWrap: true,physics: const BouncingScrollPhysics(),children: [
            UiUtils.getMarginBox(0, 3.h),
            Container(padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 0.h, bottom: 1.h), child: Row(mainAxisSize: MainAxisSize.max, children: [
              UiUtils.getTextWithFixedScale("사건기록", 15.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1),
              const Spacer(flex: 2),
              MyData.email == "lalalllaa@kakao.com" ? UiUtils.getIconButton(Icons.comments_disabled_sharp, 7.w, ColorStyles.upFinRed, () {
                CommonUtils.moveTo(context, AppView.debugForAdminView.value, null);
              }) : UiUtils.getMarginBox(0, 0),
              UiUtils.getMarginBox(2.w, 0),
              UiUtils.getIconButton(Icons.add, 7.w, ColorStyles.upFinDarkGray, () {
                UiUtils.showPopMenu(context, true, 100.w, 100.h, 0.5, 0, ColorStyles.upFinButtonBlue, (slideContext, slideSetState){
                  Widget slideWidget = Column(
                      children: [
                        SizedBox(width: 95.w, child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          UiUtils.getCloseButton(ColorStyles.upFinWhite, () {
                            Navigator.pop(slideContext);
                          })
                        ])),
                        UiUtils.getMarginBox(0, 5.h),
                        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("새로운", 22.sp, FontWeight.w800, ColorStyles.upFinWhite, TextAlign.start, null)),
                        UiUtils.getMarginBox(0, 1.h),
                        SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("개인회생사건 등록", 22.sp, FontWeight.w800, ColorStyles.upFinWhite, TextAlign.start, null)),
                        UiUtils.getMarginBox(0, 5.h),
                        UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
                            UiUtils.getTextWithFixedScale("✚ 추가하기", 14.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.center, null), () async {
                              Navigator.pop(slideContext);
                              isViewHere = false;
                              await CommonUtils.moveToWithResult(context, AppView.appSearchAccidentView.value, null);
                              isViewHere = true;
                            }),
                        UiUtils.getExpandedScrollView(Axis.vertical, const Column(children: [])),
                        Align(alignment: Alignment.bottomCenter, child: Image.asset(fit: BoxFit.fitHeight,'assets/images/img_woman_searcher_01.png')),
                      ]);

                  return slideWidget;
                });
              }),
              UiUtils.getMarginBox(2.w, 0),
              UiUtils.getIconButton(Icons.refresh_outlined, 7.w, ColorStyles.upFinDarkGray, () {
                _refreshMyView(context);
              }),
              UiUtils.getMarginBox(2.w, 0),
              UiUtils.getIconButton(Icons.settings, 7.w, ColorStyles.upFinDarkGray, () {
                setState(() {viewTypeId = 3;});
              })
            ])),
            Container(padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 1.h, bottom: 1.h),
                child: UiUtils.getTopBannerButtonBox(90.w, 8.h, ColorStyles.upFinBannerSky, ColorStyles.upFinBannerSky,
                    Stack(
                        children: [
                          Positioned(
                              top:3.h,
                              right: 5.w,
                              left: 5.w,
                              child: UiUtils.getTextWithFixedScale("업핀! 다이렉트 대출의 시작!", 12.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null)),
                          Positioned(
                              left: 1.w,
                              child: UiUtils.getImage(25.w, 15.h, Image.asset(fit: BoxFit.fitHeight,'assets/images/img_man_banner.png'))),
                        ]), () {})),
            UiUtils.getMarginBox(0, 1.h),
            Obx((){
              List<Widget> accidentWidgetList = _getAccidentWidgetList();
              return SizedBox(width: 90.w, height: accidentWidgetList.isEmpty ? 8.h : accidentWidgetList.length > 1 ? 25.h : 22.h,
                  child: accidentWidgetList.isNotEmpty ? Column(
                    children: <Widget>[
                      // PageView
                      SizedBox(width: 90.w, height: 22.h,
                        child: PageView(
                          controller: _pageController,
                          children: accidentWidgetList,
                        ),
                      ),
                      accidentWidgetList.length>1? UiUtils.getMarginBox(0, 2.h) : Container(),
                      accidentWidgetList.length>1? SmoothPageIndicator(
                        controller: _pageController,
                        count: accidentWidgetList.length, // 페이지 수
                        effect: WormEffect(dotWidth: 1.h, dotHeight: 1.h, dotColor: ColorStyles.upFinWhiteSky, activeDotColor: ColorStyles.upFinTextAndBorderBlue), // 페이지 인디케이터 스타일
                      ):Container(),
                    ],
                  ) : Column(children: [
                    UiUtils.getMarginBox(0, 1.h),
                    UiUtils.getBorderButtonBoxWithZeroPadding(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
                        Row(children: [
                          UiUtils.getTextWithFixedScale("현재 등록된 사건이 없습니다.", 13.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, null),
                          const Spacer(flex: 2),
                          UiUtils.getBorderButtonBox(22.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                              UiUtils.getTextWithFixedScale("등록하기", 10.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.end, null), () async {
                                isViewHere = false;
                                await CommonUtils.moveToWithResult(context, AppView.appSearchAccidentView.value, null);
                                isViewHere = false;
                              })
                        ]), () { })
                  ]));
            }),
            Obx((){
              List<Widget> loanWidgetList = _getLoanChatWidgetList();
              return loanWidgetList.isNotEmpty ? Column(children: [
                UiUtils.getMarginBox(100.w, 2.h),
                UiUtils.getMarginColoredBox(100.w, 2.h, ColorStyles.upFinWhiteGray),
                UiUtils.getMarginBox(100.w, 2.h),
                Container(padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h, bottom: 1.h), child: Row(mainAxisSize: MainAxisSize.max, children: [
                  UiUtils.getTextWithFixedScale("접수내역", 15.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, 1),
                  const Spacer(flex: 2)
                ])),
                Column(children: loanWidgetList)
              ]) : Container();
            }),
            UiUtils.getMarginBox(100.w, 2.h),
            UiUtils.getMarginColoredBox(100.w, 2.h, ColorStyles.upFinWhiteGray),
            UiUtils.getMarginBox(100.w, 3.h),
            Stack(alignment: Alignment.center, children: [
              Positioned(
                  child: UiUtils.getBannerButtonBox(90.w, 50.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        SizedBox(width: 77.w, child: UiUtils.getTextWithFixedScale("위기는 기회다! ", 22.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.start, 1)),
                        UiUtils.getMarginBox(0, 10.h)
                      ]), () {})),
              Positioned(
                  right: 3.w,
                  child: UiUtils.getImage(50.w, 50.w, Image.asset(fit: BoxFit.fill,'assets/images/ani_man_search.gif'))),
            ]),
            UiUtils.getMarginBox(0, 1.h),
          ])
      )),

    ]);
  }
  List<Widget> _getAccidentWidgetList(){
    List<Widget> accidentWidgetList = [];
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
      accidentWidgetList.add(
          UiUtils.getAccidentBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinGray,
              Column(children: [
                UiUtils.getMarginBox(0, 0.5.h),
                Row(children: [
                  Expanded(flex: 15, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      UiUtils.getMarginBox(2.w, 0 ),
                      //
                      UiUtils.getBoxTextWithFixedScale("개인회생", 8.sp, FontWeight.w500, TextAlign.center, ColorStyles.upFinWhiteSky, ColorStyles.upFinButtonBlue),
                      UiUtils.getMarginBox(2.w, 0),
                      !MyData.isPossibleAccidentInfo(each)? UiUtils.getBoxTextWithFixedScale("환급계좌 오류", 8.sp, FontWeight.w500, TextAlign.start, ColorStyles.upFinWhiteRed, ColorStyles.upFinRed) : Container()
                    ]),
                    UiUtils.getMarginBox(0, 0.2.h),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      UiUtils.getImage(16.w, 16.w, Image.asset('assets/images/accident_icon.png', fit: BoxFit.fill)),
                      // UiUtils.getMarginBox(0.2.w, 0),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        UiUtils.getTextWithFixedScale(each.accidentCourtInfo.split("@")[0], 10.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, 1),
                        UiUtils.getMarginBox(0, 0.5.h),
                        UiUtils.getTextWithFixedScale("${each.accidentCaseNumberYear}${each.accidentCaseNumberType}${each.accidentCaseNumberNumber}", 16.sp,
                            FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, null),
                      ])
                    ]),
                    //UiUtils.getTextWithFixedScale("${each.accidentBankInfo.split("@")[0]} ${each.accidentBankAccount} / ${each.resData["resRepaymentList"][0]["resRoundNo2"]}회 납부", 10.sp, FontWeight.w600, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, 1),
                  ])),
                  Expanded(flex: 1, child: Icon(Icons.arrow_forward_ios_rounded, color: ColorStyles.upFinDarkGray, size: 5.5.w))
                ]),

                UiUtils.getMarginBox(0, 0.5.h),
                UiUtils.getBorderButtonBoxForSearch(80.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                    Row(mainAxisAlignment:MainAxisAlignment.center, children: [
                      UiUtils.getIcon(5.w, 5.w, Icons.search_rounded, 5.w, ColorStyles.upFinWhite),
                      UiUtils.getMarginBox(0.5.w, 0),
                      UiUtils.getTextWithFixedScale("대출상품 찾기", 12.sp, FontWeight.w700, ColorStyles.upFinWhite, TextAlign.center, null)
                    ]), () async {
                      MyData.selectedAccidentInfoData = each;
                      if(MyData.isPossibleAccidentInfo(each)){
                        AppUpdateAccidentViewState.isAccountEditMode = false;
                        AppUpdateAccidentViewState.startViewId = AppUpdateAccidentViewState.confirmedViewId;
                        AppUpdateAccidentViewState.endViewId = AppUpdateAccidentViewState.jobViewId;
                        isViewHere = false;
                        await CommonUtils.moveToWithResult(context, AppView.appUpdateAccidentView.value, null);
                        isViewHere = false;
                      }else{
                        isViewHere = false;
                        await CommonUtils.moveToWithResult(context, AppView.appAccidentDetailInfoView.value, null);
                        isViewHere = false;
                      }
                    })
              ]), () async {
                MyData.selectedAccidentInfoData = each;
                isViewHere = false;
                await CommonUtils.moveToWithResult(context, AppView.appAccidentDetailInfoView.value, null);
                isViewHere = false;
              })
      );
    }

    return accidentWidgetList;
  }

  List<Widget> _getLoanChatWidgetList(){
    List<Widget> loanChatRoomWidgetList = [];
    int count = 0;
    for(var each in GetController.to.chatLoanInfoDataList){
      var jsonData = jsonDecode(each.chatRoomMsgInfo);
      Map<String, dynamic> msg = jsonData;
      List<dynamic> listMsg = msg["data"];
      listMsg.sort((a,b) => a["id"].compareTo(b["id"]));
      String lastMsg = listMsg[listMsg.length-1]["message"].toString();
      if(lastMsg.contains(" / ")){
        lastMsg = lastMsg.split(" / ")[1];
      }
      String lastDateString = CommonUtils.convertTimeToString(CommonUtils.parseToLocalTime(listMsg[listMsg.length-1]["created_at"]));
      int lastReadId = int.parse(msg["last_read_message_id"].toString());
      int cnt = 0;
      for(Map<String, dynamic> eachMsg in listMsg){
        if(eachMsg["username"].toString() == "UPFIN"){
          if(int.parse(eachMsg["id"].toString()) > lastReadId){
            cnt++;
          }
        }
      }

      loanChatRoomWidgetList.add(
          Column(children: [
            UiUtils.getMarginBox(0, 1.5.h),
            UiUtils.getBorderButtonBoxWithZeroPadding(92.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Expanded(flex: 2, child: each.chatRoomType == 0? UiUtils.getIcon(11.w, 11.w, Icons.account_box_rounded, 11.w, ColorStyles.upFinButtonBlue)
                      : UiUtils.getImage(11.w, 11.w, Image.asset(each.chatRoomIconPath))),
                  UiUtils.getMarginBox(1.w, 0),
                  Expanded(flex: 10, child: Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      UiUtils.getMarginBox(0, 1.h),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        UiUtils.getTextWithFixedScale(each.chatRoomTitle, 14.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, null),
                        UiUtils.getMarginBox(0, 1.h),
                        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                          UiUtils.getRoundBoxTextWithFixedScale(LoanInfoData.getDetailStatusName(each.chatRoomLoanStatus), 7.sp, FontWeight.w600, TextAlign.center,  ColorStyles.upFinWhiteSky, ColorStyles.upFinButtonBlue),
                          UiUtils.getMarginBox(2.w, 0),
                          Expanded(child: UiUtils.getTextWithFixedScaleAndOverFlow(lastMsg, 9.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, 1))
                        ]),
                        UiUtils.getMarginBox(0, 0.2.h),
                      ])
                    ])
                  ])),
                  Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                   Row(children: [ UiUtils.getTextWithFixedScale(CommonUtils.getFormattedLastMsgTime(lastDateString), 8.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null), UiUtils.getMarginBox(0.5.w, 0) ],),
                    UiUtils.getMarginBox(0,1.h),
                    cnt > 0? Row(mainAxisSize: MainAxisSize.min, children: [
                      UiUtils.getCountCircleBox(6.w, cnt, 7.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.center, 1), UiUtils.getMarginBox(0.8.w, 0)]) : Container()
                  ]))
                ]), () async {
                  if(WebSocketController.isSubscribe(each.chatRoomId)){
                    _goToChatRoom(listMsg, each.chatRoomId);
                  }else{
                    _resetAndGoToChatRoom(context, each.chatRoomId);
                  }
                }),
            UiUtils.getMarginBox(0, 1.5.h),
            GetController.to.chatLoanInfoDataList.length == 1 || (GetController.to.chatLoanInfoDataList.length != 1 && count == GetController.to.chatLoanInfoDataList.length-1) ?
                Container() : UiUtils.getMarginColoredBox(90.w, 0.15.h, ColorStyles.upFinWhiteGray)
          ])
      );
      count++;
    }

    return loanChatRoomWidgetList;
  }

  Future<void> _goToChatRoom(List<dynamic> listMsg, String chatRoomId) async {
    if(listMsg.length>30){
      UiUtils.showLoadingPop(context);
      await Future.delayed(const Duration(milliseconds: 200));
    }

    GetController.to.resetChatMessageInfoList();
    for(Map<String, dynamic> eachMsg in listMsg){
      var messageItem = ChatMessageInfoData(eachMsg["id"].toString(), eachMsg["pr_room_id"].toString(), eachMsg["message"].toString(),
          CommonUtils.convertTimeToString(CommonUtils.parseToLocalTime(eachMsg["created_at"])),
          eachMsg["message_type"].toString(), eachMsg["username"].toString(), jsonEncode(eachMsg));
      GetController.to.addChatMessageInfoList(messageItem);
    }

    await FireBaseController.setNotificationTorF(false);
    isViewHere = false;
    if(context.mounted){
      UiUtils.closeLoadingPop(context);
      await CommonUtils.moveToWithResult(context, AppView.appChatView.value, null);
    }
    isViewHere = true;
    if(context.mounted){
      FireBaseController.setStateForForeground = setState;
      listMsg.clear();
      for(var eachMessage in GetController.to.chatMessageInfoDataList){
        listMsg.add(jsonDecode(eachMessage.messageInfo));
      }
      listMsg.sort((a,b) => a["id"].compareTo(b["id"]));
      for(int i = 0 ; i < MyData.getChatRoomInfoList().length ; i++){
        if(MyData.getChatRoomInfoList()[i].chatRoomId == chatRoomId){
          Map<String, dynamic> msgInfo = jsonDecode(MyData.getChatRoomInfoList()[i].chatRoomMsgInfo);
          msgInfo.remove("data");
          msgInfo["data"] = listMsg;
          msgInfo["last_read_message_id"] = listMsg[listMsg.length-1]["id"];
          MyData.getChatRoomInfoList()[i].chatRoomMsgInfo = jsonEncode(msgInfo);
        }
      }
      GetController.to.updateChatLoanInfoList(MyData.getChatRoomInfoList());
    }
  }

  void _refreshMyView(BuildContext context) {
    UiUtils.showLoadingPop(context);
    LogfinController.getMainViewInfo((isSuccessToGetMainInfo){
      UiUtils.closeLoadingPop(context);
    });
  }

  Future<void> _resetAndGoToChatRoom(BuildContext context, String chatRoomId) async {
    UiUtils.showLoadingPop(context);
    LogfinController.getLoanInfo((isSuccessToGetLoanInfo, _) async {
      UiUtils.closeLoadingPop(context);
      if(isSuccessToGetLoanInfo){
        await CommonUtils.saveSettingsToFile("push_from", "F");
        await CommonUtils.saveSettingsToFile("push_room_id", chatRoomId);
        _directGoToChatRoom(chatRoomId);
      }
    });

  }

  void _back(){
    tryOut++;
    Future.delayed(const Duration(milliseconds: 500), () async {
      tryOut = 0;
    });
    if(tryOut >= 2 && Config.isAndroid){
      UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, true, 100.w, 23.h, 0.3, (slideContext, slideSetState){
        return Column(mainAxisAlignment: MainAxisAlignment.start, children:
        [
          UiUtils.getMarginBox(0, 3.h),
          SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("🥹 앱을 종료할까요?", 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)),
          UiUtils.getMarginBox(0, 3.h),
          UiUtils.getExpandedScrollView(Axis.vertical, const Column(children: [])),
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinButtonBlue,
              UiUtils.getTextWithFixedScale("나가기", 14.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, null), (){
                MyData.resetMyData();
                GetController.to.resetAccdientInfoList();
                GetController.to.resetChatLoanInfoList();
                GetController.to.resetChatMessageInfoList();
                WebSocketController.resetConnectWebSocketCable();
                SystemNavigator.pop();
              })
        ]);
      });
    }else{
      if(viewTypeId != 2){
        setState(() {viewTypeId = 2;});
      }
    }
  }
  Widget _getSettingView(){
    return Container(color: ColorStyles.upFinWhite, width: 100.w, height: 100.h, padding: EdgeInsets.only(top:3.w),
        child: Column(children: [
          SizedBox(width: 95.w, child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            UiUtils.getCloseButton(ColorStyles.upFinDarkGray, () {
              _back();
            })
          ])),
          UiUtils.getMarginBox(0, 3.w),
          UiUtils.getBorderButtonBoxWithZeroPadding(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
              Row(children: [UiUtils.getTextWithFixedScale("설정", 22.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, null)]), () {}),
          UiUtils.getMarginBox(0, 3.h),
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
              Row(children: [UiUtils.getTextWithFixedScale("계정", 15.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)]), () async {
                isViewHere = false;
                await CommonUtils.moveToWithResult(context, AppView.appSignOutView.value, null);
                isViewHere = true;
              }),
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
              Row(children: [
                UiUtils.getTextWithFixedScale("버전", 15.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null),
                const Spacer(flex: 2),
                UiUtils.getTextWithFixedScale("(${Config.appVersion})", 15.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)
              ]), () {}),
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
              Row(children: [UiUtils.getTextWithFixedScale("로그아웃", 15.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)]), () {
                SharedPreferenceController.deleteValidAutoLoginData();
                CommonUtils.backToHome(context);
              })
        ])
    );
  }

  static Timer? reSubScribeCheckTimer;
  static bool isStart = false;
  Future<void> _detectPushClickFromBack() async {
    if(!isStart){
      isStart = true;
      UiUtils.showLoadingPop(context);
      Map<String, dynamic> map = await CommonUtils.readSettingsFromFile();
      if(map["push_room_id"] != ""){
        CommonUtils.log("", "push_room_id: ${map["push_room_id"]}");
        if(map["push_from"] == "F"){
          bool isHere = false;
          for(var each in MyData.getChatRoomInfoList()){
            if(each.chatRoomId == map["push_room_id"].toString()) isHere = true;
          }
          if(isHere){
            const Duration intervalFoCheckSubScribe = Duration(seconds: 1);
            reSubScribeCheckTimer = Timer.periodic(intervalFoCheckSubScribe, (Timer timer) {
              if(GetController.to.isAllSubscribed.value){
                if(context.mounted) UiUtils.closeLoadingPop(context);
                if(reSubScribeCheckTimer != null){
                  reSubScribeCheckTimer!.cancel();
                }else{

                }
                _directGoToChatRoom(map["push_room_id"].toString());
              }
            });
          }else{
            if(context.mounted) UiUtils.closeLoadingPop(context);
            if(reSubScribeCheckTimer != null) reSubScribeCheckTimer!.cancel();
            await CommonUtils.saveSettingsToFile("push_from", "");
            await CommonUtils.saveSettingsToFile("push_room_id", "");
            isStart = false;
          }
        }else if(map["push_from"] == "B"){
          bool isHere = false;
          for(var each in MyData.getChatRoomInfoList()){
            if(each.chatRoomId == map["push_room_id"].toString()) isHere = true;
          }
          if(isHere){
            const Duration intervalFoCheckSubScribe = Duration(seconds: 1);
            reSubScribeCheckTimer = Timer.periodic(intervalFoCheckSubScribe, (Timer timer) {
              if(GetController.to.isAllSubscribed.value){

                if(context.mounted) UiUtils.closeLoadingPop(context);
                if(reSubScribeCheckTimer != null){
                  reSubScribeCheckTimer!.cancel();
                }else{

                }
                _directGoToChatRoom(map["push_room_id"].toString());
              }
            });
          }else{
            if(context.mounted) UiUtils.closeLoadingPop(context);
            if(reSubScribeCheckTimer != null) reSubScribeCheckTimer!.cancel();
            await CommonUtils.saveSettingsToFile("push_from", "");
            await CommonUtils.saveSettingsToFile("push_room_id", "");
            isStart = false;
          }
        }else{
          if(context.mounted) UiUtils.closeLoadingPop(context);
          if(reSubScribeCheckTimer != null) reSubScribeCheckTimer!.cancel();
          await CommonUtils.saveSettingsToFile("push_from", "");
          await CommonUtils.saveSettingsToFile("push_room_id", "");
          isStart = false;
        }
      }else{
        if(context.mounted) UiUtils.closeLoadingPop(context);
        if(reSubScribeCheckTimer != null) reSubScribeCheckTimer!.cancel();
        await CommonUtils.saveSettingsToFile("push_from", "");
        await CommonUtils.saveSettingsToFile("push_room_id", "");
        isStart = false;
      }
    }
  }

  void _directGoToChatRoom(String pushedRoomId){
    for(var each in GetController.to.chatLoanInfoDataList){
      if(each.chatRoomId == pushedRoomId){
        var jsonData = jsonDecode(each.chatRoomMsgInfo);
        Map<String, dynamic> msg = jsonData;
        List<dynamic> listMsg = msg["data"];
        listMsg.sort((a,b) => a["id"].compareTo(b["id"]));
        _goToChatRoom(listMsg, each.chatRoomId);
      }
    }
  }

  void _showInfoPop(){
    UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, false, 100.w, 40.h, 0.5, (slideContext, setState){
      return Center(child: Column(children: [
        UiUtils.getMarginBox(0, 1.h),
        UiUtils.getTextWithFixedScale("📌 안내사항", 14.sp, FontWeight.w800, ColorStyles.upFinBlack, TextAlign.center, null),
        UiUtils.getMarginBox(0, 3.h),
        UiUtils.getExpandedScrollView(Axis.vertical,
            UiUtils.getTextWithFixedScale2(Config.appInfoTextMap["info_text"].replaceAll("@@", "\n"), 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 3.h),
        UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
            UiUtils.getTextWithFixedScale("확인", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null), () {
              SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceValidInfoVersion, Config.appInfoTextMap["info_text_version"].toString());
              DateTime thirtyMinutesLater = CommonUtils.addTimeToTargetTime(CommonUtils.getCurrentLocalTime());
              SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceValidInfoDateKey, CommonUtils.convertTimeToString(thirtyMinutesLater));
              isInfoPopShow = false;
              Navigator.pop(slideContext);
              _detectPushClickFromBack();
            }),
        Config.isAndroid? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 5.h)
      ]));
    });
  }

  double bottomBarHeight = 0;
  bool isInfoPopShow = false;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(isViewHere && viewTypeId == 2){
        if(!isInfoPopShow){
          isInfoPopShow = true;
          if(!CommonUtils.isValidStateByInfoExpiredDate()){
            _showInfoPop();
          }else{
            if(!CommonUtils.isValidStateByInfoVersion()){
              _showInfoPop();
            }else{
              isInfoPopShow = false;
              _detectPushClickFromBack();
            }
          }
        }else{
          isInfoPopShow = false;
          _detectPushClickFromBack();
        }
      }else{
        isStart = false;
        if(reSubScribeCheckTimer != null) reSubScribeCheckTimer!.cancel();
      }
    });

    Widget view = Stack(
      children: [
        Positioned(
            child: Container(color: ColorStyles.upFinWhite, width: 100.w, height: 100.h, child: Column(children: [
              Expanded(child: viewTypeId == 1? Container() : viewTypeId == 2? _getMyView() : _getSettingView()),
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
                      UiUtils.getTextWithFixedScale("시작하기", 14.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.center, null), () async {
                        isViewHere = false;
                        await CommonUtils.moveToWithResult(context, AppView.appSearchAccidentView.value, null);
                        isViewHere = true;
                        setState(() {
                          doCheckToSearchAccident = false;
                        });
                      }),
                  UiUtils.getMarginBox(0, 2.5.h),
                  SizedBox(width: 80.w, child: UiUtils.getTextButtonWithFixedScale("넘어가기", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null, (){
                    isViewHere = true;
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
        Positioned(child: Obx((){
          if(GetController.to.isAllSubscribed.value){
            return Container();
          }else{
            if(MyData.getChatRoomInfoList().isNotEmpty){
              if(!UiUtils.isLoadingPopOn){
                UiUtils.closeLoadingPop(context);
                return Container(
                    width: 100.w,
                    height: 100.h,
                    color: Colors.black54,
                    child: SpinKitWave(color: ColorStyles.upFinTextAndBorderBlue, size: 15.w)
                );
              }else{
                return Container();
              }
            }else{
              return Container();
            }
          }
        })
        )
      ],
    );
    return UiUtils.getViewWithAllowBackForAndroid(context, view, _back);

  }

}