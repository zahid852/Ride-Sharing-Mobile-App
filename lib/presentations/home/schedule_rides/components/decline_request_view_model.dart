import 'package:lift_app/app/di.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/usecases/campaigns_usecases/decline_passenger_request_usecase.dart';

class DeclinePassengerRequestViewModel {
  final DeclinePassengerRequestUsecase _declinePassengerRequestUsecase =
      instance<DeclinePassengerRequestUsecase>();

  Future<void> declineRequestData(
      DeclinePassengerRequest declinePassengerRequest) async {
    (await _declinePassengerRequestUsecase.execute(declinePassengerRequest))
        .fold((failure) => throw failure, (data) {});
  }
}
