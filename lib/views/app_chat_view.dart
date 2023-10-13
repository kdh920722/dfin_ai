import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:upfin/styles/TextStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppChatView extends StatefulWidget{
  @override
  AppChatViewState createState() => AppChatViewState();
}

class AppChatViewState extends State<AppChatView> with WidgetsBindingObserver{
  final ScrollController _chatScrollController = ScrollController();
  final _chatTextFocus = FocusNode();
  final _chatTextController = TextEditingController();

  @override
  void initState(){
    CommonUtils.log("i", "AppChatViewState 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppChatViewState 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    _chatScrollController.dispose();
    _chatTextFocus.dispose();
    _chatTextController.dispose();
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
    List<dynamic> chatInfoList = [];
    List<Widget> chatList = [];
    for(var each in chatInfoList){
      chatList.add(each);
    }
    chatList.add(
        Container(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            width: 100.w,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              UiUtils.getImage(10.w, 10.w, Image.asset(fit: BoxFit.fitWidth,'assets/images/chatbot_icon.png')),
              UiUtils.getMarginBox(2.w, 0),
              Column(children: [
                UiUtils.getMarginBox(0, 2.5.h),
                Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                      color: ColorStyles.upFinWhiteSky,
                    ),
                    width: 70.w,
                    child: UiUtils.getTextWithFixedScale("테스트 데이터 인풋입니다.테스트 데이터 인풋입니다.테스트 데이터 인풋입니다.테스트 데이터 인풋입니다.테스트 데이터 인풋입니다.테스트 데이터 인풋입니다.테스트 데이터 인풋입니다.테스트 데이터 인풋입니다.테스트 데이터 인풋입니다.",
                        12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null))
              ])
            ])
        )
    );

    chatList.add(
        Container(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            width: 100.w,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              UiUtils.getImage(10.w, 10.w, Image.asset(fit: BoxFit.fitWidth,'assets/images/chatbot_icon.png')),
              UiUtils.getMarginBox(2.w, 0),
              Column(children: [
                UiUtils.getMarginBox(0, 2.5.h),
                Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                      color: ColorStyles.upFinWhiteSky,
                    ),
                    width: 70.w,
                    child: Column(children: [
                      UiUtils.getTextWithFixedScale("테스트 데이터 인풋입니다.테스트 데이터 인풋입니다.테스트 데이터 인풋입니다.테스트 데이터 인풋입니다.테스트 데이터 인풋입니다.테스트 데이터 인풋입니다.테스트 데이터 인풋입니다.테스트 데이터 인풋입니다.테스트 데이터 인풋입니다.",
                          12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null),
                      UiUtils.getMarginBox(0, 2.h),
                      UiUtils.getBorderButtonBox(60.w, ColorStyles.upFinWhite, ColorStyles.upFinWhite,
                          UiUtils.getTextWithFixedScale("확인", 12.sp, FontWeight.w500, ColorStyles.upFinButtonBlue, TextAlign.start, null), () {

                          })
                    ]))
              ])
            ])
        )
    );

    return chatList;
  }

  double inputMinHeight = 8.h;
  double inputHeight = 8.h;
  double inputMaxHeight = 30.h;

  void back(){
    CommonUtils.hideKeyBoard();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {

    });

    Widget view =
    Container(
        color: ColorStyles.upFinWhite,
        width: 100.w,
        height: 100.h,
        child: Column(children: [
          UiUtils.getMarginBox(0, 2.h),
          SizedBox(width: 90.w, height: 12.h, child: Row(children: [
            UiUtils.getMarginBox(3.w, 0),
            UiUtils.getBackButton(() {
              Navigator.pop(context);
            }),
            UiUtils.getMarginBox(24.w, 0),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              UiUtils.getImage(12.w, 12.w, Image.asset(fit: BoxFit.fitWidth,'assets/images/chatbot_icon.png')),
              UiUtils.getMarginBox(0, 1.h),
              UiUtils.getTextWithFixedScale("AI어드바이저", 12.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.center, 1)
            ]),
          ])),

          UiUtils.getMarginBox(0, 2.h),
          UiUtils.getExpandedScrollViewWithController(Axis.vertical, Column(mainAxisAlignment: MainAxisAlignment.start, children: _getChatList()), _chatScrollController),

          AnimatedContainer(
              duration: const Duration(milliseconds:300),
              width: 100.w,
              height: inputHeight,
              constraints: BoxConstraints(
                minHeight: inputMinHeight,
                maxHeight: inputMaxHeight,
              ),
              color: ColorStyles.upFinSky,
              child: Column(children: [UiUtils.getExpandedScrollView(Axis.vertical,
                  Column(children: [
                    UiUtils.getMarginBox(0, 0.7.h),
                    Row(mainAxisAlignment:MainAxisAlignment.start, children: [
                      UiUtils.getMarginBox(2.w, 0),
                      UiUtils.getChatTextField(86.w, TextStyles.upFinTextFormFieldTextStyle, _chatTextFocus, _chatTextController, TextInputType.multiline,
                          UiUtils.getChatInputDecoration(), (textValue) {
                        if(textValue != ""){
                          final textLinePainter = TextPainter(
                            text: TextSpan(text: textValue, style: TextStyles.upFinTextFormFieldTextStyle),
                            maxLines: null,
                            textDirection: TextDirection.ltr,
                          )..layout(minWidth: 0, maxWidth: 60.w);

                          if(inputHeight <= 20.h){
                            final desiredHeight = inputMinHeight*0.7+textLinePainter.height;
                            final height = desiredHeight.clamp(inputMinHeight, inputMaxHeight);
                            setState(() {
                              inputHeight = height;
                            });
                          }
                        }else{
                          setState(() {
                            inputHeight = inputMinHeight;
                          });
                        }
                      }),
                      UiUtils.getMarginBox(1.w, 0),
                      UiUtils.getIconButton(Icons.send, 9.w, ColorStyles.upFinWhite, () { }),
                      UiUtils.getMarginBox(2.w, 0),
                ])
              ]))])
              )
        ])
    );
    return UiUtils.getViewWithAllowBackForAndroid(context, view, back);
  }

}