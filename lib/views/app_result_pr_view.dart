import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:dfin/configs/app_config.dart';
import 'package:dfin/controllers/logfin_controller.dart';
import 'package:dfin/datas/my_data.dart';
import 'package:dfin/styles/ColorStyles.dart';
import 'package:dfin/views/app_main_view.dart';
import '../controllers/firebase_controller.dart';
import '../datas/pr_info_data.dart';
import '../styles/TextStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppResultPrView extends StatefulWidget{
  @override
  AppResultPrViewState createState() => AppResultPrViewState();
}

class AppResultPrViewState extends State<AppResultPrView> with WidgetsBindingObserver, TickerProviderStateMixin{
  static BuildContext? mainContext;

  late final TabController _tabController;
  int possiblePrCnt = 0;
  int impossiblePrCnt = 0;
  bool isOrderByLimit = false;
  late AnimationController _logoAniController;

  int selectedTabIndex = 0 ;
  int selectedTabCount = 0 ;
  int possiblePrCount = 0 ;
  int impossiblePrbCount = 0 ;
  @override
  void initState(){
    CommonUtils.log("i", "AppResultPrView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setPrCnt();
    MyData.selectedPrInfoData = null;
    _tabController = TabController(length: 2, vsync: this);

    _logoAniController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        lowerBound: 0.0,
        upperBound: 1.0);

    for(var each in MyData.getPrInfoList()){
      if(each.isPossible){
        possiblePrCount++;
      }else{
        impossiblePrbCount++;
      }
    }
    selectedTabCount = possiblePrCount;
    _tabController.addListener(() {
      selectedTabIndex = _tabController.index;
      setState(() {
        if(selectedTabIndex == 0){
          selectedTabCount = possiblePrCount;
        }else{
          selectedTabCount = impossiblePrbCount;
        }
      });
    });

    mainContext = context;
    Config.contextForEmergencyBack = context;
    Config.isEmergencyRoot = false;
    FireBaseController.setStateForForeground = null;
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppResultPrView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    _logoAniController.dispose();
    Config.contextForEmergencyBack = AppMainViewState.mainContext;
    MyData.selectedAccidentInfoData = null;
    MyData.selectedCarInfoData = null;
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await CommonUtils.checkUpdate(context);
        CommonUtils.log('i','AppResultPrView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('i','AppResultPrView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('i','AppResultPrView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('i','AppResultPrView paused');
        break;
      default:
        break;
    }
  }

  void setPrCnt(){
    for(var each in MyData.getPrInfoList()){
      if(each.isPossible){
        possiblePrCnt++;
      }else{
        impossiblePrCnt++;
      }
    }
  }

  void _reOrderList(bool orderByLimit){
    if(orderByLimit != isOrderByLimit){
      if(isOrderByLimit){
        isOrderByLimit = false;
      }else{
        isOrderByLimit = true;
      }
      setState(() {
        MyData.sortPrInfoListBy(isOrderByLimit);
      });
    }
  }

  List<Widget> _getMsgListIWidget(List<String> msgList){
    List<Widget> widgetList = [];
    for(var eachMsg in msgList){
      widgetList.add(UiUtils.getBoxTextAndIconWithFixedScale(eachMsg, 10.sp, FontWeight.w500, TextAlign.start, ColorStyles.dFinWhiteRed, ColorStyles.dFinRed,
          Icons.warning_rounded, ColorStyles.dFinRed, 5.w));

      widgetList.add(UiUtils.getMarginBox(0, 0.5.h));
    }
    return widgetList;
  }

  String _getDateText(String targetString){
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
    var formatter = DateFormat('yyyy.MM.dd  $period$formattedHour시 $formattedMinute분', 'ko_KR');
    String formattedDate = formatter.format(dateTime);

    return formattedDate;
  }

  Widget _getPrListView(bool isPossible){
    List<Widget> prInfoWidgetList = [];
    for(var each in MyData.getPrInfoList()){
      if(each.isPossible == isPossible){
        String msg = "";
        String eachMsg = "";
        List<String> msgList = [];
        for(int i = 0 ; i < each.failReason.length ; i++){
          if(each.failReason[i].contains("잔여한도")){
            String frontMsg = each.failReason[i].split("잔여한도")[0].replaceAll(",", "");
            String backMsg = "잔여한도:${CommonUtils.getPriceFormattedString(double.parse(each.failReason[i].split(" : ")[1]))}";
            eachMsg = "$frontMsg\n($backMsg)";
          }else{
            eachMsg = each.failReason[i];
          }

          msgList.add(eachMsg);

          if(i == each.failReason.length-1){
            msg+=eachMsg;
          }else{
            msg+="$eachMsg\n";
          }
        }

        prInfoWidgetList.add(
            UiUtils.getBorderButtonBox(90.w, each.isPossible? ColorStyles.dFinRealWhite : ColorStyles.dFinRealWhite, each.isPossible? ColorStyles.dFinGray : ColorStyles.dFinGray,
                Row(mainAxisSize: MainAxisSize.max, children: [
                  Expanded(flex: 15, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(width: 90.w, child: Row(children: [
                      CommonUtils.isUrlPath(each.productCompanyLogo) ? UiUtils.getCircleNetWorkImage(10.w, each.productCompanyLogo, _logoAniController)
                          : UiUtils.getImage(10.w, 10.w, Image.asset(each.productCompanyLogo)),
                      UiUtils.getMarginBox(1.5.w, 0),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        UiUtils.getTextWithFixedScale(each.productCompanyName, 14.sp, FontWeight.w500, ColorStyles.dFinBlack, TextAlign.start, null),
                        UiUtils.getMarginBox(0, 0.5.h),
                        UiUtils.getTextWithFixedScaleAndOverFlow(each.productName, 10.sp, FontWeight.w300, ColorStyles.dFinBlack, TextAlign.start, null),
                      ])
                    ])),
                    UiUtils.getMarginBox(0, 2.h),
                    SizedBox(width: 80.w, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      SizedBox(width: 20.w,height: 2.5.h , child: UiUtils.getTextWithFixedScale("금리", 10.sp, FontWeight.w500, ColorStyles.dFinButtonBlue, TextAlign.start, 1)),
                      UiUtils.getMarginBox(5.w, 0),
                      SizedBox(width: 45.w,height: 2.5.h , child: UiUtils.getTextWithFixedScale("한도", 10.sp, FontWeight.w500, ColorStyles.dFinButtonBlue, TextAlign.start, 1))
                    ])),
                    SizedBox(width: 80.w, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      SizedBox(width: 20.w, child: UiUtils.getTextWithFixedScale("${each.productLoanMinRates}%", 16.sp, FontWeight.w600, ColorStyles.dFinBlack, TextAlign.start, 1)),
                      UiUtils.getMarginBox(5.w, 0),
                      SizedBox(width: 45.w, child: UiUtils.getTextWithFixedScale(CommonUtils.getPriceFormattedString(double.parse(each.productLoanLimit)), 16.sp, FontWeight.w600, ColorStyles.dFinBlack, TextAlign.start, 1))
                    ])),
                    // UiUtils.getMarginBox(0, 2.h),

                    each.isPossible? Container()
                        : UiUtils.getMarginBox(0, 1.h),
                    each.isPossible? Container()
                        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: _getMsgListIWidget(msgList)),
                  ])),
                  Expanded(flex: 1, child: each.isPossible? Icon(Icons.arrow_forward_ios_rounded, color: ColorStyles.dFinDarkGray , size: 4.5.w) : Container()),
                ]), () async {
                  if(each.isPossible) {
                    bool isDuplicate = false;
                    List<String> dupleDateList = [];
                    for(var eachLoan in MyData.getLoanInfoList()){
                      CommonUtils.log("w","${each.uidType}  ${eachLoan.uidType}");
                      if(each.uidType == eachLoan.uidType){

                        if(eachLoan.lenderPrId == each.productOfferLenderPrId){
                          dupleDateList.add(eachLoan.createdDate);
                          isDuplicate = true;
                        }
                      }
                    }

                    if(isDuplicate){
                      dupleDateList.sort((a,b) => DateTime.parse(b).compareTo(DateTime.parse(a)));
                      UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, true, 100.w, Config.isAndroid ? Config.isPad()? 38.h : 28.h : Config.isPad()? 42.h : 32.h, 0.5, (slideContext, slideSetState){
                        return Column(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              UiUtils.getMarginBox(100.w, 1.h),
                              Column(children: [
                                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale2("중복상품 신청",14.sp, FontWeight.w600, ColorStyles.dFinWhiteGray, TextAlign.center, null)),
                                UiUtils.getMarginBox(0, 3.h),
                                SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale2("신청하셨던 상품이에요, 다시 신청하시겠어요?",12.sp, FontWeight.w500, ColorStyles.dFinWhiteGray, TextAlign.start, null)),
                              ]),
                              UiUtils.getMarginBox(0, 0.5.h),
                              SizedBox(width: 85.w, child: Row(children: [
                                UiUtils.getTextWithFixedScale2("마지막 신청일자 : ",12.sp, FontWeight.w500, ColorStyles.dFinWhiteGray, TextAlign.start, null),
                                UiUtils.getTextWithFixedScale2(_getDateText(dupleDateList[0]),12.sp, FontWeight.w600, ColorStyles.dFinWhiteGray, TextAlign.start, null)
                              ])),
                              UiUtils.getExpandedScrollView(Axis.vertical, Container()),
                              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                UiUtils.getBorderButtonBox(43.w, ColorStyles.dFinButtonBlue, ColorStyles.dFinButtonBlue,
                                    UiUtils.getTextWithFixedScale("네! 신청할게요", 12.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.start, null), () async {
                                      Navigator.pop(slideContext);
                                      //_showAgree(each);
                                      _showDetailView(each);
                                    }),
                                UiUtils.getMarginBox(2.w, 0),
                                UiUtils.getBorderButtonBox(43.w, ColorStyles.dFinBlack, ColorStyles.dFinBlack,
                                    UiUtils.getTextWithFixedScale("아니오", 12.sp, FontWeight.w600, ColorStyles.dFinWhiteGray, TextAlign.start, null), () async {
                                      Navigator.pop(slideContext);
                                    })
                              ]),
                              Config.isAndroid ? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 5.h),
                            ]
                        );
                      });
                    }else{
                      //_showAgree(each);
                      _showDetailView(each);
                    }
                  }else{
                    CommonUtils.flutterToast("신청 불가능한 상품이에요.");
                  }
                })
        );
        prInfoWidgetList.add(UiUtils.getMarginBox(0, 1.2.h));
      }
    }

    return UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: prInfoWidgetList));
  }

  List<Widget> _getEachDetailWidget(String title, String detailInfo){
    List<Widget> introWidgetList = [];
    introWidgetList.add(
        UiUtils.getMarginBox(0, 5.h)
    );
    introWidgetList.add(
        SizedBox(width: 80.w,
            child: UiUtils.getTextWithFixedScale(title, 11.sp, FontWeight.w600, ColorStyles.dFinDarkGrayWithAlpha, TextAlign.start, null)
        )
    );
    introWidgetList.add(
        UiUtils.getMarginBox(0, 1.h)
    );

    introWidgetList.add(
        SizedBox(width: 80.w,
            child: Row(children: [
              //UiUtils.getMarginBox(3.w, 0),
              SizedBox(width: 75.w, child: UiUtils.getTextWithFixedScale2(detailInfo == "" ? "정보없음" : "${detailInfo.replaceAll("(", "\n(")}", 14.sp, FontWeight.w500, detailInfo == "" ?  ColorStyles.dFinDarkGrayWithAlpha : ColorStyles.dFinBlack, TextAlign.start, null))
            ])
        )
    );
    return introWidgetList;
  }

  String _getDetailStringInfo(String keyString, Map<String, dynamic> info){
    String result = "";
    if(info.containsKey(keyString)){
      String infoString = info[keyString].toString();
      if(infoString != "" && infoString != "null"){
        result = infoString;
      }
    }

    return result;
  }

  void _showDetailView(PrInfoData selectedPrInfo){
    UiUtils.showPopMenu(context, false, 100.w, 100.h, 0.5, 0, ColorStyles.dFinWhite, (popContext, popSetState){
      List<Widget> introWidgetList = [];

      introWidgetList.add(
          UiUtils.getMarginBox(0, 1.h)
      );

      introWidgetList.add(
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 90.w, child: Row(children: [
              CommonUtils.isUrlPath(selectedPrInfo.productCompanyLogo) ? UiUtils.getCircleNetWorkImage(12.w, selectedPrInfo.productCompanyLogo, _logoAniController)
                  : UiUtils.getImage(12.w, 12.w, Image.asset(selectedPrInfo.productCompanyLogo)),
              UiUtils.getMarginBox(3.w, 0),
              Column(children: [
                SizedBox(width: 70.w, child: UiUtils.getTextWithFixedScaleAndOverFlow(selectedPrInfo.productCompanyName, 15.sp, FontWeight.w500, ColorStyles.dFinBlack, TextAlign.start, 1)),
                UiUtils.getMarginBox(0, 1.h),
                SizedBox(width: 70.w, child: UiUtils.getTextWithFixedScaleAndOverFlow(selectedPrInfo.productName, 10.sp, FontWeight.w600, ColorStyles.dFinRealGray, TextAlign.start, 1)),
              ])
            ])),
            UiUtils.getMarginBox(0, 3.h),
            SizedBox(width: 90.w, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              UiUtils.getBorderButtonBoxWithZeroPadding(41.w, ColorStyles.dFinRealWhite, ColorStyles.dFinGray,
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    UiUtils.getMarginBox(0, 2.h),
                    SizedBox(width: 30.w, child: UiUtils.getTextWithFixedScale("최저금리", 10.sp, FontWeight.w500, ColorStyles.dFinButtonBlue, TextAlign.start, 1)),
                    UiUtils.getMarginBox(0, 1.h),
                    SizedBox(width: 35.w, child: UiUtils.getTextWithFixedScale("${selectedPrInfo.productLoanMinRates}%", 15.sp, FontWeight.w600, ColorStyles.dFinBlack, TextAlign.start, 1)),
                    UiUtils.getMarginBox(0, 2.h),
                  ]), () {}),
              UiUtils.getMarginBox(2.w, 0),
              UiUtils.getBorderButtonBoxWithZeroPadding(41.w, ColorStyles.dFinRealWhite, ColorStyles.dFinGray,
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    UiUtils.getMarginBox(0, 2.h),
                    SizedBox(width: 30.w, child: UiUtils.getTextWithFixedScale("최대한도", 10.sp, FontWeight.w500, ColorStyles.dFinButtonBlue, TextAlign.start, 1)),
                    UiUtils.getMarginBox(0, 1.h),
                    SizedBox(width: 35.w, child: UiUtils.getTextWithFixedScale(CommonUtils.getPriceFormattedString(double.parse(selectedPrInfo.productLoanLimit)), 15.sp, FontWeight.w600, ColorStyles.dFinBlack, TextAlign.start, 1)),
                    UiUtils.getMarginBox(0, 2.h),
                  ]), () {})
            ]))
          ])
      );

      Map<String, dynamic> info = selectedPrInfo.lenderInfo;
      CommonUtils.log("i", "info  : $info");
      introWidgetList.addAll(_getEachDetailWidget("중도상환수수료", _getDetailStringInfo("prepayment_fee", info)));
      introWidgetList.addAll(_getEachDetailWidget("상환방식", _getDetailStringInfo("repayment_method", info)));
      introWidgetList.addAll(_getEachDetailWidget("상환기간", _getDetailStringInfo("repayment_term", info)));
      introWidgetList.addAll(_getEachDetailWidget("부대비용", _getDetailStringInfo("additional_fee", info)));
      introWidgetList.addAll(_getEachDetailWidget("이자납입", _getDetailStringInfo("delay_rate", info)));
      introWidgetList.addAll(_getEachDetailWidget("연체이자율", _getDetailStringInfo("interest_payment", info)));

      return UiUtils.getRowColumnWithAlignCenter([
        SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UiUtils.getBackButton(() async {
            Navigator.pop(popContext);
          }),
        ])),
        UiUtils.getMarginBox(0, 2.w),
        UiUtils.getExpandedScrollView(Axis.vertical, SizedBox(width: 85.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: introWidgetList))),
        UiUtils.getMarginBox(0, 4.h),
        UiUtils.getBorderButtonBox(90.w, ColorStyles.dFinButtonBlue, ColorStyles.dFinButtonBlue,
            UiUtils.getTextWithFixedScale("신청하기", 14.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.center, null), () async {
              MyData.selectedPrInfoData = selectedPrInfo;
              await _addAgreeInfoForProduct(MyData.selectedPrInfoData!.productDocCode);
              if(popContext.mounted){
                UiUtils.showAgreePop(popContext, "B", MyData.selectedPrInfoData!.productDocCode, () {
                  UiUtils.showLoadingPop(popContext);
                  if(selectedPrInfo.uidType == "1"){
                    LogfinController.getPrDocsList(MyData.selectedPrInfoData!.productOfferId, MyData.selectedPrInfoData!.productOfferRid, (isSuccessToSearchDocs, _) async {
                      UiUtils.closeLoadingPop(popContext);
                      Navigator.pop(popContext);
                      if(isSuccessToSearchDocs){
                        CommonUtils.moveToWithResult(context, AppView.appApplyPrView.value, null);
                      }else{
                        CommonUtils.flutterToast("상품정보를 불러오는데\n실패했어요.");
                        MyData.selectedPrInfoData = null;
                      }
                    });
                  }else{
                    LogfinController.getCarPrDocsList((isSuccessToSearchDocs, _) async {
                      UiUtils.closeLoadingPop(popContext);
                      Navigator.pop(popContext);
                      if(isSuccessToSearchDocs){
                        CommonUtils.moveToWithResult(context, AppView.appApplyPrView.value, null);
                      }else{
                        CommonUtils.flutterToast("상품정보를 불러오는데\n실패했어요.");
                        MyData.selectedPrInfoData = null;
                      }
                    });
                  }
                });
              }
            }),
        UiUtils.getMarginBox(0, 3.h)
      ]);
    });
  }

  Future<void> _showAgree(PrInfoData selectedPrInfo) async {
    MyData.selectedPrInfoData = selectedPrInfo;
    await _addAgreeInfoForProduct(MyData.selectedPrInfoData!.productDocCode);
    if(context.mounted){
      UiUtils.showAgreePop(context, "B", MyData.selectedPrInfoData!.productDocCode, () {
        UiUtils.showLoadingPop(context);
        if(selectedPrInfo.uidType == "1"){
          LogfinController.getPrDocsList(MyData.selectedPrInfoData!.productOfferId, MyData.selectedPrInfoData!.productOfferRid, (isSuccessToSearchDocs, _) async {
            UiUtils.closeLoadingPop(context);
            if(isSuccessToSearchDocs){
              CommonUtils.moveToWithResult(context, AppView.appApplyPrView.value, null);
            }else{
              CommonUtils.flutterToast("상품정보를 불러오는데\n실패했어요.");
              MyData.selectedPrInfoData = null;
            }
          });
        }else{
          LogfinController.getCarPrDocsList((isSuccessToSearchDocs, _) async {
            UiUtils.closeLoadingPop(context);
            if(isSuccessToSearchDocs){
              CommonUtils.moveToWithResult(context, AppView.appApplyPrView.value, null);
            }else{
              CommonUtils.flutterToast("상품정보를 불러오는데\n실패했어요.");
              MyData.selectedPrInfoData = null;
            }
          });
        }
      });
    }
  }

  Future<void> _addAgreeInfoForProduct(String productDocCode) async {
    if(productDocCode.contains("P")){
      UiUtils.showLoadingPop(context);
      var inputJson = {
        "type" : productDocCode
      };
      await LogfinController.callLogfinApi(LogfinApis.getAgreeDocuments, inputJson, (isSuccessToGetAgreeInfo, outputJsonForGetAgreeInfo){
        if(isSuccessToGetAgreeInfo){
          LogfinController.addAgreeInfo("B99", {"type" : "B99", "detailType": "B99@1@99", "isAgree": false, "result" : outputJsonForGetAgreeInfo});
        }
        UiUtils.closeLoadingPop(context);
      });
    }
  }

  void _back(){
    CommonUtils.moveWithUntil(context, AppView.appMainView.value);
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Container(color: ColorStyles.dFinWhiteGray, width: 100.w, height: 100.h, child:
    MediaQuery(
        data : MediaQuery.of(context).copyWith(textScaleFactor : 1.1),
        child : Column(children: [
          Container(color: ColorStyles.dFinWhite, width: 100.w, padding: EdgeInsets.only(top:3.w),
              child: Column(children: [
              SizedBox(width: 95.w, child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                UiUtils.getCloseButton(ColorStyles.dFinDarkGray, () {
                  MyData.selectedAccidentInfoData = null;
                  MyData.selectedCarInfoData = null;
                  MyData.selectedPrInfoData = null;
                  _back();
                })
              ])),
              UiUtils.getMarginBox(0, 3.w),
              SizedBox(width: 90.w, child : UiUtils.getTextWithFixedScale("대출상품", 22.sp, FontWeight.w800, ColorStyles.dFinButtonBlue, TextAlign.start, 1)),
              UiUtils.getMarginBox(0, 1.h),
              SizedBox(width: 90.w, height: 5.h, child: TabBar(
                unselectedLabelStyle: TextStyles.dFinUnselectedTabTextInButtonStyle,
                unselectedLabelColor: ColorStyles.dFinRealGray,
                labelStyle: TextStyles.dFinSelectedTabTextInButtonStyle,
                labelColor: ColorStyles.dFinButtonBlue,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: MyPrTabIndicator(),
                indicatorColor: ColorStyles.dFinButtonBlue,
                dividerColor: ColorStyles.dFinWhiteSky,
                controller: _tabController,
                tabs: const <Widget>[
                  Tab(text: "신청 가능"),
                  Tab(text: "신청 불가능"),
                ],
              ))
            ])
          ),
          Expanded(child: Container(color: ColorStyles.dFinWhiteGray, width: 100.w,
              child: Column(children: [
                UiUtils.getMarginBox(0, 2.h),
                SizedBox(width: 90.w, height: 6.h, child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  UiUtils.getTextWithFixedScale("상품 ", 14.sp, FontWeight.w400, ColorStyles.dFinBlack, TextAlign.center, 1),
                  UiUtils.getTextWithFixedScale("$selectedTabCount개", 16.sp, FontWeight.w600, ColorStyles.dFinBlack, TextAlign.center, 1),
                  const Spacer(flex: 2),
                  UiUtils.getCustomTextButtonBox(22.w, "금리순", 9.sp, FontWeight.w600, isOrderByLimit? ColorStyles.dFinWhiteSky : ColorStyles.dFinButtonBlue,
                      isOrderByLimit? ColorStyles.dFinButtonBlue : ColorStyles.dFinWhiteSky, () {
                        _reOrderList(false);
                      }),
                  UiUtils.getMarginBox(1.5.w, 0),
                  UiUtils.getCustomTextButtonBox(22.w, "한도순", 9.sp, FontWeight.w600, isOrderByLimit? ColorStyles.dFinButtonBlue : ColorStyles.dFinWhiteSky,
                      isOrderByLimit? ColorStyles.dFinWhiteSky : ColorStyles.dFinButtonBlue, () {
                        _reOrderList(true);
                      })
                ])),
                Expanded(child: SizedBox(width:90.w, child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    possiblePrCnt>0 ? Column(children: [
                      UiUtils.getMarginBox(0, 2.h),
                      _getPrListView(true)
                    ]) : Center(child: UiUtils.getTextWithFixedScale("접수 가능한 상품이 없습니다.", 12.sp, FontWeight.w500, ColorStyles.dFinBlack, TextAlign.center, null)),
                    impossiblePrCnt>0 ? Column(children: [
                      UiUtils.getMarginBox(0, 2.h),
                      _getPrListView(false)
                    ]) : Center(child: UiUtils.getTextWithFixedScale("접수 불가능한 상품이 없습니다.", 12.sp, FontWeight.w500, ColorStyles.dFinBlack, TextAlign.center, null))
                  ],
                )))
              ])
          ))
        ])
    )
    );
    return UiUtils.getViewWithAllowBackForAndroid(context, view, _back);
  }

}

class MyPrTabIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _MyPrTabIndicatorPainter(this, onChanged);
  }
}



class _MyPrTabIndicatorPainter extends BoxPainter {
  final MyPrTabIndicator decoration;

  _MyPrTabIndicatorPainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = offset & configuration.size!;
    final Paint paint = Paint();
    paint.color = ColorStyles.dFinButtonBlue; // 인디케이터 색상
    paint.style = PaintingStyle.fill;
    paint.strokeCap = StrokeCap.round; // 둥글게 된 모서리

    final indicatorRect = Rect.fromPoints(
      Offset(rect.left, rect.bottom - 2), // 네모 모서리 높이 조절
      Offset(rect.right, rect.bottom), // 네모 모서리 높이 조절
    );

    canvas.drawRect(indicatorRect, paint);
  }
}