// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PassengerProfileModel _$PassengerProfileModelFromJson(
        Map<String, dynamic> json) =>
    PassengerProfileModel(
      json['id'] as String,
      json['name'] as String,
      json['email'] as String,
      json['city'] as String,
      json['gender'] as String,
      json['profileType'] as String,
    );

Map<String, dynamic> _$PassengerProfileModelToJson(
        PassengerProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'city': instance.city,
      'gender': instance.gender,
      'profileType': instance.profileType,
    };

BasicInfoModel _$BasicInfoModelFromJson(Map<String, dynamic> json) =>
    BasicInfoModel(
      json['id'] as String,
      json['cnic'] as String,
      json['fatherName'] as String,
      json['birthDate'] as String,
      json['address'] as String,
    );

Map<String, dynamic> _$BasicInfoModelToJson(BasicInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cnic': instance.cnic,
      'fatherName': instance.fatherName,
      'birthDate': instance.birthDate,
      'address': instance.address,
    };

CNICImagesModel _$CNICImagesModelFromJson(Map<String, dynamic> json) =>
    CNICImagesModel(
      json['id'] as String,
      json['cnicFront'] as String,
      json['cnicBack'] as String,
    );

Map<String, dynamic> _$CNICImagesModelToJson(CNICImagesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cnicFront': instance.cnicFront,
      'cnicBack': instance.cnicBack,
    };

VehicleInfoModel _$VehicleInfoModelFromJson(Map<String, dynamic> json) =>
    VehicleInfoModel(
      json['id'] as String,
      json['type'] as String,
      json['brand'] as String,
      json['number'] as String,
    );

Map<String, dynamic> _$VehicleInfoModelToJson(VehicleInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'brand': instance.brand,
      'number': instance.number,
    };

VehicleImagesModel _$VehicleImagesModelFromJson(Map<String, dynamic> json) =>
    VehicleImagesModel(
      json['id'] as String,
      json['vehicle'] as String,
      json['vehicleRegistrationCertificate'] as String,
    );

Map<String, dynamic> _$VehicleImagesModelToJson(VehicleImagesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicle': instance.vehicle,
      'vehicleRegistrationCertificate': instance.vehicleRegistrationCertificate,
    };

LicenseInfoModel _$LicenseInfoModelFromJson(Map<String, dynamic> json) =>
    LicenseInfoModel(
      json['id'] as String,
      json['number'] as String,
      json['expiryDate'] as String,
      json['licenseCertificate'] as String,
    );

Map<String, dynamic> _$LicenseInfoModelToJson(LicenseInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'expiryDate': instance.expiryDate,
      'licenseCertificate': instance.licenseCertificate,
    };

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      json['userId'] as String,
      json['title'] as String,
      json['body'] as String,
      json['userImage'] as String,
      json['dateTime'] as String,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'title': instance.title,
      'body': instance.body,
      'userImage': instance.userImage,
      'dateTime': instance.dateTime,
    };

RideRules _$RideRulesFromJson(Map<String, dynamic> json) => RideRules(
      json['isAc'] as bool,
      json['isSmoke'] as bool,
      json['isMusic'] as bool,
    );

Map<String, dynamic> _$RideRulesToJson(RideRules instance) => <String, dynamic>{
      'isAc': instance.isAc,
      'isSmoke': instance.isSmoke,
      'isMusic': instance.isMusic,
    };

PassengerRequestRideDetails _$PassengerRequestRideDetailsFromJson(
        Map<String, dynamic> json) =>
    PassengerRequestRideDetails(
      json['name'] as String,
      json['userId'] as String,
      json['profileImg'] as String,
      json['passengerRideStatus'] as int,
      json['requiredSeats'] as int,
      json['fareOffered'] as int,
      json['pickUpLocation'] as String,
    );

Map<String, dynamic> _$PassengerRequestRideDetailsToJson(
        PassengerRequestRideDetails instance) =>
    <String, dynamic>{
      'name': instance.name,
      'userId': instance.userId,
      'profileImg': instance.profileImg,
      'passengerRideStatus': instance.passengerRideStatus,
      'requiredSeats': instance.requiredSeats,
      'fareOffered': instance.fareOffered,
      'pickUpLocation': instance.pickUpLocation,
    };

ChatObjectModel _$ChatObjectModelFromJson(Map<String, dynamic> json) =>
    ChatObjectModel(
      json['chatName'] as String,
      json['campaignId'] as String,
      (json['usersList'] as List<dynamic>).map((e) => e as String).toList(),
      json['name'] as String,
      json['profileImg'] as String,
      json['roomId'] as String,
    );

Map<String, dynamic> _$ChatObjectModelToJson(ChatObjectModel instance) =>
    <String, dynamic>{
      'chatName': instance.chatName,
      'campaignId': instance.campaignId,
      'usersList': instance.usersList,
      'name': instance.name,
      'profileImg': instance.profileImg,
      'roomId': instance.roomId,
    };

StartRidePassengersModel _$StartRidePassengersModelFromJson(
        Map<String, dynamic> json) =>
    StartRidePassengersModel(
      json['passengerId'] as String,
      json['requestStatus'] as int,
      json['requiredSeats'] as int,
      json['fareOffered'] as int,
      json['passengerRequestId'] as String,
    );

Map<String, dynamic> _$StartRidePassengersModelToJson(
        StartRidePassengersModel instance) =>
    <String, dynamic>{
      'passengerId': instance.passengerId,
      'requestStatus': instance.requestStatus,
      'requiredSeats': instance.requiredSeats,
      'fareOffered': instance.fareOffered,
      'passengerRequestId': instance.passengerRequestId,
    };
