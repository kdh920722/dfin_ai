import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dfin/styles/ColorStyles.dart';
import '../styles/TextStyles.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class DebugForAdminView extends StatefulWidget{
  @override
  DebugForAdminViewState createState() => DebugForAdminViewState();
}

class DebugForAdminViewState extends State<DebugForAdminView> with WidgetsBindingObserver{
  final _encTextController = TextEditingController();
  final _encTextFocus = FocusNode();
  final _tokenTextController = TextEditingController();
  final _tokenTextFocus = FocusNode();
  String decryptedText = "";

  void _unFocusAllNodes(){
    _encTextFocus.unfocus();
    _tokenTextFocus.unfocus();
  }

  void _disposeAllTextControllers(){
    _encTextController.dispose();
    _tokenTextController.dispose();
  }

  @override
  void initState(){
    CommonUtils.log("i", "DebugForAdminViewState 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose(){
    CommonUtils.log("i", "DebugForAdminViewState 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _disposeAllTextControllers();
    _unFocusAllNodes();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('i','DebugForAdminViewState resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('i','DebugForAdminViewState inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('i','DebugForAdminViewState detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('i','DebugForAdminViewState paused');
        break;
      default:
        break;
    }
  }

  bool isVerticalViewInWeb = false;
  @override
  Widget build(BuildContext context) {
    if(100.w >= 100.h){
      isVerticalViewInWeb = false;
    }else{
      isVerticalViewInWeb = true;
    }
    Widget view = Config.isWeb ? Container(
      color: ColorStyles.upFinBlack,
      width: 100.w,
      height: 100.h,
      padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w),
        child: isVerticalViewInWeb ? UiUtils.getRowColumnWithAlignCenter([
          UiUtils.getMarginBox(0, 3.w),
          SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            UiUtils.getTextWithFixedScale("Encrypt", 16.sp, FontWeight.w600, ColorStyles.upFinSky, TextAlign.start, null),
            UiUtils.getMarginBox(0, 1.h)
          ])),
          Row(children: [
            UiUtils.getTextFormField(context, 78.w, TextStyles.upFinSmallTextFormFieldTextStyle, _tokenTextFocus, _tokenTextController, TextInputType.text, false,
                UiUtils.getInputDecoration("token", 12.sp, "", 0.sp), (text) {}, (value){}),
            UiUtils.getMarginBox(2.w,0),
            UiUtils.getBorderButtonBoxWithZeroPadding(10.w, ColorStyles.upFinRed, ColorStyles.upFinRed,
                UiUtils.getTextWithFixedScale("X", 12.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
                  setState(() {
                    _tokenTextController.text = "";
                  });
                })
          ]),
          UiUtils.getMarginBox(0, 1.h),
          Row(children: [
            UiUtils.getTextFormField(context, 78.w, TextStyles.upFinSmallTextFormFieldTextStyle, _encTextFocus, _encTextController, TextInputType.text, false,
                UiUtils.getInputDecoration("enc", 12.sp, "", 0.sp), (text) {}, (value){}),
            UiUtils.getMarginBox(2.w,0),
            UiUtils.getBorderButtonBoxWithZeroPadding(10.w, ColorStyles.upFinRed, ColorStyles.upFinRed,
                UiUtils.getTextWithFixedScale("X", 12.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
                  setState(() {
                    _encTextController.text = "";
                  });
                })
          ]),
          UiUtils.getMarginBox(0, 0.5.h),
          UiUtils.getBorderButtonBoxWithZeroPadding(90.w, ColorStyles.upFinSky, ColorStyles.upFinSky,
              UiUtils.getTextWithFixedScale("변환", 12.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
                String result = CommonUtils.decryptLogData(_tokenTextController.text, _encTextController.text);
                if(result != ""){
                  setState(() {
                    decryptedText = result;
                  });
                }
              }),
          UiUtils.getMarginBox(0, 3.h),
          SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            UiUtils.getTextWithFixedScale("Decrypt", 16.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.start, null),
            UiUtils.getMarginBox(0, 1.h)
          ])),
          UiUtils.getExpandedScrollView(Axis.vertical, Column(children: [
            SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              UiUtils.getTextWithFixedScale(decryptedText, 12.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null)
            ])),
          ])),
          UiUtils.getMarginBox(0, 2.h),
        ]) : Row(children: [
          UiUtils.getRowColumnWithAlignCenter([
            SizedBox(width: 45.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              UiUtils.getTextWithFixedScale("Encrypt", 14.sp, FontWeight.w600, ColorStyles.upFinSky, TextAlign.start, null),
              UiUtils.getMarginBox(0, 1.h)
            ])),
            Row(children: [
              UiUtils.getTextFormField(context, 43.w, TextStyles.upFinSmallTextFormFieldTextStyle, _tokenTextFocus, _tokenTextController, TextInputType.text, false,
                  UiUtils.getInputDecoration("token", 10.sp, "", 0.sp), (text) {}, (value){}),
              UiUtils.getMarginBox(1.w,0),
              UiUtils.getBorderButtonBoxWithZeroPadding(2.w, ColorStyles.upFinRed, ColorStyles.upFinRed,
                  UiUtils.getTextWithFixedScale("X", 10.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
                    setState(() {
                      _tokenTextController.text = "";
                    });
                  })
            ]),
            UiUtils.getMarginBox(0, 1.h),
            Row(children: [
              UiUtils.getTextFormField(context, 43.w, TextStyles.upFinSmallTextFormFieldTextStyle, _encTextFocus, _encTextController, TextInputType.text, false,
                  UiUtils.getInputDecoration("enc", 10.sp, "", 0.sp), (text) {}, (value){}),
              UiUtils.getMarginBox(1.w,0),
              UiUtils.getBorderButtonBoxWithZeroPadding(2.w, ColorStyles.upFinRed, ColorStyles.upFinRed,
                  UiUtils.getTextWithFixedScale("X", 10.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
                    setState(() {
                      _encTextController.text = "";
                    });
                  })
            ]),
            UiUtils.getMarginBox(0, 1.h),
            UiUtils.getBorderButtonBoxWithZeroPadding(46.w, ColorStyles.upFinSky, ColorStyles.upFinSky,
                UiUtils.getTextWithFixedScale("변환", 7.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
                  String result = CommonUtils.decryptLogData(_tokenTextController.text, _encTextController.text);
                  if(result != ""){
                    setState(() {
                      decryptedText = result;
                    });
                  }
                }),
          ]),
          UiUtils.getRowColumnWithAlignCenter([
            SizedBox(width: 40.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              UiUtils.getTextWithFixedScale("Decrypt", 14.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.start, null),
              UiUtils.getMarginBox(0, 1.h)
            ])),
            UiUtils.getExpandedScrollView(Axis.vertical, Column(children: [
              SizedBox(width: 40.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                UiUtils.getTextWithFixedScale(decryptedText, 10.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null)
              ])),
            ])),
            UiUtils.getMarginBox(0, 2.h),
          ])
        ])
    )

        : Container(
        color: ColorStyles.upFinBlack,
        width: 100.w,
        height: 100.h,
        padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w),
        child: UiUtils.getRowColumnWithAlignCenter([
          SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            UiUtils.getBackButton(() async {
              if(Navigator.canPop(context)){
                Navigator.pop(context);
              }
            }),
          ])),
          UiUtils.getMarginBox(0, 3.w),
          SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            UiUtils.getTextWithFixedScale("Encrypt", 16.sp, FontWeight.w600, ColorStyles.upFinSky, TextAlign.start, null),
            UiUtils.getMarginBox(0, 1.h)
          ])),
          Row(children: [
            UiUtils.getTextFormField(context, 78.w, TextStyles.upFinSmallTextFormFieldTextStyle, _tokenTextFocus, _tokenTextController, TextInputType.text, false,
                UiUtils.getInputDecoration("token", 12.sp, "", 0.sp), (text) {}, (value){}),
            UiUtils.getMarginBox(2.w,0),
            UiUtils.getBorderButtonBoxWithZeroPadding(10.w, ColorStyles.upFinRed, ColorStyles.upFinRed,
                UiUtils.getTextWithFixedScale("X", 12.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
                  setState(() {
                    _tokenTextController.text = "";
                  });
                })
          ]),
          UiUtils.getMarginBox(0, 1.h),
          Row(children: [
            UiUtils.getTextFormField(context, 78.w, TextStyles.upFinSmallTextFormFieldTextStyle, _encTextFocus, _encTextController, TextInputType.text, false,
                UiUtils.getInputDecoration("enc", 12.sp, "", 0.sp), (text) {}, (value){}),
            UiUtils.getMarginBox(2.w,0),
            UiUtils.getBorderButtonBoxWithZeroPadding(10.w, ColorStyles.upFinRed, ColorStyles.upFinRed,
                UiUtils.getTextWithFixedScale("X", 12.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
                  setState(() {
                    _encTextController.text = "";
                  });
                })
          ]),
          UiUtils.getMarginBox(0, 0.5.h),
          UiUtils.getBorderButtonBoxWithZeroPadding(90.w, ColorStyles.upFinSky, ColorStyles.upFinSky,
              UiUtils.getTextWithFixedScale("변환", 12.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () {
                String result = CommonUtils.decryptLogData(_tokenTextController.text, _encTextController.text);
                if(result != ""){
                  setState(() {
                    decryptedText = result;
                  });
                }
              }),
          UiUtils.getMarginBox(0, 3.h),
          SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            UiUtils.getTextWithFixedScale("Decrypt", 16.sp, FontWeight.w600, ColorStyles.upFinWhite, TextAlign.start, null),
            UiUtils.getMarginBox(0, 1.h)
          ])),
          UiUtils.getExpandedScrollView(Axis.vertical, Column(children: [
            SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              UiUtils.getTextWithFixedScale(decryptedText, 12.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null)
            ])),
          ])),
          UiUtils.getMarginBox(0, 2.h),
        ])
    );

    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}