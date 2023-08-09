// ignore_for_file: constant_identifier_names

import 'package:lift_app/app/di.dart';
import 'package:lift_app/data/mapper/mappers.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

const String PREFS_KEY_IS_USER_LOGGED_IN = "PREFS_KEY_IS_USER_LOGGED_IN";
const String PREFS_KEY_IS_PASSENGER_PROFILE_DONE =
    "PREFS_KEY_IS_PASSENGER_PROFILE_DONE";
const String PREFS_KEY_IS_USER_DRIVER = "PREFS_KEY_IS_USER_DRIVER";
const String PREFS_KEY_IS_DRIVER_PROFILE_DONE =
    "PREFS_KEY_IS_DRIVER_PROFILE_DONE";
const String PREFS_KEY_TOKEN = "PREFS_KEY_TOKEN";
const String PREFS_KEY_USER_ID = "PREFS_KEY_USER_ID";
const String THEME_STATUS = "THEME_STATUS";
const String FCM_TOKEN = "FCM_TOKEN";

class AppPreferences {
  final SharedPreferences _sharedPreferences;
  AppPreferences(this._sharedPreferences);
  void setToken(String token) {
    _sharedPreferences.setString(PREFS_KEY_TOKEN, 'Bearer $token');
  }

  void setUserId(String userId) {
    _sharedPreferences.setString(PREFS_KEY_USER_ID, userId);
  }

  String getUserId() {
    return _sharedPreferences.getString(PREFS_KEY_USER_ID) ?? EMPTY;
  }

  String getToken() {
    return _sharedPreferences.getString(PREFS_KEY_TOKEN) ?? EMPTY;
  }

  void setUserLoggedIn() {
    _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED_IN, true);
  }

  Future<bool> isUserLogedIn() async {
    return _sharedPreferences.getBool(PREFS_KEY_IS_USER_LOGGED_IN) ?? false;
  }

  void setPassengerProfileDone() {
    _sharedPreferences.setBool(PREFS_KEY_IS_PASSENGER_PROFILE_DONE, true);
  }

  Future<bool> isPassengerProfileDone() async {
    return _sharedPreferences.getBool(PREFS_KEY_IS_PASSENGER_PROFILE_DONE) ??
        false;
  }

  void setUserAsDriver() {
    _sharedPreferences.setBool(PREFS_KEY_IS_USER_DRIVER, true);
  }

  Future<bool> isUserTheDriver() async {
    return _sharedPreferences.getBool(PREFS_KEY_IS_USER_DRIVER) ?? false;
  }

  void setDriverProfileDone() {
    _sharedPreferences.setBool(PREFS_KEY_IS_DRIVER_PROFILE_DONE, true);
  }

  Future<bool> isDriverProfileDone() async {
    return _sharedPreferences.getBool(PREFS_KEY_IS_DRIVER_PROFILE_DONE) ??
        false;
  }

  setDarkTheme(bool value) async {
    _sharedPreferences.setBool(THEME_STATUS, value);
  }

  bool getTheme() {
    return _sharedPreferences.getBool(
          THEME_STATUS,
        ) ??
        false;
  }

  void setFCMToken(String fcmToken) {
    _sharedPreferences.setString(FCM_TOKEN, fcmToken);
  }

  String getFCMToken() {
    return _sharedPreferences.getString(FCM_TOKEN) ?? EMPTY;
  }

  Future<void> logout() async {
    // _sharedPreferences.remove(PREFS_KEY_IS_USER_LOGGED_IN);
    // _sharedPreferences.remove(PREFS_KEY_TOKEN);
    // _sharedPreferences.remove(PREFS_KEY_USER_ID);
    // _sharedPreferences.remove(THEME_STATUS);
    // _sharedPreferences.remove(PREFS_KEY_IS_DRIVER_PROFILE_DONE);
    CommonData.isDataFetched = false;
    ZegoUIKitPrebuiltCallInvitationService().uninit();
    _sharedPreferences.clear();
    resetAllModules();
  }
}
