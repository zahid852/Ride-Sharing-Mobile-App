import 'package:dartz/dartz.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class RegisterPassengerUsecase
    implements BaseUsecase<RegisterPassengerRequest, DefaultMessageModel> {
  Repositry repositry;
  RegisterPassengerUsecase(this.repositry);

  @override
  Future<Either<Failure, DefaultMessageModel>> execute(
      RegisterPassengerRequest registerUserRequest) async {
    return await repositry.registerPassenger(registerUserRequest);
  }
}
