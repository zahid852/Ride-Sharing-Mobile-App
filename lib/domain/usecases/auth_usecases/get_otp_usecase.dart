import 'package:lift_app/data/network/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/domain/repositry/repositry.dart';
import 'package:lift_app/domain/usecases/base_usecase/base_usecase.dart';

class GetOtpUsecase implements BaseUsecase<String, DefaultMessageModel> {
  Repositry repositry;
  GetOtpUsecase(this.repositry);

  @override
  Future<Either<Failure, DefaultMessageModel>> execute(String input) async {
    return await repositry.getOtp(input);
  }
}
