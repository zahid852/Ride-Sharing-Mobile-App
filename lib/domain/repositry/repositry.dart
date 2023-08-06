import 'package:dartz/dartz.dart';
import 'package:lift_app/data/network/failure.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';

abstract class Repositry {
  Future<Either<Failure, DefaultMessageModel>> getOtp(String phone);
  Future<Either<Failure, AuthModel>> verifyOtp(
      VerifyOtpRequest verifyOtpRequest);
  Future<Either<Failure, DefaultMessageModel>> registerPassenger(
      RegisterPassengerRequest registerUserRequest);
  Future<Either<Failure, DefaultMessageModel>> registerDriver(
      RegisterDriverRequest registerDriverRequest);
  Future<Either<Failure, ProfileDataModal>> getPassengerData(
      UserDetailsRequest userDetailsRequest);
  Future<Either<Failure, ScheduleRideDataModal>> driverPostCompaign(
      SharedRideCompaignRequest sharedRideCompaignRequest);
  Future<Either<Failure, CampaignsModal>> getCampaignsData();
  Future<Either<Failure, PassengerRequestResponseData>>
      passengerRideShareRequestToDriver(
          PassengerRideShareRequest passengerRideShareRequest);
  Future<Either<Failure, PassengerRequests>> getPassengerRequests(
      PassengerRequestsGetRequest passengerRequestsGetRequest);
  Future<Either<Failure, DefaultMessageModel>> updatePassengerRequest(
      UpdatePassengerRequest updatePassengerRequest);
  Future<Either<Failure, DefaultMessageModel>> declinePassengerRequest(
      DeclinePassengerRequest declinePassengerRequest);
  Future<Either<Failure, PassengerAllRequestsData>> getPassengerAllRequests();
  Future<Either<Failure, ScheduleRides>> getDriverScheduleRides(
      DriverScheduleRidesRequest driverScheduleRidesRequest);
  Future<Either<Failure, DefaultMessageModel>> pickingPassenger(
      PickingPassengerRequest pickingPassengerRequest);
  Future<Either<Failure, StartRideModel>> rideStart(
      RideStatusRequest rideStatusRequest);
  Future<Either<Failure, DefaultMessageModel>> rideEnd(
      RideStatusRequest rideStatusRequest);

  Future<Either<Failure, CreateChatModel>> createChatRoom(
      CreateChatRequest createChatRequest);
  Future<Either<Failure, SendMessageModel>> sendMessage(
      SendMessageRequest sendMessageRequest);
  Future<Either<Failure, GetMessagesModel>> getAllMessages(
      GetMessagesRequest getMessagesRequest);
  Future<Either<Failure, DefaultMessageModel>> submittingRating(
      RatingSubmitRequest ratingSubmitRequest);
  Future<Either<Failure, ScheduleRides>> getPassengerHistory(
      PassengerDataRequest passengerDataRequest);
  Future<Either<Failure, DefaultMessageModel>> cancelDriverRide(
      CancelDriverRideRequest cancelDriverRideRequest);
  Future<Either<Failure, DriverDetailsList>> getDriverDetails(String driverId);
  Future<Either<Failure, DefaultMessageModel>> sendNotification(
      SendNotificationRequest sendNotificationRequest);

  Future<Either<Failure, RatingsModel>> getRatings(String driverId);
}
