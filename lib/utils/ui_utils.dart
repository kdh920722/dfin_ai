import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../styles/ColorStyles.dart';
import '../styles/TextStyles.dart';
import '../configs/app_config.dart';
import 'common_utils.dart';

class UiUtils {
  static ScreenUtilInit getMainView(BuildContext context, Widget mainView){
    return ScreenUtilInit( // 스크린 사이즈 비율 고정
        designSize: const Size(Config.appWidth, Config.appHeight),
        builder: (context, child) {
          return MaterialApp(
              home: child,
              builder: (context, child) {
                if(!Config.isAppMainInit){
                  Config.appFullSize = CommonUtils.fullSize(context);
                  Config.appRealSize = CommonUtils.safeSize(context);
                  Config.isAppMainInit = true;
                }
                return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: SafeArea(
                        child: child!
                    )
                );
              }
          );
        },
        child: mainView
    );
  }

  static Widget getView(BuildContext context, Widget view, Future<bool> Function(BuildContext? context) callbackBackButtonForView){
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: WillPopScope(
              onWillPop: () => callbackBackButtonForView(context),
              child: SizedBox(width: Config.appRealSize[0], height: Config.appRealSize[1], child: view)
          ),
        )
    );
  }

  static Widget getViewWithScroll(BuildContext context, Widget view, ScrollController scrollController, Future<bool> Function(BuildContext? context) callbackBackButtonForView){
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        scrollController.jumpTo(0);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: WillPopScope(
            onWillPop: () => callbackBackButtonForView(context),
            child: ListView(
                controller: scrollController,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(width: Config.appRealSize[0], height: Config.appRealSize[1], child: view)
                ]
            )
        ),
      )
    );
  }

  static Widget getTextWithUnderline(String text, TextStyle textStyle, Color underlineColor, VoidCallback? onPressedCallback){
    return Column(mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[Container(padding: const EdgeInsets.only(bottom: 3),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: underlineColor, width: 0.5.w))),
          child: GestureDetector(onTap: onPressedCallback, child: Text(text, style: textStyle)))]);
  }

  static SizedBox getMarginBox(double marginHeight, double marginWidth){
    return SizedBox(height: marginHeight, width: marginWidth);
  }

  static SizedBox getIconTextButtonBox(double buttonWidth, IconData icon, String buttonText, Color buttonColor, VoidCallback onPressedCallback) {
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
            elevation: 3,
            shadowColor: Colors.grey,
          ),
          icon: Icon(icon, color: ColorStyles.finAppWhite, size: 25.sp,),
          label: Text(buttonText, style: TextStyle(color: ColorStyles.finAppWhite, fontSize: 18.sp, fontWeight: FontWeight.bold)),
          onPressed: onPressedCallback,
        )
    );
  }

  static SizedBox getIconButtonBox(double buttonWidth, IconData icon, String buttonText, Color buttonColor, VoidCallback onPressedCallback) {
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
            elevation: 3,
            shadowColor: Colors.grey,
          ),
          onPressed: onPressedCallback,
          child: Icon(icon, color: ColorStyles.finAppWhite, size: 25.sp)
        )
    );
  }

  static SizedBox getTextButtonBox(double buttonWidth, String buttonText, Color buttonColor, VoidCallback onPressedCallback) {
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
            elevation: 3,
            shadowColor: Colors.grey,
          ),
          onPressed: onPressedCallback,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(buttonText, style: TextStyles.buttonTextStyle, textAlign: TextAlign.center),
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
            child: Text(buttonText, style: TextStyles.countDownButtonStyle, textAlign: TextAlign.center),
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
              child: Text(buttonText, style: TextStyles.buttonTextStyle, textAlign: TextAlign.center),
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
              child: Text(buttonText, style: TextStyles.buttonTextStyle, textAlign: TextAlign.center),
            ),
          )
      );
    }
  }

  static Text getTitle(String titleText){
    return Text(titleText, style: TextStyles.titleTextStyle, textAlign: TextAlign.start);
  }

  static Text getSubTitle(String titleText){
    return Text(titleText, style: TextStyles.subTitleTextStyle, textAlign: TextAlign.start);
  }

  static InputDecoration getInputDecorationWithNoErrorMessage(String labelText){
    return InputDecoration(labelText: labelText, hintText: "", counterText: "",
        labelStyle: TextStyles.labelTextStyle,
        border : OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: ColorStyles.darkGray,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: ColorStyles.finAppGreen,
          ),
        ),
        errorStyle: const TextStyle(height: 0),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
        filled: true,
        fillColor: ColorStyles.finAppWhite
    );
  }

  static bool isLoadingPopOn = false;
  static void showLoadingPop(BuildContext targetContext){
    if(!isLoadingPopOn){
      showGeneralDialog(
        barrierDismissible: false,
        context: targetContext,
        pageBuilder: (context, animation, secondaryAnimation) {
          return StatefulBuilder(// You need this, notice the parameters below:
              builder: (BuildContext context, StateSetter setState) {
                isLoadingPopOn = true;
                return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: ColorStyles.darkGrayWithAlpha,
                    child: SpinKitCubeGrid(color: ColorStyles.finAppGreen, size: 50.w)
                );
              });
        },
      );
    }
  }

  static void closeLoadingPop(BuildContext targetContext){
    isLoadingPopOn = false;
    Navigator.pop(targetContext);
  }

  static void showPop(BuildContext parentViewContext, Widget Function(BuildContext context, StateSetter setState) createWidgetMethod){
    double popWidth = Config.appFullSize[0]*(2/3);

    showDialog(
      barrierDismissible: false,
      context: parentViewContext,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          backgroundColor: ColorStyles.finAppWhite,
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

  static void showSlideMenu(BuildContext parentViewContext, SlideType slideType, Widget Function(BuildContext context, StateSetter setState) createWidgetMethod){
    double popWidth = Config.appFullSize[0]*(2/3);
    double popHeight = Config.appFullSize[1]*(1/3);
    BorderRadius borderRadius = BorderRadius.circular(30.r);
    Alignment alignment = Alignment.bottomCenter;

    showGeneralDialog(
      barrierLabel: "Slide Menu",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: parentViewContext,
      pageBuilder: (context, anim1, anim2) {
        switch (slideType) {
          case SlideType.toRight:
            popHeight = double.infinity;
            alignment = Alignment.centerLeft;
            borderRadius = BorderRadius.only(topRight: Radius.circular(30.r), bottomRight: Radius.circular(30.r));
            break;
          case SlideType.toLeft:
            popHeight = double.infinity;
            alignment = Alignment.centerRight;
            borderRadius = BorderRadius.only(topLeft: Radius.circular(30.r), bottomLeft: Radius.circular(30.r));
            break;
          case SlideType.toTop:
            popWidth = double.infinity;
            alignment = Alignment.bottomCenter;
            borderRadius = BorderRadius.only(topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r));
            break;
          case SlideType.toBottom:
            popWidth = double.infinity;
            popHeight = 300.h;
            alignment = Alignment.topCenter;
            borderRadius = BorderRadius.only(bottomLeft: Radius.circular(30.r), bottomRight: Radius.circular(30.r));
            break;
          default:
            popWidth = double.infinity;
            alignment = Alignment.bottomCenter;
            borderRadius = BorderRadius.only(topLeft: Radius.circular(30.r), bottomLeft: Radius.circular(30.r));
        }

        return Align(
          alignment: alignment,
          child: Container(
            width: popWidth,
            height: popHeight,
            child: SizedBox.expand(
                child: StatefulBuilder(
                    builder: (_, StateSetter popViewSetState){
                      Widget contentsWidget = createWidgetMethod(parentViewContext, popViewSetState);
                      return Padding(padding: const EdgeInsets.all(15.0), child: contentsWidget);
                    }
                )
            ),
            decoration: BoxDecoration(
              color: ColorStyles.finAppWhite,
              borderRadius: borderRadius,
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        switch (slideType) {
          case SlideType.toLeft:
            return SlideTransition(
              position: Tween(begin: Offset(1, 0), end: Offset(0,0)).animate(anim1),
              child: child,
            );
          case SlideType.toRight:
            return SlideTransition(
              position: Tween(begin: Offset(-1, 0), end: Offset(0,0)).animate(anim1),
              child: child,
            );
          case SlideType.toTop:
            return SlideTransition(
              position: Tween(begin: Offset(0, 1), end: Offset(0,0)).animate(anim1),
              child: child,
            );
          case SlideType.toBottom:
            return SlideTransition(
              position: Tween(begin: Offset(0, -1), end: Offset(0,0)).animate(anim1),
              child: child,
            );
          default:
            return SlideTransition(
              position: Tween(begin: Offset(1, 0), end: Offset(0,0)).animate(anim1),
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
          padding: EdgeInsets.all(20),
          child: FloatingActionButton.extended(
            label: Text(text!),
            icon: Icon(icon),
            backgroundColor: fabColor,
            onPressed: onPressedCallback,
          )
      )
    );
  }

}