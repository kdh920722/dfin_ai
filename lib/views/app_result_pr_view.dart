import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/configs/app_config.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/datas/pr_info_data.dart';
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
    MyData.selectedPrInfoData = null;
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
      MyData.sortPrInfoListBy(isOrderByLimit);
    });

  }

  Widget _getPrListView(){
    List<Widget> prInfoWidgetList = [];
    for(var each in MyData.getPrInfoList()){
      String msg = "";
      String eachMsg = "";
      for(int i = 0 ; i < each.failReason.length ; i++){
        if(each.failReason[i].contains("잔여한도")){
          String frontMsg = each.failReason[i].split("잔여한도")[0].replaceAll(",", "");
          String backMsg = "잔여한도:${CommonUtils.getPriceFormattedString(double.parse(each.failReason[i].split(" : ")[1]))}";
          eachMsg = "$frontMsg\n($backMsg)";
        }else{
          eachMsg = each.failReason[i];
        }

        if(i == each.failReason.length-1){
          msg+=eachMsg;
        }else{
          msg+="$eachMsg\n";
        }
      }

      prInfoWidgetList.add(
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinRealWhite, ColorStyles.upFinGray,
              Row(mainAxisSize: MainAxisSize.max, children: [
                Expanded(flex: 15, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(width: 90.w, child: Row(children: [
                    UiUtils.getTextWithFixedScale(each.productCompanyName, 14.sp, FontWeight.w800, ColorStyles.upFinDarkGray, TextAlign.start, 1),
                    const Spacer(flex: 2),
                    each.isPossible? UiUtils.getTextWithFixedScale("신청 가능", 9.sp, FontWeight.w600, ColorStyles.upFinTextAndBorderBlue, TextAlign.end, 1)
                        : UiUtils.getTextWithFixedScale("신청 불가능", 9.sp, FontWeight.w600, ColorStyles.upFinRed, TextAlign.end, 1),
                  ])),
                  UiUtils.getMarginBox(0, 0.5.h),
                  UiUtils.getTextWithFixedScale(each.productName, 10.sp, FontWeight.w500, ColorStyles.upFinRealGray, TextAlign.start, null),
                  UiUtils.getMarginBox(0, 1.5.h),
                  SizedBox(width: 80.w, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(width: 20.w, child: UiUtils.getTextWithFixedScale("최저금리", 10.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, 1)),
                    UiUtils.getMarginBox(5.w, 0),
                    SizedBox(width: 45.w, child: UiUtils.getTextWithFixedScale("최대한도", 10.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, 1))
                  ])),
                  SizedBox(width: 80.w, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(width: 20.w, child: UiUtils.getTextWithFixedScale("${each.productLoanRates}%", 18.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1)),
                    UiUtils.getMarginBox(5.w, 0),
                    SizedBox(width: 45.w, child: UiUtils.getTextWithFixedScale(CommonUtils.getPriceFormattedString(double.parse(each.productLoanLimit)), 18.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1))
                  ])),
                  UiUtils.getMarginBox(0, 1.5.h),
                  each.isPossible? UiUtils.getTextWithFixedScale(msg, 10.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.start, null)
                      : UiUtils.getTextWithFixedScale(msg, 10.sp, FontWeight.w500, ColorStyles.upFinRed, TextAlign.start, null),
                ])),
                Expanded(flex: 1, child: each.isPossible? Icon(Icons.arrow_forward_ios_rounded, color: ColorStyles.upFinButtonBlue, size: 5.5.w) : Container()),
              ]), () {
                UiUtils.showLoadingPop(context);
                LogfinController.getPrDocsList(each.productOfferId, each.productOfferRid, (isSuccessToSearchDocs, _){
                  UiUtils.closeLoadingPop(context);
                  if(isSuccessToSearchDocs){
                    MyData.selectedPrInfoData = each;
                    CommonUtils.moveTo(context, AppView.detailPrView.value, null);
                  }
                });
          })
      );
      prInfoWidgetList.add(UiUtils.getMarginBox(0, 1.2.h));
    }

    return UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: prInfoWidgetList));
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Container(color: ColorStyles.upFinWhite, width: 100.w, height: 100.h, padding: EdgeInsets.all(5.w), child: Column(children: [
      SizedBox(width: 95.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () {
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
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(height: 6.h, child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        UiUtils.getTextWithFixedScale("전체상품 ", 14.sp, FontWeight.w400, ColorStyles.upFinBlack, TextAlign.center, 1),
        UiUtils.getTextWithFixedScale("${MyData.getPrInfoList().length}개", 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.center, 1),
        const Spacer(flex: 2),
        UiUtils.getCustomTextButtonBox(23.w, "금리순", 10.sp, FontWeight.w600, isOrderByLimit? ColorStyles.upFinWhiteSky : ColorStyles.upFinButtonBlue,
            isOrderByLimit? ColorStyles.upFinButtonBlue : ColorStyles.upFinWhiteSky, () {
              _reOrderList();
        }),
        UiUtils.getMarginBox(1.w, 0),
        UiUtils.getCustomTextButtonBox(23.w, "한도순", 10.sp, FontWeight.w600, isOrderByLimit? ColorStyles.upFinButtonBlue : ColorStyles.upFinWhiteSky,
            isOrderByLimit? ColorStyles.upFinWhiteSky : ColorStyles.upFinButtonBlue, () {
              _reOrderList();
        })
      ])),
      UiUtils.getMarginBox(0, 0.5.h),
      _getPrListView(),
    ]));
    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}