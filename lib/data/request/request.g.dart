// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatePassengerRequest _$UpdatePassengerRequestFromJson(
        Map<String, dynamic> json) =>
    UpdatePassengerRequest(
      json['campaignId'] as String?,
      json['passengerRequestId'] as String?,
    );

Map<String, dynamic> _$UpdatePassengerRequestToJson(
        UpdatePassengerRequest instance) =>
    <String, dynamic>{
      'campaignId': instance.campaignId,
      'passengerRequestId': instance.requestId,
    };

PickingPassengerRequest _$PickingPassengerRequestFromJson(
        Map<String, dynamic> json) =>
    PickingPassengerRequest(
      json['campaignId'] as String?,
      json['passengerId'] as String?,
    );

Map<String, dynamic> _$PickingPassengerRequestToJson(
        PickingPassengerRequest instance) =>
    <String, dynamic>{
      'campaignId': instance.campaignId,
      'passengerId': instance.passengerId,
    };

RideStatusRequest _$RideStatusRequestFromJson(Map<String, dynamic> json) =>
    RideStatusRequest(
      json['campaignId'] as String?,
    );

Map<String, dynamic> _$RideStatusRequestToJson(RideStatusRequest instance) =>
    <String, dynamic>{
      'campaignId': instance.campaignId,
    };

CreateChatRequest _$CreateChatRequestFromJson(Map<String, dynamic> json) =>
    CreateChatRequest(
      json['campaignId'] as String?,
      json['userId'] as String?,
    );

Map<String, dynamic> _$CreateChatRequestToJson(CreateChatRequest instance) =>
    <String, dynamic>{
      'campaignId': instance.campaignId,
      'userId': instance.opponentUserId,
    };

SendMessageRequest _$SendMessageRequestFromJson(Map<String, dynamic> json) =>
    SendMessageRequest(
      json['chatId'] as String?,
      json['content'] as String?,
    );

Map<String, dynamic> _$SendMessageRequestToJson(SendMessageRequest instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'content': instance.content,
    };

RatingSubmitRequest _$RatingSubmitRequestFromJson(Map<String, dynamic> json) =>
    RatingSubmitRequest(
      json['driverId'] as String?,
      json['rating'] as int?,
      json['campaignId'] as String?,
      json['comment'] as String?,
      json['dateTime'] as String?,
    );

Map<String, dynamic> _$RatingSubmitRequestToJson(
        RatingSubmitRequest instance) =>
    <String, dynamic>{
      'driverId': instance.driverId,
      'rating': instance.rating,
      'campaignId': instance.campaignId,
      'comment': instance.comment,
      'dateTime': instance.dateTime,
    };

CancelDriverRideRequest _$CancelDriverRideRequestFromJson(
        Map<String, dynamic> json) =>
    CancelDriverRideRequest(
      json['campaignId'] as String?,
    );

Map<String, dynamic> _$CancelDriverRideRequestToJson(
        CancelDriverRideRequest instance) =>
    <String, dynamic>{
      'campaignId': instance.campaignId,
    };

SendNotificationRequest _$SendNotificationRequestFromJson(
        Map<String, dynamic> json) =>
    SendNotificationRequest(
      (json['receiverIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['title'] as String?,
      json['content'] as String?,
      json['data'] as Map<String, dynamic>?,
      json['token'] as String?,
    );

Map<String, dynamic> _$SendNotificationRequestToJson(
        SendNotificationRequest instance) =>
    <String, dynamic>{
      'receiverIds': instance.receiverId,
      'title': instance.title,
      'content': instance.content,
      'data': instance.data,
      'token': instance.token,
    };
