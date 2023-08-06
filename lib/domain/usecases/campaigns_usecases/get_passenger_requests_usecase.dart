import 'package:dartz/dartz.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class GetPassengerRequestsUsecase
    implements BaseUsecase<PassengerRequestsGetRequest, PassengerRequests> {
  Repositry repositry;
  GetPassengerRequestsUsecase(this.repositry);

  @override
  Future<Either<Failure, PassengerRequests>> execute(
      PassengerRequestsGetRequest passengerRequestsGetRequest) async {
    return await repositry.getPassengerRequests(passengerRequestsGetRequest);
  }
}
