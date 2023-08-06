import 'package:dartz/dartz.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class PickingPassengerRequestUsecase
    implements BaseUsecase<PickingPassengerRequest, DefaultMessageModel> {
  Repositry repositry;
  PickingPassengerRequestUsecase(this.repositry);

  @override
  Future<Either<Failure, DefaultMessageModel>> execute(
      PickingPassengerRequest pickingPassengerRequest) async {
    return await repositry.pickingPassenger(pickingPassengerRequest);
  }
}
