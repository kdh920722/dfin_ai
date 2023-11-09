import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:upfin/configs/app_config.dart';
import 'package:upfin/controllers/firebase_controller.dart';
import 'package:upfin/utils/ui_utils.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  if(!kIsWeb){
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await FireBaseController.initMainFirebase();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await FlutterDownloader.initialize(
        debug: false,
        ignoreSsl: false
    );
    await initializeDateFormatting();
  }
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

