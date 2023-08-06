import 'package:dartz/dartz.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class GetDriverScheduleRidesDataUsecase
    implements BaseUsecase<DriverScheduleRidesRequest, ScheduleRides> {
  Repositry repositry;
  GetDriverScheduleRidesDataUsecase(this.repositry);

  @override
  Future<Either<Failure, ScheduleRides>> execute(
      DriverScheduleRidesRequest driverScheduleRidesRequest) async {
    return await repositry.getDriverScheduleRides(driverScheduleRidesRequest);
  }
}
