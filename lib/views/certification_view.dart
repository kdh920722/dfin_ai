import 'package:flutter/material.dart';
import 'package:flutterwebchat/configs/app_config.dart';
import 'package:flutterwebchat/controllers/iamport_controller.dart';
import 'package:flutterwebchat/utils/common_utils.dart';
import '../utils/ui_utils.dart';

class CertificationView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Map<String, String> certInfo = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    Widget view = IamportController.getCertificationWebView(context, certInfo);
    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }
}
