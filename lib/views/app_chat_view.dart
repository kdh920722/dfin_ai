import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/controllers/get_controller.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:upfin/styles/TextStyles.dart';
import '../configs/app_config.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppChatView extends StatefulWidget{
  @override
  AppChatViewState createState() => AppChatViewState();
}

class AppChatViewState extends State<AppChatView> with WidgetsBindingObserver{
  bool backPossibleFlag = true;
  final ScrollController _chatScrollController = ScrollController();
  final _chatTextFocus = FocusNode();
  final _chatTextController = TextEditingController();
  static String currentRoomId = "";
  String currentLoanUid = "";
  String currentCompany = "";
  String currentCompanyLogo = "";
  String currentStatus = "";
  int _ticks = 0;
  bool isBuild = false;

  @override
  void initState(){
    CommonUtils.log("i", "AppChatViewState 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    currentRoomId = GetController.to.chatMessageInfoDataList[0].chatRoomId;
    for(var each in MyData.getLoanInfoList()){
      if(each.chatRoomId == currentRoomId){
        currentLoanUid = each.loanUid;
        currentCompany = each.companyName;
        currentCompanyLogo = each.companyLogo;
        currentStatus = each.statueId;
        _ticks = 2;
      }
    }
    Config.contextForEmergencyBack = context;
    _keyboardVisibilityController = CommonUtils.getKeyboardViewController(_functionForKeyboardShow, _functionForKeyboardHide);
  }

  KeyboardVisibilityController? _keyboardVisibilityController;
  void _functionForKeyboardHide(){
    _scrollToBottom();
  }
  Future<void> _functionForKeyboardShow() async {
    _scrollToBottom();
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppChatViewState 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _chatScrollController.dispose();
    _chatTextFocus.dispose();
    _chatTextController.dispose();
    currentRoomId = "";
    Config.contextForEmergencyBack = null;
    _keyboardVisibilityController = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('i','AppChatViewState resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('i','AppChatViewState inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('i','AppChatViewState detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('i','AppChatViewState paused');
        break;
      default:
        break;
    }
  }

  List<Widget> _getChatList(){
    List<Widget> chatList = [];
    CommonUtils.log("i", "re draw chat messages");
    for(var each in GetController.to.chatMessageInfoDataList){
      if(each.messageType == "text"){
        /*
        * type text
        * */
        if(each.senderName == "UPFIN"){
          chatList.add(
              Container(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 1.w, bottom: 2.w),
                  child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    UiUtils.getImage(10.w, 10.w, Image.asset(fit: BoxFit.fitWidth, currentCompanyLogo)),
                    UiUtils.getMarginBox(1.5.w, 0),
                    Column(children: [
                      UiUtils.getMarginBox(0, 4.h),
                      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Container(
                            constraints: BoxConstraints(
                                maxWidth: 55.w
                            ),
                            padding: EdgeInsets.all(3.w),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                              color: ColorStyles.upFinWhiteSky,
                            ),
                            child: UiUtils.getTextWithFixedScale(each.message.replaceAll("/", "\n"), 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null)),
                        UiUtils.getMarginBox(1.w, 0),
                        UiUtils.getTextWithFixedScale(CommonUtils.getFormattedLastMsgTime(each.messageTime), 8.sp, FontWeight.w400, ColorStyles.upFinDarkGray, TextAlign.start, null)
                      ])
                    ]),
                  ])
              )
          );
        }else{
          chatList.add(
              Container(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 1.w, bottom: 2.w),
                  width: 100.w,
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Column(children: [
                      Container(
                          constraints: BoxConstraints(
                              maxWidth: 55.w
                          ),
                          padding: EdgeInsets.all(3.w),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                            color: ColorStyles.upFinGray,
                          ),
                          child: UiUtils.getTextWithFixedScale(each.message, 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null))
                    ])
                  ])
              )
          );
        }
      }else{
        /*
        * type file
        * */
        if(each.senderName == "UPFIN"){
          chatList.add(
              Container(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.w, bottom: 5.w),
                  width: 100.w,
                  child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    UiUtils.getImage(10.w, 10.w, Image.asset(fit: BoxFit.fitWidth, currentCompanyLogo)),
                    UiUtils.getMarginBox(1.5.w, 0),
                    Column(children: [
                      UiUtils.getMarginBox(0, 4.h),
                      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Container(
                            constraints: BoxConstraints(
                                maxWidth: 55.w
                            ),
                            padding: EdgeInsets.all(3.w),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                              color: ColorStyles.upFinWhiteSky,
                            ),
                            child: Column(children: [
                              UiUtils.getTextWithFixedScale(each.message.replaceAll("/", "\n"), 12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null),
                              UiUtils.getMarginBox(0, 2.h),
                              UiUtils.getBorderButtonBox(60.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
                                  UiUtils.getTextWithFixedScale("확인", 12.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, null), () {

                                  })
                            ])),
                        UiUtils.getMarginBox(1.w, 0),
                        UiUtils.getTextWithFixedScale("21시09분", 8.sp, FontWeight.w400, ColorStyles.upFinDarkGray, TextAlign.start, null)
                      ])
                    ])
                  ])
              )
          );
        }
      }
    }

    _scrollToBottom();
    return chatList;
  }

  void back(){
    if(backPossibleFlag){
      backPossibleFlag = false;
      CommonUtils.hideKeyBoard();
      var inputJson = {
        "pr_room_id" : currentRoomId
      };
      UiUtils.showLoadingPop(context);
      LogfinController.callLogfinApi(LogfinApis.checkMessage, inputJson, (isSuccess, outputJson){
        backPossibleFlag =true;
        UiUtils.closeLoadingPop(context);
        if(isSuccess){
          Navigator.pop(context);
        }else{
          CommonUtils.flutterToast("메시지를 읽는중\n오류가 발생했습니다.");
        }
      });
    }
  }

  Future<void> _scrollToBottom() async {
    if(isBuild){
      await Future.delayed(const Duration(milliseconds: 400), () async {
        if(_chatScrollController.hasClients){
          _chatScrollController.animateTo(
            _chatScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.fastOutSlowIn,
          );
        }
      });
    }
  }

  Widget _getTimelineWidget(){
    return Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _stepTick1(),
        _ticks>1? _stepLine(true) : _stepLine(false),
        _stepTick2(),
        _ticks>2? _stepLine(true) : _stepLine(false),
        _stepTick3()
      ],
    );
  }
  Widget _stepTick(int type, bool isChecked){
    String typeString = "";
    if(type == 0){
      typeString = "접수";
    }else if(type == 1){
      typeString = "심사";
    }else{
      typeString = "통보";
    }

    return Column(children: [
      UiUtils.getMarginBox(0, 3.h),
      isChecked? UiUtils.getIcon(4.w, 4.w, Icons.check_circle_rounded, 4.w, ColorStyles.upFinButtonBlue) :
        UiUtils.getIcon(4.w, 4.w, Icons.check_circle_outline_rounded, 4.w, ColorStyles.upFinWhiteSky),
      UiUtils.getMarginBox(0, 1.5.h),
      UiUtils.getTextWithFixedScale(typeString, 9.sp, FontWeight.w600, ColorStyles.upFinRealGray, TextAlign.center, null)
    ]);
  }

  Widget _stepTick1() {
    return _ticks>0?_stepTick(0, true):_stepTick(0, false);
  }
  Widget _stepTick2() {
    return _ticks>1?_stepTick(1, true):_stepTick(1, false);
  }
  Widget _stepTick3() {
    return _ticks>2?_stepTick(2, true):_stepTick(2, false);
  }

  Widget _stepLine(bool isReached) {
    return Container(
      color: isReached? ColorStyles.upFinButtonBlue : ColorStyles.upFinWhiteSky,
      height: 0.15.h,
      width: 36.w,
    );
  }

  double inputMinHeight = 9.2.h;
  double inputHeight = 9.2.h;
  double inputMaxHeight = 20.h;

  @override
  Widget build(BuildContext context) {

    if(CommonUtils.isValidStateByAPiExpiredDate()){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isBuild = true;
        _scrollToBottom();
      });

      Widget view =
      Container(
          color: ColorStyles.upFinWhite,
          width: 100.w,
          height: 100.h,
          child: Column(children: [
            UiUtils.getMarginBox(0, 0.5.h),
            Stack(children: [
              Positioned(
                top: 1.h,
                left: 5.w,
                child: UiUtils.getBackButton(() {
                  back();
                }),
              ),
              Positioned(
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      UiUtils.getMarginBox(0, 2.5.h),
                      UiUtils.getTextWithFixedScale(currentCompany, 16.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.center, 1),
                      UiUtils.getMarginBox(0, 1.h),
                      UiUtils.getTextWithFixedScale("AI어드바이저", 12.sp, FontWeight.w600, ColorStyles.upFinRealGray, TextAlign.center, 1),
                    ])
                ),
              ),
            ]),
            UiUtils.getMarginBox(0, 1.h),
            _getTimelineWidget(),
            UiUtils.getMarginBox(0, 3.h),
            UiUtils.getMarginColoredBox(100.w, 1.h, ColorStyles.upFinWhiteGray),
            UiUtils.getMarginBox(0, 0.5.h),
            UiUtils.getExpandedScrollViewWithController(Axis.vertical, Obx(()=>Column(mainAxisAlignment: MainAxisAlignment.start, children: _getChatList())), _chatScrollController),
            UiUtils.getMarginBox(0, 0.5.h),
            AnimatedContainer(
                duration: const Duration(milliseconds:300),
                width: 100.w,
                height: inputHeight,
                constraints: BoxConstraints(
                  minHeight: inputMinHeight,
                  maxHeight: inputMaxHeight,
                ),
                color: ColorStyles.upFinWhite,
                child: Padding(padding: EdgeInsets.only(left: 3.w,right: 3.w,bottom: 2.w,top: 0.5.w), child:
                Container(color: ColorStyles.upFinGray, padding: EdgeInsets.all(0.5.w),
                  child: Container(color: ColorStyles.upFinWhite, child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Expanded(flex: 75, child: Column(children: [UiUtils.getExpandedScrollView(Axis.vertical,
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          UiUtils.getMarginBox(0, 0.5.h),
                          UiUtils.getChatTextField(73.w, TextStyles.upFinTextFormFieldTextStyle, _chatTextFocus, _chatTextController, TextInputType.multiline,
                              UiUtils.getChatInputDecoration(), (textValue) {
                                if(textValue != ""){
                                  final textLinePainter = TextPainter(
                                    text: TextSpan(text: textValue, style: TextStyles.upFinTextFormFieldTextStyle),
                                    maxLines: null,
                                    textDirection: TextDirection.ltr,
                                  )..layout(minWidth: 0, maxWidth: 70.w);

                                  if(inputHeight <= inputMaxHeight){
                                    final desiredHeight = inputMinHeight*0.7+textLinePainter.height;
                                    final height = desiredHeight.clamp(inputMinHeight, inputMaxHeight);
                                    print("hhh : $inputHeight || $height");
                                    setState(() {
                                      inputHeight = height;
                                    });
                                  }
                                }else{
                                  setState(() {
                                    inputHeight = inputMinHeight;
                                  });
                                }
                              })
                        ]))])),
                    Expanded(flex: 1, child: Container(color: ColorStyles.upFinWhite)),
                    Expanded(flex: 15, child: UiUtils.getBorderButtonBoxWithZeroPadding(12.w, ColorStyles.upFinWhiteSky, ColorStyles.upFinWhiteSky,
                        UiUtils.getTextWithFixedScale("보내기", 10.sp, FontWeight.w600, ColorStyles.upFinButtonBlue, TextAlign.start, null), () async {
                          CommonUtils.hideKeyBoard();
                          var inputJson = {
                            "loan_uid" : currentLoanUid,
                            "message" : _chatTextController.text
                          };
                          LogfinController.callLogfinApi(LogfinApis.sendMessage, inputJson, (isSuccess, _){
                            if(!isSuccess){
                              CommonUtils.flutterToast("메시지 전송중\n오류가 발생했습니다.");
                            }
                          });
                          setState(() {
                            _chatTextController.text = "";
                          });
                        })),
                    Expanded(flex: 2, child: Container(color: ColorStyles.upFinWhite)),
                  ]))))
            )
          ])
      );
      return UiUtils.getViewWithAllowBackForAndroid(context, view, back);
    }else{
      CommonUtils.flutterToast("접속시간이 만료되었습니다.\n재로그인 해주세요");
      CommonUtils.backToHome(context);
      return Container();
    }
  }

}