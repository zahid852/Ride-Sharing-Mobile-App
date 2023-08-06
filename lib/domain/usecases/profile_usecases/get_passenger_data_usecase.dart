import 'package:dartz/dartz.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class GetPassengerDataUsecase
    implements BaseUsecase<UserDetailsRequest, ProfileDataModal> {
  Repositry repositry;
  GetPassengerDataUsecase(this.repositry);

  @override
  Future<Either<Failure, ProfileDataModal>> execute(
      UserDetailsRequest userDetailsRequest) async {
    return await repositry.getPassengerData(userDetailsRequest);
  }
}
