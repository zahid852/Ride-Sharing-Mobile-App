import 'package:flutter/material.dart';
import 'package:lift_app/app/di.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/domain/usecases/campaigns_usecases/get_passenger_requests_usecase.dart';

class PassengerRequestsViewModel extends ChangeNotifier {
  final GetPassengerRequestsUsecase _getPassengerRequestsUsecase =
      instance<GetPassengerRequestsUsecase>();
  List<PassengerDetailRequestResponseData> requestsList = [];
  bool isGotData = false;
  DateTime currentDateTime = DateTime.now();
  Future<void> getRequestsData(
      PassengerRequestsGetRequest passengerRequestsGetRequest) async {
    (await _getPassengerRequestsUsecase.execute(passengerRequestsGetRequest))
        .fold((failure) => throw failure, (data) async {
      // currentDateTime = await NTP.now();
      // campaignsList = data.campaignsData.where((campaignDataModal) {
      //   DateTime date = DateTime.parse(campaignDataModal.date);
      //   DateTime time = DateTime.parse(campaignDataModal.time);
      //   DateTime combineDateTime = DateTime(date.year, date.month, date.day,
      //       time.hour, time.minute, time.second);
      //   if (combineDateTime.isAfter(currentDateTime) &&
      //       CommonData.passengerDataModal.id == campaignDataModal.driverId) {
      //     return true;
      //   } else {
      //     return false;
      //   }
      // }).toList();
      requestsList = data.passengerRequestsData.reversed.toList();

      isGotData = true;
      notifyListeners();
    });
  }

  void getUpdatedData(List<PassengerDetailRequestResponseData> requests) {
    requestsList = requests;
    notifyListeners();
  }
}
