import 'dart:async';
import 'package:lift_app/app/services.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/domain/usecases/profile_usecases/register_passenger_usecase.dart';
import '../../app/di.dart';

class ProfileViewModel {
  final RegisterPassengerUsecase _registerPassengerUsecase =
      instance<RegisterPassengerUsecase>();
  final StreamController _isAllInputsValidStreamController =
      StreamController<void>.broadcast();

  final PassengerProfileModel _passengerProfileModel =
      PassengerProfileModel('', '', '', '', '', '');
  void _validate() {
    inputIsAllInputValid.add(null);
  }

  void setName(String name) {
    _passengerProfileModel.name = name;
    _validate();
  }

  void setEmail(String email) {
    _passengerProfileModel.email = email;
    _validate();
  }

  void setCity(String city) {
    _passengerProfileModel.city = city;
    _validate();
  }

  void setGender(String gender) {
    _passengerProfileModel.gender = gender;
    _validate();
  }

  bool _isAllInputsValid() {
    if (isStringValid(_passengerProfileModel.name) &&
        isEmailValid(_passengerProfileModel.email) &&
        isStringValid(_passengerProfileModel.city)) {
      return true;
    } else {
      return false;
    }
  }

  void dispose() {
    _isAllInputsValidStreamController.close();
  }

  Sink get inputIsAllInputValid => _isAllInputsValidStreamController.sink;
  Stream<bool> get outputIsAllInputValid =>
      _isAllInputsValidStreamController.stream.map((_) => _isAllInputsValid());

  Future<void> registerUser(
      RegisterPassengerRequest registerPassengerRequest) async {
    (await _registerPassengerUsecase.execute(registerPassengerRequest))
        .fold((failure) => throw failure, (data) => {});
  }
}
