import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:upfin/configs/app_config.dart';
import 'package:upfin/utils/common_utils.dart';
import 'package:upfin/utils/ui_utils.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async{
  // 화면 회전 제어
  CommonUtils.log("", "start");
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await initializeDateFormatting();
  await FlutterDownloader.initialize(
      debug: false,
      ignoreSsl: false
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    if(!Config.isAppMainInit){
      // screen settings..
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ));
    }

    return UiUtils.startAppView();
  }
}

