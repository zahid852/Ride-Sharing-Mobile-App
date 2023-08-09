import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:lift_app/app/app.dart';
import 'package:lift_app/app/app_preferences.dart';
import 'package:lift_app/app/di.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'data/data_source/local_data_source.dart';

@pragma('vm:entry-point')
Future<void> _firbaseMessageHandler(RemoteMessage message) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final AppPreferences appPreferences = AppPreferences(sharedPreferences);
  final LocalDataSource localDataSource = LocalDataSource(appPreferences);
  await Firebase.initializeApp();
  Map<String, dynamic> data =
      jsonDecode(message.data['data']) as Map<String, dynamic>;

  localDataSource.insert(
      LocalDataSourceConstants.notificationTable,
      NotificationModel(
          appPreferences.getUserId(),
          data['title'],
          data['body'],
          data['userImage'],
          '${formatDateToMonthDay(DateTime.now())} at ${formatTimeToTimeString(DateTime.now())}'));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  final navigatorKey = GlobalKey<NavigatorState>();

  ZegoUIKitPrebuiltCallInvitationService()
      .setNavigatorKey(navigatorKey); //for call
  await initAppModule();
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;

  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = false;
    mapsImplementation.initializeWithRenderer(AndroidMapRenderer.latest);
  }
  FirebaseMessaging.onBackgroundMessage(_firbaseMessageHandler);

  runApp(MyApp(navigatorKey: navigatorKey));
}
