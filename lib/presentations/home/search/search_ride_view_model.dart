import 'package:flutter/material.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/domain/usecases/campaigns_usecases/campaign_usecases.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';
import 'package:ntp/ntp.dart';

import '../../../app/di.dart';

class SearchRidesViewModel extends ChangeNotifier {
  final GetCampaignsDataUsecase _getCampaignsDataUsecase =
      instance<GetCampaignsDataUsecase>();
  List<CampaignsDataModal> campaignsList = [];
  bool isGotData = false;
  DateTime currentDateTime = DateTime.now();
  Future<void> getCampaignsData() async {
    (await _getCampaignsDataUsecase
            .execute(UserDetailsRequest(CommonData.passengerDataModal.id)))
        .fold((failure) => throw failure, (data) async {
      isGotData = false;
      campaignsList = [];
      currentDateTime = await NTP.now();
      campaignsList = data.campaignsData
          .where((campaignDataModal) {
            DateTime date = DateTime.parse(campaignDataModal.date);
            DateTime time = DateTime.parse(campaignDataModal.time);
            DateTime combineDateTime = DateTime(date.year, date.month, date.day,
                time.hour, time.minute, time.second);
            if (combineDateTime.isAfter(currentDateTime) &&
                campaignDataModal.bookedSeats <
                    campaignDataModal.availableSeats &&
                campaignDataModal.driverId !=
                    CommonData.passengerDataModal.id &&
                campaignDataModal.status == 0) {
              return true;
            } else {
              return false;
            }
          })
          .toList()
          .reversed
          .toList();

      isGotData = true;
      notifyListeners();
    });
  }
}
