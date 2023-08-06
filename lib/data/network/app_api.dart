import 'dart:io';
import 'package:dio/dio.dart';
import 'package:lift_app/app/constants.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/data/response/response.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:retrofit/http.dart';
part 'app_api.g.dart';

@RestApi(baseUrl: Constants.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST('/otp')
  Future<DefaultResponse> getOtp(@Field("phone") String phoneNumber);

  @POST('/otp/verify')
  Future<VerifyOtpResponse> verifyOtp(
    @Field("phone") String phoneNumber,
    @Field("otp") String otp,
    @Field("fcmToken") String fcmToken,
  );

  @POST('/register')
  @MultiPart()
  Future<DefaultResponse> registerPassenger(
      @Part() String name,
      @Part() String email,
      @Part() String userId,
      @Part() String city,
      @Part() String gender,
      @Part() bool isDriver,
      @Part() File profileImg);

  @POST('/driver/register')
  @MultiPart()
  Future<DefaultResponse> registerDriver(
    @Part() String userId,
    @Part() String cnic,
    @Part() String fatherName,
    @Part() String birthDate,
    @Part() String residentialAddress,
    @Part() File cnicfront,
    @Part() File cnicback,
    @Part() String vehicleType,
    @Part() String vehicleBrand,
    @Part() String vehicleNumber,
    @Part() File vehicles,
    @Part() File vehicleCertificate,
    @Part() String liscenseNumber,
    @Part() String liscenseExpiryDate,
    @Part() File liscenseimage,
    @Part() int totalReviewsGiven,
    @Part() int totalRating,
  );

  @GET('/user/{id}')
  Future<ProfileDataResponse> getPassengerData(
    @Path("id") String id,
  );
  @POST('/driver/campaign')
  Future<DriverPostCampaignResponse> driverPostCompaign(
    @Field("driverId") String driverId,
    @Field("startLocation") String startLocation,
    @Field("endingLocation") String endingLocation,
    @Field("date") String date,
    @Field("time") String time,
    @Field("rideRules") RideRules rideRules,
    @Field("seatCost") double seatCost,
    @Field("availableSeats") int availableSeats,
    @Field("comment") String comment,
    @Field("expectedRideDistance") String expectedDistance,
    @Field("expectedRideTime") String expectedTime,
    @Field("isNowRide") bool isNowRide,
  );
  @GET('/campaigns')
  Future<CampaignsResponse> getCompaignsData();

  @GET('/driver/campaign/{driverId}')
  Future<DriverSpecificScheduleRidesResponse> getDriverScheduleRides(
    @Path("driverId") String driverId,
  );

  @POST('/passenger/request')
  Future<PassengerRideShareRequestResponse> passengerRideShareRequest(
    @Field("passengerId") String passengerId,
    @Field("campaignId") String campaignId,
    @Field("requireSeats") int requireSeats,
    @Field("costPerSeat") int seatCost,
    @Field("pickupLocation") String customPickUpLocation,
    @Field("driverId") String driverId,
  );

  @GET('/passenger/request/{campaignId}')
  Future<PassengerRequestsResponse> getPassengerRequests(
    @Path("campaignId") String campaignId,
  );

  @POST('/request/approve')
  Future<DefaultResponse> updatePassengerRequests(
      @Body() UpdatePassengerRequest updateRequest);

  @PUT('/request/decline/{PassengerRequestId}')
  Future<DefaultResponse> declinePassengerRequest(
    @Path("PassengerRequestId") String passengerRequestId,
  );
  @GET('/passenger/request')
  Future<PassengerAllRequestsResponseData> getPassengerAllRequests();
  @PUT('/passenger/pick')
  Future<DefaultResponse> pickingPassenger(
      @Body() PickingPassengerRequest pickingPassengerRequest);
  @PUT('/ride/start')
  Future<StartRideResponse> startRide(
      @Body() RideStatusRequest rideStatusRequest);
  @POST('/ride/end')
  Future<DefaultResponse> endRide(@Body() RideStatusRequest rideStatusRequest);

  @POST('/chat')
  Future<CreateChatResponse> createChat(
      @Body() CreateChatRequest createChatRequest);

  @POST('/message')
  Future<SendMessageResponse> sendMessage(
      @Body() SendMessageRequest sendMessageRequest);
  @GET('/message/{chatId}')
  Future<GetMessageResponse> getAllMessages(
    @Path("chatId") String chatId,
  );
  @PUT('/rate/driver')
  Future<DefaultResponse> submittingRating(
      @Body() RatingSubmitRequest ratingSubmitRequest);

  @GET('/passenger/history/{passengerId}')
  Future<PassengerHistoryRidesResponse> getPassengerHistory(
    @Path("passengerId") String passengerId,
  );

  @POST('/ride/cancel')
  Future<DefaultResponse> cancelRide(
      @Body() CancelDriverRideRequest cancelDriverRideRequest);
  @GET('/driver/{driverId}')
  Future<DriverDetailsListResponse> getDriverDetails(
      @Path("driverId") String driverId);

  @POST('/notification')
  Future<DefaultResponse> sendNotification(
      @Body() SendNotificationRequest sendNotificationRequest);

  @GET('/rating/{driverId}')
  Future<RatingsResponse> getRatings(
    @Path("driverId") String driverId,
  );
}
