import 'package:dartz/dartz.dart';
import 'package:lift_app/data/network/failure.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/domain/repositry/repositry.dart';
import 'package:lift_app/domain/usecases/base_usecase/base_usecase.dart';

import '../../../data/request/request.dart';

class DriverPostCompaignUsecase
    implements BaseUsecase<SharedRideCompaignRequest, ScheduleRideDataModal> {
  Repositry repositry;
  DriverPostCompaignUsecase(this.repositry);

  @override
  Future<Either<Failure, ScheduleRideDataModal>> execute(
      SharedRideCompaignRequest sharedRideCompaignRequest) async {
    return await repositry.driverPostCompaign(sharedRideCompaignRequest);
  }
}
