import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/controllers/sharedpreference_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
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
    MyData.selectedAccidentInfoData = null;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppAccidentDetailView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
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
    //var formatter = DateFormat('yyyy년 M월 d일 $period$formattedHour시 $formattedMinute분', 'ko_KR');
    var formatter = DateFormat('yyyy년 M월 d일', 'ko_KR');
    String formattedDate = formatter.format(dateTime);

    return formattedDate;
  }

  List<Widget> _getLoanWidgetList(){
    List<Widget> loanWidgetList = [];
    for(var each in MyData.getLoanInfoList()){
      loanWidgetList.add(
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinGray,
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  UiUtils.getImage(10.w, 10.w, Image.asset(each.companyLogo)),
                  UiUtils.getMarginBox(2.w, 0),
                  SizedBox(width: 55.w, child: UiUtils.getTextWithFixedScaleAndOverFlow(each.companyName, 13.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1)),
                ]),
                UiUtils.getMarginBox(0, 2.h),
                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("현재상태", 10.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 1.h),
                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(_getStatusName(each.statueId), 12.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 2.h),
                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("한도", 10.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 1.h),
                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(CommonUtils.getPriceFormattedString(double.parse(each.submitAmount)), 12.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 2.h),
                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("금리", 10.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 1.h),
                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("${each.submitRate}%", 12.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 2.h),
                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("접수일", 10.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 1.h),
                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(_getFormattedDateString(each.createdDate), 12.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)),
              ]), () {})
      );
      loanWidgetList.add(UiUtils.getMarginBox(0, 1.h));
    }

    return loanWidgetList;
  }

  List<Widget> _getAccidentWidgetList(){
    List<Widget> accidentWidgetList = [];
    for(var each in MyData.getAccidentInfoList()){
      accidentWidgetList.add(
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinGray,
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  UiUtils.getImage(10.w, 10.w, Image.asset('assets/images/accident_icon.png')),
                  UiUtils.getMarginBox(2.w, 0),
                  SizedBox(width: 50.w, child: UiUtils.getTextWithFixedScale(each.accidentCaseNumberYear+each.accidentCaseNumberType+each.accidentCaseNumberNumber, 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)),
                  const Spacer(flex: 2),
                  UiUtils.getBorderButtonBoxWithZeroPadding(12.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinWhiteSky,
                      UiUtils.getTextWithFixedScale("편집", 10.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, null), () async {
                        MyData.selectedAccidentInfoData = each;
                        var result = await CommonUtils.moveToWithResult(context, AppView.appUpdateAccidentView.value, null) as bool;
                        if(result){
                          setState(() {});
                        }
                      })
                ]),
                UiUtils.getMarginBox(0, 2.h),
                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("법원", 10.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 1.h),
                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(each.accidentCourtInfo.split("@")[0], 12.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 2.h),
                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("환급계좌", 10.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 1.h),
                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("${each.accidentBankInfo.split("@")[0]} ${each.accidentBankAccount}", 12.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 2.h),
                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("변제정보", 10.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 1.h),
                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("월 변제금액 : ${CommonUtils.getPriceCommaFormattedString(double.parse(each.resData["resRepaymentList"][0]["resAmount"]))}원", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 0.5.h),
                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("납입회차 : ${each.resData["resRepaymentList"][0]["resRoundNo2"]}/${each.resData["resRepaymentList"][0]["resRoundNo1"]}", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 0.5.h),
                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("총입금액 : ${CommonUtils.getPriceCommaFormattedString(double.parse(each.resData["resRepaymentList"][0]["resTotalAmt"]))}원", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 0.5.h),
                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("상환주기 : ${each.resData["resRepaymentList"][0]["resRepaymentCycle"].toString().trim()} ${each.resData["resRepaymentList"][0]["resRepaymentDate"].toString().trim()}", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 0.5.h),
                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("미납회차 : ${double.parse(each.resData["resRepaymentList"][0]["resRoundNo"]).toInt()}회", 12.sp, FontWeight.w500, ColorStyles.upFinRed, TextAlign.start, null)),
                UiUtils.getMarginBox(0, 0.5.h),
                SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("미납금액 : ${CommonUtils.getPriceCommaFormattedString(double.parse(each.resData["resRepaymentList"][0]["resUnpaidAmt"]))}원", 12.sp, FontWeight.w500, ColorStyles.upFinRed, TextAlign.start, null)),

              ]), () {})
      );
      accidentWidgetList.add(UiUtils.getMarginBox(0, 1.h));
    }

    return accidentWidgetList;
  }

  void back(){
    CommonUtils.hideKeyBoard();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Container(
      color: ColorStyles.upFinWhite,
      width: 100.w,
      height: 100.h,
      padding: EdgeInsets.all(5.w),
      child: Column(children: [
        SizedBox(width: 95.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UiUtils.getIconButtonWithHeight(5.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () {
            Navigator.pop(context);
          }),
          UiUtils.getMarginBox(0, 2.h),
          SizedBox(width: 95.w, height: 5.h, child: TabBar(
            unselectedLabelStyle: TextStyles.upFinUnselectedTabTextInButtonStyle,
            unselectedLabelColor: ColorStyles.upFinRealGray,
            labelStyle: TextStyles.upFinSelectedTabTextInButtonStyle,
            labelColor: ColorStyles.upFinButtonBlue,
            indicator: MyTabIndicator(),
            dividerColor: ColorStyles.upFinWhite,
            controller: _tabController,
            tabs: const <Widget>[
              Tab(text: "사건정보"),
              Tab(text: "접수내역"),
            ],
          )),
          SizedBox(width: 95.w, height: 75.h, child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Column(children: [
                UiUtils.getMarginBox(0, 3.h),
                UiUtils.getExpandedScrollView(Axis.vertical, Column(children: _getAccidentWidgetList()))
              ]),
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
    final double indicatorWidth = rect.width*1.4; // 탭의 중간 길이
    final double indicatorHeight = 0.3.h; // 인디케이터 높이
    paint.strokeCap = StrokeCap.round; // 둥글게 된 모서리

    final Rect indicatorRect = Rect.fromCenter(
      center: rect.bottomCenter,
      width: indicatorWidth,
      height: indicatorHeight,
    );

    canvas.drawRect(indicatorRect, paint);
  }
}