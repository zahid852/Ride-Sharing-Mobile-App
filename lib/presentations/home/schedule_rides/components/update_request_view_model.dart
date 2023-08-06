import 'package:lift_app/app/di.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../../domain/usecases/campaigns_usecases/update_request_usecase.dart';

class UpdatePassengerRequestViewModel {
  final UpdatePassengerRequestUsecase _updatePassengerRequestUsecase =
      instance<UpdatePassengerRequestUsecase>();
  static List<String> userList = [];
  Future<void> updateRequestData(UpdatePassengerRequest updatePassengerRequest,
      PassengerDetailRequestResponseData passengerData) async {
    (await _updatePassengerRequestUsecase.execute(updatePassengerRequest))
        .fold((failure) => throw failure, (data) {
      userList.add(passengerData.passengerId); //for notification
    });
  }
}
