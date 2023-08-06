import 'package:dartz/dartz.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class PassengerRideShareRequestUsecase
    implements
        BaseUsecase<PassengerRideShareRequest, PassengerRequestResponseData> {
  Repositry repositry;
  PassengerRideShareRequestUsecase(this.repositry);

  @override
  Future<Either<Failure, PassengerRequestResponseData>> execute(
      PassengerRideShareRequest passengerRequest) async {
    return await repositry.passengerRideShareRequestToDriver(passengerRequest);
  }
}
