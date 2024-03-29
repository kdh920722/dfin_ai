import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:dfin/controllers/firebase_controller.dart';
import 'package:dfin/controllers/logfin_controller.dart';
import 'package:dfin/styles/TextStyles.dart';
import '../controllers/get_controller.dart';
import '../styles/ColorStyles.dart';
import '../configs/app_config.dart';
import 'common_utils.dart';

class UiUtils {
  static Widget startAppView(){
    return Sizer(
      builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(useMaterial3: true),
          initialRoute: AppView.appRootView.value,
          routes: Config.appRoutes,
          navigatorObservers: [FireBaseController.faGaObserver!],
        );
      },
    );
  }

  static Widget getView(BuildContext context, Widget view, Future<bool> Function() callbackBackButtonForView){
    return GestureDetector(
        onTap: () {
          CommonUtils.hideKeyBoard();
        },
        child: SafeArea(
            child: WillPopScope(
                onWillPop: () => callbackBackButtonForView(),
                child: Scaffold(
                  backgroundColor: ColorStyles.dFinWhite,
                  body: view,
                )
            )
        )
    );
  }

  static Widget getViewWithAllowBackForAndroid(BuildContext context, Widget view, Function() callbackBackButtonForView){
    return GestureDetector(
        onTap: () {
          CommonUtils.hideKeyBoard();
        },
        child: SafeArea(
            child: WillPopScope(
                onWillPop: (){
                  return Future((){
                    if(Config.isAndroid) callbackBackButtonForView();
                    return false;
                  });
                },
                child: Scaffold(
                  backgroundColor: ColorStyles.dFinWhite,
                  body: view,
                )
            )
        )
    );
  }

  static Widget getScrollView(BuildContext context, Widget view, ScrollController scrollController, Future<bool> Function() callbackBackButtonForView){
    return GestureDetector(
      onTap: () {
        CommonUtils.hideKeyBoard();
        scrollController.jumpTo(0);
      },
      child: SafeArea(
          child: WillPopScope(
              onWillPop: () => callbackBackButtonForView(),
              child: Scaffold(
                  backgroundColor: ColorStyles.dFinWhite,
                  body: ListView(
                      controller: scrollController,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: [view]
                  )
              )
          )
      )
    );
  }

  static Widget getScrollViewWithAllowBackForAndroid(BuildContext context, Widget view, ScrollController scrollController, Function() callbackBackButtonForView){
    return GestureDetector(
        onTap: () {
          CommonUtils.hideKeyBoard();
          scrollController.jumpTo(0);
        },
        child: SafeArea(
            child: WillPopScope(
                onWillPop: (){
                  return Future((){
                    if(Config.isAndroid) callbackBackButtonForView();
                    return false;
                  });
                },
                child: Scaffold(
                    backgroundColor: ColorStyles.dFinWhite,
                    body: ListView(
                        controller: scrollController,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        children: [view]
                    )
                )
            )
        )
    );
  }

  static bool isTextOverflow(String text, TextStyle style, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1, // 최대 한 줄 텍스트로 제한
    )..layout(maxWidth: maxWidth);

    return textPainter.didExceedMaxLines;
  }

  static Text getStyledTextWithFixedScale(String text, TextStyle textStyle, TextAlign? textAlign, int? textMaxLine){
    return Text(text, style: textStyle, textScaleFactor: 1.0, textAlign: textAlign, maxLines: textMaxLine);
  }

  static Text getTitleWithFixedScale(String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign? textAlign, int? textMaxLine){
    return Text(text, style: TextStyle(decoration: TextDecoration.none, height: 1.1, fontFamily: "Pacifico", fontWeight: fontWeight, fontSize: fontSize, color: textColor), textScaleFactor: 1.0, textAlign: textAlign, maxLines: textMaxLine);
  }

  static Text getTextWithFixedScale(String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign? textAlign, int? textMaxLine){
    return Text(text, style: TextStyle(decoration: TextDecoration.none, height: 1.1, fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor), textScaleFactor: 1.0, textAlign: textAlign, maxLines: textMaxLine);
  }

  static Text getTextWithFixedScale2(String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign? textAlign, int? textMaxLine){
    return Text(text, style: TextStyle(decoration: TextDecoration.none, height: 1.4, fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor), textScaleFactor: 1.0, textAlign: textAlign, maxLines: textMaxLine);
  }

  static Text getTextWithFixedScaleForAgreeSubTitle(String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign? textAlign, int? textMaxLine){
    return Text(text, style: TextStyle(decoration: TextDecoration.none, height: 1.4, fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor), textScaleFactor: 1.0, textAlign: textAlign, maxLines: textMaxLine);
  }

  static Text getTextWithFixedScaleForAddress(String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign? textAlign, int? textMaxLine){
    return Text(text, style: TextStyle(decoration: TextDecoration.none, height: 1.4, fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor), textScaleFactor: 1.0, textAlign: textAlign, maxLines: textMaxLine);
  }

  static Text getTextWithFixedScaleAndOverFlow(String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign? textAlign, int? textMaxLine){
    return Text(overflow: TextOverflow.ellipsis, text, style: TextStyle(decoration: TextDecoration.none, height: 1.1, fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor), textScaleFactor: 1.0, textAlign: textAlign, maxLines: textMaxLine);
  }

  static Widget getTextButtonWithFixedScale(String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign? textAlign, int? textMaxLine, Function() onPressedCallback){
    return GestureDetector(onTap: onPressedCallback, child : UiUtils.getTextWithFixedScale(text, fontSize, fontWeight, textColor, textAlign, null));
  }

  static Widget getTextOverFlowButtonWithFixedScale(double width, String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign? textAlign, int? textMaxLine, Function() onPressedCallback){
    return GestureDetector(onTap: onPressedCallback, child : SizedBox(width: width, child: UiUtils.getTextWithFixedScaleAndOverFlow(text, fontSize, fontWeight, textColor, textAlign, null)));
  }

  static Widget getTextButtonWithFixedScale2(String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign? textAlign, int? textMaxLine, Function() onPressedCallback){
    return GestureDetector(onTap: onPressedCallback, child : UiUtils.getTextWithFixedScale2(text, fontSize, fontWeight, textColor, textAlign, null));
  }

  static Widget getTextButtonWithFixedScaleForAddress(String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign? textAlign, int? textMaxLine, Function() onPressedCallback){
    return GestureDetector(onTap: onPressedCallback, child : UiUtils.getTextWithFixedScaleForAddress(text, fontSize, fontWeight, textColor, textAlign, null));
  }

  static Widget getTextStyledWithIconAndText(TextDirection textDirection, String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign? textAlign, int? textMaxLine,
      IconData icon, double iconSize, Color iconColor, Function() onPressedCallback){
    return Directionality(textDirection: textDirection, child: TextButton.icon(onPressed: onPressedCallback, icon: Icon(icon, color: iconColor, size: iconSize),
        label: getTextWithFixedScale(text, fontSize, fontWeight, textColor, textAlign, textMaxLine)));
  }

  static Widget getBorderTextWithFixedScale(String text, double fontSize, FontWeight fontWeight, TextAlign? textAlign, Color borderColor, Color textColor){
    return Container(padding: EdgeInsets.all(0.1.w), // 텍스트 주위에 여백 추가
      decoration: BoxDecoration(border: Border.all(color: borderColor, width: 2.0), borderRadius: BorderRadius.circular(2.0)),
      child: Text(textScaleFactor: 1.0, text, style: TextStyle(decoration: TextDecoration.none, height: 1, fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor)));
  }

  static Widget getRoundedBoxTextWithFixedScale(String text, double fontSize, FontWeight fontWeight, TextAlign? textAlign, Color borderColor, Color fillColor, Color textColor){
    return Container(padding: EdgeInsets.only(top: 2.w, bottom: 2.w, left: 3.w, right: 3.w), // 텍스트 주위에 여백 추가
        decoration: BoxDecoration(color: fillColor, border: Border.all(color: borderColor, width: 0.3.w), borderRadius: BorderRadius.circular(20)),
        child: Text(textScaleFactor: 1.0, text, style: TextStyle(decoration: TextDecoration.none, height: 1, fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor)));
  }

  static Widget getBoxTextWithFixedScale(String text, double fontSize, FontWeight fontWeight, TextAlign? textAlign, Color boxColor, Color textColor){
    return Container(color: boxColor, child: FittedBox(fit: BoxFit.contain, alignment: Alignment.center,
    child: Padding(padding: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 1.w, top: 1.w), child: Text(textScaleFactor: 1.0, text, style: TextStyle(fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor)))));
  }

  static Widget getBoxTextAndIconWithFixedScale(String text, double fontSize, FontWeight fontWeight, TextAlign? textAlign, Color boxColor, Color textColor, IconData icon, Color iconColor, double iconSize){
    return Container(color: boxColor, child: FittedBox(fit: BoxFit.contain, alignment: Alignment.center,
        child: Padding(padding: EdgeInsets.only(left: 2.w, right: 2.5.w, bottom: 2.w, top: 2.w), child: Row(children: [
          getIcon(iconSize, iconSize, icon, iconSize, iconColor),
          getMarginBox(1.w, 0),
          Text(textScaleFactor: 1.0, text, style: TextStyle(fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor))
        ])
        )));
  }

  static Widget getBoxTextAndIconWithFixedScale2(String text, double fontSize, FontWeight fontWeight, TextAlign? textAlign, Color boxColor, Color textColor, IconData icon, Color iconColor, double iconSize){
    return Container(color: boxColor, child: FittedBox(fit: BoxFit.contain, alignment: Alignment.center,
        child: Padding(padding: EdgeInsets.zero, child: Row(children: [
          getIcon(iconSize, iconSize, icon, iconSize, iconColor),
          getMarginBox(0.5.w, 0),
          Text(textScaleFactor: 1.0, text, style: TextStyle(fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor))
        ])
        )));
  }

  static Widget getRoundBoxTextWithFixedScale(String text, double fontSize, FontWeight fontWeight, TextAlign? textAlign, Color boxColor, Color textColor){
    return Container(
        decoration: BoxDecoration(
          color: boxColor, // 배경색 설정
          borderRadius: BorderRadius.circular(20.0), // 모서리를 둥글게 하는 부분
    ),child: FittedBox(fit: BoxFit.contain, alignment: Alignment.center,
        child: Padding(padding: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 1.w, top: 1.w), child: Text(textScaleFactor: 1.0, text, style: TextStyle(fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor)))));
  }

  static Widget getRoundBoxTextWithFixedScale3(Widget child, Color boxColor){
    return Container(
        decoration: BoxDecoration(
          color: boxColor, // 배경색 설정
          borderRadius: BorderRadius.circular(20.0), // 모서리를 둥글게 하는 부분
        ),child: FittedBox(fit: BoxFit.contain, alignment: Alignment.center,
        child: Padding(padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 2.w, top: 2.w), child: child)));
  }

  static Widget getRoundBoxTextWithFixedScale6(Widget child, Color boxColor){
    return Container(
        decoration: BoxDecoration(
          color: boxColor, // 배경색 설정
          borderRadius: BorderRadius.circular(20.0), // 모서리를 둥글게 하는 부분
        ),child: FittedBox(fit: BoxFit.contain, alignment: Alignment.center,
        child: Padding(padding: EdgeInsets.only(left: 2.5.w, right: 2.5.w, bottom: 2.w, top: 2.w), child: child)));
  }

  static Widget getRoundBoxButtonTextWithFixedScale5(Widget child, Color boxColor, Function() tabCallBack){
    return GestureDetector(onTap: tabCallBack, child: Container(
        decoration: BoxDecoration(
          color: boxColor, // 배경색 설정
          borderRadius: BorderRadius.circular(1), // 모서리를 둥글게 하는 부분
        ),child: FittedBox(fit: BoxFit.contain, alignment: Alignment.center,
        child: Padding(padding: EdgeInsets.only(left: 0, right: 2.5.w, bottom: 1.7.w, top: 1.7.w), child: child))));
  }

  static Widget getRoundBoxButtonTextWithFixedScale6(Widget child, Color boxColor, Function() tabCallBack){
    return GestureDetector(onTap: tabCallBack, child: Container(
        decoration: BoxDecoration(
          color: boxColor, // 배경색 설정
          borderRadius: BorderRadius.circular(1), // 모서리를 둥글게 하는 부분
        ),child: FittedBox(fit: BoxFit.contain, alignment: Alignment.center,
        child: Padding(padding: EdgeInsets.only(left: 2.5.w, right: 2.5.w, bottom: 2.w, top: 2.w), child: child))));
  }

  static Widget getRoundBoxTextWithFixedScale2(String text, double fontSize, FontWeight fontWeight, TextAlign? textAlign, Color boxColor, Color textColor){
    return Container(
        decoration: BoxDecoration(
          color: boxColor, // 배경색 설정
          borderRadius: BorderRadius.circular(20.0), // 모서리를 둥글게 하는 부분
        ),child: FittedBox(fit: BoxFit.contain, alignment: Alignment.center,
        child: Padding(padding: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 2.w, top: 2.w), child: Text(textScaleFactor: 1.0, text, style: TextStyle(fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor)))));
  }

  static Widget getRoundBoxTextWithFixedScale4(String text, double fontSize, FontWeight fontWeight, TextAlign? textAlign, Color boxColor, Color textColor){
    return Container(
        decoration: BoxDecoration(
          color: boxColor, // 배경색 설정
          borderRadius: BorderRadius.circular(20.0), // 모서리를 둥글게 하는 부분
        ),child: FittedBox(fit: BoxFit.contain, alignment: Alignment.center,
        child: Padding(padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 2.w, top: 2.w), child: Text(textScaleFactor: 1.0, text, style: TextStyle(fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor)))));
  }


  static SelectableText getSelectableTextWithFixedScale(String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign? textAlign, int? textMaxLine){
    return SelectableText(textScaleFactor: 1.0, text, style: TextStyle(decoration: TextDecoration.none, height: 1, fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor), textAlign: textAlign, maxLines: textMaxLine);
  }

  static SelectableText getSelectableTextWithFixedScale2(String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign? textAlign, int? textMaxLine){
    return SelectableText(textScaleFactor: 1.0, text, style: TextStyle(decoration: TextDecoration.none, height: 1.3, fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor), textAlign: textAlign, maxLines: textMaxLine);
  }

  static SelectableText getSelectableStyledTextWithFixedScale(String text, TextStyle textStyle, TextAlign? textAlign, int? textMaxLine){
    return SelectableText(textScaleFactor: 1.0, text, style: textStyle, textAlign: textAlign, maxLines: textMaxLine);
  }

  static Widget getTextWithUnderline(String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign textAlign, int? textMaxLine, Color underlineColor){
    return Column(mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[Container(padding: EdgeInsets.only(bottom: 0.1.w),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: underlineColor, width: 0.2.w))),
            child: getTextWithFixedScale(text, fontSize, fontWeight, textColor, textAlign, textMaxLine)
        )]);
  }

  static SizedBox getMarginBox(double marginWidth, double marginHeight){
    return SizedBox(width: marginWidth, height: marginHeight);
  }

  static SizedBox getMarginColoredBox(double marginWidth, double marginHeight, Color backColor){
    return SizedBox(width: marginWidth, height: marginHeight, child: Container(color: backColor));
  }

  static Widget getIconButton(IconData icon, double size, Color iconColor, VoidCallback onPressedCallback) {
    return SizedBox(width: size, height: size, child: IconButton(padding: EdgeInsets.zero, onPressed: onPressedCallback, icon: Icon(icon, color: iconColor, size: size)));
  }

  static Widget getImageButton(Image image, double size, Color iconColor, VoidCallback onPressedCallback) {
    return Container(color : iconColor, width: size, height: size, child: IconButton(padding: const EdgeInsets.all(4.5), onPressed: onPressedCallback, icon: image, iconSize: size));
  }

  static Widget getCircleImageButton(Image image, double size, Color iconColor, VoidCallback onPressedCallback) {
    return Container(decoration: BoxDecoration(border: Border.all(color: iconColor, width: 0.1.w), shape: BoxShape.circle),
        width: size, height: size, child: IconButton(padding: const EdgeInsets.all(0.5), onPressed: onPressedCallback, icon: image, iconSize: size));
  }

  static Widget getRoundImageButton(Image image, double size, Color iconColor, VoidCallback onPressedCallback) {
    return SizedBox(width: size, height: size, child: IconButton(padding: const EdgeInsets.all(4.5), onPressed: onPressedCallback, icon: ClipRRect(
      borderRadius: BorderRadius.circular(10.0), child: image)));
  }

  static Widget getCircleNetWorkImage(double size, String imageUrl, AnimationController aniController){
    return Container(
        width: size,
        height: size,
        color:ColorStyles.dFinDarkWhiteGray,
        alignment: Alignment.center,
        child: ExtendedImage.network(
          imageUrl,
          fit: BoxFit.contain,
          border: Border.all(color: ColorStyles.dFinWhiteGray, width: 0.3.w),
          cache: true,
          cacheMaxAge: const Duration(hours: 1),
          shape: BoxShape.circle,
          loadStateChanged: (ExtendedImageState state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                aniController.reset();
                if(state.loadingProgress != null && state.loadingProgress!.expectedTotalBytes != null){
                  int total = state.loadingProgress!.expectedTotalBytes!;
                  int val = state.loadingProgress!.cumulativeBytesLoaded;
                  return Center(
                      child: CircularProgressIndicator(
                          color: ColorStyles.dFinWhite,
                          value: val / total
                      )
                  );
                }else{
                  return const Center(
                      child: CircularProgressIndicator(
                          color: ColorStyles.dFinWhite,
                          value: 1
                      )
                  );
                }
              case LoadState.completed:
                aniController.forward();

                return FadeTransition(
                  opacity: aniController,
                  child: ExtendedRawImage(
                    image: state.extendedImageInfo?.image,
                    fit: BoxFit.contain,
                  ),
                );
              case LoadState.failed:
                aniController.reset();
                return GestureDetector(
                  child: UiUtils.getIcon(8.w, 8.w, Icons.refresh_rounded, 8.w, ColorStyles.dFinRed),
                  onTap: () {
                    state.reLoadImage();
                  },
                );
            }
          },
        )
    );
  }

  static Widget getCircleImage(String imagePath, double size) {
    return SizedBox(width: size, height: size, child: CircleAvatar(backgroundImage: AssetImage(imagePath)));
  }

  static Widget getImage(double width, double height, Image image) {
    return SizedBox(width: width, height: height, child: image);
  }

  static Widget getIcon(double width, double height, IconData icon, double size, Color iconColor) {
    return SizedBox(width: width, height: height, child: Icon(icon, color: iconColor, size: size));
  }

  static Widget getIconButtonWithHeight(double height, IconData icon, double size, Color iconColor, VoidCallback onPressedCallback) {
    return SizedBox(height: height, width: height,
        child: IconButton(constraints: const BoxConstraints(), padding: EdgeInsets.zero, onPressed: onPressedCallback, icon: Icon(icon, color: iconColor, size: size)));
  }

  static Widget getIconButtonWithSize(double width, double height, IconData icon, double size, Color iconColor, VoidCallback onPressedCallback) {
    return SizedBox(height: height, width: width,
        child: IconButton(constraints: const BoxConstraints(), padding: EdgeInsets.zero, onPressed: onPressedCallback, icon: Icon(icon, color: iconColor, size: size)));
  }

  static Widget getIconButtonWithHeight3(IconData icon, double size, Color iconColor, VoidCallback onPressedCallback) {
    return IconButton(constraints: const BoxConstraints(), padding: EdgeInsets.zero, onPressed: onPressedCallback, icon: Icon(icon, color: iconColor, size: size));
  }

  static Widget getIconButtonWithHeight2(double height, IconData icon, double size, Color iconColor, VoidCallback onPressedCallback) {
    return SizedBox(height: height,
        width : 6.w,
        child: IconButton(constraints: const BoxConstraints(), padding: EdgeInsets.zero, onPressed: onPressedCallback, icon: Icon(icon, color: iconColor, size: size)));
  }


  static Widget getBackButton(VoidCallback onPressedCallback) {
    return SizedBox(
        width : 15.w,
        child: IconButton(constraints: const BoxConstraints(), padding: EdgeInsets.only(right: 5.w),
            onPressed: onPressedCallback, icon: Icon(Icons.arrow_back_ios_new_sharp, color: ColorStyles.dFinWhiteGray, size: 5.w)));
  }

  static Widget getBackButtonForMainView(VoidCallback onPressedCallback) {
    return SizedBox(
        width : 15.w,
        child: IconButton(constraints: const BoxConstraints(), padding: EdgeInsets.only(right: 10.w),
            onPressed: onPressedCallback, icon: Icon(Icons.arrow_back_ios_new_sharp, color: ColorStyles.dFinWhiteGray, size: 5.w)));
  }

  static Widget getCloseButton(Color iconColor, VoidCallback onPressedCallback) {
    return SizedBox(
        width : 15.w,
        child: IconButton(constraints: const BoxConstraints(), padding: EdgeInsets.only(left: 5.w),
            onPressed: onPressedCallback, icon: Icon(Icons.close, color: iconColor, size: 7.w)));
  }

  static Widget getIconButtonBox(double buttonWidth, Color buttonColor, IconData icon, double size, Color iconColor, VoidCallback onPressedCallback) {
    return Container(
        width: buttonWidth,
        height: buttonWidth,
        padding: EdgeInsets.zero,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            elevation: 0.5,
            shadowColor: ColorStyles.dFinGray,
          ),
          onPressed: onPressedCallback,
          child: Icon(icon, color: iconColor, size: size),
        )
    );
  }

  static SizedBox getTextButtonBox(double buttonWidth, String buttonText, TextStyle buttonTextStyles, Color buttonColor, VoidCallback onPressedCallback) {
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            elevation: 0.0,
            shadowColor: ColorStyles.dFinGray,
          ),
          onPressed: onPressedCallback,
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: getStyledTextWithFixedScale(buttonText,buttonTextStyles,TextAlign.center,null)
          ),
        )
    );
  }

  static SizedBox getCustomTextButtonBox(double buttonWidth, String buttonText, double fontSize, FontWeight fontWeight, Color buttonColor, Color textColor, VoidCallback onPressedCallback) {
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            elevation: 0.5,
            shadowColor: ColorStyles.dFinGray,
          ),
          onPressed: onPressedCallback,
          child: Padding(
              padding: EdgeInsets.only(top: 2.w, bottom: 2.w),
              child: getStyledTextWithFixedScale(buttonText,TextStyle(fontFamily: "SpoqaHanSansNeo", fontSize: fontSize, color: textColor, fontWeight: fontWeight, decoration: TextDecoration.none, decorationThickness: 0.0, height: 1), TextAlign.start,1)
          ),
        )
    );
  }

  static SizedBox getTextCustomPaddingButtonBox(double buttonWidth, String buttonText, TextStyle buttonTextStyles,
      EdgeInsets edgeInsets, Color buttonColor, VoidCallback onPressedCallback, int maxLine) {
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            elevation: 0.5,
            shadowColor: ColorStyles.dFinGray,
          ),
          onPressed: onPressedCallback,
          child: Padding(
              padding: edgeInsets,
              child: getStyledTextWithFixedScale(buttonText,buttonTextStyles,TextAlign.center,maxLine)
          ),
        )
    );
  }

  static SizedBox getBorderButtonBoxForSearch(double buttonWidth, Color buttonColor, Color borderColor, Widget childWidget, VoidCallback onPressedCallback){
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 4.w, bottom: 4.w),
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide(width: 1, color: borderColor),
            elevation: 1.5,
            shadowColor: ColorStyles.dFinBlack,
          ),
          onPressed: onPressedCallback,
          child: childWidget,
        )
    );
  }

  static SizedBox getBorderButtonBox(double buttonWidth, Color buttonColor, Color borderColor, Widget childWidget, VoidCallback onPressedCallback){
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 4.w, bottom: 4.w),
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide(width: 0.1.w, color: borderColor),
              elevation: 1.5,
              shadowColor: ColorStyles.dFinBlack,
            ),
            onPressed: onPressedCallback,
            child: childWidget,
        )
    );
  }

  static SizedBox getBorderButtonBoxWithNoShadow(double buttonWidth, Color buttonColor, Color borderColor, Widget childWidget, VoidCallback onPressedCallback){
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 4.w, bottom: 4.w),
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide(width: 0.1.w, color: borderColor),
            elevation: 0,
            shadowColor: ColorStyles.dFinBlack,
          ),
          onPressed: onPressedCallback,
          child: childWidget,
        )
    );
  }

  static SizedBox getBorderButtonBox2(double buttonWidth, Color buttonColor, Color borderColor, Widget childWidget, VoidCallback onPressedCallback){
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 4.w, bottom: 4.w),
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide(width: 0.1.w, color: borderColor),
            elevation: 0,
            shadowColor: ColorStyles.dFinBlack,
          ),
          onPressed: onPressedCallback,
          child: childWidget,
        )
    );
  }

  static SizedBox getBorderButtonBox5(double buttonWidth, Color buttonColor, Color borderColor, Widget childWidget, VoidCallback onPressedCallback){
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 2.w, bottom: 2.w),
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            side: BorderSide(width: 1, color: borderColor),
            elevation: 0.0,
            shadowColor: ColorStyles.dFinGray,
          ),
          onPressed: onPressedCallback,
          child: childWidget,
        )
    );
  }

  static SizedBox getBorderButtonBoxForChoiceType(double buttonWidth, Color buttonColor, Color borderColor, Widget childWidget, VoidCallback onPressedCallback){
    return SizedBox(
        width: buttonWidth,
        height: 33.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 4.w, bottom: 2.w),
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide(width: 1, color: borderColor),
            elevation: 0.0,
            shadowColor: ColorStyles.dFinGray,
          ),
          onPressed: onPressedCallback,
          child: childWidget,
        )
    );
  }

  static SizedBox getLoanListBorderButtonBox(double buttonWidth, Color buttonColor, Color borderColor, Widget childWidget, VoidCallback onPressedCallback){
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(left: 0, right: 0, top: 4.w, bottom: 4.w),
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
            side: BorderSide(width: 0.6, color: borderColor),
            elevation: 0.0,
            shadowColor: ColorStyles.dFinGray,
          ),
          onPressed: onPressedCallback,
          child: childWidget,
        )
    );
  }

  static Widget getSwitchButton(StateSetter setState, bool isSwitched, Color kSecondaryColor){
    return GestureDetector(
      onTap: () {
        setState(() {
          isSwitched = !isSwitched;
        });
      },
      child: Container(
        width: 20.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: kSecondaryColor),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(30),
                    color: isSwitched
                        ? Colors.white
                        : kSecondaryColor),
                child: Center(
                    child: Text(
                      'BUY',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSwitched
                              ? Colors.black
                              : Colors.white),
                    )),
              ),
              Container(
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(30),
                    color: isSwitched
                        ? kSecondaryColor
                        : Colors.white),
                child: Center(
                    child: Text(
                      'SELL',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSwitched
                              ? Colors.white
                              : Colors.black),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static SizedBox getMyInfoBorderButtonBox(double buttonWidth, Color buttonColor, Color borderColor, Widget childWidget, VoidCallback onPressedCallback){
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(left: 2.w, right: 2.w),
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
            side: BorderSide(width: 0.6, color: borderColor),
            elevation: 0.0,
            shadowColor: ColorStyles.dFinGray,
          ),
          onPressed: onPressedCallback,
          child: childWidget,
        )
    );
  }

  static SizedBox getBorderButtonBoxWithZeroPadding(double buttonWidth, Color buttonColor, Color borderColor, Widget childWidget, VoidCallback onPressedCallback){
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            side: BorderSide(width: 1.3, color: borderColor),
            elevation: 0.0,
            shadowColor: ColorStyles.dFinGray,
          ),
          onPressed: onPressedCallback,
          child: childWidget,
        )
    );
  }

  static SizedBox getBorderButtonBoxWithZeroPadding3(double buttonWidth, Color buttonColor, Color borderColor, Widget childWidget, VoidCallback onPressedCallback){
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
            side: BorderSide(width: 0, color: borderColor),
            elevation: 0.0,
            shadowColor: ColorStyles.dFinGray,
          ),
          onPressed: onPressedCallback,
          child: childWidget,
        )
    );
  }

  static SizedBox getBorderButtonBoxWithZeroPadding2(double buttonWidth, double buttonHeight, Color buttonColor, Color borderColor, Widget childWidget, VoidCallback onPressedCallback){
    return SizedBox(
        height: buttonHeight,
        width: buttonWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            side: BorderSide(width: 1.3, color: borderColor),
            elevation: 0.0,
            shadowColor: ColorStyles.dFinGray,
          ),
          onPressed: onPressedCallback,
          child: childWidget,
        )
    );
  }

  static SizedBox getBorderButtonBoxForRound(double buttonWidth, Color buttonColor, Color borderColor, Widget childWidget, VoidCallback onPressedCallback){
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide(width: 1.3, color: borderColor),
            elevation: 0.0,
            shadowColor: ColorStyles.dFinGray,
          ),
          onPressed: onPressedCallback,
          child: childWidget,
        )
    );
  }

  static Widget getBorderButtonBoxForRound2(Color buttonColor, Color borderColor, Widget childWidget, VoidCallback onPressedCallback){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 0, bottom: 0),
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: borderColor, width: 0.4.w),
        elevation: 0.0,
        shadowColor: ColorStyles.dFinGray,
      ),
      onPressed: onPressedCallback,
      child: childWidget,
    );
  }

  static Widget getBorderButtonBoxForRound3(Color buttonColor, Color borderColor, Widget childWidget, VoidCallback onPressedCallback){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(left: 3.w, right: 2.w, top: 3.w, bottom: 2.w),
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        side: BorderSide(color: borderColor, width: 0.26.w),
        elevation: 0,
        shadowColor: ColorStyles.dFinGray,
      ),
      onPressed: onPressedCallback,
      child: childWidget,
    );
  }

  static Widget getBorderButtonBoxForRound6(Color buttonColor, Color borderColor, Widget childWidget, VoidCallback onPressedCallback){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(left: 1.w, right: 0.w, top: 0.w, bottom: 1.w),
        backgroundColor: buttonColor,
        shape: const CircleBorder(),
        side: BorderSide(color: borderColor, width: 0.w),
        elevation: 0,
        shadowColor: ColorStyles.dFinGray,
      ),
      onPressed: onPressedCallback,
      child: childWidget,
    );
  }

  static SizedBox getBannerButtonBox(double buttonWidth, double buttonHeight, Color buttonColor, Color borderColor, Widget childWidget, VoidCallback onPressedCallback){
    return SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 4.w, bottom: 4.w),
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
            side: BorderSide(width: 1.3, color: borderColor),
            elevation: 0.0,
            shadowColor: ColorStyles.dFinGray,
          ),
          onPressed: onPressedCallback,
          child: childWidget,
        )
    );
  }

  static SizedBox getTopBannerButtonBox(double buttonWidth, double buttonHeight, Color buttonColor, Color borderColor, Widget childWidget, VoidCallback onPressedCallback){
    return SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
            side: BorderSide(width: 0, color: buttonColor),
            elevation: 0.0,
            shadowColor: ColorStyles.dFinGray,
          ),
          onPressed: onPressedCallback,
          child: childWidget,
        )
    );
  }

  static Widget getCountCircleBox(double circleBoxSize, int messageCount, double fontSize, FontWeight fontWeight, Color textColor, TextAlign textAlign, int textMaxLine){
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: circleBoxSize,
          height: circleBoxSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: ColorStyles.dFinRed, // 빨간색 배경
          ),
        ),
        // 안읽은 메시지 숫자 텍스트
        getTextWithFixedScale(messageCount > 99 ? "99+" : "$messageCount", fontSize, fontWeight, textColor, textAlign, textMaxLine)
      ],
    );
  }

  static Widget getSizedScrollView(double? scrollWidth, double? scrollHeight, Axis scrollDir, Widget scrollChildView){
    Widget? container;
    if(scrollWidth != null && scrollHeight != null){
      container = SizedBox(width: scrollWidth, height: scrollHeight, child: SingleChildScrollView(scrollDirection: scrollDir, physics: const BouncingScrollPhysics(), child: scrollChildView));
    }else{
      if(scrollWidth == null){
        container = SizedBox(height: scrollHeight, child: SingleChildScrollView(scrollDirection: scrollDir, physics: const BouncingScrollPhysics(), child: scrollChildView));
      }else if(scrollHeight == null){
        container = SizedBox(width: scrollWidth, child: SingleChildScrollView(scrollDirection: scrollDir, physics: const BouncingScrollPhysics(), child: scrollChildView));
      }
    }
    return container!;
  }

  static Widget getExpandedScrollView(Axis scrollDir, Widget scrollChildView){
    return Expanded(child: SingleChildScrollView(scrollDirection: scrollDir, child: scrollChildView));
  }

  static Widget getExpandedScrollViewWithController(Axis scrollDir, Widget scrollChildView, ScrollController controller){
    return Expanded(child: SingleChildScrollView(controller: controller, scrollDirection: scrollDir, child: scrollChildView));
  }

  static Widget getExpandedScrollViewWithScrollbar(Axis scrollDir, Widget scrollChildView, ScrollController controller){
    return Expanded(child: SizedBox(width: 90.w, child: Scrollbar(radius: const Radius.circular(3), trackVisibility: false, scrollbarOrientation: ScrollbarOrientation.right, thickness: 1.5.w, thumbVisibility: true, controller: controller, child: SingleChildScrollView(controller: controller, scrollDirection: scrollDir, child: scrollChildView))));
  }

  static Widget getDisabledTextField(BuildContext context, double width, String initText, TextStyle textStyle, InputDecoration inputDecoration){
    return SizedBox(width: width, child: MediaQuery(
        data : MediaQuery.of(context).copyWith(textScaleFactor : 1.1),
        child : TextFormField(initialValue: initText, enabled: false,
            decoration: inputDecoration, style: textStyle)));
  }

  static Widget getTextField(BuildContext context, double width, TextStyle textStyle, FocusNode focusNode, TextEditingController textEditingController, TextInputType textInputType,
      InputDecoration inputDecoration, ValueChanged<String> onChangedCallback){
    return SizedBox(width: width,
        child: MediaQuery(
            data : MediaQuery.of(context).copyWith(textScaleFactor : 1.1),
            child : TextField(enableInteractiveSelection: true, focusNode: focusNode, cursorColor: ColorStyles.dFinBlack, controller: textEditingController,
                keyboardType: textInputType, decoration: inputDecoration, onChanged: onChangedCallback, style: textStyle))
        );
  }

  static Widget getChatTextField(BuildContext context, double width, TextStyle textStyle, FocusNode focusNode, TextEditingController textEditingController, TextInputType textInputType,
      InputDecoration inputDecoration, ValueChanged<String> onChangedCallback){
    return SizedBox(width: width,
        child: MediaQuery(
            data : MediaQuery.of(context).copyWith(textScaleFactor : 1.1),
            child : TextField(enableInteractiveSelection: true, maxLines: null, focusNode: focusNode, cursorColor: ColorStyles.dFinBlack, controller: textEditingController,
                keyboardType: textInputType, decoration: inputDecoration, onChanged: onChangedCallback, style: textStyle)));
  }

  static Widget getTextFormField(BuildContext context, double width, TextStyle textStyle, FocusNode focusNode, TextEditingController textEditingController, TextInputType textInputType, bool isPwd,
      InputDecoration inputDecoration, ValueChanged<String> onChangedCallback, FormFieldValidator<String> validatorCallback){
    return SizedBox(width: width,
        child: MediaQuery(
            data : MediaQuery.of(context).copyWith(textScaleFactor : 1.1),
            child : TextFormField(enableInteractiveSelection: true, focusNode: focusNode, obscureText : isPwd, cursorColor: ColorStyles.dFinBlack, controller: textEditingController,
                keyboardType: textInputType, decoration: inputDecoration, onChanged: onChangedCallback, validator: validatorCallback, style: textStyle))
        );
  }

  static InputDecoration getInputDecoration(String labelText, double labelTextSize, String counterText, double counterTextSize){
    return InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(decoration: TextDecoration.none, height: 1.1, fontFamily: "SpoqaHanSansNeo", color: ColorStyles.dFinTextAndBorderBlue, fontSize: labelTextSize, fontWeight: FontWeight.w500),
        hintText: "",
        counterText: counterText,
        errorStyle: TextStyle(fontSize: 0.sp),
        contentPadding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.w),
        counterStyle: TextStyle(decoration: TextDecoration.none, height: 1.1, fontFamily: "SpoqaHanSansNeo", color: ColorStyles.dFinTextAndBorderBlue, fontSize: counterTextSize, fontWeight: FontWeight.w500),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: ColorStyles.dFinBlack)
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: ColorStyles.dFinBlack),
        ),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColorStyles.dFinRed)),
        filled: true,
        fillColor: ColorStyles.dFinDarkWhiteGray
    );
  }

  static InputDecoration getInputDecorationForPrice(String labelText, double labelTextSize, String counterText){
    return InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(decoration: TextDecoration.none, height: 1.1, fontFamily: "SpoqaHanSansNeo", color: ColorStyles.dFinTextAndBorderBlue, fontSize: labelTextSize, fontWeight: FontWeight.w500),
        hintText: "",
        counterText: counterText,
        isDense: true,
        suffixIcon: Text("만원  ", style: TextStyles.dFinDisabledTextFormFieldTextStyle),
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        errorStyle: TextStyle(fontSize: 0.sp),
        counterStyle: TextStyle(decoration: TextDecoration.none, height: 2.2, fontFamily: "SpoqaHanSansNeo", color: ColorStyles.dFinTextAndBorderBlue, fontSize: 10.sp, fontWeight: FontWeight.w500),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.dFinButtonBlue)),

        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: ColorStyles.dFinButtonBlue),
        ),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColorStyles.dFinRed)),
        filled: true,
        fillColor: ColorStyles.dFinWhite
    );
  }

  static InputDecoration getInputDecorationForAddress(String labelText, double labelTextSize, Widget iconWidget){
    return InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(decoration: TextDecoration.none, height: 1.1, fontFamily: "SpoqaHanSansNeo", color: ColorStyles.dFinTextAndBorderBlue, fontSize: labelTextSize, fontWeight: FontWeight.w500),
        hintText: "",
        isDense: true,
        suffixIcon: iconWidget,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        errorStyle: TextStyle(fontSize: 0.sp),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.dFinButtonBlue)),

        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: ColorStyles.dFinButtonBlue),
        ),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColorStyles.dFinRed)),
        filled: true,
        fillColor: ColorStyles.dFinWhite
    );
  }

  static InputDecoration getDisabledInputDecoration(String labelText, double labelTextSize, String counterText, double counterTextSize){
    return InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(decoration: TextDecoration.none, height: 1.1, fontFamily: "SpoqaHanSansNeo", color: ColorStyles.dFinRealGray, fontSize: labelTextSize, fontWeight: FontWeight.w500),
        hintText: "",
        counterText: counterText,
        errorStyle: TextStyle(fontSize: 0.sp),
        counterStyle: TextStyle(decoration: TextDecoration.none, height: 1.1, fontFamily: "SpoqaHanSansNeo", color: ColorStyles.dFinRealGray, fontSize: counterTextSize, fontWeight: FontWeight.w500),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.dFinButtonBlue)),
        border: InputBorder.none, // 언더라인 없애기
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: ColorStyles.dFinButtonBlue),
        ),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColorStyles.dFinButtonBlue)),
        filled: true,
        fillColor: ColorStyles.dFinBlack
    );
  }

  static InputDecoration getChatInputDecoration(){
    return InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(fontSize: 0.sp),
        errorStyle: TextStyle(fontSize: 0.sp),
        counterStyle: TextStyle(fontSize: 0.sp),
        hintStyle: TextStyles.dFinChatHintTextStyle,
        hintText: "메시지를 입력해주세요.",
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide: const BorderSide(color: ColorStyles.dFinWhiteGray),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide: const BorderSide(color: ColorStyles.dFinWhiteGray),
        ),
        filled: true,
        fillColor: ColorStyles.dFinWhiteGray
    );
  }

  static InputDecoration getCertCheckInputDecoration(){
    return InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(fontSize: 0.sp),
        errorStyle: TextStyle(fontSize: 0.sp),
        counterStyle: TextStyle(fontSize: 0.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 0.3.w, color: ColorStyles.dFinGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 0.3.w, color: ColorStyles.dFinGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 0.3.w, color: ColorStyles.dFinGray),
        ),
        filled: true,
        fillColor: ColorStyles.dFinWhite
    );
  }


  static bool isLoadingPopOn = false;
  static void showLoadingPop(BuildContext targetContext){
    if(!isLoadingPopOn){
      isLoadingPopOn = true;
      showGeneralDialog(
        barrierDismissible: false,
        context: targetContext,
        pageBuilder: (context, animation, secondaryAnimation) {
          return WillPopScope(
            onWillPop: () async => false,
            child: StatefulBuilder(// You need this, notice the parameters below:
                builder: (_, StateSetter setState) {
                  return Container(
                      width: 100.w,
                      height: 100.h,
                      color: ColorStyles.dFinDarkGrayWithAlpha,
                      child: SpinKitWave(color: ColorStyles.dFinTextAndBorderBlue, size: 15.w)
                  );
                })
          );
        },
      );
    }
  }
  static Timer? loadingCheckTimer;
  static int loadingTimerCount = 0;
  static bool isLoadingStop = false;
  static void showLoadingPercentPop(BuildContext targetContext, String text){
    if(!isLoadingPopOn){
      isLoadingPopOn = true;

      isLoadingStop = false;
      loadingTimerCount = 0;
      GetController.to.resetPercent();

      loadingCheckTimer ??= Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        if(!isLoadingStop){
          loadingTimerCount++;

          if(GetController.to.loadingPercent.value >= 80){
            GetController.to.updatePercent(0);
            if(loadingCheckTimer != null) loadingCheckTimer!.cancel();
            loadingCheckTimer = null;
          }else if(GetController.to.loadingPercent.value >= 60){
            GetController.to.updatePercent(6);
          }else if(GetController.to.loadingPercent.value >= 40){
            GetController.to.updatePercent(3);
          }else if(GetController.to.loadingPercent.value >= 20){
            GetController.to.updatePercent(4);
          }else if(GetController.to.loadingPercent.value >= 5){
            GetController.to.updatePercent(5);
          }else{
            GetController.to.updatePercent(3);
          }

          if(loadingTimerCount >= 100){
            if(loadingCheckTimer != null) loadingCheckTimer!.cancel();
            loadingCheckTimer = null;
          }
        }
      });

      showGeneralDialog(
        barrierDismissible: false,
        context: targetContext,
        pageBuilder: (context, animation, secondaryAnimation) {
          return WillPopScope(
              onWillPop: () async => false,
              child: StatefulBuilder(// You need this, notice the parameters below:
                  builder: (_, StateSetter setState) {
                    return Obx((){
                      return Center(child: Container(
                          width: 100.w,
                          height: 100.h,
                          color: Colors.black54,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment : MainAxisAlignment.center, children: [
                            SpinKitWave(color: ColorStyles.dFinTextAndBorderBlue, size: 15.w),
                            UiUtils.getMarginBox(0, 3.h),
                            UiUtils.getTextWithFixedScale(text, 12.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.center, 1),
                            UiUtils.getMarginBox(0, 2.h),
                            Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                              UiUtils.getTextWithFixedScale("${GetController.to.loadingPercent.value}", 16.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.center, null),
                              UiUtils.getMarginBox(0.5.w, 0),
                              UiUtils.getTextWithFixedScale("%", 16.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.center, null),
                            ])
                          ])
                      ));
                    });
                  })
          );
        },
      );
    }
  }

  static void closeLoadingPop(BuildContext targetContext){
    if(isLoadingPopOn){
      Navigator.pop(targetContext);
      isLoadingPopOn = false;
    }
  }

  static void closeLoadingPercentPop(BuildContext targetContext){
    if(isLoadingPopOn){
      GetController.to.setPercent(0);
      Navigator.pop(targetContext);
      if(loadingCheckTimer != null) loadingCheckTimer!.cancel();
      loadingCheckTimer = null;
      loadingTimerCount = 0;
      GetController.to.resetPercent();
      isLoadingPopOn = false;
      isLoadingStop = false;
    }
  }

  static void closeLoadingPercentPopForSuccess(BuildContext targetContext, Function(bool isEnd) callback){
    if(isLoadingPopOn){
      GetController.to.setPercent(100);
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(targetContext);
        if(loadingCheckTimer != null) loadingCheckTimer!.cancel();
        loadingCheckTimer = null;
        loadingTimerCount = 0;
        GetController.to.resetPercent();
        isLoadingPopOn = false;
        isLoadingStop = false;
        callback(true);
      });
    }
  }

  static bool isLoadingBackPopOn = false;
  static void showLoadingBackPop(BuildContext targetContext){
    if(!isLoadingBackPopOn){
      isLoadingBackPopOn = true;
      showGeneralDialog(
        barrierDismissible: false,
        context: targetContext,
        pageBuilder: (context, animation, secondaryAnimation) {
          return WillPopScope(
              onWillPop: () async => false,
              child: StatefulBuilder(// You need this, notice the parameters below:
                  builder: (_, StateSetter setState) {
                    return Container(
                        width: 100.w,
                        height: 100.h,
                        color: ColorStyles.dFinDarkGrayWithAlpha
                    );
                  })
          );
        },
      );
    }
  }

  static void closeLoadingBackPop(BuildContext targetContext){
    if(isLoadingBackPopOn){
      Navigator.pop(targetContext);
      isLoadingBackPopOn = false;
    }
  }

  static void showPop(BuildContext parentViewContext, Widget Function(BuildContext context, StateSetter setState) createWidgetMethod){
    double popWidth = 66.w;
    showDialog(
      barrierDismissible: false,
      context: parentViewContext,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: ColorStyles.dFinWhite,
          insetPadding: EdgeInsets.all(3.w),
          child: StatefulBuilder(
            builder: (__, StateSetter popViewSetState){
              Widget contentsWidget = createWidgetMethod(parentViewContext, popViewSetState);
              return SizedBox(
                  width: popWidth,
                  child: Padding(padding: EdgeInsets.all(3.w), child: contentsWidget));
            }
          )
        );
      },
    );
  }

  static bool isInitAgree = false;
  static List<Map<String, dynamic>> agreeInfoList = [];
  static ScrollController _agreeScrollController = ScrollController();
  static void _resetAgreeInfo(){
    isInitAgree = false;
    agreeInfoList.clear();
    agreeInfoList = [];
    _agreeScrollController.dispose();
    _agreeScrollController = ScrollController();
    for(int i = 0 ; i <LogfinController.agreeDocsList.length ; i++){
      LogfinController.agreeDocsList[i]["isAgree"] = false;
    }
  }

  static void showAgreePop(BuildContext parentContext, String type, String companyDocCode, VoidCallback onPressedCallback){
    _resetAgreeInfo();
    _showSlideMenuForAgreePop(parentContext, SlideMenuMoveType.bottomToTop, true, 100.w, 65.h, 0.5, type, companyDocCode, onPressedCallback, _makeAgreeWidget);
  }

  static Widget _makeAgreeWidget(String type, String companyDocCode, BuildContext parentContext, BuildContext thisContext, StateSetter thisSetState, VoidCallback onPressedCallback){
    if(!isInitAgree){
      for(var each in LogfinController.agreeDocsList){

        if(each["type"].toString().contains(type)){
          agreeInfoList.add(each);
        }
      }

      CommonUtils.log("w","agreeInfoList length : ${agreeInfoList.length}");
      agreeInfoList.sort((a,b)=>int.parse(a["detailType"].toString().split("@")[2]).compareTo(int.parse(b["detailType"].toString().split("@")[2])));
      isInitAgree =  true;
      thisSetState(() {});
    }

    void setAgreeState(bool isAgree, bool isForAll, String targetId){
      for(int i = 0 ; i < agreeInfoList.length ; i++){
        if(isForAll){
          agreeInfoList[i]["isAgree"] = isAgree;
        }else{
          if(agreeInfoList[i]["type"].toString() == targetId){
            agreeInfoList[i]["isAgree"] = isAgree;
          }
        }
      }
    }

    void setTypeAgreeState(bool isAgree, String type, String targetDetailType){
      for(int i = 0 ; i < agreeInfoList.length ; i++){
        if(agreeInfoList[i]["type"].toString().contains(type)){
          if(agreeInfoList[i]["detailType"].toString().split("@")[1] == targetDetailType){
            agreeInfoList[i]["isAgree"] = isAgree;
          }
        }
      }
    }

    bool isAllAgree(){
      bool isAllAgreed = true;
      for(int i = 0 ; i < agreeInfoList.length ; i++){
        if(!agreeInfoList[i]["isAgree"]) isAllAgreed = false;
      }

      return isAllAgreed;
    }

    bool isTypeAgree(String detailType){
      bool isAllAgreed = true;
      for(int i = 0 ; i < agreeInfoList.length ; i++){
        if(agreeInfoList[i]["detailType"].toString().split("@")[1] == detailType){
          if(!agreeInfoList[i]["isAgree"]) isAllAgreed = false;
        }
      }

      return isAllAgreed;
    }

    String getAgreeTypeTitle(String detailType){
      String resultTitle = "";
      for(var each in LogfinController.agreeDocsDetailTypeInfoList){
        if(each.split("@")[0] == detailType) resultTitle = each.split("@")[1];
      }

      return resultTitle;
    }

    Future<void> smallAgreePressEvent(BuildContext parentContext, String titleString, String contentsString, Function(bool agreeResult) callback) async {
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
          renderMode: RenderMode.column,
          textStyle: TextStyles.dFinHtmlTextStyle,
        )
      ]);

      bool isAgree = await CommonUtils.moveToWithResult(parentContext, AppView.appAgreeDetailInfoView.value, {"title": titleString, "contents" : htmlWidget}) as bool;
      callback(isAgree);
    }

    Widget getSmallAgreeInfoWidget(String titleString, String contentsString, bool isAgreeCheck, Function(bool isCheck) callAct){
      return SizedBox(width: 100.w, height: 4.h, child: Row(children: [
        UiUtils.getBorderButtonBoxWithZeroPadding(87.5.w, ColorStyles.dFinDarkWhiteGray, ColorStyles.dFinDarkWhiteGray, Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          isAgreeCheck? UiUtils.getCustomCheckBox(UniqueKey(), 1, isAgreeCheck, ColorStyles.dFinButtonBlue, ColorStyles.dFinWhite,
              ColorStyles.dFinWhite, ColorStyles.dFinWhite, (checkedValue){
                thisSetState(() {
                  if(checkedValue != null){
                    callAct(checkedValue);
                  }
                });
              }) : UiUtils.getCustomCheckBox(UniqueKey(), 1, true, ColorStyles.dFinGray, ColorStyles.dFinWhite,
              ColorStyles.dFinWhite, ColorStyles.dFinWhite, (checkedValue){
                thisSetState(() {
                  if(checkedValue != null){
                    if(!checkedValue) {
                      callAct(true);
                    }
                  }
                });
              }),
          UiUtils.getTextButtonWithFixedScale2(titleString, 10.sp, FontWeight.w500, ColorStyles.dFinWhiteGray, TextAlign.start, null, () {
            smallAgreePressEvent(parentContext, titleString, contentsString, (agreeResult){
              thisSetState(() {
                callAct(agreeResult);
              });
            });
          }),
          const Spacer(flex: 2),
          UiUtils.getIconButton(Icons.arrow_forward_ios_rounded, 4.w, ColorStyles.dFinGray, () {
            smallAgreePressEvent(parentContext, titleString, contentsString, (agreeResult){
              thisSetState(() {
                callAct(agreeResult);
              });
            });
          })
        ]), () {
          smallAgreePressEvent(parentContext, titleString, contentsString, (agreeResult){
            thisSetState(() {
              callAct(agreeResult);
            });
          });
        })
      ]));
    }

    Widget getAgreeTypeTitleWidget(String type, String detailType){
      return Container(padding: EdgeInsets.zero, height: 3.h, child: Row(
        children: [
          UiUtils.getCheckBox(1.2, isTypeAgree(detailType), (isChanged) {
            thisSetState(() {
              setTypeAgreeState(isChanged!, type, detailType);
            });
          }),
          UiUtils.getTextWithFixedScale(getAgreeTypeTitle(detailType), 12.sp, FontWeight.w500, ColorStyles.dFinWhiteGray, TextAlign.center, null)
        ],
      ));
    }

    String getMaxDetailType(String detailType){
      int maxDetailType = 0;
      for(int i = 0 ; i < agreeInfoList.length ; i++){
        int eachDetailType = int.parse(agreeInfoList[i]["detailType"].toString().split("@")[1]);
        if(maxDetailType < eachDetailType) maxDetailType = eachDetailType;
      }

      return maxDetailType.toString();
    }

    List<Widget> getTypeAgreeWidgetList(String type, String detailType){
      List<Widget> widgetList = [];
      List<Map<String,dynamic>> agreeTypeInfoList = [];
      for(int i = 0 ; i < agreeInfoList.length ; i++){
        if(agreeInfoList[i]["type"].toString().contains(type) && agreeInfoList[i]["detailType"].toString().split("@")[1] == detailType){
          agreeTypeInfoList.add(agreeInfoList[i]);
        }
      }

      agreeTypeInfoList.sort((a,b)=>int.parse(a["detailType"].toString().split("@")[2]).compareTo(int.parse(b["detailType"].toString().split("@")[2])));
      Widget titleWidget = Container();
      List<Widget> titleChildWidgetList = [];
      for(int i = 0 ; i < agreeTypeInfoList.length ; i++){
        if(i == 0){
          titleWidget = getAgreeTypeTitleWidget(type, detailType);
        }
        titleChildWidgetList.add(getSmallAgreeInfoWidget(LogfinController.getAgreeTitle(agreeTypeInfoList[i]["type"].toString()),
            LogfinController.getAgreeContents(agreeTypeInfoList[i]["type"].toString()), agreeTypeInfoList[i]["isAgree"], (bool isChecked){
              agreeTypeInfoList[i]["isAgree"] = isChecked;
            }));
      }

      titleChildWidgetList.add(UiUtils.getMarginBox(0, 1.5.h));
      widgetList.add(
        ExpansionTileWithoutBorderItem(
            title: titleWidget,
            childrenPadding: EdgeInsets.zero,tilePadding: EdgeInsets.zero, iconColor: ColorStyles.dFinWhiteGray, collapsedIconColor: ColorStyles.dFinWhiteGray,
            initiallyExpanded: true,
            onExpansionChanged: (isExpanded){
              if (isExpanded) {
                if(detailType == getMaxDetailType(detailType)){
                  Future.delayed(const Duration(milliseconds: 200), () async {
                    if(_agreeScrollController.hasClients){
                      _agreeScrollController.animateTo(
                        _agreeScrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.ease,
                      );
                    }
                  });

                }
              }
            },
            children: titleChildWidgetList),
      );

      return widgetList;
    }

    List<Widget> getAgreeWidgetList(){
      List<Widget> widgetList = [];
      String currentDetailType = "";
      for(int i = 0 ; i < agreeInfoList.length ; i++){
        if(currentDetailType != agreeInfoList[i]["detailType"].toString().split("@")[1]){
          widgetList.addAll(getTypeAgreeWidgetList(agreeInfoList[i]["type"].toString().substring(0,1), agreeInfoList[i]["detailType"].toString().split("@")[1]));
          currentDetailType = agreeInfoList[i]["detailType"].toString().split("@")[1];
        }
      }
      return widgetList;
    }

    return Material(color: ColorStyles.dFinDarkWhiteGray, child: Container(color: ColorStyles.dFinDarkWhiteGray,
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.end,children: [
            UiUtils.getIconButton(Icons.close, 7.w, ColorStyles.dFinWhiteGray, () {
              Navigator.pop(thisContext);
            })
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start,children: [
            UiUtils.getTextWithFixedScale("AND 서비스 약관동의", 16.sp, FontWeight.w800, ColorStyles.dFinWhiteGray, TextAlign.center, null)
          ]),
          UiUtils.getMarginBox(0, 1.5.h),
          Wrap(children: [
            UiUtils.getTextWithFixedScaleForAgreeSubTitle("서비스를 이용하기 위해 고객님의 서비스 이용약관에 동의가 필요합니다.", 12.sp, FontWeight.w500, ColorStyles.dFinWhiteGray, TextAlign.start, null)
          ]),
          UiUtils.getMarginBox(0, 3.h),
          GestureDetector(child: Container(height: 8.h, color: ColorStyles.dFinDarkWhiteGray, child: Row(
            children: [
              UiUtils.getCheckBox(1.2, isAllAgree(), (isChanged) {
                thisSetState(() {
                  setAgreeState(isChanged!, true, "");
                });
              }),
              UiUtils.getTextWithFixedScale("전체동의", 14.sp, FontWeight.w500, ColorStyles.dFinWhiteGray, TextAlign.center, null)
            ],
          )),onTap: (){
            thisSetState(() {
              if(isAllAgree()){
                setAgreeState(false, true, "");
              }else{
                setAgreeState(true, true, "");
              }
            });
          }),
          UiUtils.getExpandedScrollViewWithController(Axis.vertical, Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
            Column(crossAxisAlignment:CrossAxisAlignment.start, children: getAgreeWidgetList()),
          ]), _agreeScrollController),
          UiUtils.getMarginBox(0, 1.5.h),
          isTypeAgree("1") ? UiUtils.getBorderButtonBox(90.w, ColorStyles.dFinButtonBlue, ColorStyles.dFinButtonBlue,
              getTextWithFixedScale("동의하기", 14.sp, FontWeight.w500, ColorStyles.dFinWhiteGray, TextAlign.center, 1), (){
            Navigator.pop(thisContext);
            onPressedCallback();
          }) : UiUtils.getBorderButtonBox(90.w, ColorStyles.dFinButtonBlue, ColorStyles.dFinButtonBlue,
              getTextWithFixedScale("동의하기", 14.sp, FontWeight.w500, ColorStyles.dFinWhiteGray, TextAlign.center, 1), (){}),
          Config.isAndroid? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 3.h)
        ])
    ));
  }

  static Widget getRowColumnWithAlignCenter(List<Widget> viewList){
    return Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [Column(crossAxisAlignment: CrossAxisAlignment.center, children: viewList)]);
  }

  static Widget getCheckBox(double size, bool checkedValue, Function(bool?) onChanged){
    return Transform.scale(scale: size, child: Checkbox(
        value: checkedValue,
        onChanged: onChanged,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
        checkColor: ColorStyles.dFinWhite,
        activeColor: ColorStyles.dFinButtonBlue,
        side: MaterialStateBorderSide.resolveWith((states) =>
         !checkedValue? const BorderSide(width: 2.0, color: ColorStyles.dFinGray) : const BorderSide(width: 2.0, color: ColorStyles.dFinButtonBlue))
    ));
  }

  static Widget getCustomCheckBox(Key key, double size, bool checkedValue,
      Color activeCheckColor, Color activeFillColor, Color borderColor, Color activeBorderColor, Function(bool?) onChanged){
    return Transform.scale(scale: size, child: Container(padding: EdgeInsets.zero, child: Checkbox(
        key: key,
        value: checkedValue,
        onChanged: onChanged,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
        checkColor: activeCheckColor,
        activeColor: activeFillColor,
        side: MaterialStateBorderSide.resolveWith((states) =>
        !checkedValue? BorderSide(width: 2.0, color: borderColor) : BorderSide(width: 2.0, color: activeBorderColor))
    )));
  }

  static Widget getCustomCircleCheckBox(Key key, double size, bool checkedValue,
      Color activeCheckColor, Color activeFillColor, Color borderColor, Color activeBorderColor, Function(bool?) onChanged){
    return Transform.scale(scale: size, child: Container(padding: EdgeInsets.zero, child: Checkbox(
        key: key,
        value: checkedValue,
        onChanged: onChanged,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        checkColor: activeCheckColor,
        activeColor: activeFillColor,
        side: MaterialStateBorderSide.resolveWith((states) =>
        !checkedValue? BorderSide(width: 2.0, color: borderColor) : BorderSide(width: 2.0, color: activeBorderColor))
    )));
  }

  static Widget getAnimatedText(String text, Color textColor, double fontSize, FontWeight fontWeight, Duration duration, int repeat, Function() callback){
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
            text,
            textStyle: TextStyle(decoration: TextDecoration.none, height: 1.1, fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor),
            speed: duration
        ),
      ],
      totalRepeatCount: repeat,
      pause: const Duration(milliseconds: 1000),
      displayFullTextOnTap: true,
      stopPauseOnTap: false,
    );
  }

  static Widget getAnimatedTextList(List<String> textList, Color textColor, double fontSize, FontWeight fontWeight, Duration duration, int repeat, Function() callback){
    List<TypewriterAnimatedText> list = [];
    for(var each in textList){
      list.add(TypewriterAnimatedText(
          each,
          textStyle: TextStyle(decoration: TextDecoration.none, height: 1.1, fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor),
          speed: duration
      ));
    }
    return AnimatedTextKit(
      animatedTexts: list,
      totalRepeatCount: repeat,
      pause: const Duration(seconds: 3),
      displayFullTextOnTap: true,
      stopPauseOnTap: false,
    );
  }

  static void showSlideMenu(BuildContext parentViewContext, SlideMenuMoveType slideType, bool isDismissible,
      double? width, double? height, double opacity, Widget Function(BuildContext context, StateSetter setState) createWidgetMethod){
    double popWidth = 0.0;
    double popHeight = 0.0;
    if(width == null) {
      popWidth = 66.w;
    }else{
      popWidth = width;
    }
    if(height == null) {
      popHeight = 33.w;
    }else{
      popHeight = height;
    }

    BorderRadius borderRadius = BorderRadius.circular(30);
    Alignment alignment = Alignment.bottomCenter;

    showGeneralDialog(
      barrierLabel: "",
      barrierDismissible: isDismissible,
      barrierColor: Colors.black.withOpacity(opacity),
      transitionDuration: const Duration(milliseconds: 300),
      context: parentViewContext,
      pageBuilder: (context, anim1, anim2) {
        switch (slideType) {
          case SlideMenuMoveType.leftToRight:
            popHeight = 100.h;
            alignment = Alignment.centerLeft;
            borderRadius = const BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30));
            break;
          case SlideMenuMoveType.rightToLeft:
            popHeight = 100.h;
            alignment = Alignment.centerRight;
            borderRadius = const BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30));
            break;
          case SlideMenuMoveType.bottomToTop:
            popWidth = 100.w;
            alignment = Alignment.bottomCenter;
            borderRadius = const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30));
            break;
          case SlideMenuMoveType.topToBottom:
            popWidth = 100.w;
            alignment = Alignment.topCenter;
            borderRadius = const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30));
            break;
          default:
            popWidth = 100.w;
            alignment = Alignment.bottomCenter;
            borderRadius = const BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30));
        }

        return WillPopScope(
          onWillPop: () async => isDismissible,
          child: Align(
            alignment: alignment,
            child: Container(
              width: popWidth,
              height: popHeight,
              decoration: BoxDecoration(
                color: ColorStyles.dFinDarkWhiteGray,
                borderRadius: borderRadius,
              ),
              child: SizedBox.expand(
                  child: StatefulBuilder(
                      builder: (_, StateSetter popViewSetState){
                        Widget contentsWidget = createWidgetMethod(parentViewContext, popViewSetState);
                        return Padding(padding: EdgeInsets.all(5.w), child: contentsWidget);
                      }
                  )
              ),
            ),
          )
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        switch (slideType) {
          case SlideMenuMoveType.rightToLeft:
            return SlideTransition(
              position: Tween(begin: const Offset(1, 0), end: const Offset(0,0)).animate(anim1),
              child: child,
            );
          case SlideMenuMoveType.leftToRight:
            return SlideTransition(
              position: Tween(begin: const Offset(-1, 0), end: const Offset(0,0)).animate(anim1),
              child: child,
            );
          case SlideMenuMoveType.bottomToTop:
            return SlideTransition(
              position: Tween(begin: const Offset(0, 1), end: const Offset(0,0)).animate(anim1),
              child: child,
            );
          case SlideMenuMoveType.topToBottom:
            return SlideTransition(
              position: Tween(begin: const Offset(0, -1), end: const Offset(0,0)).animate(anim1),
              child: child,
            );
          default:
            return SlideTransition(
              position: Tween(begin: const Offset(1, 0), end: const Offset(0,0)).animate(anim1),
              child: child,
            );
        }
      },
    );
  }

  static void _showSlideMenuForAgreePop(BuildContext parentViewContext, SlideMenuMoveType slideType, bool isDismissible, double? width, double? height, double opacity,
      String type, String companyDocCode, VoidCallback onPressedCallback, Widget Function(String type, String companyName, BuildContext parentContext, BuildContext thisContext, StateSetter thisSetState, VoidCallback onPressedCallback) createWidgetMethod){
    double popWidth = 0.0;
    double popHeight = 0.0;
    if(width == null) {
      popWidth = 66.w;
    }else{
      popWidth = width;
    }
    if(height == null) {
      popHeight = 33.w;
    }else{
      popHeight = height;
    }

    BorderRadius borderRadius = BorderRadius.circular(30);
    Alignment alignment = Alignment.bottomCenter;

    showGeneralDialog(
      barrierLabel: "",
      barrierDismissible: isDismissible,
      barrierColor: Colors.black.withOpacity(opacity),
      transitionDuration: const Duration(milliseconds: 300),
      context: parentViewContext,
      pageBuilder: (context, anim1, anim2) {
        switch (slideType) {
          case SlideMenuMoveType.leftToRight:
            popHeight = 100.h;
            alignment = Alignment.centerLeft;
            borderRadius = const BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30));
            break;
          case SlideMenuMoveType.rightToLeft:
            popHeight = 100.h;
            alignment = Alignment.centerRight;
            borderRadius = const BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30));
            break;
          case SlideMenuMoveType.bottomToTop:
            popWidth = 100.w;
            alignment = Alignment.bottomCenter;
            borderRadius = const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30));
            break;
          case SlideMenuMoveType.topToBottom:
            popWidth = 100.w;
            alignment = Alignment.topCenter;
            borderRadius = const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30));
            break;
          default:
            popWidth = 100.w;
            alignment = Alignment.bottomCenter;
            borderRadius = const BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30));
        }

        return WillPopScope(
            onWillPop: () async => isDismissible,
            child: Align(
              alignment: alignment,
              child: Container(
                width: popWidth,
                height: popHeight,
                decoration: BoxDecoration(
                  color: ColorStyles.dFinDarkWhiteGray,
                  borderRadius: borderRadius,
                ),
                child: SizedBox.expand(
                    child: StatefulBuilder(
                        builder: (_, StateSetter popViewSetState){
                          Widget contentsWidget = createWidgetMethod(type, companyDocCode, parentViewContext, parentViewContext, popViewSetState, onPressedCallback);
                          return Padding(padding: EdgeInsets.all(5.w), child: contentsWidget);
                        }
                    )
                ),
              ),
            )
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        switch (slideType) {
          case SlideMenuMoveType.rightToLeft:
            return SlideTransition(
              position: Tween(begin: const Offset(1, 0), end: const Offset(0,0)).animate(anim1),
              child: child,
            );
          case SlideMenuMoveType.leftToRight:
            return SlideTransition(
              position: Tween(begin: const Offset(-1, 0), end: const Offset(0,0)).animate(anim1),
              child: child,
            );
          case SlideMenuMoveType.bottomToTop:
            return SlideTransition(
              position: Tween(begin: const Offset(0, 1), end: const Offset(0,0)).animate(anim1),
              child: child,
            );
          case SlideMenuMoveType.topToBottom:
            return SlideTransition(
              position: Tween(begin: const Offset(0, -1), end: const Offset(0,0)).animate(anim1),
              child: child,
            );
          default:
            return SlideTransition(
              position: Tween(begin: const Offset(1, 0), end: const Offset(0,0)).animate(anim1),
              child: child,
            );
        }
      },
    );
  }

  static void showPopMenu(BuildContext parentViewContext, bool isDismissible, double? width, double? height, double opacity, double radius, Color backColor,
      Widget Function(BuildContext context, StateSetter setState) createWidgetMethod){
    double popWidth = 0.0;
    double popHeight = 0.0;
    if(width == null) {
      popWidth = 66.w;
    }else{
      popWidth = width;
    }
    if(height == null) {
      popHeight = 33.w;
    }else{
      popHeight = height;
    }

    Alignment alignment = Alignment.bottomCenter;
    BorderRadius borderRadius = BorderRadius.circular(radius);

    showGeneralDialog(
      barrierLabel: "",
      barrierDismissible: isDismissible,
      barrierColor: Colors.black.withOpacity(opacity),
      transitionDuration: const Duration(milliseconds: 50),
      context: parentViewContext,
      pageBuilder: (context, anim1, anim2) {
        return WillPopScope(
            onWillPop: () async => isDismissible,
            child: Align(
              alignment: alignment,
              child: SafeArea(child:Container(
                width: popWidth,
                height: popHeight,
                decoration: BoxDecoration(
                  color: backColor,
                  borderRadius: borderRadius,
                ),
                child: SizedBox.expand(
                    child: StatefulBuilder(
                        builder: (_, StateSetter popViewSetState){
                          Widget contentsWidget = createWidgetMethod(parentViewContext, popViewSetState);
                          return Padding(padding: EdgeInsets.only(top: 3.w), child: Scaffold(
                              backgroundColor: backColor,
                              body:contentsWidget
                          ));
                        }
                    )
                ),
              ))
            )
        );
      }
    );
  }

  static Widget getFab(FabType fabType, IconData? icon, String? text, Color fabColor, VoidCallback onPressedCallback){
    Alignment alignment = Alignment.bottomLeft;
    switch (fabType) {
      case FabType.bottomLeft:
        alignment = Alignment.bottomLeft;
        break;
      case FabType.bottomRight:
        alignment = Alignment.bottomRight;
        break;
      default:
        alignment = Alignment.bottomLeft;
    }

    return Align(
      alignment: alignment,
      child: Padding(
          padding: EdgeInsets.all(5.w),
          child: FloatingActionButton.extended(
            label: Text(text!),
            icon: Icon(icon),
            backgroundColor: fabColor,
            onPressed: onPressedCallback,
          )
      )
    );
  }

  static Widget getInitLoadingView(int percent) {
    return Container(width: 100.w, height: 100.h, color: ColorStyles.dFinBlack,
        child: Stack(alignment: Alignment.center, children: [
          Positioned(
              top: Config.isPad()? 15.h : 35.h,
              child: Center(child: Column(children: [
                UiUtils.getTitleWithFixedScale("AND", Config.isPad()? 55.sp : 75.sp, FontWeight.w500, ColorStyles.dFinButtonBlue, TextAlign.center, null),
                UiUtils.getMarginBox(0, 5.h),
                UiUtils.getTitleWithFixedScale("값어치를 하는 내차량의 재발견", Config.isPad()? 16.sp : 16.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.center, null)
              ])))
        ])
    );
      /*
      Container(width: 100.w, height: 100.h, color: ColorStyles.upFinWhite,
        child: Center(child: CircularPercentIndicator(
          animateFromLastPercent: true,
          radius: 65.0,
          lineWidth: 15.0,
          animation: true,
          percent: percent/100,
          center: getTextWithFixedScale("$percent%", 14.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.center, null),
          footer: Column(children: [getMarginBox(0, 3.h),getTextWithFixedScale("데이터를 가져오는 중입니다.", 13.sp, FontWeight.w800, ColorStyles.upFinTextAndBorderBlue, TextAlign.center, null)]),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: ColorStyles.upFinButtonBlue,
        ))
    );
       */
  }

}