import 'package:dartz/dartz.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class StartRideUsecase
    implements BaseUsecase<RideStatusRequest, StartRideModel> {
  Repositry repositry;
  StartRideUsecase(this.repositry);

  @override
  Future<Either<Failure, StartRideModel>> execute(
      RideStatusRequest rideStatusRequest) async {
    return await repositry.rideStart(rideStatusRequest);
  }
}
