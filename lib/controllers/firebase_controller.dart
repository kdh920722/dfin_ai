import 'dart:io' as io;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:upfin/configs/app_config.dart';
import 'package:upfin/views/app_chat_view.dart';
import '../configs/firebase_options.dart';
import '../utils/common_utils.dart';

class FireBaseController{
  static final FireBaseController _instance = FireBaseController._internal();
  factory FireBaseController() => _instance;
  FireBaseController._internal();
  static FirebaseApp? firebaseApp;
  static UserCredential? userCredential;
  static String fcmToken = "";
  static String pushFrom = "";

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

  static Future<void> writeLog(String type, String id, String msg) async {
    try{
      String dbPath = "";
      if(type == "error"){
        dbPath = "UPFIN/LOG/error";
      }else{
        dbPath = "UPFIN/LOG/info";
      }

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
          CommonUtils.log("i", 'Data has been written successfully.');
        }).catchError((error) {
          CommonUtils.log("i", 'Failed to write data: $error');
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
          CommonUtils.log("i", 'Data has been written successfully.');
        }).catchError((error) {
          CommonUtils.log("i", 'Failed to write data: $error');
        });
      }
    }catch(error){
      CommonUtils.log("i", "write log error : ${error.toString()}");
    }
  }

  /// firebase FCM =========================================================================== ///
  static String channelIdForAndroid = "upfin_notification";
  static String channelNameForAndroid = "upfin_notification";
  static String channelDescForAndroid = "upfin 알림";
  static String channelTitleForIOS = "upfin 알림";
  static StateSetter? setStateForForeground;

  static Future<void> initFcm(Function(bool isSuccess, String fcmToken) callback) async {
    try{
      await _initFirebase((bool isSuccess) async {
        if(isSuccess){
          CommonUtils.log("i", "firebase init");
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          await messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
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

          if(Config.isAndroid){
            androidNotificationChannel = AndroidNotificationChannel(channelIdForAndroid, channelNameForAndroid, description: channelDescForAndroid, importance: Importance.max);
            await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidNotificationChannel);
          }else{
            await messaging.requestPermission(alert: true, announcement: false, badge: true, carPlay: false, criticalAlert: false, provisional: false, sound: true);
          }

          // Foreground handling event
          FirebaseMessaging.onMessage.listen((RemoteMessage message) {_handlerForFirebaseMessagingOnForeground(message, flutterLocalNotificationsPlugin, androidNotificationChannel);});

          // Background handling event
          FirebaseMessaging.onBackgroundMessage(_handlerForFirebaseMessagingOnBackground);

          await initInteractedMessageForBackground(messaging);

          String? firebaseToken = await messaging.getToken();
          if(firebaseToken != null){
            fcmToken = firebaseToken;
            CommonUtils.log("d", "fcm token : $firebaseToken");
            messaging.onTokenRefresh.listen((event) {
              //TODO : 서버에 해당 토큰을 저장하는 로직 구현
              CommonUtils.log("i", "updated fcm token : $firebaseToken");
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
    CommonUtils.log("", "fcm foreground message : ${message.toString()}");
    await CommonUtils.saveSettingsToFile("push_from", "F");
    if (message.notification != null) {
      Map<String, dynamic> resultData = message.data;
      if (resultData.containsKey("room_id")) {
        String roomId = resultData["room_id"].toString();
        if (AppChatViewState.currentRoomId == "" || AppChatViewState.currentRoomId != roomId) {
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
                  )),
              payload: _getRoomIdFromMessage(message)
          );
        }
      } else {
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
                )),
            payload: _getRoomIdFromMessage(message));
      }
    }
  }
  
  static Future<void> _handlerForFirebaseMessagingOnBackground(RemoteMessage message) async {
    await CommonUtils.saveSettingsToFile("push_from", "B");
    await _initFirebase((bool isSuccess) async {
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

        if(Config.isAndroid){
          androidNotificationChannel = AndroidNotificationChannel(channelIdForAndroid, channelNameForAndroid,description: channelDescForAndroid, importance: Importance.max);
          await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidNotificationChannel);
        }else{
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          await messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
          await messaging.requestPermission(alert: true, announcement: false, badge: true, carPlay: false, criticalAlert: false, provisional: false, sound: true);
        }

        flutterLocalNotificationsPlugin.show(
            message.hashCode,
            message.notification?.title,
            message.notification?.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                  androidNotificationChannel!.id,
                  androidNotificationChannel.name,
                  channelDescription: androidNotificationChannel.description,
                  icon: '@mipmap/ic_launcher',
                ),
                iOS: const DarwinNotificationDetails(
                  badgeNumber: 1,
                  subtitle: 'the subtitle',
                  sound: 'slow_spring_board.aiff',
                ),
            ),
            payload: _getRoomIdFromMessage(message));

      }else{
        CommonUtils.log("e", "firebase init error ");
      }
    });
  }

  static Future<void> initInteractedMessageForBackground(FirebaseMessaging fbMsg) async {
    if(io.Platform.isAndroid){
      RemoteMessage? message = await fbMsg.getInitialMessage();
      if (message != null) {
        // 액션 부분 -> 파라미터는 message.data['test_parameter1'] 이런 방식으로...
        CommonUtils.log("", "fcm getInitialMessage android : ${_getRoomIdFromMessage(message)}");
      }
    }else if(io.Platform.isIOS){
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        CommonUtils.log("", "fcm getInitialMessage ios : ${_getRoomIdFromMessage(message)}");
      });
    }
  }

  static Future<void> backgroundHandler(NotificationResponse details) async {
    CommonUtils.log("", "[Background] onDidReceiveNotificationResponse : ${details.id} || ${details.payload}");
    await CommonUtils.saveSettingsToFile("push_room_id", "${details.payload}");
    await CommonUtils.printSettingsFromFile();
    if(setStateForForeground != null){
      CommonUtils.log("", "not null");
      setStateForForeground!((){});
    }
  }

  static Future<void> foregroundHandler(NotificationResponse details) async {
    CommonUtils.log("", "[Foreground] onDidReceiveNotificationResponse : ${details.id} || ${details.payload}");
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