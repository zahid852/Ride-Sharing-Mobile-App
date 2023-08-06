import 'dart:async';
import 'package:lift_app/app/services.dart';
import 'package:lift_app/data/mapper/mappers.dart';
import 'package:lift_app/domain/model/models.dart';

class VehicleInfoViewModel {
  final StreamController _isAllInputsValidStreamController =
      StreamController<void>.broadcast();
  final VehicleInfoModel _vehicleInfoModel =
      VehicleInfoModel(EMPTY, EMPTY, EMPTY, EMPTY);
  void _validate() {
    inputIsAllInputValid.add(null);
  }

  void setBrand(String vehicleBrand) {
    _vehicleInfoModel.brand = vehicleBrand;
    _validate();
  }

  void setNumber(String number) {
    _vehicleInfoModel.number = number;
    _validate();
  }

  bool _isAllInputsValid() {
    if (isStringValid(_vehicleInfoModel.brand) &&
        isStringValid(_vehicleInfoModel.number)) {
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
