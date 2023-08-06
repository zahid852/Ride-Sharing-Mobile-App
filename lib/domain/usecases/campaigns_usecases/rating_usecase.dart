import 'package:dartz/dartz.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class GetRatingsUsecase implements BaseUsecase<String, RatingsModel> {
  Repositry repositry;
  GetRatingsUsecase(this.repositry);

  @override
  Future<Either<Failure, RatingsModel>> execute(String driverId) async {
    return await repositry.getRatings(driverId);
  }
}
