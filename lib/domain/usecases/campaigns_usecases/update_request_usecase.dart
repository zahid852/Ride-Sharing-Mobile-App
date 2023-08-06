import 'package:dartz/dartz.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class UpdatePassengerRequestUsecase
    implements BaseUsecase<UpdatePassengerRequest, DefaultMessageModel> {
  Repositry repositry;
  UpdatePassengerRequestUsecase(this.repositry);

  @override
  Future<Either<Failure, DefaultMessageModel>> execute(
      UpdatePassengerRequest updatePassengerRequest) async {
    return await repositry.updatePassengerRequest(updatePassengerRequest);
  }
}
