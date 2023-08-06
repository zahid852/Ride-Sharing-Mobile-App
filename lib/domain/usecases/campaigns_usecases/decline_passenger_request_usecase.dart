import 'package:dartz/dartz.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class DeclinePassengerRequestUsecase
    implements BaseUsecase<DeclinePassengerRequest, DefaultMessageModel> {
  Repositry repositry;
  DeclinePassengerRequestUsecase(this.repositry);

  @override
  Future<Either<Failure, DefaultMessageModel>> execute(
      DeclinePassengerRequest declinePassengerRequest) async {
    return await repositry.declinePassengerRequest(declinePassengerRequest);
  }
}
