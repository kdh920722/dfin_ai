import 'dart:io' as io;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dfin/configs/app_config.dart';
import 'package:dfin/controllers/appsflyer_controller.dart';
import 'package:dfin/controllers/websocket_controller.dart';
import 'package:dfin/datas/my_data.dart';
import 'package:dfin/views/app_chat_view.dart';
import 'package:dfin/views/app_main_view.dart';
import '../configs/firebase_options.dart';
import '../utils/common_utils.dart';
import 'logfin_controller.dart';

class FireBaseController{
  static final FireBaseController _instance = FireBaseController._internal();
  factory FireBaseController() => _instance;
  FireBaseController._internal();
  static FirebaseApp? firebaseApp;
  static UserCredential? userCredential;
  static String fcmToken = "";
  static String pushFrom = "";
  static FirebaseAnalytics? analytics;
  static FirebaseAnalyticsObserver? faGaObserver;

  /// firebase database =========================================================================== ///
  static Future<void> initMainFirebase() async {
    try {
      firebaseApp = await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    } on FirebaseAuthException catch (e) {
      CommonUtils.log("e", "firebase main init error : ${e.code} : ${e.toString()}");
    }
  }
  static void initFirebaseAnalyticsEventLog(){
    analytics = FirebaseAnalytics.instance;
    faGaObserver = FirebaseAnalyticsObserver(analytics: analytics!);
  }
  static Future<void> _initFirebaseForBackgroundPush(Function(bool) callback) async {
    try {
      firebaseApp = await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      userCredential = await FirebaseAuth.instance.signInAnonymously();
      callback(true);
    } on FirebaseAuthException catch (e) {
      CommonUtils.log("e", "firebase background push init error : ${e.code} : ${e.toString()}");
      callback(false);
    }
  }
  static Future<void> _initFirebase(Function(bool) callback) async {
    try {
      userCredential = await FirebaseAuth.instance.signInAnonymously();
      callback(true);
    } on FirebaseAuthException catch (e) {
      CommonUtils.log("e", "firebase init error : ${e.code} : ${e.toString()}");
      callback(false);
    }
  }

  static Future<void> writeLog(String type, String id, String msg) async {
    try{
      String dbPath = "DFIN/LOG/$type";

      final snapshot = await FirebaseDatabase.instance.ref().child("$dbPath/$fcmToken").get();
      if (snapshot.exists) {
        final saveRef = FirebaseDatabase.instance.ref().child("$dbPath/$fcmToken");
        final data = {
          CommonUtils.convertTimeToString(CommonUtils.getCurrentLocalTime()) : {
            'id': CommonUtils.encryptData(id),
            'msg': CommonUtils.encryptData(msg),
            'time' : CommonUtils.encryptData(CommonUtils.convertTimeToString(CommonUtils.getCurrentLocalTime()))
          }
        };
        saveRef.update(data).then((_) {
          CommonUtils.log("d", 'Data has been written successfully.');
        }).catchError((error) {
          CommonUtils.log("d", 'Failed to write data: $error');
        });
      }else{
        final saveRef = FirebaseDatabase.instance.ref().child(dbPath);
        final data = {
          fcmToken : {
            CommonUtils.convertTimeToString(CommonUtils.getCurrentLocalTime()) : {
              'id': CommonUtils.encryptData(id),
              'msg': CommonUtils.encryptData(msg),
              'time' : CommonUtils.encryptData(CommonUtils.convertTimeToString(CommonUtils.getCurrentLocalTime()))
            }
          }
        };
        saveRef.update(data).then((_) {
          CommonUtils.log("d", 'Data has been written successfully.');
        }).catchError((error) {
          CommonUtils.log("d", 'Failed to write data: $error');
        });
      }
    }catch(error){
      CommonUtils.log("", "write log error : ${error.toString()}");
    }
  }

  /// firebase FCM =========================================================================== ///
  static String channelIdForAndroid = "dfin_notification";
  static String channelNameForAndroid = "dfin_notification";
  static String channelDescForAndroid = "dfin 알림";
  static String channelTitleForIOS = "dfin 알림";
  static StateSetter? setStateForForeground;

  static Future<void> initFcm(Function(bool isSuccess, String fcmToken) callback) async {
    try{
      await _initFirebase((bool isSuccess) async {
        if(isSuccess){
          CommonUtils.log("i", "firebase init");
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
          FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
          await flutterLocalNotificationsPlugin.initialize(
            const InitializationSettings(
              android: AndroidInitializationSettings("@mipmap/ic_launcher"),
              iOS: DarwinInitializationSettings(),
            ),
            onDidReceiveNotificationResponse: foregroundHandler,
            onDidReceiveBackgroundNotificationResponse: backgroundHandler,
          );
          AndroidNotificationChannel? androidNotificationChannel;
          androidNotificationChannel = AndroidNotificationChannel(channelIdForAndroid, channelNameForAndroid, description: channelDescForAndroid, importance: Importance.max);
          await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidNotificationChannel);

          if(!Config.isAndroid){
           // await messaging.requestPermission(alert: true, announcement: false, badge: true, carPlay: false, criticalAlert: false, provisional: false, sound: true);
          }

          // Foreground handling event
          FirebaseMessaging.onMessage.listen((RemoteMessage message) {_handlerForFirebaseMessagingOnForeground(message, flutterLocalNotificationsPlugin, androidNotificationChannel);});

          // Background handling event
          FirebaseMessaging.onBackgroundMessage(_handlerForFirebaseMessagingOnBackground);

          await initInteractedMessageForBackground(messaging);

          String? firebaseToken = await messaging.getToken();
          if(firebaseToken != null){
            fcmToken = firebaseToken;
            AppsflyerController.appsFlyerOneLinkCnt++;
            if(AppsflyerController.appsFlyerOneLinkCnt == 3){
              AppsflyerController.sendInfoForInstallTracking();
            }
            CommonUtils.log("d", "fcm token : $firebaseToken");
            messaging.onTokenRefresh.listen((event) {
              CommonUtils.log("i", "updated fcm token : $firebaseToken");
            });

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

  static Future<void> setNotificationTorF(bool isValue) async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: isValue, badge: isValue, sound: isValue);
  }

  static Future<void> _showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, AndroidNotificationChannel? channel) async {
    //await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    if(!MyData.isLogout && Config.isAndroid){
      CommonUtils.log("w","dfffascon android");
      String? pushMsg = message.notification?.body.toString().replaceAll("<a href=", "").replaceAll("</a", "").replaceAll("<br>", "").replaceAll("<b>", "").replaceAll("</b>", "").replaceAll(">", "");
      if(pushMsg != null){
        if(pushMsg.contains("http")){
          String ext = pushMsg.split(".").last.toLowerCase();
          if(LogfinController.validFileTypeList.contains(ext)){
            if(LogfinController.validDocFileTypeList.contains(ext)){
              pushMsg = "파일을 보냈습니다.";
            }else{
              pushMsg = "사진을 보냈습니다.";
            }
          }
        }

        flutterLocalNotificationsPlugin.show(
            message.hashCode,
            message.notification?.title,
            pushMsg,
            Config.isAndroid? NotificationDetails(
                android: AndroidNotificationDetails(
                  channel!.id,
                  channel.name,
                  channelDescription: channel.description,
                  icon: '@mipmap/ic_launcher',
                )
            ) : NotificationDetails(
                iOS: DarwinNotificationDetails(
                  badgeNumber: 0,
                  subtitle: channelTitleForIOS,
                  sound: 'slow_spring_board.aiff',
                )
            ),
            payload: _getRoomIdFromMessage(message)
        );
      }
    }

    /*
    Future.delayed(const Duration(milliseconds: 120), () async {
    //  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: false, badge: false, sound: false);
    });
    */

  }

  static Future<void> _handlerForFirebaseMessagingOnForeground(RemoteMessage message,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, AndroidNotificationChannel? channel) async {
    CommonUtils.log("w", "FORE PUSH \n${message.messageId}${message.data}");
    if(message.messageId != null){
      String roomId = _getRoomIdFromMessage(message);
      if(roomId != ""){
        bool isRoomIdHere = false;
        for(var each in WebSocketController.subscribedRoomIds){
          if(each["room_id"] == roomId) isRoomIdHere = true;
        }

        if(!isRoomIdHere){
          CommonUtils.log("w", "FORE PUSH refresh");
          AppMainViewState.refreshMain();
        }
      }

      if(AppChatViewState.currentRoomId == ""){
        // 채팅방 아닐때, show notification
        await _showNotification(message, flutterLocalNotificationsPlugin, channel);

      }else{
        // 채팅방
        if(AppChatViewState.currentRoomId != roomId){
          // 채팅방이지만 다른 채팅방 알림일 때, show notification
          await _showNotification(message, flutterLocalNotificationsPlugin, channel);
        }else{

        }
      }
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _handlerForFirebaseMessagingOnBackground(RemoteMessage message) async {
    CommonUtils.log("w", "BACK PUSH \n${message.messageId}${message.data}");
    await CommonUtils.saveSettingsToFile("push_from", "B");
    await CommonUtils.saveSettingsToFile("push_room_id", _getRoomIdFromMessage(message));


    /*
    await _initFirebaseForBackgroundPush((bool isSuccess) async {
      if(isSuccess){
        CommonUtils.log("", "firebase init on background");
        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
        await flutterLocalNotificationsPlugin.initialize(
          const InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"),
            iOS: DarwinInitializationSettings(),
          ),
          onDidReceiveNotificationResponse: foregroundHandler,
          onDidReceiveBackgroundNotificationResponse: backgroundHandler,
        );

        AndroidNotificationChannel? androidNotificationChannel;
        FirebaseMessaging messaging = FirebaseMessaging.instance;

        await messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

        androidNotificationChannel = AndroidNotificationChannel(channelIdForAndroid, channelNameForAndroid,description: channelDescForAndroid, importance: Importance.max);
        await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidNotificationChannel);
        /*
        //  await messaging.requestPermission(alert: true, announcement: false, badge: true, carPlay: false, criticalAlert: false, provisional: false, sound: true);

        if(message.messageId != null){
          if(AppChatViewState.currentRoomId == ""){
            // 채팅방 아닐때, show notification
            await _showNotification(message, flutterLocalNotificationsPlugin, androidNotificationChannel);
          }else{
            // 채팅방
            if(AppChatViewState.currentRoomId != _getRoomIdFromMessage(message)){
              // 채팅방이지만 다른 채팅방 알림일 때, show notification
              await _showNotification(message, flutterLocalNotificationsPlugin, androidNotificationChannel);
            }
          }
        }
         */

      }else{
        CommonUtils.log("e", "firebase init error ");
      }
    });
    */
  }

  static Future<void> initInteractedMessageForBackground(FirebaseMessaging fbMsg) async {
    RemoteMessage? message = await fbMsg.getInitialMessage();
    if(io.Platform.isAndroid){
      if (message != null) {
        // 액션 부분 -> 파라미터는 message.data['test_parameter1'] 이런 방식으로...
        CommonUtils.log("w", "fcm getInitialMessage android : ${_getRoomIdFromMessage(message)}");
      }
    }else if(io.Platform.isIOS){
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
        CommonUtils.log("w", "fcm getInitialMessage ios : ${_getRoomIdFromMessage(message)}");
        await CommonUtils.saveSettingsToFile("push_from", "B");
        await CommonUtils.saveSettingsToFile("push_room_id", _getRoomIdFromMessage(message));
        await CommonUtils.printSettingsFromFile();
        if(setStateForForeground != null){
          CommonUtils.log("", "not null");
          setStateForForeground!((){});
        }
      });
    }
  }

  static Future<void> backgroundHandler(NotificationResponse details) async {
    CommonUtils.log("w", "[Background] onDidReceiveNotificationResponse : ${details.id} || ${details.payload}");
    await CommonUtils.saveSettingsToFile("push_from", "B");
    await CommonUtils.saveSettingsToFile("push_room_id", "${details.payload}");
    await CommonUtils.printSettingsFromFile();
    if(setStateForForeground != null){
      CommonUtils.log("", "not null");
      setStateForForeground!((){});
    }
  }

  static Future<void> foregroundHandler(NotificationResponse details) async {
    CommonUtils.log("w", "[Foreground] onDidReceiveNotificationResponse : ${details.id} || ${details.payload}");
    await CommonUtils.saveSettingsToFile("push_from", "F");
    await CommonUtils.saveSettingsToFile("push_room_id", "${details.payload}");
    await CommonUtils.printSettingsFromFile();
    if(setStateForForeground != null){
      CommonUtils.log("", "not null");
      setStateForForeground!((){});
    }
  }

  static String _getRoomIdFromMessage(RemoteMessage message){
    String roomId = "";
    if(message.notification != null){
      Map<String, dynamic> resultData = message.data;
      if (resultData.containsKey("room_id")) {
        roomId = resultData["room_id"].toString();
      }
    }

    return roomId;
  }
}