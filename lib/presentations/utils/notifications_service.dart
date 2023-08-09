import 'dart:convert';
import 'dart:developer' as print;
import 'dart:io';
import 'dart:math';
import 'package:lift_app/presentations/splash/splash_screen.dart';
import 'package:timezone/data/latest.dart' as tzl;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:lift_app/data/data_source/local_data_source.dart';
import 'package:lift_app/data/mapper/mappers.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';
import 'package:lift_app/presentations/resources/routes_manager.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import '../../app/di.dart';
import '../../domain/usecases/notification_usecases/send_notification_usecase.dart';

class NotificationsService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final LocalDataSource localDataSource = instance<LocalDataSource>();
  static final SendNotificationUsecase sendNotificationUsecase =
      instance<SendNotificationUsecase>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static void sendPushNotification(
      SendNotificationRequest sendNotificationRequest) async {
    (await sendNotificationUsecase.execute(sendNotificationRequest)).fold(
        (failure) => print.log('notification sent error ${failure.message}'),
        (data) async {
      print.log('notification send');
    });
    // await http.post(
    //   Uri.parse('https://fcm.googleapis.com/fcm/send'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json',
    //     'Authorization':
    //         // 'key=AAAArUNU8SM:APA91bFYt-zoqfK1FmU8TFD16EF7qpkeusVw1tRstab3CqrHq9gdG5odXiq0jHxINKdCrxxiEuhaRCYmkEv5_AG5xqGvJdSSmSJplabt2MchTwe2M_akDJX8aqFgCaDFABhdUcjSvK_1',
    //         'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NGI2YTg3N2Q5ODVkYzhiYmIxMDQ0MDEiLCJpYXQiOjE2OTAyMjE1Mjd9.7h64LrkvSMOiW_KA13a0PUmNMBHZq-KiOgpc3sJ4tgs'
    //   },
    // body: jsonEncode(data),
    // jsonEncode(<String, dynamic>{
    //   'priority': 'high',
    //   'data': data, // data to receive for navigating
    //   'notification': <String, dynamic>{
    //     //actual notification
    //     'body': data['body'],
    //     'title': data['title'],
    //     'android_channel_id': 'TripShare'
    //   },
    //Zahid's token
    // 'to':
    //     'ffCqjeO4QYe-7ThvU4t84o:APA91bGtulwvKSEUjRriGTaWhZlncMDm4cD7psnL3PaMRKNKUTej7LzJbuSOwo3K4kk54n4v34IfdNU7DZtwRZ6TNon3JDnyy6L05tqVTFKr0jfgzZIqIn7niVNTNcQYeJrx2XVwPKoY'
    // 'to':
    //     'cWm0udDTSgqBkDPAsus7Y1:APA91bFZCzq4hQ49DM9pj-E66q0CdYbg6tZ3NuSQmXbPwNUKs5Xrl1RllXLwELmS6SLYuG8g-VnBG_6-NPFgg6zfPycfJszBEnbaj8wEmaB6OFq9qqPlyubzrCEpNnVj3hBpFhhvgFCS'
    // }
    // )
    // );
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true, //enabling notification
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true, //granting access to user
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print.log('user grandted access');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print.log('user grandted provisional access');
    } else {
      print.log('user denied permission');
      // AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  Future<void> getDeviceToken() async {
    PushNotificationCredentials.token = await messaging.getToken() ?? EMPTY;
    globalAppPreferences.setFCMToken(PushNotificationCredentials.token);
    print.log('token ${PushNotificationCredentials.token}');
  }

  void initLocalNotifications(BuildContext context, RemoteMessage message) {
    //by default notifications don't show when the app is in active mode,
    var androidInitializeSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitializeSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      //when the app is in foreground
      handleMessage(context, message);
    });
  }

  Future<void> setUpInteractMessage(BuildContext context) async {
    //handle notification when the app is in terminated mode
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      if (context.mounted) {
        handleMessage(context, message);
      }
    }
    //handle notification when the app is in background mode
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      handleMessage(context, remoteMessage);
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) async {
      print.log('foreground message ${message.messageId}');

      Map<String, dynamic> data =
          jsonDecode(message.data['data']) as Map<String, dynamic>;

      localDataSource.insert(
          LocalDataSourceConstants.notificationTable,
          NotificationModel(
              CommonData.passengerDataModal.id,
              data['title'],
              data['body'],
              data['userImage'],
              '${formatDateToMonthDay(DateTime.now())} at ${formatTimeToTimeString(DateTime.now())}'));

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        await showNotification(message);
      } else {
        await showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
            Random.secure()
                .nextInt(100000)
                .toString(), //different channel id is used notifications to show pop up
            'High Importance Notifications',
            importance: Importance
                .max // setting importance to high will not show notifications
            );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(androidNotificationChannel.id.toString(),
            androidNotificationChannel.name.toString(),
            channelDescription: 'your channel description',
            priority: Priority.high,
            importance: Importance.high,
            ticker: 'ticker');
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails);
  }

  Future<void> scheduleNotification(DateTime date, DateTime time) async {
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
            Random.secure()
                .nextInt(100000)
                .toString(), //different channel id is used notifications to show pop up
            'High Importance Notifications',
            importance: Importance
                .max // setting importance to high will not show notifications
            );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(androidNotificationChannel.id.toString(),
            androidNotificationChannel.name.toString(),
            channelDescription: 'your channel description',
            priority: Priority.high,
            importance: Importance.high,
            ticker: 'ticker');
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    DateTime dateTime = DateTime(
        date.year, date.month, date.day, time.hour, time.minute, time.second);
    tzl.initializeTimeZones();
    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      CommonData.passengerDataModal.name,
      'You have a scheduled ride at the moment. Please start your ride.',
      tz.TZDateTime.from(dateTime, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    final Map<String, dynamic> data =
        jsonDecode(message.data['data']) as Map<String, dynamic>;

    if (data['type'] == 'Message') {
      //done
      try {
        Navigator.of(context).pushNamed(Routes.messageScreenRoute, arguments: [
          data['title'],
          data['userImage'],
          ChatObjectModel.fromJson(data['model']),
        ]);
      } catch (e) {
        print.log('context $context');
        print.log('error $e');
      }
    } else if (data['type'] == 'Accept_request') {
      //done
      try {
        Navigator.of(context).pushReplacementNamed(Routes.homeRoute,
            arguments: [true, int.parse(data['route'])]);
      } catch (e) {
        print.log('context $context');
        print.log('error in accept $e');
      }
    } else if (data['type'] == 'Rejected_request') {
      //done
      Navigator.of(context).pushReplacementNamed(Routes.homeRoute,
          arguments: [true, int.parse(data['route'])]);
    } else if (data['type'] == 'Send_request') {
      //done
      Navigator.of(context).pushNamed(Routes.campaignRequestRoute,
          arguments: data['campaignId']);
    } else if (data['type'] == 'Start_ride') {
      //done
      Navigator.of(context).pushReplacementNamed(Routes.homeRoute,
          arguments: [true, int.parse(data['route'])]);
    } else if (data['type'] == 'End_ride') {
      //done
      Navigator.of(context).pushNamed(
        Routes.ratingBarRoute,
        arguments: [data['driverId'], data['campaignId']],
      );
    } else if (data['type'] == 'Submit_rating') {
      //done
      Navigator.of(context).pushNamed(
        Routes.reviewsRoute,
      );
    }
  }
}
