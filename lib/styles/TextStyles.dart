import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ColorStyles.dart';

class TextStyles {
  static TextStyle titleTextStyle = TextStyle(fontSize: 22.sp, color: Colors.black54, fontWeight: FontWeight.bold);
  static TextStyle popTitleTextStyle = TextStyle(fontSize: 22.sp, color: Colors.black87, fontWeight: FontWeight.bold);
  static TextStyle popSubUnderTextStyle = TextStyle(fontSize: 14.sp, color: Colors.black26, fontWeight: FontWeight.normal);
  static TextStyle subTitleTextStyle = TextStyle(fontSize: 16.sp, color: ColorStyles.finAppGray4, fontWeight: FontWeight.bold, decoration: TextDecoration.none, decorationThickness: 0.0);
  static TextStyle buttonTextStyle = TextStyle(fontSize: 20.sp, color: Colors.white, fontWeight: FontWeight.bold);
  static TextStyle basicTextStyleBold = TextStyle(fontSize: 22.sp, color: Colors.black, fontWeight: FontWeight.bold);
  static TextStyle basicTextStyle = TextStyle(fontSize: 14.sp, color: Colors.black, fontWeight: FontWeight.normal);
  static TextStyle dropDownTextStyle = TextStyle(fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.normal);
  static TextStyle labelTextStyle = TextStyle(fontSize: 20.sp, color: Colors.black45, fontWeight: FontWeight.normal);
  static TextStyle closeTextStyle = TextStyle(fontSize: 20.sp, color: Colors.black26, fontWeight: FontWeight.bold);
  static TextStyle countDownTextStyle = TextStyle(fontSize: 18.sp, color: ColorStyles.finAppGreen, fontWeight: FontWeight.normal);
  static TextStyle countDownButtonStyle = TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold);
  static TextStyle finishPopTitleStyle = TextStyle(fontSize: 18.sp, color: ColorStyles.finAppGray4, fontWeight: FontWeight.bold);
  static TextStyle finishPopContentsStyle = TextStyle(fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.bold);
  static TextStyle finishPopButtonTextStyle = TextStyle(fontSize: 16.sp, color: ColorStyles.finAppGreen, fontWeight: FontWeight.bold);


  static TextStyle popSubTitleTextStyleSelected(bool isSelected){
    if(!isSelected) {
      return TextStyle(fontSize: 18.sp, color: ColorStyles.finAppGray4, fontWeight: FontWeight.normal);
    } else {
      return TextStyle(fontSize: 18.sp, color: ColorStyles.finAppGreen, fontWeight: FontWeight.normal);
    }
  }
// ...
}