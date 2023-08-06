import 'package:flutter/foundation.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../../app/di.dart';
import '../../../../domain/usecases/driver_usecases/get_driver_details_usecase.dart';

class ShowProfileViewModel extends ChangeNotifier {
  final GetDriverDetailsUsecase _driverDetailsUsecase =
      instance<GetDriverDetailsUsecase>();
  late DriverDetailsModel driverDetailsModel;
  bool isGotData = false;
  bool showVehicleDetails = false;
  bool showLiscenseDetails = false;

  Future<void> getDriverDetails(String driverId) async {
    (await _driverDetailsUsecase.execute(driverId))
        .fold((failure) => throw failure, (data) async {
      driverDetailsModel = data.driverList.first;

      isGotData = true;
      notifyListeners();
    });
  }

  void customizeVehicleDetailsBox(bool vehicleDetails) {
    showVehicleDetails = !vehicleDetails;
    notifyListeners();
  }

  void customizeLiscenseDetailsBox(bool liscenseDetails) {
    showLiscenseDetails = !liscenseDetails;
    notifyListeners();
  }

  void close() {
    showVehicleDetails = false;
    showLiscenseDetails = false;
    isGotData = false;
  }
}
