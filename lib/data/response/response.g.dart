// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) => BaseResponse()
  ..message = json['message'] as String?
  ..success = json['success'] as bool?;

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
    };

DefaultResponse _$DefaultResponseFromJson(Map<String, dynamic> json) =>
    DefaultResponse(
      json['message'] as String?,
      json['success'] as bool?,
    );

Map<String, dynamic> _$DefaultResponseToJson(DefaultResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
    };

VerifyOtpResponse _$VerifyOtpResponseFromJson(Map<String, dynamic> json) =>
    VerifyOtpResponse(
      json['userId'] as String?,
      json['token'] as String?,
      json['isProfileCreated'] as bool?,
      json['isDriver'] as bool?,
      json['isDriverProfileCreated'] as bool?,
    )
      ..message = json['message'] as String?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$VerifyOtpResponseToJson(VerifyOtpResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'userId': instance.userId,
      'token': instance.token,
      'isProfileCreated': instance.isProfileCreated,
      'isDriver': instance.isDriver,
      'isDriverProfileCreated': instance.isDriverProfileCreated,
    };

ProfileDataResponse _$ProfileDataResponseFromJson(Map<String, dynamic> json) =>
    ProfileDataResponse(
      (json['data'] as List<dynamic>?)
          ?.map(
              (e) => PassengerDataResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..message = json['message'] as String?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$ProfileDataResponseToJson(
        ProfileDataResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
    };

PassengerDataResponse _$PassengerDataResponseFromJson(
        Map<String, dynamic> json) =>
    PassengerDataResponse(
      json['name'] as String?,
      json['email'] as String?,
      json['city'] as String?,
      json['gender'] as String?,
      json['isDriver'] as bool?,
      json['profileImg'] as String?,
      json['totalRating'] as int?,
      json['totalReviewsGiven'] as int?,
      json['fatherName'] as String?,
      json['liscenseExpiryDate'] as String?,
      json['phone'] as String?,
      json['vehicleType'] as String?,
    )..id = json['userId'] as String?;

Map<String, dynamic> _$PassengerDataResponseToJson(
        PassengerDataResponse instance) =>
    <String, dynamic>{
      'userId': instance.id,
      'name': instance.name,
      'email': instance.email,
      'city': instance.city,
      'gender': instance.gender,
      'isDriver': instance.isDriver,
      'profileImg': instance.profileImg,
      'totalRating': instance.totalRating,
      'totalReviewsGiven': instance.totalReviewsGiven,
      'fatherName': instance.fatherName,
      'liscenseExpiryDate': instance.liscenseExpiryDate,
      'phone': instance.phone,
      'vehicleType': instance.vehicleType,
    };

CampaignsResponse _$CampaignsResponseFromJson(Map<String, dynamic> json) =>
    CampaignsResponse(
      (json['campaigns'] as List<dynamic>?)
          ?.map((e) => CampaignsData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..message = json['message'] as String?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$CampaignsResponseToJson(CampaignsResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'campaigns': instance.data,
    };

CampaignsData _$CampaignsDataFromJson(Map<String, dynamic> json) =>
    CampaignsData(
      json['_id'] as String?,
      json['driverId'] as String?,
      json['startLocation'] as String?,
      json['endingLocation'] as String?,
      json['date'] as String?,
      json['time'] as String?,
      json['rideRules'] == null
          ? null
          : RideRulesResponse.fromJson(
              json['rideRules'] as Map<String, dynamic>),
      json['comment'] as String?,
      json['seatCost'] as String?,
      json['expectedRideDistance'] as String?,
      json['expectedRideTime'] as String?,
      json['availableSeats'] as int?,
      json['bookedSeats'] as int?,
      json['vehicleType'] as String?,
      json['vehicleBrand'] as String?,
      json['vehicleNumber'] as String?,
      json['vehicleImage'] as String?,
      json['totalRating'] as int?,
      json['totalReviewsGiven'] as int?,
      json['name'] as String?,
      json['profileImg'] as String?,
      json['status'] as int?,
      json['isNowRide'] as bool?,
    );

Map<String, dynamic> _$CampaignsDataToJson(CampaignsData instance) =>
    <String, dynamic>{
      '_id': instance.campaignId,
      'driverId': instance.driverId,
      'startLocation': instance.startLocation,
      'endingLocation': instance.endingLocation,
      'date': instance.date,
      'time': instance.time,
      'rideRules': instance.rideRules,
      'comment': instance.comment,
      'seatCost': instance.seatCost,
      'expectedRideDistance': instance.expectedRideDistance,
      'expectedRideTime': instance.expectedRideTime,
      'availableSeats': instance.availableSeats,
      'bookedSeats': instance.bookedSeats,
      'vehicleType': instance.vehicleType,
      'vehicleBrand': instance.vehicleBrand,
      'vehicleNumber': instance.vehicleNumber,
      'vehicleImage': instance.vehicleImage,
      'totalRating': instance.totalRating,
      'totalReviewsGiven': instance.totalReviewsGiven,
      'name': instance.name,
      'profileImg': instance.profileImg,
      'status': instance.status,
      'isNowRide': instance.isNowRide,
    };

GetMessageResponse _$GetMessageResponseFromJson(Map<String, dynamic> json) =>
    GetMessageResponse(
      (json['result'] as List<dynamic>?)
          ?.map(
              (e) => MessageObjectResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..message = json['message'] as String?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$GetMessageResponseToJson(GetMessageResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'result': instance.data,
    };

MessageObjectResponse _$MessageObjectResponseFromJson(
        Map<String, dynamic> json) =>
    MessageObjectResponse(
      json['_id'] as String?,
      json['chatId'] as String?,
      json['content'] as String?,
      json['sender'] as String?,
    );

Map<String, dynamic> _$MessageObjectResponseToJson(
        MessageObjectResponse instance) =>
    <String, dynamic>{
      '_id': instance.messageId,
      'chatId': instance.chatRoomId,
      'content': instance.content,
      'sender': instance.senderId,
    };

CreateChatResponse _$CreateChatResponseFromJson(Map<String, dynamic> json) =>
    CreateChatResponse(
      json['chat'] == null
          ? null
          : ChatObjectResponse.fromJson(json['chat'] as Map<String, dynamic>),
    )
      ..message = json['message'] as String?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$CreateChatResponseToJson(CreateChatResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'chat': instance.chatObject,
    };

ChatObjectResponse _$ChatObjectResponseFromJson(Map<String, dynamic> json) =>
    ChatObjectResponse(
      json['chatName'] as String?,
      json['campaignId'] as String?,
      (json['users'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['name'] as String?,
      json['profileImg'] as String?,
      json['_id'] as String?,
    );

Map<String, dynamic> _$ChatObjectResponseToJson(ChatObjectResponse instance) =>
    <String, dynamic>{
      'chatName': instance.chatName,
      'campaignId': instance.campaignId,
      'users': instance.users,
      'name': instance.name,
      'profileImg': instance.profileImg,
      '_id': instance.chatRoomId,
    };

SendMessageResponse _$SendMessageResponseFromJson(Map<String, dynamic> json) =>
    SendMessageResponse(
      json['result'] == null
          ? null
          : SendMessageObjectResponse.fromJson(
              json['result'] as Map<String, dynamic>),
    )
      ..message = json['message'] as String?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$SendMessageResponseToJson(
        SendMessageResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'result': instance.sendMessageObject,
    };

SendMessageObjectResponse _$SendMessageObjectResponseFromJson(
        Map<String, dynamic> json) =>
    SendMessageObjectResponse(
      json['sender'] as String?,
      json['chatId'] as String?,
      json['content'] as String?,
      json['_id'] as String?,
      (json['users'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['senderName'] as String?,
      json['senderImage'] as String?,
    );

Map<String, dynamic> _$SendMessageObjectResponseToJson(
        SendMessageObjectResponse instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'chatId': instance.chatId,
      'content': instance.content,
      '_id': instance.sendMessageId,
      'users': instance.users,
      'senderName': instance.senderName,
      'senderImage': instance.senderImage,
    };

PassengerRequestRideResponse _$PassengerRequestRideResponseFromJson(
        Map<String, dynamic> json) =>
    PassengerRequestRideResponse(
      json['name'] as String?,
      json['userId'] as String?,
      json['profileImg'] as String?,
      json['status'] as int?,
      json['requiredSeats'] as int?,
      json['fareOffered'] as int?,
      json['pickupLocation'] as String?,
    );

Map<String, dynamic> _$PassengerRequestRideResponseToJson(
        PassengerRequestRideResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'userId': instance.userId,
      'profileImg': instance.profileImg,
      'status': instance.passengerRideStatus,
      'requiredSeats': instance.requiredSeats,
      'fareOffered': instance.fareOffered,
      'pickupLocation': instance.pickUpLocation,
    };

RideRulesResponse _$RideRulesResponseFromJson(Map<String, dynamic> json) =>
    RideRulesResponse(
      json['isAc'] as bool?,
      json['isSmoke'] as bool?,
      json['isMusic'] as bool?,
    );

Map<String, dynamic> _$RideRulesResponseToJson(RideRulesResponse instance) =>
    <String, dynamic>{
      'isAc': instance.isAc,
      'isSmoke': instance.isSmoke,
      'isMusic': instance.isMusic,
    };

DriverSpecificScheduleRidesResponse
    _$DriverSpecificScheduleRidesResponseFromJson(Map<String, dynamic> json) =>
        DriverSpecificScheduleRidesResponse(
          (json['campaigns'] as List<dynamic>?)
              ?.map((e) =>
                  ScheduleRideResponse.fromJson(e as Map<String, dynamic>))
              .toList(),
        )
          ..message = json['message'] as String?
          ..success = json['success'] as bool?;

Map<String, dynamic> _$DriverSpecificScheduleRidesResponseToJson(
        DriverSpecificScheduleRidesResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'campaigns': instance.data,
    };

PassengerHistoryRidesResponse _$PassengerHistoryRidesResponseFromJson(
        Map<String, dynamic> json) =>
    PassengerHistoryRidesResponse(
      (json['history'] as List<dynamic>?)
          ?.map((e) => ScheduleRideResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..message = json['message'] as String?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$PassengerHistoryRidesResponseToJson(
        PassengerHistoryRidesResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'history': instance.data,
    };

DriverPostCampaignResponse _$DriverPostCampaignResponseFromJson(
        Map<String, dynamic> json) =>
    DriverPostCampaignResponse(
      ScheduleRideResponse.fromJson(json['campaign'] as Map<String, dynamic>),
    )
      ..message = json['message'] as String?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$DriverPostCampaignResponseToJson(
        DriverPostCampaignResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'campaign': instance.data,
    };

ScheduleRideResponse _$ScheduleRideResponseFromJson(
        Map<String, dynamic> json) =>
    ScheduleRideResponse(
      json['_id'] as String?,
      json['driverId'] as String?,
      json['startLocation'] as String?,
      json['endingLocation'] as String?,
      json['date'] as String?,
      json['time'] as String?,
      json['rideRules'] == null
          ? null
          : RideRulesResponse.fromJson(
              json['rideRules'] as Map<String, dynamic>),
      json['comment'] as String?,
      json['seatCost'] as String?,
      json['expectedRideDistance'] as String?,
      json['expectedRideTime'] as String?,
      json['availableSeats'] as int?,
      json['bookedSeats'] as int?,
      json['status'] as int?,
      (json['passengers'] as List<dynamic>?)
          ?.map((e) =>
              PassengerRequestRideResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['isNowRide'] as bool?,
    );

Map<String, dynamic> _$ScheduleRideResponseToJson(
        ScheduleRideResponse instance) =>
    <String, dynamic>{
      '_id': instance.campaignId,
      'driverId': instance.driverId,
      'startLocation': instance.startLocation,
      'endingLocation': instance.endingLocation,
      'date': instance.date,
      'time': instance.time,
      'rideRules': instance.rideRules,
      'comment': instance.comment,
      'seatCost': instance.seatCost,
      'expectedRideDistance': instance.expectedRideDistance,
      'expectedRideTime': instance.expectedRideTime,
      'availableSeats': instance.availableSeats,
      'bookedSeats': instance.bookedSeats,
      'status': instance.status,
      'passengers': instance.passengerRequestRideResponse,
      'isNowRide': instance.isNowRide,
    };

PassengerRideShareRequestResponse _$PassengerRideShareRequestResponseFromJson(
        Map<String, dynamic> json) =>
    PassengerRideShareRequestResponse(
      json['passengerId'] as String?,
      json['campaignId'] as String?,
      json['requireSeats'] as int?,
      json['costPerSeat'] as int?,
      json['requestStatus'] as String?,
      json['_id'] as String?,
    )
      ..message = json['message'] as String?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$PassengerRideShareRequestResponseToJson(
        PassengerRideShareRequestResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'passengerId': instance.passengerId,
      'campaignId': instance.campaignId,
      'requireSeats': instance.requireSeats,
      'costPerSeat': instance.seatCost,
      'requestStatus': instance.requestStatus,
      '_id': instance.id,
    };

PassengerRequestsResponse _$PassengerRequestsResponseFromJson(
        Map<String, dynamic> json) =>
    PassengerRequestsResponse(
      (json['requests'] as List<dynamic>?)
          ?.map((e) =>
              PassengerRequestResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..message = json['message'] as String?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$PassengerRequestsResponseToJson(
        PassengerRequestsResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'requests': instance.data,
    };

PassengerRequestResponse _$PassengerRequestResponseFromJson(
        Map<String, dynamic> json) =>
    PassengerRequestResponse(
      json['passengerId'] as String?,
      json['campaignId'] as String?,
      json['requireSeats'] as int?,
      json['costPerSeat'] as int?,
      json['requestStatus'] as String?,
      json['_id'] as String?,
      json['name'] as String?,
      json['phone'] as String?,
      json['city'] as String?,
      json['profileImg'] as String?,
      json['pickupLocation'] as String?,
    )
      ..message = json['message'] as String?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$PassengerRequestResponseToJson(
        PassengerRequestResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'passengerId': instance.passengerId,
      'campaignId': instance.campaignId,
      'requireSeats': instance.requireSeats,
      'costPerSeat': instance.seatCost,
      'requestStatus': instance.requestStatus,
      '_id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'city': instance.city,
      'profileImg': instance.imageUrl,
      'pickupLocation': instance.pickUpLocation,
    };

PassengerAllRequestsResponseData _$PassengerAllRequestsResponseDataFromJson(
        Map<String, dynamic> json) =>
    PassengerAllRequestsResponseData(
      (json['requests'] as List<dynamic>?)
          ?.map((e) =>
              PassengerAllRequestResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..message = json['message'] as String?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$PassengerAllRequestsResponseDataToJson(
        PassengerAllRequestsResponseData instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'requests': instance.data,
    };

PassengerAllRequestResponse _$PassengerAllRequestResponseFromJson(
        Map<String, dynamic> json) =>
    PassengerAllRequestResponse(
      json['_id'] as String?,
      json['passengerId'] as String?,
      json['campaignId'] as String?,
      json['requireSeats'] as int?,
      json['costPerSeat'] as int?,
      json['requestStatus'] as String?,
      json['startLocation'] as String?,
      json['endingLocation'] as String?,
      json['expectedRideDistance'] as String?,
      json['expectedRideTime'] as String?,
      json['startDate'] as String?,
      json['startTime'] as String?,
      json['availableSeats'] as int?,
      json['bookedSeats'] as int?,
      json['driverName'] as String?,
      json['driverImage'] as String?,
      json['status'] as int?,
      json['vehicleType'] as String?,
      json['vehicleBrand'] as String?,
      json['vehicleNumber'] as String?,
      json['vehicleImage'] as String?,
      json['driverId'] as String?,
    )
      ..message = json['message'] as String?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$PassengerAllRequestResponseToJson(
        PassengerAllRequestResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      '_id': instance.id,
      'passengerId': instance.passengerId,
      'campaignId': instance.campaignId,
      'requireSeats': instance.requireSeats,
      'costPerSeat': instance.seatCost,
      'requestStatus': instance.requestStatus,
      'startLocation': instance.startLocation,
      'endingLocation': instance.endingLocation,
      'expectedRideDistance': instance.expectedRideDistance,
      'expectedRideTime': instance.expectedRideTime,
      'startDate': instance.startDate,
      'startTime': instance.startTime,
      'availableSeats': instance.availableSeats,
      'bookedSeats': instance.bookedSeats,
      'driverName': instance.driverName,
      'driverImage': instance.driverImage,
      'status': instance.status,
      'vehicleType': instance.vehicleType,
      'vehicleBrand': instance.vehicleBrand,
      'vehicleNumber': instance.vehicleNumber,
      'vehicleImage': instance.vehicleImage,
      'driverId': instance.driverId,
    };

DriverDetailsListResponse _$DriverDetailsListResponseFromJson(
        Map<String, dynamic> json) =>
    DriverDetailsListResponse(
      (json['user'] as List<dynamic>?)
          ?.map(
              (e) => DriverDetailsResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..message = json['message'] as String?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$DriverDetailsListResponseToJson(
        DriverDetailsListResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'user': instance.data,
    };

DriverDetailsResponse _$DriverDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    DriverDetailsResponse(
      json['userId'] as String?,
      json['fatherName'] as String?,
      json['birthDate'] as String?,
      json['cnic'] as String?,
      json['cnicImgFront'] as String?,
      json['cnicImgBack'] as String?,
      json['totalReviewsGiven'] as int?,
      json['totalRating'] as int?,
      json['profileStatus'] as bool?,
      json['residentialAddress'] as String?,
      json['vehicleType'] as String?,
      json['vehicleNumber'] as String?,
      json['vehicleBrand'] as String?,
      json['vehicleRegisterCertificate'] as String?,
      json['vehicleImage'] as String?,
      json['liscenseNumber'] as String?,
      json['liscenseImage'] as String?,
      json['liscenseExpiryDate'] as String?,
    )
      ..message = json['message'] as String?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$DriverDetailsResponseToJson(
        DriverDetailsResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'userId': instance.userId,
      'fatherName': instance.fatherName,
      'birthDate': instance.birthDate,
      'cnic': instance.cnic,
      'cnicImgFront': instance.cnicImgFront,
      'cnicImgBack': instance.cnicImgBack,
      'totalReviewsGiven': instance.totalReviewsGiven,
      'totalRating': instance.totalRating,
      'profileStatus': instance.profileStatus,
      'residentialAddress': instance.residentialAddress,
      'vehicleType': instance.vehicleType,
      'vehicleNumber': instance.vehicleNumber,
      'vehicleBrand': instance.vehicleBrand,
      'vehicleRegisterCertificate': instance.vehicleRegisterCertificate,
      'vehicleImage': instance.vehicleImage,
      'liscenseNumber': instance.liscenseNumber,
      'liscenseImage': instance.liscenseImage,
      'liscenseExpiryDate': instance.liscenseExpiryDate,
    };

RatingsResponse _$RatingsResponseFromJson(Map<String, dynamic> json) =>
    RatingsResponse(
      (json['rating'] as List<dynamic>?)
          ?.map((e) => RatingDataResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..message = json['message'] as String?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$RatingsResponseToJson(RatingsResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'rating': instance.data,
    };

RatingDataResponse _$RatingDataResponseFromJson(Map<String, dynamic> json) =>
    RatingDataResponse(
      json['driverId'] as String?,
      json['passengerId'] as String?,
      json['rating'] as int?,
      json['comment'] as String?,
      json['name'] as String?,
      json['profileImg'] as String?,
      json['dateTime'] as String?,
    )
      ..message = json['message'] as String?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$RatingDataResponseToJson(RatingDataResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'driverId': instance.driverId,
      'passengerId': instance.passengerId,
      'rating': instance.rating,
      'comment': instance.comment,
      'name': instance.passengerName,
      'profileImg': instance.profileImg,
      'dateTime': instance.dateTime,
    };

StartRideResponse _$StartRideResponseFromJson(Map<String, dynamic> json) =>
    StartRideResponse(
      json['_id'] as String?,
      json['driverId'] as String?,
      json['startLocation'] as String?,
      json['endingLocation'] as String?,
      json['date'] as String?,
      json['time'] as String?,
      json['rideRules'] == null
          ? null
          : RideRulesResponse.fromJson(
              json['rideRules'] as Map<String, dynamic>),
      json['comment'] as String?,
      json['seatCost'] as String?,
      json['expectedRideDistance'] as String?,
      json['expectedRideTime'] as String?,
      json['availableSeats'] as int?,
      json['bookedSeats'] as int?,
      json['status'] as int?,
      (json['passengers'] as List<dynamic>?)
          ?.map((e) =>
              StartRidePassengersResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..message = json['message'] as String?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$StartRideResponseToJson(StartRideResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      '_id': instance.campaignId,
      'driverId': instance.driverId,
      'startLocation': instance.startLocation,
      'endingLocation': instance.endingLocation,
      'date': instance.date,
      'time': instance.time,
      'rideRules': instance.rideRules,
      'comment': instance.comment,
      'seatCost': instance.seatCost,
      'expectedRideDistance': instance.expectedRideDistance,
      'expectedRideTime': instance.expectedRideTime,
      'availableSeats': instance.availableSeats,
      'bookedSeats': instance.bookedSeats,
      'status': instance.status,
      'passengers': instance.startRidePassengers,
    };

StartRidePassengersResponse _$StartRidePassengersResponseFromJson(
        Map<String, dynamic> json) =>
    StartRidePassengersResponse(
      json['id'] as String?,
      json['status'] as int?,
      json['requiredSeats'] as int?,
      json['fareOffered'] as int?,
      json['_id'] as String?,
    )
      ..message = json['message'] as String?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$StartRidePassengersResponseToJson(
        StartRidePassengersResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'id': instance.passengerId,
      'status': instance.requestStatus,
      'requiredSeats': instance.requiredSeats,
      'fareOffered': instance.costPerSeat,
      '_id': instance.passengerRequestId,
    };
