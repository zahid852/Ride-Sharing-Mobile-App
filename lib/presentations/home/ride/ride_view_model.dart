import 'package:flutter/material.dart';
import 'package:lift_app/app/di.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/usecases/campaigns_usecases/picking_passenger_usecase.dart';

import '../../../domain/usecases/campaigns_usecases/end_campaign_usecase.dart';

class RideViewModel extends ChangeNotifier {
  final PickingPassengerRequestUsecase _pickingPassengerRequestUsecase =
      instance<PickingPassengerRequestUsecase>();
  final EndRideUsecase _endRideUsecase = instance<EndRideUsecase>();
  List<String> usersList = [];
  Future<void> pickingPassenger(
      PickingPassengerRequest pickingPassengerRequest) async {
    (await _pickingPassengerRequestUsecase.execute(pickingPassengerRequest))
        .fold((failure) => throw failure, (data) async {
      usersList.add(pickingPassengerRequest.passengerId!);

      notifyListeners();
    });
  }

  Future<void> endRide(RideStatusRequest rideStatusRequest) async {
    (await _endRideUsecase.execute(rideStatusRequest))
        .fold((failure) => throw failure, (data) async {});
  }
}
