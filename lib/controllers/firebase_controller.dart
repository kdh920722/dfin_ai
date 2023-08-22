import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutterwebchat/configs/app_config.dart';
import '../configs/firebase_options.dart';
import '../utils/common_utils.dart';

class FireBaseController{
  static final FireBaseController _instance = FireBaseController._internal();
  factory FireBaseController() => _instance;
  FireBaseController._internal();
  static FirebaseApp? firebaseApp;
  static UserCredential? userCredential;

  /// firebase database =========================================================================== ///
  static Future<void> _initFirebase(Function(bool) callback) async {
    try {
      firebaseApp = await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      userCredential = await FirebaseAuth.instance.signInAnonymously();
      callback(true);
    } on FirebaseAuthException catch (e) {
      CommonUtils.log("e", "firebase init error : ${e.code} : ${e.toString()}");
      callback(false);
    }
  }

  /// firebase FCM =========================================================================== ///
  static String channelIdForAndroid = "upcross_notification";
  static String channelNameForAndroid = "upcross notification";
  static String channelDescForAndroid = "upcross 알림";
  static String channelTitleForIOS = "upcross 알림";

  static Future<void> initFcm(Function(bool isSuccess, String fcmToken) callback) async {
    try{
      await _initFirebase((bool isSuccess) async {
        if(isSuccess){
          CommonUtils.log("i", "firebase init");
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          await messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
          FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
          AndroidNotificationChannel? androidNotificationChannel;

          if(Config.isAndroid){
            androidNotificationChannel = AndroidNotificationChannel(channelIdForAndroid, channelNameForAndroid,description: channelDescForAndroid, importance: Importance.max);
            await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidNotificationChannel);
          }else{
            await messaging.requestPermission(alert: true, announcement: false, badge: true, carPlay: false, criticalAlert: false, provisional: false, sound: true);
          }

          // Background handling event
          FirebaseMessaging.onBackgroundMessage(_handlerForFirebaseMessagingOnBackground);
          // Foreground handling event
          FirebaseMessaging.onMessage.listen((RemoteMessage message) {_handlerForFirebaseMessagingOnForeground(message, flutterLocalNotificationsPlugin, androidNotificationChannel);});

          await initInteractedMessageForBackground(messaging);

          String? firebaseToken = await messaging.getToken();
          if(firebaseToken != null){
            messaging.onTokenRefresh.listen((event) {
              //TODO : 서버에 해당 토큰을 저장하는 로직 구현
            });

            //TODO : 서버에 해당 토큰을 저장하는 로직 구현
            callback(true, firebaseToken);
          }else{
            CommonUtils.log("e", "fcm token is null");
            callback(false, "");
          }
        }else{
          CommonUtils.log("e", "fcm init error");
          callback(false, "");
        }
      });
    }catch(e){
      CommonUtils.log("e", "fcm init error : ${e.toString()}");
      callback(false, "");
    }
  }

  static Future<void> _handlerForFirebaseMessagingOnForeground(RemoteMessage message,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, AndroidNotificationChannel? channel) async {
    CommonUtils.log("i", "fcm foreground message : ${message.toString()}");
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.notification?.title,
          message.notification?.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                channel.name,
                channelDescription: channel.description,
                icon: '@mipmap/ic_launcher',
              ),
              iOS: const DarwinNotificationDetails(
                badgeNumber: 1,
                subtitle: 'the subtitle',
                sound: 'slow_spring_board.aiff',
              )));
    }
  }
  
  static Future<void> _handlerForFirebaseMessagingOnBackground(RemoteMessage message) async {
    CommonUtils.log("i", "fcm background message : ${message.toString()}");
    await _initFirebase((bool isSuccess){
      if(isSuccess){
        CommonUtils.log("i", "firebase init on background");
      }else{
        CommonUtils.log("e", "firebase init error ");
      }
    });
  }

  static Future<void> initInteractedMessageForBackground(FirebaseMessaging fbMsg) async {
    RemoteMessage? initialMessage = await fbMsg.getInitialMessage();
    // 종료상태에서 클릭한 푸시 알림 메세지 핸들링
    if (initialMessage != null) _clickMessageEvent(initialMessage);
    // 앱이 백그라운드 상태에서 푸시 알림 클릭 하여 열릴 경우 메세지 스트림을 통해 처리
    FirebaseMessaging.onMessageOpenedApp.listen(_clickMessageEvent);
  }

  static void _clickMessageEvent(RemoteMessage message) {
    CommonUtils.log("i", "fcm message click : ${message.notification!.toString()}");
    //TODO : 메시지 클릭 이벤트 구현
  }
}