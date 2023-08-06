import 'package:dartz/dartz.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';
import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class VerifyOtpUsecase implements BaseUsecase<VerifyOtpRequest, AuthModel> {
  Repositry repositry;
  VerifyOtpUsecase(this.repositry);

  @override
  Future<Either<Failure, AuthModel>> execute(
      VerifyOtpRequest verifyOtpRequest) async {
    return await repositry.verifyOtp(verifyOtpRequest);
  }
}
