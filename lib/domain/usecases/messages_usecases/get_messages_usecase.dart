import 'package:dartz/dartz.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class GetMessagesUsecase
    implements BaseUsecase<GetMessagesRequest, GetMessagesModel> {
  Repositry repositry;
  GetMessagesUsecase(this.repositry);

  @override
  Future<Either<Failure, GetMessagesModel>> execute(
      GetMessagesRequest getMessagesRequest) async {
    return await repositry.getAllMessages(getMessagesRequest);
  }
}
