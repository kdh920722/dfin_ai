import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/styles/ColorStyles.dart';
import '../configs/app_config.dart';
import '../controllers/firebase_controller.dart';
import '../styles/TextStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppAgreeDetailInfoViewTest extends StatefulWidget{
  @override
  AppAgreeDetailInfoViewTestState createState() => AppAgreeDetailInfoViewTestState();
}

class AppAgreeDetailInfoViewTestState extends State<AppAgreeDetailInfoViewTest> with WidgetsBindingObserver{
  @override
  void initState(){
    CommonUtils.log("i", "AppAgreeDetailInfoView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Config.contextForEmergencyBack = context;
    Config.isEmergencyRoot = false;
    FireBaseController.setStateForForeground = null;
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppAgreeDetailInfoView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    Config.contextForEmergencyBack = null;
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

  Widget getHtmlViewForTest(){
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      HtmlWidget(
        htmlContentsText,
        customStylesBuilder: (element) {
          if (element.id.contains('type1')) {
            return {
              "color" : "black",
              "font-size": "12px",
              "line-height" : "120%",
              "font-weight": "normal"
            };
          }else if (element.id.contains('type2')) {
            return {
              "color" : "gray",
              "font-size": "14px",
              "line-height" : "150%",
              "font-weight": "bold"
            };
          }else if (element.id.contains('type3')) {
            return {
              "color" : "black",
              "font-size": "16px",
              "line-height" : "200%",
              "font-weight": "bold"
            };
          }else if (element.localName == 'button') {
            return {
              //"cursor": "pointer",
              //"display":"inlne-block",
              "text-align":"center",
              "background-color":"#3a6cff",
              "color" : "white",
              "font-size": "14px",
              "line-height" : "250%",
              "font-weight": "normal",
              "border-radius":"0.1em",
              "padding":"5px 20px"
            };
          }

          return null;
        },

        onTapUrl: (url) async {
          return true;
        },
        renderMode: RenderMode.column,
        textStyle: TextStyles.upFinHtmlTextStyle,
      )
    ]);
  }

  String htmlContentsText =
  """
  
  """;

  @override
  Widget build(BuildContext context) {
    Widget subContents = getHtmlViewForTest();
    Widget view = Container(
        color: ColorStyles.upFinWhite,
        width: 100.w,
        height: 100.h,
        padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w),
        child: Column(children: [
          SizedBox(width: 90.w, child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
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

    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }
}