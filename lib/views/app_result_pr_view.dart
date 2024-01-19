import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/configs/app_config.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:upfin/views/app_main_view.dart';
import '../controllers/firebase_controller.dart';
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
      widgetList.add(UiUtils.getBoxTextAndIconWithFixedScale(eachMsg, 8.sp, FontWeight.w500, TextAlign.start, ColorStyles.upFinWhiteRed, ColorStyles.upFinRed,
          Icons.warning_rounded, ColorStyles.upFinRed, 5.w));

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
            UiUtils.getBorderButtonBox(90.w, each.isPossible? ColorStyles.upFinRealWhite : ColorStyles.upFinRealWhite, each.isPossible? ColorStyles.upFinGray : ColorStyles.upFinGray,
                Row(mainAxisSize: MainAxisSize.max, children: [
                  Expanded(flex: 15, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(width: 90.w, child: Row(children: [
                      UiUtils.getImage(10.w, 10.w, Image.asset(each.productCompanyLogo)),
                      UiUtils.getMarginBox(1.5.w, 0),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        UiUtils.getTextWithFixedScale(each.productCompanyName, 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null),
                        UiUtils.getMarginBox(0, 0.5.h),
                        UiUtils.getTextWithFixedScaleAndOverFlow(each.productName, 10.sp, FontWeight.w300, ColorStyles.upFinBlack, TextAlign.start, null),
                      ])
                    ])),
                    UiUtils.getMarginBox(0, 2.h),
                    SizedBox(width: 80.w, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      SizedBox(width: 20.w,height: 2.5.h , child: UiUtils.getTextWithFixedScale("금리", 10.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, 1)),
                      UiUtils.getMarginBox(5.w, 0),
                      SizedBox(width: 45.w,height: 2.5.h , child: UiUtils.getTextWithFixedScale("한도", 10.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, 1))
                    ])),
                    SizedBox(width: 80.w, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      SizedBox(width: 20.w, child: UiUtils.getTextWithFixedScale("${each.productLoanMinRates}%", 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1)),
                      UiUtils.getMarginBox(5.w, 0),
                      SizedBox(width: 45.w, child: UiUtils.getTextWithFixedScale(CommonUtils.getPriceFormattedString(double.parse(each.productLoanLimit)), 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1))
                    ])),
                    // UiUtils.getMarginBox(0, 2.h),

                    each.isPossible? Container()
                        : UiUtils.getMarginBox(0, 1.h),
                    each.isPossible? Container()
                        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: _getMsgListIWidget(msgList)),
                  ])),
                  Expanded(flex: 1, child: each.isPossible? Icon(Icons.arrow_forward_ios_rounded, color: ColorStyles.upFinDarkGray , size: 4.5.w) : Container()),
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
                                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale2("중복상품 신청",14.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.center, null)),
                                UiUtils.getMarginBox(0, 3.h),
                                SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale2("신청하셨던 상품이에요, 다시 신청하시겠어요?",12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null)),
                              ]),
                              UiUtils.getMarginBox(0, 0.5.h),
                              SizedBox(width: 85.w, child: Row(children: [
                                UiUtils.getTextWithFixedScale2("마지막 신청일자 : ",12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null),
                                UiUtils.getTextWithFixedScale2(_getDateText(dupleDateList[0]),12.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)
                              ])),
                              UiUtils.getExpandedScrollView(Axis.vertical, Container()),
                              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                UiUtils.getBorderButtonBox(43.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                                    UiUtils.getTextWithFixedScale("네! 신청할게요", 12.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () async {
                                      Navigator.pop(slideContext);
                                      MyData.selectedPrInfoData = each;
                                      await _addAgreeInfoForProduct(MyData.selectedPrInfoData!.productDocCode);
                                      if(context.mounted){
                                        UiUtils.showAgreePop(context, "B", MyData.selectedPrInfoData!.productDocCode, () {
                                          UiUtils.showLoadingPop(context);
                                          if(each.uidType == "1"){
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
                                    }),
                                UiUtils.getMarginBox(2.w, 0),
                                UiUtils.getBorderButtonBox(43.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinWhiteSky,
                                    UiUtils.getTextWithFixedScale("아니오", 12.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, null), () async {
                                      Navigator.pop(slideContext);
                                    })
                              ]),
                              Config.isAndroid ? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 5.h),
                            ]
                        );
                      });
                    }else{
                      MyData.selectedPrInfoData = each;
                      await _addAgreeInfoForProduct(MyData.selectedPrInfoData!.productDocCode);
                      if(context.mounted){
                        UiUtils.showAgreePop(context, "B", MyData.selectedPrInfoData!.productDocCode, () {
                          UiUtils.showLoadingPop(context);
                          if(each.uidType == "1"){
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
                  }else{
                    CommonUtils.flutterToast("신청 불가능한 상풉이에요.");
                  }
                })
        );
        prInfoWidgetList.add(UiUtils.getMarginBox(0, 1.2.h));
      }
    }

    return UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: prInfoWidgetList));
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
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Container(color: ColorStyles.upFinWhiteGray, width: 100.w, height: 100.h, child:
    MediaQuery(
        data : MediaQuery.of(context).copyWith(textScaleFactor : 1.1),
        child : Column(children: [
          Container(color: ColorStyles.upFinWhite, width: 100.w, padding: EdgeInsets.only(top:3.w),
              child: Column(children: [
              SizedBox(width: 95.w, child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                UiUtils.getCloseButton(ColorStyles.upFinDarkGray, () {
                  MyData.selectedAccidentInfoData = null;
                  MyData.selectedCarInfoData = null;
                  MyData.selectedPrInfoData = null;
                  Navigator.pop(context);
                })
              ])),
              UiUtils.getMarginBox(0, 3.w),
              SizedBox(width: 90.w, child : UiUtils.getTextWithFixedScale("대출상품", 22.sp, FontWeight.w800, ColorStyles.upFinButtonBlue, TextAlign.start, 1)),
              UiUtils.getMarginBox(0, 1.h),
              SizedBox(width: 90.w, height: 5.h, child: TabBar(
                unselectedLabelStyle: TextStyles.upFinUnselectedTabTextInButtonStyle,
                unselectedLabelColor: ColorStyles.upFinRealGray,
                labelStyle: TextStyles.upFinSelectedTabTextInButtonStyle,
                labelColor: ColorStyles.upFinButtonBlue,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: MyPrTabIndicator(),
                indicatorColor: ColorStyles.upFinButtonBlue,
                dividerColor: ColorStyles.upFinWhiteSky,
                controller: _tabController,
                tabs: const <Widget>[
                  Tab(text: "신청 가능"),
                  Tab(text: "신청 불가능"),
                ],
              ))
            ])
          ),
          Expanded(child: Container(color: ColorStyles.upFinWhiteGray, width: 100.w,
              child: Column(children: [
                UiUtils.getMarginBox(0, 2.h),
                SizedBox(width: 90.w, height: 6.h, child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  UiUtils.getTextWithFixedScale("상품 ", 14.sp, FontWeight.w400, ColorStyles.upFinBlack, TextAlign.center, 1),
                  UiUtils.getTextWithFixedScale("$selectedTabCount개", 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.center, 1),
                  const Spacer(flex: 2),
                  UiUtils.getCustomTextButtonBox(22.w, "금리순", 9.sp, FontWeight.w600, isOrderByLimit? ColorStyles.upFinWhiteSky : ColorStyles.upFinButtonBlue,
                      isOrderByLimit? ColorStyles.upFinButtonBlue : ColorStyles.upFinWhiteSky, () {
                        _reOrderList(false);
                      }),
                  UiUtils.getMarginBox(1.5.w, 0),
                  UiUtils.getCustomTextButtonBox(22.w, "한도순", 9.sp, FontWeight.w600, isOrderByLimit? ColorStyles.upFinButtonBlue : ColorStyles.upFinWhiteSky,
                      isOrderByLimit? ColorStyles.upFinWhiteSky : ColorStyles.upFinButtonBlue, () {
                        _reOrderList(true);
                      })
                ])),
                Expanded(child: SizedBox(width:90.w, child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    possiblePrCnt>0 ? Column(children: [
                      UiUtils.getMarginBox(0, 2.h),
                      _getPrListView(true)
                    ]) : Center(child: UiUtils.getTextWithFixedScale("접수 가능한 상품이 없습니다.", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null)),
                    impossiblePrCnt>0 ? Column(children: [
                      UiUtils.getMarginBox(0, 2.h),
                      _getPrListView(false)
                    ]) : Center(child: UiUtils.getTextWithFixedScale("접수 불가능한 상품이 없습니다.", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null))
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
    paint.color = ColorStyles.upFinButtonBlue; // 인디케이터 색상
    paint.style = PaintingStyle.fill;
    paint.strokeCap = StrokeCap.round; // 둥글게 된 모서리

    final indicatorRect = Rect.fromPoints(
      Offset(rect.left, rect.bottom - 2), // 네모 모서리 높이 조절
      Offset(rect.right, rect.bottom), // 네모 모서리 높이 조절
    );

    canvas.drawRect(indicatorRect, paint);
  }
}