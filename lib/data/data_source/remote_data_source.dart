import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/data/response/response.dart';
import '../network/app_api.dart';

abstract class RemoteDataSource {
  Future<DefaultResponse> getOtp(String phoneNumber);
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest verifyOtpRequest);
  Future<DefaultResponse> registerPassenger(
      RegisterPassengerRequest registerPassengerRequest);
  Future<DefaultResponse> registerDriver(
      RegisterDriverRequest registerDriverRequest);
  Future<ProfileDataResponse> getPassengerData(
      UserDetailsRequest userDetailsRequest);
  Future<DriverPostCampaignResponse> driverPostCompaign(
      SharedRideCompaignRequest sharedRideCompaignRequest);
  Future<CampaignsResponse> getCampaignsData();
  Future<PassengerRideShareRequestResponse> passengerRideShareRequest(
      PassengerRideShareRequest passengerRideShareRequest);
  Future<PassengerRequestsResponse> getPassengerRequests(
      PassengerRequestsGetRequest passengerRequestsGetRequest);
  Future<DefaultResponse> updatePassengerRequests(
      UpdatePassengerRequest passengerRequest);
  Future<DefaultResponse> declinePassengerRequest(
      DeclinePassengerRequest declinePassengerRequest);

  Future<PassengerAllRequestsResponseData> getPassengerAllRequests();
  Future<DriverSpecificScheduleRidesResponse> getDriverScheduleRides(
      DriverScheduleRidesRequest driverScheduleRidesRequest);
  Future<DefaultResponse> pickingPassenger(
      PickingPassengerRequest pickingPassengerRequest);
  Future<StartRideResponse> startRide(RideStatusRequest rideStatusRequest);
  Future<DefaultResponse> endRide(RideStatusRequest rideStatusRequest);
  Future<CreateChatResponse> createChat(CreateChatRequest createChatRequest);
  Future<SendMessageResponse> sendMessage(
      SendMessageRequest sendMessageRequest);

  Future<GetMessageResponse> getMessages(GetMessagesRequest getMessagesRequest);
  Future<DefaultResponse> submittingRating(
      RatingSubmitRequest ratingSubmitRequest);
  Future<PassengerHistoryRidesResponse> getPassengerHistory(
      PassengerDataRequest passengerDataRequest);
  Future<DefaultResponse> cancelRide(
      CancelDriverRideRequest cancelDriverRideRequest);
  Future<DriverDetailsListResponse> getDriverDetails(String driverId);
  Future<DefaultResponse> sendNotification(
      SendNotificationRequest sendNotificationRequest);
  Future<RatingsResponse> getRatings(String driverId);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final AppServiceClient _appServiceClient;

  RemoteDataSourceImpl(this._appServiceClient);
  @override
  Future<DefaultResponse> getOtp(String phoneNumber) async {
    return await _appServiceClient.getOtp(phoneNumber);
  }

  @override
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest verifyOtpRequest) async {
    return await _appServiceClient.verifyOtp(verifyOtpRequest.phoneNumber,
        verifyOtpRequest.otp, verifyOtpRequest.fcmToken);
  }

  @override
  Future<DefaultResponse> registerPassenger(
      RegisterPassengerRequest rur) async {
    return await _appServiceClient.registerPassenger(rur.name, rur.email,
        rur.userId, rur.city, rur.gender, rur.isDriver, rur.profileImg);
  }

  @override
  Future<DefaultResponse> registerDriver(RegisterDriverRequest rdr) async {
    return await _appServiceClient.registerDriver(
        rdr.userId,
        rdr.cnic,
        rdr.fatherName,
        rdr.birthDate,
        rdr.address,
        rdr.cnicFrontImage,
        rdr.cnicBackImage,
        rdr.vehicleType,
        rdr.vehicleBrand,
        rdr.vehicleNumber,
        rdr.vehicleImage,
        rdr.vehicleCertificateImage,
        rdr.licenseNumber,
        rdr.licenseExpiryDate,
        rdr.licenseImage,
        rdr.totalReviewsGiven,
        rdr.tatalRating);
  }

  @override
  Future<ProfileDataResponse> getPassengerData(
      UserDetailsRequest userDetailsRequest) async {
    return await _appServiceClient.getPassengerData(userDetailsRequest.userId);
  }

  @override
  Future<DriverPostCampaignResponse> driverPostCompaign(
      SharedRideCompaignRequest request) async {
    return await _appServiceClient.driverPostCompaign(
        request.driverId,
        request.startingLocation,
        request.endingLocation,
        request.rideDate,
        request.rideTime,
        request.rideRules,
        request.seatCost,
        request.availableSeats,
        request.comment,
        request.expectedRideDistance,
        request.expectedRideTime,
        request.isNowRide);
  }

  @override
  Future<CampaignsResponse> getCampaignsData() async {
    return await _appServiceClient.getCompaignsData();
  }

  @override
  Future<PassengerRideShareRequestResponse> passengerRideShareRequest(
      PassengerRideShareRequest passengerRideShareRequest) async {
    return await _appServiceClient.passengerRideShareRequest(
        passengerRideShareRequest.passengerId,
        passengerRideShareRequest.campaignId,
        passengerRideShareRequest.requireSeats,
        passengerRideShareRequest.seatCost,
        passengerRideShareRequest.customPickUpLocation,
        passengerRideShareRequest.driverId);
  }

  @override
  Future<PassengerRequestsResponse> getPassengerRequests(
      PassengerRequestsGetRequest passengerRequestsGetRequest) async {
    return await _appServiceClient
        .getPassengerRequests(passengerRequestsGetRequest.campaingId);
  }

  @override
  Future<DefaultResponse> updatePassengerRequests(
      UpdatePassengerRequest passengerRequest) async {
    return await _appServiceClient.updatePassengerRequests(passengerRequest);
  }

  @override
  Future<DefaultResponse> declinePassengerRequest(
      DeclinePassengerRequest declinePassengerRequest) async {
    return await _appServiceClient
        .declinePassengerRequest(declinePassengerRequest.requestId);
  }

  @override
  Future<PassengerAllRequestsResponseData> getPassengerAllRequests() async {
    return await _appServiceClient.getPassengerAllRequests();
  }

  @override
  Future<DriverSpecificScheduleRidesResponse> getDriverScheduleRides(
      DriverScheduleRidesRequest driverScheduleRidesRequest) async {
    return await _appServiceClient
        .getDriverScheduleRides(driverScheduleRidesRequest.driverId);
  }

  @override
  Future<DefaultResponse> pickingPassenger(
      PickingPassengerRequest pickingPassengerRequest) async {
    return await _appServiceClient.pickingPassenger(pickingPassengerRequest);
  }

  @override
  Future<DefaultResponse> endRide(RideStatusRequest rideStatusRequest) async {
    return await _appServiceClient.endRide(rideStatusRequest);
  }

  @override
  Future<StartRideResponse> startRide(
      RideStatusRequest rideStatusRequest) async {
    return await _appServiceClient.startRide(rideStatusRequest);
  }

  @override
  Future<CreateChatResponse> createChat(
      CreateChatRequest createChatRequest) async {
    return await _appServiceClient.createChat(createChatRequest);
  }

  @override
  Future<SendMessageResponse> sendMessage(
      SendMessageRequest sendMessageRequest) async {
    return await _appServiceClient.sendMessage(sendMessageRequest);
  }

  @override
  Future<GetMessageResponse> getMessages(
      GetMessagesRequest getMessagesRequest) async {
    return await _appServiceClient.getAllMessages(getMessagesRequest.chatId);
  }

  @override
  Future<DefaultResponse> submittingRating(
      RatingSubmitRequest ratingSubmitRequest) async {
    return await _appServiceClient.submittingRating(ratingSubmitRequest);
  }

  @override
  Future<PassengerHistoryRidesResponse> getPassengerHistory(
      PassengerDataRequest passengerDataRequest) async {
    return await _appServiceClient
        .getPassengerHistory(passengerDataRequest.passengerId);
  }

  @override
  Future<DefaultResponse> cancelRide(
      CancelDriverRideRequest cancelRideRequest) async {
    return await _appServiceClient.cancelRide(cancelRideRequest);
  }

  @override
  Future<DriverDetailsListResponse> getDriverDetails(String driverId) async {
    return await _appServiceClient.getDriverDetails(driverId);
  }

  @override
  Future<DefaultResponse> sendNotification(
      SendNotificationRequest sendNotificationRequest) async {
    return await _appServiceClient.sendNotification(sendNotificationRequest);
  }

  @override
  Future<RatingsResponse> getRatings(String driverId) async {
    return await _appServiceClient.getRatings(driverId);
  }
}
