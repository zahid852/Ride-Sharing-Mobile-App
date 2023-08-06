import 'package:flutter/material.dart';
import 'package:lift_app/app/di.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/auth/get_otp/get_otp_screen.dart';
import 'package:lift_app/presentations/auth/verify_otp/verify_otp_screen.dart';
import 'package:lift_app/presentations/driver/driver_child_screens/base_info/basic_info_screen.dart';
import 'package:lift_app/presentations/driver/driver_child_screens/cnic_images/cnic_images_screen.dart';
import 'package:lift_app/presentations/driver/driver_child_screens/license_info/license_info_screen.dart';
import 'package:lift_app/presentations/driver/driver_child_screens/vehicle_images/vehicle_images_screen.dart';
import 'package:lift_app/presentations/driver/driver_child_screens/vehicle_info/vehicle_info_screen.dart';
import 'package:lift_app/presentations/driver/driver_parent_screen.dart';
import 'package:lift_app/presentations/home/Loading/error_screen.dart';
import 'package:lift_app/presentations/home/Loading/loading_screen.dart';
import 'package:lift_app/presentations/home/Loading/success_screen.dart';
import 'package:lift_app/presentations/home/drawer/components/loading_data_screen.dart';
import 'package:lift_app/presentations/home/now_ride/cancel_ride_screen.dart';
import 'package:lift_app/presentations/home/now_ride/now_ride_view_model.dart';
import 'package:lift_app/presentations/home/messages/message_screen.dart';
import 'package:lift_app/presentations/home/now_ride/schedule_later_screen.dart';
import 'package:lift_app/presentations/home/ride/passenger_details_screen.dart';
import 'package:lift_app/presentations/home/passenger_requests/components/rating_bar.dart';
import 'package:lift_app/presentations/home/ride/ride_screen.dart';
import 'package:lift_app/presentations/home/schedule_rides/components/full_page_custum_location.dart';
import 'package:lift_app/presentations/home/search/components/custom_pick_up_location.dart';
import 'package:lift_app/presentations/home/settings/components/profile_screen.dart';
import 'package:lift_app/presentations/home/settings/components/review_screen.dart';
import 'package:lift_app/presentations/home/share_ride/sub_screens/choose_locations_screens.dart';
import 'package:lift_app/presentations/home/share_ride/sub_screens/location_selection_screen.dart';
import 'package:lift_app/presentations/home/drawer/drawer_screen.dart';
import 'package:lift_app/presentations/home/image/full_image_screen.dart';
import 'package:lift_app/presentations/home/schedule_rides/components/driver_campaign_request_screen.dart';
import 'package:lift_app/presentations/home/search/components/ride_detail_screen.dart';
import 'package:lift_app/presentations/home/now_ride/now_ride_screen.dart';
import 'package:lift_app/presentations/passenger/profile_screen.dart';
import 'package:lift_app/presentations/splash/splash_screen.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:page_transition/page_transition.dart';
import '../home/call/call_screen.dart';
import '../home/passenger_requests/components/track_ride_screen.dart';

class Routes {
  static const String nowRideRoute = '/nowRideRoute';
  static const String splashRoute = '/';
  static const String getOtpRoute = '/getOtpRoute';
  static const String verifyOtpRoute = '/verifyOtpRoute';
  static const String passengerProfileRoute = '/passengerProfileRoute';
  static const String driverProfileRoute = '/driverProfileRoute';
  static const String basicInfoRoute = '/basicInfoRoute';
  static const String cnicImagesRoute = '/cnicImagesRoute';
  static const String vehicleInfoRoute = '/vehicleInfoRoute';
  static const String vehicleImagesRoute = '/vehicleImagesRoute';
  static const String licenseInfoRoute = '/licenseInfoRoute';
  static const String homeRoute = 'homeRoute';
  static const String locationSelectionRoute = '/locationSelectionRoute';
  static const String chooseLocationOnMap = '/chooseLocationOnMapRoute';
  static const String rideDetails = '/sharedRideDetails';
  static const String imageRoute = '/imageRoute';
  static const String loadingRoute = '/loading';
  static const String errorRoute = '/error';
  static const String successRoute = '/success';
  static const String campaignRequestRoute = '/campaignRequests';
  static const String rideRoute = '/rideRoute';
  static const String customRoute = '/customRoute';
  static const String fullPageLocationRoute = '/fullPageLocationRoute';
  static const String passengerDetailsPopUpScreenRoute =
      '/passengerDetailsPopUpScreenRoute';
  static const String messageScreenRoute = '/messageScreenRoute';
  static const String ratingBarRoute = '/ratingBarRoute';

  static const String trackRideRoute = '/trackRideRoute';
  static const String audioCallingRoute = '/audioCallingRoute';
  static const String reviewsRoute = '/reviewsRoute';
  static const String profileRoute = '/profileRoute';
  static const String cancelRideRoute = '/cancelRideRoute';
  static const String scheduleLaterRideRoute = '/scheduleLaterRideRoute';
  static const String fetchingDataRoute = '/fetchingDataRoute';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.fetchingDataRoute:
        initHomeModule();
        return PageTransition(
            child: const FetchingDataScreen(),
            type: PageTransitionType.rightToLeft);
      case Routes.nowRideRoute:
        final ScheduleRideDataModal data =
            routeSettings.arguments as ScheduleRideDataModal;
        return PageTransition(
            child: NowRideScreen(data: data),
            type: PageTransitionType.rightToLeft);
      case Routes.splashRoute:
        return PageTransition(
            child: const SplashScreen(), type: PageTransitionType.rightToLeft);
      case Routes.getOtpRoute:
        initGetOtpModule();
        return PageTransition(
            child: const GetOtpScreen(), type: PageTransitionType.rightToLeft);
      case Routes.verifyOtpRoute:
        initVerifyOtpModule();
        final phoneNumber = routeSettings.arguments as String;

        return PageTransition(
            child: VerifyOtpScreen(
              phoneNumber: phoneNumber,
            ),
            type: PageTransitionType.rightToLeft);
      case Routes.passengerProfileRoute:
        initRegisterPassengerModule();
        return PageTransition(
            child: const PassengerProfileScreen(),
            type: PageTransitionType.rightToLeft);
      case Routes.driverProfileRoute:
        initRegisterDriverModule();
        return PageTransition(
            child: const DriverProfileScreen(),
            type: PageTransitionType.rightToLeft);
      case Routes.basicInfoRoute:
        return PageTransition(
            child: const BasicInfoScreen(),
            type: PageTransitionType.rightToLeft);
      case Routes.cnicImagesRoute:
        return PageTransition(
            child: const CnicImagesScreen(),
            type: PageTransitionType.rightToLeft);
      case Routes.vehicleInfoRoute:
        return PageTransition(
            child: const VehicleInfoScreen(),
            type: PageTransitionType.rightToLeft);
      case Routes.vehicleImagesRoute:
        return PageTransition(
            child: const VehicleImagesScreen(),
            type: PageTransitionType.rightToLeft);
      case Routes.licenseInfoRoute:
        return PageTransition(
            child: const LicenseInfoScreen(),
            type: PageTransitionType.rightToLeft);
      case Routes.homeRoute:
        if (routeSettings.arguments != null) {
          final List<dynamic> data = routeSettings.arguments as List<dynamic>;
          final bool? notificationCheck = data[0];
          final int? index = data[1];
          return PageTransition(
              child: DrawerScreen(
                passengerRequestsCheck: notificationCheck,
                index: index,
              ),
              type: PageTransitionType.rightToLeft);
        } else {
          return PageTransition(
              child: DrawerScreen(), type: PageTransitionType.rightToLeft);
        }
      case Routes.locationSelectionRoute:
        return PageTransition(
            child: const LocationSelectionScreen(),
            type: PageTransitionType.bottomToTop);
      case Routes.chooseLocationOnMap:
        final List<dynamic> data = routeSettings.arguments as List<dynamic>;
        final LocationType location = data[0];
        final double currentLatitude = data[1];
        final double currentLongitude = data[2];
        return PageTransition(
            child: ChooseLocationOnMapScreen(
                whichLocation: location,
                currentLatitude: currentLatitude,
                currentLongitude: currentLongitude),
            type: PageTransitionType.bottomToTop);
      case Routes.rideDetails:
        final List<dynamic> data = routeSettings.arguments as List<dynamic>;
        final CampaignsDataModal campaignModal = data[0];
        final DateTime dateNow = data[1];
        return PageTransition(
            child: SharedRideDetailScreen(
                campaignsDataModal: campaignModal, currentDate: dateNow),
            type: PageTransitionType.rightToLeft);
      case Routes.imageRoute:
        final String imagePath = routeSettings.arguments as String;

        return PageTransition(
            child: FullImageScreen(imagePath: imagePath),
            type: PageTransitionType.rightToLeft);
      case Routes.loadingRoute:
        final String message = routeSettings.arguments as String;
        return PageTransition(
            child: LoadingScreen(message: message),
            type: PageTransitionType.fade);
      case Routes.errorRoute:
        final String error = routeSettings.arguments as String;

        return PageTransition(
            child: ErrorScreen(error: error), type: PageTransitionType.fade);
      case Routes.successRoute:
        final String successMessage = routeSettings.arguments as String;

        return PageTransition(
            child: SuccessScreen(message: successMessage),
            type: PageTransitionType.fade);
      case Routes.campaignRequestRoute:
        final String campaignId = routeSettings.arguments as String;

        return PageTransition(
            child: DriverCampaignRequestScreen(campaignId: campaignId),
            type: PageTransitionType.rightToLeft);
      case Routes.rideRoute:
        final ScheduleRideDataModal scheduleRideDataModal =
            routeSettings.arguments as ScheduleRideDataModal;

        return PageTransition(
            child: RideScreen(scheduleRideDataModal: scheduleRideDataModal),
            type: PageTransitionType.rightToLeft);
      case Routes.customRoute:
        return PageTransition(
            child: const CustomPickLocation(),
            type: PageTransitionType.rightToLeft);
      case Routes.fullPageLocationRoute:
        final String address = routeSettings.arguments as String;
        return PageTransition(
            child: FullPageLocation(address: address),
            type: PageTransitionType.rightToLeft);
      case Routes.passengerDetailsPopUpScreenRoute:
        final List<dynamic> data = routeSettings.arguments as List<dynamic>;
        final PassengerRequestRideDetails passengerRequestRideDetails = data[1];
        final String campaignId = data[0];

        return PageTransition(
            child: PassengerDetailsPopUpScreen(
                campaignId: campaignId,
                passengerRequestRideDetails: passengerRequestRideDetails),
            type: PageTransitionType.rightToLeft);
      case Routes.messageScreenRoute:
        final List<dynamic> data = routeSettings.arguments as List<dynamic>;
        final String name = data[0];
        final String image = data[1];
        final ChatObjectModel chatObjectModel = data[2] as ChatObjectModel;
        return PageTransition(
            child: MessageScreen(
                opponentName: name,
                opponentImage: image,
                chatObjectModel: chatObjectModel),
            type: PageTransitionType.rightToLeft);
      case Routes.ratingBarRoute:
        final List<dynamic> data = routeSettings.arguments as List<dynamic>;
        final String driverId = data[0];
        final String campaignId = data[1];
        return PageTransition(
            child:
                PassengerRatingBar(driverId: driverId, campaignId: campaignId),
            type: PageTransitionType.rightToLeft);

      case Routes.trackRideRoute:
        final PassengerAllRequests data =
            routeSettings.arguments as PassengerAllRequests;

        return PageTransition(
            child: TrackRideScreen(request: data),
            type: PageTransitionType.rightToLeft);
      case Routes.audioCallingRoute:
        final String callingId = routeSettings.arguments as String;

        return PageTransition(
            child: AudioCallingScreen(callingId: callingId),
            type: PageTransitionType.rightToLeft);
      case Routes.reviewsRoute:
        return PageTransition(
            child: const ReviewsScreen(), type: PageTransitionType.rightToLeft);
      case Routes.profileRoute:
        return PageTransition(
            child: const ProfileScreen(), type: PageTransitionType.rightToLeft);
      case Routes.cancelRideRoute:
        final List<dynamic> data = routeSettings.arguments as List<dynamic>;
        final String campaignId = data[0];
        final NowRideViewModel nowRideViewModel = data[1];
        return PageTransition(
            child: CancelNowRideScreen(
                campaignId: campaignId, nowRideViewModel: nowRideViewModel),
            type: PageTransitionType.rightToLeft);
      case Routes.scheduleLaterRideRoute:
        final List<dynamic> data = routeSettings.arguments as List<dynamic>;
        final ScheduleRideDataModal dataModal = data[0];
        final NowRideViewModel nowRideViewModel = data[1];
        return PageTransition(
            child: ScheduleLaterRideScreen(
                scheduleRideDataModel: dataModal,
                nowRideViewModel: nowRideViewModel),
            type: PageTransitionType.rightToLeft);

      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return PageTransition(
        child: const Scaffold(
          body: SafeArea(child: Text('No route found')),
        ),
        type: PageTransitionType.rightToLeft);
  }
}
