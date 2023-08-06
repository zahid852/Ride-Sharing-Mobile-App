// ignore_for_file: constant_identifier_names

import 'package:lift_app/app/constants.dart';
import 'package:lift_app/app/extention.dart';
import 'package:lift_app/data/response/response.dart';
import 'package:lift_app/domain/model/models.dart';

const String EMPTY = "";
const int ZERO = 0;

extension DefaultResponseMapper on DefaultResponse? {
  DefaultMessageModel toDomain() {
    return DefaultMessageModel(
        this?.success ?? false, this?.message.orEmpty() ?? EMPTY);
  }
}

extension VerifyOtpResponseMapper on VerifyOtpResponse? {
  AuthModel toDomain() {
    return AuthModel(
        this?.userId.orEmpty() ?? EMPTY,
        this?.token.orEmpty() ?? EMPTY,
        this?.message.orEmpty() ?? EMPTY,
        this?.isProfileCreated.orFalse() ?? false,
        this?.isDriver.orFalse() ?? false,
        this?.isDriverProfileCreated.orFalse() ?? false);
  }
}

extension ProfileDataResponseMapper on ProfileDataResponse {
  ProfileDataModal toDomain() {
    List<PassengerDataModal> passengerDataList =
        (this.data?.map((passengerEntity) => passengerEntity.toDomain()) ??
                const Iterable.empty())
            .cast<PassengerDataModal>()
            .toList();
    ProfileDataModal data = ProfileDataModal(passengerDataList);

    return data;
  }
}

extension PassengerDataResponseMapper on PassengerDataResponse? {
  PassengerDataModal toDomain() {
    return PassengerDataModal(
      this?.id.orEmpty() ?? EMPTY,
      this?.name.orEmpty() ?? EMPTY,
      this?.email.orEmpty() ?? EMPTY,
      this?.city.orEmpty() ?? EMPTY,
      this?.gender.orEmpty() ?? EMPTY,
      this?.isDriver.orFalse() ?? false,
      "${Constants.baseUrl}Uploads/profile/${this?.profileImg.orEmpty() ?? EMPTY}",
      this?.totalRating.orZero() ?? ZERO,
      this?.totalReviewsGiven.orZero() ?? ZERO,
      this?.fatherName.orEmpty() ?? EMPTY,
      this?.liscenseExpiryDate.orEmpty() ?? EMPTY,
      this?.phone.orEmpty() ?? EMPTY,
      this?.vehicleType.orEmpty() ?? EMPTY,
    );
  }
}

extension GetMessagesResponseMapper on GetMessageResponse? {
  toDomain() {
    List<MessageObjectModel> messagesDataList =
        (this?.data?.map((messageEntity) => messageEntity.toDomain()) ??
                const Iterable.empty())
            .cast<MessageObjectModel>()
            .toList();
    GetMessagesModel data = GetMessagesModel(messagesDataList);

    return data;
  }
}

extension MessageObjectResponseMapper on MessageObjectResponse? {
  MessageObjectModel toDomain() {
    return MessageObjectModel(
      this?.messageId.orEmpty() ?? EMPTY,
      this?.senderId.orEmpty() ?? EMPTY,
      this?.chatRoomId.orEmpty() ?? EMPTY,
      this?.content.orEmpty() ?? EMPTY,
    );
  }
}

extension CampaignsResponseMapper on CampaignsResponse? {
  CampaignsModal toDomain() {
    List<CampaignsDataModal> campaignsList =
        (this?.data?.map((campaignEntity) => campaignEntity.toDomain()) ??
                const Iterable.empty())
            .cast<CampaignsDataModal>()
            .toList();
    CampaignsModal data = CampaignsModal(campaignsList);

    return data;
  }
}

extension RideRulesResponseMapper on RideRulesResponse? {
  RideRules toDomain() {
    return RideRules(this?.isAc.orFalse() ?? false,
        this?.isSmoke.orFalse() ?? false, this?.isMusic.orFalse() ?? false);
  }
}

extension PassengerRequestRideResponseMapper on PassengerRequestRideResponse? {
  PassengerRequestRideDetails toDomain() {
    return PassengerRequestRideDetails(
      this?.name.orEmpty() ?? EMPTY,
      this?.userId.orEmpty() ?? EMPTY,
      "${Constants.baseUrl}Uploads/profile/${this?.profileImg.orEmpty() ?? EMPTY}",
      this?.passengerRideStatus.orZero() ?? ZERO,
      this?.requiredSeats.orZero() ?? ZERO,
      this?.fareOffered.orZero() ?? ZERO,
      this?.pickUpLocation.orEmpty() ?? EMPTY,
    );
  }
}

extension CreateChatResponseMapper on CreateChatResponse? {
  CreateChatModel toDomain() {
    return CreateChatModel(this?.chatObject.toDomain() ??
        ChatObjectModel(EMPTY, EMPTY, [], EMPTY, EMPTY, EMPTY));
  }
}

extension ChatObjectResponseMapper on ChatObjectResponse? {
  ChatObjectModel toDomain() {
    return ChatObjectModel(
      this?.chatName.orEmpty() ?? EMPTY,
      this?.campaignId.orEmpty() ?? EMPTY,
      this?.users ?? [],
      this?.name.orEmpty() ?? EMPTY,
      "${Constants.baseUrl}Uploads/profile/${this?.profileImg.orEmpty() ?? EMPTY}",
      this?.chatRoomId.orEmpty() ?? EMPTY,
    );
  }
}

extension SendMessageResponseMapper on SendMessageResponse? {
  SendMessageModel toDomain() {
    return SendMessageModel(this?.sendMessageObject.toDomain() ??
        SendMessageObjectModel(EMPTY, EMPTY, EMPTY, EMPTY, [], EMPTY, EMPTY));
  }
}

extension SendMessageObjectResponseMapper on SendMessageObjectResponse? {
  SendMessageObjectModel toDomain() {
    return SendMessageObjectModel(
      this?.sender.orEmpty() ?? EMPTY,
      this?.chatId.orEmpty() ?? EMPTY,
      this?.content.orEmpty() ?? EMPTY,
      this?.sendMessageId.orEmpty() ?? EMPTY,
      this?.users ?? [],
      "${Constants.baseUrl}Uploads/profile/${this?.senderImage.orEmpty() ?? EMPTY}",
      this?.senderName.orEmpty() ?? EMPTY,
    );
  }
}

extension DriverPostCampaignResponseMapper on DriverPostCampaignResponse? {
  ScheduleRideDataModal toDomain() {
    return this?.data.toDomain() ??
        ScheduleRideDataModal(
            EMPTY,
            EMPTY,
            EMPTY,
            EMPTY,
            EMPTY,
            EMPTY,
            RideRules(false, false, false),
            EMPTY,
            EMPTY,
            EMPTY,
            EMPTY,
            ZERO,
            ZERO,
            ZERO,
            [],
            false);
  }
}

extension DriverSpecificScheduleRidesResponseMapper
    on DriverSpecificScheduleRidesResponse? {
  ScheduleRides toDomain() {
    List<ScheduleRideDataModal> scheduleRidesList =
        (this?.data?.map((campaignEntity) => campaignEntity.toDomain()) ??
                const Iterable.empty())
            .cast<ScheduleRideDataModal>()
            .toList();
    ScheduleRides data = ScheduleRides(scheduleRidesList);

    return data;
  }
}

extension PassengerHistoryRidesResponseMapper
    on PassengerHistoryRidesResponse? {
  ScheduleRides toDomain() {
    List<ScheduleRideDataModal> scheduleRidesList =
        (this?.data?.map((campaignEntity) => campaignEntity.toDomain()) ??
                const Iterable.empty())
            .cast<ScheduleRideDataModal>()
            .toList();
    ScheduleRides data = ScheduleRides(scheduleRidesList);

    return data;
  }
}

extension ScheduleRideResponseMapper on ScheduleRideResponse? {
  ScheduleRideDataModal toDomain() {
    return ScheduleRideDataModal(
        this?.campaignId.orEmpty() ?? EMPTY,
        this?.driverId.orEmpty() ?? EMPTY,
        this?.startLocation.orEmpty() ?? EMPTY,
        this?.endingLocation.orEmpty() ?? EMPTY,
        this?.date.orEmpty() ?? EMPTY,
        this?.time.orEmpty() ?? EMPTY,
        this?.rideRules.toDomain() ?? RideRules(false, false, false),
        this?.comment.orEmpty() ?? EMPTY,
        this?.seatCost.orEmpty() ?? EMPTY,
        this?.expectedRideDistance.orEmpty() ?? EMPTY,
        this?.expectedRideTime.orEmpty() ?? EMPTY,
        this?.availableSeats.orZero() ?? ZERO,
        this?.bookedSeats.orZero() ?? ZERO,
        this?.status.orZero() ?? ZERO,
        (this?.passengerRequestRideResponse?.map((passengerRequestEntity) =>
                    passengerRequestEntity.toDomain()) ??
                const Iterable.empty())
            .cast<PassengerRequestRideDetails>()
            .toList(),
        this?.isNowRide.orFalse() ?? false);
  }
}

extension CampaignsDataMapper on CampaignsData? {
  CampaignsDataModal toDomain() {
    return CampaignsDataModal(
        this?.campaignId.orEmpty() ?? EMPTY,
        this?.driverId.orEmpty() ?? EMPTY,
        this?.startLocation.orEmpty() ?? EMPTY,
        this?.endingLocation.orEmpty() ?? EMPTY,
        this?.date.orEmpty() ?? EMPTY,
        this?.time.orEmpty() ?? EMPTY,
        this?.rideRules.toDomain() ?? RideRules(false, false, false),
        this?.comment.orEmpty() ?? EMPTY,
        this?.seatCost.orEmpty() ?? EMPTY,
        this?.expectedRideDistance.orEmpty() ?? EMPTY,
        this?.expectedRideTime.orEmpty() ?? EMPTY,
        this?.availableSeats.orZero() ?? ZERO,
        this?.bookedSeats.orZero() ?? ZERO,
        this?.vehicleType.orEmpty() ?? EMPTY,
        this?.vehicleBrand.orEmpty() ?? EMPTY,
        this?.vehicleNumber.orEmpty() ?? EMPTY,
        "${Constants.baseUrl}Uploads/driver/vehicles/${this?.vehicleImage.orEmpty() ?? EMPTY}",
        this?.totalRating.orZero() ?? ZERO,
        this?.totalReviewsGiven.orZero() ?? ZERO,
        this?.name.orEmpty() ?? EMPTY,
        "${Constants.baseUrl}Uploads/profile/${this?.profileImg.orEmpty() ?? EMPTY}",
        this?.status.orZero() ?? ZERO,
        this?.isNowRide.orFalse() ?? false);
  }
}

extension PassengerRideShareReqResponseMapper
    on PassengerRideShareRequestResponse? {
  PassengerRequestResponseData toDomain() {
    return PassengerRequestResponseData(
      this?.passengerId.orEmpty() ?? EMPTY,
      this?.campaignId.orEmpty() ?? EMPTY,
      this?.requireSeats.orZero() ?? ZERO,
      this?.seatCost.orZero() ?? ZERO,
      this?.requestStatus.orEmpty() ?? EMPTY,
      this?.id.orEmpty() ?? EMPTY,
    );
  }
}

extension PassengerRequestResponseMapper on PassengerRequestResponse? {
  PassengerDetailRequestResponseData toDomain() {
    return PassengerDetailRequestResponseData(
      this?.passengerId.orEmpty() ?? EMPTY,
      this?.campaignId.orEmpty() ?? EMPTY,
      this?.requireSeats.orZero() ?? ZERO,
      this?.seatCost.orZero() ?? ZERO,
      this?.requestStatus.orEmpty() ?? EMPTY,
      this?.id.orEmpty() ?? EMPTY,
      this?.name.orEmpty() ?? EMPTY,
      this?.city.orEmpty() ?? EMPTY,
      this?.phone.orEmpty() ?? EMPTY,
      "${Constants.baseUrl}Uploads/profile/${this?.imageUrl.orEmpty() ?? EMPTY}",
      this?.pickUpLocation.orEmpty() ?? EMPTY,
    );
  }
}

extension PassengerRequestsResponseMapper on PassengerRequestsResponse? {
  PassengerRequests toDomain() {
    List<PassengerDetailRequestResponseData> passengerRequestsList =
        (this?.data?.map((campaignEntity) => campaignEntity.toDomain()) ??
                const Iterable.empty())
            .cast<PassengerDetailRequestResponseData>()
            .toList();
    PassengerRequests data = PassengerRequests(passengerRequestsList);

    return data;
  }
}

extension PassengerAllRequestResponseMapper on PassengerAllRequestResponse? {
  PassengerAllRequests toDomain() {
    return PassengerAllRequests(
      this?.id.orEmpty() ?? EMPTY,
      this?.passengerId.orEmpty() ?? EMPTY,
      this?.campaignId.orEmpty() ?? EMPTY,
      this?.requireSeats.orZero() ?? ZERO,
      this?.seatCost.orZero() ?? ZERO,
      this?.requestStatus.orEmpty() ?? EMPTY,
      this?.startLocation.orEmpty() ?? EMPTY,
      this?.endingLocation.orEmpty() ?? EMPTY,
      this?.expectedRideDistance.orEmpty() ?? EMPTY,
      this?.expectedRideTime.orEmpty() ?? EMPTY,
      this?.startDate.orEmpty() ?? EMPTY,
      this?.startTime.orEmpty() ?? EMPTY,
      this?.availableSeats.orZero() ?? ZERO,
      this?.bookedSeats.orZero() ?? ZERO,
      this?.driverName.orEmpty() ?? EMPTY,
      "${Constants.baseUrl}Uploads/profile/${this?.driverImage.orEmpty() ?? EMPTY}",
      this?.status.orZero() ?? ZERO,
      this?.vehicleType.orEmpty() ?? EMPTY,
      this?.vehicleBrand.orEmpty() ?? EMPTY,
      this?.vehicleNumber.orEmpty() ?? EMPTY,
      "${Constants.baseUrl}Uploads/driver/vehicles/${this?.vehicleImage.orEmpty() ?? EMPTY}",
      this?.driverId.orEmpty() ?? EMPTY,
    );
  }
}

extension PassengerAllRequestsResponseMapper
    on PassengerAllRequestsResponseData? {
  PassengerAllRequestsData toDomain() {
    List<PassengerAllRequests> passengerRequestsList =
        (this?.data?.map((campaignEntity) => campaignEntity.toDomain()) ??
                const Iterable.empty())
            .cast<PassengerAllRequests>()
            .toList();
    PassengerAllRequestsData data =
        PassengerAllRequestsData(passengerRequestsList);

    return data;
  }
}

extension DriverDetailsListResponseMapper on DriverDetailsListResponse? {
  DriverDetailsList toDomain() {
    List<DriverDetailsModel> driverDetailsList =
        (this?.data?.map((driverDetail) => driverDetail.toDomain()) ??
                const Iterable.empty())
            .cast<DriverDetailsModel>()
            .toList();
    DriverDetailsList data = DriverDetailsList(driverDetailsList);

    return data;
  }
}

extension DriverDetailsResponseMapper on DriverDetailsResponse? {
  DriverDetailsModel toDomain() {
    return DriverDetailsModel(
      this?.userId ?? EMPTY,
      this?.fatherName.orEmpty() ?? EMPTY,
      this?.birthDate.orEmpty() ?? EMPTY,
      this?.cnic.orEmpty() ?? EMPTY,
      "${Constants.baseUrl}Uploads/driver/cnic/${this?.cnicImgFront.orEmpty() ?? EMPTY}",
      "${Constants.baseUrl}Uploads/driver/cnic/${this?.cnicImgBack.orEmpty() ?? EMPTY}",
      this?.totalReviewsGiven.orZero() ?? ZERO,
      this?.totalRating.orZero() ?? ZERO,
      this?.profileStatus.orFalse() ?? false,
      this?.residentialAddress.orEmpty() ?? EMPTY,
      this?.vehicleType.orEmpty() ?? EMPTY,
      this?.vehicleNumber.orEmpty() ?? EMPTY,
      this?.vehicleBrand.orEmpty() ?? EMPTY,
      "${Constants.baseUrl}Uploads/driver/vehicles/${this?.vehicleRegisterCertificate.orEmpty() ?? EMPTY}",
      "${Constants.baseUrl}Uploads/driver/vehicles/${this?.vehicleImage.orEmpty() ?? EMPTY}",
      this?.liscenseNumber.orEmpty() ?? EMPTY,
      "${Constants.baseUrl}Uploads/driver/liscense/${this?.liscenseImage.orEmpty() ?? EMPTY}",
      this?.liscenseExpiryDate.orEmpty() ?? EMPTY,
    );
  }
}

extension RatingsResponseMapper on RatingsResponse? {
  RatingsModel toDomain() {
    List<RatingDataModel> ratingsList =
        (this?.data?.map((rating) => rating.toDomain()) ??
                const Iterable.empty())
            .cast<RatingDataModel>()
            .toList();
    RatingsModel data = RatingsModel(ratingsList);

    return data;
  }
}

extension RatingDataResponseMapper on RatingDataResponse? {
  RatingDataModel toDomain() {
    return RatingDataModel(
      this?.driverId ?? EMPTY,
      this?.passengerId.orEmpty() ?? EMPTY,
      this?.rating.orZero() ?? ZERO,
      this?.comment.orEmpty() ?? EMPTY,
      this?.passengerName.orEmpty() ?? EMPTY,
      "${Constants.baseUrl}Uploads/profile/${this?.profileImg.orEmpty() ?? EMPTY}",
      this?.dateTime.orEmpty() ?? EMPTY,
    );
  }
}

extension StartRidePassengersResponseMapper on StartRidePassengersResponse? {
  StartRidePassengersModel toDomain() {
    return StartRidePassengersModel(
      this?.passengerId.orEmpty() ?? EMPTY,
      this?.requestStatus.orZero() ?? ZERO,
      this?.requiredSeats.orZero() ?? ZERO,
      this?.costPerSeat.orZero() ?? ZERO,
      this?.passengerRequestId.orEmpty() ?? EMPTY,
    );
  }
}

extension StartRideResponseMapper on StartRideResponse? {
  StartRideModel toDomain() {
    return StartRideModel(
      this?.campaignId.orEmpty() ?? EMPTY,
      this?.driverId.orEmpty() ?? EMPTY,
      this?.startLocation.orEmpty() ?? EMPTY,
      this?.endingLocation.orEmpty() ?? EMPTY,
      this?.date.orEmpty() ?? EMPTY,
      this?.time.orEmpty() ?? EMPTY,
      this?.rideRules.toDomain() ?? RideRules(false, false, false),
      this?.comment.orEmpty() ?? EMPTY,
      this?.seatCost.orEmpty() ?? EMPTY,
      this?.expectedRideDistance.orEmpty() ?? EMPTY,
      this?.expectedRideTime.orEmpty() ?? EMPTY,
      this?.availableSeats.orZero() ?? ZERO,
      this?.bookedSeats.orZero() ?? ZERO,
      this?.status.orZero() ?? ZERO,
      (this?.startRidePassengers?.map((passengerRequestEntity) =>
                  passengerRequestEntity.toDomain()) ??
              const Iterable.empty())
          .cast<StartRidePassengersModel>()
          .toList(),
    );
  }
}
