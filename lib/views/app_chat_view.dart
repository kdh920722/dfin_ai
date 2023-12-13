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
import 'package:upfin/controllers/aws_controller.dart';
import 'package:upfin/controllers/firebase_controller.dart';
import 'package:upfin/controllers/get_controller.dart';
import 'package:upfin/controllers/logfin_controller.dart';
import 'package:upfin/controllers/websocket_controller.dart';
import 'package:upfin/datas/chat_message_info_data.dart';
import 'package:upfin/datas/loan_info_data.dart';
import 'package:upfin/datas/my_data.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:upfin/styles/TextStyles.dart';
import 'package:upfin/views/app_apply_pr_view.dart';
import 'package:upfin/views/app_main_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../configs/app_config.dart' as appConfig;
import '../configs/app_config.dart';
import '../datas/pr_docs_info_data.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';
import 'package:path_provider/path_provider.dart';

class AppChatView extends StatefulWidget{
  @override
  AppChatViewState createState() => AppChatViewState();
}

class AppChatViewState extends State<AppChatView> with WidgetsBindingObserver, SingleTickerProviderStateMixin{
  bool backPossibleFlag = true;
  final ScrollController _chatScrollController = ScrollController();
  final _chatTextFocus = FocusNode();
  final _chatTextController = TextEditingController();
  static String currentRoomId = "";
  static String currentLoanUid = "";
  String currentCompany = "";
  String currentCompanyLogo = "";
  String currentStatus = "";
  bool isBuild = false;
  bool isTextFieldFocus = false;
  bool inputTextHide = true;
  static bool isViewHere = false;
  double deviceH = 100.h;
  late AnimationController _aniController;

  bool searchNoMore = false;
  double prevScrollPos = 0.0;
  static bool isScrollMove = false;
  bool isOpenDownloadedFile = false;

  Timer? scrollCheckTimer;

  CameraController? _cameraController;
  GlobalKey repaintKey = GlobalKey();
  bool _isCameraReady = false;

  Map<String, bool> cachedImage = {};

  @override
  void initState(){
    CommonUtils.log("d", "AppChatViewState 화면 입장");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _aniController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        lowerBound: 0.0,
        upperBound: 1.0);
    currentRoomId = GetController.to.chatMessageInfoDataList[0].chatRoomId;
    for(var each in MyData.getLoanInfoList()){
      if(each.chatRoomId == currentRoomId){
        currentLoanUid = each.loanUid;
        currentCompany = each.companyName;
        currentCompanyLogo = each.companyLogo;
        currentStatus = each.statueId;
        if(LoanInfoData.getStatusName(currentStatus) == "접수"){
          GetController.to.updateChatStatusTick(1);
        }else if(LoanInfoData.getStatusName(currentStatus) == "심사"){
          GetController.to.updateChatStatusTick(2);
        }else if(LoanInfoData.getStatusName(currentStatus) == "통보"){
          GetController.to.updateChatStatusTick(3);
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
    GetController.to.updateInputTextHide(true);
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
    _chatScrollController.dispose();
    _chatTextFocus.dispose();
    _chatTextController.dispose();
    _aniController.dispose();
    currentRoomId = "";
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
    UiUtils.showPopMenu(context, false, 100.w, 100.h, 0.5, 0, ColorStyles.upFinBlack, (popContext, popSetState){
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              child: SizedBox(width: 100.w, height: 100.h)
          ),
          Positioned(
              child: SizedBox(width: 100.w, height: appConfig.Config.isAndroid? 70.h : 63.h,
                  child: Container(color: ColorStyles.upFinBlack, child: UiUtils.getImage(80.w, 22.h, Image.file(File(imageFilFromCamera!.path)))))
          ),
          Positioned(
              top: appConfig.Config.isAndroid? 85.h : 80.h,
              child: Row(children: [
                UiUtils.getBorderButtonBox(30.w, ColorStyles.upFinBlack, ColorStyles.upFinBlack,
                    UiUtils.getTextWithFixedScale("취소", 13.sp, FontWeight.w300, ColorStyles.upFinWhite, TextAlign.start, null), () {
                      Navigator.pop(popContext);
                      _takeCustomCamera();
                    }),
                UiUtils.getMarginBox(20.w, 0),
                UiUtils.getBorderButtonBox(30.w, ColorStyles.upFinBlack, ColorStyles.upFinBlack,
                    UiUtils.getTextWithFixedScale("확인", 13.sp, FontWeight.w300, ColorStyles.upFinWhite, TextAlign.start, null), () {
                      XFile? image = imageFilFromCamera;
                      if(image != null){
                        isShowPickedFile = true;
                        GetController.to.updateShowPickedFile(isShowPickedFile);
                        inputHelpHeight = inputHelpPickedFileHeight;
                        GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
                        pickedFiles.add(File(image.path));
                      }else{
                        if(pickedFiles.isEmpty){
                          isShowPickedFile = false;
                          GetController.to.updateShowPickedFile(isShowPickedFile);
                          inputHelpHeight = inputHelpMinHeight;
                          GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
                        }else{
                          isShowPickedFile = true;
                          GetController.to.updateShowPickedFile(isShowPickedFile);
                          inputHelpHeight = inputHelpPickedFileHeight;
                          GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
                        }
                      }
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
    UiUtils.showPopMenu(context, false, 100.w, 100.h, 0.5, 0, ColorStyles.upFinBlack, (popContext, popSetState){
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              child: SizedBox(width: 100.w, height: 100.h)
          ),
          Positioned(
              child: SizedBox(width: 100.w, height: appConfig.Config.isAndroid? 70.h : 63.h, child: _cameraController != null && _isCameraReady ?
              CameraPreview(_cameraController!) : Container(color: ColorStyles.upFinBlack))
          ),
          Positioned(
              top: 3.w,
              right: 3.w,
              child: UiUtils.getCloseButton(ColorStyles.upFinWhite, () {
                imageFilFromCamera = null;
                Navigator.pop(popContext);
              })
          ),
          Positioned(
              top: appConfig.Config.isAndroid? 85.h : 80.h,
              child: UiUtils.getIconButtonWithHeight(5.h, Icons.camera, 5.h, ColorStyles.upFinWhite, () {
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
    String buttonId = "";
    String fileName = "";
    String boldTextId = "";
    bool isFileType = true;

    if(sender == "UPFIN") {
      htmlTextTag = "<div id='typeOther'>";
      buttonId = "buttonTypeOther";
      boldTextId = "boldTextOther";
    }else{
      htmlTextTag = "<div id='typeMe'>";
      buttonId = "buttonTypeMe";
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
                    "border-radius":"0.1em",
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
                CommonUtils.log("", "furl : $url");
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
                }else{
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
            textStyle: TextStyles.upFinHtmlTextStyle,
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
        otherInfoWidget = UiUtils.getSelectableTextWithFixedScale2(otherInfo.message, 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null);
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
          otherInfoWidget = _getHtmlView(otherInfo.message, "UPFIN", otherInfo.messageType);
        }else{
          isImageView = true;
          otherInfoWidget = _getImageView(otherInfo.message);
        }
      }else{
        otherInfoWidget = UiUtils.getTextWithFixedScale("$extension은 지원히지 않는 파일입니다.\n\n(${otherInfo.message})", 13.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null);
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
                  padding: isImageView? EdgeInsets.zero : EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    borderRadius: isImageView? const BorderRadius.only(topRight: Radius.circular(1), topLeft: Radius.circular(1), bottomRight: Radius.circular(1))
                      : const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                    color: isImageView? ColorStyles.upFinWhite : ColorStyles.upFinWhiteGray,
                  ),
                  child: otherInfoWidget
              ),
              UiUtils.getMarginBox(1.w, 0),
              UiUtils.getTextWithFixedScale(CommonUtils.getFormattedLastMsgTime(otherInfo.messageTime), 8.sp, FontWeight.w400, ColorStyles.upFinDarkGray, TextAlign.start, null)
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
                    color: ColorStyles.upFinWhiteGray,
                  ),
                  child: UiUtils.getImage(5.w, 5.w, Image.asset(fit: BoxFit.fill,'assets/images/chat_loading.gif'))
              ),
            ]),
            UiUtils.getMarginBox(0, 1.h)
          ]),
        ])
    );
  }

  Future<void> _loadImageAsync(String src) async {
    if(!cachedImage.containsKey(src)){
      await Future.delayed(const Duration(seconds: 2));
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
                    color: ColorStyles.upFinBlack,
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
                                    color: ColorStyles.upFinWhite,
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
                            child: UiUtils.getIcon(10.w, 10.w, Icons.refresh_rounded, 10.w, ColorStyles.upFinRed),
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
                    color: ColorStyles.upFinBlack,
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
            UiUtils.showPopMenu(context, true, 100.w, 100.h, 0.5, 0, ColorStyles.upFinBlack, (slideContext, slideSetState){
              Widget slideWidget = Column(children: [
                SizedBox(width: 97.w, child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  UiUtils.getCloseButton(ColorStyles.upFinWhite, () {
                    Navigator.pop(slideContext);
                  })
                ])),
                UiUtils.getMarginBox(0, 4.h),
                Container(
                    color:ColorStyles.upFinBlack,
                    width: 90.w, height: appConfig.Config.isAndroid? 75.h : 70.h,
                    child: InteractiveViewer(
                        constrained: false,
                        child: Container(
                            color:ColorStyles.upFinBlack,
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
                                              color: ColorStyles.upFinWhite,
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
                                      child: UiUtils.getIcon(10.w, 10.w, Icons.refresh_rounded, 10.w, ColorStyles.upFinRed),
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
      meInfoWidget = UiUtils.getSelectableTextWithFixedScale2(meInfo.message, 13.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null);
    }else{
      String extension = meInfo.message.split('.').last.toLowerCase();
      List<String> validDocExtensions = LogfinController.validDocFileTypeList;
      if (validDocExtensions.contains(extension)) {
        meInfoWidget = _getHtmlView(meInfo.message, "ME", meInfo.messageType);
      }else{
        meInfoWidget = _getImageView(meInfo.message);
        isImageView = true;
      }
    }

    return Container(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.w, bottom: 2.w),
        width: 100.w,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            UiUtils.getTextWithFixedScale(CommonUtils.getFormattedLastMsgTime(meInfo.messageTime), 8.sp, FontWeight.w400, ColorStyles.upFinDarkGray, TextAlign.start, null),
            UiUtils.getMarginBox(1.w, 0),
            Container(
                constraints: BoxConstraints(maxWidth: isImageView? 63.w : 73.w),
                padding: isImageView? EdgeInsets.zero : EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  borderRadius: isImageView? const BorderRadius.only(topRight: Radius.circular(1), topLeft: Radius.circular(1), bottomLeft: Radius.circular(1))
                      : const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                  color: isImageView? ColorStyles.upFinWhite : ColorStyles.upFinTextAndBorderBlue,
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
                  color: ColorStyles.upFinTextAndBorderBlue
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
    for(var each in GetController.to.chatMessageInfoDataList){
      if(each.senderName == "UPFIN"){
        chatList.add(_getOtherView(each));
      }else{
        chatList.add(_getMeView(each));
      }
    }

    if(WebSocketController.isWaitingForAnswerState(currentRoomId, "ME")){
      chatList.add(_getMeViewForLoading());
    }

    if(WebSocketController.isWaitingForAnswerState(currentRoomId, "UPFIN")){
      chatList.add(_getOtherForLoadingView());
    }

    _scrollToBottom(false,0);

    return chatList;
  }

  Future<void> _back() async {
    if(backPossibleFlag){
      backPossibleFlag = false;
      var inputJson = {
        "pr_room_id" : currentRoomId
      };
      UiUtils.showLoadingPop(context);
      await CommonUtils.saveSettingsToFile("push_from", "");
      await CommonUtils.saveSettingsToFile("push_room_id", "");
      await FireBaseController.setNotificationTorF(true);
      await LogfinController.callLogfinApi(LogfinApis.checkMessage, inputJson, (isSuccess, outputJson){
        if(!isSuccess){
          CommonUtils.flutterToast("메시지를 읽는중\n오류가 발생했어요.");
        }

        if(context.mounted) {
          if(scrollCheckTimer != null) scrollCheckTimer!.cancel();
          isViewHere = false;
          _chatTextFocus.unfocus();
          CommonUtils.hideKeyBoard();
          UiUtils.closeLoadingPop(context);
          backPossibleFlag =true;
          Navigator.pop(context);
        }
      });
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
      UiUtils.getMarginColoredBox(100.w, 0.12.h, ColorStyles.upFinGray)

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
      isChecked? passed? UiUtils.getIcon(3.w, 3.w, Icons.radio_button_checked_rounded, 3.w, ColorStyles.upFinButtonBlue)
          : UiUtils.getIcon(3.w, 3.w, Icons.circle, 3.w, ColorStyles.upFinButtonBlue)
            : UiUtils.getIcon(3.w, 3.w, Icons.radio_button_unchecked_rounded, 3.w, ColorStyles.upFinWhiteSky),
      UiUtils.getMarginBox(0, 1.5.h),
      UiUtils.getTextWithFixedScale(typeString, 9.sp, FontWeight.w600, ColorStyles.upFinRealGray, TextAlign.center, null),
    ]);
  }

  Widget _stepLine(bool isReached) {
    return Column(children: [
      UiUtils.getMarginBox(0, 0.5.h),
      Container(
        color: isReached? ColorStyles.upFinButtonBlue : ColorStyles.upFinWhiteSky,
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
    if(currentKey != ""){
      answerList.add("이전");
    }
    for(var each in answerList){
      Color borderColor = ColorStyles.upFinGray;
      Color fillColor = ColorStyles.upFinWhite;
      Color textColor = ColorStyles.upFinBlack;
      if(each.contains("이전")){
        borderColor = ColorStyles.upFinBlack;
        fillColor = ColorStyles.upFinBlack;
        textColor = ColorStyles.upFinWhite;
      }
      if(each.contains("맨아래")){
        borderColor = ColorStyles.upFinRealGray;
        fillColor = ColorStyles.upFinRealGray;
        textColor = ColorStyles.upFinWhite;
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
                        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale2("촬영을위한 카메라 권한이 필요해요.",14.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.center, null)),
                        UiUtils.getMarginBox(0, 1.h),
                        SizedBox(width: 90.w, child: UiUtils.getTextWithFixedScale2("설정에서 카메라 권한을 허용 해주세요",12.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.center, null))
                      ]),
                      UiUtils.getExpandedScrollView(Axis.vertical, Container()),
                      UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                          UiUtils.getTextWithFixedScale("설정 바로가기", 12.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.start, null), () async {
                            Navigator.pop(slideContext);
                            openAppSettings();
                          }),
                      Config.isAndroid ? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 5.h),
                    ]
                );
              });
            }
          }
        }else if(each.contains("채팅")){
          inputTextHide = false;
          GetController.to.updateInputTextHide(inputTextHide);
          _setAutoAnswerWidgetList();
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
    CommonUtils.hideKeyBoard();
    if(!WebSocketController.isWaitingForAnswerState(currentRoomId, "ME")){
      GetController.to.updateAutoAnswerWaiting(true);

      var inputJson = {
        "loan_uid" : currentLoanUid,
        "message" : message
      };

      WebSocketController.setWaitingState(currentRoomId, "ME", true);

      if(pickedFiles.isEmpty){
        // message, custom message
        if(customMessageType != ""){
          inputJson["type"] = "custom";
          inputJson["message"] = customMessageType;
        }else{
          inputJson["type"] = "text";
        }
        WebSocketController.setWaitingState(currentRoomId, "UPFIN", true);
      }else{
        // file
        inputJson["type"] = "file";
      }

      if(!isScrollMove) setState(() {});

      LogfinController.callLogfinApi(LogfinApis.sendMessage, inputJson, (isSuccess, _){
        GetController.to.updateChatAutoAnswerHeight(inputHelpHeight);
        if(!isSuccess){
          CommonUtils.flutterToast("메시지 전송중\n오류가 발생했습니다.");
        }
      });

    }else{
      CommonUtils.flutterToast("응답을 기다리는 중입니다.");
    }
  }

  bool isShowPickedFile = false;
  List<File> pickedFiles = [];
  int maximumSize = 1;
  Widget _getPickedFilesWidget(){
    List<Widget> widgetList = [];
    for(int i = 0 ; i < pickedFiles.length ; i++){
      bool isImage = true;
      CommonUtils.log("","picked file : ${pickedFiles[i].path}");
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
            Positioned(top: 0.1.h, right: -3.3.w, child: UiUtils.getIconButtonWithHeight(2.h, Icons.cancel_rounded, 2.h, ColorStyles.upFinGray, () {
              pickedFiles.removeAt(i);
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
      );
    }

    if(widgetList.isEmpty){
      return Container();
    }else{
      return Row(children: widgetList);
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
          CommonUtils.log("", "get prev $loanMessageInfoOutputJson");
          List<dynamic> prevMsgList = loanMessageInfoOutputJson!['data'];
          if(prevMsgList.isEmpty){
            UiUtils.closeLoadingPop(context);
            searchNoMore = true;
          }else{
            // 스크롤뷰의 현재 스크롤 위치를 가져옵니다.
            prevScrollPos = _chatScrollController.position.maxScrollExtent;
            CommonUtils.log("", "prevScrollPos : $prevScrollPos");
            CommonUtils.flutterToast("메시지가 추가되었습니다.");
            prevMsgList.sort((a,b) => a["id"].compareTo(b["id"]));
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
              CommonUtils.log("", "!!!do prevScrollPos : $prevScrollPos || current pos : ${_chatScrollController.position.maxScrollExtent}");
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

  double inputMinHeight = 9.2.h;
  double inputHeight = 9.2.h;
  double inputMaxHeight = 20.h;
  double inputHelpMinHeight = 17.5.h;
  double inputHelpPickedFileHeight = 45.h;
  double inputHelpHeight = 17.5.h;
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
        color: ColorStyles.upFinWhite,
        width: 100.w,
        height: 100.h,
        child: Column(children: [
          UiUtils.getMarginBox(0, 0.5.h),
          Stack(children: [
            Positioned(
              top: 1.h,
              left: 5.w,
              child: UiUtils.getBackButtonForMainView(() {
                _back();
              }),
            ),
            Positioned(
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    UiUtils.getMarginBox(0, 2.5.h),
                    UiUtils.getTextWithFixedScale(currentCompany, 15.sp, FontWeight.w600, ColorStyles.upFinDarkGray, TextAlign.center, 1),
                    //UiUtils.getMarginBox(0, 1.h),
                  ])
              ),
            ),

            Positioned(
              child: Align(
                  alignment: Alignment.topRight,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    UiUtils.getMarginBox(0, 1.7.h),
                    Row(mainAxisAlignment:MainAxisAlignment.end, children: [
                      Obx((){

                        //String statusName = LoanInfoData.getDetailStatusName(GetController.to.chatStatusTick.value.toString());

                        return GestureDetector(
                            child: Container(
                              padding: EdgeInsets.only(top:1.4.w, bottom:1.2.w, right: 0.5.w, left:0.7.w),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(18)),
                                color: ColorStyles.upFinWhite,
                                  border: Border.all(
                                    color: ColorStyles.upFinGray,
                                    width: 0.35.w,
                                  )
                              ),
                              child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment:MainAxisAlignment.center, children: [
                                UiUtils.getMarginBox(1.5.w, 0),
                                UiUtils.getTextWithFixedScale("상태", 10.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null),
                                Icon(GetController.to.isShowStatus.value? Icons.arrow_drop_up_outlined : Icons.arrow_drop_down_outlined, color: ColorStyles.upFinBlack, size: 5.w)
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
                      UiUtils.getMarginBox(5.w, 0),
                    ])
                    //UiUtils.getMarginBox(0, 1.h),
                  ])
              ),
            ),
          ]),
          Obx((){
            if(GetController.to.isShowStatus.value){
              return Column(children:[
                UiUtils.getMarginBox(0, 3.h),
                _getTimelineWidget()
              ]);
            }else{
              return Container();
            }
          }),
          Obx((){
            if(GetController.to.isShowStatus.value){
              return UiUtils.getMarginBox(0, 0);
            }else{
              return UiUtils.getMarginBox(0, 2.h);
            }
          }),
          Expanded(child: RefreshIndicator(onRefresh: ()=>_requestPrev(),color: ColorStyles.upFinButtonBlue, backgroundColor: ColorStyles.upFinWhiteSky,
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

            return Container(color:ColorStyles.upFinWhite, child: Column(
              mainAxisSize: MainAxisSize.min, // 자식 위젯에 맞게 높이를 조절합니다.
              children: [
                isWaiting ? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 0.6.h),
                isWaiting ? Container() : Align(alignment: Alignment.topRight,
                    child: Padding(padding: EdgeInsets.only(left: 2.w, right: 2.w),
                        child: Wrap(runSpacing: 0.7.h, spacing: 1.7.w, alignment: WrapAlignment.end, direction: Axis.horizontal,
                            children: GetController.to.autoAnswerWidgetList))),
                GetController.to.isShowPickedFile.value? Column(children: [
                  UiUtils.getSizedScrollView(90.w, inputHelpMinHeight, Axis.horizontal, _getPickedFilesWidget()),
                  UiUtils.getMarginBox(0, 5.w),
                  UiUtils.getBorderButtonBox(90.w, ColorStyles.upFinButtonBlue, ColorStyles.upFinButtonBlue,
                      UiUtils.getTextWithFixedScale("전송", 14.sp, FontWeight.w500, ColorStyles.upFinWhite, TextAlign.center, null), () async{
                        await _sendFileToAws();
                      }),
                  UiUtils.getMarginBox(0, 5.w),
                ]) : Container(),
                isWaiting ? UiUtils.getMarginBox(0, 0) : UiUtils.getMarginBox(0, 2.h)
              ],
            ));
          }),

          Obx((){
            return GetController.to.isInputTextHide.value? Container() : AnimatedContainer(
                duration: const Duration(milliseconds:200),
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
                    padding: EdgeInsets.all(0.35.w),
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
                                UiUtils.getChatTextField(context, 70.w, TextStyles.upFinTextFormFieldTextStyle, _chatTextFocus, _chatTextController, TextInputType.multiline,
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
                                          /*
                                          setState(() {
                                            inputHeight = height;
                                          });

                                           */
                                        }
                                      }else{
                                        /*
                                        setState(() {
                                          isTextFieldFocus = false;
                                          inputHeight = inputMinHeight;
                                        });

                                         */
                                      }
                                    })
                              ]))])),
                          Expanded(flex: 1, child: Container(color: ColorStyles.upFinWhite)),
                          Expanded(flex: 15, child:
                          UiUtils.getIconButtonWithHeight(14.w, Icons.arrow_circle_up_rounded, 14.w,
                              isTextFieldFocus? ColorStyles.upFinButtonBlue : ColorStyles.upFinWhiteSky, () {
                                if(_chatTextController.text.toString().trim() != ""){
                                  _sendMessage(_chatTextController.text, "");
                                  setState(() {
                                    _chatTextController.text = "";
                                    isTextFieldFocus = false;
                                  });
                                }else{
                                  CommonUtils.flutterToast("메시지를 입력하세요.");
                                }
                              })
                          ),
                        ]))))
            );
          })
        ])
    ),
      Obx((){
        if(GetController.to.isShowScrollBottom.value){
          return Positioned(
              bottom: 5.w, right: 5.w,
              child: UiUtils.getIconButtonWithHeight(10.w, Icons.arrow_drop_down_circle, 10.w, ColorStyles.upFinDarkGray, () {
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
    var paint = Paint()..color = ColorStyles.upFinWhiteGray;

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
    var paint = Paint()..color = ColorStyles.upFinTextAndBorderBlue;

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