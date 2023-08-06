import 'dart:async';
import 'package:lift_app/app/services.dart';
import 'package:lift_app/data/mapper/mappers.dart';
import 'package:lift_app/domain/model/models.dart';

class BaseInfoViewModel {
  final StreamController _isAllInputsValidStreamController =
      StreamController<void>.broadcast();
  final BasicInfoModel _basicInfoModel =
      BasicInfoModel(EMPTY, EMPTY, EMPTY, EMPTY, EMPTY);
  void _validate() {
    inputIsAllInputValid.add(null);
  }

  void setCNIC(String cnic) {
    _basicInfoModel.cnic = cnic;
    _validate();

    // inputCNIC.add(cnic);
  }

  void setFatherName(String fatherName) {
    _basicInfoModel.fatherName = fatherName;
    _validate();
    // inputFatherName.add(fatherName);
  }

  void setBirthDate(String birthDate) {
    _basicInfoModel.birthDate = birthDate;
    _validate();
    // inputBirthDate.add(birthDate);
  }

  void setAddress(String address) {
    _basicInfoModel.address = address;
    _validate();
    // inputAddress.add(address);
  }

  bool _isCNICValid(String cnic) {
    return cnic.length == 15;
  }

  bool _isAllInputsValid() {
    if (_isCNICValid(_basicInfoModel.cnic) &&
        isStringValid(_basicInfoModel.fatherName) &&
        isStringValid(_basicInfoModel.birthDate) &&
        isStringValid(_basicInfoModel.address)) {
      return true;
    } else {
      return false;
    }
  }

  void dispose() {
    // _cnicStreamController.close();
    // _fatherNameStreamController.close();
    // _birthDateStreamController.close();
    // _addressStreamController.close();
    _isAllInputsValidStreamController.close();
  }

  // Sink get inputCNIC => _cnicStreamController.sink;
  // Stream<bool> get outputIsCNICValid =>
  //     _cnicStreamController.stream.map((cnic) => isCNICValid(cnic));

  // Sink get inputFatherName => _fatherNameStreamController.sink;
  // Stream<bool> get outputIsFatherNameValid => _fatherNameStreamController.stream
  //     .map((fatherName) => isStringValid(fatherName));

  // Sink get inputBirthDate => _birthDateStreamController.sink;
  // Stream<bool> get outputIsBirthDateValid => _birthDateStreamController.stream
  //     .map((birthDate) => isStringValid(birthDate));

  // Sink get inputAddress => _addressStreamController.sink;
  // Stream<bool> get outputIsAddressValid =>
  //     _addressStreamController.stream.map((address) => isStringValid(address));

  Sink get inputIsAllInputValid => _isAllInputsValidStreamController.sink;
  Stream<bool> get outputIsAllInputValid =>
      _isAllInputsValidStreamController.stream.map((_) => _isAllInputsValid());
}
