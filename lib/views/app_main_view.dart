import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/configs/app_config.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppMainView extends StatefulWidget{
  @override
  AppMainViewState createState() => AppMainViewState();
}

class AppMainViewState extends State<AppMainView> with WidgetsBindingObserver{
  int viewTypeId = 1; // 1: MY / 2: AI어드바이저 / 3: 설정

  @override
  void initState(){
    CommonUtils.log("i", "AppMainView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    MyData.initSearchViewFromMainView = true;
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
    List<Widget> accidentWidgetList = [];
    for(var each in MyData.getAccidentInfoList()){
      accidentWidgetList.add(
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinRealWhite, ColorStyles.upFinGray,
              Row(mainAxisSize: MainAxisSize.max, children: [
                Expanded(flex: 15, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  UiUtils.getTextWithFixedScale(each.accidentCourtName, 14.sp, FontWeight.w600, ColorStyles.upFinTextAndBorderBlue, TextAlign.center, 1),
                  UiUtils.getMarginBox(0, 0.7.h),
                  UiUtils.getTextWithFixedScale("${each.accidentCaseNumberYear}${each.accidentCaseNumberType}${each.accidentCaseNumberNumber}", 16.sp,
                      FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null),
                  UiUtils.getMarginBox(0, 0.7.h),
                  UiUtils.getTextWithFixedScale("${each.accidentBankName} ${each.accidentBankAccount}", 10.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, 1),
                ])),
                Expanded(flex: 1, child: Icon(Icons.arrow_forward_ios_rounded, color: ColorStyles.upFinDarkGray, size: 5.5.w)),
              ]), () {
                UiUtils.showLoadingPop(context);
                LogfinController.getPrList("${each.accidentCaseNumberYear}${each.accidentCaseNumberType}${each.accidentCaseNumberNumber}", (isSuccessToGetOffers, _){
                  UiUtils.closeLoadingPop(context);
                  if(isSuccessToGetOffers){
                    CommonUtils.moveTo(context, AppView.resultPrView.value, null);
                  }else{
                    // findUidInAccidentInfoList 실패
                    CommonUtils.flutterToast("에러가 발생했습니다.");
                  }
                });
              })
      );
      accidentWidgetList.add(UiUtils.getMarginBox(0, 1.5.h));
    }

    return Column(children: [
      Container(padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h, bottom: 1.h),
          child: Row(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.end, children: [
            UiUtils.getTextWithFixedScale("${MyData.name}님, ", 26.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1),
            UiUtils.getTextWithFixedScale("안녕하세요!", 20.sp, FontWeight.w400, ColorStyles.upFinBlack, TextAlign.start, 1),
      ])),
      Container(padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h, bottom: 1.h), child: Row(mainAxisSize: MainAxisSize.max, children: [
        UiUtils.getTextWithFixedScale("사건기록", 20.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1),
        const Spacer(flex: 2),
        UiUtils.getIconButtonBox(18.w, ColorStyles.upFinWhiteSky, Icons.add, 3.h, ColorStyles.upFinButtonBlue, () {
          CommonUtils.moveTo(context, AppView.searchAccidentView.value, null);
        })
      ])),
      UiUtils.getExpandedScrollView(Axis.vertical, Column(children: accidentWidgetList))
    ]);
  }

  Widget _getAIChatView(){
    return Column(children: [
      Container(height: 10.h, padding: EdgeInsets.all(5.w), child: Row(mainAxisSize: MainAxisSize.max, children: [
        UiUtils.getTextWithFixedScale("나의 사건기록", 20.sp, FontWeight.w800, ColorStyles.darkGray, TextAlign.center, 1),
        const Spacer(flex: 2),
        UiUtils.getIconButtonWithBoxSize(ColorStyles.upFinWhiteSky, 15.w, 5.h, Icons.add, 3.h, ColorStyles.upFinButtonBlue, () {

        })
      ]))
    ]);
  }

  Widget _getSettingView(){
    return Column(children: [
      Container(height: 15.h, padding: EdgeInsets.all(5.w), child: Row(mainAxisSize: MainAxisSize.max, children: [
        UiUtils.getTextWithFixedScale("${MyData.name}님", 20.sp, FontWeight.w800, ColorStyles.upFinBlack, TextAlign.center, 1),
        const Spacer(flex: 2),
        UiUtils.getTextStyledButtonWithFixedScale("설정", 14.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.center, 1,(){

        })
      ]))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Container(color: ColorStyles.upFinWhite, width: 100.w, height: 100.h, child: Column(children: [
      viewTypeId == 1? Expanded(child: _getMyView()) : viewTypeId == 2? Expanded(child: _getAIChatView()) : Expanded(child: _getSettingView()),
      SizedBox(width: 100.w, height: 7.h, child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: [
        Container(width: 30.w, height: 7.h, color: ColorStyles.upFinWhiteSky,
            child: UiUtils.getTextStyledButtonWithFixedScale("MY", 13.sp, viewTypeId == 1? FontWeight.w800 : FontWeight.w400, viewTypeId == 1? ColorStyles.upFinButtonBlue : ColorStyles.upFinTextAndBorderBlue, TextAlign.center, 1,(){
          setState(() {viewTypeId = 1;});
        })),
        Container(width: 40.w, height: 7.h, color: ColorStyles.upFinWhiteSky,
            child: UiUtils.getTextStyledButtonWithFixedScale("AI 어드바이저", 13.sp, viewTypeId == 2? FontWeight.w800 : FontWeight.w400, viewTypeId == 2? ColorStyles.upFinButtonBlue : ColorStyles.upFinTextAndBorderBlue, TextAlign.center, 1,(){
          setState(() {viewTypeId = 2;});
        })),
        Container(width: 30.w, height: 7.h, color: ColorStyles.upFinWhiteSky,
            child: UiUtils.getTextStyledButtonWithFixedScale("설정", 13.sp, viewTypeId == 3? FontWeight.w800 : FontWeight.w400, viewTypeId == 3? ColorStyles.upFinButtonBlue : ColorStyles.upFinTextAndBorderBlue, TextAlign.center, 1,(){
          setState(() {viewTypeId = 3;});
        })),
      ])),
    ]));
    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}