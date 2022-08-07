import 'dart:developer';


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Calls.dart';



// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling a background message ${message.messageId}');
// }

const AndroidNotificationChannel channel = AndroidNotificationChannel('com.deejos.gatello', 'High Importance Notifications',
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
BigPictureStyleInformation? bigPictureStyleInformation;

Future fcmMain() async {
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

// fcmInit() async {
//   // FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
//   //   print(message.toString());
//   // });

//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     if (message.data["type"] == 'chat') {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       AppleNotification? apple = message.notification?.apple;
//       if (notification != null && android != null && apple != null) {
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//                 android: AndroidNotificationDetails(channel.id, channel.name,
//                     channelDescription: channel.description, playSound: true, icon: '@drawable/logo', importance: Importance.max, priority: Priority.high),
//                 iOS: IOSNotificationDetails()));
//       }
//     }
//   });

//   // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//   //   print(message.toString());
//   // });
// }

Future<void> firebaseMessagingHandler(RemoteMessage message) async {
  var payload = message.data;
  log(payload.toString());
  if (payload["type"] == 'call') {
    await showCallkitIncoming(state: 0, message: message);
    await listenerEvent();
  } else {
    try {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description, playSound: true, icon: '@drawable/logo', importance: Importance.max, priority: Priority.high),
                iOS: IOSNotificationDetails()));
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
