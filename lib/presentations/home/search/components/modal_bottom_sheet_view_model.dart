import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/usecases/campaigns_usecases/passenger_request_usecase.dart';

import '../../../../app/di.dart';

class ModalBottomSheetViewModel {
  final PassengerRideShareRequestUsecase _passengerRideShareRequestUsecase =
      instance<PassengerRideShareRequestUsecase>();

  Future<void> passengerRideShareRequest(
      PassengerRideShareRequest passengerRideShareRequest) async {
    (await _passengerRideShareRequestUsecase.execute(passengerRideShareRequest))
        .fold((failure) => throw failure, (data) async {});
  }
}
