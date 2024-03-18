import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:dfin/controllers/logfin_controller.dart';
import 'package:dfin/styles/ColorStyles.dart';
import 'package:dfin/views/app_chat_view.dart';
import '../configs/app_config.dart';
import '../controllers/get_controller.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppWebView extends StatefulWidget{
  @override
  AppWebViewState createState() => AppWebViewState();
}

class AppWebViewState extends State<AppWebView> with WidgetsBindingObserver{
  static String url = "";
  static List<int> resultArr = []; // success, fail
  static String oneTimeKey = "";
  bool isComplete = false;
  @override
  void initState(){
    CommonUtils.log("i", "AppWebViewState 화면 입장");
    super.initState();
    _getOneTimeKey();
    resultArr.clear();
    isComplete = false;
  }

  @override
  void dispose(){
    CommonUtils.log("i", "AppWebViewState 화면 파괴");
    WidgetsBinding.instance.removeObserver(this);
    oneTimeKey = "";
    url = "";
    GetController.to.updateOneTimeKeyFlag(false);
    GetController.to.updateWebViewFlag(false);
    isComplete = false;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        CommonUtils.log('i','AppWebView resumed');
        break;
      case AppLifecycleState.inactive:
        CommonUtils.log('i','AppWebView inactive');
        break;
      case AppLifecycleState.detached:
        CommonUtils.log('i','AppWebView detached');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        CommonUtils.log('i','AppWebView paused');
        break;
      default:
        break;
    }
  }

  bool backValid = true;
  void _back(){
    if(backValid && !isComplete){
      backValid = false;
      CommonUtils.hideKeyBoard();
      Future.delayed(const Duration(milliseconds: 200), () async {
        backValid = true;
        Navigator.pop(context, resultArr);
      });
    }
  }
  
  void _getOneTimeKey() {
    Map<String, dynamic> inputJson = {
      "pr_room_id": AppChatViewState.currentRoomId.toString()
    };
    LogfinController.callLogfinApi(LogfinApis.getOneTimeKey, inputJson, (isSuccess, outputJson){
      if(isSuccess){
        oneTimeKey = outputJson!["user_token"].toString();
        url = "${Config.fileUploadWebUrl}user_token=$oneTimeKey";
        GetController.to.updateOneTimeKeyFlag(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Stack(children: [
      Container(width:100.w, height: 100.h, color: ColorStyles.dFinWhite,
          child: Column(children: [
            Container(padding: EdgeInsets.only(bottom: 0, top: 3.w, left: 5.w, right: 5.w), width: 100.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              UiUtils.getBackButtonForMainView(() {
                _back();
              })
            ])),
            Expanded(child: Obx((){
              if(GetController.to.isOneTimeKeyHere.value){
                return InAppWebView(
                  key: UniqueKey(),
                  initialUrlRequest: URLRequest(url: Uri.parse(url)),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                        javaScriptCanOpenWindowsAutomatically: true,
                        javaScriptEnabled: true,
                        useOnDownloadStart: true,
                        useOnLoadResource: true,
                        useShouldOverrideUrlLoading: true,
                        mediaPlaybackRequiresUserGesture: true,
                        allowFileAccessFromFileURLs: true,
                        allowUniversalAccessFromFileURLs: true,
                        verticalScrollBarEnabled: true,
                        userAgent: 'Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36'
                    ),
                    android: AndroidInAppWebViewOptions(
                        useHybridComposition: true,
                        allowContentAccess: true,
                        builtInZoomControls: true,
                        thirdPartyCookiesEnabled: true,
                        allowFileAccess: true,
                        supportMultipleWindows: true
                    ),
                    ios: IOSInAppWebViewOptions(
                      allowsInlineMediaPlayback: true,
                      allowsBackForwardNavigationGestures: true,
                    ),
                  ),
                  onLoadStop: (InAppWebViewController controller, uri) {
                    CommonUtils.log("i", "finished url : $uri");
                    GetController.to.updateWebViewFlag(true);
                    if(uri.toString().contains("complete_file_send")){
                      Future.delayed(const Duration(milliseconds: 400), () async {
                        Navigator.pop(context, resultArr);
                      });
                    }
                  },  onLoadStart: (InAppWebViewController controller, uri){
                    if(uri.toString().contains("complete_file_send")){
                      isComplete = true;
                    }
                  }, onCreateWindow: (controller, createWindowRequest) async{
                    return true;
                  },
                );
              }else{
                return const SizedBox(width: 0, height: 0);
              }
            }))
          ])
      ),
      Positioned(child: Obx((){
        if(GetController.to.isWebViewHere.value){
          return const SizedBox(width: 0, height: 0);
        }else{
          return WillPopScope(
              onWillPop: () async => true,
              child: StatefulBuilder(// You need this, notice the parameters below:
                  builder: (_, StateSetter setState) {
                    return Container(
                        width: 100.w,
                        height: 100.h,
                        color: Colors.black54,
                        child:
                        Center(child: SpinKitWave(color: ColorStyles.dFinTextAndBorderBlue, size: 15.w))
                    );
                  })
          );
        }
      })
      )
    ]);
    return UiUtils.getViewWithAllowBackForAndroid(context, view, _back);
  }

}