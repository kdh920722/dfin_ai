import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutterwebchat/utils/app_config.dart';
import 'package:flutterwebchat/utils/common_utils.dart';
import 'package:flutterwebchat/utils/ui_utils.dart';
import 'package:flutterwebchat/views/chat_view.dart';

void main() async{
  // 화면 회전 제어
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

final ScrollController scrollController = ScrollController();
KeyboardVisibilityController? _keyboardVisibilityController;
void _functionForKeyboardHide(){
  FocusManager.instance.primaryFocus?.unfocus();
  scrollController.jumpTo(0);
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

      // keyboard settings..
      _keyboardVisibilityController ??= CommonUtils.getKeyboardViewController(null, _functionForKeyboardHide);
    }

    return UiUtils.getMainView(context, ChatView(), CommonUtils.onWillPopForPreventBackButton);
  }
}

