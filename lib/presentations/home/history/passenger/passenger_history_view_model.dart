import 'package:flutter/material.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/domain/usecases/campaigns_usecases/passenger_history_usecase.dart';

import '../../../../app/di.dart';
import '../../../../data/request/request.dart';

class PassengerHistoryRidesViewModel extends ChangeNotifier {
  final GetPassengerHistoryUsecase _getPassengerHistoryUsecase =
      instance<GetPassengerHistoryUsecase>();

  List<ScheduleRideDataModal> historyRidesList = [];
  bool isGotData = false;

  Future<void> getScheduleRidesData(String passengerId) async {
    (await _getPassengerHistoryUsecase
            .execute(PassengerDataRequest(passengerId)))
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
