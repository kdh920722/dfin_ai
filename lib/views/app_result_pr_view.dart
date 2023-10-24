import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/configs/app_config.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import '../configs/string_config.dart';
import '../styles/TextStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppResultPrView extends StatefulWidget{
  @override
  AppResultPrViewState createState() => AppResultPrViewState();
}

class AppResultPrViewState extends State<AppResultPrView> with WidgetsBindingObserver, TickerProviderStateMixin{
  late final TabController _tabController;
  int possiblePrCnt = 0;
  int impossiblePrCnt = 0;
  bool isOrderByLimit = false;
  bool? allAgreed = false;
  bool? item1Agreed = false;

  bool? item1SubAgreed1 = false;
  bool? item1SubAgreed2 = false;
  bool? item1SubAgreed3 = false;
  bool? item1SubAgreed4 = false;
  bool? item1SubAgreed5 = false;
  bool? item1SubAgreed6 = false;

  int selectedTabIndex = 0 ;
  int selectedTabCount = 0 ;
  int possiblePrCount = 0 ;
  int impossiblePrbCount = 0 ;
  @override
  void initState(){
    CommonUtils.log("i", "AppResultPrView 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setPrCnt();
    MyData.selectedPrInfoData = null;
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setImagePreLoad();
    });

    for(var each in MyData.getPrInfoList()){
      if(each.isPossible){
        possiblePrCount++;
      }else{
        impossiblePrbCount++;
      }
    }
    selectedTabCount = possiblePrCount;
    _tabController.addListener(() {
      selectedTabIndex = _tabController.index;
      setState(() {
        if(selectedTabIndex == 0){
          selectedTabCount = possiblePrCount;
        }else{
          selectedTabCount = impossiblePrbCount;
        }
      });
    });

    Config.contextForEmergencyBack = context;
    Config.isEmergencyRoot = false;
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppResultPrView 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    Config.contextForEmergencyBack = null;
    MyData.selectedAccidentInfoData = null;
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

  void setPrCnt(){
    for(var each in MyData.getPrInfoList()){
      if(each.isPossible){
        possiblePrCnt++;
      }else{
        impossiblePrCnt++;
      }
    }
  }

  void _reOrderList(bool orderByLimit){
    if(orderByLimit != isOrderByLimit){
      if(isOrderByLimit){
        isOrderByLimit = false;
      }else{
        isOrderByLimit = true;
      }
      setState(() {
        MyData.sortPrInfoListBy(isOrderByLimit);
      });
    }
  }

  void _setImagePreLoad(){
    precacheImage(const AssetImage('assets/images/bank_logo_default.png'), context);
    precacheImage(const AssetImage('assets/images/bank_logo_safe.png'), context);
  }

  List<Widget> _getMsgListIWidget(List<String> msgList){
    List<Widget> widgetList = [];
    for(var eachMsg in msgList){
      widgetList.add(UiUtils.getBoxTextAndIconWithFixedScale(eachMsg, 8.sp, FontWeight.w500, TextAlign.start, ColorStyles.upFinWhiteRed, ColorStyles.upFinRed,
          Icons.warning_rounded, ColorStyles.upFinRed, 5.w));

      widgetList.add(UiUtils.getMarginBox(0, 0.5.h));
    }
    return widgetList;
  }

  Widget _getPrListView(bool isPossible){
    List<Widget> prInfoWidgetList = [];
    for(var each in MyData.getPrInfoList()){
      if(each.isPossible == isPossible){
        //CommonUtils.log("i", "${each.productLoanMinRates} ${CommonUtils.getPriceFormattedString(double.parse(each.productLoanLimit))}");
        String msg = "";
        String eachMsg = "";
        List<String> msgList = [];
        for(int i = 0 ; i < each.failReason.length ; i++){
          if(each.failReason[i].contains("잔여한도")){
            String frontMsg = each.failReason[i].split("잔여한도")[0].replaceAll(",", "");
            String backMsg = "잔여한도:${CommonUtils.getPriceFormattedString(double.parse(each.failReason[i].split(" : ")[1]))}";
            eachMsg = "$frontMsg\n($backMsg)";
          }else{
            eachMsg = each.failReason[i];
          }

          msgList.add(eachMsg);

          if(i == each.failReason.length-1){
            msg+=eachMsg;
          }else{
            msg+="$eachMsg\n";
          }
        }

        prInfoWidgetList.add(
            UiUtils.getBorderButtonBox(90.w, each.isPossible? ColorStyles.upFinRealWhite : ColorStyles.upFinRealWhite, each.isPossible? ColorStyles.upFinGray : ColorStyles.upFinGray,
                Row(mainAxisSize: MainAxisSize.max, children: [
                  Expanded(flex: 15, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(width: 90.w, child: Row(children: [
                      UiUtils.getImage(6.w, 6.w, Image.asset(each.productCompanyLogo)),
                      UiUtils.getMarginBox(1.5.w, 0),
                      UiUtils.getTextWithFixedScale(each.productCompanyName, 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null),
                    ])),
                    UiUtils.getMarginBox(0, 1.h),
                    UiUtils.getTextWithFixedScaleAndOverFlow(each.productName, 10.sp, FontWeight.w300, ColorStyles.upFinBlack, TextAlign.start, null),
                    UiUtils.getMarginBox(0, 2.h),
                    SizedBox(width: 80.w, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      SizedBox(width: 20.w,height: 2.5.h , child: UiUtils.getTextWithFixedScale("금리", 10.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, 1)),
                      UiUtils.getMarginBox(5.w, 0),
                      SizedBox(width: 45.w,height: 2.5.h , child: UiUtils.getTextWithFixedScale("한도", 10.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, 1))
                    ])),
                    SizedBox(width: 80.w, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      SizedBox(width: 20.w, child: UiUtils.getTextWithFixedScale("${each.productLoanMinRates}%", 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1)),
                      UiUtils.getMarginBox(5.w, 0),
                      SizedBox(width: 45.w, child: UiUtils.getTextWithFixedScale(CommonUtils.getPriceFormattedString(double.parse(each.productLoanLimit)), 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, 1))
                    ])),
                    // UiUtils.getMarginBox(0, 2.h),

                    each.isPossible? Container()
                        : UiUtils.getMarginBox(0, 1.h),
                    each.isPossible? Container()
                        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: _getMsgListIWidget(msgList)),
                  ])),
                  Expanded(flex: 1, child: each.isPossible? Icon(Icons.arrow_forward_ios_rounded, color: ColorStyles.upFinDarkGray , size: 4.5.w) : Container()),
                ]), () {
                  if(each.isPossible) {
                    CommonUtils.log("i","${each.productOfferLenderPrId} ${each.productOfferRid} ${each.productOfferId}");
                    bool isDuplicate = false;
                    for(var eachLoan in MyData.getLoanInfoList()){
                      if(eachLoan.lenderPrId == each.productOfferLenderPrId){
                        isDuplicate = true;
                      }
                    }
                    if(isDuplicate){
                      CommonUtils.flutterToast("이미 신청하신 상품입니다.");
                      MyData.selectedPrInfoData = each;
                      UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, true, 100.w, 65.h, 0.5, _makeAgreeWidget);
                    }else{
                      MyData.selectedPrInfoData = each;
                      UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, true, 100.w, 65.h, 0.5, _makeAgreeWidget);
                    }
                  }else{
                    CommonUtils.flutterToast("신청 불가능한 상풉입니다.");
                  }
                })
        );
        prInfoWidgetList.add(UiUtils.getMarginBox(0, 1.2.h));
      }
    }

    return UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment: CrossAxisAlignment.start, children: prInfoWidgetList));
  }

  void _getSmallAgree1Sub1Act(bool checkedValue){
    item1SubAgreed1 = checkedValue;
    if(item1SubAgreed1!){
      if(item1SubAgreed1! == item1SubAgreed2! && item1SubAgreed2! == item1SubAgreed3!
          && item1SubAgreed3! == item1SubAgreed4! && item1SubAgreed4! == item1SubAgreed5! && item1SubAgreed5! == item1SubAgreed6!){
        item1Agreed = true;
        allAgreed = true;
      }
    }else{
      item1Agreed = false;
      allAgreed = false;
    }
  }
  void _getSmallAgree1Sub2Act(bool checkedValue){
    item1SubAgreed2 = checkedValue;
    if(item1SubAgreed2!){
      if(item1SubAgreed1! == item1SubAgreed2! && item1SubAgreed2! == item1SubAgreed3!
          && item1SubAgreed3! == item1SubAgreed4! && item1SubAgreed4! == item1SubAgreed5! && item1SubAgreed5! == item1SubAgreed6!){
        item1Agreed = true;
        allAgreed = true;
      }
    }else{
      item1Agreed = false;
      allAgreed = false;
    }
  }
  void _getSmallAgree1Sub3Act(bool checkedValue){
    item1SubAgreed3 = checkedValue;
    if(item1SubAgreed3!){
      if(item1SubAgreed1! == item1SubAgreed2! && item1SubAgreed2! == item1SubAgreed3!
          && item1SubAgreed3! == item1SubAgreed4! && item1SubAgreed4! == item1SubAgreed5! && item1SubAgreed5! == item1SubAgreed6!){
        item1Agreed = true;
        allAgreed = true;
      }
    }else{
      item1Agreed = false;
      allAgreed = false;
    }
  }
  void _getSmallAgree1Sub4Act(bool checkedValue){
    item1SubAgreed4 = checkedValue;
    if(item1SubAgreed4!){
      if(item1SubAgreed1! == item1SubAgreed2! && item1SubAgreed2! == item1SubAgreed3!
          && item1SubAgreed3! == item1SubAgreed4! && item1SubAgreed4! == item1SubAgreed5! && item1SubAgreed5! == item1SubAgreed6!){
        item1Agreed = true;
        allAgreed = true;
      }
    }else{
      item1Agreed = false;
      allAgreed = false;
    }
  }
  void _getSmallAgree1Sub5Act(bool checkedValue){
    item1SubAgreed5 = checkedValue;
    if(item1SubAgreed5!){
      if(item1SubAgreed1! == item1SubAgreed2! && item1SubAgreed2! == item1SubAgreed3!
          && item1SubAgreed3! == item1SubAgreed4! && item1SubAgreed4! == item1SubAgreed5! && item1SubAgreed5! == item1SubAgreed6!){
        item1Agreed = true;
        allAgreed = true;
      }
    }else{
      item1Agreed = false;
      allAgreed = false;
    }
  }
  void _getSmallAgree1Sub6Act(bool checkedValue){
    item1SubAgreed6 = checkedValue;
    if(item1SubAgreed6!){
      if(item1SubAgreed1! == item1SubAgreed2! && item1SubAgreed2! == item1SubAgreed3!
          && item1SubAgreed3! == item1SubAgreed4! && item1SubAgreed4! == item1SubAgreed5! && item1SubAgreed5! == item1SubAgreed6!){
        item1Agreed = true;
        allAgreed = true;
      }
    }else{
      item1Agreed = false;
      allAgreed = false;
    }
  }
  Widget _getSmallAgreeInfoWidget(StateSetter thisSetState, String titleString, String contentsString, bool isAgreeCheck, Function(bool isCheck) callAct){
    return SizedBox(width: 100.w, height: 4.h, child: Row(children: [
      UiUtils.getBorderButtonBoxWithZeroPadding(87.5.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite, Row(mainAxisAlignment: MainAxisAlignment.start, children: [
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
        UiUtils.getTextButtonWithFixedScale(titleString, 10.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null, () {
          _smallAgreePressEvent(titleString, contentsString, (agreeResult){
            thisSetState(() {
              callAct(agreeResult);
            });
          });
        }),
        const Spacer(flex: 2),
        UiUtils.getIconButton(Icons.arrow_forward_ios_rounded, 4.w, ColorStyles.upFinRealGray, () {
          _smallAgreePressEvent(titleString, contentsString, (agreeResult){
            thisSetState(() {
              callAct(agreeResult);
            });
          });
        })
      ]), () {
        _smallAgreePressEvent(titleString, contentsString, (agreeResult){
          thisSetState(() {
            callAct(agreeResult);
          });
        });
      })
    ]));
  }
  Future<void> _smallAgreePressEvent(String titleString, String contentsString, Function(bool agreeResult) callback) async {
    Widget htmlWidget = Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      HtmlWidget(
        contentsString,
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
          UiUtils.showLoadingPop(context);
          Map<String, String> urlInfoMap = {
            "url" : url
          };
          bool isSuccess = false;
          var result = await CommonUtils.moveToWithResult(context, AppView.appWebView.value, urlInfoMap);
          if(context.mounted) UiUtils.closeLoadingPop(context);
          return true;
        },
        renderMode: RenderMode.column,
        textStyle: TextStyles.upFinHtmlTextStyle,
      )
    ]);

    bool isAgree = await CommonUtils.moveToWithResult(context, AppView.appAgreeDetailInfoView.value, {"title": titleString, "contents" : htmlWidget}) as bool;
    callback(isAgree);
  }
  Widget _makeAgreeWidget(BuildContext thisContext, StateSetter thisSetState, ){
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
            UiUtils.getTextWithFixedScaleForAgreeSubTitle("서비스를 이용하기 위해 고객님의 서비스 이용약관에 동의가 필요합니다.", 12.sp, FontWeight.w500, ColorStyles.upFinDarkGray, TextAlign.start, null)
          ]),
          UiUtils.getMarginBox(0, 3.h),
          GestureDetector(child: Container(color: ColorStyles.upFinWhiteGray, child: Row(
            children: [
              UiUtils.getCheckBox(1.2, allAgreed!, (isChanged) {
                thisSetState(() {
                  allAgreed = isChanged;
                  item1Agreed = isChanged;
                  item1SubAgreed1 = isChanged;
                  item1SubAgreed2 = isChanged;
                  item1SubAgreed3 = isChanged;
                  item1SubAgreed4 = isChanged;
                  item1SubAgreed5 = isChanged;
                  item1SubAgreed6 = isChanged;
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
                item1SubAgreed3 = false;
                item1SubAgreed4 = false;
                item1SubAgreed5 = false;
                item1SubAgreed6 = false;
              }else{
                allAgreed = true;
                item1Agreed = true;
                item1SubAgreed1 = true;
                item1SubAgreed2 = true;
                item1SubAgreed3 = true;
                item1SubAgreed4 = true;
                item1SubAgreed5 = true;
                item1SubAgreed6 = true;
              }
            });
          }),
          UiUtils.getMarginBox(0, 2.h),
          UiUtils.getExpandedScrollView(Axis.vertical, Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
            Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
              Container(padding: EdgeInsets.zero, height: 3.h, child: Row(
                children: [
                  UiUtils.getCheckBox(1.2, item1Agreed!, (isChanged) {
                    thisSetState(() {
                      item1Agreed = isChanged;
                      item1SubAgreed1 = isChanged;
                      item1SubAgreed2 = isChanged;
                      item1SubAgreed3 = isChanged;
                      item1SubAgreed4 = isChanged;
                      item1SubAgreed5 = isChanged;
                      item1SubAgreed6 = isChanged;
                      if(item1Agreed!){
                        allAgreed = true;
                      }else{
                        allAgreed = false;
                      }
                    });
                  }),
                  UiUtils.getTextWithFixedScale("(필수)전체 동의하기", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null)
                ],
              )),
              UiUtils.getMarginBox(0, 1.5.h),
              _getSmallAgreeInfoWidget(thisSetState, LogfinController.getAgreeTitle("B1"), LogfinController.getAgreeContents("B1"), item1SubAgreed1!, _getSmallAgree1Sub1Act),
              _getSmallAgreeInfoWidget(thisSetState, LogfinController.getAgreeTitle("B2"), LogfinController.getAgreeContents("B2"), item1SubAgreed2!, _getSmallAgree1Sub2Act),
              _getSmallAgreeInfoWidget(thisSetState, LogfinController.getAgreeTitle("B3"), LogfinController.getAgreeContents("B3"), item1SubAgreed3!, _getSmallAgree1Sub3Act),
              _getSmallAgreeInfoWidget(thisSetState, LogfinController.getAgreeTitle("B4"), LogfinController.getAgreeContents("B4"), item1SubAgreed4!, _getSmallAgree1Sub4Act),
              _getSmallAgreeInfoWidget(thisSetState, LogfinController.getAgreeTitle("B5"), LogfinController.getAgreeContents("B5"), item1SubAgreed5!, _getSmallAgree1Sub5Act),
              _getSmallAgreeInfoWidget(thisSetState, LogfinController.getAgreeTitle("B6"), LogfinController.getAgreeContents("B6"), item1SubAgreed6!, _getSmallAgree1Sub6Act),
            ]),
          ])),
          UiUtils.getMarginBox(0, 1.5.h),
          item1Agreed!? UiUtils.getTextButtonBox(90.w, "동의하기", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, () {
            UiUtils.showLoadingPop(context);
            LogfinController.getPrDocsList(MyData.selectedPrInfoData!.productOfferId, MyData.selectedPrInfoData!.productOfferRid, (isSuccessToSearchDocs, _){
              UiUtils.closeLoadingPop(context);
              if(isSuccessToSearchDocs){
                Navigator.pop(thisContext);
                CommonUtils.moveTo(thisContext, AppView.appApplyPrView.value, null);
              }else{
                CommonUtils.flutterToast("상품정보를 불러오는데\n실패했습니다.");
                MyData.selectedPrInfoData = null;
              }
            });

          }) : UiUtils.getTextButtonBox(90.w, "동의하기", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinGray, () {})
        ])
    ));
  }

  void back(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(!CommonUtils.isValidStateByAPiExpiredDate()){
        CommonUtils.flutterToast("접속시간이 만료되었습니다.\n재로그인 해주세요");
        CommonUtils.backToHome(context);
      }
    });

    Widget view = Container(color: ColorStyles.upFinWhite, width: 100.w, height: 100.h, padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w), child: Column(children: [
      Row(children: [
        const Spacer(flex: 2),
        UiUtils.getIconButtonWithHeight(3.h, Icons.close, 25.sp, ColorStyles.upFinDarkGray, () {
          MyData.selectedAccidentInfoData = null;
          MyData.selectedPrInfoData = null;
          Navigator.pop(context);
        })
      ]),
      UiUtils.getMarginBox(0, 3.w),
      SizedBox(width: 95.w, height: 5.h , child : UiUtils.getTextWithFixedScale("대출상품", 24.sp, FontWeight.w800, ColorStyles.upFinButtonBlue, TextAlign.start, 1)),
      UiUtils.getMarginBox(0, 1.h),
      SizedBox(width: 95.w, height: 5.h, child: TabBar(
        unselectedLabelStyle: TextStyles.upFinUnselectedTabTextInButtonStyle,
        unselectedLabelColor: ColorStyles.upFinRealGray,
        labelStyle: TextStyles.upFinSelectedTabTextInButtonStyle,
        labelColor: ColorStyles.upFinBlack,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: MyPrTabIndicator(),
        indicatorColor: ColorStyles.upFinButtonBlue,
        dividerColor: ColorStyles.upFinWhiteSky,
        controller: _tabController,
        tabs: const <Widget>[
          Tab(text: "신청 가능"),
          Tab(text: "신청 불가능"),
        ],
      )),
      UiUtils.getMarginBox(0, 2.h),
      SizedBox(height: 6.h, child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        UiUtils.getTextWithFixedScale("상품 ", 14.sp, FontWeight.w400, ColorStyles.upFinBlack, TextAlign.center, 1),
        UiUtils.getTextWithFixedScale("$selectedTabCount개", 16.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.center, 1),
        const Spacer(flex: 2),
        UiUtils.getCustomTextButtonBox(20.w, "금리순", 9.sp, FontWeight.w600, isOrderByLimit? ColorStyles.upFinWhiteSky : ColorStyles.upFinButtonBlue,
            isOrderByLimit? ColorStyles.upFinButtonBlue : ColorStyles.upFinWhiteSky, () {
              _reOrderList(false);
            }),
        UiUtils.getMarginBox(1.5.w, 0),
        UiUtils.getCustomTextButtonBox(20.w, "한도순", 9.sp, FontWeight.w600, isOrderByLimit? ColorStyles.upFinButtonBlue : ColorStyles.upFinWhiteSky,
            isOrderByLimit? ColorStyles.upFinWhiteSky : ColorStyles.upFinButtonBlue, () {
              _reOrderList(true);
            })
      ])),
      SizedBox(width: 95.w, height: 65.h, child: TabBarView(
        controller: _tabController,
        children: <Widget>[
          possiblePrCnt>0 ? Column(children: [
            UiUtils.getMarginBox(0, 3.h),
            _getPrListView(true)
          ]) : Center(
            child: UiUtils.getTextWithFixedScale("접수 가능한 상품이 없습니다.", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null),
          ),
          impossiblePrCnt>0 ? Column(children: [
            UiUtils.getMarginBox(0, 3.h),
            _getPrListView(false)
          ]) : Center(
            child: UiUtils.getTextWithFixedScale("접수 불가능한 상품이 없습니다.", 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null),
          )
        ],
      ))
    ]));
    return UiUtils.getViewWithAllowBackForAndroid(context, view, back);
  }

}

class MyPrTabIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _MyPrTabIndicatorPainter(this, onChanged);
  }
}



class _MyPrTabIndicatorPainter extends BoxPainter {
  final MyPrTabIndicator decoration;

  _MyPrTabIndicatorPainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

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