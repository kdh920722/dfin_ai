import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/datas/loan_info_data.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:upfin/views/app_main_view.dart';
import '../controllers/firebase_controller.dart';
import '../styles/TextStyles.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppCarDetailView extends StatefulWidget{
  @override
  AppCarDetailViewState createState() => AppCarDetailViewState();
}

class AppCarDetailViewState extends State<AppCarDetailView> with WidgetsBindingObserver, TickerProviderStateMixin{
  static BuildContext? mainContext;
  late final TabController _tabController;
  late AnimationController _aniController;

  @override
  void initState(){
    CommonUtils.log("d", "AppCarDetailView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 2, vsync: this);
    mainContext = context;
    Config.contextForEmergencyBack = context;
    Config.isEmergencyRoot = false;
    FireBaseController.setStateForForeground = null;
    _aniController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        lowerBound: 0.0,
        upperBound: 1.0);
  }

  @override
  void dispose(){
    CommonUtils.log("d", "AppCarDetailView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    MyData.selectedCarInfoData = null;
    _tabController.dispose();
    Config.contextForEmergencyBack = AppMainViewState.mainContext;
    _aniController.dispose();
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await CommonUtils.checkUpdate(context);
        CommonUtils.log('d','AppCarDetailView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('d','AppCarDetailView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('d','AppCarDetailView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('d','AppCarDetailView paused');
        break;
      default:
        break;
    }
  }

  int _getLoanCnt(){
    int cnt = 0 ;
    for(var each in MyData.getLoanInfoList()){
      String eachCarNum = "";
      for(var eachCar in MyData.getCarInfoList()){
        if(eachCar.carUid == each.uid) eachCarNum = eachCar.carNum;
      }
      String selectedCarNum = MyData.selectedCarInfoData!.carNum;
      if(eachCarNum == selectedCarNum){
        cnt++;
      }
    }
    return cnt;
  }

  List<Widget> _getLoanWidgetList(){
    List<Widget> loanWidgetList = [];
    int count = 0;
    loanWidgetList.add(UiUtils.getMarginBox(0, 3.h));
    for(var each in MyData.getLoanInfoList()){
      String eachCarNum = "";
      for(var eachCar in MyData.getCarInfoList()){
        if(eachCar.carUid == each.uid) eachCarNum = eachCar.carNum;
      }
      String selectedCarNum = MyData.selectedCarInfoData!.carNum;

      if(eachCarNum == selectedCarNum){
        loanWidgetList.add(
            UiUtils.getLoanListBorderButtonBox(90.w, ColorStyles.upFinWhite , ColorStyles.upFinGray,
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(padding: EdgeInsets.only(left: 6.w, right: 6.w),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      UiUtils.getMarginBox(0, 1.5.h),
                      SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScaleAndOverFlow(each.companyName, 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1)),
                      UiUtils.getMarginBox(0, 2.5.h),
                      SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("접수일", 11.sp, FontWeight.w600, ColorStyles.upFinDarkGrayWithAlpha, TextAlign.start, null)),
                      UiUtils.getMarginBox(0, 1.2.h),
                      SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(_setUpdateDate(each.createdDate), 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null)),
                      UiUtils.getMarginBox(0, 2.h),

                      SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("상품명", 11.sp, FontWeight.w600, ColorStyles.upFinDarkGrayWithAlpha, TextAlign.start, null)),
                      UiUtils.getMarginBox(0, 1.2.h),
                      SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScaleAndOverFlow(each.productName, 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, 1)),
                      UiUtils.getMarginBox(0, 2.h),

                      SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("한도", 11.sp, FontWeight.w600, ColorStyles.upFinDarkGrayWithAlpha, TextAlign.start, null)),
                      UiUtils.getMarginBox(0, 1.2.h),
                      SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(CommonUtils.getPriceFormattedString(double.parse(each.submitAmount)), 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, 1)),
                      UiUtils.getMarginBox(0, 2.h),

                      SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("금리", 11.sp, FontWeight.w600, ColorStyles.upFinDarkGrayWithAlpha, TextAlign.start, null)),
                      UiUtils.getMarginBox(0, 1.2.h),
                      SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("${each.submitRate}%", 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, 1)),
                      UiUtils.getMarginBox(0, 3.h),
                      Container(width: 90.w, decoration: BoxDecoration(
                        color: each.statueId == "6" || each.statueId == "7"? ColorStyles.upFinWhiteRed : ColorStyles.upFinWhiteSky, // 배경색 설정
                        borderRadius: BorderRadius.circular(1), // 모서리를 둥글게 하는 부분
                      ),child: Padding(padding: EdgeInsets.only(left: 2.5.w, right: 2.5.w, bottom: 3.w, top: 3.w),
                          child: UiUtils.getTextWithFixedScale(LoanInfoData.getDetailStatusName(each.statueId), 12.sp, FontWeight.w600,
                              each.statueId == "6" || each.statueId == "7"? ColorStyles.upFinRed : ColorStyles.upFinButtonBlue, TextAlign.center, 1))),
                      UiUtils.getMarginBox(0, 2.h),
                    ])
                  ),
                ]), () {})
        );

        loanWidgetList.add(UiUtils.getMarginBox(0, 3.h));
      }
      count++;
    }

    return loanWidgetList;
  }

  Widget _getCarWidgetList(){
    return Padding(padding: EdgeInsets.only(left: 8.w, right: 8.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UiUtils.getMarginBox(0, 5.h),
          SizedBox(width: 90.w, height: 18.h, child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment:CrossAxisAlignment.center, children: [
            Container(
                width: 65.w,
                color:ColorStyles.upFinWhite,
                alignment: Alignment.center,
                child: ExtendedImage.network(
                  MyData.selectedCarInfoData!.carImage,
                  fit: BoxFit.contain,
                  cache: true,
                  cacheMaxAge: const Duration(hours: 1),
                  shape: BoxShape.rectangle,
                  loadStateChanged: (ExtendedImageState state) {
                    switch (state.extendedImageLoadState) {
                      case LoadState.loading:
                        _aniController.reset();
                        if(state.loadingProgress != null && state.loadingProgress!.expectedTotalBytes != null){
                          int total = state.loadingProgress!.expectedTotalBytes!;
                          int val = state.loadingProgress!.cumulativeBytesLoaded;
                          return Center(
                              child: CircularProgressIndicator(
                                  color: ColorStyles.upFinWhite,
                                  value: val / total
                              )
                          );
                        }else{
                          return UiUtils.getImage(8.w, 8.w, Image.asset(fit: BoxFit.fill,'assets/images/chat_loading.gif'));
                        }
                      case LoadState.completed:
                        _aniController.forward();

                        return FadeTransition(
                          opacity: _aniController,
                          child: ExtendedRawImage(
                            image: state.extendedImageInfo?.image,
                            fit: BoxFit.contain,
                          ),
                        );
                      case LoadState.failed:
                        _aniController.reset();
                        return GestureDetector(
                          child: UiUtils.getIcon(10.w, 10.w, Icons.refresh_rounded, 10.w, ColorStyles.upFinRed),
                          onTap: () {
                            state.reLoadImage();
                          },
                        );
                    }
                  },
                )
            )
          ])),
          UiUtils.getMarginBox(0, 2.h),
          SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(MyData.selectedCarInfoData!.carModel, 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)),
          UiUtils.getMarginBox(0, 2.h),
          SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(CommonUtils.getPriceFormattedStringForFullPrice(double.parse(MyData.selectedCarInfoData!.carPrice)), 16.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, null)),
          UiUtils.getMarginBox(0, 4.h),
          SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("소유주", 11.sp, FontWeight.w600, ColorStyles.upFinDarkGrayWithAlpha , TextAlign.start, null)),
          UiUtils.getMarginBox(0, 2.h),
          SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(MyData.selectedCarInfoData!.carOwnerName, 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null)),
          UiUtils.getMarginBox(0, 4.h),
          SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("차량번호", 11.sp, FontWeight.w600, ColorStyles.upFinDarkGrayWithAlpha , TextAlign.start, null)),
          UiUtils.getMarginBox(0, 2.h),
          SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(MyData.selectedCarInfoData!.carNum, 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null)),
          UiUtils.getMarginBox(0, 4.h),
          SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("상세 모델명", 11.sp, FontWeight.w600, ColorStyles.upFinDarkGrayWithAlpha, TextAlign.start, null)),
          UiUtils.getMarginBox(0, 2.h),
          SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(MyData.selectedCarInfoData!.carModelDetail, 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null)),
          UiUtils.getMarginBox(0, 4.h),

        ])
    );
  }

  void back(){
    CommonUtils.hideKeyBoard();
    MyData.selectedCarInfoData = null;
    Navigator.pop(context);
  }

  String _setUpdateDate(String targetString){
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

  String _setUpdateDateForTitle(String targetString){
    String targetStringDate = CommonUtils.convertTimeToString(CommonUtils.parseToLocalTime(targetString));
    return "${targetStringDate.substring(0,4)}.${targetStringDate.substring(4,6)}.${targetStringDate.substring(6,8)} ${targetStringDate.substring(8,10)}:${targetStringDate.substring(10,12)}";
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Container(
      color: ColorStyles.upFinWhite,
      width: 100.w,
      height: 100.h,
      child: Column(children: [
        Container(color: ColorStyles.upFinWhite, width: 100.w, padding: EdgeInsets.only(bottom: 5.w, top: 2.w, left: 5.w, right: 5.w),
            child: Stack(children: [
              Positioned(
                top: 1.h,
                child: UiUtils.getBackButtonForMainView(() {
                  back();
                }),
              ),
              Positioned(
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      UiUtils.getMarginBox(0, 2.5.h),
                      UiUtils.getTextWithFixedScale("오토론", 22.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.center, 1),
                      UiUtils.getMarginBox(0, 1.h),
                      UiUtils.getTextWithFixedScale("업데이트 : ${_setUpdateDate(MyData.selectedCarInfoData!.date)}", 10.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.center, 1),
                    ])
                ),
              ),
            ])
        ),
        Expanded(child: Container(color: ColorStyles.upFinWhiteGray, child: MediaQuery(
            data : MediaQuery.of(context).copyWith(textScaleFactor : 1.1),
            child : SizedBox(width: 100.w, child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(color: ColorStyles.upFinWhite, width: 100.w,
                  child: Column(children: [
                    UiUtils.getMarginBox(0, 2.h),
                    SizedBox(width: 90.w, height: 5.h,
                        child: TabBar(
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
                            Tab(text: "차량정보"),
                            Tab(text: "접수내역"),
                          ],
                        )
                    )
                  ])
              ),
              Expanded(child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Container(color: ColorStyles.upFinWhite, padding: EdgeInsets.zero,
                      child: Column(children: [UiUtils.getExpandedScrollView(Axis.vertical, _getCarWidgetList())])
                  ),
                  _getLoanCnt() != 0 ? Container(color: ColorStyles.upFinWhiteGray, padding: EdgeInsets.zero,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        UiUtils.getExpandedScrollView(Axis.vertical, Column(mainAxisSize: MainAxisSize.min, children: _getLoanWidgetList()))
                      ])
                  ) : Container(color: ColorStyles.upFinWhiteGray,
                      child: Center(
                          child: UiUtils.getTextWithFixedScale("접수이력이 없습니다.", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null)
                      )
                  )
                ],
              )),
            ]))))),
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
    paint.strokeCap = StrokeCap.round; // 둥글게 된 모서리

    final indicatorRect = Rect.fromPoints(
      Offset(rect.left, rect.bottom - 2), // 네모 모서리 높이 조절
      Offset(rect.right, rect.bottom), // 네모 모서리 높이 조절
    );


    canvas.drawRect(indicatorRect, paint);
  }
}