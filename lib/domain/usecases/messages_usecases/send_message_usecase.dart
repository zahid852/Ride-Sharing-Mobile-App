import 'package:dartz/dartz.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class SendMessageUsecase
    implements BaseUsecase<SendMessageRequest, SendMessageModel> {
  Repositry repositry;
  SendMessageUsecase(this.repositry);

  @override
  Future<Either<Failure, SendMessageModel>> execute(
      SendMessageRequest sendMessageRequest) async {
    return await repositry.sendMessage(sendMessageRequest);
  }
}
