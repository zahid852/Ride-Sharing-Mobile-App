import 'package:dartz/dartz.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class EndRideUsecase
    implements BaseUsecase<RideStatusRequest, DefaultMessageModel> {
  Repositry repositry;
  EndRideUsecase(this.repositry);

  @override
  Future<Either<Failure, DefaultMessageModel>> execute(
      RideStatusRequest rideStatusRequest) async {
    return await repositry.rideEnd(rideStatusRequest);
  }
}
