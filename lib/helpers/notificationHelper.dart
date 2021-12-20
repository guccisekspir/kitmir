import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // BottomNavBarBloc _bottomNavBarBloc;
  final Map<String, dynamic> data = message.data;
  debugPrint("background tetiklendi" + data.toString());
  if (message.data.isNotEmpty) {
    NotificationHelper.showDataNotification(message);
  }

  debugPrint("Handling a background message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class NotificationHelper {
  static final NotificationHelper singleton = NotificationHelper._internal();
  factory NotificationHelper() {
    return singleton;
  }
  NotificationHelper._internal();

  subscribeTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    debugPrint("Subscribed to $topic");
  }

  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  initializeFCMNotification(BuildContext context) async {
    debugPrint("aaaaa geldi");
    await FirebaseMessaging.instance.subscribeToTopic("main");

    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      //notificationBloc.add(SaveToken());
    });

    try {
      if (Platform.isIOS) {
        NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
      }
      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

      /// Note: permissions aren't requested here just to demonstrate that can be
      /// done later
      const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
      );
    } catch (e) {
      debugPrint(e.toString());
//      FirebaseCrashlytics.instance.recordError("Notification Initialize Error", StackTrace.current);
    }

    RemoteMessage? buneMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (buneMessage != null) {
      debugPrint(buneMessage.sentTime.toString() + buneMessage.from.toString());
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');
        if (message.data.isNotEmpty) {
          showDataNotification(message);
          if (message.data["type"] == "place") {}
        } else {
          showNotification(message.notification!);
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      debugPrint("dassssssssra" + event.sentTime.toString());
    });

/*
  *Handle any interaction when the app is in the background via a
  *Stream listener
 */

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> showNotification(RemoteNotification message1) async {
    if (Platform.isAndroid) {
      debugPrint("************** platform android data null");

      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('1', 'like',
          icon: 'app_icon',
          channelDescription: 'Like notifications',
          importance: Importance.max,
          priority: Priority.high,
          enableLights: true,
          ledOffMs: 100,
          ledOnMs: 100,
          groupKey: "like",
          ledColor: Colors.green,
          visibility: NotificationVisibility.public,
          ticker: 'ticker');
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
          0, (message1.title ?? "Gain & Grind"), message1.body ?? "Gain & Grind", platformChannelSpecifics,
          payload: "jsonEncode(message1)");
    } else {
      debugPrint("platform ios data null");
      const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(threadIdentifier: "like");
      const NotificationDetails platformChannelSpecifics = NotificationDetails(iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(0, message1.title, message1.body, platformChannelSpecifics,
          payload: "jsonEncode(message1)");
    }
  }

  static Future<void> showDataNotification(RemoteMessage dataMessage) async {
    Map<String, dynamic> message = dataMessage.data;

    if (Platform.isAndroid) {
      debugPrint("************** playform android data notnull");
      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('1', 'like',
          importance: Importance.max,
          icon: 'app_icon',
          priority: Priority.max,
          enableLights: true,
          ledColor: Colors.green,
          visibility: NotificationVisibility.public,
          ledOffMs: 1000,
          ledOnMs: 1000,
          color: Colors.limeAccent,
          ticker: 'ticker');
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
          0, (message["title"] ?? "Gain & Grind"), message["body"] ?? "title boş", platformChannelSpecifics,
          payload: jsonEncode(message));
    } else {
      debugPrint("platform ios daha notnull");
      const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(threadIdentifier: "like");
      const NotificationDetails platformChannelSpecifics = NotificationDetails(iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(0, message["title"], message["body"], platformChannelSpecifics,
          payload: jsonEncode(message));
    }
  }
}
