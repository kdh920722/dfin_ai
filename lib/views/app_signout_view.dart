import 'package:upfin/configs/string_config.dart';
import 'package:upfin/controllers/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/controllers/iamport_controller.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import '../controllers/sharedpreference_controller.dart';
import '../styles/TextStyles.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class AppSignOutView extends StatefulWidget{
  @override
  AppSignOutViewState createState() => AppSignOutViewState();
}

class AppSignOutViewState extends State<AppSignOutView> with WidgetsBindingObserver{
  final ScrollController _scrollController = ScrollController();
  final _pwdTextController = TextEditingController();
  final _pwdTextFocus = FocusNode();

  void _unFocusAllNodes(){
    _pwdTextFocus.unfocus();
  }

  void _disposeAllTextControllers(){
    _pwdTextController.dispose();
  }

  KeyboardVisibilityController? _keyboardVisibilityController;
  void _functionForKeyboardHide(){
    CommonUtils.hideKeyBoard();
    _scrollController.jumpTo(0);
  }
  void _functionForKeyboardShow(){
  }

  @override
  void initState(){
    CommonUtils.log("i", "AppSignOutViewState 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppSignOutViewState 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _unFocusAllNodes();
    _disposeAllTextControllers();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('i','AppSignOutView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('i','AppSignOutView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('i','AppSignOutView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('i','AppSignOutView paused');
        break;
      default:
        break;
    }
  }


  void back(){
    CommonUtils.hideKeyBoard();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Container(
        color: ColorStyles.upFinWhite,
        width: 100.w,
        height: 95.h,
        padding: EdgeInsets.all(5.w),
        child: UiUtils.getRowColumnWithAlignCenter([
          SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            UiUtils.getIconButtonWithHeight(5.h, Icons.arrow_back_ios_new_sharp, 18.sp, ColorStyles.upFinDarkGray, () async {
              CommonUtils.hideKeyBoard();
              Navigator.pop(context);
            }),
          ])),
          SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            UiUtils.getMarginBox(0, 3.h),
            UiUtils.getTextWithFixedScale("사용자정보", 20.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, null),
            UiUtils.getMarginBox(0, 3.h)
          ])),
          UiUtils.getDisabledTextField(90.w, MyData.name, TextStyles.upFinDisabledTextFormFieldTextStyle,
              UiUtils.getDisabledInputDecoration("이름", 12.sp, "", 0.sp)),
          UiUtils.getMarginBox(0, 2.h),
          UiUtils.getDisabledTextField(90.w, MyData.email, TextStyles.upFinDisabledTextFormFieldTextStyle,
              UiUtils.getDisabledInputDecoration("이메일", 12.sp, "", 0.sp)),
          UiUtils.getMarginBox(0, 2.h),
          UiUtils.getDisabledTextField(90.w, "${MyData.phoneNumber.substring(0,3)}-${MyData.phoneNumber.substring(3,7)}-${MyData.phoneNumber.substring(7)}", TextStyles.upFinDisabledTextFormFieldTextStyle,
              UiUtils.getDisabledInputDecoration("연락처", 12.sp, "", 0.sp)),
          UiUtils.getExpandedScrollView(Axis.vertical, const Column(children: [])),
          UiUtils.getMarginBox(0, 2.h),
          UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
              UiUtils.getTextWithFixedScale("탈퇴하기", 12.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.center, null), () {
                UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, true, 100.w, 65.h, 0.5, (slideContext, slideSetState){
                  Widget slideWidget = Scaffold(
                      backgroundColor: ColorStyles.upFinWhite,
                      body: Container(
                          padding: EdgeInsets.all(2.w),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UiUtils.getTextWithFixedScale("탈퇴", 14.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null),
                                UiUtils.getMarginBox(0, 1.h),
                                UiUtils.getTextWithFixedScale("비밀번호 입력 후 회원탈퇴가 가능합니다.", 14.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.start, null),
                                UiUtils.getMarginBox(0, 4.h),
                                UiUtils.getTextField(90.w, TextStyles.upFinTextFormFieldTextStyle, _pwdTextFocus, _pwdTextController, TextInputType.text,
                                    UiUtils.getInputDecoration("비밀번호", 12.sp, "", 0.sp), (value) { }),
                                UiUtils.getExpandedScrollView(Axis.vertical, const Column(children: [])),
                                UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                                    UiUtils.getTextWithFixedScale("진행", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null), () {
                                      Map<String, dynamic> inputJson = {
                                        "user" : {
                                          "email": MyData.email,
                                          "password": _pwdTextController.text
                                        }
                                      };
                                      UiUtils.showLoadingPop(context);
                                      LogfinController.callLogfinApi(LogfinApis.deleteAccount, inputJson, (isSuccessToLogin, outputJson) async {
                                        UiUtils.closeLoadingPop(context);
                                        Navigator.pop(slideContext);
                                        if(isSuccessToLogin){
                                          CommonUtils.flutterToast("회원삭제 성공");
                                          CommonUtils.backToHome(context);
                                        }else{
                                          if(outputJson!["error"] == "Invalid email or password"){
                                            CommonUtils.flutterToast("비밀번호가 일치하지 않습니다.");
                                          }else{
                                            CommonUtils.flutterToast("회원탈퇴중 에러가 발생했습니다.");
                                          }

                                        }
                                      });
                                    })
                              ])
                      )
                  );

                  return slideWidget;
                });
              })
        ])
    );


    return UiUtils.getScrollViewWithAllowBackForAndroid(context, view, _scrollController, back);
  }

}