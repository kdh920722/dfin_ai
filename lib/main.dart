import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterwebchat/configs/app_config.dart';
import 'package:flutterwebchat/utils/common_utils.dart';
import 'package:flutterwebchat/utils/ui_utils.dart';
import 'package:flutterwebchat/views/chat_view.dart';
import 'package:uni_links/uni_links.dart';

void main() async{
  // 화면 회전 제어
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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

    return UiUtils.getMainView(context, ChatView());
  }
}

