import 'package:dartz/dartz.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class GetPassengerAllRequestsUsecase
    implements BaseUsecase<UserDetailsRequest, PassengerAllRequestsData> {
  Repositry repositry;
  GetPassengerAllRequestsUsecase(this.repositry);

  @override
  Future<Either<Failure, PassengerAllRequestsData>> execute(
      UserDetailsRequest userDetailsRequest) async {
    return await repositry.getPassengerAllRequests();
  }
}
