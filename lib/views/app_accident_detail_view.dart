import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/datas/loan_info_data.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:upfin/views/app_update_accident_view.dart';
import '../styles/TextStyles.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppAccidentDetailView extends StatefulWidget{
  @override
  AppAccidentDetailViewState createState() => AppAccidentDetailViewState();
}

class AppAccidentDetailViewState extends State<AppAccidentDetailView> with WidgetsBindingObserver, TickerProviderStateMixin{
  late final TabController _tabController;
  @override
  void initState(){
    CommonUtils.log("i", "AppAccidentDetailView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 2, vsync: this);
    Config.contextForEmergencyBack = context;
    Config.isEmergencyRoot = false;
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppAccidentDetailView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    MyData.selectedAccidentInfoData = null;
    _tabController.dispose();
    Config.contextForEmergencyBack = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('i','AppAccidentDetailView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('i','AppAccidentDetailView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('i','AppAccidentDetailView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('i','AppAccidentDetailView paused');
        break;
      default:
        break;
    }
  }

  List<Widget> _getLoanWidgetList(){
    List<Widget> loanWidgetList = [];
    CommonUtils.log("i", "MyData.getLoanInfoList size : ${MyData.getLoanInfoList().length}");
    for(var each in MyData.getLoanInfoList()){
      CommonUtils.log("i", "accdient uid in loan : ${each.accidentUid}");
      String eachAccidentNum = "";
      for(var eachAccident in MyData.getAccidentInfoList()){
        if(eachAccident.accidentUid == each.accidentUid) eachAccidentNum = eachAccident.accidentCaseNumberYear+eachAccident.accidentCaseNumberType+eachAccident.accidentCaseNumberNumber;
      }
      String selectedAccidentNum = MyData.selectedAccidentInfoData!.accidentCaseNumberYear+MyData.selectedAccidentInfoData!.accidentCaseNumberType+MyData.selectedAccidentInfoData!.accidentCaseNumberNumber;

      if(eachAccidentNum == selectedAccidentNum){
        CommonUtils.log("i", "@@@");
        loanWidgetList.add(
            UiUtils.getLoanListBorderButtonBox(90.w, ColorStyles.upFinWhiteGray, ColorStyles.upFinWhiteGray,
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  UiUtils.getMarginBox(0, 1.h),
                  SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScaleAndOverFlow(each.companyName, 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1)),
                  UiUtils.getMarginBox(0, 4.h),

                  SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("접수일", 10.sp, FontWeight.w600, ColorStyles.upFinRealGray, TextAlign.start, null)),
                  UiUtils.getMarginBox(0, 1.h),
                  SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(_setUpdateDate(each.createdDate), 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null)),
                  UiUtils.getMarginBox(0, 3.h),

                  SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("상품명", 10.sp, FontWeight.w600, ColorStyles.upFinRealGray, TextAlign.start, null)),
                  UiUtils.getMarginBox(0, 1.h),
                  SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScaleAndOverFlow(each.productName, 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, 1)),
                  UiUtils.getMarginBox(0, 3.h),

                  SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("한도", 10.sp, FontWeight.w600, ColorStyles.upFinRealGray, TextAlign.start, null)),
                  UiUtils.getMarginBox(0, 1.h),
                  SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(CommonUtils.getPriceFormattedString(double.parse(each.submitAmount)), 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, 1)),
                  UiUtils.getMarginBox(0, 3.h),

                  SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("금리", 10.sp, FontWeight.w600, ColorStyles.upFinRealGray, TextAlign.start, null)),
                  UiUtils.getMarginBox(0, 1.h),
                  SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("${each.submitRate}%", 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, 1)),
                  UiUtils.getMarginBox(0, 3.h),

                  UiUtils.getMarginColoredBox(90.w, 0.3.h, ColorStyles.upFinGray),
                  UiUtils.getMarginBox(0, 2.h),
                  SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(LoanInfoData.getDetailStatusName(each.statueId), 16.sp, FontWeight.w700, ColorStyles.upFinButtonBlue, TextAlign.start, null)),

                ]), () {})
        );
        loanWidgetList.add(UiUtils.getMarginBox(0, 1.h));
      }
    }

    return loanWidgetList;
  }

  Widget _getAccidentWidgetList(){
    bool isSuccessToGetDetailInfo = MyData.isPossibleAccidentInfo(MyData.selectedAccidentInfoData!);
    if(!isSuccessToGetDetailInfo){
      CommonUtils.flutterToast("환급계좌정보가 잘못되었습니다.\n수정해주세요.");
    }

    CommonUtils.log("i", MyData.selectedAccidentInfoData!.resData["resRepaymentList"][0]["resAmount"]);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      UiUtils.getMarginBox(0, 4.h),

      SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("사건번호", 10.sp, FontWeight.w600, ColorStyles.upFinSky, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(MyData.selectedAccidentInfoData!.accidentCaseNumberYear+
          MyData.selectedAccidentInfoData!.accidentCaseNumberType+MyData.selectedAccidentInfoData!.accidentCaseNumberNumber, 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 4.h),

      SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("법원", 10.sp, FontWeight.w600, ColorStyles.upFinSky, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(MyData.selectedAccidentInfoData!.accidentCourtInfo.split("@")[0], 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 4.h),
      Row(children: [
        Column(children: [
          SizedBox(width: 70.w, child: UiUtils.getTextWithFixedScale(isSuccessToGetDetailInfo ? "환급계좌" : "환급계좌 오류", 10.sp, FontWeight.w600, isSuccessToGetDetailInfo ? ColorStyles.upFinSky : ColorStyles.upFinRed, TextAlign.start, null)),
          UiUtils.getMarginBox(0, 1.h),
          SizedBox(width: 70.w, child: UiUtils.getTextWithFixedScale("${MyData.selectedAccidentInfoData!.accidentBankInfo.split("@")[0]} / ${MyData.selectedAccidentInfoData!.accidentBankAccount}", 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null)),
        ]),
        const Spacer(flex: 2),
        UiUtils.getBorderButtonBoxWithZeroPadding(18.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinWhiteSky,
            UiUtils.getTextWithFixedScale("변경", 10.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, null), () async {
              AppUpdateAccidentViewState.isAccountEditMode = true;
              AppUpdateAccidentViewState.startViewId = AppUpdateAccidentViewState.bankCodeViewId;
              AppUpdateAccidentViewState.endViewId = AppUpdateAccidentViewState.bankAccountViewId;
              var result = await CommonUtils.moveToWithResult(context, AppView.appUpdateAccidentView.value, null) as bool;
              if(result){
                String thisAccidentNum = MyData.selectedAccidentInfoData!.accidentCaseNumberYear+MyData.selectedAccidentInfoData!.accidentCaseNumberType+MyData.selectedAccidentInfoData!.accidentCaseNumberNumber;
                String updatedAccidentUid = MyData.findUidInAccidentInfoList(thisAccidentNum);
                CommonUtils.log("i", "updatedAccidentUid $updatedAccidentUid");
                for(var each in MyData.getAccidentInfoList()){
                  CommonUtils.log("i", "updatedAccidentInfo ===> ${each.id} ${each.accidentUid} ${each.accidentBankAccount}");
                  if(each.accidentUid == updatedAccidentUid){
                    MyData.selectedAccidentInfoData = each;
                  }
                }
                setState(() {});
              }
            }),
        UiUtils.getMarginBox(2.w, 0),
      ]),
      UiUtils.getMarginBox(0, 4.h),
      isSuccessToGetDetailInfo? Column(children: [
        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("변제정보", 10.sp, FontWeight.w600, ColorStyles.upFinSky, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 1.h),
        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("•  월 변제금액 : ${CommonUtils.getPriceCommaFormattedString(double.parse(MyData.selectedAccidentInfoData!.resData["resRepaymentList"][0]["resAmount"]))}원", 14.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 1.h),
        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("•  납입회차 : ${MyData.selectedAccidentInfoData!.resData["resRepaymentList"][0]["resRoundNo2"]}/${MyData.selectedAccidentInfoData!.resData["resRepaymentList"][0]["resRoundNo1"]}", 14.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 1.h),
        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("•  총입금액 : ${CommonUtils.getPriceCommaFormattedString(double.parse(MyData.selectedAccidentInfoData!.resData["resRepaymentList"][0]["resTotalAmt"]))}원", 14.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 1.h),
        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("•  상환주기 : ${MyData.selectedAccidentInfoData!.resData["resRepaymentList"][0]["resRepaymentCycle"].toString().trim()} ${MyData.selectedAccidentInfoData!.resData["resRepaymentList"][0]["resRepaymentDate"].toString().trim()}", 14.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 1.h),
        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("•  미납회차 : ${double.parse(MyData.selectedAccidentInfoData!.resData["resRepaymentList"][0]["resRoundNo"]).toInt()}회", 14.sp, FontWeight.w500, ColorStyles.upFinRed, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 1.h),
        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("•  미납금액 : ${CommonUtils.getPriceCommaFormattedString(double.parse(MyData.selectedAccidentInfoData!.resData["resRepaymentList"][0]["resUnpaidAmt"]))}원", 14.sp, FontWeight.w500, ColorStyles.upFinRed, TextAlign.start, null)),
      ]) : Container(),
    ]);
  }

  void back(){
    CommonUtils.hideKeyBoard();
    MyData.selectedAccidentInfoData = null;
    Navigator.pop(context);
  }

  String _setUpdateDate(String targetString){
    // 문자열을 DateTime 객체로 변환
    CommonUtils.log("i", "targetString $targetString");
    DateTime dateTime = DateTime.parse(targetString);
    // 대한민국 시간대로 설정
    dateTime = dateTime.toLocal();

    // 오전과 오후를 구분하여 표시
    String period = dateTime.hour < 12 ? '오전' : '오후';

    // 시간, 분을 0이 붙은 두 자리로 포맷팅
    String formattedHour = DateFormat('h', 'ko_KR').format(dateTime);
    String formattedMinute = DateFormat('m', 'ko_KR').format(dateTime);

    // 날짜와 시간을 원하는 형식으로 포맷팅
    var formatter = DateFormat('yyyy.MM.dd $period$formattedHour시 $formattedMinute분', 'ko_KR');
    String formattedDate = formatter.format(dateTime);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    if(CommonUtils.isValidStateByAPiExpiredDate()){
      Widget view = Container(
        color: ColorStyles.upFinWhite,
        width: 100.w,
        height: 100.h,
        padding: EdgeInsets.only(bottom: 5.w, top: 2.w, left: 5.w, right: 5.w),
        child: Column(children: [
          Stack(children: [
            Positioned(
              top: 1.h,
              left: 5.w,
              child: UiUtils.getBackButton(() {
                back();
              }),
            ),
            Positioned(
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    UiUtils.getMarginBox(0, 2.5.h),
                    UiUtils.getTextWithFixedScale("개인회생", 22.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.center, 1),
                    UiUtils.getMarginBox(0, 1.h),
                    UiUtils.getTextWithFixedScale(_setUpdateDate(MyData.selectedAccidentInfoData!.date), 10.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.center, 1),
                  ])
              ),
            ),
          ]),
          SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            UiUtils.getMarginBox(0, 2.h),
            SizedBox(width: 95.w, height: 5.h, child: TabBar(
              unselectedLabelStyle: TextStyles.upFinUnselectedTabTextInButtonStyle,
              unselectedLabelColor: ColorStyles.upFinRealGray,
              labelStyle: TextStyles.upFinSelectedTabTextInButtonStyle,
              labelColor: ColorStyles.upFinButtonBlue,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: MyTabIndicator(),
              indicatorColor: ColorStyles.upFinButtonBlue,
              dividerColor: ColorStyles.upFinWhiteSky,
              controller: _tabController,
              tabs: const <Widget>[
                Tab(text: "사건정보"),
                Tab(text: "접수내역"),
              ],
            )),
            SizedBox(width: 95.w, height: 75.h, child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Column(children: [UiUtils.getExpandedScrollView(Axis.vertical, _getAccidentWidgetList())]),
                MyData.getLoanInfoList().isNotEmpty ? Column(children: [
                  UiUtils.getMarginBox(0, 3.h),
                  UiUtils.getExpandedScrollView(Axis.vertical, Column(children: _getLoanWidgetList()))
                ]) : Center(
                  child: UiUtils.getTextWithFixedScale("접수이력이 없습니다.", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null),
                )
              ],
            )),
          ])),

        ]),
      );

      return UiUtils.getViewWithAllowBackForAndroid(context, view, back);
    }else{
      CommonUtils.flutterToast("접속시간이 만료되었습니다.\n재로그인 해주세요");
      CommonUtils.backToHome(context);
      return Container();
    }
  }
}

class MyTabIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _MyTabIndicatorPainter(this, onChanged);
  }
}

class _MyTabIndicatorPainter extends BoxPainter {
  final MyTabIndicator decoration;

  _MyTabIndicatorPainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

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