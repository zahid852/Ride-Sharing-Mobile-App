import 'package:flutter/material.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/domain/usecases/campaigns_usecases/rating_usecase.dart';

import '../../../../app/di.dart';

class ReviewViewModel extends ChangeNotifier {
  final GetRatingsUsecase _getRatingsUsecase = instance<GetRatingsUsecase>();
  List<RatingDataModel> ratingsList = [];
  bool isGotData = false;

  Future<void> getRatings(String driverId) async {
    (await _getRatingsUsecase.execute(driverId))
        .fold((failure) => throw failure, (data) async {
      ratingsList = data.ratingsData.reversed.toList();

      isGotData = true;
      notifyListeners();
    });
  }
}
