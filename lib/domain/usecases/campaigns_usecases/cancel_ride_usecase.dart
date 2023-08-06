import 'package:dartz/dartz.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../../data/request/request.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class CancelRideUsecase
    implements BaseUsecase<CancelDriverRideRequest, DefaultMessageModel> {
  Repositry repositry;
  CancelRideUsecase(this.repositry);

  @override
  Future<Either<Failure, DefaultMessageModel>> execute(
      CancelDriverRideRequest cancelDriverRideRequest) async {
    return await repositry.cancelDriverRide(cancelDriverRideRequest);
  }
}
