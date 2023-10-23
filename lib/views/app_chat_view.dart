import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/controllers/firebase_controller.dart';
import 'package:upfin/controllers/get_controller.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/datas/loan_info_data.dart';
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
  bool isTextFieldFocus = false;

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
        if(LoanInfoData.getStatusName(currentStatus) == "접수"){
          _ticks = 1;
        }else if(LoanInfoData.getStatusName(currentStatus) == "심사"){
          _ticks = 2;
        }else if(LoanInfoData.getStatusName(currentStatus) == "통보"){
          _ticks = 3;
        }
      }
    }
    Config.contextForEmergencyBack = context;
    Config.isEmergencyRoot = false;
    _keyboardVisibilityController = CommonUtils.getKeyboardViewController(_functionForKeyboardShow, _functionForKeyboardHide);
  }

  KeyboardVisibilityController? _keyboardVisibilityController;
  void _functionForKeyboardHide(){
    _scrollToBottom(true);
  }
  void _functionForKeyboardShow() {
    _scrollToBottom(true);
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
  
  Widget _getHtmlView(String htmlString){
    htmlString = "<div id='type1'>$htmlString</div>";
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      HtmlWidget(
        htmlString,
        customStylesBuilder: (element) {
          if(element.id == 'type1') {
            return {
              "color" : "black",
              "font-size": "16px",
              "line-height" : "120%",
              "font-weight": "normal",
            };
          }

          if (element.localName == 'button') {
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
        },

        onTapUrl: (url) async {
          Map<String, String> urlInfoMap = {
            "url" : url
          };
          CommonUtils.moveTo(context, AppView.appWebView.value, urlInfoMap);
          return true;
        },
        renderMode: RenderMode.column,
        textStyle: TextStyles.upFinHtmlTextStyle,
      )
    ]);
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
                    Column(children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        CustomPaint(
                          painter: ChatBubbleTriangleForOther(),
                        ),
                        Container(
                            constraints: BoxConstraints(maxWidth: 70.w),
                            padding: EdgeInsets.all(3.w),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                              color: ColorStyles.upFinWhiteSky,
                            ),
                            child: _getHtmlView(each.message)
                        ),
                        UiUtils.getMarginBox(1.w, 0),
                        UiUtils.getTextWithFixedScale(CommonUtils.getFormattedLastMsgTime(each.messageTime), 8.sp, FontWeight.w400, ColorStyles.upFinDarkGray, TextAlign.start, null)
                      ]),
                      UiUtils.getMarginBox(0, 1.h)
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
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Container(
                          constraints: BoxConstraints(
                              maxWidth: 55.w
                          ),
                          padding: EdgeInsets.all(3.w),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                            color: ColorStyles.upFinTextAndBorderBlue,
                          ),
                          child: UiUtils.getTextWithFixedScale(each.message, 12.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null)
                      ),
                      CustomPaint(
                        painter: ChatBubbleTriangleForMe(),
                      )
                    ]),
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
                    Column(children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Container(
                            constraints: BoxConstraints(
                                maxWidth: 55.w
                            ),
                            padding: EdgeInsets.all(3.w),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
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

    _scrollToBottom(false);
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

  Future<void> _scrollToBottom(bool doDelay) async {
    if(isBuild){
      if(doDelay){
        await Future.delayed(const Duration(milliseconds: 400), () async {});
      }

      if(_chatScrollController.hasClients){
        _chatScrollController.jumpTo(_chatScrollController.position.maxScrollExtent);
      }
    }
  }

  Widget _getTimelineWidget(){
    return Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
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
      isChecked? UiUtils.getIcon(4.w, 4.w, Icons.check_circle_rounded, 4.w, ColorStyles.upFinButtonBlue) :
        UiUtils.getIcon(4.w, 4.w, Icons.check_circle_outline_rounded, 4.w, ColorStyles.upFinWhiteSky),
      UiUtils.getMarginBox(0, 1.5.h),
      UiUtils.getTextWithFixedScale(typeString, 9.sp, FontWeight.w600, ColorStyles.upFinRealGray, TextAlign.center, null),
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
    return Column(children: [
      UiUtils.getMarginBox(0, 0.8.h),
      Container(
        color: isReached? ColorStyles.upFinButtonBlue : ColorStyles.upFinWhiteSky,
        height: 0.15.h,
        width: 36.w,
      )
    ]);
  }

  double inputMinHeight = 9.2.h;
  double inputHeight = 9.2.h;
  double inputMaxHeight = 20.h;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(!CommonUtils.isValidStateByAPiExpiredDate()){
        CommonUtils.flutterToast("접속시간이 만료되었습니다.\n재로그인 해주세요");
        CommonUtils.backToHome(context);
      }else{
        isBuild = true;
        _scrollToBottom(false);
      }
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
                    UiUtils.getTextWithFixedScale(LoanInfoData.getDetailStatusName(currentStatus), 12.sp, FontWeight.w600, ColorStyles.upFinTextAndBorderBlue, TextAlign.center, null)
                  ])
              ),
            ),
          ]),
          UiUtils.getMarginBox(0, 3.h),
          _getTimelineWidget(),
          UiUtils.getMarginBox(0, 3.h),
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
              Container(
                  decoration: BoxDecoration(
                    color: ColorStyles.upFinGray, // 배경색 설정
                    borderRadius: BorderRadius.circular(20.0), // 모서리를 둥글게 하는 부분
                  ),
                  padding: EdgeInsets.all(0.5.w),
                  child: Container(
                      decoration: BoxDecoration(
                        color: ColorStyles.upFinWhite, // 배경색 설정
                        borderRadius: BorderRadius.circular(18.0), // 모서리를 둥글게 하는 부분
                      ),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        UiUtils.getMarginBox(1.5.w, 0),
                    Expanded(flex: 75, child: Column(children: [UiUtils.getExpandedScrollView(Axis.vertical,
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          UiUtils.getMarginBox(0, 0.7.h),
                          UiUtils.getChatTextField(70.w, TextStyles.upFinTextFormFieldTextStyle, _chatTextFocus, _chatTextController, TextInputType.multiline,
                              UiUtils.getChatInputDecoration(), (textValue) {
                                if(textValue != ""){
                                  isTextFieldFocus = true;
                                  final textLinePainter = TextPainter(
                                    text: TextSpan(text: textValue, style: TextStyles.upFinTextFormFieldTextStyle),
                                    maxLines: null,
                                    textDirection: TextDirection.ltr,
                                  )..layout(minWidth: 0, maxWidth: 67.w);

                                  if(inputHeight <= inputMaxHeight){
                                    final desiredHeight = inputMinHeight*0.7+textLinePainter.height;
                                    final height = desiredHeight.clamp(inputMinHeight, inputMaxHeight);
                                    setState(() {
                                      inputHeight = height;
                                    });
                                  }
                                }else{
                                  setState(() {
                                    isTextFieldFocus = false;
                                    inputHeight = inputMinHeight;
                                  });
                                }
                              })
                        ]))])),
                    Expanded(flex: 1, child: Container(color: ColorStyles.upFinWhite)),
                    Expanded(flex: 15, child: UiUtils.getBorderButtonBoxWithZeroPadding(12.w, isTextFieldFocus? ColorStyles.upFinWhiteSky : ColorStyles.upFinWhiteGray, isTextFieldFocus? ColorStyles.upFinWhiteSky : ColorStyles.upFinWhiteGray,
                        UiUtils.getTextWithFixedScale("보내기", 10.sp, FontWeight.w600, isTextFieldFocus? ColorStyles.upFinButtonBlue : ColorStyles.upFinRealGray, TextAlign.start, null), () async {
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
                        UiUtils.getMarginBox(2.5.w, 0),
                  ]))))
          )
        ])
    );
    return UiUtils.getViewWithAllowBackForAndroid(context, view, back);

  }

}

class ChatBubbleTriangleForOther extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = ColorStyles.upFinWhiteSky;

    var path = Path();
    path.lineTo(0, -4.w);
    path.lineTo(-2.w, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ChatBubbleTriangleForMe extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = ColorStyles.upFinTextAndBorderBlue;

    var path = Path();
    path.lineTo(0, -4.w);
    path.lineTo(2.w, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}