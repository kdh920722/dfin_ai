import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/configs/app_config.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:upfin/styles/TextStyles.dart';
import '../configs/string_config.dart';
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
  bool? item1SubAgreed1 = false;
  bool? item1SubAgreed2 = false;
  bool? item2SubAgreed1 = false;
  bool? item2SubAgreed2 = false;
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

  void _getSmallAgree1Sub1Act(bool checkedValue){
    item1SubAgreed1 = checkedValue;
    if(item1SubAgreed1!){
      if(item1SubAgreed1! == item1SubAgreed2!){
        item1Agreed = true;
        if(item1Agreed == item2Agreed){
          allAgreed = true;
        }else{
          allAgreed = false;
        }
      }
    }else{
      item1Agreed = false;
      if(item1Agreed == item2Agreed){
        allAgreed = false;
      }
    }
  }
  void _getSmallAgree1Sub2Act(bool checkedValue){
    item1SubAgreed2 = checkedValue;
    if(item1SubAgreed2!){
      if(item1SubAgreed2! == item1SubAgreed1!){
        item1Agreed = true;
        if(item1Agreed == item2Agreed){
          allAgreed = true;
        }else{
          allAgreed = false;
        }
      }
    }else{
      item1Agreed = false;
      if(item1Agreed == item2Agreed){
        allAgreed = false;
      }
    }
  }
  void _getSmallAgree2Sub1Act(bool checkedValue){
    item2SubAgreed1 = checkedValue;
    if(item2SubAgreed1!){
      if(item2SubAgreed1! == item2SubAgreed2!){
        item2Agreed = true;
        if(item2Agreed == item1Agreed){
          allAgreed = true;
        }else{
          allAgreed = false;
        }
      }
    }else{
      item2Agreed = false;
      if(item2Agreed == item1Agreed){
        allAgreed = false;
      }
    }
  }
  void _getSmallAgree2Sub2Act(bool checkedValue){
    item2SubAgreed2 = checkedValue;
    if(item2SubAgreed2!){
      if(item2SubAgreed2! == item2SubAgreed1!){
        item2Agreed = true;
        if(item2Agreed == item1Agreed){
          allAgreed = true;
        }else{
          allAgreed = false;
        }
      }
    }else{
      item2Agreed = false;
      if(item2Agreed == item1Agreed){
        allAgreed = false;
      }
    }
  }
  Widget _getSmallAgreeInfoWidget(StateSetter thisSetState, String titleString, String contentsString, bool isAgreeCheck, Function(bool isCheck) callAct){
    return SizedBox(width: 100.w, height: 4.h, child: Row(children: [
      UiUtils.getMarginBox(10.w, 0),
      UiUtils.getBorderButtonBoxWithZeroPadding(80.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite, Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        isAgreeCheck? UiUtils.getCustomCheckBox(UniqueKey(), 1, isAgreeCheck, ColorStyles.upFinTextAndBorderBlue, ColorStyles.upFinWhite,
            ColorStyles.upFinWhite, ColorStyles.upFinWhite, (checkedValue){
              thisSetState(() {
                if(checkedValue != null){
                  callAct(checkedValue);
                }
              });
            }) : UiUtils.getCustomCheckBox(UniqueKey(), 1, true, ColorStyles.upFinGray, ColorStyles.upFinWhite,
            ColorStyles.upFinWhite, ColorStyles.upFinWhite, (checkedValue){
              thisSetState(() {
                if(checkedValue != null){
                  if(!checkedValue) {
                    callAct(true);
                  }
                }
              });
            }),
        UiUtils.getTextButtonWithFixedScale(titleString, 10.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null, () async {
          Widget contentsWidget = Column(children: [
            SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(contentsString, 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null))
          ]);
          bool isAgree = await CommonUtils.moveToWithResult(context, AppView.appAgreeDetailInfoView.value, {"title": titleString, "contents" : contentsWidget}) as bool;
          thisSetState(() {
            callAct(isAgree);
          });
        }),
        UiUtils.getIconButton(Icons.arrow_forward_ios_rounded, 4.w, ColorStyles.upFinRealGray, () async {
          Widget contentsWidget = Column(children: [
            SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale(contentsString, 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null))
          ]);
          bool isAgree = await CommonUtils.moveToWithResult(context, AppView.appAgreeDetailInfoView.value, {"title": titleString, "contents" : contentsWidget}) as bool;
          thisSetState(() {
            callAct(isAgree);
          });
        })
      ]), () async {})
    ]));
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
            UiUtils.getTextWithFixedScale("업핀 서비스 약관동의", 16.sp, FontWeight.w800, ColorStyles.upFinBlack, TextAlign.center, null)
          ]),
          UiUtils.getMarginBox(0, 1.5.h),
          Wrap(children: [
            UiUtils.getTextWithFixedScale("서비스를 이용하기 위해 고객님의 서비스 이용약관에 동의가 필요합니다.", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)
          ]),
          UiUtils.getMarginBox(0, 3.h),
          GestureDetector(child: Container(color: ColorStyles.upFinWhiteGray, child: Row(
            children: [
              UiUtils.getCheckBox(1.4, allAgreed!, (isChanged) {
                thisSetState(() {
                  allAgreed = isChanged;
                  item1Agreed = isChanged;
                  item2Agreed = isChanged;
                  item1SubAgreed1 = isChanged;
                  item1SubAgreed2 = isChanged;
                  item2SubAgreed1 = isChanged;
                  item2SubAgreed2 = isChanged;
                });
              }),
              UiUtils.getTextWithFixedScale("전체동의", 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null)
            ],
          )),onTap: (){
            thisSetState(() {
              if(allAgreed!){
                allAgreed = false;
                item1Agreed = false;
                item1SubAgreed1 = false;
                item1SubAgreed2 = false;
                item2Agreed = false;
                item2SubAgreed1 = false;
                item2SubAgreed2 = false;
              }else{
                allAgreed = true;
                item1Agreed = true;
                item1SubAgreed1 = true;
                item1SubAgreed2 = true;
                item2Agreed = true;
                item2SubAgreed1 = true;
                item2SubAgreed2 = true;
              }
            });
          }),
          UiUtils.getMarginBox(0, 2.h),
          UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
            Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
              Container(padding: EdgeInsets.only(left: 2.w), height: 3.h, child: Row(
                children: [
                  UiUtils.getCheckBox(1, item1Agreed!, (isChanged) {
                    thisSetState(() {
                      item1Agreed = isChanged;
                      item1SubAgreed1 = isChanged;
                      item1SubAgreed2 = isChanged;
                      if(item1Agreed == item2Agreed){
                        allAgreed = isChanged;
                      }else{
                        allAgreed = false;
                      }
                    });
                  }),
                  UiUtils.getTextWithFixedScale("(필수)전체 동의하기", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null)
                ],
              )),
              _getSmallAgreeInfoWidget(thisSetState, "업핀 서비스 이용약관", StringConfig.agreeContents1, item1SubAgreed1!, _getSmallAgree1Sub1Act),
              _getSmallAgreeInfoWidget(thisSetState, "개인(신용)정보 수집 이용 제공 동의서", StringConfig.agreeContents1, item1SubAgreed2!, _getSmallAgree1Sub2Act),
            ]),
            UiUtils.getMarginBox(0, 2.h),
            Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
              Container(padding: EdgeInsets.only(left: 2.w), height: 3.h, child: Row(
                children: [
                  UiUtils.getCheckBox(1, item2Agreed!, (isChanged) {
                    thisSetState(() {
                      item2Agreed = isChanged;
                      item2SubAgreed1 = isChanged;
                      item2SubAgreed2 = isChanged;
                      if(item1Agreed == item2Agreed){
                        allAgreed = isChanged;
                      }else{
                        allAgreed = false;
                      }
                    });
                  }),
                  UiUtils.getTextWithFixedScale("(선택)전체 동의하기", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null)
                ],
              )),
              _getSmallAgreeInfoWidget(thisSetState, "마케팅 정보 수신 동의", StringConfig.agreeContents1, item2SubAgreed1!, _getSmallAgree2Sub1Act),
              _getSmallAgreeInfoWidget(thisSetState, "야간 마케팅 정보 수신 동의", StringConfig.agreeContents1, item2SubAgreed2!, _getSmallAgree2Sub2Act)
            ]),
          ])),
          UiUtils.getMarginBox(0, 3.h),
          item1Agreed!? UiUtils.getTextButtonBox(90.w, "동의하기", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () {
            Navigator.pop(thisContext);
            CommonUtils.moveTo(thisContext, AppView.appApplyPrView.value, null);
          }) : UiUtils.getTextButtonBox(90.w, "동의하기", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinGray, () {})
        ])
    ));
  }

  void back(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Container(color: ColorStyles.upFinButtonBlue, width: 100.w, height: 100.h, padding: EdgeInsets.all(5.w), child: Column(children: [
      SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UiUtils.getBackButton(() {
          Navigator.pop(context);
        }),
      ])),
      UiUtils.getMarginBox(0, 2.h),
      UiUtils.getTitleWithFixedScale("upfin", 75.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null),
      UiUtils.getMarginBox(0, 3.h),
      SizedBox(width: 95.w, child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScaleAndOverFlow(MyData.selectedPrInfoData!.productCompanyName, 20.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.center, null)),
        UiUtils.getMarginBox(0, 1.h),
        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScaleAndOverFlow(MyData.selectedPrInfoData!.productName, 10.sp, FontWeight.w300, ColorStyles.upFinWhite, TextAlign.center, 1))
      ])),
      UiUtils.getExpandedScrollView(Axis.vertical, Container()),
      UiUtils.getMarginBox(0, 1.h),
      UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
          UiUtils.getTextWithFixedScale("다이렉트 접수하기", 12.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.center, null), () {
            UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, true, 100.w, 65.h, 0.5, _makeAgreeWidget);
          })
    ]));
    return UiUtils.getViewWithAllowBackForAndroid(context, view, back);
  }

}