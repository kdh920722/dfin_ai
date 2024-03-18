import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dfin/controllers/logfin_controller.dart';
import 'package:dfin/datas/my_data.dart';
import 'package:dfin/styles/ColorStyles.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/firebase_controller.dart';
import '../controllers/sharedpreference_controller.dart';
import '../styles/TextStyles.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';
import 'app_findpw_view.dart';

class AppSignOutView extends StatefulWidget{
  @override
  AppSignOutViewState createState() => AppSignOutViewState();
}

class AppSignOutViewState extends State<AppSignOutView> with WidgetsBindingObserver{
  final _pwdTextController = TextEditingController();
  final _pwdTextFocus = FocusNode();

  void _unFocusAllNodes(){
    _pwdTextFocus.unfocus();
  }

  void _disposeAllTextControllers(){
    _pwdTextController.dispose();
  }

  @override
  void initState(){
    CommonUtils.log("d", "AppSignOutViewState 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Config.contextForEmergencyBack = context;
    Config.isEmergencyRoot = false;
    isValidToSignOut = false;
    backValid = true;
    FireBaseController.setStateForForeground = null;
  }

  @override
  void dispose(){
    CommonUtils.log("d", "AppSignOutViewState 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _unFocusAllNodes();
    _disposeAllTextControllers();
    Config.contextForEmergencyBack =null;
    isValidToSignOut = false;
    backValid = true;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('d','AppSignOutView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('d','AppSignOutView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('d','AppSignOutView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('d','AppSignOutView paused');
        break;
      default:
        break;
    }
  }

  String _getBirth(){
    String birthMonth = MyData.birth.substring(4,6);
    if(birthMonth.substring(0,1) == "0"){
      birthMonth = birthMonth.substring(1);
    }

    String birthDay = MyData.birth.substring(6);
    if(birthDay.substring(0,1) == "0"){
      birthDay = birthDay.substring(1);
    }

    return "${MyData.birth.substring(0,4)}년 $birthMonth월 $birthDay일";
  }


  bool backValid = true;
  void _back(){
    if(backValid){
      backValid = false;
      CommonUtils.hideKeyBoard();
      Future.delayed(const Duration(milliseconds: 300), () async {
        Navigator.pop(context);
        backValid = true;
      });
    }
  }

  bool isValidToSignOut = false;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Widget view = Container(
        color: ColorStyles.dFinBlack,
        width: 100.w,
        height: 100.h,
        padding: EdgeInsets.only(bottom: 5.w, top: 3.w, left: 5.w, right: 5.w),
        child: UiUtils.getRowColumnWithAlignCenter([
          SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            UiUtils.getBackButtonForMainView(() async {
              _back();
            }),
          ])),
          SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            UiUtils.getMarginBox(0, 3.w),
            UiUtils.getTextWithFixedScale("사용자 정보", 22.sp, FontWeight.w600, ColorStyles.dFinWhiteGray, TextAlign.start, null),
            UiUtils.getMarginBox(0, 3.h)
          ])),
          UiUtils.getDisabledTextField(context, 90.w, MyData.name, TextStyles.dFinDisabledTextFormFieldTextStyle2,
              UiUtils.getDisabledInputDecoration("이름", 12.sp, "", 0.sp)),
          UiUtils.getMarginBox(0, 2.h),
          UiUtils.getDisabledTextField(context, 90.w, _getBirth(), TextStyles.dFinDisabledTextFormFieldTextStyle2,
              UiUtils.getDisabledInputDecoration("생년월일", 12.sp, "", 0.sp)),
          UiUtils.getMarginBox(0, 2.h),
          UiUtils.getDisabledTextField(context, 90.w, MyData.email, TextStyles.dFinDisabledTextFormFieldTextStyle2,
              UiUtils.getDisabledInputDecoration("이메일", 12.sp, "", 0.sp)),
          UiUtils.getMarginBox(0, 2.h),
          UiUtils.getDisabledTextField(context, 90.w, "${MyData.phoneNumber.substring(0,3)}-${MyData.phoneNumber.substring(3,7)}-${MyData.phoneNumber.substring(7)}", TextStyles.dFinDisabledTextFormFieldTextStyle2,
              UiUtils.getDisabledInputDecoration("연락처", 12.sp, "", 0.sp)),
          UiUtils.getExpandedScrollView(Axis.vertical, const Column(children: [])),
          UiUtils.getMarginBox(0, 2.h),
          SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            UiUtils.getMarginBox(0, 1.w),
            UiUtils.getRoundBoxButtonTextWithFixedScale5(
                UiUtils.getTextWithFixedScale("회원탈퇴를 원하시나요?", 12.sp, FontWeight.w500, ColorStyles.dFinRealGray, TextAlign.start, null),
                ColorStyles.dFinBlack, (){
              isValidToSignOut = false;
              isChecked = false;
              _pwdTextController.text = "";
              UiUtils.showPopMenu(context, true, 100.w, 100.h, 0.5, 0, ColorStyles.dFinBlack, (slideContext, slideSetState){
                Widget slideWidget = Column(
                    children: [
                      SizedBox(width: 95.w, child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                        UiUtils.getBackButton(() {
                          _pwdTextController.text = "";
                          if(backValid){
                            backValid = false;
                            CommonUtils.hideKeyBoard();
                            Future.delayed(const Duration(milliseconds: 300), () async {
                              Navigator.pop(slideContext);
                              backValid = true;
                            });
                          }
                        }),
                        UiUtils.getMarginBox(2.w, 0),
                      ])),
                      UiUtils.getMarginBox(0, 3.w),
                      SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("회원탈퇴", 22.sp, FontWeight.w600, ColorStyles.dFinWhiteGray, TextAlign.start, null)),
                      UiUtils.getMarginBox(0, 5.h),
                      SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale("비밀번호", 11.sp, FontWeight.w500, ColorStyles.dFinRealGray, TextAlign.start, null)),
                      UiUtils.getMarginBox(0, 1.5.h),
                      UiUtils.getTextFormField(context, 90.w, TextStyles.dFinTextFormFieldTextStyle, _pwdTextFocus, _pwdTextController, TextInputType.visiblePassword, true,
                          UiUtils.getInputDecoration("", 12.sp, "", 0.sp), (text) {
                            if(text == ""){
                              slideSetState(() {
                                isValidToSignOut = false;
                              });
                            }else{
                              slideSetState(() {
                                isValidToSignOut = true;
                              });
                            }
                          }, (value){}),
                      Row(crossAxisAlignment:CrossAxisAlignment.start, children: [UiUtils.getMarginBox(5.w, 0),Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
                        UiUtils.getMarginBox(0, 2.h),
                        UiUtils.getTextWithFixedScale2("•  탈퇴시 사용자의 정보는 삭제되며, 복구가 불가능합니다.", 10.sp, FontWeight.w400, ColorStyles.dFinDarkGray, TextAlign.start, null),
                        UiUtils.getMarginBox(0, 1.h),
                        GestureDetector(child: Row(children: [
                          UiUtils.getTextWithFixedScale2("•  자세한 내용은", 10.sp, FontWeight.w400, ColorStyles.dFinDarkGray, TextAlign.start, null),
                          UiUtils.getTextWithFixedScale2("개인정보처리방침", 10.sp, FontWeight.w400, ColorStyles.dFinButtonBlue, TextAlign.start, null),
                          UiUtils.getTextWithFixedScale2("을 참고하세요", 10.sp, FontWeight.w400, ColorStyles.dFinDarkGray, TextAlign.start, null),
                        ]),
                            onTap: () async {
                              Uri privacyLink = Uri.parse(Config.privacyUrl);
                              if(await canLaunchUrl(privacyLink)){
                                launchUrl(privacyLink);
                              }
                            }),
                      ])]),
                      Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        UiUtils.getMarginBox(2.w, 0),
                        UiUtils.getCustomCheckBox(UniqueKey(), 1.2, isChecked, ColorStyles.dFinWhite, ColorStyles.dFinButtonBlue,
                            ColorStyles.dFinGray, ColorStyles.dFinButtonBlue, (checkedValue){
                              slideSetState(() {
                                if(checkedValue != null){
                                  isChecked = checkedValue;
                                }
                              });
                            }),
                        UiUtils.getTextWithFixedScale("위 내용을 모두 확인했습니다.", 12.sp, FontWeight.w500, ColorStyles.dFinWhiteGray, TextAlign.start, null),
                      ]),
                      UiUtils.getExpandedScrollView(Axis.vertical, const Column(children: [])),
                      isValidToSignOut? Column(children: [
                        UiUtils.getBorderButtonBox(90.w, ColorStyles.dFinButtonBlue, ColorStyles.dFinButtonBlue,
                            UiUtils.getTextWithFixedScale("탈퇴하기", 14.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.center, null), () {
                              CommonUtils.hideKeyBoard();
                              if(isChecked){
                                Map<String, dynamic> inputJson = {
                                  "user" : {
                                    "email": MyData.email,
                                    "password": _pwdTextController.text
                                  }
                                };
                                UiUtils.showLoadingPop(context);
                                LogfinController.callLogfinApi(LogfinApis.deleteAccount, inputJson, (isSuccessToLogin, outputJson) async {
                                  UiUtils.closeLoadingPop(context);
                                  if(isSuccessToLogin){
                                    Navigator.pop(slideContext);
                                    SharedPreferenceController.deleteAllData();
                                    CommonUtils.flutterToast("회원삭제 성공");
                                    CommonUtils.backToHome(context);
                                  }else{
                                    if(outputJson!["error"] == "Invalid email or password"){
                                      CommonUtils.flutterToast("비밀번호가 일치하지 않아요.");
                                    }else{
                                      CommonUtils.flutterToast("회원탈퇴중 에러가 발생했어요.");
                                    }

                                  }
                                });
                              }else{
                                CommonUtils.flutterToast("내용 확인에 체크하세요.");
                              }
                            }),
                        UiUtils.getMarginBox(0, 1.5.h),
                        SizedBox(width: 90.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          UiUtils.getRoundBoxButtonTextWithFixedScale5(
                              UiUtils.getTextWithFixedScale("비밀번호를 잊으셨나요?", 12.sp, FontWeight.w500, ColorStyles.dFinWhiteGray, TextAlign.start, null),
                              ColorStyles.dFinBlack, (){
                            CommonUtils.hideKeyBoard();
                            AppFindPwViewState.viewId = 1;
                            CommonUtils.moveTo(context, AppView.appFindPwView.value, null);
                          })
                        ]))
                      ]) : Container(),
                      UiUtils.getMarginBox(0, 5.w)
                    ]);

                return slideWidget;
              });
            }),
          ]))
        ])
    );

    return UiUtils.getViewWithAllowBackForAndroid(context, view, _back);
  }

}