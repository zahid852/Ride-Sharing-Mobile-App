import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/app/app_preferences.dart';
import 'package:lift_app/app/di.dart';
import 'package:lift_app/presentations/home/settings/components/theme_provider.dart';
import 'package:lift_app/presentations/resources/routes_manager.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:provider/provider.dart';

final AppPreferences globalAppPreferences = instance<AppPreferences>();

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  // NotificationsService notificationsService = NotificationsService();

  late ThemeProvider _themeProvider;
  //Fetch the current theme
  void getCurrentAppTheme() {
    _themeProvider.setDarkTheme = _themeProvider.appPreferences.getTheme();
  }

  @override
  void initState() {
    // notificationsService.getDeviceToken();
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    getCurrentAppTheme();
    // _appPreferences.logout();
    Future.delayed(const Duration(seconds: 4), () {
      _appPreferences.isUserLogedIn().then((isUserLoggedIn) {
        // log('isUserLogedIn ${isUserLoggedIn}');
        if (isUserLoggedIn) {
          _appPreferences
              .isPassengerProfileDone()
              .then((isPassengerProfileDone) {
            if (isPassengerProfileDone) {
              // log('isPassengerProfileDone ${isPassengerProfileDone}');
              _appPreferences.isUserTheDriver().then((isUserTheDriver) {
                if (isUserTheDriver) {
                  // log('isUserTheDriver $isUserTheDriver');
                  _appPreferences
                      .isDriverProfileDone()
                      .then((isDriverProfileDone) {
                    if (isDriverProfileDone) {
                      // log('isDriverProfileDone $isDriverProfileDone');
                      Navigator.pushReplacementNamed(
                          context, Routes.fetchingDataRoute);
                    } else {
                      Navigator.pushReplacementNamed(
                          context, Routes.driverProfileRoute);
                    }
                  });
                } else {
                  Navigator.pushReplacementNamed(
                      context, Routes.fetchingDataRoute);
                }
              });
            } else {
              Navigator.pushReplacementNamed(
                  context, Routes.passengerProfileRoute);
            }
          });
        } else {
          Navigator.pushReplacementNamed(context, Routes.getOtpRoute);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.black),
        ),
        body: SafeArea(
            child: Container(
          height: getHeight(context: context),
          width: getWidth(context: context),
          color: Colors.lightGreen,
          alignment: Alignment.topCenter,
          child: SizedBox(
              height: getHeight(context: context) * 0.9,
              width: getWidth(context: context),
              child: Center(
                child: DelayedDisplay(
                  slidingCurve: Curves.fastOutSlowIn,
                  fadingDuration: const Duration(seconds: 1),
                  slidingBeginOffset: Offset(getWidth(context: context),
                      getHeight(context: context) / 2),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        'TripShare',
                        style: GoogleFonts.nunito(
                            fontSize: 40,
                            letterSpacing: 1.5,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = Colors.white,
                            fontWeight: FontWeight.w900),
                      ),
                      Text(
                        "TripShare",
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          fontSize: 40,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        )),
      ),
    );
  }
}
