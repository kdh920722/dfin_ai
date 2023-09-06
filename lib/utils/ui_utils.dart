import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../configs/text_config.dart';
import '../styles/ColorStyles.dart';
import '../styles/TextStyles.dart';
import '../configs/app_config.dart';
import 'common_utils.dart';

class UiUtils {
  static Widget startAppView(){
    return Sizer(
      builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
        return MaterialApp(
          theme: ThemeData(useMaterial3: true),
          initialRoute: AppView.rootView.value,
          routes: Config.appRoutes
        );
      },
    );
  }


  static Widget getView(BuildContext context, Widget view, Future<bool> Function(BuildContext? context) callbackBackButtonForView){
    return GestureDetector(
        onTap: () {
          CommonUtils.hideKeyBoard(context);
        },
        child: SafeArea(
            child: WillPopScope(
                onWillPop: () => callbackBackButtonForView(context),
                child: Scaffold(
                  backgroundColor: Colors.black,
                  body: view,
                )
            )
        )
    );
  }

  static Widget getViewWithScroll(BuildContext context, Widget view, ScrollController scrollController, Future<bool> Function(BuildContext? context) callbackBackButtonForView){
    return GestureDetector(
      onTap: () {
        CommonUtils.hideKeyBoard(context);
        scrollController.jumpTo(0);
      },
      child: SafeArea(
          child: WillPopScope(
              onWillPop: () => callbackBackButtonForView(context),
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

  static Text getStyledTextWithFixedScale(String text, TextStyle textStyle, TextAlign? textAlign, int? textMaxLine){
    return Text(text, style: textStyle,  textScaleFactor: 1.0, textAlign: textAlign, maxLines: textMaxLine);
  }

  static Text getTextWithFixedScale(String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign? textAlign, int? textMaxLine){
    return Text(text, style: TextStyle(decoration: TextDecoration.none, height: 1.1, fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor), textScaleFactor: 1.0, textAlign: textAlign, maxLines: textMaxLine);
  }

  static Widget getTextStyledButtonWithFixedScale(String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign? textAlign, int? textMaxLine, Function() onPressedCallback){
    return TextButton(
      onPressed: onPressedCallback,
      child: getTextWithFixedScale(text, fontSize, fontWeight, textColor, textAlign, textMaxLine)
    );
  }

  static Widget getTextWithIconStyledButtonWithFixedScale(TextDirection textDirection, String text, double fontSize, FontWeight fontWeight, Color textColor, TextAlign? textAlign, int? textMaxLine,
      IconData icon, double iconSize, Color iconColor, Function() onPressedCallback){
    return Directionality(textDirection: textDirection, child: TextButton.icon(onPressed: onPressedCallback, icon: Icon(icon, color: iconColor, size: iconSize),
        label: getTextWithFixedScale(text, fontSize, fontWeight, textColor, textAlign, textMaxLine)));
  }

  static Widget getBorderTextWithFixedScale(String text, double fontSize, FontWeight fontWeight, TextAlign? textAlign, Color borderColor, Color textColor){
    return Container(padding: const EdgeInsets.all(0.2), // 텍스트 주위에 여백 추가
      decoration: BoxDecoration(border: Border.all(color: borderColor, width: 2.0), borderRadius: BorderRadius.circular(2.0)),
      child: Text(text, style: TextStyle(decoration: TextDecoration.none, height: 1, fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor)));
  }

  static Widget getBoxTextWithFixedScale(String text, double fontSize, FontWeight fontWeight, TextAlign? textAlign, Color boxColor, Color textColor){
    return Container(color: boxColor, child: FittedBox(fit: BoxFit.contain, alignment: Alignment.center,
    child: Padding(padding: const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 2.0, top: 2.0), child: Text(text, style: TextStyle(fontFamily: "SpoqaHanSansNeo", fontWeight: fontWeight, fontSize: fontSize, color: textColor)))));
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
      children: <Widget>[Container(padding: const EdgeInsets.only(bottom: 3),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: underlineColor, width: 0.5.w))),
          child: GestureDetector(onTap: onPressedCallback, child: getStyledTextWithFixedScale(text,textStyle,null,null)))]);
  }

  static SizedBox getMarginBox(double marginWidth, double marginHeight){
    return SizedBox(width: marginWidth, height: marginHeight,);
  }

  static SizedBox getIconInTextButtonBox(double buttonWidth, IconData icon, String buttonText, TextStyle buttonTextStyles, Color buttonColor, VoidCallback onPressedCallback) {
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 5,
            shadowColor: Colors.grey,
          ),
          icon: Icon(icon, color: ColorStyles.upFinWhite, size: 25.sp),
          label: getStyledTextWithFixedScale(buttonText,buttonTextStyles,null,null),
          onPressed: onPressedCallback,
        )
    );
  }

  static SizedBox getIconInButtonBox(double buttonWidth, IconData icon, Color buttonColor, VoidCallback onPressedCallback) {
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 5,
            shadowColor: Colors.grey,
          ),
          onPressed: onPressedCallback,
          child: Icon(icon, color: ColorStyles.upFinWhite, size: 16.sp)
        )
    );
  }

  static Widget getIconButton(IconData icon, double size, Color iconColor, VoidCallback onPressedCallback) {
    return SizedBox(child: IconButton(onPressed: onPressedCallback, icon: Icon(icon, color: iconColor, size: size)));
  }

  static SizedBox getTextButtonBox(double buttonWidth, String buttonText, TextStyle buttonTextStyles, Color buttonColor, VoidCallback onPressedCallback) {
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
            padding: const EdgeInsets.all(15.0),
            child: getStyledTextWithFixedScale(buttonText,buttonTextStyles,TextAlign.center,null)
          ),
        )
    );
  }

  static SizedBox getTextCustomPaddingButtonBox(double buttonWidth, String buttonText, TextStyle buttonTextStyles,
      EdgeInsets edgeInsets, Color buttonColor, VoidCallback onPressedCallback) {
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
              padding: edgeInsets,
              child: getStyledTextWithFixedScale(buttonText,buttonTextStyles,TextAlign.center,null)
          ),
        )
    );
  }

  static SizedBox getCountDownButtonBox(double buttonWidth, String buttonText, Color buttonColor, VoidCallback onPressedCallback) {
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0.0),
            backgroundColor: MaterialStateProperty.all(buttonColor),
          ),
          onPressed: onPressedCallback,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: getStyledTextWithFixedScale(buttonText,TextStyles.countDownButtonStyle,TextAlign.center,null)
          ),
        )
    );
  }

  static SizedBox getActiveButtonBox(double buttonWidth, String buttonText, bool isActive, Color activeButtonColor, Color inactiveButtonColor, VoidCallback onPressedCallback) {
    if(isActive){
      return SizedBox(
          width: buttonWidth,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(activeButtonColor),
            ),
            onPressed: onPressedCallback,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: getStyledTextWithFixedScale(buttonText, TextStyles.buttonTextStyle, TextAlign.center, null)
            ),
          )
      );
    }else{
      return SizedBox(
          width: buttonWidth,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(inactiveButtonColor),
            ),
            onPressed: () { },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: getStyledTextWithFixedScale(buttonText, TextStyles.buttonTextStyle, TextAlign.center, null)
            ),
          )
      );
    }
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

  static Text getTitle(String titleText){
    return getStyledTextWithFixedScale(titleText, TextStyles.titleTextStyle, TextAlign.start, null);
  }

  static Text getSubTitle(String titleText){
    return getStyledTextWithFixedScale(titleText, TextStyles.subTitleTextStyle, TextAlign.start, null);
  }

  static Widget getEnabledTextField(double width, String initText, InputDecoration inputDecoration){
    return SizedBox(width: width, child: TextFormField(initialValue: initText, enabled: false, decoration: inputDecoration));
  }

  static Widget getTextField(double width, TextEditingController textEditingController, TextInputType textInputType,
      InputDecoration inputDecoration, ValueChanged<String> onChangedCallback){
    return SizedBox(width: width,
        child: TextField(cursorColor: ColorStyles.upFinBlack, controller: textEditingController, keyboardType: textInputType, decoration: inputDecoration, onChanged: onChangedCallback));
  }

  static Widget getTextFormField(double width, TextEditingController textEditingController, TextInputType textInputType, bool isPwd, InputDecoration inputDecoration,
      ValueChanged<String> onChangedCallback, FormFieldValidator<String> validatorCallback){
    return SizedBox(width: width, child: TextFormField(obscureText : isPwd, cursorColor: ColorStyles.upFinBlack, controller: textEditingController, keyboardType: textInputType, decoration: inputDecoration,
            onChanged: onChangedCallback, validator: validatorCallback));
  }

  static InputDecoration getInputDecoration(String labelText, String counterText){
    return InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(color: ColorStyles.upFinTextAndBorderBlue),
        hintText: "",
        counterText: counterText,
        errorStyle: TextStyle(fontSize: 0.sp),
        counterStyle: const TextStyle(color: ColorStyles.upFinTextAndBorderBlue),
        hintStyle: TextStyles.upFinTextFormFieldLabelTextStyle,
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColorStyles.upFinButtonBlue)),
        border: const UnderlineInputBorder(borderSide: BorderSide(color: ColorStyles.upFinButtonBlue)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColorStyles.upFinTextAndBorderBlue)),
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
                builder: (BuildContext context, StateSetter setState) {
                  isLoadingPopOn = true;
                  return Container(
                      width: 100.w,
                      height: 100.h,
                      color: ColorStyles.darkGrayWithAlpha,
                      child: SpinKitCubeGrid(color: ColorStyles.upFinTextAndBorderBlue, size: 25.w)
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
          insetPadding: const EdgeInsets.all(10),
          child: StatefulBuilder(
            builder: (__, StateSetter popViewSetState){
              Widget contentsWidget = createWidgetMethod(parentViewContext, popViewSetState);
              return SizedBox(
                  width: popWidth,
                  child: Padding(padding: const EdgeInsets.all(15.0), child: contentsWidget));
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

  static Widget getCircleCheckBox(StateSetter setState, double size, bool checkedValue, Function(bool?) onChanged){
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
      popHeight = 3.w;
    }else{
      popHeight = height;
    }

    BorderRadius borderRadius = BorderRadius.circular(30);
    Alignment alignment = Alignment.bottomCenter;

    showGeneralDialog(
      barrierLabel: "Slide Menu",
      barrierDismissible: isDismissible,
      barrierColor: Colors.black.withOpacity(opacity),
      transitionDuration: const Duration(milliseconds: 500),
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
          onWillPop: () async => false,
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
                        return Padding(padding: const EdgeInsets.all(20.0), child: contentsWidget);
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
          padding: const EdgeInsets.all(20),
          child: FloatingActionButton.extended(
            label: Text(text!),
            icon: Icon(icon),
            backgroundColor: fabColor,
            onPressed: onPressedCallback,
          )
      )
    );
  }

  static Widget getInitLoadingView() {
    return Container();
  }


}