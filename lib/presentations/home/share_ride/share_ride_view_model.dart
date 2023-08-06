import 'dart:async';
import 'package:lift_app/app/services.dart';
import 'package:lift_app/data/mapper/mappers.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../app/di.dart';
import '../../../domain/usecases/driver_usecases/driver_post_compaign_usecase.dart';

class SharedRideViewModel {
  final DriverPostCompaignUsecase _driverPostCompaignUsecase =
      instance<DriverPostCompaignUsecase>();
  final StreamController _isAllInputsValidStreamController =
      StreamController<void>.broadcast();
  bool areLocationsSelected = false;
  String availableSeats = EMPTY;
  String costSeat = EMPTY;
  bool isScheduleRide = false;
  String scheduledDay = EMPTY;
  String scheduledTime = EMPTY;
  ScheduleRideDataModal? scheduleRideDataModal;

  static bool isCar = false;
  void _validate() {
    inputIsAllInputValid.add(null);
  }

  void setLocations(bool locations) {
    areLocationsSelected = locations;
    _validate();
  }

  void setSchedule(int index) {
    if (index == 1) {
      isScheduleRide = true;
    } else if (index == 0) {
      isScheduleRide = false;
    }

    _validate();
  }

  void setSeatCost(String cost) {
    costSeat = cost;
    _validate();
  }

  void setAvailableSeats(String seats) {
    availableSeats = seats;
    _validate();
  }

  void setScheduledDay(String day) {
    scheduledDay = day;

    _validate();
  }

  void setScheduledTime(String time) {
    scheduledTime = time;

    _validate();
  }

  bool isSeatCountValid(String seats) {
    if (seats.isEmpty) {
      return seats.isNotEmpty;
    } else {
      int seatCount = int.parse(seats);
      if (isCar) {
        if (seatCount == 1 || seatCount == 2 || seatCount == 3) {
          return true;
        } else {
          return false;
        }
      } else {
        if (seatCount == 1) {
          return true;
        } else {
          return false;
        }
      }
    }
  }

  bool _isAllInputsValid() {
    if ((isScheduleRide
            ? (isStringValid(scheduledDay) && isStringValid(scheduledTime))
            : true) &&
        isSeatCountValid(availableSeats) &&
        isStringValid(costSeat) &&
        areLocationsSelected) {
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

  Future<void> postCompaign(
      SharedRideCompaignRequest sharedRideCompaignRequest) async {
    (await _driverPostCompaignUsecase.execute(sharedRideCompaignRequest)).fold(
        (failure) => throw failure, (data) => {scheduleRideDataModal = data});
  }
}
