import 'package:dartz/dartz.dart';
import 'package:lift_app/data/network/failure.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/domain/repositry/repositry.dart';
import 'package:lift_app/domain/usecases/base_usecase/base_usecase.dart';

class GetDriverDetailsUsecase
    implements BaseUsecase<String, DriverDetailsList> {
  Repositry repositry;
  GetDriverDetailsUsecase(this.repositry);

  @override
  Future<Either<Failure, DriverDetailsList>> execute(String driverId) async {
    return await repositry.getDriverDetails(driverId);
  }
}
