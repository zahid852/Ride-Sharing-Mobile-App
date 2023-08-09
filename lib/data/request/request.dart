import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import '../../domain/model/models.dart';
part 'request.g.dart';

class VerifyOtpRequest {
  String phoneNumber;
  String otp;
  String fcmToken;
  VerifyOtpRequest(this.phoneNumber, this.otp, this.fcmToken);
}

class RegisterPassengerRequest {
  String name;
  String email;
  String userId;
  String city;
  String gender;
  bool isDriver;
  File profileImg;
  RegisterPassengerRequest(this.name, this.email, this.userId, this.city,
      this.gender, this.isDriver, this.profileImg);
}

class RegisterDriverRequest {
  String userId;
  String cnic;
  String fatherName;
  String birthDate;
  String address;
  File cnicFrontImage;
  File cnicBackImage;
  String vehicleType;
  String vehicleBrand;
  String vehicleNumber;
  File vehicleImage;
  File vehicleCertificateImage;
  String licenseNumber;
  String licenseExpiryDate;
  File licenseImage;
  int totalReviewsGiven;
  int tatalRating;
  RegisterDriverRequest(
      this.userId,
      this.cnic,
      this.fatherName,
      this.birthDate,
      this.address,
      this.cnicFrontImage,
      this.cnicBackImage,
      this.vehicleType,
      this.vehicleBrand,
      this.vehicleNumber,
      this.vehicleImage,
      this.vehicleCertificateImage,
      this.licenseNumber,
      this.licenseExpiryDate,
      this.licenseImage,
      this.totalReviewsGiven,
      this.tatalRating);
}

class UserDetailsRequest {
  String userId;
  UserDetailsRequest(this.userId);
}

class SharedRideCompaignRequest {
  String driverId;
  String startingLocation;
  String endingLocation;
  String rideTime;
  String rideDate;
  RideRules rideRules;
  int availableSeats;
  double seatCost;
  String comment;
  String expectedRideDistance;
  String expectedRideTime;
  bool isNowRide;
  SharedRideCompaignRequest(
      this.driverId,
      this.startingLocation,
      this.endingLocation,
      this.rideTime,
      this.rideDate,
      this.rideRules,
      this.availableSeats,
      this.seatCost,
      this.comment,
      this.expectedRideDistance,
      this.expectedRideTime,
      this.isNowRide);
}

class PassengerRideShareRequest {
  String passengerId;
  String campaignId;
  int requireSeats;
  int seatCost;
  String customPickUpLocation;
  String driverId;

  PassengerRideShareRequest(
      this.passengerId,
      this.campaignId,
      this.requireSeats,
      this.seatCost,
      this.customPickUpLocation,
      this.driverId);
}

class PassengerRequestsGetRequest {
  String campaingId;

  PassengerRequestsGetRequest(this.campaingId);
}

@JsonSerializable()
class UpdatePassengerRequest {
  @JsonKey(name: "campaignId")
  String? campaignId;
  @JsonKey(name: "passengerRequestId")
  String? requestId;

  UpdatePassengerRequest(this.campaignId, this.requestId);

  //from json
  factory UpdatePassengerRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePassengerRequestFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$UpdatePassengerRequestToJson(this);
}

class DeclinePassengerRequest {
  String requestId;

  DeclinePassengerRequest(this.requestId);
}

class DriverScheduleRidesRequest {
  String driverId;

  DriverScheduleRidesRequest(this.driverId);
}

class PassengerDataRequest {
  String passengerId;

  PassengerDataRequest(this.passengerId);
}

@JsonSerializable()
class PickingPassengerRequest {
  @JsonKey(name: "campaignId")
  String? campaignId;
  @JsonKey(name: "passengerId")
  String? passengerId;

  PickingPassengerRequest(this.campaignId, this.passengerId);

  //from json
  factory PickingPassengerRequest.fromJson(Map<String, dynamic> json) =>
      _$PickingPassengerRequestFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$PickingPassengerRequestToJson(this);
}

@JsonSerializable()
class RideStatusRequest {
  @JsonKey(name: "campaignId")
  String? campaignId;

  RideStatusRequest(this.campaignId);

  //from json
  factory RideStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$RideStatusRequestFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$RideStatusRequestToJson(this);
}

@JsonSerializable()
class CreateChatRequest {
  @JsonKey(name: "campaignId")
  String? campaignId;
  @JsonKey(name: "userId")
  String? opponentUserId;

  CreateChatRequest(this.campaignId, this.opponentUserId);

  //from json
  factory CreateChatRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateChatRequestFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$CreateChatRequestToJson(this);
}

@JsonSerializable()
class SendMessageRequest {
  @JsonKey(name: "chatId")
  String? chatId;
  @JsonKey(name: "content")
  String? content;

  SendMessageRequest(this.chatId, this.content);

  //from json
  factory SendMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$SendMessageRequestFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$SendMessageRequestToJson(this);
}

class GetMessagesRequest {
  String chatId;
  GetMessagesRequest(this.chatId);
}

@JsonSerializable()
class RatingSubmitRequest {
  @JsonKey(name: "driverId")
  String? driverId;
  @JsonKey(name: "rating")
  int? rating;
  @JsonKey(name: "campaignId")
  String? campaignId;
  @JsonKey(name: "comment")
  String? comment;
  @JsonKey(name: "dateTime")
  String? dateTime;

  RatingSubmitRequest(
      this.driverId, this.rating, this.campaignId, this.comment, this.dateTime);

  //from json
  factory RatingSubmitRequest.fromJson(Map<String, dynamic> json) =>
      _$RatingSubmitRequestFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$RatingSubmitRequestToJson(this);
}

@JsonSerializable()
class CancelDriverRideRequest {
  @JsonKey(name: "campaignId")
  String? campaignId;

  CancelDriverRideRequest(this.campaignId);

  //from json
  factory CancelDriverRideRequest.fromJson(Map<String, dynamic> json) =>
      _$CancelDriverRideRequestFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$CancelDriverRideRequestToJson(this);
}

@JsonSerializable()
class SendNotificationRequest {
  @JsonKey(name: "receiverIds")
  List<String>? receiverId;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "content")
  String? content;
  @JsonKey(name: "data")
  Map<String, dynamic>? data;
  @JsonKey(name: "token")
  String? token;

  SendNotificationRequest(
      this.receiverId, this.title, this.content, this.data, this.token);

  //from json
  factory SendNotificationRequest.fromJson(Map<String, dynamic> json) =>
      _$SendNotificationRequestFromJson(json);
  //to json
  Map<String, dynamic> toJson() => _$SendNotificationRequestToJson(this);
}
