import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/styles/TextStyles.dart';
import '../styles/ColorStyles.dart';
import '../configs/app_config.dart';
import 'common_utils.dart';

class UiUtils {
  static Widget startAppView(){
    return Sizer(
      builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
        return MaterialApp(
          theme: ThemeData(useMaterial3: true),
          initialRoute: AppView.appRootView.value,
          routes: Config.appRoutes
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
                  backgroundColor: ColorStyles.upFinWhite,
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
                  backgroundColor: ColorStyles.upFinWhite,
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
                  backgroundColor: ColorStyles.upFinWhite,
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
                    backgroundColor: ColorStyles.upFinWhite,
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
      child: Text(text, style: TextStyle(decoration: TextDecoration.none, height: 1, fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor)));
  }

  static Widget getRoundedBoxTextWithFixedScale(String text, double fontSize, FontWeight fontWeight, TextAlign? textAlign, Color borderColor, Color fillColor, Color textColor){
    return Container(padding: EdgeInsets.only(top: 2.w, bottom: 2.w, left: 3.w, right: 3.w), // 텍스트 주위에 여백 추가
        decoration: BoxDecoration(color: fillColor, border: Border.all(color: borderColor, width: 0.4.w), borderRadius: BorderRadius.circular(20)),
        child: Text(text, style: TextStyle(decoration: TextDecoration.none, height: 1, fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor)));
  }

  static Widget getBoxTextWithFixedScale(String text, double fontSize, FontWeight fontWeight, TextAlign? textAlign, Color boxColor, Color textColor){
    return Container(color: boxColor, child: FittedBox(fit: BoxFit.contain, alignment: Alignment.center,
    child: Padding(padding: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 1.w, top: 1.w), child: Text(text, style: TextStyle(fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor)))));
  }

  static Widget getBoxTextAndIconWithFixedScale(String text, double fontSize, FontWeight fontWeight, TextAlign? textAlign, Color boxColor, Color textColor, IconData icon, Color iconColor, double iconSize){
    return Container(color: boxColor, child: FittedBox(fit: BoxFit.contain, alignment: Alignment.center,
        child: Padding(padding: EdgeInsets.only(left: 2.w, right: 2.5.w, bottom: 2.w, top: 2.w), child: Row(children: [
          getIcon(iconSize, iconSize, icon, iconSize, iconColor),
          getMarginBox(1.w, 0),
          Text(text, style: TextStyle(fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor))
        ])
        )));
  }

  static Widget getRoundBoxTextWithFixedScale(String text, double fontSize, FontWeight fontWeight, TextAlign? textAlign, Color boxColor, Color textColor){
    return Container(
        decoration: BoxDecoration(
          color: boxColor, // 배경색 설정
          borderRadius: BorderRadius.circular(20.0), // 모서리를 둥글게 하는 부분
    ),child: FittedBox(fit: BoxFit.contain, alignment: Alignment.center,
        child: Padding(padding: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 1.w, top: 1.w), child: Text(text, style: TextStyle(fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor)))));
  }

  static Widget getRoundBoxTextWithFixedScale2(String text, double fontSize, FontWeight fontWeight, TextAlign? textAlign, Color boxColor, Color textColor){
    return Container(
        decoration: BoxDecoration(
          color: boxColor, // 배경색 설정
          borderRadius: BorderRadius.circular(20.0), // 모서리를 둥글게 하는 부분
        ),child: FittedBox(fit: BoxFit.contain, alignment: Alignment.center,
        child: Padding(padding: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 2.w, top: 2.w), child: Text(text, style: TextStyle(fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor)))));
  }


  static SelectableText getSelectableTextWithFixedScale(String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign? textAlign, int? textMaxLine){
    return SelectableText(text, style: TextStyle(decoration: TextDecoration.none, height: 1, fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor), textScaleFactor: 1.0, textAlign: textAlign, maxLines: textMaxLine);
  }

  static SelectableText getSelectableStyledTextWithFixedScale(String text, TextStyle textStyle, TextAlign? textAlign, int? textMaxLine){
    return SelectableText(text, style: textStyle,  textScaleFactor: 1.0, textAlign: textAlign, maxLines: textMaxLine);
  }

  static Widget getTextWithUnderline(String text, TextStyle textStyle, Color underlineColor, VoidCallback? onPressedCallback){
    return Column(mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[Container(padding: EdgeInsets.only(bottom: 1.w),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: underlineColor, width: 0.5.w))),
          child: GestureDetector(onTap: onPressedCallback, child: getStyledTextWithFixedScale(text,textStyle,null,null)))]);
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
    return SizedBox(width: size, height: size, child: IconButton(padding: const EdgeInsets.all(4.5), onPressed: onPressedCallback, icon: image, iconSize: size));
  }

  static Widget getRoundImageButton(Image image, double size, Color iconColor, VoidCallback onPressedCallback) {
    return SizedBox(width: size, height: size, child: IconButton(padding: const EdgeInsets.all(4.5), onPressed: onPressedCallback, icon: ClipRRect(
      borderRadius: BorderRadius.circular(10.0), child: image)));
  }

  static Widget getImage(double width, double height, Image image) {
    return SizedBox(width: width, height: height, child: image);
  }

  static Widget getIcon(double width, double height, IconData icon, double size, Color iconColor) {
    return SizedBox(width: width, height: height, child: Icon(icon, color: iconColor, size: size));
  }

  static Widget getIconButtonWithHeight(double height, IconData icon, double size, Color iconColor, VoidCallback onPressedCallback) {
    return SizedBox(height: height,
        child: IconButton(constraints: const BoxConstraints(), padding: EdgeInsets.zero, onPressed: onPressedCallback, icon: Icon(icon, color: iconColor, size: size)));
  }

  static Widget getBackButton(VoidCallback onPressedCallback) {
    return SizedBox(
        width : 10.w,
        child: IconButton(constraints: const BoxConstraints(), padding: EdgeInsets.only(right: 5.w),
            onPressed: onPressedCallback, icon: Icon(Icons.arrow_back_ios_new_sharp, color: ColorStyles.upFinDarkGray, size: 5.w)));
  }

  static Widget getCloseButton(Color iconColor, VoidCallback onPressedCallback) {
    return SizedBox(
        width : 10.w,
        child: IconButton(constraints: const BoxConstraints(), padding: EdgeInsets.only(right: 1.w, left: 5.w),
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
            shadowColor: ColorStyles.upFinGray,
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
            shadowColor: ColorStyles.upFinGray,
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
            shadowColor: ColorStyles.upFinGray,
          ),
          onPressed: onPressedCallback,
          child: Padding(
              padding: EdgeInsets.zero,
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
            shadowColor: ColorStyles.upFinGray,
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            side: BorderSide(width: 1, color: borderColor),
            elevation: 0.0,
            shadowColor: ColorStyles.upFinGray,
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
              side: BorderSide(width: 1, color: borderColor),
              elevation: 0.0,
              shadowColor: ColorStyles.upFinGray,
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
            padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 4.w, bottom: 4.w),
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: BorderSide(width: 1, color: borderColor),
            elevation: 0.0,
            shadowColor: ColorStyles.upFinGray,
          ),
          onPressed: onPressedCallback,
          child: childWidget,
        )
    );
  }

  static SizedBox getAccidentBorderButtonBox(double buttonWidth, Color buttonColor, Color borderColor, Widget childWidget, VoidCallback onPressedCallback){
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 2.w, bottom: 2.w),
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            side: BorderSide(width: 1, color: borderColor),
            elevation: 0.0,
            shadowColor: ColorStyles.upFinGray,
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
            shadowColor: ColorStyles.upFinGray,
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
            shadowColor: ColorStyles.upFinGray,
          ),
          onPressed: onPressedCallback,
          child: childWidget,
        )
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide(width: 1.3, color: borderColor),
            elevation: 0.0,
            shadowColor: ColorStyles.upFinGray,
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
            side: BorderSide(width: 1.3, color: borderColor),
            elevation: 0.0,
            shadowColor: ColorStyles.upFinGray,
          ),
          onPressed: onPressedCallback,
          child: childWidget,
        )
    );
  }

  static Widget getCountCircleBox(double circleBoxSize, int messageCount, double fontSize, FontWeight fontWeight, Color textColor, TextAlign textAlign, int textMaxLine){
    return Stack(
      alignment: Alignment.center,
      children: [Container(
          width: circleBoxSize,
          height: circleBoxSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: ColorStyles.upFinRed, // 빨간색 배경
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
    return Expanded(child: SingleChildScrollView(scrollDirection: scrollDir, physics: const BouncingScrollPhysics(), child: scrollChildView));
  }

  static Widget getExpandedScrollViewFit(Axis scrollDir, Widget scrollChildView){
    return Flexible(child: SingleChildScrollView(scrollDirection: scrollDir, physics: const BouncingScrollPhysics(), child: scrollChildView));
  }

  static Widget getExpandedScrollViewFit2(Axis scrollDir, Widget scrollChildView, ScrollController controller){
    return Flexible(fit: FlexFit.tight, child: SingleChildScrollView(controller: controller, scrollDirection: scrollDir, physics: const BouncingScrollPhysics(), child: scrollChildView));
  }

  static Widget getExpandedScrollViewWithController(Axis scrollDir, Widget scrollChildView, ScrollController controller){
    return Expanded(child: SingleChildScrollView(controller: controller, scrollDirection: scrollDir, physics: const BouncingScrollPhysics(), child: scrollChildView));
  }

  static Widget getExpandedScrollViewWithControllerFlex(Axis scrollDir, Widget scrollChildView, ScrollController controller){
    return Expanded(flex:2, child: SingleChildScrollView(controller: controller, scrollDirection: scrollDir, physics: const BouncingScrollPhysics(), child: scrollChildView));
  }

  static Widget getDisabledTextField(double width, String initText, TextStyle textStyle, InputDecoration inputDecoration){
    return SizedBox(width: width, child: TextFormField(initialValue: initText, enabled: false,
        decoration: inputDecoration, style: textStyle));
  }

  static Widget getTextField(double width, TextStyle textStyle, FocusNode focusNode, TextEditingController textEditingController, TextInputType textInputType,
      InputDecoration inputDecoration, ValueChanged<String> onChangedCallback){
    return SizedBox(width: width,
        child: TextField(focusNode: focusNode, cursorColor: ColorStyles.upFinBlack, controller: textEditingController,
            keyboardType: textInputType, decoration: inputDecoration, onChanged: onChangedCallback, style: textStyle));
  }

  static Widget getChatTextField(double width, TextStyle textStyle, FocusNode focusNode, TextEditingController textEditingController, TextInputType textInputType,
      InputDecoration inputDecoration, ValueChanged<String> onChangedCallback){
    return SizedBox(width: width,
        child: TextField(maxLines: null, focusNode: focusNode, cursorColor: ColorStyles.upFinBlack, controller: textEditingController,
            keyboardType: textInputType, decoration: inputDecoration, onChanged: onChangedCallback, style: textStyle));
  }

  static Widget getTextFormField(double width, TextStyle textStyle, FocusNode focusNode, TextEditingController textEditingController, TextInputType textInputType, bool isPwd,
      InputDecoration inputDecoration, ValueChanged<String> onChangedCallback, FormFieldValidator<String> validatorCallback){
    return SizedBox(width: width,
        child: TextFormField(focusNode: focusNode, obscureText : isPwd, cursorColor: ColorStyles.upFinBlack, controller: textEditingController,
            keyboardType: textInputType, decoration: inputDecoration, onChanged: onChangedCallback, validator: validatorCallback, style: textStyle));
  }

  static InputDecoration getInputDecoration(String labelText, double labelTextSize, String counterText, double counterTextSize){
    return InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(decoration: TextDecoration.none, height: 1.1, fontFamily: "SpoqaHanSansNeo", color: ColorStyles.upFinTextAndBorderBlue, fontSize: labelTextSize, fontWeight: FontWeight.w500),
        hintText: "",
        counterText: counterText,
        errorStyle: TextStyle(fontSize: 0.sp),
        counterStyle: TextStyle(decoration: TextDecoration.none, height: 1.1, fontFamily: "SpoqaHanSansNeo", color: ColorStyles.upFinTextAndBorderBlue, fontSize: counterTextSize, fontWeight: FontWeight.w500),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.upFinButtonBlue)),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: ColorStyles.upFinButtonBlue),
        ),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColorStyles.upFinRed)),
        filled: true,
        fillColor: ColorStyles.upFinWhite
    );
  }

  static InputDecoration getInputDecorationForPrice(String labelText, double labelTextSize, String counterText){
    return InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(decoration: TextDecoration.none, height: 1.1, fontFamily: "SpoqaHanSansNeo", color: ColorStyles.upFinTextAndBorderBlue, fontSize: labelTextSize, fontWeight: FontWeight.w500),
        hintText: "",
        counterText: counterText,
        isDense: true,
        suffixIcon: Text("만원  ", style: TextStyles.upFinDisabledTextFormFieldTextStyle),
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        errorStyle: TextStyle(fontSize: 0.sp),
        counterStyle: TextStyle(decoration: TextDecoration.none, height: 2.2, fontFamily: "SpoqaHanSansNeo", color: ColorStyles.upFinTextAndBorderBlue, fontSize: 10.sp, fontWeight: FontWeight.w500),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.upFinButtonBlue)),

        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: ColorStyles.upFinButtonBlue),
        ),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColorStyles.upFinRed)),
        filled: true,
        fillColor: ColorStyles.upFinWhite
    );
  }

  static InputDecoration getInputDecorationForAddress(String labelText, double labelTextSize, Widget iconWidget){
    return InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(decoration: TextDecoration.none, height: 1.1, fontFamily: "SpoqaHanSansNeo", color: ColorStyles.upFinTextAndBorderBlue, fontSize: labelTextSize, fontWeight: FontWeight.w500),
        hintText: "",
        isDense: true,
        suffixIcon: iconWidget,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        errorStyle: TextStyle(fontSize: 0.sp),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.upFinButtonBlue)),

        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: ColorStyles.upFinButtonBlue),
        ),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColorStyles.upFinRed)),
        filled: true,
        fillColor: ColorStyles.upFinWhite
    );
  }

  static InputDecoration getDisabledInputDecoration(String labelText, double labelTextSize, String counterText, double counterTextSize){
    return InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(decoration: TextDecoration.none, height: 1.1, fontFamily: "SpoqaHanSansNeo", color: ColorStyles.upFinRealGray, fontSize: labelTextSize, fontWeight: FontWeight.w500),
        hintText: "",
        counterText: counterText,
        errorStyle: TextStyle(fontSize: 0.sp),
        counterStyle: TextStyle(decoration: TextDecoration.none, height: 1.1, fontFamily: "SpoqaHanSansNeo", color: ColorStyles.upFinRealGray, fontSize: counterTextSize, fontWeight: FontWeight.w500),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.upFinButtonBlue)),
        border: InputBorder.none, // 언더라인 없애기
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: ColorStyles.upFinButtonBlue),
        ),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColorStyles.upFinButtonBlue)),
        filled: true,
        fillColor: ColorStyles.upFinWhite
    );
  }

  static InputDecoration getChatInputDecoration(){
    return InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(fontSize: 0.sp),
        errorStyle: TextStyle(fontSize: 0.sp),
        counterStyle: TextStyle(fontSize: 0.sp),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide: const BorderSide(color: ColorStyles.upFinWhite),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide: const BorderSide(color: ColorStyles.upFinWhite),
        ),
        filled: true,
        fillColor: ColorStyles.upFinWhite
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
                      color: ColorStyles.upFinDarkGrayWithAlpha,
                      child: SpinKitWave(color: ColorStyles.upFinTextAndBorderBlue, size: 15.w)
                  );
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

  static void showPop(BuildContext parentViewContext, Widget Function(BuildContext context, StateSetter setState) createWidgetMethod){
    double popWidth = 66.w;
    showDialog(
      barrierDismissible: false,
      context: parentViewContext,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: ColorStyles.upFinWhite,
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

  static void showAgreePop(BuildContext parentContext, String type, VoidCallback onPressedCallback){
    _resetAgreeInfo();
    _showSlideMenuForAgreePop(parentContext, SlideMenuMoveType.bottomToTop, true, 100.w, 65.h, 0.5, type, onPressedCallback, _makeAgreeWidget);
  }

  static Widget _makeAgreeWidget(String type, BuildContext parentContext, BuildContext thisContext, StateSetter thisSetState, VoidCallback onPressedCallback){
    if(!isInitAgree){
      for(var each in LogfinController.agreeDocsList){
        if(each["type"].toString().contains(type)){
          agreeInfoList.add(each);
        }
      }
      agreeInfoList.sort((a,b)=>int.parse(a["detailType"].toString().split("@")[2]).compareTo(int.parse(b["detailType"].toString().split("@")[2])));
      for(var each in agreeInfoList){
        CommonUtils.log("i", "agree result : "
            "\n${{"type" : each["type"].toString(),
          "\ndetailType" : each["detailType"].toString(),
          "\nisAgree" : each["isAgree"],
          "\nresult" : each["result"].toString()}}"
        );
      }
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
            UiUtils.showLoadingPop(parentContext);
            Map<String, String> urlInfoMap = {
              "url" : url
            };
            await CommonUtils.moveToWithResult(parentContext, AppView.appWebView.value, urlInfoMap);
            if(parentContext.mounted) UiUtils.closeLoadingPop(parentContext);
            return true;
          },
          renderMode: RenderMode.column,
          textStyle: TextStyles.upFinHtmlTextStyle,
        )
      ]);

      bool isAgree = await CommonUtils.moveToWithResult(parentContext, AppView.appAgreeDetailInfoView.value, {"title": titleString, "contents" : htmlWidget}) as bool;
      callback(isAgree);
    }

    Widget getSmallAgreeInfoWidget(String titleString, String contentsString, bool isAgreeCheck, Function(bool isCheck) callAct){
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
            smallAgreePressEvent(parentContext, titleString, contentsString, (agreeResult){
              thisSetState(() {
                callAct(agreeResult);
              });
            });
          }),
          const Spacer(flex: 2),
          UiUtils.getIconButton(Icons.arrow_forward_ios_rounded, 4.w, ColorStyles.upFinRealGray, () {
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
          UiUtils.getTextWithFixedScale(getAgreeTypeTitle(detailType), 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null)
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
            childrenPadding: EdgeInsets.zero,tilePadding: EdgeInsets.zero, iconColor: ColorStyles.upFinBlack,
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
              UiUtils.getCheckBox(1.2, isAllAgree(), (isChanged) {
                thisSetState(() {
                  setAgreeState(isChanged!, true, "");
                });
              }),
              UiUtils.getTextWithFixedScale("전체동의", 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null)
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
          UiUtils.getMarginBox(0, 2.h),
          UiUtils.getExpandedScrollViewWithController(Axis.vertical, Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
            Column(crossAxisAlignment:CrossAxisAlignment.start, children: getAgreeWidgetList()),
          ]), _agreeScrollController),
          UiUtils.getMarginBox(0, 1.5.h),
          isTypeAgree("1") ? UiUtils.getTextButtonBox(90.w, "동의하기", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinButtonBlue, onPressedCallback)
              : UiUtils.getTextButtonBox(90.w, "동의하기", TextStyles.upFinBasicButtonTextStyle, ColorStyles.upFinGray, () {})
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
        checkColor: ColorStyles.upFinWhite,
        activeColor: ColorStyles.upFinSky,
        side: MaterialStateBorderSide.resolveWith((states) =>
         !checkedValue? const BorderSide(width: 2.0, color: ColorStyles.upFinGray) : const BorderSide(width: 2.0, color: ColorStyles.upFinSky))
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
                color: ColorStyles.upFinWhite,
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
      String type, VoidCallback onPressedCallback, Widget Function(String type, BuildContext parentContext, BuildContext thisContext, StateSetter thisSetState, VoidCallback onPressedCallback) createWidgetMethod){
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
                  color: ColorStyles.upFinWhite,
                  borderRadius: borderRadius,
                ),
                child: SizedBox.expand(
                    child: StatefulBuilder(
                        builder: (_, StateSetter popViewSetState){
                          Widget contentsWidget = createWidgetMethod(type, parentViewContext, parentViewContext, popViewSetState, onPressedCallback);
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
                          return Padding(padding: EdgeInsets.only(top: 5.w, left: 5.w, right: 5.w), child: Scaffold(
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
    return Container(width: 100.w, height: 100.h, color: ColorStyles.upFinButtonBlue,
        child: Stack(alignment: Alignment.center, children: [
          Positioned(
              bottom: 0,
              child: UiUtils.getImage(90.w, 90.w, Image.asset(fit: BoxFit.fill,'assets/images/img_man_searcher.png'))),
          Positioned(
              top: 35.h,
              child: UiUtils.getTitleWithFixedScale("upfin", 75.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null))
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