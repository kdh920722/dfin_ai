import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:dfin/configs/app_config.dart';
import 'package:dfin/controllers/facebook_controller.dart';
import 'package:dfin/controllers/firebase_controller.dart';
import 'package:dfin/utils/ui_utils.dart';
import 'controllers/get_controller.dart';

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  if(!kIsWeb){
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await FireBaseController.initMainFirebase();
    FireBaseController.initFirebaseAnalyticsEventLog();
    await FacebookController.initFacebookEventLog();
    // init appsflyer later..

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await initializeDateFormatting();
    FlutterNativeSplash.remove();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(!Config.isAppMainInit){
      // screen settings..
      Get.put(GetController());
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ));
    }

    return UiUtils.startAppView();
  }
}

