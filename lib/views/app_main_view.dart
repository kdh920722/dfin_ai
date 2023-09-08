import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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
    List<String> accidentList = ["1"];
    List<Widget> accidentWidgetList = [];

    for(var each in accidentList){
      accidentWidgetList.add(
          GestureDetector(child: Container(width: 90.w, padding: EdgeInsets.all(5.w), decoration: BoxDecoration(border: Border.all(width: 2, color: ColorStyles.upFinGray)), //  POINT: BoxDecoration
              child: Row(mainAxisSize: MainAxisSize.max, children: [
                Expanded(flex: 15, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  UiUtils.getTextWithFixedScale("서울동부지방법원", 14.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.center, 1),
                  UiUtils.getMarginBox(0, 1.h),
                  UiUtils.getTextWithFixedScale("2022 개회 109233", 22.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.center, 1),
                  UiUtils.getMarginBox(0, 1.h),
                  UiUtils.getTextWithFixedScale("우리은행 10239481", 10.sp, FontWeight.w300, ColorStyles.upFinRealGray, TextAlign.center, 1),
                ])),
                Expanded(flex: 1, child: Icon(Icons.arrow_forward_ios_rounded, color: ColorStyles.upFinDarkGray, size: 5.5.w)),
              ])
          ), onTap: (){
            CommonUtils.log("i", "gogo");
          })
      );
    }

    return Column(children: [
      Container(height: 15.h, padding: EdgeInsets.all(5.w), child: Row(mainAxisSize: MainAxisSize.max, children: [
        UiUtils.getTextWithFixedScale("${MyData.name}님", 20.sp, FontWeight.w800, ColorStyles.upFinBlack, TextAlign.center, 1),
        const Spacer(flex: 2),
        UiUtils.getTextStyledButtonWithFixedScale("설정", 14.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.center, 1,(){

        })
      ])),
      Container(height: 10.h, padding: EdgeInsets.all(5.w), child: Row(mainAxisSize: MainAxisSize.max, children: [
        UiUtils.getTextWithFixedScale("나의 사건기록", 20.sp, FontWeight.w800, ColorStyles.darkGray, TextAlign.center, 1),
        const Spacer(flex: 2),
        UiUtils.getIconButtonWithBoxSize(ColorStyles.upFinWhiteSky, 15.w, 5.h, Icons.add, 3.h, ColorStyles.upFinButtonBlue, () {

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
      Container(color: ColorStyles.upFinButtonBlue, height: 8.h, child: Row(mainAxisSize: MainAxisSize.max, children: [
        const Spacer(flex: 1),
        UiUtils.getTextStyledButtonWithFixedScale("MY", 14.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.center, 1,(){
          setState(() {viewTypeId = 1;});
        }),
        const Spacer(flex: 2),
        UiUtils.getTextStyledButtonWithFixedScale("AI 어드바이저", 14.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.center, 1,(){
          setState(() {viewTypeId = 2;});
        }),
        const Spacer(flex: 2),
        UiUtils.getTextStyledButtonWithFixedScale("설정", 14.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.center, 1,(){
          setState(() {viewTypeId = 3;});
        }),
        const Spacer(flex: 1)
      ])),
    ]));
    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}