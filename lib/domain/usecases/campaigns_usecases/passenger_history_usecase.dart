import 'package:dartz/dartz.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class GetPassengerHistoryUsecase
    implements BaseUsecase<PassengerDataRequest, ScheduleRides> {
  Repositry repositry;
  GetPassengerHistoryUsecase(this.repositry);

  @override
  Future<Either<Failure, ScheduleRides>> execute(
      PassengerDataRequest passengerDataRequest) async {
    return await repositry.getPassengerHistory(passengerDataRequest);
  }
}
