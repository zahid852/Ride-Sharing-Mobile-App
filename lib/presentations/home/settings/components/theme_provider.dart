import 'package:flutter/material.dart';
import 'package:lift_app/app/app_preferences.dart';
import 'package:lift_app/app/di.dart';

class ThemeProvider with ChangeNotifier {
  final AppPreferences appPreferences = instance<AppPreferences>();
  static bool darkTheme = false;
  bool get getDarkTheme => darkTheme;

  set setDarkTheme(bool value) {
    darkTheme = value;
    appPreferences.setDarkTheme(value);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
