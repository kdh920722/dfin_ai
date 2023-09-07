import 'package:flutter/material.dart';
import 'package:upfin/controllers/webview_controller.dart';
import 'package:upfin/utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppWebView extends StatefulWidget{
  @override
  AppWebViewState createState() => AppWebViewState();
}

class AppWebViewState extends State<AppWebView> {
  @override
  Widget build(BuildContext context) {
    Map<String, String> urlInfo = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    Widget view = WebViewController.getWebView(context, setState, urlInfo['url']!);
    return UiUtils.getView(context, view, CommonUtils.onWillPopForAllowBackButton);
  }
}