import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/domain/usecases/campaigns_usecases/get_passenger_requests_usecase.dart';
import '../../../app/di.dart';
import '../../../domain/usecases/campaigns_usecases/cancel_ride_usecase.dart';
import '../../../domain/usecases/campaigns_usecases/decline_passenger_request_usecase.dart';
import '../../../domain/usecases/campaigns_usecases/start_campaign_usecase.dart';
import '../../../domain/usecases/campaigns_usecases/update_request_usecase.dart';

class NowRideViewModel extends ChangeNotifier {
  final GetPassengerRequestsUsecase _getPassengerRequestsUsecase =
      instance<GetPassengerRequestsUsecase>();
  final UpdatePassengerRequestUsecase _updatePassengerRequestUsecase =
      instance<UpdatePassengerRequestUsecase>();
  final DeclinePassengerRequestUsecase _declinePassengerRequestUsecase =
      instance<DeclinePassengerRequestUsecase>();
  final StartRideUsecase _startRideUsecase = instance<StartRideUsecase>();
  final CancelRideUsecase _cancelRideUsecase = instance<CancelRideUsecase>();
  List<PassengerDetailRequestResponseData> requestsList = [];
  StartRideModel? startRideModel;
  List<String> usersList = [];
  ScheduleRideDataModal? dataToSend;

  Future<void> getRequestsData(
      PassengerRequestsGetRequest passengerRequestsGetRequest) async {
    (await _getPassengerRequestsUsecase.execute(passengerRequestsGetRequest))
        .fold((failure) => throw failure, (data) async {
      requestsList = data.passengerRequestsData.reversed.toList();
      requestsList.removeWhere((data) => data.requestStatus == 'decline');
      requestsList.sort((data1, data2) {
        return data1.requestStatus.compareTo(data2.requestStatus);
      });
      notifyListeners();
    });
  }

  Future<void> declineRequestData(
      DeclinePassengerRequest declinePassengerRequest) async {
    (await _declinePassengerRequestUsecase.execute(declinePassengerRequest))
        .fold((failure) => throw failure, (data) {});
  }

  Future<void> updateRequestData(UpdatePassengerRequest updatePassengerRequest,
      PassengerDetailRequestResponseData passengerData) async {
    (await _updatePassengerRequestUsecase.execute(updatePassengerRequest))
        .fold((failure) => throw failure, (data) {
      usersList.add(passengerData.passengerId); //for notification
      dataToSend!.bookedSeats = dataToSend!.bookedSeats + 1;
      dataToSend!.passengerRequestRide.add(PassengerRequestRideDetails(
          passengerData.name,
          passengerData.passengerId,
          passengerData.imageUrl,
          0,
          passengerData.requireSeats,
          passengerData.costPerSeat,
          passengerData.customPickUpLocation));
      requestsList.removeWhere((data) => data.requestStatus == 'decline');
      requestsList.sort((data1, data2) {
        return data1.requestStatus.compareTo(data2.requestStatus);
      });
    });
    notifyListeners();
  }

  void getUpdatedData(List<PassengerDetailRequestResponseData> requests) {
    requestsList = requests;
    requestsList.removeWhere((data) => data.requestStatus == 'decline');
    requestsList.sort((data1, data2) {
      return data1.requestStatus.compareTo(data2.requestStatus);
    });
    notifyListeners();
  }

  Future<void> cancelRide(
      CancelDriverRideRequest cancelDriverRideRequest) async {
    (await _cancelRideUsecase.execute(cancelDriverRideRequest))
        .fold((failure) => throw failure, (data) async {});
  }

  Future<void> startRide(RideStatusRequest rideStatusRequest) async {
    (await _startRideUsecase.execute(rideStatusRequest))
        .fold((failure) => throw failure, (data) async {
      startRideModel = data;
    });
  }
}
