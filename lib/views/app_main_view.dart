import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
import 'package:upfin/styles/TextStyles.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/get_controller.dart';
import '../controllers/sharedpreference_controller.dart';
import '../datas/car_info_data.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';
import 'app_update_accident_view.dart';
import 'app_update_car_view.dart';

class AppMainView extends StatefulWidget{
  @override
  AppMainViewState createState() => AppMainViewState();
}

class AppMainViewState extends State<AppMainView> with WidgetsBindingObserver{
  final PageController _pageController = PageController();
  static bool doCheckToSearchPr = false;
  int viewTypeId = 2; // 1: 대출 / 2: MY / 3: 설정
  int tryOut = 0;
  String retryChatRoomId = "";
  static bool isViewHere = false;
  static BuildContext? mainContext;

  @override
  void initState(){
    CommonUtils.log("d", "AppMainView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    MyData.selectedAccidentInfoData = null;
    MyData.selectedCarInfoData = null;
    if(MyData.getAccidentInfoList().isEmpty && MyData.getCarInfoList().isEmpty){
      doCheckToSearchPr = true;
    }else{
      doCheckToSearchPr = false;
    }

    mainContext = context;
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
    WebSocketController.resetConnectWebSocketCable();
    WebSocketController.resetRetry();
    AppMainViewState.isStart = false;
    FireBaseController.setStateForForeground = null;
    isViewHere = false;
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('d','AppMainView resumed');
        await CommonUtils.checkUpdate(context);
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

  void _showChoicePop(){
    UiUtils.showPopMenu(context, true, 100.w, 100.h, 0.5, 0, ColorStyles.upFinButtonBlue, (slideContext, slideSetState){
      Widget slideWidget = Column(
          children: [
            SizedBox(width: 95.w, child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              UiUtils.getCloseButton(ColorStyles.upFinWhite, () {
                Navigator.pop(slideContext);
              })
            ])),
            UiUtils.getMarginBox(0, 5.h),

            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(children: [
                UiUtils.getTextWithFixedScale("새로운 등록을 시작하세요!", 22.sp, FontWeight.w800, ColorStyles.upFinWhite, TextAlign.start, null),
                UiUtils.getMarginBox(0, 1.h),
                UiUtils.getTextWithFixedScale2("정보를 등록하시면 조건에 맞는 대출상품을 보여드립니다.", 10.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null),
                UiUtils.getMarginBox(0, 4.h),
                Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  UiUtils.getBorderButtonBoxWithZeroPadding(90.w,  ColorStyles.upFinWhite,  ColorStyles.upFinWhite, Row(children: [
                    UiUtils.getMarginBox(4.w, 0),
                    UiUtils.getImage(16.w, 16.w, Image.asset('assets/images/accident_icon.png', fit: BoxFit.fill)),
                    UiUtils.getMarginBox(5.6.w, 0),
                    UiUtils.getTextWithFixedScale("개인회생사건 등록", 14.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.center, null),
                  ]), () async {
                    isViewHere = false;
                    await CommonUtils.moveToWithResult(context, AppView.appSearchAccidentView.value, null);
                    isViewHere = true;
                  }),
                  UiUtils.getMarginBox(0, 1.h),
                  UiUtils.getBorderButtonBoxWithZeroPadding(90.w,  ColorStyles.upFinWhite,  ColorStyles.upFinWhite, Row(children: [
                    UiUtils.getMarginBox(6.w, 0),
                    UiUtils.getImage(16.w, 16.w, Image.asset('assets/images/icon_car.png', fit: BoxFit.fill)),
                    UiUtils.getMarginBox(4.w, 0),
                    UiUtils.getTextWithFixedScale("자동차 정보 등록", 14.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.center, null),
                  ]), () async {
                    if(MyData.isTestUser){
                      isViewHere = false;
                      await CommonUtils.moveToWithResult(context, AppView.appSearchCarView.value, null);
                      isViewHere = true;
                    }else{
                      if(Config.isAutoOpen){
                        isViewHere = false;
                        await CommonUtils.moveToWithResult(context, AppView.appSearchCarView.value, null);
                        isViewHere = true;
                      }else{
                        CommonUtils.flutterToast("오토론 상품은 준비중입니다.!");
                      }
                    }
                  })
                ]),
              ])
              /*
              UiUtils.getBorderButtonBoxForChoiceType(43.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
                  Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    UiUtils.getMarginBox(0, 0.5.h),
                    SizedBox(width: 40.w, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      UiUtils.getBoxTextWithFixedScale("개인회생", 8.sp, FontWeight.w600, TextAlign.start, ColorStyles.upFinWhiteSky, ColorStyles.upFinButtonBlue)
                    ])),
                    UiUtils.getMarginBox(0, 2.h),
                    Icon(Icons.accessibility_sharp, color: ColorStyles.upFinGray, size: 30.w),
                    UiUtils.getMarginBox(0, 2.h),
                    UiUtils.getTextWithFixedScale("사건번호 추가하기", 11.sp, FontWeight.w800, ColorStyles.upFinButtonBlue, TextAlign.center, null),
                    UiUtils.getMarginBox(0, 1.h),
                    UiUtils.getTextWithFixedScale2("개인회생 대출을 위해", 9.sp, FontWeight.w300, ColorStyles.upFinDarkGray, TextAlign.center, null),
                    UiUtils.getTextWithFixedScale2("사건정보를 찾아보세요.", 9.sp, FontWeight.w300, ColorStyles.upFinDarkGray, TextAlign.center, null)
                  ]), () async {
                    isViewHere = false;
                    await CommonUtils.moveToWithResult(context, AppView.appSearchAccidentView.value, null);
                    isViewHere = true;
                  }),
              UiUtils.getMarginBox(2.w, 0),
              UiUtils.getBorderButtonBoxForChoiceType(43.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
                  Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    UiUtils.getMarginBox(0, 0.5.h),
                    SizedBox(width: 40.w, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      UiUtils.getBoxTextWithFixedScale("오토론", 8.sp, FontWeight.w600, TextAlign.start, ColorStyles.upFinWhiteSky, ColorStyles.upFinButtonBlue)
                    ])),
                    UiUtils.getMarginBox(0, 2.h),
                    Icon(Icons.car_repair_rounded, color: ColorStyles.upFinGray, size: 30.w),
                    UiUtils.getMarginBox(0, 2.h),
                    UiUtils.getTextWithFixedScale("차량정보 추가하기", 11.sp, FontWeight.w800, ColorStyles.upFinButtonBlue, TextAlign.center, null),
                    UiUtils.getMarginBox(0, 1.h),
                    UiUtils.getTextWithFixedScale2("자동차담보 대출을 위해", 9.sp, FontWeight.w300, ColorStyles.upFinDarkGray, TextAlign.start, null),
                    UiUtils.getTextWithFixedScale2("시세정보를 찾아보세요.", 9.sp, FontWeight.w300, ColorStyles.upFinDarkGray, TextAlign.start, null),
                  ]), () async {
                    isViewHere = false;
                    await CommonUtils.moveToWithResult(context, AppView.appSearchCarView.value, null);
                    isViewHere = true;
                  }),
              */
            ]),

            UiUtils.getExpandedScrollView(Axis.vertical, const Column(children: [])),
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Image.asset(fit: BoxFit.fitHeight,'assets/images/img_woman_searcher_01.png', height: 50.h)
            ])
          ]);

      return slideWidget;
    });
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
            UiUtils.getMarginBox(0, 2.5.h),
            Container(padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 0.h, bottom: 1.h), child: Row(mainAxisSize: MainAxisSize.max, children: [
              UiUtils.getTextWithFixedScale("${MyData.name}님", 15.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1),
              UiUtils.getMarginBox(2.w, 0),
              MyData.isTestUser ? UiUtils.getRoundBoxButtonTextWithFixedScale5(
                  UiUtils.getTextWithFixedScale("관리자", 9.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null),
                  ColorStyles.upFinBlack, (){
                    // test

                UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, true, null, Config.isPad()? 65.h : 45.h, 0.5, (context, setState){
                  return Obx(()=>Column(mainAxisAlignment: MainAxisAlignment.start, children:[
                    UiUtils.getMarginBox(0, 8.h),
                    UiUtils.getImage(30.w, 30.w, Image.asset(fit: BoxFit.fill,'assets/images/doc_move2.gif')),
                    UiUtils.getMarginBox(0, 2.h),
                    Column(children: [
                      UiUtils.getStyledTextWithFixedScale("서류를 가지고 오는중입니다.", TextStyles.upFinBasicTextStyle, TextAlign.center, null),
                      UiUtils.getMarginBox(0, 1.h),
                      LinearPercentIndicator(
                        animateFromLastPercent: true,
                        alignment: MainAxisAlignment.center,
                        barRadius: const Radius.circular(10),
                        animation: true,
                        center: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                          UiUtils.getTextWithFixedScale("${GetController.to.loadingPercent.value}", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null),
                          UiUtils.getMarginBox(0.5.w, 0),
                          UiUtils.getTextWithFixedScale("%", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null),
                        ]),
                        width: 60.w,
                        lineHeight: 3.h,
                        linearStrokeCap: LinearStrokeCap.round,
                        backgroundColor : ColorStyles.upFinWhite,
                        progressColor: ColorStyles.upFinWhite,
                      )
                    ]),
                    Container(),
                    Config.isAndroid? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 3.h)
                  ]));
                });
              })
                 : UiUtils.getMarginBox(0, 0),
              const Spacer(flex: 2),
              UiUtils.getMarginBox(2.w, 0),
              UiUtils.getIconButton(Icons.add, 7.w, ColorStyles.upFinDarkGray, () {
                _showChoicePop();
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
            Container(padding: EdgeInsets.only(top: 1.h),
                child: UiUtils.getTopBannerButtonBox(100.w, Config.isPad()? 9.h : 8.h, ColorStyles.upFinBannerSky, ColorStyles.upFinBannerSky,
                    Stack(
                        children: [
                          Positioned(
                              top:3.h,
                              right: 5.w,
                              left: 5.w,
                              child: Row(children: [
                                UiUtils.getMarginBox(20.w, 0),
                                UiUtils.getAnimatedText("업핀! 다이렉트 대출의 새로운 시작!", ColorStyles.upFinWhite, 12.sp, FontWeight.w500, const Duration(milliseconds: 200), (){})
                              ])),
                          Positioned(
                              left: 3.w,
                              child: UiUtils.getImage(22.w, 15.h, Image.asset(fit: BoxFit.fitHeight,'assets/images/img_woman_coffee.png'))),
                        ]), () {})),
            Obx((){
              List<Widget> myInfoWidgetList = _getMyInfoWidgetList();
              return Container(color: ColorStyles.upFinWhiteGray, width: 90.w,
                  height: myInfoWidgetList.isEmpty ? 18.h : myInfoWidgetList.length > 1 ? Config.isPad() ? 39.h : 29.h : Config.isPad() ? 36.h : 26.h,
                  child: myInfoWidgetList.isNotEmpty ? Column(
                    children: <Widget>[
                      // PageView
                      UiUtils.getMarginBox(0, 2.h),
                      SizedBox(width: 90.w, height: Config.isPad() ? 32.h : 22.h,
                        child: PageView(
                          controller: _pageController,
                          children: myInfoWidgetList,
                        ),
                      ),
                      myInfoWidgetList.length>1? UiUtils.getMarginBox(0, 2.h) : Container(),
                      myInfoWidgetList.length>1? SmoothPageIndicator(
                        controller: _pageController,
                        count: myInfoWidgetList.length, // 페이지 수
                        effect: WormEffect(dotWidth: 1.h, dotHeight: 1.h, dotColor: ColorStyles.upFinWhite, activeDotColor: ColorStyles.upFinButtonBlue), // 페이지 인디케이터 스타일
                      ):Container(),
                      UiUtils.getMarginBox(0, 2.h),
                    ],
                  ) : GetController.to.chatLoanInfoDataList.isEmpty? Container(color: ColorStyles.upFinWhiteGray, padding: EdgeInsets.only(left: 5.w, right: 5.w, top:5.w, bottom: 5.w),
                      child: UiUtils.getBorderButtonBoxWithZeroPadding(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
                          Column(children: [
                            UiUtils.getMarginBox(0, 2.h),
                            UiUtils.getTextWithFixedScale("대출상품 검색을 위해 정보가 필요해요.", 11.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, null),
                            UiUtils.getMarginBox(0, 2.h),
                            UiUtils.getAnimatedTextButton(80.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinWhite, "✚ 새로운 정보등록", 11.sp, FontWeight.w500,
                                const Duration(seconds: 20), ShakeHorizontalConstant2(), true, (){_showChoicePop();})
                          ]), () { })
                  ) : Container(color: ColorStyles.upFinWhiteGray, padding: EdgeInsets.only(left: 5.w, right: 5.w, top:5.w, bottom: 5.w),
                      child: UiUtils.getBorderButtonBoxWithZeroPadding(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
                          Column(children: [
                            UiUtils.getMarginBox(0, 2.h),
                            UiUtils.getTextWithFixedScale("새로고침을 눌러주세요!", 11.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, null),
                            UiUtils.getMarginBox(0, 2.h),
                            UiUtils.getAnimatedTextButton(80.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinWhite, "새로고침", 11.sp, FontWeight.w500,
                                const Duration(seconds: 20), ShakeHorizontalConstant2(), true, (){_refreshMyView(context);})
                          ]), () { })
                  )
              );
            }),
            Obx((){
              List<Widget> loanWidgetList = _getLoanChatWidgetList();
              return loanWidgetList.isNotEmpty ? Column(children: [
                UiUtils.getMarginBox(0, 1.h),
                Container(padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h, bottom: 1.h), child: Row(mainAxisSize: MainAxisSize.max, children: [
                  UiUtils.getTextWithFixedScale("접수내역", 15.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1),
                  const Spacer(flex: 2)
                ])),
                Column(children: loanWidgetList)
              ]) : Container();
            }),
            UiUtils.getMarginBox(100.w, 2.h),
            UiUtils.getMarginColoredBox(100.w, 0.11.h, ColorStyles.upFinGray),
            UiUtils.getMarginColoredBox(100.w, 2.h, ColorStyles.upFinWhiteGray),
            Stack(alignment: Alignment.center, children: [
              Positioned(
                  child: UiUtils.getBannerButtonBox(100.w, 50.w, ColorStyles.upFinBannerSky, ColorStyles.upFinBannerSky,
                      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        SizedBox(width: 77.w, child: UiUtils.getAnimatedText("위기는 기회다!", ColorStyles.upFinWhite, 22.sp, FontWeight.w600, const Duration(milliseconds: 300), (){})),
                        UiUtils.getMarginBox(0, 10.h)
                      ]), () {})),
              Positioned(
                  right: 3.w,
                  child: UiUtils.getImage(50.w, 50.w, Image.asset(fit: BoxFit.fill,'assets/images/ani_man_search.gif'))),
            ]),
            UiUtils.getMarginBox(100.w, 3.h),
            Container(padding: EdgeInsets.only(right: 5.w, left : 5.w, bottom : 5.w), child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
              UiUtils.getRoundBoxTextWithFixedScale3(
                  UiUtils.getTextWithFixedScale("중개운영", 10.sp, FontWeight.w600, ColorStyles.upFinMainTitleColor1, TextAlign.start, null),
                  ColorStyles.upFinMainTitleBackColor1),
              UiUtils.getMarginBox(0, 1.h),
              UiUtils.getTextWithFixedScale2(Config.appMainIntroText1.replaceAll("@@", "\n"), 10.sp, FontWeight.w400, ColorStyles.upFinDarkGray, TextAlign.start, null),
              UiUtils.getMarginBox(0, 4.h),
              UiUtils.getRoundBoxTextWithFixedScale3(
                  UiUtils.getTextWithFixedScale("서비스운영", 10.sp, FontWeight.w600, ColorStyles.upFinMainTitleColor2, TextAlign.start, null),
                  ColorStyles.upFinMainTitleBackColor2),
              UiUtils.getMarginBox(0, 1.h),
              UiUtils.getTextWithFixedScale2(Config.appMainIntroText2.replaceAll("@@", "\n"), 10.sp, FontWeight.w400, ColorStyles.upFinDarkGray, TextAlign.start, null),
              UiUtils.getMarginBox(0, 2.h),
              UiUtils.getTextWithFixedScale2(Config.privacyText.replaceAll("@@", "\n"), 10.sp, FontWeight.w400, ColorStyles.upFinDarkGray, TextAlign.start, null),
              UiUtils.getMarginBox(0, 2.h),
              GestureDetector(child: Row(children: [
                UiUtils.getTextWithFixedScale("개인정보처리방침 바로가기:", 10.sp, FontWeight.w400, ColorStyles.upFinDarkGray, TextAlign.start, null),
                UiUtils.getTextWithUnderline(Config.privacyUrl, 10.sp, FontWeight.w400, ColorStyles.upFinDarkGray, TextAlign.start, null, ColorStyles.upFinDarkGray)
              ]),
              onTap: () async {
                Uri privacyLink = Uri.parse(Config.privacyUrl);
                if(await canLaunchUrl(privacyLink)){
                launchUrl(privacyLink);
                }
              }),
              UiUtils.getMarginBox(0, 2.h),
            ]))
          ])
      )),

    ]);
  }
  List<Widget> _getMyInfoWidgetList(){
    List<Widget> myInfoWidgetList = [];

    // 사건정보
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
      myInfoWidgetList.add(
          UiUtils.getAccidentBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinGray,
              Column(children: [
                UiUtils.getMarginBox(0, 1.h),
                Row(children: [
                  Expanded(flex: 15, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      UiUtils.getMarginBox(3.w, 0),
                      UiUtils.getBoxTextWithFixedScale("개인회생", 8.sp, FontWeight.w600, TextAlign.center, ColorStyles.upFinPrTitleBackColor, ColorStyles.upFinPrTitleColor),
                      UiUtils.getMarginBox(2.w, 0),
                      each.accidentAccountValidType == AccidentInfoData.needToCheckAccount1 || each.accidentAccountValidType == AccidentInfoData.needToCheckAccount2 ?
                        UiUtils.getBoxTextWithFixedScale("환급계좌 오류", 8.sp, FontWeight.w600, TextAlign.start, ColorStyles.upFinWhiteRed, ColorStyles.upFinRed) : Container()
                    ]),
                    UiUtils.getMarginBox(0, 0.5.h),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      UiUtils.getMarginBox(2.w, 0),
                      UiUtils.getImage(16.w, 16.w, Image.asset('assets/images/accident_icon.png', fit: BoxFit.fill)),
                      UiUtils.getMarginBox(1.w, 0),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        UiUtils.getTextWithFixedScale(each.accidentCourtInfo.split("@")[0], 10.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, 1),
                        UiUtils.getMarginBox(0, 0.5.h),
                        UiUtils.getTextWithFixedScale("${each.accidentCaseNumberYear}${each.accidentCaseNumberType}${each.accidentCaseNumberNumber}", 16.sp,
                            FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, null),
                      ]),
                      const Spacer(flex: 1),
                      Icon(Icons.arrow_forward_ios_rounded, color: ColorStyles.upFinDarkGray, size: 5.5.w),
                      UiUtils.getMarginBox(1.5.w, 0),
                    ]),
                  ])),
                ]),

                UiUtils.getMarginBox(0, 0.8.h),
                UiUtils.getBorderButtonBoxForSearch(80.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                    Row(mainAxisAlignment:MainAxisAlignment.center, children: [
                      UiUtils.getIcon(5.w, 5.w, Icons.search_rounded, 5.w, ColorStyles.upFinWhite),
                      UiUtils.getMarginBox(0.5.w, 0),
                      UiUtils.getTextWithFixedScale("대출상품 찾기", 12.sp, FontWeight.w700, ColorStyles.upFinWhite, TextAlign.center, null)
                    ]), () async {
                      MyData.selectedCarInfoData = null;
                      MyData.selectedAccidentInfoData = each;
                      if(MyData.selectedAccidentInfoData!.accidentAccountValidType == AccidentInfoData.needToCheckAccount1 ||
                          MyData.selectedAccidentInfoData!.accidentAccountValidType == AccidentInfoData.needToCheckAccount2){
                        isViewHere = false;
                        await CommonUtils.moveToWithResult(context, AppView.appAccidentDetailInfoView.value, null);
                        isViewHere = false;
                      }else{
                        AppUpdateAccidentViewState.isAccountEditMode = false;
                        AppUpdateAccidentViewState.startViewId = AppUpdateAccidentViewState.confirmedViewId;
                        AppUpdateAccidentViewState.endViewId = AppUpdateAccidentViewState.jobViewId;
                        isViewHere = false;
                        await CommonUtils.moveToWithResult(context, AppView.appUpdateAccidentView.value, null);
                        isViewHere = false;
                      }
                    })
              ]), () async {
                MyData.selectedCarInfoData = null;
                MyData.selectedAccidentInfoData = each;
                isViewHere = false;
                await CommonUtils.moveToWithResult(context, AppView.appAccidentDetailInfoView.value, null);
                isViewHere = false;
              })
      );
    }

    // 자동차정보
    List<String> carList = [];
    List<String> carIdList = [];
    List<CarInfoData> carInfoList = [];
    for(var each in GetController.to.carInfoDataList){
      String eachCarNum = each.carNum;
      for(var each2 in GetController.to.carInfoDataList){
        String each2CarNum = each2.carNum;
        if(eachCarNum == each2CarNum){
          bool isHere = false;
          for(var eachTemp in carList){
            if(eachTemp == eachCarNum) isHere = true;
          }
          if(!isHere) carList.add(eachCarNum);
        }
      }
    }

    for(var eachTemp in carList){
      int maxId = -1;
      for(var each in GetController.to.carInfoDataList){
        String eachCarNum = each.carNum;
        if(eachTemp == eachCarNum){
          int eachId = int.parse(each.id);
          if(eachId > maxId) maxId = eachId;
        }
      }
      carIdList.add("$eachTemp@$maxId");
    }

    for(var eachIdTemp in carIdList){
      String carNum = eachIdTemp.split("@")[0];
      String id = eachIdTemp.split("@")[1];
      for(var each in GetController.to.carInfoDataList){
        String eachCarNum = each.carNum;
        if(carNum == eachCarNum && id == each.id) carInfoList.add(each);
      }
    }

    for(var each in carInfoList){
      myInfoWidgetList.add(
          UiUtils.getAccidentBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinGray,
              Column(children: [
                UiUtils.getMarginBox(0, 1.h),
                Row(children: [
                  Expanded(flex: 15, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      UiUtils.getMarginBox(3.w, 0 ),
                      UiUtils.getBoxTextWithFixedScale("오토론", 8.sp, FontWeight.w600, TextAlign.center, ColorStyles.upFinPrTitleBackColor, ColorStyles.upFinPrTitleColor),
                    ]),
                    UiUtils.getMarginBox(0, 0.5.h),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      UiUtils.getMarginBox(5.w, 0),
                      UiUtils.getImage(16.w, 16.w, Image.asset('assets/images/icon_car.png', fit: BoxFit.fill)),
                      UiUtils.getMarginBox(3.w, 0),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        UiUtils.getTextWithFixedScale("${each.carModel}", 10.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, 1),
                        UiUtils.getMarginBox(0, 0.5.h),
                        UiUtils.getTextWithFixedScale(each.carNum, 16.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, null),
                      ]),
                      const Spacer(flex: 1),
                      Icon(Icons.arrow_forward_ios_rounded, color: ColorStyles.upFinDarkGray, size: 5.5.w),
                      UiUtils.getMarginBox(1.5.w, 0),
                    ]),
                  ])),
                ]),

                UiUtils.getMarginBox(0, 0.8.h),
                UiUtils.getBorderButtonBoxForSearch(80.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                    Row(mainAxisAlignment:MainAxisAlignment.center, children: [
                      UiUtils.getIcon(5.w, 5.w, Icons.search_rounded, 5.w, ColorStyles.upFinWhite),
                      UiUtils.getMarginBox(0.5.w, 0),
                      UiUtils.getTextWithFixedScale("대출상품 찾기", 12.sp, FontWeight.w700, ColorStyles.upFinWhite, TextAlign.center, null)
                    ]), () async {
                      MyData.selectedAccidentInfoData = null;
                      MyData.selectedCarInfoData = each;
                      AppUpdateCarViewState.startViewId = AppUpdateCarViewState.confirmedViewId;
                      AppUpdateCarViewState.endViewId = AppUpdateCarViewState.jobViewId;
                      isViewHere = false;
                      await CommonUtils.moveToWithResult(context, AppView.appUpdateCarView.value, null);
                      isViewHere = false;
                    })
              ]), () async {
                MyData.selectedAccidentInfoData = null;
                MyData.selectedCarInfoData = each;
                isViewHere = false;
                await CommonUtils.moveToWithResult(context, AppView.appCarDetailInfoView.value, null);
                isViewHere = false;
              })
      );
    }

    return myInfoWidgetList;
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
      if(lastMsg.contains("http")){
        String ext = lastMsg.split(".").last;
        if(LogfinController.validFileTypeList.contains(ext)){
          if(LogfinController.validDocFileTypeList.contains(ext)){
            lastMsg = "파일을 보냈습니다.";
          }else{
            lastMsg = "사진을 보냈습니다.";
          }
        }
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

      String roomType = each.chatRoomType == "1" ? "#개인회생" : "#오토론";

      loanChatRoomWidgetList.add(
          Column(children: [
            UiUtils.getMarginBox(0, 1.5.h),
            UiUtils.getBorderButtonBoxWithZeroPadding(92.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Expanded(flex: 2, child:  UiUtils.getImage(11.w, 11.w, Image.asset(each.chatRoomIconPath))),
                  UiUtils.getMarginBox(1.w, 0),
                  Expanded(flex: 10, child: Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      UiUtils.getMarginBox(0, 1.h),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        UiUtils.getTextWithFixedScale(roomType, 9.sp, FontWeight.w600, ColorStyles.upFinPrTitleColor, TextAlign.start, null),
                        UiUtils.getMarginBox(0, 0.5.h),
                        UiUtils.getTextWithFixedScale(each.chatRoomTitle, 14.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, null),
                        UiUtils.getMarginBox(0, 1.h),
                        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                          UiUtils.getRoundBoxTextWithFixedScale(LoanInfoData.getDetailStatusName(each.chatRoomLoanStatus), 7.sp,
                              FontWeight.w600, TextAlign.center,  each.chatRoomLoanStatus == "6" || each.chatRoomLoanStatus == "7"? ColorStyles.upFinWhiteRed : ColorStyles.upFinWhiteSky,
                              each.chatRoomLoanStatus == "6" || each.chatRoomLoanStatus == "7"? ColorStyles.upFinRed : ColorStyles.upFinButtonBlue),
                          UiUtils.getMarginBox(2.w, 0),
                          Expanded(child: UiUtils.getTextWithFixedScaleAndOverFlow(lastMsg, 10.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, 1))
                        ]),
                        UiUtils.getMarginBox(0, 0.2.h),
                      ])
                    ])
                  ])),
                  Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                   Row(mainAxisAlignment: MainAxisAlignment.end, children: [ UiUtils.getTextWithFixedScale(CommonUtils.getFormattedLastMsgTime(lastDateString), 8.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null), UiUtils.getMarginBox(0.5.w, 0) ],),
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
    CommonUtils.log("w","chatRoomId : $chatRoomId");
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
      for(var each in GetController.to.chatLoanInfoDataList){
        if(each.chatRoomId == chatRoomId){
          if(each.chatRoomType == "1"){
            LogfinController.autoAnswerMap = LogfinController.autoAnswerMapForAccident;
          }else{
            LogfinController.autoAnswerMap = LogfinController.autoAnswerMapForCar;
            for(var eachLoan in MyData.getLoanInfoList()){
              if(each.chatLoanUid == eachLoan.loanUid){
                CommonUtils.log("w","22 uid : ${eachLoan.loanUid}");
                CommonUtils.log("w","33 uid : ${eachLoan.uid}");
                for(var eachCar in MyData.getCarInfoList()){
                  if(eachLoan.uid == eachCar.carUid){
                    MyData.selectedCarInfoData = eachCar;
                    CommonUtils.log("w","44 uid : ${eachCar.carUid}");
                  }
                }
              }
            }
          }
        }
      }

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

  static void refreshMain(){
    LogfinController.getMainViewInfo((isSuccessToGetMainInfo){});
  }

  void _refreshMyView(BuildContext context) {
    UiUtils.showLoadingPop(context);
    LogfinController.getMainViewInfo((isSuccessToGetMainInfo){
      UiUtils.closeLoadingPop(context);
      setState(() {});
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
          SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("앱을 종료할까요?", 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)),
          UiUtils.getMarginBox(0, 3.h),
          UiUtils.getExpandedScrollView(Axis.vertical, const Column(children: [])),
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinButtonBlue,
              UiUtils.getTextWithFixedScale("나가기", 14.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, null), (){
                CommonUtils.resetData();
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
              Row(children: [UiUtils.getTextWithFixedScale("설정", 22.sp, FontWeight.w600, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)]), () {}),
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
                UiUtils.getTextWithFixedScale(MyData.isTestUser? "(${Config.appTestVersion.split("+").first})" : "(${Config.appVersion.split("+").first})", 14.sp, FontWeight.w300, ColorStyles.upFinDarkGray, TextAlign.start, null)
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
      Map<String, dynamic> map = await CommonUtils.readSettingsFromFile();
      if(map["push_room_id"] != ""){
        if(map["push_from"] == "F"){
          if(context.mounted) UiUtils.showLoadingPop(context);
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
          if(context.mounted) UiUtils.showLoadingPop(context);
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
    bool isRemove1week = false;
    int lineCnt = Config.appInfoTextMap["info_text"].toString().split("@@").length;
    double h = lineCnt*2.3.h;
    if(Config.appInfoTextMap["info_text_version"].toString() != "0"){
      UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, false, 100.w, Config.isAndroid? Config.isPad()? 35.5.h+h : 25.5.h+h : Config.isPad()? 40.5.h+h : 30.5.h+h, 0.5, (slideContext, slideSetState){
        return Center(child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
          UiUtils.getMarginBox(0, 1.h),
          SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("안내사항", 14.sp, FontWeight.w800, ColorStyles.upFinBlack, TextAlign.center, null)),
          UiUtils.getMarginBox(0, 3.h),
          UiUtils.getExpandedScrollView(Axis.vertical,
              Padding(padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 0, bottom: 0), child: UiUtils.getTextWithFixedScale2(Config.appInfoTextMap["info_text"].replaceAll("@@", "\n"), 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null))),
          UiUtils.getMarginBox(0, 0.5.h),
          UiUtils.getBorderButtonBoxWithZeroPadding(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
              Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment:CrossAxisAlignment.center, children: [
                UiUtils.getCustomCheckBox(UniqueKey(), 1.2, isRemove1week, ColorStyles.upFinButtonBlue, ColorStyles.upFinWhiteGray,
                    ColorStyles.upFinWhiteGray,  ColorStyles.upFinWhiteGray, (checkedValue){
                      if(checkedValue != null){
                        slideSetState((){
                          isRemove1week = checkedValue;
                        });
                      }
                    }),
                Expanded(child: UiUtils.getTextButtonWithFixedScale("일주일간 보지 않기", 10.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null, (){
                  slideSetState((){
                    if(isRemove1week){
                      isRemove1week = false;
                    }else{
                      isRemove1week = true;
                    }
                  });
                }))
              ])
              , () { slideSetState((){
                if(isRemove1week){
                  isRemove1week = false;
                }else{
                  isRemove1week = true;
                }
              });}),
          UiUtils.getMarginBox(0, 1.5.h),
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
              UiUtils.getTextWithFixedScale("확인", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null), () {
                SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceValidInfoVersion, Config.appInfoTextMap["info_text_version"].toString());
                DateTime laterDt = isRemove1week? CommonUtils.addWeekToTargetTime(CommonUtils.getCurrentLocalTime()) : CommonUtils.addTimeToTargetTime(CommonUtils.getCurrentLocalTime());
                SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceValidInfoDateKey, CommonUtils.convertTimeToString(laterDt));
                isInfoPopShow = false;
                Navigator.pop(slideContext);
                _detectPushClickFromBack();
              }),
          Config.isAndroid? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 5.h)
        ]));
      });
    }else{
      isInfoPopShow = false;
      _detectPushClickFromBack();
    }
  }

  double bottomBarHeight = 0;
  static bool isInfoPopShow = false;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(isViewHere){
        await CommonUtils.checkUpdate(context);
      }

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
            child: doCheckToSearchPr? Stack(alignment: Alignment.center, children: [
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
                  SizedBox(width: 80.w, child: UiUtils.getTextWithFixedScale("대출상품을 찾아볼까요?", 22.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.start, null)),
                  UiUtils.getMarginBox(0, 3.h),
                  UiUtils.getBorderButtonBox(80.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
                      UiUtils.getTextWithFixedScale("시작하기", 14.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.center, null), () async {
                        setState(() {
                          doCheckToSearchPr = false;
                        });
                        _showChoicePop();
                      }),
                  UiUtils.getMarginBox(0, 2.5.h),
                  SizedBox(width: 80.w, child: UiUtils.getTextButtonWithFixedScale("넘어가기", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null, (){
                    isViewHere = true;
                    setState(() {
                      doCheckToSearchPr = false;
                    });
                  })),
                ]),
              )),
              Positioned(
                  top: Config.isPad()? 60.h : 50.h,
                  child: Config.isPad()? UiUtils.getImage(100.w, 100.w, Image.asset(fit: BoxFit.fitHeight,'assets/images/img_woman_coffee.png')) :
                  UiUtils.getImage(150.w, 150.w, Image.asset(fit: BoxFit.fitWidth,'assets/images/img_woman_coffee.png')))
            ]) : Container()
        ),
        Positioned(child: Obx((){
          if(GetController.to.isAllSubscribed.value){
            return Container();
          }else{
            if(MyData.getChatRoomInfoList().isNotEmpty){
              return Container(
                  width: 100.w,
                  height: 100.h,
                  color: Colors.black54,
                  child: SpinKitWave(color: ColorStyles.upFinTextAndBorderBlue, size: 15.w)
              );
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