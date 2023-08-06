import 'package:flutter/material.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/domain/usecases/campaigns_usecases/get_passenger_all_request_usecase.dart';

import '../../../app/di.dart';

class PassengerAllRequestsViewModel extends ChangeNotifier {
  final GetPassengerAllRequestsUsecase _getPassengerAllRequestsUsecase =
      instance<GetPassengerAllRequestsUsecase>();
  List<PassengerAllRequests> requestsList = [];
  bool isGotData = false;

  Future<void> getAllRequestsData(UserDetailsRequest userDetailsRequest) async {
    (await _getPassengerAllRequestsUsecase.execute(userDetailsRequest))
        .fold((failure) => throw failure, (data) async {
      requestsList = data.passengerAllRequests.reversed.toList();

      isGotData = true;
      notifyListeners();
    });
  }
}
