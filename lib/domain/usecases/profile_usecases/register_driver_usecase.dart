import 'package:dartz/dartz.dart';
import 'package:lift_app/data/network/failure.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/domain/repositry/repositry.dart';
import 'package:lift_app/domain/usecases/base_usecase/base_usecase.dart';

import '../../../data/request/request.dart';

class RegisterDriverUsecase
    implements BaseUsecase<RegisterDriverRequest, DefaultMessageModel> {
  Repositry repositry;
  RegisterDriverUsecase(this.repositry);

  @override
  Future<Either<Failure, DefaultMessageModel>> execute(
      RegisterDriverRequest registerDriverRequest) async {
    return await repositry.registerDriver(registerDriverRequest);
  }
}
