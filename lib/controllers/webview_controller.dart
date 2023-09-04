import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutterwebchat/utils/common_utils.dart';
import 'package:sizer/sizer.dart';

class WebViewController {
  static final WebViewController _instance = WebViewController._internal();
  factory WebViewController() => _instance;
  WebViewController._internal();

  static final GlobalKey webViewKey = GlobalKey();
  static Uri myUrl = Uri.parse("");

  static Widget getWebView(BuildContext context, StateSetter setState, String url){
    myUrl = Uri.parse("https://$url");
    return SafeArea(
        child : Scaffold(
          backgroundColor: Colors.black,
          body: InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(url: myUrl),
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
                CommonUtils.log("i", "UPDATED URL CHECK : $uri");
                setState(() {myUrl = uri!;});
              },
              onCreateWindow: (controller, createWindowRequest) async{
                showDialog(
                    context: context, builder: (context) {
                  return AlertDialog(
                    content: SizedBox(
                        width: 100.w,
                        height: 40.h,
                        child: InAppWebView(
                          // Setting the windowId property is important here!
                            windowId: createWindowRequest.windowId,
                            initialOptions: InAppWebViewGroupOptions(
                              android: AndroidInAppWebViewOptions(
                                builtInZoomControls: true,
                                thirdPartyCookiesEnabled: true,
                              ),
                              crossPlatform: InAppWebViewOptions(
                                mediaPlaybackRequiresUserGesture: false,
                                cacheEnabled: true,
                                javaScriptEnabled: true,
                                userAgent: "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36",
                              ),
                              ios: IOSInAppWebViewOptions(
                                allowsInlineMediaPlayback: true,
                                allowsBackForwardNavigationGestures: true,
                              ),
                            ),
                            onCloseWindow: (controller) async{
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            }
                        )
                    ),);
                }
                );
                return true;
              }
          ),
        )
    );
  }
}