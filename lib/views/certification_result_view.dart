import 'package:flutter/material.dart';
import 'package:flutterwebchat/controllers/iamport_controller.dart';
import 'package:flutterwebchat/utils/common_utils.dart';
import '../utils/ui_utils.dart';

class CertificationResultView extends StatelessWidget {

  bool _isCertificationResultCheck(BuildContext context){
    bool isSuccess = false;
    Object? result = ModalRoute.of(context)?.settings.arguments;
    if(result != null){
      isSuccess = IamportController.isCertificationResultSuccess(result as Map<String, String>);
    }

    return isSuccess;
  }

  @override
  Widget build(BuildContext context) {
    Widget view = IamportController.getCertificationResultView(context, _isCertificationResultCheck(context));
    return UiUtils.getView(context, view, CommonUtils.onWillPopForPreventBackButton);
  }
}
