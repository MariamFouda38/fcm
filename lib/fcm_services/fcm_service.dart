import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

 class FcmService {
   static FirebaseMessaging messaging = FirebaseMessaging.instance;

 static  init()async{
     await permissionIos();
     await getDevicetoken();
 handleOnBaclGroundMessage();
     handleForGroundMessage();
  }
static permissionIos()async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

static getDevicetoken()async{
   String? token= await messaging.getToken();
  }

static handleOnBaclGroundMessage(){
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  }

   static handleForGroundMessage()async{
     AndroidNotificationChannel channel = AndroidNotificationChannel(
       'high_importance_channel', // id
       'High Importance Notifications', // title
       'This channel is used for important notifications.', // description
       importance: Importance.max,
     );
     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
     FlutterLocalNotificationsPlugin();

     await flutterLocalNotificationsPlugin
         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
         ?.createNotificationChannel(channel);
     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
       RemoteNotification? notification = message.notification;
       AndroidNotification? android = message.notification?.android;

       // If `onMessage` is triggered with a notification, construct our own
       // local notification to show to users using the created channel.
       if (notification != null && android != null) {
         flutterLocalNotificationsPlugin.show(
             notification.hashCode,
             notification.title,
             notification.body,
             NotificationDetails(
               android: AndroidNotificationDetails(
                 channel.id,
                 channel.name,
                 channelDescription:channel.description,
                 icon: '@mipmap/ic_launcher',
                 // other properties...
               ),
             ));
       }
     });
   }
}