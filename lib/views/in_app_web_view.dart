import 'package:flutter/material.dart';
import 'package:flutterwebchat/controllers/webview_controller.dart';
import 'package:flutterwebchat/utils/common_utils.dart';
import '../utils/ui_utils.dart';

class InAppWebView extends StatefulWidget{
  @override
  InAppWebViewState createState() => InAppWebViewState();
}

class InAppWebViewState extends State<InAppWebView> {
  @override
  Widget build(BuildContext context) {
    Map<String, String> urlInfo = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    Widget view = WebViewController.getWebView(context, setState, urlInfo['url']!);
    return UiUtils.getView(context, view, CommonUtils.onWillPopForAllowBackButton);
  }
}