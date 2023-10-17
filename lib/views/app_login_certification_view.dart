import 'package:flutter/material.dart';
import 'package:upfin/controllers/iamport_controller.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';

class AppLoginCertificationView extends StatefulWidget{
  @override
  AppLoginCertificationViewState createState() => AppLoginCertificationViewState();
}

class AppLoginCertificationViewState extends State<AppLoginCertificationView> {
  void back(){
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    Map<String, String> certInfo = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    Widget view = IamportController.getCertificationWebView(context, certInfo);
    return UiUtils.getViewWithAllowBackForAndroid(context, view, back);
  }
}
