import 'dart:async';
import 'dart:developer';

import 'package:lift_app/app/di.dart';
import 'package:lift_app/domain/usecases/auth_usecases/get_otp_usecase.dart';

class GetOtpViewModel {
  final GetOtpUsecase _getOtpUsecase = instance<GetOtpUsecase>();
  final StreamController _phoneNumberStreamController =
      StreamController<String>.broadcast();
  setPhoneNumber(String phoneNumber) {
    inputNumber.add(phoneNumber);
  }

  bool isPhoneNumberValid(String phone) {
    return phone.length == 10;
  }

  void dispose() {
    _phoneNumberStreamController.close();
  }

  Sink get inputNumber => _phoneNumberStreamController.sink;
  Stream<bool> get outputIsNumberValid => _phoneNumberStreamController.stream
      .map((phoneNumber) => isPhoneNumberValid(phoneNumber));

  Future<void> getOtp(String phone) async {
    (await _getOtpUsecase.execute(phone)).fold((failure) => throw failure,
        (data) => log('otp message ${data.message}'));
  }
}
