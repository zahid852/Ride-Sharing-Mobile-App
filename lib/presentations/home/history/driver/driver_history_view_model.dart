import 'package:flutter/material.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../../app/di.dart';
import '../../../../data/request/request.dart';
import '../../../../domain/usecases/campaigns_usecases/get_driver_schedule_rides_usecase.dart';

class DriverHistoryRidesViewModel extends ChangeNotifier {
  final GetDriverScheduleRidesDataUsecase _getDriverScheduleRidesDataUsecase =
      instance<GetDriverScheduleRidesDataUsecase>();

  List<ScheduleRideDataModal> historyRidesList = [];
  bool isGotData = false;

  Future<void> getScheduleRidesData(String driverId) async {
    (await _getDriverScheduleRidesDataUsecase
            .execute(DriverScheduleRidesRequest(driverId)))
        .fold((failure) => throw failure, (data) async {
      historyRidesList = data.scheduleRideList
          .where((scheduleRideModel) {
            if (scheduleRideModel.status == 2 ||
                scheduleRideModel.status == 3) {
              return true;
            } else {
              return false;
            }
          })
          .toList()
          .reversed
          .toList();

      isGotData = true;
      notifyListeners();
    });
  }
}
