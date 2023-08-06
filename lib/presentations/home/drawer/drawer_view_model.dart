import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lift_app/app/di.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/domain/usecases/profile_usecases/get_passenger_data_usecase.dart';
import 'package:lift_app/presentations/home/share_ride/share_ride_view_model.dart';
import 'package:lift_app/presentations/utils/socket.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../../app/constants.dart';

class CommonData {
  static late PassengerDataModal passengerDataModal;
  static bool isUserPassengerCurrently = false;
  static ScheduleRideDataModal?
      scheduleRideDataModal; // for rescheduling the ride
  static bool isDataFetched = false;
}

class DrawerViewModel extends ChangeNotifier {
  final GetPassengerDataUsecase _getPassengerDataUsecase =
      instance<GetPassengerDataUsecase>();

  Future<void> getPassengerData(
      UserDetailsRequest userDetailsRequest, BuildContext context) async {
    (await _getPassengerDataUsecase.execute(userDetailsRequest))
        .fold((failure) => throw failure, (data) {
      CommonData.passengerDataModal = data.passengerDataList.first;
      SocketImplementation.setUpData();

      // SocketImplementation.socket.on('ride ended', (data) {
      //   Navigator.of(context).pushNamed(Routes.ratingBarRoute, arguments: data);
      // });
      ZegoUIKitPrebuiltCallInvitationService().init(
        appID: Constants.zegoCloudAppId,
        appSign: Constants.zegoCloudAppSignInId,
        userID: CommonData.passengerDataModal.id,
        notifyWhenAppRunningInBackgroundOrQuit: true,
        userName: CommonData.passengerDataModal.name,
        plugins: [ZegoUIKitSignalingPlugin()],
      );

      CommonData.isDataFetched = true;
      SharedRideViewModel.isCar =
          CommonData.passengerDataModal.vehicleType == 'Car' ? true : false;
      CommonData.isUserPassengerCurrently =
          CommonData.passengerDataModal.isDriver ? false : true;
      notifyListeners();
    });
  }
}
