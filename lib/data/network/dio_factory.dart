import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lift_app/app/app_preferences.dart';
import 'package:lift_app/app/constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app/di.dart';

// ignore_for_file: constant_identifier_names
const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";

class DioFactory {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  Future<Dio> getDio() async {
    Dio dio = Dio();
    int timeOut = 60 * 1000; //1 min
    Map<String, dynamic> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: _appPreferences.getToken(),
    };

    dio.options = BaseOptions(
        baseUrl: Constants.baseUrl,
        connectTimeout: Duration(seconds: timeOut),
        receiveTimeout: Duration(seconds: timeOut),
        validateStatus: (statusCode) {
          if (statusCode == null) {
            return false;
          }
          if (statusCode == 422 || statusCode == 400) {
            // your http status code
            return true;
          } else {
            return statusCode >= 200 && statusCode < 300;
          }
        },
        headers: headers);
    if (kReleaseMode) {
      log("release mode no logs");
    } else {
      dio.interceptors.add(PrettyDioLogger(
          requestHeader: true, requestBody: true, responseHeader: true));
    }
    return dio;
  }
}
