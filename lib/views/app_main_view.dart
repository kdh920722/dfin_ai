import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/configs/app_config.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/datas/chatroom_info_data.dart';
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
    return Column(children: [
      UiUtils.getMarginBox(0, 2.h),
      SizedBox(width: 95.w, height: 15.h, child:Stack(alignment: Alignment.center, children: [
        Positioned(
            child: UiUtils.getTopBannerButtonBox(90.w, 7.h, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                UiUtils.getTextWithFixedScale("업핀! 다이렉트 대출의시작!", 12.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, 1), () {

            })),
        Positioned(
            left: 0.5.w,
            child: UiUtils.getImage(25.w, 15.h, Image.asset(fit: BoxFit.fitHeight,'assets/images/img_man_banner.png'))),
      ])),
      UiUtils.getMarginBox(0, 1.h),
      Container(padding: EdgeInsets.only(left: 5.w, right: 5.w),
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
          const Spacer(flex: 2)
        ])),
        Obx((){
          List<Widget> accidentWidgetList = _getAccidentWidgetList();
          return accidentWidgetList.isNotEmpty ? Column(children: accidentWidgetList)
              : Column(children: [
            UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinRealGray,
                UiUtils.getTextWithFixedScale("사건기록이 없습니다.", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, null), () { })
          ]);
        }),
        UiUtils.getMarginBox(0, 2.h),
        Container(padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h, bottom: 1.h), child: Row(mainAxisSize: MainAxisSize.max, children: [
          UiUtils.getTextWithFixedScale("접수내역", 15.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, 1),
          const Spacer(flex: 2)
        ])),
        Obx((){
          List<Widget> loanWidgetList = _getLoanChatWidgetList();
          return loanWidgetList.isNotEmpty ? Column(children: loanWidgetList)
              : Column(children: [
            UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinRealGray,
                UiUtils.getTextWithFixedScale("접수내역이 없습니다.", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, null), () { })
          ]);
        }),
        UiUtils.getMarginBox(0, 4.h),
        Stack(alignment: Alignment.center, children: [
          Positioned(
              child: UiUtils.getBannerButtonBox(90.w, 50.w, ColorStyles.upFinBannerSky, ColorStyles.upFinBannerSky,
                  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SizedBox(width: 70.w, child: UiUtils.getTextWithFixedScale("빠르고", 25.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, 1)),
                    UiUtils.getMarginBox(0, 1.h),
                    SizedBox(width: 70.w, child: UiUtils.getTextWithFixedScale("쉽게", 25.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, 1)),
                    UiUtils.getMarginBox(0, 1.h),
                    SizedBox(width: 70.w, child: UiUtils.getTextWithFixedScale("대출받자!", 25.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, 1)),
                  ]), () {
              })),
          Positioned(
              right: 1.w,
              child: UiUtils.getImage(60.w, 60.w, Image.asset(fit: BoxFit.fill,'assets/images/img_woman_sports.png'))),
        ]),
        UiUtils.getMarginBox(0, 5.h),
      ])),

    ]);
  }
  List<Widget> _getAccidentWidgetList(){
    List<Widget> accidentWidgetList = [];
    if(GetController.to.isMainAccidentDataChanged.value){
      CommonUtils.log("", "accident view redraw!");
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
                          UiUtils.getTextWithFixedScale(each.accidentCourtInfo.split("@")[0], 10.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, 1),
                          UiUtils.getMarginBox(0, 0.7.h),
                          UiUtils.getTextWithFixedScale("${each.accidentCaseNumberYear}${each.accidentCaseNumberType}${each.accidentCaseNumberNumber}", 16.sp,
                              FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null),
                        ])
                      ]),
                      UiUtils.getMarginBox(0, 1.h),
                      UiUtils.getTextWithFixedScale("${each.accidentBankInfo.split("@")[0]} ${each.accidentBankAccount} / ${each.resData["resRepaymentList"][0]["resRoundNo2"]}회 납부", 10.sp, FontWeight.w600, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, 1),
                    ])),
                    Expanded(flex: 1, child: Icon(Icons.arrow_forward_ios_rounded, color: ColorStyles.upFinDarkGray, size: 5.5.w))
                  ]),
                ]), () {
                  MyData.selectedAccidentInfoData = each;
                  CommonUtils.moveTo(context, AppView.appAccidentDetailInfoView.value, null);
                })
        );
        accidentWidgetList.add(UiUtils.getMarginBox(0, 0.5.h));
      }
    }

    return accidentWidgetList;
  }
  List<Widget> _getLoanChatWidgetList(){
    List<Widget> loanChatRoomWidgetList = [];
    if(GetController.to.isMainLoanDataChanged.value){
      CommonUtils.log("", "loan view redraw!");
      for(var each in MyData.getChatRoomInfoList()){
        loanChatRoomWidgetList.add(
            Column(children: [
              UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinWhiteSky,
                  Row(mainAxisSize: MainAxisSize.max, children: [
                    Expanded(flex: 9, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        UiUtils.getMarginBox(0, 1.h),
                        UiUtils.getTextWithFixedScale(_getStatusName(each.chatRoomLoanStatus), 12.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, null),
                        UiUtils.getMarginBox(0, 2.h),
                        UiUtils.getTextWithFixedScaleAndOverFlow(each.chatRoomLastMsg, 10.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, 1)
                      ])
                    ])),
                    Expanded(flex: 1, child: each.chatRoomLastMsgCnt > 0? UiUtils.getCountCircleBox(5.w, each.chatRoomLastMsgCnt, 6.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, 1) : Container()),
                    Expanded(flex: 2, child: UiUtils.getTextWithFixedScale(CommonUtils.getFormattedLastMsgTime(each.chatRoomLastMsgTime), 8.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null))
                  ]), () {
                    CommonUtils.moveTo(context, AppView.appChatView.value, null);
                  })
            ])
        );
        loanChatRoomWidgetList.add(UiUtils.getMarginBox(0, 1.h));
      }
    }

    return loanChatRoomWidgetList;
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
  void _bankToHome(BuildContext context){
    MyData.resetMyData();
    CommonUtils.moveWithUntil(context, AppView.appRootView.value);
  }
  void _refreshMyView(BuildContext context){
    UiUtils.showLoadingPop(context);
    LogfinController.getMainViewInfo((isSuccessToGetMainInfo){
      UiUtils.closeLoadingPop(context);
    });
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
                  UiUtils.showSlideMenu(context, SlideType.bottomToTop, true, 100.w, MyData.getAccidentInfoList().length == 1 ? 38.h : 45.h, 0.5, (slideContext, slideSetState){
                    List<Widget> accidentWidgetList = [];
                    for(var each in MyData.getAccidentInfoList()){
                      accidentWidgetList.add(
                          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinRealWhite, ColorStyles.upFinGray,
                              Column(children: [
                                Row(children: [
                                  Expanded(flex: 15, child:Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(children: [
                                      UiUtils.getImage(12.w, 12.w, Image.asset('assets/images/accident_icon.png')),
                                      UiUtils.getMarginBox(2.w, 0),
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        UiUtils.getTextWithFixedScale(each.accidentCourtInfo.split("@")[0], 10.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.center, 1),
                                        UiUtils.getMarginBox(0, 0.7.h),
                                        UiUtils.getTextWithFixedScale("${each.accidentCaseNumberYear}${each.accidentCaseNumberType}${each.accidentCaseNumberNumber}", 16.sp,
                                            FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null),
                                      ])
                                    ]),
                                    UiUtils.getMarginBox(0, 1.h),
                                    UiUtils.getTextWithFixedScale("${each.accidentBankInfo.split("@")[0]} ${each.accidentBankAccount} / ${each.resData["resRepaymentList"][0]["resRoundNo2"]}회 납부", 10.sp, FontWeight.w600, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, 1),
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
                      accidentWidgetList.add(UiUtils.getMarginBox(0, 1.h));
                    }

                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      UiUtils.getMarginBox(0, 3.h),
                      UiUtils.getTextWithFixedScale("사건정보를 선택해주세요.", 16.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.center, 1),
                      UiUtils.getMarginBox(0, 3.h),
                      UiUtils.getExpandedScrollView(Axis.vertical, Column(children: accidentWidgetList)),
                      UiUtils.getMarginBox(0, 3.h),
                      UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinWhiteSky,
                          UiUtils.getTextWithFixedScale("사건 추가하기", 14.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.center, 1), () {
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
              }))
    ]);
  }

  Widget _getSettingView(){
    return Container(color: ColorStyles.upFinWhite, width: 100.w, height: 100.h, padding: EdgeInsets.all(5.w),
        child: Column(children: [
          UiUtils.getMarginBox(0, 5.h),
          UiUtils.getBorderButtonBoxWithZeroPadding(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
              Row(children: [UiUtils.getTextWithFixedScale("설정", 22.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, null)]), () {}),
          UiUtils.getMarginBox(0, 5.h),
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
              Row(children: [UiUtils.getTextWithFixedScale("사용자정보", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)]), () {

              }),
          UiUtils.getMarginBox(0, 1.h),
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
              Row(children: [UiUtils.getTextWithFixedScale("버전", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)]), () {

              }),
          UiUtils.getMarginBox(0, 1.h),
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
              Row(children: [UiUtils.getTextWithFixedScale("로그아웃", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)]), () {
                _bankToHome(context);
              }),
          UiUtils.getMarginBox(0, 1.h),
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
              Row(children: [UiUtils.getTextWithFixedScale("회원탈퇴", 12.sp, FontWeight.w500, ColorStyles.upFinRed, TextAlign.start, null)]), () {
                Map<String, dynamic> inputJson = {
                  "user" : {
                    "email": "lalalllaa@kakao.com",
                    "password": "1111111"
                  }
                };
                UiUtils.showLoadingPop(context);
                LogfinController.callLogfinApi(LogfinApis.deleteAccount, inputJson, (isSuccessToLogin, outputJson) async {
                  UiUtils.closeLoadingPop(context);
                  if(isSuccessToLogin){
                    CommonUtils.flutterToast("회원삭제 성공");
                    _bankToHome(context);
                  }else{
                    CommonUtils.flutterToast(outputJson!["error"]);
                  }
                });
              })
        ])
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Stack(
      children: [
        Positioned(
          child: Container(color: ColorStyles.upFinWhite, width: 100.w, height: 100.h, child: Column(children: [
            Expanded(child: viewTypeId == 1? _getApplyView() : viewTypeId == 2? _getMyView() : _getSettingView()),
            SizedBox(width: 100.w, height: 7.h, child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: [
              GestureDetector(child: Container(width: 30.w, height: 7.h, color: ColorStyles.upFinWhiteSky,
                  child: Center(child: UiUtils.getTextButtonWithFixedScale("대출", 13.sp, viewTypeId == 1? FontWeight.w800 : FontWeight.w300,
                      viewTypeId == 1? ColorStyles.upFinButtonBlue : ColorStyles.upFinTextAndBorderBlue, TextAlign.center, 1,(){setState(() {viewTypeId = 1;});}))),onTap: (){
                setState(() {viewTypeId = 1;});
              }),
              GestureDetector(child: Container(width: 40.w, height: 7.h, color: ColorStyles.upFinWhiteSky,
                  child: Center(child: UiUtils.getTextButtonWithFixedScale("MY", 13.sp, viewTypeId == 2? FontWeight.w800 : FontWeight.w300,
                      viewTypeId == 2? ColorStyles.upFinButtonBlue : ColorStyles.upFinTextAndBorderBlue, TextAlign.center, 1,(){setState(() {viewTypeId = 2;});}))
              ), onTap: () {setState(() {viewTypeId = 2;});}),
              GestureDetector(child: Container(width: 30.w, height: 7.h, color: ColorStyles.upFinWhiteSky,
                  child: Center(child: UiUtils.getTextButtonWithFixedScale("설정", 13.sp, viewTypeId == 3? FontWeight.w800 : FontWeight.w300,
                      viewTypeId == 3? ColorStyles.upFinButtonBlue : ColorStyles.upFinTextAndBorderBlue, TextAlign.center, 1,(){setState(() {viewTypeId = 3;});}))
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
                      setState(() {
                        doCheckToSearchAccident = false;
                      });
                      CommonUtils.moveTo(context, AppView.appSearchAccidentView.value, null);
                    }),
                UiUtils.getMarginBox(0, 2.h),
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
    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}