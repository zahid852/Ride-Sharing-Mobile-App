import 'package:dartz/dartz.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

import '../../../data/network/failure.dart';
import '../../repositry/repositry.dart';
import '../base_usecase/base_usecase.dart';

class SubmittingRatingUsecase
    implements BaseUsecase<RatingSubmitRequest, DefaultMessageModel> {
  Repositry repositry;
  SubmittingRatingUsecase(this.repositry);

  @override
  Future<Either<Failure, DefaultMessageModel>> execute(
      RatingSubmitRequest ratingSubmitRequest) async {
    return await repositry.submittingRating(ratingSubmitRequest);
  }
}
