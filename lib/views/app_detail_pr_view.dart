import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/configs/app_config.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:upfin/styles/TextStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppDetailPrView extends StatefulWidget{
  @override
  AppDetailPrViewState createState() => AppDetailPrViewState();
}

class AppDetailPrViewState extends State<AppDetailPrView> with WidgetsBindingObserver{
  bool? allAgreed = false;
  bool? item1Agreed = false;
  bool? item2Agreed = false;

  @override
  void initState(){
    CommonUtils.log("i", "AppDetailPrView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppDetailPrView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('i','AppDetailPrView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('i','AppDetailPrView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('i','AppDetailPrView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('i','AppDetailPrView paused');
        break;
      default:
        break;
    }
  }

  bool _isAllChecked(){
    bool isAllAgree = true;
    List<bool?> itemList = [];
    itemList.add(item1Agreed);
    itemList.add(item2Agreed);
    for(var each in itemList){
      if(each != null){
        if(!each){
          isAllAgree = false;
        }
      }else{
        isAllAgree = false;
      }
    }

    return isAllAgree;
  }

  void _setAllChecked(){
    allAgreed = true;
    item1Agreed = true;
    item2Agreed = true;
  }

  Widget _makeAgreeWidget(BuildContext thisContext, StateSetter thisSetState){
    return Material(child: Container(color: ColorStyles.upFinWhite,
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.end,children: [
            UiUtils.getIconButton(Icons.close, 7.w, ColorStyles.upFinDarkGray, () {
              Navigator.pop(thisContext);
            })
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start,children: [
            UiUtils.getTextWithFixedScale("대출상품 신청 약관동의", 16.sp, FontWeight.w800, ColorStyles.upFinBlack, TextAlign.center, null)
          ]),
          UiUtils.getMarginBox(0, 1.5.h),
          Wrap(children: [
            UiUtils.getTextWithFixedScale("서비스를 이용하기 위해 대출상품 신청 이용약관에 동의가 필요합니다.", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)
          ]),
          UiUtils.getMarginBox(0, 3.h),
          Container(color: ColorStyles.upFinWhiteGray, child: Row(
            children: [
              UiUtils.getCircleCheckBox(1.4, allAgreed!, (isChanged) {
                thisSetState(() {
                  _setAllChecked();
                });
              }),
              UiUtils.getTextWithFixedScale("전체동의", 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null)
            ],
          )),
          UiUtils.getMarginBox(0, 2.h),
          UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
            Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
              Container(padding: EdgeInsets.only(left: 5.w), height: 3.h, child: Row(
                children: [
                  UiUtils.getCircleCheckBox(1, item1Agreed!, (isChanged) {
                    thisSetState(() {
                      item1Agreed = isChanged;
                      if(_isAllChecked()){
                        allAgreed = isChanged;
                      }else{
                        allAgreed = false;
                      }
                    });
                  }),
                  UiUtils.getTextWithFixedScale("개인정보 활용 및 필수 서류 제출 동의", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null)
                ],
              )),
              Container(padding: EdgeInsets.only(left: 20.w), height: 3.5.h, child: Row(children: [
                UiUtils.getTextStyledWithIconAndText(TextDirection.rtl, "대출 서비스 이용약관", 10.sp, FontWeight.w500, ColorStyles.upFinDarkWhiteGray, TextAlign.start, null,
                    Icons.arrow_back_ios, 3.5.w, ColorStyles.upFinDarkWhiteGray, (){

                    }),
              ])),
              Container(padding: EdgeInsets.only(left: 20.w), height: 3.5.h, child: Row(children: [
                UiUtils.getTextStyledWithIconAndText(TextDirection.rtl, "개인(신용)정보 수집 이용 제공 동의서", 10.sp, FontWeight.w500, ColorStyles.upFinDarkWhiteGray, TextAlign.start, null,
                    Icons.arrow_back_ios, 3.5.w, ColorStyles.upFinDarkWhiteGray, (){

                    }),
              ]))
            ]),
            UiUtils.getMarginBox(0, 2.h),
            Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
              Container(padding: EdgeInsets.only(left: 5.w), height: 3.h, child: Row(
                children: [
                  UiUtils.getCircleCheckBox(1, item2Agreed!, (isChanged) {
                    thisSetState(() {
                      item2Agreed = isChanged;
                      if(_isAllChecked()){
                        allAgreed = isChanged;
                      }else{
                        allAgreed = false;
                      }
                    });
                  }),
                  UiUtils.getTextWithFixedScale("개인정보 제3자 제공 동의", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null)
                ],
              )),
              Container(padding: EdgeInsets.only(left: 20.w), height: 3.5.h, child: Row(children: [
                UiUtils.getTextStyledWithIconAndText(TextDirection.rtl, "마케팅 정보 수신 동의", 10.sp, FontWeight.w500, ColorStyles.upFinDarkWhiteGray, TextAlign.start, null,
                    Icons.arrow_back_ios, 3.5.w, ColorStyles.upFinDarkWhiteGray, (){

                    }),
              ])),
              Container(padding: EdgeInsets.only(left: 20.w), height: 3.5.h, child: Row(children: [
                UiUtils.getTextStyledWithIconAndText(TextDirection.rtl, "야간 마케팅 정보 수신 동의", 10.sp, FontWeight.w500, ColorStyles.upFinDarkWhiteGray, TextAlign.start, null,
                    Icons.arrow_back_ios, 3.5.w, ColorStyles.upFinDarkWhiteGray, (){

                    }),
              ]))
            ]),
          ])),
          UiUtils.getMarginBox(0, 3.h),
          item1Agreed!? UiUtils.getTextButtonBox(90.w, "동의하기", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () {
            CommonUtils.moveTo(context, AppView.applyPrView.value, null);
          }) : UiUtils.getTextButtonBox(90.w, "동의하기", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinGray, () {})
        ])
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Container(color: ColorStyles.upFinWhite, width: 100.w, height: 100.h, padding: EdgeInsets.all(5.w), child: Column(children: [
      Config.deppLinkInfo == "" ? SizedBox(width: 95.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () {
          Navigator.pop(context);
        }),
      ])) : Container(),
      Config.deppLinkInfo == "" ? UiUtils.getMarginBox(0, 7.h) : UiUtils.getMarginBox(0, 10.h),
      SizedBox(width: 95.w, child: UiUtils.getTextWithFixedScale(MyData.selectedPrInfoData!.productCompanyName, 20.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)),
      UiUtils.getMarginBox(0, 0.5.h),
      UiUtils.getTextWithFixedScale(MyData.selectedPrInfoData!.productName, 16.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null),
      UiUtils.getMarginBox(0, 2.h),
      UiUtils.getExpandedScrollView(Axis.vertical, SizedBox(width: 95.w, child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(width: 95.w, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          UiUtils.getImage(40.w, 20.h, Image.asset(MyData.selectedPrInfoData!.productCompanyLogo))
        ])),
        UiUtils.getMarginBox(0, 3.h),
        SizedBox(width: 95.w, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(children: [
            SizedBox(width: 25.w, child: UiUtils.getTextWithFixedScale("최저금리", 14.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.center, 1)),
            UiUtils.getMarginBox(0, 0.5.h),
            SizedBox(width: 25.w, child: UiUtils.getTextWithFixedScale("${MyData.selectedPrInfoData!.productLoanMinRates}%", 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.center, 1)),
          ]),
          UiUtils.getMarginBox(2.w, 0),
          Column(children: [
            SizedBox(width: 25.w, child: UiUtils.getTextWithFixedScale("최대금리", 14.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.center, 1)),
            UiUtils.getMarginBox(0, 0.5.h),
            SizedBox(width: 25.w, child: UiUtils.getTextWithFixedScale("${MyData.selectedPrInfoData!.productLoanMaxRates}%", 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.center, 1)),
          ]),
          UiUtils.getMarginBox(2.w, 0),
          Column(children: [
            SizedBox(width: 35.w, child: UiUtils.getTextWithFixedScale("최대한도", 14.sp, FontWeight.w500, ColorStyles.upFinTextAndBorderBlue, TextAlign.center, 1)),
            UiUtils.getMarginBox(0, 0.5.h),
            SizedBox(width: 35.w, child: UiUtils.getTextWithFixedScale(CommonUtils.getPriceFormattedString(double.parse(MyData.selectedPrInfoData!.productLoanLimit)), 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.center, 1)),
          ]),
        ])),
      ]))),
      UiUtils.getMarginBox(0, 2.h),
      UiUtils.getTextButtonBox(90.w, "접수하기", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () {
        UiUtils.showSlideMenu(context, SlideType.bottomToTop, true, 100.w, 65.h, 0.5, _makeAgreeWidget);
      })
    ]));
    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}