import 'package:flutter/material.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';
import 'package:lift_app/presentations/home/history/passenger/passenger_history_view_model.dart';
import 'package:lift_app/presentations/home/messages/messages_view_model.dart';
import 'package:lift_app/presentations/home/ride/ride_view_model.dart';
import 'package:lift_app/presentations/home/schedule_rides/components/requests_view_model.dart';
import 'package:lift_app/presentations/home/schedule_rides/schedule_rides_view_model.dart';
import 'package:lift_app/presentations/home/search/search_ride_view_model.dart';
import 'package:lift_app/presentations/home/search/searches_view_model.dart';
import 'package:lift_app/presentations/home/settings/components/theme_provider.dart';
import 'package:lift_app/presentations/resources/routes_manager.dart';
import 'package:lift_app/presentations/resources/theme_manager.dart';
import 'package:provider/provider.dart';

import '../presentations/home/now_ride/now_ride_view_model.dart';
import '../presentations/home/history/driver/driver_history_view_model.dart';
import '../presentations/home/passenger_requests/passenger_request_view_model.dart';
import '../presentations/home/settings/components/profile_view_model.dart';
import '../presentations/home/settings/components/review_view_model.dart';

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({Key? key, required this.navigatorKey}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DrawerViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchRidesViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ScheduleRidesViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => PassengerRequestsViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => PassengerAllRequestsViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => RideViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => MessagesViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DriverHistoryRidesViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => PassengerHistoryRidesViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ShowProfileViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => NowRideViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReviewViewModel(),
        ),
      ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
        return MaterialApp(
          navigatorKey: widget.navigatorKey,
          debugShowCheckedModeBanner: false,
          theme:
              ApplicationTheme.themeData(themeProvider.getDarkTheme, context),
          initialRoute: Routes.splashRoute,
          onGenerateRoute: RouteGenerator.getRoute,
        );
      }),
    );
  }
}
