import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/configs/app_config.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import '../styles/TextStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppResultPrView extends StatefulWidget{
  @override
  AppResultPrViewState createState() => AppResultPrViewState();
}

class AppResultPrViewState extends State<AppResultPrView> with WidgetsBindingObserver, TickerProviderStateMixin{
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setImagePreLoad();
    });

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

    Config.contextForEmergencyBack = context;
    Config.isEmergencyRoot = false;
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppResultPrView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    Config.contextForEmergencyBack = null;
    MyData.selectedAccidentInfoData = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
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

  void _setImagePreLoad(){
    precacheImage(const AssetImage('assets/images/bank_logo_default.png'), context);
    precacheImage(const AssetImage('assets/images/bank_logo_safe.png'), context);
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
                      UiUtils.getImage(6.w, 6.w, Image.asset(each.productCompanyLogo)),
                      UiUtils.getMarginBox(1.5.w, 0),
                      UiUtils.getTextWithFixedScale(each.productCompanyName, 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null),
                    ])),
                    UiUtils.getMarginBox(0, 1.h),
                    UiUtils.getTextWithFixedScaleAndOverFlow(each.productName, 10.sp, FontWeight.w300, ColorStyles.upFinBlack, TextAlign.start, null),
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
                ]), () {
                  if(each.isPossible) {
                    CommonUtils.log("i","${each.productOfferLenderPrId} ${each.productOfferRid} ${each.productOfferId}");
                    bool isDuplicate = false;
                    for(var eachLoan in MyData.getLoanInfoList()){
                      if(eachLoan.lenderPrId == each.productOfferLenderPrId){
                        isDuplicate = true;
                      }
                    }
                    if(isDuplicate){
                      CommonUtils.flutterToast("이미 신청하신 상품입니다.");

                      // test
                      MyData.selectedPrInfoData = each;
                      UiUtils.showAgreePop(context, "B", () {
                        UiUtils.showLoadingPop(context);
                        LogfinController.getPrDocsList(MyData.selectedPrInfoData!.productOfferId, MyData.selectedPrInfoData!.productOfferRid, (isSuccessToSearchDocs, _) async {
                          UiUtils.closeLoadingPop(context);
                          if(isSuccessToSearchDocs){
                            CommonUtils.moveToWithResult(context, AppView.appApplyPrView.value, null);
                          }else{
                            CommonUtils.flutterToast("상품정보를 불러오는데\n실패했습니다.");
                            MyData.selectedPrInfoData = null;
                          }
                        });
                      });
                      // test

                    }else{
                      MyData.selectedPrInfoData = each;
                      UiUtils.showAgreePop(context, "B", () {
                        UiUtils.showLoadingPop(context);
                        LogfinController.getPrDocsList(MyData.selectedPrInfoData!.productOfferId, MyData.selectedPrInfoData!.productOfferRid, (isSuccessToSearchDocs, _) async {
                          UiUtils.closeLoadingPop(context);
                          if(isSuccessToSearchDocs){
                            CommonUtils.moveToWithResult(context, AppView.appApplyPrView.value, null);
                          }else{
                            CommonUtils.flutterToast("상품정보를 불러오는데\n실패했습니다.");
                            MyData.selectedPrInfoData = null;
                          }
                        });
                      });
                    }
                  }else{
                    CommonUtils.flutterToast("신청 불가능한 상풉입니다.");
                  }
                })
        );
        prInfoWidgetList.add(UiUtils.getMarginBox(0, 1.2.h));
      }
    }

    return UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: prInfoWidgetList));
  }

  void back(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(!CommonUtils.isValidStateByAPiExpiredDate()){
        CommonUtils.flutterToast("접속시간이 만료되었습니다.\n재로그인 해주세요");
        CommonUtils.backToHome(context);
      }
    });

    Widget view = Container(color: ColorStyles.upFinWhite, width: 100.w, height: 100.h, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: Column(children: [
      Row(children: [
        const Spacer(flex: 2),
        UiUtils.getIconButtonWithHeight(3.h, Icons.close, 25.sp, ColorStyles.upFinDarkGray, () {
          MyData.selectedAccidentInfoData = null;
          MyData.selectedPrInfoData = null;
          Navigator.pop(context);
        })
      ]),
      UiUtils.getMarginBox(0, 3.w),
      SizedBox(width: 95.w, height: 5.h , child : UiUtils.getTextWithFixedScale("대출상품", 24.sp, FontWeight.w800, ColorStyles.upFinButtonBlue, TextAlign.start, 1)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 95.w, height: 5.h, child: TabBar(
        unselectedLabelStyle: TextStyles.upFinUnselectedTabTextInButtonStyle,
        unselectedLabelColor: ColorStyles.upFinRealGray,
        labelStyle: TextStyles.upFinSelectedTabTextInButtonStyle,
        labelColor: ColorStyles.upFinBlack,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: MyPrTabIndicator(),
        indicatorColor: ColorStyles.upFinButtonBlue,
        dividerColor: ColorStyles.upFinWhiteSky,
        controller: _tabController,
        tabs: const <Widget>[
          Tab(text: "신청 가능"),
          Tab(text: "신청 불가능"),
        ],
      )),
      UiUtils.getMarginBox(0, 2.h),
      SizedBox(height: 6.h, child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        UiUtils.getTextWithFixedScale("상품 ", 14.sp, FontWeight.w400, ColorStyles.upFinBlack, TextAlign.center, 1),
        UiUtils.getTextWithFixedScale("$selectedTabCount개", 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.center, 1),
        const Spacer(flex: 2),
        UiUtils.getCustomTextButtonBox(20.w, "금리순", 9.sp, FontWeight.w600, isOrderByLimit? ColorStyles.upFinWhiteSky : ColorStyles.upFinButtonBlue,
            isOrderByLimit? ColorStyles.upFinButtonBlue : ColorStyles.upFinWhiteSky, () {
              _reOrderList(false);
            }),
        UiUtils.getMarginBox(1.5.w, 0),
        UiUtils.getCustomTextButtonBox(20.w, "한도순", 9.sp, FontWeight.w600, isOrderByLimit? ColorStyles.upFinButtonBlue : ColorStyles.upFinWhiteSky,
            isOrderByLimit? ColorStyles.upFinWhiteSky : ColorStyles.upFinButtonBlue, () {
              _reOrderList(true);
            })
      ])),
      SizedBox(width: 95.w, height: 65.h, child: TabBarView(
        controller: _tabController,
        children: <Widget>[
          possiblePrCnt>0 ? Column(children: [
            UiUtils.getMarginBox(0, 3.h),
            _getPrListView(true)
          ]) : Center(
            child: UiUtils.getTextWithFixedScale("접수 가능한 상품이 없습니다.", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null),
          ),
          impossiblePrCnt>0 ? Column(children: [
            UiUtils.getMarginBox(0, 3.h),
            _getPrListView(false)
          ]) : Center(
            child: UiUtils.getTextWithFixedScale("접수 불가능한 상품이 없습니다.", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null),
          )
        ],
      ))
    ]));
    return UiUtils.getViewWithAllowBackForAndroid(context, view, back);
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