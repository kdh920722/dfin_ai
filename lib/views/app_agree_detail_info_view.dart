import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/styles/ColorStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppAgreeDetailInfoView extends StatefulWidget{
  @override
  AppAgreeDetailInfoViewState createState() => AppAgreeDetailInfoViewState();
}

class AppAgreeDetailInfoViewState extends State<AppAgreeDetailInfoView> with WidgetsBindingObserver{

  @override
  void initState(){
    CommonUtils.log("i", "AppAgreeDetailInfoView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppAgreeDetailInfoView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('i','AppAgreeDetailInfoView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('i','AppAgreeDetailInfoView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('i','AppAgreeDetailInfoView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('i','AppAgreeDetailInfoView paused');
        break;
      default:
        break;
    }
  }

  void back(){
    CommonUtils.hideKeyBoard();
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> agreeInfo = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    String title = agreeInfo["title"].toString();
    Widget subContents = agreeInfo["contents"] as Widget;

    Widget view = Container(
      color: ColorStyles.upFinWhite,
      width: 100.w,
      height: 100.h,
      padding: EdgeInsets.all(5.w),
      child: Column(children: [
        Row(children: [
          const Spacer(flex: 2),
          UiUtils.getIconButtonWithHeight(5.h, Icons.close, 20.sp, ColorStyles.upFinRealGray, () async {
            Navigator.pop(context, false);
          })
        ]),
        UiUtils.getMarginBox(0, 3.h),
        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(title, 22.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)),
        UiUtils.getMarginBox(0, 5.h),
        UiUtils.getExpandedScrollView(Axis.vertical, subContents),
        UiUtils.getMarginBox(0, 3.h),
        UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
            UiUtils.getTextWithFixedScale("확인", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
              Navigator.pop(context, true);
            })
      ])
    );

    return UiUtils.getViewWithAllowBackForAndroid(context, view, back);
  }
}