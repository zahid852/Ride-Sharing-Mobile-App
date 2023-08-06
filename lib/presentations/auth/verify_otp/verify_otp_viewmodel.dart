import 'dart:async';

import 'package:lift_app/app/app_preferences.dart';
import 'package:lift_app/app/di.dart';
import 'package:lift_app/data/mapper/mappers.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/usecases/auth_usecases/verify_otp_usecase.dart';
import 'package:lift_app/presentations/resources/routes_manager.dart';

class VerifyOtpViewModel {
  final VerifyOtpUsecase _verifyOtpUsecase = instance<VerifyOtpUsecase>();
  final StreamController _verificationCodeStreamController =
      StreamController<String>.broadcast();
  StreamController isUserloggedInSuccesfullyStreamController =
      StreamController<String>();

  final AppPreferences _appPreferences = instance<AppPreferences>();
  setVerificationCode(String verificationCode) {
    inputCode.add(verificationCode);
  }

  bool isPhoneNumberValid(String verificationCode) {
    return verificationCode.length == 4;
  }

  void dispose() {
    _verificationCodeStreamController.close();
    isUserloggedInSuccesfullyStreamController.close();
  }

  Sink get inputCode => _verificationCodeStreamController.sink;
  Stream<bool> get outputIsCodeValid => _verificationCodeStreamController.stream
      .map((phoneNumber) => isPhoneNumberValid(phoneNumber));
  Future<void> verifyOtp(VerifyOtpRequest verifyOtpRequest) async {
    (await _verifyOtpUsecase.execute(verifyOtpRequest))
        .fold((failure) => throw failure, (data) {
      _appPreferences.setUserLoggedIn();
      _appPreferences.setToken(data.token);
      _appPreferences.setUserId(data.userId);
      resetAllModules();
      String route = EMPTY;
      if (data.isProfileCreated) {
        _appPreferences.setPassengerProfileDone();
        if (data.isDriver) {
          _appPreferences.setUserAsDriver();
          if (data.isDriverProfileCreated) {
            _appPreferences.setDriverProfileDone();
            route = Routes.fetchingDataRoute;
          } else {
            route = Routes.driverProfileRoute;
          }
        } else {
          route = Routes.fetchingDataRoute;
        }
      } else {
        route = Routes.passengerProfileRoute;
      }
      isUserloggedInSuccesfullyStreamController.add(route);
    });
  }
}
