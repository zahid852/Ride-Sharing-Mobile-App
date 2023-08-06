import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class BaseResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "success")
  bool? success;
}

@JsonSerializable()
class DefaultResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "success")
  bool? success;

  DefaultResponse(this.message, this.success);

  //from json
  factory DefaultResponse.fromJson(Map<String, dynamic> json) =>
      _$DefaultResponseFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$DefaultResponseToJson(this);
}

@JsonSerializable()
class VerifyOtpResponse extends BaseResponse {
  @JsonKey(name: "userId")
  String? userId;
  @JsonKey(name: "token")
  String? token;
  @JsonKey(name: "isProfileCreated")
  bool? isProfileCreated;
  @JsonKey(name: "isDriver")
  bool? isDriver;
  @JsonKey(name: "isDriverProfileCreated")
  bool? isDriverProfileCreated;
  VerifyOtpResponse(this.userId, this.token, this.isProfileCreated,
      this.isDriver, this.isDriverProfileCreated);
  //from json
  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$VerifyOtpResponseToJson(this);
}

@JsonSerializable()
class ProfileDataResponse extends BaseResponse {
  @JsonKey(name: "data")
  List<PassengerDataResponse>? data;

  ProfileDataResponse(this.data);
  //from json
  factory ProfileDataResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataResponseFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$ProfileDataResponseToJson(this);
}

@JsonSerializable()
class PassengerDataResponse {
  @JsonKey(name: "userId")
  String? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "city")
  String? city;
  @JsonKey(name: "gender")
  String? gender;
  @JsonKey(name: "isDriver")
  bool? isDriver;
  @JsonKey(name: "profileImg")
  String? profileImg;

  @JsonKey(name: "totalRating")
  int? totalRating;
  @JsonKey(name: "totalReviewsGiven")
  int? totalReviewsGiven;
  @JsonKey(name: "fatherName")
  String? fatherName;
  @JsonKey(name: "liscenseExpiryDate")
  String? liscenseExpiryDate;
  @JsonKey(name: "phone")
  String? phone;
  @JsonKey(name: "vehicleType")
  String? vehicleType;
  PassengerDataResponse(
      this.name,
      this.email,
      this.city,
      this.gender,
      this.isDriver,
      this.profileImg,
      this.totalRating,
      this.totalReviewsGiven,
      this.fatherName,
      this.liscenseExpiryDate,
      this.phone,
      this.vehicleType);
  factory PassengerDataResponse.fromJson(Map<String, dynamic> json) =>
      _$PassengerDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PassengerDataResponseToJson(this);
}

@JsonSerializable()
class CampaignsResponse extends BaseResponse {
  @JsonKey(name: "campaigns")
  List<CampaignsData>? data;

  CampaignsResponse(this.data);
  //from json
  factory CampaignsResponse.fromJson(Map<String, dynamic> json) =>
      _$CampaignsResponseFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$CampaignsResponseToJson(this);
}

@JsonSerializable()
class CampaignsData {
  @JsonKey(name: "_id")
  String? campaignId;
  @JsonKey(name: "driverId")
  String? driverId;
  @JsonKey(name: "startLocation")
  String? startLocation;
  @JsonKey(name: "endingLocation")
  String? endingLocation;
  @JsonKey(name: "date")
  String? date;
  @JsonKey(name: "time")
  String? time;
  @JsonKey(name: "rideRules")
  RideRulesResponse? rideRules;
  @JsonKey(name: "comment")
  String? comment;

  @JsonKey(name: "seatCost")
  String? seatCost;
  @JsonKey(name: "expectedRideDistance")
  String? expectedRideDistance;
  @JsonKey(name: "expectedRideTime")
  String? expectedRideTime;
  @JsonKey(name: "availableSeats")
  int? availableSeats;
  @JsonKey(name: "bookedSeats")
  int? bookedSeats;
  @JsonKey(name: "vehicleType")
  String? vehicleType;
  @JsonKey(name: "vehicleBrand")
  String? vehicleBrand;
  @JsonKey(name: "vehicleNumber")
  String? vehicleNumber;
  @JsonKey(name: "vehicleImage")
  String? vehicleImage;
  @JsonKey(name: "totalRating")
  int? totalRating;
  @JsonKey(name: "totalReviewsGiven")
  int? totalReviewsGiven;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "profileImg")
  String? profileImg;
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "isNowRide")
  bool? isNowRide;
  CampaignsData(
      this.campaignId,
      this.driverId,
      this.startLocation,
      this.endingLocation,
      this.date,
      this.time,
      this.rideRules,
      this.comment,
      this.seatCost,
      this.expectedRideDistance,
      this.expectedRideTime,
      this.availableSeats,
      this.bookedSeats,
      this.vehicleType,
      this.vehicleBrand,
      this.vehicleNumber,
      this.vehicleImage,
      this.totalRating,
      this.totalReviewsGiven,
      this.name,
      this.profileImg,
      this.status,
      this.isNowRide);
  factory CampaignsData.fromJson(Map<String, dynamic> json) =>
      _$CampaignsDataFromJson(json);

  Map<String, dynamic> toJson() => _$CampaignsDataToJson(this);
}

@JsonSerializable()
class GetMessageResponse extends BaseResponse {
  @JsonKey(name: "result")
  List<MessageObjectResponse>? data;

  GetMessageResponse(this.data);
  //from json
  factory GetMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$GetMessageResponseFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$GetMessageResponseToJson(this);
}

@JsonSerializable()
class MessageObjectResponse {
  @JsonKey(name: "_id")
  String? messageId;
  @JsonKey(name: "chatId")
  String? chatRoomId;
  @JsonKey(name: "content")
  String? content;
  @JsonKey(name: "sender")
  String? senderId;
  MessageObjectResponse(
      this.messageId, this.chatRoomId, this.content, this.senderId);
  factory MessageObjectResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageObjectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MessageObjectResponseToJson(this);
}

@JsonSerializable()
class CreateChatResponse extends BaseResponse {
  @JsonKey(name: "chat")
  ChatObjectResponse? chatObject;

  CreateChatResponse(
    this.chatObject,
  );
  factory CreateChatResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateChatResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateChatResponseToJson(this);
}

@JsonSerializable()
class ChatObjectResponse {
  @JsonKey(name: "chatName")
  String? chatName;
  @JsonKey(name: "campaignId")
  String? campaignId;
  @JsonKey(name: "users")
  List<String>? users;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "profileImg")
  String? profileImg;
  @JsonKey(name: "_id")
  String? chatRoomId;

  ChatObjectResponse(this.chatName, this.campaignId, this.users, this.name,
      this.profileImg, this.chatRoomId);

  //from json
  factory ChatObjectResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatObjectResponseFromJson(json);

  //to josn
  Map<String, dynamic> toJson() => _$ChatObjectResponseToJson(this);
}

@JsonSerializable()
class SendMessageResponse extends BaseResponse {
  @JsonKey(name: "result")
  SendMessageObjectResponse? sendMessageObject;

  SendMessageResponse(
    this.sendMessageObject,
  );
  factory SendMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageResponseToJson(this);
}

@JsonSerializable()
class SendMessageObjectResponse {
  @JsonKey(name: "sender")
  String? sender;
  @JsonKey(name: "chatId")
  String? chatId;
  @JsonKey(name: "content")
  String? content;
  @JsonKey(name: "_id")
  String? sendMessageId;

  @JsonKey(name: "users")
  List<String>? users;
  @JsonKey(name: "senderName")
  String? senderName;
  @JsonKey(name: "senderImage")
  String? senderImage;

  SendMessageObjectResponse(this.sender, this.chatId, this.content,
      this.sendMessageId, this.users, this.senderName, this.senderImage);

  //from json
  factory SendMessageObjectResponse.fromJson(Map<String, dynamic> json) =>
      _$SendMessageObjectResponseFromJson(json);

  //to josn
  Map<String, dynamic> toJson() => _$SendMessageObjectResponseToJson(this);
}

@JsonSerializable()
class PassengerRequestRideResponse {
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "userId")
  String? userId;
  @JsonKey(name: "profileImg")
  String? profileImg;
  @JsonKey(name: "status")
  int? passengerRideStatus;
  @JsonKey(name: "requiredSeats")
  int? requiredSeats;
  @JsonKey(name: "fareOffered")
  int? fareOffered;
  @JsonKey(name: "pickupLocation")
  String? pickUpLocation;

  PassengerRequestRideResponse(
      this.name,
      this.userId,
      this.profileImg,
      this.passengerRideStatus,
      this.requiredSeats,
      this.fareOffered,
      this.pickUpLocation);
  //from json
  factory PassengerRequestRideResponse.fromJson(Map<String, dynamic> json) =>
      _$PassengerRequestRideResponseFromJson(json);

  //to josn
  Map<String, dynamic> toJson() => _$PassengerRequestRideResponseToJson(this);
}

@JsonSerializable()
class RideRulesResponse {
  @JsonKey(name: "isAc")
  bool? isAc;
  @JsonKey(name: "isSmoke")
  bool? isSmoke;
  @JsonKey(name: "isMusic")
  bool? isMusic;

  RideRulesResponse(this.isAc, this.isSmoke, this.isMusic);
  //from json
  factory RideRulesResponse.fromJson(Map<String, dynamic> json) =>
      _$RideRulesResponseFromJson(json);

  //to josn
  Map<String, dynamic> toJson() => _$RideRulesResponseToJson(this);
}

@JsonSerializable()
class DriverSpecificScheduleRidesResponse extends BaseResponse {
  @JsonKey(name: "campaigns")
  List<ScheduleRideResponse>? data;

  DriverSpecificScheduleRidesResponse(this.data);
  //from json
  factory DriverSpecificScheduleRidesResponse.fromJson(
          Map<String, dynamic> json) =>
      _$DriverSpecificScheduleRidesResponseFromJson(json);
  //to json
  Map<String, dynamic> toJson() =>
      _$DriverSpecificScheduleRidesResponseToJson(this);
}

@JsonSerializable()
class PassengerHistoryRidesResponse extends BaseResponse {
  @JsonKey(name: "history")
  List<ScheduleRideResponse>? data;

  PassengerHistoryRidesResponse(this.data);
  //from json
  factory PassengerHistoryRidesResponse.fromJson(Map<String, dynamic> json) =>
      _$PassengerHistoryRidesResponseFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$PassengerHistoryRidesResponseToJson(this);
}

@JsonSerializable()
class DriverPostCampaignResponse extends BaseResponse {
  @JsonKey(name: "campaign")
  ScheduleRideResponse data;

  DriverPostCampaignResponse(this.data);
  //from json
  factory DriverPostCampaignResponse.fromJson(Map<String, dynamic> json) =>
      _$DriverPostCampaignResponseFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$DriverPostCampaignResponseToJson(this);
}

@JsonSerializable()
class ScheduleRideResponse {
  @JsonKey(name: "_id")
  String? campaignId;
  @JsonKey(name: "driverId")
  String? driverId;
  @JsonKey(name: "startLocation")
  String? startLocation;
  @JsonKey(name: "endingLocation")
  String? endingLocation;
  @JsonKey(name: "date")
  String? date;
  @JsonKey(name: "time")
  String? time;
  @JsonKey(name: "rideRules")
  RideRulesResponse? rideRules;
  @JsonKey(name: "comment")
  String? comment;

  @JsonKey(name: "seatCost")
  String? seatCost;
  @JsonKey(name: "expectedRideDistance")
  String? expectedRideDistance;
  @JsonKey(name: "expectedRideTime")
  String? expectedRideTime;
  @JsonKey(name: "availableSeats")
  int? availableSeats;
  @JsonKey(name: "bookedSeats")
  int? bookedSeats;

  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "passengers")
  List<PassengerRequestRideResponse>? passengerRequestRideResponse;
  @JsonKey(name: "isNowRide")
  bool? isNowRide;
  ScheduleRideResponse(
      this.campaignId,
      this.driverId,
      this.startLocation,
      this.endingLocation,
      this.date,
      this.time,
      this.rideRules,
      this.comment,
      this.seatCost,
      this.expectedRideDistance,
      this.expectedRideTime,
      this.availableSeats,
      this.bookedSeats,
      this.status,
      this.passengerRequestRideResponse,
      this.isNowRide);
  factory ScheduleRideResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleRideResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleRideResponseToJson(this);
}

@JsonSerializable()
class PassengerRideShareRequestResponse extends BaseResponse {
  @JsonKey(name: "passengerId")
  String? passengerId;
  @JsonKey(name: "campaignId")
  String? campaignId;
  @JsonKey(name: "requireSeats")
  int? requireSeats;
  @JsonKey(name: "costPerSeat")
  int? seatCost;
  @JsonKey(name: "requestStatus")
  String? requestStatus;
  @JsonKey(name: "_id")
  String? id;
  PassengerRideShareRequestResponse(this.passengerId, this.campaignId,
      this.requireSeats, this.seatCost, this.requestStatus, this.id);
  //from json
  factory PassengerRideShareRequestResponse.fromJson(
          Map<String, dynamic> json) =>
      _$PassengerRideShareRequestResponseFromJson(json);
  //to json
  Map<String, dynamic> toJson() =>
      _$PassengerRideShareRequestResponseToJson(this);
}

@JsonSerializable()
class PassengerRequestsResponse extends BaseResponse {
  @JsonKey(name: "requests")
  List<PassengerRequestResponse>? data;

  PassengerRequestsResponse(this.data);
  //from json
  factory PassengerRequestsResponse.fromJson(Map<String, dynamic> json) =>
      _$PassengerRequestsResponseFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$PassengerRequestsResponseToJson(this);
}

@JsonSerializable()
class PassengerRequestResponse extends BaseResponse {
  @JsonKey(name: "passengerId")
  String? passengerId;
  @JsonKey(name: "campaignId")
  String? campaignId;
  @JsonKey(name: "requireSeats")
  int? requireSeats;
  @JsonKey(name: "costPerSeat")
  int? seatCost;
  @JsonKey(name: "requestStatus")
  String? requestStatus;
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "phone")
  String? phone;
  @JsonKey(name: "city")
  String? city;
  @JsonKey(name: "profileImg")
  String? imageUrl;
  @JsonKey(name: "pickupLocation")
  String? pickUpLocation;

  PassengerRequestResponse(
    this.passengerId,
    this.campaignId,
    this.requireSeats,
    this.seatCost,
    this.requestStatus,
    this.id,
    this.name,
    this.phone,
    this.city,
    this.imageUrl,
    this.pickUpLocation,
  );
  //from json
  factory PassengerRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$PassengerRequestResponseFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$PassengerRequestResponseToJson(this);
}

@JsonSerializable()
class PassengerAllRequestsResponseData extends BaseResponse {
  @JsonKey(name: "requests")
  List<PassengerAllRequestResponse>? data;

  PassengerAllRequestsResponseData(this.data);
  //from json
  factory PassengerAllRequestsResponseData.fromJson(
          Map<String, dynamic> json) =>
      _$PassengerAllRequestsResponseDataFromJson(json);
  //to json
  Map<String, dynamic> toJson() =>
      _$PassengerAllRequestsResponseDataToJson(this);
}

@JsonSerializable()
class PassengerAllRequestResponse extends BaseResponse {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "passengerId")
  String? passengerId;
  @JsonKey(name: "campaignId")
  String? campaignId;
  @JsonKey(name: "requireSeats")
  int? requireSeats;
  @JsonKey(name: "costPerSeat")
  int? seatCost;
  @JsonKey(name: "requestStatus")
  String? requestStatus;
  @JsonKey(name: "startLocation")
  String? startLocation;
  @JsonKey(name: "endingLocation")
  String? endingLocation;
  @JsonKey(name: "expectedRideDistance")
  String? expectedRideDistance;
  @JsonKey(name: "expectedRideTime")
  String? expectedRideTime;
  @JsonKey(name: "startDate")
  String? startDate;
  @JsonKey(name: "startTime")
  String? startTime;
  @JsonKey(name: "availableSeats")
  int? availableSeats;
  @JsonKey(name: "bookedSeats")
  int? bookedSeats;
  @JsonKey(name: "driverName")
  String? driverName;
  @JsonKey(name: "driverImage")
  String? driverImage;
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "vehicleType")
  String? vehicleType;
  @JsonKey(name: "vehicleBrand")
  String? vehicleBrand;
  @JsonKey(name: "vehicleNumber")
  String? vehicleNumber;
  @JsonKey(name: "vehicleImage")
  String? vehicleImage;
  @JsonKey(name: "driverId")
  String? driverId;

  PassengerAllRequestResponse(
      this.id,
      this.passengerId,
      this.campaignId,
      this.requireSeats,
      this.seatCost,
      this.requestStatus,
      this.startLocation,
      this.endingLocation,
      this.expectedRideDistance,
      this.expectedRideTime,
      this.startDate,
      this.startTime,
      this.availableSeats,
      this.bookedSeats,
      this.driverName,
      this.driverImage,
      this.status,
      this.vehicleType,
      this.vehicleBrand,
      this.vehicleNumber,
      this.vehicleImage,
      this.driverId);
  //from json
  factory PassengerAllRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$PassengerAllRequestResponseFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$PassengerAllRequestResponseToJson(this);
}

@JsonSerializable()
class DriverDetailsListResponse extends BaseResponse {
  @JsonKey(name: "user")
  List<DriverDetailsResponse>? data;

  DriverDetailsListResponse(this.data);
  //from json
  factory DriverDetailsListResponse.fromJson(Map<String, dynamic> json) =>
      _$DriverDetailsListResponseFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$DriverDetailsListResponseToJson(this);
}

@JsonSerializable()
class DriverDetailsResponse extends BaseResponse {
  @JsonKey(name: "userId")
  String? userId;
  @JsonKey(name: "fatherName")
  String? fatherName;
  @JsonKey(name: "birthDate")
  String? birthDate;
  @JsonKey(name: "cnic")
  String? cnic;
  @JsonKey(name: "cnicImgFront")
  String? cnicImgFront;
  @JsonKey(name: "cnicImgBack")
  String? cnicImgBack;
  @JsonKey(name: "totalReviewsGiven")
  int? totalReviewsGiven;
  @JsonKey(name: "totalRating")
  int? totalRating;
  @JsonKey(name: "profileStatus")
  bool? profileStatus;
  @JsonKey(name: "residentialAddress")
  String? residentialAddress;
  @JsonKey(name: "vehicleType")
  String? vehicleType;
  @JsonKey(name: "vehicleNumber")
  String? vehicleNumber;
  @JsonKey(name: "vehicleBrand")
  String? vehicleBrand;
  @JsonKey(name: "vehicleRegisterCertificate")
  String? vehicleRegisterCertificate;
  @JsonKey(name: "vehicleImage")
  String? vehicleImage;
  @JsonKey(name: "liscenseNumber")
  String? liscenseNumber;
  @JsonKey(name: "liscenseImage")
  String? liscenseImage;
  @JsonKey(name: "liscenseExpiryDate")
  String? liscenseExpiryDate;

  DriverDetailsResponse(
      this.userId,
      this.fatherName,
      this.birthDate,
      this.cnic,
      this.cnicImgFront,
      this.cnicImgBack,
      this.totalReviewsGiven,
      this.totalRating,
      this.profileStatus,
      this.residentialAddress,
      this.vehicleType,
      this.vehicleNumber,
      this.vehicleBrand,
      this.vehicleRegisterCertificate,
      this.vehicleImage,
      this.liscenseNumber,
      this.liscenseImage,
      this.liscenseExpiryDate);

  factory DriverDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$DriverDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DriverDetailsResponseToJson(this);
}

@JsonSerializable()
class RatingsResponse extends BaseResponse {
  @JsonKey(name: "rating")
  List<RatingDataResponse>? data;

  RatingsResponse(this.data);
  //from json
  factory RatingsResponse.fromJson(Map<String, dynamic> json) =>
      _$RatingsResponseFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$RatingsResponseToJson(this);
}

@JsonSerializable()
class RatingDataResponse extends BaseResponse {
  @JsonKey(name: "driverId")
  String? driverId;
  @JsonKey(name: "passengerId")
  String? passengerId;
  @JsonKey(name: "rating")
  int? rating;
  @JsonKey(name: "comment")
  String? comment;
  @JsonKey(name: "name")
  String? passengerName;
  @JsonKey(name: "profileImg")
  String? profileImg;
  @JsonKey(name: "dateTime")
  String? dateTime;

  RatingDataResponse(this.driverId, this.passengerId, this.rating, this.comment,
      this.passengerName, this.profileImg, this.dateTime);
  //from json
  factory RatingDataResponse.fromJson(Map<String, dynamic> json) =>
      _$RatingDataResponseFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$RatingDataResponseToJson(this);
}

@JsonSerializable()
class StartRideResponse extends BaseResponse {
  @JsonKey(name: "_id")
  String? campaignId;
  @JsonKey(name: "driverId")
  String? driverId;
  @JsonKey(name: "startLocation")
  String? startLocation;
  @JsonKey(name: "endingLocation")
  String? endingLocation;
  @JsonKey(name: "date")
  String? date;
  @JsonKey(name: "time")
  String? time;
  @JsonKey(name: "rideRules")
  RideRulesResponse? rideRules;
  @JsonKey(name: "comment")
  String? comment;

  @JsonKey(name: "seatCost")
  String? seatCost;
  @JsonKey(name: "expectedRideDistance")
  String? expectedRideDistance;
  @JsonKey(name: "expectedRideTime")
  String? expectedRideTime;
  @JsonKey(name: "availableSeats")
  int? availableSeats;
  @JsonKey(name: "bookedSeats")
  int? bookedSeats;

  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "passengers")
  List<StartRidePassengersResponse>? startRidePassengers;
  StartRideResponse(
      this.campaignId,
      this.driverId,
      this.startLocation,
      this.endingLocation,
      this.date,
      this.time,
      this.rideRules,
      this.comment,
      this.seatCost,
      this.expectedRideDistance,
      this.expectedRideTime,
      this.availableSeats,
      this.bookedSeats,
      this.status,
      this.startRidePassengers);
  factory StartRideResponse.fromJson(Map<String, dynamic> json) =>
      _$StartRideResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StartRideResponseToJson(this);
}

@JsonSerializable()
class StartRidePassengersResponse extends BaseResponse {
  @JsonKey(name: "id")
  String? passengerId;
  @JsonKey(name: "status")
  int? requestStatus;
  @JsonKey(name: "requiredSeats")
  int? requiredSeats;
  @JsonKey(name: "fareOffered")
  int? costPerSeat;
  @JsonKey(name: "_id")
  String? passengerRequestId;
  StartRidePassengersResponse(this.passengerId, this.requestStatus,
      this.requiredSeats, this.costPerSeat, this.passengerRequestId);
  //from json
  factory StartRidePassengersResponse.fromJson(Map<String, dynamic> json) =>
      _$StartRidePassengersResponseFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$StartRidePassengersResponseToJson(this);
}
