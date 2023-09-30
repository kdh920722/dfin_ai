import 'package:flutter/gestures.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
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
                  backgroundColor: Colors.black,
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
                  backgroundColor: Colors.black,
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
                  backgroundColor: Colors.black,
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
                    backgroundColor: Colors.black,
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

  static Text getTextWithFixedScaleAndOverFlow(String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign? textAlign, int? textMaxLine){
    return Text(overflow: TextOverflow.ellipsis, text, style: TextStyle(decoration: TextDecoration.none, height: 1.1, fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor), textScaleFactor: 1.0, textAlign: textAlign, maxLines: textMaxLine);
  }

  static Widget getTextButtonWithFixedScale(String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign? textAlign, int? textMaxLine, Function() onPressedCallback){
    return GestureDetector(onTap: onPressedCallback, child : UiUtils.getTextWithFixedScale(text, fontSize, fontWeight, textColor, textAlign, null));
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

  static Widget getBoxTextWithFixedScale(String text, double fontSize, FontWeight fontWeight, TextAlign? textAlign, Color boxColor, Color textColor){
    return Container(color: boxColor, child: FittedBox(fit: BoxFit.contain, alignment: Alignment.center,
    child: Padding(padding: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 1.w, top: 1.w), child: Text(text, style: TextStyle(fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor)))));
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
    return SizedBox(width: marginWidth, height: marginHeight,);
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
    return SizedBox(height: height,child: IconButton(onPressed: onPressedCallback, icon: Icon(icon, color: iconColor, size: size)));
  }

  static Widget getIconButtonWithBoxSize(Color backgroundColor, double width, double height, IconData icon, double size, Color iconColor, VoidCallback onPressedCallback) {
    return Container(color: backgroundColor, width: width, height: height,child: IconButton(onPressed: onPressedCallback, icon: Icon(icon, color: iconColor, size: size)));
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
            padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 4.w, bottom: 4.w),
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
        getTextWithFixedScale(messageCount.toString(), fontSize, fontWeight, textColor, textAlign, textMaxLine)
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

  static Widget getExpandedScrollViewWithController(Axis scrollDir, Widget scrollChildView, ScrollController controller){
    return Expanded(child: SingleChildScrollView(controller: controller, scrollDirection: scrollDir, physics: const BouncingScrollPhysics(), child: scrollChildView));
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

  static bool isLoadingPopOn = false;
  static void showLoadingPop(BuildContext targetContext){
    if(!isLoadingPopOn){
      showGeneralDialog(
        barrierDismissible: false,
        context: targetContext,
        pageBuilder: (context, animation, secondaryAnimation) {
          return WillPopScope(
            onWillPop: () async => false,
            child: StatefulBuilder(// You need this, notice the parameters below:
                builder: (_, StateSetter setState) {
                  isLoadingPopOn = true;
                  return Container(
                      width: 100.w,
                      height: 100.h,
                      color: ColorStyles.upFinDarkGrayWithAlpha,
                      child: SpinKitWave(color: ColorStyles.upFinTextAndBorderBlue, size: 25.w)
                  );
                })
          );
        },
      );
    }
  }

  static void closeLoadingPop(BuildContext targetContext){
    if(isLoadingPopOn){
      isLoadingPopOn = false;
      Navigator.pop(targetContext);
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

  static Widget getRowColumnWithAlignCenter(List<Widget> viewList){
    return Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [Column(crossAxisAlignment: CrossAxisAlignment.center, children: viewList)]);
  }

  static Widget getCircleCheckBox(double size, bool checkedValue, Function(bool?) onChanged){
    return Transform.scale(scale: size, child: Checkbox(
        value: checkedValue,
        onChanged: onChanged,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        checkColor: ColorStyles.upFinWhite,
        activeColor: ColorStyles.upFinSky,
        side: MaterialStateBorderSide.resolveWith((states) =>
         !checkedValue? const BorderSide(width: 2.0, color: ColorStyles.upFinGray) : const BorderSide(width: 2.0, color: ColorStyles.upFinSky))
    ));
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

  static void showSlideMenu(BuildContext parentViewContext, SlideType slideType, bool isDismissible,
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
          case SlideType.leftToRight:
            popHeight = 100.h;
            alignment = Alignment.centerLeft;
            borderRadius = const BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30));
            break;
          case SlideType.rightToLeft:
            popHeight = 100.h;
            alignment = Alignment.centerRight;
            borderRadius = const BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30));
            break;
          case SlideType.bottomToTop:
            popWidth = 100.w;
            alignment = Alignment.bottomCenter;
            borderRadius = const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30));
            break;
          case SlideType.topToBottom:
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
          case SlideType.rightToLeft:
            return SlideTransition(
              position: Tween(begin: const Offset(1, 0), end: const Offset(0,0)).animate(anim1),
              child: child,
            );
          case SlideType.leftToRight:
            return SlideTransition(
              position: Tween(begin: const Offset(-1, 0), end: const Offset(0,0)).animate(anim1),
              child: child,
            );
          case SlideType.bottomToTop:
            return SlideTransition(
              position: Tween(begin: const Offset(0, 1), end: const Offset(0,0)).animate(anim1),
              child: child,
            );
          case SlideType.topToBottom:
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