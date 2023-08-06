import '../../../../app/di.dart';
import '../../../../data/request/request.dart';
import '../../../../domain/usecases/campaigns_usecases/submitting_rating_usecase.dart';

class RatingViewModel {
  final SubmittingRatingUsecase _submittingRatingUsecase =
      instance<SubmittingRatingUsecase>();

  Future<void> submitRating(RatingSubmitRequest ratingSubmitRequest) async {
    (await _submittingRatingUsecase.execute(ratingSubmitRequest))
        .fold((failure) => throw failure, (data) async {});
  }
}
