import 'package:flutter/material.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/home/search/search_ride_screen.dart';

class SearchViewModel extends ChangeNotifier {
  List<CampaignsDataModal> campaignsList = [];
  void getSortedData(List<CampaignsDataModal> dataList, String locationToSort,
      String sortBy, String vehicleType) {
    campaignsList = dataList.where((location) {
      if (SearchByEnum.From.name == sortBy) {
        if (VehicleEnum.Car.name == vehicleType) {
          return location.vehicleType == vehicleType &&
              location.startingLocation
                  .toLowerCase()
                  .contains(locationToSort.toLowerCase());
        } else if (VehicleEnum.Bike.name == vehicleType) {
          return location.vehicleType == vehicleType &&
              location.startingLocation
                  .toLowerCase()
                  .contains(locationToSort.toLowerCase());
        } else {
          return location.startingLocation
              .toLowerCase()
              .contains(locationToSort.toLowerCase());
        }
      } else {
        if (VehicleEnum.Car.name == vehicleType) {
          return location.vehicleType == vehicleType &&
              location.endingLocation
                  .toLowerCase()
                  .contains(locationToSort.toLowerCase());
        } else if (VehicleEnum.Bike.name == vehicleType) {
          return location.vehicleType == vehicleType &&
              location.endingLocation
                  .toLowerCase()
                  .contains(locationToSort.toLowerCase());
        } else {
          return location.endingLocation
              .toLowerCase()
              .contains(locationToSort.toLowerCase());
        }
      }
    }).toList();

    notifyListeners();
  }
}
