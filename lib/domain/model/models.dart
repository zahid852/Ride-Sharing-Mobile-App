import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lift_app/data/mapper/mappers.dart';
import 'package:lift_app/presentations/utils/utils.dart';
part 'models.g.dart';

class DefaultMessageModel {
  bool status;
  String message;
  DefaultMessageModel(this.status, this.message);
}

class AuthModel {
  String userId;
  String token;
  String message;
  bool isProfileCreated;
  bool isDriver;
  bool isDriverProfileCreated;
  AuthModel(this.userId, this.token, this.message, this.isProfileCreated,
      this.isDriver, this.isDriverProfileCreated);
}

@JsonSerializable()
class PassengerProfileModel {
  String id;
  String name;
  String email;
  String city;
  String gender;
  String profileType;
  PassengerProfileModel(
      this.id, this.name, this.email, this.city, this.gender, this.profileType);
  //from json
  factory PassengerProfileModel.fromJson(Map<String, dynamic> json) =>
      _$PassengerProfileModelFromJson(json);

  //to josn
  Map<String, dynamic> toJson() => _$PassengerProfileModelToJson(this);
}

@JsonSerializable()
class BasicInfoModel {
  String id;
  String cnic;
  String fatherName;
  String birthDate;
  String address;
  BasicInfoModel(
      this.id, this.cnic, this.fatherName, this.birthDate, this.address);
  //from json
  factory BasicInfoModel.fromJson(Map<String, dynamic> json) =>
      _$BasicInfoModelFromJson(json);

  //to josn
  Map<String, dynamic> toJson() => _$BasicInfoModelToJson(this);
}

@JsonSerializable()
class CNICImagesModel {
  String id;
  String cnicFront;
  String cnicBack;
  CNICImagesModel(this.id, this.cnicFront, this.cnicBack);
  //from json
  factory CNICImagesModel.fromJson(Map<String, dynamic> json) =>
      _$CNICImagesModelFromJson(json);

  //to josn
  Map<String, dynamic> toJson() => _$CNICImagesModelToJson(this);
}

@JsonSerializable()
class VehicleInfoModel {
  String id;
  String type;
  String brand;
  String number;

  VehicleInfoModel(this.id, this.type, this.brand, this.number);
  //from json
  factory VehicleInfoModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleInfoModelFromJson(json);

  //to josn
  Map<String, dynamic> toJson() => _$VehicleInfoModelToJson(this);
}

@JsonSerializable()
class VehicleImagesModel {
  String id;
  String vehicle;
  String vehicleRegistrationCertificate;
  VehicleImagesModel(
      this.id, this.vehicle, this.vehicleRegistrationCertificate);
  //from json
  factory VehicleImagesModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleImagesModelFromJson(json);

  //to josn
  Map<String, dynamic> toJson() => _$VehicleImagesModelToJson(this);
}

@JsonSerializable()
class LicenseInfoModel {
  String id;
  String number;
  String expiryDate;
  String licenseCertificate;
  LicenseInfoModel(
      this.id, this.number, this.expiryDate, this.licenseCertificate);
  //from json
  factory LicenseInfoModel.fromJson(Map<String, dynamic> json) =>
      _$LicenseInfoModelFromJson(json);

  //to josn
  Map<String, dynamic> toJson() => _$LicenseInfoModelToJson(this);
}

class PickedLocation {
  LocationType locationType;
  String address;
  LatLng coardinates;

  PickedLocation(this.locationType, this.address, this.coardinates);
}

@JsonSerializable()
class NotificationModel {
  String userId;
  String title;
  String body;
  String userImage;
  String dateTime;

  NotificationModel(
      this.userId, this.title, this.body, this.userImage, this.dateTime);
  //from json
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  //to josn
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}

class LocationEntries {
  Location pickUpLocation;
  String pickLocationAddress;
  Location destinationLocation;
  String destinationLocationAddress;
  String distance;
  String time;

  LocationEntries(
      {required this.pickUpLocation,
      required this.pickLocationAddress,
      required this.destinationLocation,
      required this.destinationLocationAddress,
      required this.distance,
      required this.time});
}

class PassengerDataModal {
  String id;
  String name;
  String email;
  String city;
  String gender;
  bool isDriver;
  String profileImg;
  int totalRating;
  int totalReviewsGiven;
  String fatherName;
  String liscenseExpiryDate;
  String phone;
  String vehicleType;

  PassengerDataModal(
      this.id,
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
}

class ProfileDataModal {
  List<PassengerDataModal> passengerDataList;

  ProfileDataModal(this.passengerDataList);
}

// @JsonSerializable()
// class SharedRideCompaignModel {
//   String? id;
//   String driverId;
//   String startingLocation;
//   String endingLocation;
//   String rideTime;
//   String rideDate;
//   RideRules rideRules;
//   int availableSeats;
//   int seatCost;
//   String comment;
//   String expectedRideDistance;
//   String expectedRideTime;
//   SharedRideCompaignModel(
//       this.id,
//       this.driverId,
//       this.startingLocation,
//       this.endingLocation,
//       this.rideTime,
//       this.rideDate,
//       this.rideRules,
//       this.availableSeats,
//       this.seatCost,
//       this.comment,
//       this.expectedRideDistance,
//       this.expectedRideTime);
// //from json
// factory SharedRideCompaignModel.fromJson(Map<String, dynamic> json) =>
//     _$SharedRideCompaignModelFromJson(json);

// //to josn
// Map<String, dynamic> toJson() => _$SharedRideCompaignModelToJson(this);
// }

@JsonSerializable()
class RideRules {
  @JsonKey(name: "isAc")
  bool isAc;
  @JsonKey(name: "isSmoke")
  bool isSmoke;
  @JsonKey(name: "isMusic")
  bool isMusic;

  RideRules(this.isAc, this.isSmoke, this.isMusic);
  //from json
  factory RideRules.fromJson(Map<String, dynamic> json) =>
      _$RideRulesFromJson(json);

  //to josn
  Map<String, dynamic> toJson() => _$RideRulesToJson(this);
}

@JsonSerializable()
class PassengerRequestRideDetails {
  String name;
  String userId;
  String profileImg;
  int passengerRideStatus;
  int requiredSeats;
  int fareOffered;
  String pickUpLocation;

  PassengerRequestRideDetails(
      this.name,
      this.userId,
      this.profileImg,
      this.passengerRideStatus,
      this.requiredSeats,
      this.fareOffered,
      this.pickUpLocation);
  //from json
  factory PassengerRequestRideDetails.fromJson(Map<String, dynamic> json) =>
      _$PassengerRequestRideDetailsFromJson(json);

  //to josn
  Map<String, dynamic> toJson() => _$PassengerRequestRideDetailsToJson(this);
}

class ScheduleRides {
  List<ScheduleRideDataModal> scheduleRideList;

  ScheduleRides(this.scheduleRideList);
}

class ScheduleRideDataModal {
  String campaignId;
  String driverId;
  String startingLocation;
  String endingLocation;
  String date;
  String time;
  RideRules rideRules;
  String comment;
  String seatCost;
  String expectedRideDistance;
  String expectedRideTime;
  int availableSeats;
  int bookedSeats;
  int status;
  List<PassengerRequestRideDetails> passengerRequestRide;
  bool isNowRide;
  ScheduleRideDataModal(
      this.campaignId,
      this.driverId,
      this.startingLocation,
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
      this.passengerRequestRide,
      this.isNowRide);
}

class CampaignsDataModal {
  String campaignId;
  String driverId;
  String startingLocation;
  String endingLocation;
  String date;
  String time;
  RideRules rideRules;
  String comment;
  String seatCost;
  String expectedRideDistance;
  String expectedRideTime;
  int availableSeats;
  int bookedSeats;
  String vehicleType;
  String vehicleBrand;
  String vehicleNumber;
  String vehicleImage;
  int totalRating;
  int totalReviewsGiven;
  String name;
  String profileImage;
  int status;
  bool isNowRide;
  CampaignsDataModal(
      this.campaignId,
      this.driverId,
      this.startingLocation,
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
      this.profileImage,
      this.status,
      this.isNowRide);
}

class CampaignsModal {
  List<CampaignsDataModal> campaignsData;

  CampaignsModal(this.campaignsData);
}

class PassengerRequestResponseData {
  String passengerId;
  String campaignId;
  int requireSeats;
  int costPerSeat;

  String requestStatus;
  String passengerResquestId;

  PassengerRequestResponseData(
    this.passengerId,
    this.campaignId,
    this.requireSeats,
    this.costPerSeat,
    this.requestStatus,
    this.passengerResquestId,
  );
}

class CreateChatModel {
  ChatObjectModel chatModel;

  CreateChatModel(this.chatModel);
}

@JsonSerializable()
class ChatObjectModel {
  String chatName;
  String campaignId;
  List<String> usersList;
  String name;
  String profileImg;
  String roomId;

  ChatObjectModel(this.chatName, this.campaignId, this.usersList, this.name,
      this.profileImg, this.roomId);
  //from json
  factory ChatObjectModel.fromJson(Map<String, dynamic> json) =>
      _$ChatObjectModelFromJson(json);

  //to josn
  Map<String, dynamic> toJson() => _$ChatObjectModelToJson(this);
}

class SendMessageModel {
  SendMessageObjectModel sendMessageObjectModel;

  SendMessageModel(this.sendMessageObjectModel);
}

class SendMessageObjectModel {
  String senderId;
  String chatId;
  String content;
  String sendMessageId;
  List<String> usersList;
  String senderImage;
  String senderName;

  SendMessageObjectModel(this.senderId, this.chatId, this.content,
      this.sendMessageId, this.usersList, this.senderImage, this.senderName);
}

class GetMessagesModel {
  List<MessageObjectModel> messageObjectModelList;

  GetMessagesModel(this.messageObjectModelList);
}

class MessageObjectModel {
  String messageId;
  String senderId;
  String chatId;
  String content;

  MessageObjectModel(this.messageId, this.senderId, this.chatId, this.content);
}

class PassengerRequests {
  List<PassengerDetailRequestResponseData> passengerRequestsData;

  PassengerRequests(this.passengerRequestsData);
}

class PassengerDetailRequestResponseData {
  String passengerId;
  String campaignId;
  int requireSeats;
  int costPerSeat;
  String requestStatus;
  String passengerResquestId;
  String name;
  String city;
  String phone;
  String imageUrl;
  String customPickUpLocation;

  PassengerDetailRequestResponseData(
    this.passengerId,
    this.campaignId,
    this.requireSeats,
    this.costPerSeat,
    this.requestStatus,
    this.passengerResquestId,
    this.name,
    this.city,
    this.phone,
    this.imageUrl,
    this.customPickUpLocation,
  );
}

class CustomPassengerLocation {
  String pickUpLocation;
  String price;
  CustomPassengerLocation(this.pickUpLocation, this.price);
}

class PassengerAllRequestsData {
  List<PassengerAllRequests> passengerAllRequests;

  PassengerAllRequestsData(this.passengerAllRequests);
}

class PassengerAllRequests {
  String requestId;
  String passengerId;
  String campaignId;
  int requireSeats;
  int costPerSeat;
  String requestStatus;
  String startingLocation;
  String endingLocation;
  String expectedRideDistance;
  String expectedRideTime;
  String startDate;
  String startTime;
  int availableSeats;
  int bookedSeats;
  String driverName;
  String driverImage;
  int status;
  String vehicleType;
  String vehicleBrand;
  String vehicleNumber;
  String vehicleImage;
  String driverId;
  PassengerAllRequests(
      this.requestId,
      this.passengerId,
      this.campaignId,
      this.requireSeats,
      this.costPerSeat,
      this.requestStatus,
      this.startingLocation,
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
}

class PushNotificationCredentials {
  static String token = EMPTY;
  static BuildContext? homeContext;
}

class DriverDetailsList {
  List<DriverDetailsModel> driverList;

  DriverDetailsList(this.driverList);
}

class DriverDetailsModel {
  String userId;
  String fatherName;
  String birthDate;
  String cnic;
  String cnicImgFront;
  String cnicImgBack;
  int totalReviewsGiven;
  int totalRating;
  bool profileStatus;
  String residentialAddress;
  String vehicleType;
  String vehicleNumber;
  String vehicleBrand;
  String vehicleRegisterCertificate;
  String vehicleImage;
  String liscenseNumber;
  String liscenseImage;
  String liscenseExpiryDate;
  DriverDetailsModel(
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
}

class RatingsModel {
  List<RatingDataModel> ratingsData;

  RatingsModel(this.ratingsData);
}

class RatingDataModel {
  String driverId;
  String passengerId;
  int rating;
  String comment;
  String passengerName;
  String passengerProfileImg;
  String dateTime;

  RatingDataModel(this.driverId, this.passengerId, this.rating, this.comment,
      this.passengerName, this.passengerProfileImg, this.dateTime);
}

@JsonSerializable()
class StartRidePassengersModel {
  String passengerId;
  int requestStatus;
  int requiredSeats;
  int fareOffered;
  String passengerRequestId;

  StartRidePassengersModel(this.passengerId, this.requestStatus,
      this.requiredSeats, this.fareOffered, this.passengerRequestId);
  //from json
  factory StartRidePassengersModel.fromJson(Map<String, dynamic> json) =>
      _$StartRidePassengersModelFromJson(json);

  //to josn
  Map<String, dynamic> toJson() => _$StartRidePassengersModelToJson(this);
}

class StartRideModel {
  String campaignId;
  String driverId;
  String startingLocation;
  String endingLocation;
  String date;
  String time;
  RideRules rideRules;
  String comment;
  String seatCost;
  String expectedRideDistance;
  String expectedRideTime;
  int availableSeats;
  int bookedSeats;
  int status;
  List<StartRidePassengersModel> startRidePassengers;
  StartRideModel(
      this.campaignId,
      this.driverId,
      this.startingLocation,
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
}
