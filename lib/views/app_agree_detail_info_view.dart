import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dfin/styles/ColorStyles.dart';
import '../configs/app_config.dart';
import '../controllers/firebase_controller.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppAgreeDetailInfoView extends StatefulWidget{
  @override
  AppAgreeDetailInfoViewState createState() => AppAgreeDetailInfoViewState();
}

class AppAgreeDetailInfoViewState extends State<AppAgreeDetailInfoView> with WidgetsBindingObserver{

  @override
  void initState(){
    CommonUtils.log("d", "AppAgreeDetailInfoView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Config.isEmergencyRoot = false;
    FireBaseController.setStateForForeground = null;
  }

  @override
  void dispose(){
    CommonUtils.log("d", "AppAgreeDetailInfoView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('d','AppAgreeDetailInfoView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('d','AppAgreeDetailInfoView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('d','AppAgreeDetailInfoView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('d','AppAgreeDetailInfoView paused');
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
    Widget subContents = Padding(padding: EdgeInsets.only(right: 5.w, left: 5.w), child: agreeInfo["contents"] as Widget);

    Widget view = Container(
        color: ColorStyles.upFinWhite,
        width: 100.w,
        height: 100.h,
        padding: EdgeInsets.only(bottom: 5.w, top: 3.w),
        child: Column(children: [
          SizedBox(width: 95.w, child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            UiUtils.getCloseButton(ColorStyles.upFinDarkGray, () {
              Navigator.pop(context, false);
            })
          ])),
          UiUtils.getMarginBox(0, 2.h),
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