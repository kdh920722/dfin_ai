import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/configs/app_config.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppResultPrView extends StatefulWidget{
  @override
  AppResultPrViewState createState() => AppResultPrViewState();
}

class AppResultPrViewState extends State<AppResultPrView> with WidgetsBindingObserver{
  bool isOrderByLimit = false;

  @override
  void initState(){
    CommonUtils.log("i", "AppResultPrView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppResultPrView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
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

  void _reOrderList(){
    setState(() {
      if(isOrderByLimit){
        isOrderByLimit = false;
      }else{
        isOrderByLimit = true;
      }
      MyData.prInfoListReOrderBy(isOrderByLimit);
    });

  }

  Widget _getPrListView(){
    List<Widget> prInfoWidgetList = [];
    for(var each in MyData.getPrInfoList()){
      String msg = "";
      for(String eachMsg in each.failReason){
        if(eachMsg.contains("잔여한도")){
          String frontMsg = eachMsg.split("잔여한도")[0].replaceAll(",", "");
          String backMsg = "잔여한도:${CommonUtils.getPriceFormattedString(double.parse(eachMsg.split(" : ")[1]))}";
          eachMsg = "$frontMsg\n($backMsg)";
        }
        msg+="$eachMsg\n";

      }
      prInfoWidgetList.add(
          GestureDetector(child: Container(width: 90.w, padding: EdgeInsets.all(4.w), decoration: BoxDecoration(border: Border.all(width: 1.7, color: each.isPossible? ColorStyles.upFinTextAndBorderBlue : ColorStyles.upFinRed)), //  POINT: BoxDecoration
              child: Row(mainAxisSize: MainAxisSize.max, children: [
                Expanded(flex: 15, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(width: 90.w, child: Row(children: [
                    UiUtils.getTextWithFixedScale(each.productCompanyName, 14.sp, FontWeight.w800, ColorStyles.upFinDarkGray, TextAlign.center, 1),
                    const Spacer(flex: 2),
                    each.isPossible? UiUtils.getTextWithFixedScale("신청 가능", 10.sp, FontWeight.w700, ColorStyles.upFinTextAndBorderBlue, TextAlign.center, 1) : UiUtils.getTextWithFixedScale("신청 불가능", 10.sp, FontWeight.w700, ColorStyles.upFinRed, TextAlign.center, 1),
                  ])),
                  UiUtils.getMarginBox(0, 1.h),
                  UiUtils.getTextWithFixedScale(each.productName, 10.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.center, 1),
                  UiUtils.getMarginBox(0, 2.h),
                  Row(children: [
                    UiUtils.getTextWithFixedScale("${each.productLoanRates}%", 18.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.center, 1),
                    UiUtils.getMarginBox(2.w, 0),
                    UiUtils.getTextWithFixedScale(CommonUtils.getPriceFormattedString(double.parse(each.productLoanLimit)), 18.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.center, 1),
                  ]),
                  UiUtils.getMarginBox(0, 1.h),
                  each.isPossible? UiUtils.getTextWithFixedScale(msg, 10.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null) : UiUtils.getTextWithFixedScale(msg, 10.sp, FontWeight.w500, ColorStyles.upFinRed, TextAlign.start, null),
                  UiUtils.getCustomTextButtonBox(28.w, "상세보기", 12.sp, FontWeight.w600, ColorStyles.upFinWhiteSky, ColorStyles.upFinDarkGray, () {

                  })
                ])),
                Expanded(flex: 1, child: each.isPossible? Icon(Icons.arrow_forward_ios_rounded, color: ColorStyles.upFinButtonBlue, size: 5.5.w) : Container()),
              ])
          ), onTap: (){
            CommonUtils.log("i", "gogo");
          })
      );
      prInfoWidgetList.add(UiUtils.getMarginBox(0, 1.5.h));
    }

    return UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: prInfoWidgetList));
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Container(color: ColorStyles.upFinWhite, width: 100.w, height: 100.h, padding: EdgeInsets.all(5.w), child: Column(children: [
      SizedBox(width: 95.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () async {
          // 한도금리 목록 화면에서 뒤로가기 누르면 pop하여 메인뷰로 이동 *(if initSearchViewFromMainView == true)
          // 한도금리 목록 화면에서 뒤로가기 누르면 이미 사전에 AccidentInfoList 가져왔기에 메인뷰로 replace *(if initSearchViewFromMainView == false)
          if(MyData.initSearchViewFromMainView){
            Navigator.pop(context);
          }else{
            CommonUtils.moveWithReplacementTo(context, AppView.mainView.value, null);
          }
        }),
      ])),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 95.w, child : UiUtils.getTextWithFixedScale("대출상품", 24.sp, FontWeight.w800, ColorStyles.upFinButtonBlue, TextAlign.start, 1)),
      SizedBox(height: 6.h, child: Row(children: [
        UiUtils.getTextWithFixedScale("전체상품 ${MyData.getPrInfoList().length}개", 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.center, 1),
        const Spacer(flex: 2),
        UiUtils.getCustomTextButtonBox(23.w, "금리순", 10.sp, FontWeight.w500, isOrderByLimit? ColorStyles.upFinWhiteSky : ColorStyles.upFinButtonBlue,
            isOrderByLimit? ColorStyles.upFinButtonBlue : ColorStyles.upFinWhiteSky, () {
              _reOrderList();
        }),
        UiUtils.getMarginBox(1.w, 0),
        UiUtils.getCustomTextButtonBox(23.w, "한도순", 10.sp, FontWeight.w500, isOrderByLimit? ColorStyles.upFinButtonBlue : ColorStyles.upFinWhiteSky,
            isOrderByLimit? ColorStyles.upFinWhiteSky : ColorStyles.upFinButtonBlue, () {
              _reOrderList();
        })
      ])),
      UiUtils.getMarginBox(0, 2.h),
      _getPrListView(),
    ]));
    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}