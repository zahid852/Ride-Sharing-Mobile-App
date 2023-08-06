import 'package:flutter/material.dart';
import 'package:lift_app/domain/usecases/campaigns_usecases/cancel_ride_usecase.dart';
import 'package:ntp/ntp.dart';
import '../../../app/di.dart';
import '../../../data/request/request.dart';
import '../../../domain/model/models.dart';
import '../../../domain/usecases/campaigns_usecases/get_driver_schedule_rides_usecase.dart';
import '../../../domain/usecases/campaigns_usecases/start_campaign_usecase.dart';

class ScheduleRidesViewModel extends ChangeNotifier {
  final GetDriverScheduleRidesDataUsecase _getDriverScheduleRidesDataUsecase =
      instance<GetDriverScheduleRidesDataUsecase>();
  final StartRideUsecase _startRideUsecase = instance<StartRideUsecase>();
  final CancelRideUsecase _cancelRideUsecase = instance<CancelRideUsecase>();
  List<ScheduleRideDataModal> scheduleRidesList = [];
  bool isGotData = false;

  DateTime currentDateTime = DateTime.now();

  Future<void> getScheduleRidesData(String driverId) async {
    (await _getDriverScheduleRidesDataUsecase
            .execute(DriverScheduleRidesRequest(driverId)))
        .fold((failure) => throw failure, (data) async {
      currentDateTime = await NTP.now();
      scheduleRidesList = data.scheduleRideList.where((scheduleRideModel) {
        DateTime date = DateTime.parse(scheduleRideModel.date);
        DateTime time = DateTime.parse(scheduleRideModel.time);
        DateTime combineDateTime = DateTime(date.year, date.month, date.day,
            time.hour, time.minute, time.second);
        if (combineDateTime.isAfter(
                currentDateTime.subtract(const Duration(minutes: 15))) &&
            scheduleRideModel.status == 0 &&
            scheduleRideModel.isNowRide == false) {
          return true;
        } else {
          return false;
        }
      }).toList();

      isGotData = true;
      notifyListeners();
    });
  }

  Future<void> startRide(RideStatusRequest rideStatusRequest) async {
    (await _startRideUsecase.execute(rideStatusRequest))
        .fold((failure) => throw failure, (data) async {});
  }

  Future<void> cancelRide(
      CancelDriverRideRequest cancelDriverRideRequest) async {
    (await _cancelRideUsecase.execute(cancelDriverRideRequest))
        .fold((failure) => throw failure, (data) async {
      scheduleRidesList.removeWhere((campaign) =>
          campaign.campaignId == cancelDriverRideRequest.campaignId);
    });
  }
}
