import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/configs/app_config.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:upfin/styles/TextStyles.dart';
import '../utils/common_utils.dart';
import '../utils/pop_result.dart';
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

    return chatList;
  }

  double inputMinHeight = 8.h;
  double inputHeight = 8.h;
  double inputMaxHeight = 30.h;

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
          SizedBox(width: 100.w, height: 10.h, child: Row(children: [
            UiUtils.getMarginBox(3.w, 0),
            UiUtils.getIconButtonWithHeight(7.h, Icons.arrow_back_ios_new_sharp, 20.sp, ColorStyles.upFinDarkGray, () {
              Navigator.pop(context);
            }),
            UiUtils.getMarginBox(24.w, 0),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              UiUtils.getIcon(10.w, 10.w, Icons.account_box_rounded, 10.w, ColorStyles.upFinButtonBlue),
              UiUtils.getTextWithFixedScale("AI어드바이저", 14.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, 1)
            ]),
          ])),

          UiUtils.getExpandedScrollViewWithController(Axis.vertical, Container(color: ColorStyles.upFinWhiteSky, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: _getChatList())), _chatScrollController),

          AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 100.w,
              height: inputHeight,
              constraints: BoxConstraints(
                minHeight: inputMinHeight,
                maxHeight: inputMaxHeight,
              ),
              color: ColorStyles.upFinButtonBlue,
              child: Column(children: [
                UiUtils.getMarginBox(0, 0.7.h),
                Row(mainAxisAlignment:MainAxisAlignment.center, children: [
                  UiUtils.getMarginBox(2.w, 0),
                  UiUtils.getChatTextField(84.w, TextStyles.upFinTextFormFieldTextStyle, _chatTextFocus, _chatTextController, TextInputType.multiline,
                      UiUtils.getInputDecoration("", 0.sp, "", 0.sp), (textValue) {
                    if(textValue != ""){
                      final textLinePainter = TextPainter(
                        text: TextSpan(text: textValue, style: TextStyles.upFinTextFormFieldTextStyle),
                        maxLines: null,
                        textDirection: TextDirection.ltr,
                      )..layout(minWidth: 0, maxWidth: 60.w);

                      if(textLinePainter.width >= 59.w){
                        CommonUtils.log("i", "setupdate");
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
                  UiUtils.getIconButton(Icons.send_rounded, 10.w, ColorStyles.upFinWhite, () { })
                ])
              ]))
        ])
    );
    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }

}