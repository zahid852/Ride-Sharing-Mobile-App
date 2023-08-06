import 'package:dartz/dartz.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class SendNotificationUsecase
    implements BaseUsecase<SendNotificationRequest, DefaultMessageModel> {
  Repositry repositry;
  SendNotificationUsecase(this.repositry);

  @override
  Future<Either<Failure, DefaultMessageModel>> execute(
      SendNotificationRequest sendNotificationRequest) async {
    return await repositry.sendNotification(sendNotificationRequest);
  }
}
