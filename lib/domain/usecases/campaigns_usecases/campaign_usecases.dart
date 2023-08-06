import 'package:dartz/dartz.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class GetCampaignsDataUsecase
    implements BaseUsecase<UserDetailsRequest, CampaignsModal> {
  Repositry repositry;
  GetCampaignsDataUsecase(this.repositry);

  @override
  Future<Either<Failure, CampaignsModal>> execute(
      UserDetailsRequest userDetailsRequest) async {
    return await repositry.getCampaignsData();
  }
}
