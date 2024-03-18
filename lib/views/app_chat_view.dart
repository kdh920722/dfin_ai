import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:dfin/controllers/aws_controller.dart';
import 'package:dfin/controllers/firebase_controller.dart';
import 'package:dfin/controllers/get_controller.dart';
import 'package:dfin/controllers/logfin_controller.dart';
import 'package:dfin/controllers/websocket_controller.dart';
import 'package:dfin/datas/chat_message_info_data.dart';
import 'package:dfin/datas/loan_info_data.dart';
import 'package:dfin/datas/my_data.dart';
import 'package:dfin/styles/ColorStyles.dart';
import 'package:dfin/styles/TextStyles.dart';
import 'package:dfin/views/app_apply_pr_view.dart';
import 'package:dfin/views/app_main_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../configs/app_config.dart' as appConfig;
import '../configs/app_config.dart';
import '../datas/pr_docs_info_data.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppChatView extends StatefulWidget{
  @override
  AppChatViewState createState() => AppChatViewState();
}

class AppChatViewState extends State<AppChatView> with WidgetsBindingObserver, TickerProviderStateMixin{
  bool backPossibleFlag = true;
  final ScrollController _chatScrollController = ScrollController();
  final _chatTextFocus = FocusNode();
  final _chatTextController = TextEditingController();
  static String currentRoomId = "";
  static String currentLoanUid = "";
  String currentRoomType = "";
  String currentRoomTypeName = "";
  String currentCompany = "";
  String currentCompanyLogo = "";
  String currentStatus = "";
  bool isBuild = false;
  bool isTextFieldFocus = false;
  bool inputTextHide = true;
  static bool isViewHere = false;
  double deviceH = 100.h;
  late AnimationController _aniController;
  late AnimationController _logoAniController;
  bool searchNoMore = false;
  double prevScrollPos = 0.0;
  static bool isScrollMove = false;
  bool isOpenDownloadedFile = false;

  Timer? scrollCheckTimer;

  CameraController? _cameraController;
  GlobalKey repaintKey = GlobalKey();
  bool _isCameraReady = false;
  String statusString = "접수중";
  bool isUserChatRoom = false;
  Map<String, bool> cachedImage = {};

  @override
  void initState(){
    CommonUtils.log("d", "AppChatViewState 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    GetController.to.updateChatInputHeight(inputMinHeight);
    _aniController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        lowerBound: 0.0,
        upperBound: 1.0);
    _logoAniController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        lowerBound: 0.0,
        upperBound: 1.0);

    for(var each in MyData.getLoanInfoList()){
      if(each.chatRoomId == currentRoomId){
        if(each.uidType == "0"){
          isUserChatRoom = true;
          currentLoanUid = each.loanUid;
          currentCompany = "업핀 톡";
          currentCompanyLogo = each.companyLogo;
          currentStatus = "0";
          currentRoomType = each.uidType;
          currentRoomTypeName = "몇분내로 답변을 드립니다.";
          inputTextHide = false;
          GetController.to.updateInputTextHide(inputTextHide);
          _setAutoAnswerWidgetList();
        }else{
          isUserChatRoom = false;
          currentLoanUid = each.loanUid;
          currentCompany = each.companyName;
          currentCompanyLogo = each.companyLogo;
          currentStatus = each.statueId;
          currentRoomType = each.uidType;
          currentRoomTypeName = currentRoomType == "1" ? "개인회생" : "오토론";
          inputTextHide = true;
          GetController.to.updateInputTextHide(inputTextHide);
          if(LoanInfoData.getStatusName(currentStatus) == "접수"){
            GetController.to.updateChatStatusTick(1);
          }else if(LoanInfoData.getStatusName(currentStatus) == "심사"){
            GetController.to.updateChatStatusTick(2);
          }else if(LoanInfoData.getStatusName(currentStatus) == "통보"){
            GetController.to.updateChatStatusTick(3);
          }
        }
      }
    }
    appConfig.Config.contextForEmergencyBack = context;
    appConfig.Config.isEmergencyRoot = false;
    _keyboardVisibilityController = CommonUtils.getKeyboardViewController(_functionForKeyboardShow, _functionForKeyboardHide);
    _chatScrollController.addListener(() {
      scrollCheckTimer ??= Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
          double currPos = _chatScrollController.position.pixels;
          double maxH = _chatScrollController.position.maxScrollExtent;
          if((maxH - deviceH/2) >= 0) maxH = maxH - deviceH/2;
          if(deviceH < currPos){
            if(currPos < maxH - 200){
              if(!isScrollMove){
                isScrollMove = true;
                GetController.to.updateShowScrollBottom(true);
              }
            }else if(currPos > maxH){
              if(isScrollMove){
                isScrollMove = false;
                GetController.to.updateShowScrollBottom(false);
              }
            }
          }else{
            if(_chatScrollController.position.maxScrollExtent < deviceH - 200){
              if(isScrollMove){
                isScrollMove = false;
                GetController.to.updateShowScrollBottom(false);
              }
            }else if(_chatScrollController.position.maxScrollExtent > deviceH){
              if(!isScrollMove){
                isScrollMove = true;
                GetController.to.updateShowScrollBottom(true);
              }
            }
          }
        });
      if (_chatScrollController.offset == _chatScrollController.position.maxScrollExtent && !_chatScrollController.position.outOfRange) {

      }
      else{

      }
    });

    FireBaseController.setStateForForeground = null;
    isViewHere = true;
    _setAutoAnswerWidgetList();

    GetController.to.updateShowStatus(false);
    GetController.to.updateAutoAnswerWaiting(false);
    GetController.to.updateShowScrollBottom(false);
    WebSocketController.isMessageReceived = false;

    bool isFileHere = false;
    for(var each in GetController.to.chatMessageInfoDataList){
      if(each.messageType == "file") isFileHere = true;
    }
    if(isFileHere){
      //GetController.to.updateHtmlLoad(false);
    }else{
      //GetController.to.updateHtmlLoad(true);
    }

    _setAutoAnswerWaitingState();
    isScrollMove = false;
    currentKey = "";
  }

  @pragma('vm:entry-point')
  static Future<void> downloadCallback(String id, int status, int progress) async {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  void _setAutoAnswerWaitingState(){
    if(WebSocketController.isWaitingForAnswerState(currentRoomId, "ME") == WebSocketController.isWaitingForAnswerState(currentRoomId, "UPFIN")){
      if(WebSocketController.isWaitingForAnswerState(currentRoomId, "ME")){
        GetController.to.updateAutoAnswerWaiting(true);
      }else{
        GetController.to.updateAutoAnswerWaiting(false);
      }
    }else{
      GetController.to.updateAutoAnswerWaiting(true);
    }
  }

  KeyboardVisibilityController? _keyboardVisibilityController;
  void _functionForKeyboardHide(){
    isScrollMove = false;
    _scrollToBottom(true,400);
  }
  void _functionForKeyboardShow() {
    isScrollMove = false;
    _scrollToBottom(true,400);
  }

  @override
  void dispose(){
    CommonUtils.log("d", "AppChatViewState 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    if(_cameraController != null){
      _cameraController!.dispose();
    }
    GetController.to.updateChatInputHeight(inputMinHeight);
    _chatScrollController.dispose();
    _chatTextFocus.dispose();
    _chatTextController.dispose();
    _aniController.dispose();
    _logoAniController.dispose();
    currentRoomId = "";
    pickedFiles.clear();
    chatButtonPressedPossible = true;
    _keyboardVisibilityController = null;
    AppMainViewState.isStart = false;
    isViewHere = false;
    if(scrollCheckTimer != null) scrollCheckTimer!.cancel();
    widgetList.clear();
    GetController.to.resetChatAutoAnswerWidgetList();
    GetController.to.updateInputTextHide(true);
    GetController.to.updateShowPickedFile(false);
    WebSocketController.isMessageReceived = false;
    appConfig.Config.contextForEmergencyBack = AppMainViewState.mainContext;
    currentKey = "";
    cachedImage = {};
    isScrollMove = false;
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await CommonUtils.checkUpdate(context);
        CommonUtils.log('d','AppChatViewState resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('d','AppChatViewState inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('d','AppChatViewState detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('d','AppChatViewState paused');
        break;
      default:
        break;
    }
  }

  void _showCapturedImage() {
    UiUtils.showPopMenu(context, false, 100.w, 100.h, 0.5, 0, ColorStyles.dFinBlack, (popContext, popSetState){
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              child: SizedBox(width: 100.w, height: 100.h)
          ),
          Positioned(
              child: SizedBox(width: 100.w, height: appConfig.Config.isAndroid? 70.h : 63.h,
                  child: Container(color: ColorStyles.dFinBlack, child: UiUtils.getImage(80.w, 22.h, Image.file(File(imageFilFromCamera!.path)))))
          ),
          Positioned(
              top: appConfig.Config.isAndroid? 85.h : 80.h,
              child: Row(children: [
                UiUtils.getBorderButtonBox(30.w, ColorStyles.dFinBlack, ColorStyles.dFinBlack,
                    UiUtils.getTextWithFixedScale("취소", 13.sp, FontWeight.w300, ColorStyles.dFinWhite, TextAlign.start, null), () {
                      Navigator.pop(popContext);
                      _takeCustomCamera();
                    }),
                UiUtils.getMarginBox(20.w, 0),
                UiUtils.getBorderButtonBox(30.w, ColorStyles.dFinBlack, ColorStyles.dFinBlack,
                    UiUtils.getTextWithFixedScale("확인", 13.sp, FontWeight.w300, ColorStyles.dFinWhite, TextAlign.start, null), () {
                      XFile? image = imageFilFromCamera;
                      if(image != null){
                        isShowPickedFile = true;
                        inputHelpHeight = inputHelpPickedFileHeight;
                        GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
                        pickedFiles.add(File(image.path));
                      }else{
                        if(pickedFiles.isEmpty){
                          isShowPickedFile = false;
                          inputHelpHeight = inputHelpMinHeight;
                          GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
                        }else{
                          isShowPickedFile = true;
                          inputHelpHeight = inputHelpPickedFileHeight;
                          GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
                        }
                      }

                      GetController.to.updateShowPickedFile(isShowPickedFile);
                      Navigator.pop(popContext);
                      setState(() {});
                    })
              ])
          ),
        ],
      );
    });
  }
  void _takeCustomCamera() {
    UiUtils.showPopMenu(context, false, 100.w, 100.h, 0.5, 0, ColorStyles.dFinBlack, (popContext, popSetState){
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              child: SizedBox(width: 100.w, height: 100.h)
          ),
          Positioned(
              child: SizedBox(width: 100.w, height: appConfig.Config.isAndroid? 70.h : 63.h, child: _cameraController != null && _isCameraReady ?
              CameraPreview(_cameraController!) : Container(color: ColorStyles.dFinBlack))
          ),
          Positioned(
              top: 3.w,
              right: 3.w,
              child: UiUtils.getCloseButton(ColorStyles.dFinWhite, () {
                imageFilFromCamera = null;
                Navigator.pop(popContext);
              })
          ),
          Positioned(
              top: appConfig.Config.isAndroid? 85.h : 80.h,
              child: UiUtils.getIconButtonWithHeight(5.h, Icons.camera, 5.h, ColorStyles.dFinWhite, () {
                if(_cameraController != null){
                  _onTakePicture(popContext);
                }
              })
          ),
        ],
      );
    });
  }
  XFile? imageFilFromCamera;
  Future<void> _onTakePicture(BuildContext popContext) async {
    UiUtils.showLoadingPop(popContext);
    _cameraController!.setFlashMode(FlashMode.off);
    await _cameraController!.setFocusMode(FocusMode.locked);
    await _cameraController!.setExposureMode(ExposureMode.locked);
    imageFilFromCamera = await _cameraController!.takePicture();
    await _cameraController!.setFocusMode(FocusMode.auto);
    await _cameraController!.setExposureMode(ExposureMode.auto);
    if(popContext.mounted){
      UiUtils.closeLoadingPop(popContext);
      Navigator.pop(popContext);
      _showCapturedImage();
    }
  }

  Timer? htmlLoadTimer;
  Timer? htmlNormalLoadTimer;
  int htmlBuildCnt = 0;
  int htmlNormalLoadBuildCnt = 0;
  Timer? infiniteLoadTimer;
  int infiniteCnt = 0;
  bool isHtmlLoading = false;
  bool isNormalLoading = false;
  bool isHtmlLoadTimeOut = false;
  Widget _getHtmlView(String message, String sender, String type){
    message = message.replaceAll("*", "•");
    bool isImage = true;
    String htmlTag = "";
    String htmlTextTag = "";
    String extension = "";
    String fileName = "";
    String boldTextId = "";
    bool isFileType = true;

    if(sender == "UPFIN") {
      htmlTextTag = "<div id='typeOther'>";
      boldTextId = "boldTextOther";
    }else{
      htmlTextTag = "<div id='typeMe'>";
      boldTextId = "boldText";
    }

    if(type == "file"){
      isFileType = true;
      List<String> fileInfo = message.split('.');
      extension = fileInfo.last.toLowerCase();
      fileName = fileInfo[fileInfo.length-2].split("/").last;
      List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp'];
      if (imageExtensions.contains(extension.toLowerCase())) {
        isImage = true;
      } else {
        isImage = false;
      }

      if(isImage){
        htmlTag = """
        <a href='$message'><img src='$message'/></a>
        """;
      }else{
        htmlTag = """
        
        <p id='pType1'><text id='$boldTextId'>${extension.toUpperCase()}문서</text></p>
        <p id='pType2'><text>$fileName.$extension</text></p>
        
        """;
      }
    }else{
      isFileType = false;
      htmlTag = message;
      isImage = false;
    }

    String htmlString = """
    <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
    <body>
    $htmlTextTag $htmlTag </div>
    </body>
    """;

    return MediaQuery(
        data : MediaQuery.of(context).copyWith(textScaleFactor : 1.1),
        child : Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          HtmlWidget(
            htmlString,
            enableCaching: false,
            buildAsync: false,
            customStylesBuilder: (element) {
              isNormalLoading = true;
              if(htmlNormalLoadTimer != null) htmlNormalLoadTimer!.cancel();
              htmlNormalLoadTimer = Timer.periodic(const Duration(milliseconds: 150), (Timer timer) {
                htmlNormalLoadBuildCnt++;
                if(htmlNormalLoadBuildCnt > 2){
                  htmlNormalLoadTimer!.cancel();
                  isNormalLoading = false;
                  _scrollToBottom(false,0);
                  //GetController.to.updateHtmlLoad(true);
                }
              });


              if(element.id == 'typeMe') {
                return {
                  "color" : "white",
                  "font-size": "17sp",
                  "line-height" : "140%",
                  "font-weight": "normal",
                };
              }else if(element.id == 'typeOther') {
                return {
                  "color" : "black",
                  "font-size": "17sp",
                  "line-height" : "140%",
                  "font-weight": "normal",
                };
              }

              if(element.id == 'boldText') {
                return {
                  "color" : "white",
                  "font-size": "17sp !important",
                  "line-height" : "20%",
                  "font-weight": "bold",
                };
              }

              if(element.id == 'boldTextOther') {
                return {
                  "color" : "black",
                  "font-size": "17sp !important",
                  "line-height" : "20%",
                  "font-weight": "bold",
                };
              }

              if(element.id == 'pType1') {
                return {
                  "margin-bottom" : "0em"
                };
              }

              if(element.id == 'pType2') {
                return {
                  "margin-bottom" : "0.8em"
                };
              }

              if (element.localName == 'button') {
                if(element.id == 'buttonTypeOther') {
                  return {
                    "text-align":"center",
                    "background-color": "white", //"#3a6cff",
                    "color" : "black",
                    "font-size": "17sp !important",
                    "font-weight": "normal",
                    "border-radius":"0",
                    "border-color": "#6D6C6C",
                    "border" : "0.08px solid",
                    "padding":"13px 20px",
                    "width": "100%",
                  };
                }else if(element.id == 'buttonTypeMe'){
                  return {
                    "text-align":"center",
                    "background-color":"white",
                    "color" : "#3a6cff",
                    "font-size": "17sp !important",
                    "font-weight": "normal",
                    "border-radius":"0.1em",
                    "padding":"13px 20px",
                    "width": "100%",
                  };
                }
              }
            },

            onTapUrl: (url) async {
              if(isFileType){

              }else{
                CommonUtils.log("w", "furl : $url");
                if(url.toLowerCase() == "doc"){
                  Map<String, dynamic> inputMap = {
                    "loan_uid": currentLoanUid
                  };

                  UiUtils.showLoadingPop(context);
                  LogfinController.callLogfinApi(LogfinApis.getRetryDocs, inputMap, (isSuccess, outputJson) async {
                    UiUtils.closeLoadingPop(context);
                    if(isSuccess){
                      MyData.clearPrDocsInfoList();
                      if(outputJson!["documents"] != null){
                        for(var each in outputJson["documents"]){
                          MyData.addToPrDocsInfoList(PrDocsInfoData(each["id"], each["name"], each["del_flg"]));
                        }
                        if(MyData.getPrDocsInfoList().isNotEmpty){
                          isScrollMove = false;
                          isViewHere = false;
                          AppApplyPrViewState.isRetry = true;
                          await CommonUtils.moveToWithResult(context, appConfig.AppView.appApplyPrView.value, null);
                          isScrollMove = true;
                          isViewHere = true;
                        }else{
                          CommonUtils.flutterToast("서류 제출을 완료했어요.");
                        }
                      }else{
                        CommonUtils.flutterToast("서류 제출을 완료했어요.");
                      }
                    }else{
                      CommonUtils.flutterToast("서류목록을 가져오는데 실패했어요.\n다시 시도해주세요.");
                    }
                  });
                }else if(url.toLowerCase() == "car"){
                  _getSearchCarView();
                }else{
                  //tel:18009221
                  if(await canLaunchUrl(Uri.parse(url))){
                    await launchUrl(Uri.parse(url));
                  }else{
                    CommonUtils.flutterToast("연결할 수 없어요.");
                  }
                }
              }

              return true;
            },
            renderMode: RenderMode.column,
            textStyle: TextStyles.dFinHtmlTextStyle,
          )
        ]));
  }

  Widget _getOtherView(ChatMessageInfoData otherInfo){
    bool isImageView = false;
    Widget? otherInfoWidget;
    if(otherInfo.messageType == "text"){
      if(otherInfo.message.contains("<button") || otherInfo.message.contains("<br>")){
        otherInfoWidget = _getHtmlView(otherInfo.message, "UPFIN", otherInfo.messageType);
      }else{
        otherInfo.message = otherInfo.message.replaceAll(" / ", "\n");
        otherInfoWidget = UiUtils.getSelectableTextWithFixedScale2(otherInfo.message, 13.sp, FontWeight.w500, ColorStyles.dFinBlack, TextAlign.start, null);
      }
    }else{
      bool isValid = true;
      String extension = otherInfo.message.split('.').last.toLowerCase();
      List<String> validExtensions = LogfinController.validFileTypeList;
      if (!validExtensions.contains(extension)) {
        isValid = false;
      }

      if(isValid){
        List<String> validDocExtensions = LogfinController.validDocFileTypeList;
        if (validDocExtensions.contains(extension)) {
          List<String> fileInfo = otherInfo.message.split('.');
          String extension = fileInfo.last.toLowerCase();
          String fileName = fileInfo[fileInfo.length-2].split("/").last;
          otherInfoWidget = Row(mainAxisSize:MainAxisSize.min, crossAxisAlignment:CrossAxisAlignment.start, children: [
            UiUtils.getIcon(8.w, 10.w, Icons.file_copy_rounded, 7.w, ColorStyles.dFinRealGray),
            UiUtils.getMarginBox(1.w, 0),
            Column(mainAxisSize:MainAxisSize.min, crossAxisAlignment:CrossAxisAlignment.start, children: [
              UiUtils.getSelectableTextWithFixedScale2("${extension.toUpperCase()} 파일을 전송했습니다.", 13.sp, FontWeight.w500, ColorStyles.dFinBlack, TextAlign.start, null),
              UiUtils.getMarginBox(0, 0.1.h),
              Container(constraints: BoxConstraints(maxWidth: 60.w), child: UiUtils.getTextWithFixedScaleAndOverFlow("$fileName.$extension", 8.sp, FontWeight.w300, ColorStyles.dFinDarkGray, TextAlign.start, null))
            ])
          ]);
        }else{
          isImageView = true;
          otherInfoWidget = _getImageView(otherInfo.message);
        }
      }else{
        otherInfoWidget = UiUtils.getTextWithFixedScale("${extension.toUpperCase()} 파일은 지원히지 않습니다.", 13.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.start, null);
      }
    }

    return Container(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.w, bottom: 2.w),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              isImageView? Container() : CustomPaint(
                painter: ChatBubbleTriangleForOther(),
              ),
              Container(
                  constraints: BoxConstraints(maxWidth:  isImageView? 63.w : 73.w),
                  padding: isImageView? EdgeInsets.zero : EdgeInsets.only(left:3.w, right:3.w, top: 4.w, bottom: 4.w),
                  decoration: BoxDecoration(
                    borderRadius: isImageView? const BorderRadius.only(topRight: Radius.circular(1), topLeft: Radius.circular(1), bottomRight: Radius.circular(1))
                      : const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                    color: isImageView? ColorStyles.dFinWhite : ColorStyles.dFinWhiteGray,
                  ),
                  child: otherInfoWidget
              ),
              UiUtils.getMarginBox(1.w, 0),
              UiUtils.getTextWithFixedScale(CommonUtils.getFormattedLastMsgTime(otherInfo.messageTime), 8.sp, FontWeight.w400, ColorStyles.dFinDarkGray, TextAlign.start, null)
            ]),
            UiUtils.getMarginBox(0, 1.h)
          ]),
        ])
    );
  }

  Widget _getOtherForLoadingView(){
    return Container(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.w, bottom: 2.w),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              CustomPaint(
                painter: ChatBubbleTriangleForOther(),
              ),
              Container(
                  constraints: BoxConstraints(maxWidth: 63.w),
                  padding: EdgeInsets.all(3.w),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                    color: ColorStyles.dFinWhiteGray,
                  ),
                  child: UiUtils.getImage(5.w, 5.w, Image.asset(fit: BoxFit.fill,'assets/images/chat_loading.gif'))
              ),
            ]),
            UiUtils.getMarginBox(0, 1.h)
          ]),
        ])
    );
  }

  Widget _getOtherLoadingTextView(){
    String message = "업핀 담당자가 안내를 드릴게요.\n잠시만 기다려주세요.";

    return Container(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.w, bottom: 2.w),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              CustomPaint(painter: ChatBubbleTriangleForOther()),
              Container(
                  constraints: BoxConstraints(maxWidth: 73.w),
                  padding: EdgeInsets.all(3.w),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                    color: ColorStyles.dFinWhiteGray,
                  ),
                  child:  UiUtils.getSelectableTextWithFixedScale2(message, 13.sp, FontWeight.w500, ColorStyles.dFinBlack, TextAlign.start, null)
              ),
              UiUtils.getMarginBox(1.w, 0),
              UiUtils.getTextWithFixedScale("", 8.sp, FontWeight.w400, ColorStyles.dFinDarkGray, TextAlign.start, null)
            ]),
            UiUtils.getMarginBox(0, 1.h)
          ]),
        ])
    );
  }

  Future<void> _loadImageAsync(String src) async {
    if(!cachedImage.containsKey(src)){
      //await Future.delayed(const Duration(seconds: 2));
    }
  }

  Widget _getImageView(String srcUrl){
    final mediaQueryData = MediaQuery.of(context);
    final devicePixelRatio = mediaQueryData.devicePixelRatio;
    bool isLoading = true;
    return GestureDetector(
        child: FutureBuilder(
          future: _loadImageAsync(srcUrl), // 이미지 로딩을 처리하는 비동기 함수
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: ColorStyles.dFinWhite,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  constraints: BoxConstraints(maxWidth: 60.w, maxHeight: 60.w, minWidth: 20.w, minHeight: 20.w),
                  child:ExtendedImage.network(
                    srcUrl,
                    fit: BoxFit.contain,
                    cache: true,
                    cacheHeight: (30.w*devicePixelRatio).round().toInt(),
                    cacheMaxAge: const Duration(hours: 1),
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    loadStateChanged: (ExtendedImageState state) {
                      switch (state.extendedImageLoadState) {
                        case LoadState.loading:
                          _aniController.reset();
                          if(state.loadingProgress != null && state.loadingProgress!.expectedTotalBytes != null){
                            int total = state.loadingProgress!.expectedTotalBytes!;
                            int val = state.loadingProgress!.cumulativeBytesLoaded;
                            return Center(
                                child: CircularProgressIndicator(
                                    color: ColorStyles.dFinWhite,
                                    value: val / total
                                )
                            );
                          }else{
                            return UiUtils.getImage(8.w, 8.w, Image.asset(fit: BoxFit.fill,'assets/images/chat_loading.gif'));
                          }
                        case LoadState.completed:
                          isLoading = false;
                          _aniController.forward();
                          cachedImage[srcUrl] = true;
                          return FadeTransition(
                            opacity: _aniController,
                            child: AspectRatio(aspectRatio: 1, child: ExtendedRawImage(
                              fit: state.extendedImageInfo!.image.width >= state.extendedImageInfo!.image.height ? BoxFit.fitHeight : BoxFit.fitWidth,
                              image: state.extendedImageInfo?.image,
                            )),
                          );
                        case LoadState.failed:
                          _aniController.reset();
                          if(cachedImage.containsKey(srcUrl)){
                            cachedImage.remove(srcUrl);
                          }
                          return GestureDetector(
                            child: UiUtils.getIcon(10.w, 10.w, Icons.refresh_rounded, 10.w, ColorStyles.dFinRed),
                            onTap: () {
                              state.reLoadImage();
                            },
                          );
                      }
                    },
                  )
              );
            } else {
              // 이미지 로딩 중에 표시할 로딩 표시 등을 추가할 수 있습니다.
              return Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: ColorStyles.dFinWhiteGray,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  constraints: BoxConstraints(maxWidth: 60.w, maxHeight: 60.w, minWidth: 20.w, minHeight: 20.w),
                  child:UiUtils.getImage(8.w, 8.w, Image.asset(fit: BoxFit.fill,'assets/images/chat_loading.gif'))
              );
            }
          },
        ),
        onTap: ()  {
          if(!isLoading){
            UiUtils.showPopMenu(context, true, 100.w, 100.h, 0.5, 0, ColorStyles.dFinBlack, (slideContext, slideSetState){
              Widget slideWidget = Column(children: [
                SizedBox(width: 97.w, child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  UiUtils.getCloseButton(ColorStyles.dFinWhite, () {
                    Navigator.pop(slideContext);
                  })
                ])),
                UiUtils.getMarginBox(0, 4.h),
                Container(
                    color:ColorStyles.dFinBlack,
                    width: 90.w, height: appConfig.Config.isAndroid? 75.h : 70.h,
                    child: InteractiveViewer(
                        constrained: false,
                        child: Container(
                            color:ColorStyles.dFinBlack,
                            alignment: Alignment.center,
                            constraints: BoxConstraints(maxWidth: 90.w, maxHeight: appConfig.Config.isAndroid? 75.h : 70.h, minWidth: 20.w, minHeight: 20.w),
                            child: ExtendedImage.network(
                              srcUrl,
                              fit: BoxFit.contain,
                              cache: true,
                              cacheMaxAge: const Duration(hours: 1),
                              shape: BoxShape.rectangle,
                              borderRadius: const BorderRadius.all(Radius.circular(3)),
                              loadStateChanged: (ExtendedImageState state) {
                                switch (state.extendedImageLoadState) {
                                  case LoadState.loading:
                                    _aniController.reset();
                                    if(state.loadingProgress != null && state.loadingProgress!.expectedTotalBytes != null){
                                      int total = state.loadingProgress!.expectedTotalBytes!;
                                      int val = state.loadingProgress!.cumulativeBytesLoaded;
                                      return Center(
                                          child: CircularProgressIndicator(
                                              color: ColorStyles.dFinWhite,
                                              value: val / total
                                          )
                                      );
                                    }else{
                                      return UiUtils.getImage(8.w, 8.w, Image.asset(fit: BoxFit.fill,'assets/images/chat_loading.gif'));
                                    }
                                  case LoadState.completed:
                                    _aniController.forward();

                                    return FadeTransition(
                                      opacity: _aniController,
                                      child: ExtendedRawImage(
                                        image: state.extendedImageInfo?.image,
                                        fit: BoxFit.contain,
                                      ),
                                    );
                                  case LoadState.failed:
                                    _aniController.reset();
                                    return GestureDetector(
                                      child: UiUtils.getIcon(10.w, 10.w, Icons.refresh_rounded, 10.w, ColorStyles.dFinRed),
                                      onTap: () {
                                        state.reLoadImage();
                                      },
                                    );
                                }
                              },
                            )
                        )
                    )),
                UiUtils.getExpandedScrollView(Axis.vertical, Container()),
                appConfig.Config.isAndroid? UiUtils.getMarginBox(0, 1.h) :UiUtils.getMarginBox(0, 2.h),
              ]);
              return slideWidget;
            });
          }
        });
  }

  Widget _getMeView(ChatMessageInfoData meInfo){
    Widget? meInfoWidget;
    bool isImageView = false;
    if(meInfo.messageType == "text"){
      meInfoWidget = UiUtils.getSelectableTextWithFixedScale2(meInfo.message, 13.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.start, null);
    }else{
      String extension = meInfo.message.split('.').last.toLowerCase();
      if(extension == "upfin_web"){
        String fullMsg = meInfo.message.split(".").first;
        String sCnt = "0";
        String sMsg = "";
        String fCnt = "0";
        String fMsg = "";
        if(fullMsg.contains("@")){
          sCnt = fullMsg.split("@").first;
          fCnt = fullMsg.split("@").last;
          if(int.parse(sCnt) != 0){
            sMsg = "성공 $sCnt개";
          }

          if(int.parse(fCnt) != 0){
            fMsg = "실패 $fCnt개";
          }

          bool isAllSuccess = true;
          if(int.parse(sCnt) + int.parse(fCnt) != int.parse(sCnt)){
            isAllSuccess = false;
          }

          if(isAllSuccess){
            meInfoWidget = Column(mainAxisSize:MainAxisSize.min, crossAxisAlignment:CrossAxisAlignment.start, children: [
              Row(mainAxisSize:MainAxisSize.min, children: [
                UiUtils.getIcon(7.w, 7.w, Icons.file_copy_rounded, 7.w, ColorStyles.dFinWhite),
                UiUtils.getMarginBox(2.w, 0),
                UiUtils.getSelectableTextWithFixedScale2("${int.parse(sCnt) + int.parse(fCnt)}개 파일을 모두 전송했습니다.", 13.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.start, null)
              ])
            ]);
          }else{
            meInfoWidget = Row(mainAxisSize:MainAxisSize.min, crossAxisAlignment:CrossAxisAlignment.start, children: [
              UiUtils.getIcon(8.w, 10.w, Icons.file_copy_rounded, 7.w, ColorStyles.dFinWhite),
              UiUtils.getMarginBox(2.w, 0),
              Column(mainAxisSize:MainAxisSize.min, crossAxisAlignment:CrossAxisAlignment.start, children: [
                UiUtils.getSelectableTextWithFixedScale2("${int.parse(sCnt) + int.parse(fCnt)}개 파일을 전송했습니다.", 13.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.start, null),
                UiUtils.getMarginBox(0, 0.05.h),
                Row(mainAxisSize:MainAxisSize.min, children: [
                  UiUtils.getSelectableTextWithFixedScale2("(결과 : ", 10.sp, FontWeight.w300, ColorStyles.dFinWhite, TextAlign.start, null),
                  sMsg != "" ? UiUtils.getSelectableTextWithFixedScale2("$sMsg${int.parse(fCnt) != 0 ? "," : ")"}", 10.sp, FontWeight.w300, ColorStyles.dFinWhite, TextAlign.start, null) : UiUtils.getMarginBox(0, 0),
                  sMsg != "" ? UiUtils.getMarginBox(1.w, 0) : UiUtils.getMarginBox(0, 0),
                  fMsg != "" ? UiUtils.getSelectableTextWithFixedScale2("$fMsg)", 10.sp, FontWeight.w300, ColorStyles.dFinWhite, TextAlign.start, null) : UiUtils.getMarginBox(0, 0),
                ])
              ])
            ]);
          }
        }else{
          meInfoWidget = UiUtils.getSelectableTextWithFixedScale2("파일전송 메시지 오류", 13.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.start, null);
        }
      }else{
        List<String> validDocExtensions = LogfinController.validDocFileTypeList;
        if (validDocExtensions.contains(extension)) {
          //meInfoWidget = _getHtmlView(meInfo.message, "ME", meInfo.messageType);
          List<String> fileInfo = meInfo.message.split('.');
          String extension = fileInfo.last.toLowerCase();
          String fileName = fileInfo[fileInfo.length-2].split("/").last;
          meInfoWidget = Row(mainAxisSize:MainAxisSize.min, crossAxisAlignment:CrossAxisAlignment.start, children: [
            UiUtils.getIcon(8.w, 10.w, Icons.file_copy_rounded, 7.w, ColorStyles.dFinWhite),
            UiUtils.getMarginBox(1.w, 0),
            Column(mainAxisSize:MainAxisSize.min, crossAxisAlignment:CrossAxisAlignment.start, children: [
              UiUtils.getSelectableTextWithFixedScale2("${extension.toUpperCase()} 파일을 전송했습니다.", 13.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.start, null),
              UiUtils.getMarginBox(0, 0.1.h),
              Container(constraints: BoxConstraints(maxWidth: 60.w), child: UiUtils.getTextWithFixedScaleAndOverFlow("$fileName.$extension", 8.sp, FontWeight.w300, ColorStyles.dFinWhiteGray, TextAlign.start, null))
            ])
          ]);
        }else{
          List<String> validExtensions = LogfinController.validFileTypeList;
          if(validExtensions.contains(extension)){
            meInfoWidget = _getImageView(meInfo.message);
            isImageView = true;
          }else{
            meInfoWidget = UiUtils.getTextWithFixedScale("${extension.toUpperCase()} 파일은 지원히지 않습니다.", 13.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.start, null);
          }
        }
      }
    }

    return Container(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.w, bottom: 2.w),
        width: 100.w,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            UiUtils.getTextWithFixedScale(CommonUtils.getFormattedLastMsgTime(meInfo.messageTime), 8.sp, FontWeight.w400, ColorStyles.dFinDarkGray, TextAlign.start, null),
            UiUtils.getMarginBox(1.w, 0),
            Container(
                constraints: BoxConstraints(maxWidth: isImageView? 63.w : 73.w),
                padding: isImageView? EdgeInsets.zero : EdgeInsets.only(left:3.w,right:3.w, top:4.w, bottom:4.w),
                decoration: BoxDecoration(
                  borderRadius: isImageView? const BorderRadius.only(topRight: Radius.circular(1), topLeft: Radius.circular(1), bottomLeft: Radius.circular(1))
                      : const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                  color: isImageView? ColorStyles.dFinWhite : ColorStyles.dFinTextAndBorderBlue,
                ),
                child: meInfoWidget
            ),
            isImageView? Container() : CustomPaint(
              painter: ChatBubbleTriangleForMe(),
            ),
          ]),
        ])
    );
  }

  Widget _getMeViewForLoading(){
    return Container(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.w, bottom: 2.w),
        width: 100.w,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
                constraints: BoxConstraints(maxWidth: 63.w),
                padding: EdgeInsets.all(3.w),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                  color: ColorStyles.dFinTextAndBorderBlue
                ),
                child: UiUtils.getImage(5.w, 5.w, Image.asset(fit: BoxFit.fill,'assets/images/chat_loading.gif'))
            ),
            CustomPaint(
              painter: ChatBubbleTriangleForMe(),
            )
          ]),
        ])
    );
  }

  List<Widget> _getChatList(){
    List<Widget> chatList = [];
    int upFinChatCnt = 0;

    for(var each in GetController.to.chatMessageInfoDataList){
      if(each.senderName == "UPFIN"){
        upFinChatCnt++;
        chatList.add(_getOtherView(each));
      }else{
        chatList.add(_getMeView(each));
      }
    }

    if(upFinChatCnt == 0) {
      String defaultIntroMessage = Config.defaultMessage;
      ChatMessageInfoData defaultMessageInfo = ChatMessageInfoData("0", currentRoomId, defaultIntroMessage.replaceAll("@", "\n"), CommonUtils.convertTimeToString(DateTime.parse(MyData.userChatRoomInfo["created_at"]).toLocal()), "text", "UPFIN", "");
      chatList.insert(0, _getOtherView(defaultMessageInfo));
    }

    if(GetController.to.chatMessageInfoDataList.isNotEmpty){
      if(WebSocketController.isWaitingForAnswerState(currentRoomId, "ME")){
        chatList.add(_getMeViewForLoading());
      }

      if(WebSocketController.isWaitingForAnswerState(currentRoomId, "UPFIN")){
        if(isUserChatRoom){
          // chatList.add(_getOtherLoadingTextView());
        }
        chatList.add(_getOtherForLoadingView());
      }else{
        if(GetController.to.chatMessageInfoDataList.last.senderName == MyData.name){
          if(isUserChatRoom){
            //chatList.add(_getOtherLoadingTextView());
          }
          //chatList.add(_getOtherForLoadingView());
        }
      }
    }

    _scrollToBottom(false,0);

    return chatList;
  }

  Future<void> _back() async {
    if(backPossibleFlag){
      backPossibleFlag = false;
      isViewHere = false;
      Navigator.pop(context);
      LogfinController.callLogfinApi(LogfinApis.checkMessage, {"pr_room_id" : currentRoomId}, (isSuccess, outputJson){
        if(!isSuccess){
          //CommonUtils.flutterToast("메시지를 읽는중\n오류가 발생했어요.");
        }
        if(scrollCheckTimer != null) scrollCheckTimer!.cancel();
        _chatTextFocus.unfocus();
        backPossibleFlag =true;
      });
      CommonUtils.hideKeyBoard();
      CommonUtils.saveSettingsToFile("push_from", "");
      CommonUtils.saveSettingsToFile("push_room_id", "");
      FireBaseController.setNotificationTorF(true);
    }
  }

  Future<void> _scrollToBottom(bool doDelay, int delayTime) async {
    if(isBuild){
      if(!isScrollMove){
        if(doDelay){
          await Future.delayed(Duration(milliseconds: delayTime), () async {});
        }

        if(_chatScrollController.hasClients){
          _chatScrollController.jumpTo(_chatScrollController.position.maxScrollExtent);
        }
      }
    }
  }

  Widget _getWeekendInfoWidgetForUserChat(){
    return Column(crossAxisAlignment:CrossAxisAlignment.center, children: [
      UiUtils.getTextWithFixedScale2(Config.defaultMessageForWeekend.replaceAll("@", "\n"), 11.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.start, null),
    ]);
  }

  Widget _getTimelineWidget(){
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GetController.to.chatStatusTick.value>0?_stepTick(0, true):_stepTick(0, false),
            GetController.to.chatStatusTick.value>1? _stepLine(true) : _stepLine(false),
            GetController.to.chatStatusTick.value>1?_stepTick(1, true):_stepTick(1, false),
            GetController.to.chatStatusTick.value>2? _stepLine(true) : _stepLine(false),
            GetController.to.chatStatusTick.value>2?_stepTick(2, true):_stepTick(2, false)
          ]),
      UiUtils.getMarginBox(0, 1.5.h),
      UiUtils.getMarginColoredBox(100.w, 0.12.h, ColorStyles.dFinGray)

    ]);
  }
  Widget _stepTick(int type, bool isChecked){
    String typeString = "";
    bool passed = false;
    if(type == 0){
      typeString = "접수";
      if(GetController.to.chatStatusTick.value > 1){
        passed = true;
      }
    }else if(type == 1){
      typeString = "심사";
      if(GetController.to.chatStatusTick.value > 2){
        passed = true;
      }
    }else{
      typeString = "통보";
    }

    return Column(children: [
      isChecked? passed? UiUtils.getIcon(3.w, 3.w, Icons.radio_button_checked_rounded, 3.w, ColorStyles.dFinButtonBlue)
          : UiUtils.getIcon(3.w, 3.w, Icons.circle, 3.w, ColorStyles.dFinButtonBlue)
            : UiUtils.getIcon(3.w, 3.w, Icons.radio_button_unchecked_rounded, 3.w, ColorStyles.dFinWhiteSky),
      UiUtils.getMarginBox(0, 1.5.h),
      UiUtils.getTextWithFixedScale(typeString, 9.sp, FontWeight.w600, ColorStyles.dFinRealGray, TextAlign.center, null),
    ]);
  }

  Widget _stepLine(bool isReached) {
    return Column(children: [
      UiUtils.getMarginBox(0, 0.5.h),
      Container(
        color: isReached? ColorStyles.dFinButtonBlue : ColorStyles.dFinWhiteSky,
        height: 0.15.h,
        width: 36.w,
      )
    ]);
  }

  Future<void> _setPickedImgFromCamera() async {
    if(pickedFiles.length <= maximumSize){
      if(pickedFiles.length == maximumSize){
        CommonUtils.flutterToast("최대 $maximumSize개의 파일만\n전송할 수 있어요.");
      }else{
        _takeCustomCamera();
      }
    }else{
      CommonUtils.flutterToast("최대 $maximumSize개의 파일만\n전송할 수 있습니다.");
    }
  }

  String currentKey = "";
  String _findValueForKey(Map<String, dynamic> map, String targetKey) {
    String resultValue = "";

    void searchValue(Map<String, dynamic> currentMap, String currentKey) {
      if (currentMap.containsKey(currentKey)) {
        resultValue = currentMap[currentKey];
        return;
      }

      currentMap.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          searchValue(value, targetKey);
        }
      });
    }

    searchValue(map, targetKey);
    return resultValue;
  }
  List<String> _getAnswerListMap(String targetKey){
    List<String> childKeys = [];
    if(targetKey == ""){
      LogfinController.autoAnswerMap.forEach((key, value) {
        childKeys.add(key);
      });
      return childKeys;
    }else{
      void searchChildKeys(Map<String, dynamic> currentMap) {
        currentMap.forEach((key, value) {
          if (key == targetKey && value is Map<String, dynamic>) {
            childKeys.addAll(value.keys);
          }
          if (value is Map<String, dynamic>) {
            searchChildKeys(value);
          }
        });
      }

      searchChildKeys(LogfinController.autoAnswerMap);

      return childKeys;
    }
  }
  String _findPrevKey(String targetKey) {
    String parentKey = "";

    void searchParentKey(Map<String, dynamic> currentMap, String currentParent) {
      if (currentMap.containsKey(targetKey)) {
        parentKey = currentParent;
      }else{
        currentMap.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            searchParentKey(value, key);
          }
        });
      }
    }

    searchParentKey(LogfinController.autoAnswerMap, "");
    CommonUtils.log("", "parentKey : $parentKey");
    return parentKey;
  }

  int _getLineFromAutoAnswerWidgetList(List<Widget> listWidget){
    int cnt = 1;
    for(int i = 0 ; i < listWidget.length ; i++){
      if(listWidget[i].key != null){
        cnt++;
      }
    }

    return cnt;
  }
  List<Widget> widgetList = [];
  void _setAutoAnswerWidgetList(){
    widgetList.clear();
    GetController.to.resetChatAutoAnswerWidgetList();
    List<String> answerList = _getAnswerListMap(currentKey);
    if(currentKey != "" && !isUserChatRoom){
      answerList.add("이전");
    }
    for(var each in answerList){
      Color borderColor = ColorStyles.dFinGray;
      Color fillColor = ColorStyles.dFinWhite;
      Color textColor = ColorStyles.dFinBlack;
      if(each.contains("이전")){
        borderColor = ColorStyles.dFinBlack;
        fillColor = ColorStyles.dFinBlack;
        textColor = ColorStyles.dFinWhite;
      }
      if(each.contains("맨아래")){
        borderColor = ColorStyles.dFinRealGray;
        fillColor = ColorStyles.dFinRealGray;
        textColor = ColorStyles.dFinWhite;
      }

      if(each.contains("자주하는 질문")){
       // widgetList.add(Container(key: UniqueKey()));
      }

      if(each.contains("파일첨부")){
       // widgetList.add(Container(key: UniqueKey()));
      }

      if(each.contains("상환일정")){
       // widgetList.add(Container(key: UniqueKey()));
      }

      if(each.contains("미납")){
       // widgetList.add(Container(key: UniqueKey()));
      }

      if(each.contains("사진")){
       // widgetList.add(Container(key: UniqueKey()));
      }

      if(each.contains("이전")){
        if(answerList.length != 1){
          widgetList.add(Container(key: UniqueKey()));
        }
      }

      widgetList.add(
          GestureDetector(
              child: UiUtils.getRoundedBoxTextWithFixedScale(each, 11.sp, FontWeight.w500, TextAlign.center, borderColor, fillColor, textColor),
      onTap: () async {
        currentKey = each;
        isScrollMove = false;
        _scrollToBottom(false, 0);
        if(each.contains("카메라")){
          _showCamera();
        }else if(each.split(" ").first == "파일"){
          _showFileUploadWebView();
        }else if(each.contains("채팅")){
          inputTextHide = false;
          GetController.to.updateInputTextHide(inputTextHide);
          _setAutoAnswerWidgetList();
          setState(() {});
        }else if(each.contains("이전")){
          CommonUtils.log("","fcm : ${FireBaseController.fcmToken}");
          pickedFiles.clear();
          inputHelpHeight = inputHelpMinHeight;
          GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
          isShowPickedFile = false;
          GetController.to.updateShowPickedFile(isShowPickedFile);
          setState(() {});
          inputTextHide = true;
          GetController.to.updateInputTextHide(inputTextHide);
          String tempKey = _findPrevKey(answerList[0]);
          currentKey = _findPrevKey(tempKey);
          _setAutoAnswerWidgetList();
          setState(() {});
        }else{
          if(_getAnswerListMap(each).isNotEmpty){
            _setAutoAnswerWidgetList();
            setState(() {});
          }else{
            String result = _findValueForKey(LogfinController.autoAnswerMap, currentKey);
            _sendMessage("", result);

          }
        }
      }));
    }

    GetController.to.updateChatAutoAnswerWidgetList(widgetList);
  }

  Future<void> _showCamera() async {
    var cameraPermission = Permission.camera;
    var cameraStatus = await cameraPermission.request();
    if(cameraStatus.isGranted){
      if(!_isCameraReady){
        availableCameras().then((cameras) {
          if (cameras.isNotEmpty && _cameraController == null) {
            _cameraController = CameraController(
                cameras.first,
                ResolutionPreset.medium,
                enableAudio: false
            );

            _cameraController!.initialize().then((_) {
              _cameraController!.setFlashMode(FlashMode.off);
              setState(() {
                _isCameraReady = true;
                _setPickedImgFromCamera();
              });
            });
          }
        });
      }else{
        _setPickedImgFromCamera();
      }
    }else{
      if(context.mounted){
        UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, true, null, Config.isAndroid ? Config.isPad()? 32.h : 22.h : Config.isPad()? 37.h : 27.h, 0.5, (slideContext, setState){
          return Column(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UiUtils.getMarginBox(100.w, 1.h),
                Column(children: [
                  SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale2("촬영을위한 카메라 권한이 필요해요.",14.sp, FontWeight.w600, ColorStyles.dFinBlack, TextAlign.center, null)),
                  UiUtils.getMarginBox(0, 1.h),
                  SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale2("설정에서 카메라 권한을 허용 해주세요",12.sp, FontWeight.w500, ColorStyles.dFinBlack, TextAlign.center, null))
                ]),
                UiUtils.getExpandedScrollView(Axis.vertical, Container()),
                UiUtils.getBorderButtonBox(90.w, ColorStyles.dFinButtonBlue, ColorStyles.dFinButtonBlue,
                    UiUtils.getTextWithFixedScale("설정 바로가기", 12.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.start, null), () async {
                      Navigator.pop(slideContext);
                      openAppSettings();
                    }),
                Config.isAndroid ? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 5.h),
              ]
          );
        });
      }
    }
  }

  Future<void> _showFileUploadWebView() async {
    var micPermission = Permission.microphone;
    var micStatus = await micPermission.request();
    if(micStatus.isGranted){
      if(context.mounted){
        var cameraPermission = Permission.camera;
        var cameraStatus = await cameraPermission.request();
        if(cameraStatus.isGranted){
          if(!_isCameraReady){
            availableCameras().then((cameras) {
              if (cameras.isNotEmpty && _cameraController == null) {
                _cameraController = CameraController(
                    cameras.first,
                    ResolutionPreset.medium,
                    enableAudio: false
                );
                _cameraController!.initialize().then((_) async {
                  _cameraController!.setFlashMode(FlashMode.off);
                  _isCameraReady = true;
                  if(context.mounted){
                    List<int> resultCntArr = await CommonUtils.moveToWithResult(context, AppView.appWebView.value, null) as List<int>;
                    appConfig.Config.contextForEmergencyBack = context;
                    appConfig.Config.isEmergencyRoot = false;
                    CommonUtils.log("i","resultCntArr : $resultCntArr");
                    _scrollToBottom(true, 300);
                  }
                });
              }
            });
          }else{
            if(context.mounted){
              List<int> resultCntArr = await CommonUtils.moveToWithResult(context, AppView.appWebView.value, null) as List<int>;
              appConfig.Config.contextForEmergencyBack = context;
              appConfig.Config.isEmergencyRoot = false;
              CommonUtils.log("i","resultCntArr : $resultCntArr");
              _scrollToBottom(true, 300);
            }
          }
        }else{
          if(context.mounted){
            UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, true, null, Config.isAndroid ? Config.isPad()? 32.h : 22.h : Config.isPad()? 37.h : 27.h, 0.5, (slideContext, setState){
              return Column(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    UiUtils.getMarginBox(100.w, 1.h),
                    Column(children: [
                      SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale2("촬영을위한 카메라 권한이 필요해요.",14.sp, FontWeight.w600, ColorStyles.dFinBlack, TextAlign.center, null)),
                      UiUtils.getMarginBox(0, 1.h),
                      SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale2("설정에서 카메라 권한을 허용 해주세요",12.sp, FontWeight.w500, ColorStyles.dFinBlack, TextAlign.center, null))
                    ]),
                    UiUtils.getExpandedScrollView(Axis.vertical, Container()),
                    UiUtils.getBorderButtonBox(90.w, ColorStyles.dFinButtonBlue, ColorStyles.dFinButtonBlue,
                        UiUtils.getTextWithFixedScale("설정 바로가기", 12.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.start, null), () async {
                          Navigator.pop(slideContext);
                          openAppSettings();
                        }),
                    Config.isAndroid ? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 5.h),
                  ]
              );
            });
          }
        }
      }
    }else{
      if(context.mounted){
        UiUtils.showSlideMenu(context, SlideMenuMoveType.bottomToTop, true, null, Config.isAndroid ? Config.isPad()? 32.h : 22.h : Config.isPad()? 37.h : 27.h, 0.5, (slideContext, setState){
          return Column(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UiUtils.getMarginBox(100.w, 1.h),
                Column(children: [
                  SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale2("파일전송을위한 마이크 권한이 필요해요.",14.sp, FontWeight.w600, ColorStyles.dFinBlack, TextAlign.center, null)),
                  UiUtils.getMarginBox(0, 1.h),
                  SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale2("설정에서 마이크 권한을 허용 해주세요",12.sp, FontWeight.w500, ColorStyles.dFinBlack, TextAlign.center, null))
                ]),
                UiUtils.getExpandedScrollView(Axis.vertical, Container()),
                UiUtils.getBorderButtonBox(90.w, ColorStyles.dFinButtonBlue, ColorStyles.dFinButtonBlue,
                    UiUtils.getTextWithFixedScale("설정 바로가기", 12.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.start, null), () async {
                      Navigator.pop(slideContext);
                      openAppSettings();
                    }),
                Config.isAndroid ? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 5.h),
              ]
          );
        });
      }
    }



    /*
    if(resultCntArr.length == 2){
      if(!(resultCntArr[0] == 0 && resultCntArr[1] == 0)){
        int sCnt = resultCntArr[0];
        int fCnt = resultCntArr[1];
        String resultMsg = "";
        resultMsg += "$sCnt";
        resultMsg += "@$fCnt";

        _sendMessage("$resultMsg.upfin_web", "file");
      }
    }
     */
  }

  Future<void> _sendFileToAws() async {
    int cnt = 0;
    int failCnt = 0;
    UiUtils.showLoadingPop(context);
    for(var each in pickedFiles){
      await AwsController.uploadFileToAWS(each.path, "${AwsController.chatFilesDir}/${MyData.email}/${CommonUtils.convertTimeToString(CommonUtils.getCurrentLocalTime())}", (isSuccess, resultUrl){
        UiUtils.closeLoadingPop(context);
        cnt++;
        if(!isSuccess){
          failCnt++;
        }
        if(cnt == pickedFiles.length){
          if(failCnt > 0){
            CommonUtils.flutterToast("파일 전송중 에러가\n발생했습니다.");
          }else{
            _sendMessage(resultUrl,"");
            pickedFiles.clear();
            inputHelpHeight = inputHelpMinHeight;
            GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
            isShowPickedFile = false;
            GetController.to.updateShowPickedFile(isShowPickedFile);
          }
        }
      });

    }
  }

  void _sendMessage(String message, String customMessageType) {

    /*
    if(!WebSocketController.isWaitingForAnswerState(currentRoomId, "ME")){

    }else{
      CommonUtils.flutterToast("응답을 기다리는 중입니다.");
    }
     */

    GetController.to.updateAutoAnswerWaiting(true);

    var inputJson = {
      "loan_uid" : currentLoanUid,
      "message" : message
    };

    WebSocketController.setWaitingState(currentRoomId, "ME", true);

    if(pickedFiles.isEmpty){
      // message, custom message
      if(customMessageType != ""){
        if(customMessageType == "file"){
          inputJson["type"] = "file";
        }else{
          inputJson["type"] = "custom";
          inputJson["message"] = customMessageType;
        }
      }else{
        inputJson["type"] = "text";
      }
      if(!isUserChatRoom) WebSocketController.setWaitingState(currentRoomId, "UPFIN", true);
    }else{
      // file
      inputJson["type"] = "file";
    }

    if(!isScrollMove) setState(() {});

    CommonUtils.log("i", "send MSG : $inputJson");
    LogfinController.callLogfinApi(LogfinApis.sendMessage, inputJson, (isSuccess, _){
      GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
      if(!isSuccess){
        CommonUtils.flutterToast("메시지 전송중\n오류가 발생했습니다.");
      }

      if(isUserChatRoom){
        WebSocketController.setWaitingState(currentRoomId, "UPFIN", false);
      }

      _scrollToBottom(true, 300);
    });
  }

  bool isShowPickedFile = false;
  List<File> pickedFiles = [];
  int maximumSize = 1;
  Widget _getPickedFilesWidget(){
    List<Widget> widgetList = [];
    for(int i = 0 ; i < pickedFiles.length ; i++){
      bool isImage = true;
      String extension = pickedFiles[i].path.split('.').last.toLowerCase();
      List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp'];
      if (imageExtensions.contains(extension)) {
        isImage = true;
      } else {
        isImage = false;
      }

      String fileName = pickedFiles[i].uri.pathSegments.last; // 파일명 + 확장자
      //String basename = pickedFiles[i].uri.pathSegments.last.split('.').first; // 파일명\
      widgetList.add(
          Container(
              width: 22.w, height: 17.h,
              decoration: const BoxDecoration(
                  color: ColorStyles.dFinWhite
              ),
              child: SizedBox(
                width: 21.w,
                height: 16.h,
                child: Column(mainAxisAlignment:MainAxisAlignment.end, crossAxisAlignment:CrossAxisAlignment.center, children: [
                  Row(children: [
                    const Spacer(flex: 2),
                    GestureDetector(onTap: (){
                      pickedFiles.removeAt(i);
                      CommonUtils.log("i","click!!");
                      if(pickedFiles.isEmpty){
                        inputHelpHeight = inputHelpMinHeight;
                        GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
                        isShowPickedFile = false;
                        GetController.to.updateShowPickedFile(isShowPickedFile);
                      }else{
                        inputHelpHeight = inputHelpPickedFileHeight;
                        GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
                        isShowPickedFile = true;
                        GetController.to.updateShowPickedFile(isShowPickedFile);
                      }
                      setState(() {});
                    },
                        child: Container(
                            width: 7.w, height: 2.h,
                            padding: EdgeInsets.only(top: 0.2.h),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                color: ColorStyles.dFinBlack),
                            child: Center(child: UiUtils.getTextWithFixedScale("✕", 7.sp, FontWeight.w600, ColorStyles.dFinWhite, TextAlign.center, 1))
                        )),
                    UiUtils.getMarginBox(0.5.w, 0)
                  ]),
                  isImage? Container(
                      padding: EdgeInsets.all(0.3.w),
                      decoration: const BoxDecoration(color: ColorStyles.dFinBlack, borderRadius: BorderRadius.all(Radius.circular(0))),
                      width: 21.w,
                      height: 14.8.h,
                      child: Image.file(File(pickedFiles[i].path), fit: BoxFit.fill)
                  ) : Container(
                      padding: EdgeInsets.only(top:0.3.w, bottom: 0.3.w, left: 2.w, right: 2.w),
                      decoration: const BoxDecoration(color: ColorStyles.dFinBlack, borderRadius: BorderRadius.all(Radius.circular(0))),
                      width: 21.w,
                      height: 14.8.h,
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [UiUtils.getMarginBox(0, 1.2.h),
                        UiUtils.getIcon(19.5.w, 5.h, Icons.folder_copy_outlined, 5.h, ColorStyles.dFinWhite), UiUtils.getMarginBox(0, 0.5.h),
                        UiUtils.getExpandedScrollView(Axis.vertical, UiUtils.getTextWithFixedScale(fileName, 10.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.center, null))
                      ])
                  )
                ]),
          )
      )
          /*
          Stack(alignment:Alignment.bottomLeft, children: [
            Container(width: 22.5.w, height: 17.h,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: ColorStyles.upFinWhite
                )),
            Positioned(
                left: 1.w,
                bottom: 1.w,
                child: Container(
                  width: 20.w,
                  height: 16.h,
                  padding: EdgeInsets.zero,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      color: ColorStyles.upFinBlack
                  ),
                  child: isImage? Padding(padding: EdgeInsets.only(left: 1.w, right: 1.w, top: 2.w, bottom: 2.w), child: Image.file(File(pickedFiles[i].path),fit: BoxFit.fitWidth))
                      : Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                        UiUtils.getMarginBox(0, 1.5.h),
                        //UiUtils.getTextWithFixedScaleAndOverFlow(extension.toUpperCase(), 10.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null),
                        UiUtils.getMarginBox(0, 0.5.h),
                        UiUtils.getIcon(19.5.w, 5.5.h, Icons.folder_copy_outlined, 5.5.h, ColorStyles.upFinWhite),
                        UiUtils.getMarginBox(0, 1.h),
                        UiUtils.getTextWithFixedScale(fileName, 9.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null)
                  ]),
                )),
            Positioned(top: -0.3.h, right: 0.w, child: UiUtils.getIconButtonWithHeight(2.6.h, Icons.cancel_rounded, 2.6.h, ColorStyles.upFinGray, () {
              pickedFiles.removeAt(i);
              CommonUtils.log("i","click!!");
              if(pickedFiles.isEmpty){
                inputHelpHeight = inputHelpMinHeight;
                GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
                isShowPickedFile = false;
                GetController.to.updateShowPickedFile(isShowPickedFile);
              }else{
                inputHelpHeight = inputHelpPickedFileHeight;
                GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
                isShowPickedFile = true;
                GetController.to.updateShowPickedFile(isShowPickedFile);
              }
              setState(() {});
            }))
          ])
    */
      );
    }

    if(widgetList.isEmpty){
      return Container();
    }else{
      return SizedBox(width: 90.w, child: Row(mainAxisAlignment:MainAxisAlignment.center, crossAxisAlignment:CrossAxisAlignment.center, children: widgetList));
    }
  }

  Future<void> _requestPrev() async {
    if(!searchNoMore){
      UiUtils.showLoadingPop(context);
      await Future.delayed(const Duration(milliseconds: 1000));
      var inputJson = {
        "loan_uid" : currentLoanUid,
        "last_message_id" : GetController.to.chatMessageInfoDataList[0].chatId,
        "length" : 20
      };
      LogfinController.callLogfinApi(LogfinApis.getMessage, inputJson, (isSuccessToGetLoanMessageInfo, loanMessageInfoOutputJson){
        if(isSuccessToGetLoanMessageInfo){
          List<dynamic> prevMsgList = loanMessageInfoOutputJson!['data'];
          if(prevMsgList.isEmpty){
            UiUtils.closeLoadingPop(context);
            searchNoMore = true;
          }else{
            // 스크롤뷰의 현재 스크롤 위치를 가져옵니다.
            prevScrollPos = _chatScrollController.position.maxScrollExtent;
            CommonUtils.flutterToast("메시지가 추가되었습니다.");
            prevMsgList.sort((a,b) => double.parse(a["id"].toString()).compareTo(double.parse(b["id"].toString())));
            List<ChatMessageInfoData> prevMsgInfoList = [];
            for(var eachMsg in prevMsgList){
              var messageItem = ChatMessageInfoData(eachMsg["id"].toString(), eachMsg["pr_room_id"].toString(), eachMsg["message"].toString(),
                  CommonUtils.convertTimeToString(CommonUtils.parseToLocalTime(eachMsg["created_at"])),
                  eachMsg["message_type"].toString(), eachMsg["username"].toString(), jsonEncode(eachMsg));

              prevMsgInfoList.add(messageItem);
            }

            GetController.to.addPrevChatMessageInfoList(prevMsgInfoList);
            Future.delayed(const Duration(milliseconds: 400), () async {
              UiUtils.closeLoadingPop(context);
              double afterPos = _chatScrollController.position.maxScrollExtent - prevScrollPos;
              if(afterPos - 200 >= 0) afterPos = afterPos - 200;
              _chatScrollController.jumpTo(afterPos);

            });
          }
        }else{
          UiUtils.closeLoadingPop(context);
          CommonUtils.flutterToast("조회에 실패했습니다.");
        }
      });
    }
  }

  String selectedCarNum = "";
  String selectedCarOwner = "";
  final _carInfoFocus1 = FocusNode();
  final _carInfoFocus2 = FocusNode();
  final _carInfoTextController1 = TextEditingController();
  final _carInfoTextController2 = TextEditingController();
  void _carInfoTextController1Listener() {
    if(_carInfoTextController1.text.trim().length >= 9){
      _carInfoTextController1.text = _carInfoTextController1.text.substring(0,8);
    }
  }
  void _carInfoTextController2Listener() {
    if(_carInfoTextController2.text.trim().length >= 18){
      _carInfoTextController2.text = _carInfoTextController1.text.substring(0,17);
    }
  }
  void _getSearchCarView(){
    _carInfoTextController1.text = "";
    _carInfoTextController2.text = "";
    selectedCarNum = "";
    selectedCarOwner = "";
    String selectedJobInfo = MyData.jobInfo;
    UiUtils.showPopMenu(context, true, 100.w, 100.h, 0.5, 0, ColorStyles.dFinWhite, (slideContext, slideSetState){
      Widget slideWidget = Padding(padding: EdgeInsets.only(left: 2.5.w), child: Column(
          children: [
            SizedBox(width: 95.w, child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              UiUtils.getCloseButton(ColorStyles.dFinDarkGray, () {
                Navigator.pop(slideContext);
              }),
              UiUtils.getMarginBox(2.w, 0),
            ])),
            UiUtils.getMarginBox(0, 3.w),
            SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("차량번호를 입력하세요.", 22.sp, FontWeight.w800, ColorStyles.dFinTextAndBorderBlue, TextAlign.start, null)),
            UiUtils.getMarginBox(0, 1.h),
            SizedBox(width: 85.w, child: UiUtils.getTextWithFixedScale("예) 12가3456", 14.sp, FontWeight.w500, ColorStyles.dFinRealGray, TextAlign.start, null)),
            UiUtils.getMarginBox(0, 5.h),

            //test for input name
            MyData.isTestUser? SizedBox(width: 85.w, child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              UiUtils.getTextWithFixedScale("테스트용) 차량 소유자 입력", 10.sp, FontWeight.w600, ColorStyles.dFinRed, TextAlign.center, null),
              UiUtils.getTextField(context, 30.w, TextStyles.dFinTextFormFieldTextStyle, _carInfoFocus2, _carInfoTextController2, TextInputType.text,
                  UiUtils.getInputDecoration("이름", 10.sp, "", 0.sp), (value) { }),
              UiUtils.getMarginBox(0, 5.h),
            ])) : UiUtils.getMarginBox(0, 0),

            UiUtils.getExpandedScrollView(Axis.vertical,
                SizedBox(width: 85.w, child: Row(children: [
                  UiUtils.getTextField(context, 85.w, TextStyles.dFinTextFormFieldTextStyle, _carInfoFocus1, _carInfoTextController1, TextInputType.text,
                      UiUtils.getInputDecoration("번호", 10.sp, "", 0.sp), (value) { }),
                ]))
            ),

            UiUtils.getMarginBox(0, 5.h),
            UiUtils.getTextButtonBox(90.w, "등록", TextStyles.dFinBasicButtonTextStyle, ColorStyles.dFinButtonBlue, () async {
              if(_carInfoTextController1.text.trim() != ""){
                selectedCarNum = _carInfoTextController1.text.trim();
                selectedCarOwner = MyData.isTestUser? _carInfoTextController2.text.trim() : MyData.name;

                bool isValid = true;
                for(var eachCar in MyData.getCarInfoList()){
                  if(eachCar.carNum == selectedCarNum){
                    selectedCarNum = "";
                    isValid = false;
                  }
                }

                if(isValid){
                  Map<String, dynamic> inputJson = {
                    "car_no": selectedCarNum.replaceAll(" ", "").trim(),
                    "owner_name": MyData.isTestUser? selectedCarOwner : MyData.name,
                    "job": selectedJobInfo.split("@")[1],
                    "lend_count": "0", // selectedPreLoanCountInfo.split("@")[1],
                    "lend_amount": "0", // selectedPreLoanPriceInfo,
                    "loan_uid" : currentLoanUid
                  };
                  CommonUtils.log("i", "car pr search info:\n$inputJson");

                  UiUtils.showLoadingPercentPop(context, "자동차정보를 조회중");
                  LogfinController.addCar(context, inputJson, (isSuccess){
                    if(isSuccess){
                      UiUtils.closeLoadingPercentPopForSuccess(context, (isEnd){
                        if(isEnd){
                          CommonUtils.flutterToast("차량정보 조회 완료");
                          AppMainViewState.refreshMain();
                          Navigator.pop(slideContext);
                        }
                      });
                    }else{
                      UiUtils.closeLoadingPercentPop(context);
                    }
                  });
                }else{
                  CommonUtils.flutterToast("이미 조회하신 차량번호에요.");
                }
              }else{
                CommonUtils.flutterToast("정보를 입력해주세요.");
              }
            }),
            UiUtils.getMarginBox(0, 5.w)
          ]));

      return slideWidget;
    });
  }

  double inputMinHeight = 8.2.h;
  double inputHeight = 8.2.h;
  double inputMaxHeight = 20.h;
  double inputHelpMinHeight = 17.5.h;
  double inputHelpPickedFileHeight = 45.h;
  double inputHelpHeight = 17.5.h;
  bool chatButtonPressedPossible = true;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(isViewHere){
        await CommonUtils.saveSettingsToFile("push_from", "");
        await CommonUtils.saveSettingsToFile("push_room_id", "");
        isBuild = true;
        _scrollToBottom(false, 0);
      }
    });

    Widget view = Stack(children: [
        Container(
        color: ColorStyles.dFinWhite,
        width: 100.w,
        height: 100.h,
        child: Column(children: [

          Stack(children: [
            Container(height: 6.5.h,),
            Positioned(
              top: 1.h,
              left: 5.w,
              child: UiUtils.getBackButtonForMainView(() {
                _back();
              }),
            ),
            Positioned(
              left: 15.w,
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    UiUtils.getMarginBox(0, 1.8.h),
                    Row(children: [
                      CommonUtils.isUrlPath(currentCompanyLogo) ? UiUtils.getCircleNetWorkImage(9.w, currentCompanyLogo, _logoAniController)
                          : UiUtils.getCircleImage(currentCompanyLogo, 9.w),
                      UiUtils.getMarginBox(2.w, 0),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        SizedBox(width: 60.w, child: UiUtils.getTextWithFixedScaleAndOverFlow(currentCompany, 12.sp, FontWeight.w600, ColorStyles.dFinBlack, TextAlign.start, 1)),
                        UiUtils.getMarginBox(0, 0.3.h),
                        UiUtils.getTextWithFixedScale2(currentRoomTypeName, 10.sp, FontWeight.w500, ColorStyles.dFinRealGray, TextAlign.center, 1),
                      ])
                    ])
                  ])
              ),
            ),

            isUserChatRoom ? Container() : Positioned(
              child: Align(
                  alignment: Alignment.topRight,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    UiUtils.getMarginBox(0, 1.7.h),
                    Row(mainAxisAlignment:MainAxisAlignment.end, children: [
                      Obx((){
                        statusString = LoanInfoData.getDisplayStatusName(currentStatus);
                        return GestureDetector(
                            child: Container(
                              padding: EdgeInsets.only(top:1.4.w, bottom:1.2.w, right: 0.5.w, left:0.7.w),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(18)),
                                color: ColorStyles.dFinWhite,
                                  border: Border.all(
                                    color: ColorStyles.dFinGray,
                                    width: 0.25.w,
                                  )
                              ),
                              child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment:MainAxisAlignment.center, children: [
                                UiUtils.getMarginBox(1.5.w, 0),
                                UiUtils.getTextWithFixedScale(statusString, 10.sp, FontWeight.w500, ColorStyles.dFinBlack, TextAlign.start, null),
                                Icon(GetController.to.isShowStatus.value? Icons.arrow_drop_up_outlined : Icons.arrow_drop_down_outlined, color: ColorStyles.dFinBlack, size: 5.w)
                              ]),
                            ),
                            onTap: (){
                              GetController.to.updateShowStatus(!GetController.to.isShowStatus.value);
                            }
                        );


                        /*
                        return Column(children: [
                          UiUtils.getMarginBox(0, 2.2.w),
                          GestureDetector(child: Icon(Icons.signpost_outlined, color: GetController.to.isShowStatus.value? ColorStyles.upFinBlack : ColorStyles.upFinDarkGray, size: 6.w),
                           onTap: (){
                             GetController.to.updateShowStatus(!GetController.to.isShowStatus.value);
                           })
                        ]);


                         */
                      }),
                      UiUtils.getMarginBox(2.w, 0),
                    ])
                    //UiUtils.getMarginBox(0, 1.h),
                  ])
              ),
            ),
          ]),
          UiUtils.getMarginBox(0, 1.1.h),
          Obx((){
            if(GetController.to.isShowStatus.value){
              return isUserChatRoom ? UiUtils.getMarginColoredBox(100.w, 0.1.h, ColorStyles.dFinGray) : UiUtils.getMarginBox(0, 0);
            }else{
              return UiUtils.getMarginColoredBox(100.w, 0.1.h, ColorStyles.dFinGray);
            }
          }),
          isUserChatRoom ? CommonUtils.isWeekendInSeoul() ?
          Container(color: ColorStyles.dFinButtonBlue, width: 100.w, child: Padding(padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 2.h, top: 2.h), child: _getWeekendInfoWidgetForUserChat())) : Container() : Obx((){
            if(GetController.to.isShowStatus.value){
              return Column(children:[
                UiUtils.getMarginBox(0, 3.h),
                _getTimelineWidget()
              ]);
            }else{
              return Container();
            }
          }),
          Expanded(child: RefreshIndicator(onRefresh: ()=>_requestPrev(),color: ColorStyles.dFinButtonBlue, backgroundColor: ColorStyles.dFinWhiteSky,
              child: SingleChildScrollView(controller: _chatScrollController, scrollDirection: Axis.vertical, physics: const BouncingScrollPhysics(),
                  child: Obx(()=>Column(mainAxisAlignment: MainAxisAlignment.start, children: _getChatList()))))),
          Obx((){
            bool isWaiting = GetController.to.isAutoAnswerWaiting.value;
            bool isScrollWaiting = GetController.to.isShowScrollBottom.value;

            if(isScrollWaiting){
              isWaiting = isScrollWaiting;
            }

            if(!isWaiting){
              if(_chatScrollController.hasClients){
                if(_chatScrollController.position.hasPixels){
                  if(isBuild) _chatScrollController.jumpTo(_chatScrollController.position.pixels);
                }
              }
            }

            if(isUserChatRoom) isWaiting = false;

            return Container(color:ColorStyles.dFinWhite, child: Column(
              mainAxisSize: MainAxisSize.min, // 자식 위젯에 맞게 높이를 조절합니다.
              children: [
                isWaiting ? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, isUserChatRoom ? 0 : 0.6.h),
                isWaiting ? Container() : GetController.to.isShowPickedFile.value? Container() : Align(alignment: Alignment.topRight,
                    child: Padding(padding: EdgeInsets.only(left: 2.w, right: 2.w),
                        child: Wrap(runSpacing: 0.7.h, spacing: 1.7.w, alignment: WrapAlignment.end, direction: Axis.horizontal,
                            children: GetController.to.autoAnswerWidgetList))),
                isWaiting ? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, isUserChatRoom ? 0 : 1.h),
                GetController.to.isInputTextHide.value? Container() : GetController.to.isShowPickedFile.value? Container() : UiUtils.getMarginColoredBox(100.w, 0.1.h, ColorStyles.dFinGray),
                Obx((){
                  return GetController.to.isInputTextHide.value? Container() : GetController.to.isShowPickedFile.value? Container() : AnimatedContainer(
                      duration: const Duration(milliseconds:200),
                      width: 100.w,
                      height: GetController.to.chatInputHeight.value,
                      constraints: BoxConstraints(
                        minHeight: inputMinHeight,
                        maxHeight: inputMaxHeight,
                      ),
                      color: ColorStyles.dFinWhiteGray,
                      child: Padding(padding: EdgeInsets.only(left: 3.w,right: 3.w,bottom: 3.w,top: 2.w), child:
                      Container(
                          decoration: BoxDecoration(
                            color: ColorStyles.dFinWhiteGray, // 배경색 설정
                            borderRadius: BorderRadius.circular(1.0), // 모서리를 둥글게 하는 부분
                          ),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Expanded(flex: 75, child: Column(children: [UiUtils.getExpandedScrollView(Axis.vertical,
                                Column(children: [
                                  UiUtils.getChatTextField(context, 82.w, TextStyles.dFinChatTextStyle, _chatTextFocus, _chatTextController, TextInputType.multiline,
                                      UiUtils.getChatInputDecoration(), (textValue) {
                                        if(textValue != ""){
                                          isTextFieldFocus = true;
                                          final textLinePainter = TextPainter(
                                            text: TextSpan(text: textValue, style: TextStyles.dFinTextFormFieldTextStyle),
                                            maxLines: null,
                                            textDirection: TextDirection.ltr,
                                          )..layout(minWidth: 0, maxWidth: 72.w);

                                          final desiredHeight = inputMinHeight*0.64+textLinePainter.height;
                                          final height = desiredHeight.clamp(inputMinHeight, inputMaxHeight);
                                          if(height != GetController.to.chatInputHeight.value){
                                            //inputHeight = height;
                                            GetController.to.updateChatInputHeight(height);
                                            _scrollToBottom(true,300);
                                          }
                                        }else{
                                          isTextFieldFocus = false;
                                          GetController.to.updateChatInputHeight(inputMinHeight);
                                          _scrollToBottom(true,300);
                                        }
                                      }),
                                ]))])),
                            Expanded(flex: 1, child: Container(color: ColorStyles.dFinWhiteGray)),
                            Expanded(flex: !isTextFieldFocus? 20 : 13, child: !isTextFieldFocus ? SizedBox(height: 15.w, child: Row(crossAxisAlignment:CrossAxisAlignment.center, mainAxisAlignment:MainAxisAlignment.center, children: [
                              UiUtils.getIconButtonWithHeight(6.w, Icons.photo_camera_outlined, 7.w, ColorStyles.dFinRealGray, () {
                                if(chatButtonPressedPossible){
                                  chatButtonPressedPossible = false;
                                  CommonUtils.hideKeyBoard();
                                  Future.delayed(const Duration(milliseconds: 200), () async {
                                    chatButtonPressedPossible = true;
                                    _showCamera();
                                  });
                                }
                              }),
                              UiUtils.getMarginBox(4.w, 0),
                              Transform.rotate(angle: -25*(3.14/180), child: UiUtils.getIconButtonWithHeight(6.w, Icons.attachment, 7.w, ColorStyles.dFinRealGray, () {
                                if(chatButtonPressedPossible){
                                  chatButtonPressedPossible = false;
                                  CommonUtils.hideKeyBoard();
                                  Future.delayed(const Duration(milliseconds: 200), () async {
                                    chatButtonPressedPossible = true;
                                    _showFileUploadWebView();
                                  });
                                }

                              }))
                            ])) : UiUtils.getBorderButtonBoxForRound6(ColorStyles.dFinButtonBlue, ColorStyles.dFinButtonBlue,
                                Transform.rotate(angle: -25*(3.14/180), child: Icon(Icons.send_rounded, color: ColorStyles.dFinWhite, size: 6.w)), () {
                                  if(_chatTextController.text.toString().trim() != ""){
                                    _sendMessage(_chatTextController.text, "");
                                    _chatTextController.text = "";
                                    isTextFieldFocus = false;
                                    //inputHeight = inputMinHeight;
                                    GetController.to.updateChatInputHeight(inputMinHeight);
                                    _scrollToBottom(true,300);
                                  }else{
                                    CommonUtils.flutterToast("메시지를 입력하세요.");
                                  }
                                })
                            ),
                          ])
                      ))
                  );
                }),
                GetController.to.isShowPickedFile.value? Column(children: [
                  UiUtils.getSizedScrollView(90.w, inputHelpMinHeight, Axis.horizontal, _getPickedFilesWidget()),
                  UiUtils.getMarginBox(0, 3.w),
                  UiUtils.getBorderButtonBox(90.w, ColorStyles.dFinButtonBlue, ColorStyles.dFinButtonBlue,
                      UiUtils.getTextWithFixedScale("전송", 14.sp, FontWeight.w500, ColorStyles.dFinWhite, TextAlign.center, null), () async{
                        await _sendFileToAws();
                      }),
                  UiUtils.getMarginBox(0, 5.w),
                ]) : Container(),
              ],
            ));
          }),
        ])
    ),
      Obx((){
        if(GetController.to.isShowScrollBottom.value){
          return Positioned(
              bottom: GetController.to.isInputTextHide.value? 5.w : 20.w, right: 5.w,
              child: UiUtils.getIconButtonWithHeight(10.w, Icons.arrow_drop_down_circle, 10.w, ColorStyles.dFinChatScrollDarkGray, () {
                isScrollMove = false;
                GetController.to.updateAutoAnswerWaiting(false);
                GetController.to.updateShowScrollBottom(false);
                if(_chatScrollController.hasClients){
                  if(isBuild) _chatScrollController.jumpTo(_chatScrollController.position.maxScrollExtent+100);
                }
              })
          );
        }else{
          return Container();
        }
      }),
    ]);
    return UiUtils.getViewWithAllowBackForAndroid(context, view, _back);

  }

}


class ChatBubbleTriangleForOther extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = ColorStyles.dFinWhiteGray;

    var path = Path();
    path.lineTo(0, -2.w);
    path.lineTo(-1.2.w, 0);
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
    var paint = Paint()..color = ColorStyles.dFinTextAndBorderBlue;

    var path = Path();
    path.lineTo(0, -2.w);
    path.lineTo(1.2.w, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}