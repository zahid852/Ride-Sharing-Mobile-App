import 'package:dartz/dartz.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class CreateChatUsecase
    implements BaseUsecase<CreateChatRequest, CreateChatModel> {
  Repositry repositry;
  CreateChatUsecase(this.repositry);

  @override
  Future<Either<Failure, CreateChatModel>> execute(
      CreateChatRequest createChatRequest) async {
    return await repositry.createChatRoom(createChatRequest);
  }
}
