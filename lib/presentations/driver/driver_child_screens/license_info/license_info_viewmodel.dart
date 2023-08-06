import 'dart:async';
import 'package:lift_app/app/services.dart';
import 'package:lift_app/data/mapper/mappers.dart';
import 'package:lift_app/domain/model/models.dart';

class LicenseInfoViewModel {
  final StreamController _isAllInputsValidStreamController =
      StreamController<void>.broadcast();
  final LicenseInfoModel _licenseInfoModel =
      LicenseInfoModel(EMPTY, EMPTY, EMPTY, EMPTY);
  void _validate() {
    inputIsAllInputValid.add(null);
  }

  void setNumber(String number) {
    _licenseInfoModel.number = number;
    _validate();
  }

  void setExpiryDate(String expiryDate) {
    _licenseInfoModel.expiryDate = expiryDate;
    _validate();
  }

  bool _isAllInputsValid() {
    if (isStringValid(_licenseInfoModel.expiryDate) &&
        isStringValid(_licenseInfoModel.number)) {
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
}
