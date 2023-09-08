import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'ColorStyles.dart';

class TextStyles {
  static TextStyle upFinInitTextStyle = TextStyle(fontFamily: "SpoqaHanSansNeo", fontSize: 22.sp, color: ColorStyles.upFinTextAndBorderBlue, fontWeight: FontWeight.bold, decoration: TextDecoration.none, decorationThickness: 0.0, height: 1);
  static TextStyle upFinBasicTextStyle = TextStyle(fontFamily: "SpoqaHanSansNeo", fontSize: 13.sp, color: ColorStyles.upFinTextAndBorderBlue, fontWeight: FontWeight.bold, decoration: TextDecoration.none, decorationThickness: 0.0, height: 1);
  static TextStyle upFinSkyTextInButtonStyle = TextStyle(fontFamily: "SpoqaHanSansNeo", fontSize: 15.sp, color: ColorStyles.upFinTextAndBorderBlue, fontWeight: FontWeight.w500, decoration: TextDecoration.none, decorationThickness: 0.0, height: 1);
  static TextStyle upFinBasicButtonTextStyle = TextStyle(fontFamily: "SpoqaHanSansNeo", fontSize: 15.sp, color: ColorStyles.upFinWhite, fontWeight: FontWeight.w500, decoration: TextDecoration.none, decorationThickness: 0.0, height: 1);
  static TextStyle upFinSmallButtonTextStyle = TextStyle(fontFamily: "SpoqaHanSansNeo", fontSize: 12.sp, color: ColorStyles.upFinWhite, fontWeight: FontWeight.w500, decoration: TextDecoration.none, decorationThickness: 0.0, height: 1);
  static TextStyle upFinKakaoButtonTextStyle = TextStyle(fontFamily: "SpoqaHanSansNeo", fontSize: 15.sp, color: ColorStyles.upFinBlack, fontWeight: FontWeight.w700, decoration: TextDecoration.none, decorationThickness: 0.0, height: 1);
  static TextStyle upFinAppleButtonTextStyle = TextStyle(fontFamily: "SpoqaHanSansNeo", fontSize: 15.sp, color: ColorStyles.upFinWhite, fontWeight: FontWeight.w700, decoration: TextDecoration.none, decorationThickness: 0.0, height: 1);
  static TextStyle upFinTextFormFieldTextStyle = TextStyle(fontFamily: "SpoqaHanSansNeo", fontSize: 13.sp, color: ColorStyles.upFinBlack, fontWeight: FontWeight.w300, decoration: TextDecoration.none, decorationThickness: 0.0, height: 1.5);
  static TextStyle upFinDisabledTextFormFieldTextStyle = TextStyle(fontFamily: "SpoqaHanSansNeo", fontSize: 13.sp, color: ColorStyles.upFinRealGray, fontWeight: FontWeight.w600, decoration: TextDecoration.none, decorationThickness: 0.0, height: 1.5);


  static TextStyle titleTextStyle = TextStyle(fontSize: 22.sp, color: Colors.black54, fontWeight: FontWeight.bold, decoration: TextDecoration.none, decorationThickness: 0.0);
  static TextStyle popTitleTextStyle = TextStyle(fontSize: 22.sp, color: Colors.black87, fontWeight: FontWeight.bold, decoration: TextDecoration.none, decorationThickness: 0.0);
  static TextStyle popSubUnderTextStyle = TextStyle(fontSize: 14.sp, color: Colors.black26, fontWeight: FontWeight.normal, decoration: TextDecoration.none, decorationThickness: 0.0);
  static TextStyle subTitleTextStyle = TextStyle(fontSize: 10.sp, color: ColorStyles.finAppGray4, fontWeight: FontWeight.normal, decoration: TextDecoration.none, decorationThickness: 0.0);
  static TextStyle slidePopPermissionText = TextStyle(fontSize: 14.sp, color: ColorStyles.finAppGray4, fontWeight: FontWeight.bold, decoration: TextDecoration.none, decorationThickness: 0.0);
  static TextStyle slidePopButtonText = TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.normal, decoration: TextDecoration.none, decorationThickness: 0.0);
  static TextStyle buttonTextStyle = TextStyle(fontSize: 20.sp, color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.none, decorationThickness: 0.0);
  static TextStyle basicTextStyleBold = TextStyle(fontSize: 22.sp, color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.none, decorationThickness: 0.0);
  static TextStyle basicTextStyle = TextStyle(fontSize: 10.sp, color: Colors.black, fontWeight: FontWeight.normal, decoration: TextDecoration.none, decorationThickness: 0.0);
  static TextStyle dropDownTextStyle = TextStyle(fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.normal, decoration: TextDecoration.none, decorationThickness: 0.0);

  static TextStyle closeTextStyle = TextStyle(fontSize: 20.sp, color: Colors.black26, fontWeight: FontWeight.bold, decoration: TextDecoration.none, decorationThickness: 0.0);
  static TextStyle countDownTextStyle = TextStyle(fontSize: 18.sp, color: ColorStyles.finAppGreen, fontWeight: FontWeight.normal, decoration: TextDecoration.none, decorationThickness: 0.0);
  static TextStyle countDownButtonStyle = TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.none, decorationThickness: 0.0);
  static TextStyle finishPopTitleStyle = TextStyle(fontSize: 18.sp, color: ColorStyles.finAppGray4, fontWeight: FontWeight.bold, decoration: TextDecoration.none, decorationThickness: 0.0);
  static TextStyle finishPopContentsStyle = TextStyle(fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.none, decorationThickness: 0.0);
  static TextStyle finishPopButtonTextStyle = TextStyle(fontSize: 16.sp, color: ColorStyles.finAppGreen, fontWeight: FontWeight.bold, decoration: TextDecoration.none, decorationThickness: 0.0);


  static TextStyle popSubTitleTextStyleSelected(bool isSelected){
    if(!isSelected) {
      return TextStyle(fontSize: 18.sp, color: ColorStyles.finAppGray4, fontWeight: FontWeight.normal, decoration: TextDecoration.none, decorationThickness: 0.0);
    } else {
      return TextStyle(fontSize: 18.sp, color: ColorStyles.finAppGreen, fontWeight: FontWeight.normal, decoration: TextDecoration.none, decorationThickness: 0.0);
    }
  }
// ...
}