// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _AppServiceClient implements AppServiceClient {
  _AppServiceClient(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://gotogether-283d17c4540b.herokuapp.com/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<DefaultResponse> getOtp(String phoneNumber) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'phone': phoneNumber};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<DefaultResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/otp',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DefaultResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<VerifyOtpResponse> verifyOtp(
    String phoneNumber,
    String otp,
    String fcmToken,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'phone': phoneNumber,
      'otp': otp,
      'fcmToken': fcmToken,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<VerifyOtpResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/otp/verify',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = VerifyOtpResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DefaultResponse> registerPassenger(
    String name,
    String email,
    String userId,
    String city,
    String gender,
    bool isDriver,
    File profileImg,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry(
      'name',
      name,
    ));
    _data.fields.add(MapEntry(
      'email',
      email,
    ));
    _data.fields.add(MapEntry(
      'userId',
      userId,
    ));
    _data.fields.add(MapEntry(
      'city',
      city,
    ));
    _data.fields.add(MapEntry(
      'gender',
      gender,
    ));
    _data.fields.add(MapEntry(
      'isDriver',
      isDriver.toString(),
    ));
    _data.files.add(MapEntry(
      'profileImg',
      MultipartFile.fromFileSync(
        profileImg.path,
        filename: profileImg.path.split(Platform.pathSeparator).last,
      ),
    ));
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<DefaultResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
            .compose(
              _dio.options,
              '/register',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DefaultResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DefaultResponse> registerDriver(
    String userId,
    String cnic,
    String fatherName,
    String birthDate,
    String residentialAddress,
    File cnicfront,
    File cnicback,
    String vehicleType,
    String vehicleBrand,
    String vehicleNumber,
    File vehicles,
    File vehicleCertificate,
    String liscenseNumber,
    String liscenseExpiryDate,
    File liscenseimage,
    int totalReviewsGiven,
    int totalRating,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry(
      'userId',
      userId,
    ));
    _data.fields.add(MapEntry(
      'cnic',
      cnic,
    ));
    _data.fields.add(MapEntry(
      'fatherName',
      fatherName,
    ));
    _data.fields.add(MapEntry(
      'birthDate',
      birthDate,
    ));
    _data.fields.add(MapEntry(
      'residentialAddress',
      residentialAddress,
    ));
    _data.files.add(MapEntry(
      'cnicfront',
      MultipartFile.fromFileSync(
        cnicfront.path,
        filename: cnicfront.path.split(Platform.pathSeparator).last,
      ),
    ));
    _data.files.add(MapEntry(
      'cnicback',
      MultipartFile.fromFileSync(
        cnicback.path,
        filename: cnicback.path.split(Platform.pathSeparator).last,
      ),
    ));
    _data.fields.add(MapEntry(
      'vehicleType',
      vehicleType,
    ));
    _data.fields.add(MapEntry(
      'vehicleBrand',
      vehicleBrand,
    ));
    _data.fields.add(MapEntry(
      'vehicleNumber',
      vehicleNumber,
    ));
    _data.files.add(MapEntry(
      'vehicles',
      MultipartFile.fromFileSync(
        vehicles.path,
        filename: vehicles.path.split(Platform.pathSeparator).last,
      ),
    ));
    _data.files.add(MapEntry(
      'vehicleCertificate',
      MultipartFile.fromFileSync(
        vehicleCertificate.path,
        filename: vehicleCertificate.path.split(Platform.pathSeparator).last,
      ),
    ));
    _data.fields.add(MapEntry(
      'liscenseNumber',
      liscenseNumber,
    ));
    _data.fields.add(MapEntry(
      'liscenseExpiryDate',
      liscenseExpiryDate,
    ));
    _data.files.add(MapEntry(
      'liscenseimage',
      MultipartFile.fromFileSync(
        liscenseimage.path,
        filename: liscenseimage.path.split(Platform.pathSeparator).last,
      ),
    ));
    _data.fields.add(MapEntry(
      'totalReviewsGiven',
      totalReviewsGiven.toString(),
    ));
    _data.fields.add(MapEntry(
      'totalRating',
      totalRating.toString(),
    ));
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<DefaultResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
            .compose(
              _dio.options,
              '/driver/register',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DefaultResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ProfileDataResponse> getPassengerData(String id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ProfileDataResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/user/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ProfileDataResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DriverPostCampaignResponse> driverPostCompaign(
    String driverId,
    String startLocation,
    String endingLocation,
    String date,
    String time,
    RideRules rideRules,
    double seatCost,
    int availableSeats,
    String comment,
    String expectedDistance,
    String expectedTime,
    bool isNowRide,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'driverId': driverId,
      'startLocation': startLocation,
      'endingLocation': endingLocation,
      'date': date,
      'time': time,
      'rideRules': rideRules,
      'seatCost': seatCost,
      'availableSeats': availableSeats,
      'comment': comment,
      'expectedRideDistance': expectedDistance,
      'expectedRideTime': expectedTime,
      'isNowRide': isNowRide,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DriverPostCampaignResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/driver/campaign',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DriverPostCampaignResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CampaignsResponse> getCompaignsData() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CampaignsResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/campaigns',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CampaignsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DriverSpecificScheduleRidesResponse> getDriverScheduleRides(
      String driverId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DriverSpecificScheduleRidesResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/driver/campaign/${driverId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DriverSpecificScheduleRidesResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PassengerRideShareRequestResponse> passengerRideShareRequest(
    String passengerId,
    String campaignId,
    int requireSeats,
    int seatCost,
    String customPickUpLocation,
    String driverId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'passengerId': passengerId,
      'campaignId': campaignId,
      'requireSeats': requireSeats,
      'costPerSeat': seatCost,
      'pickupLocation': customPickUpLocation,
      'driverId': driverId,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PassengerRideShareRequestResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/passenger/request',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = PassengerRideShareRequestResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PassengerRequestsResponse> getPassengerRequests(
      String campaignId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PassengerRequestsResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/passenger/request/${campaignId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = PassengerRequestsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DefaultResponse> updatePassengerRequests(
      UpdatePassengerRequest updateRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateRequest.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<DefaultResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/request/approve',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DefaultResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DefaultResponse> declinePassengerRequest(
      String passengerRequestId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<DefaultResponse>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/request/decline/${passengerRequestId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DefaultResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PassengerAllRequestsResponseData> getPassengerAllRequests() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PassengerAllRequestsResponseData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/passenger/request',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = PassengerAllRequestsResponseData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DefaultResponse> pickingPassenger(
      PickingPassengerRequest pickingPassengerRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(pickingPassengerRequest.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<DefaultResponse>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/passenger/pick',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DefaultResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<StartRideResponse> startRide(
      RideStatusRequest rideStatusRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(rideStatusRequest.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<StartRideResponse>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/ride/start',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = StartRideResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DefaultResponse> endRide(RideStatusRequest rideStatusRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(rideStatusRequest.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<DefaultResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/ride/end',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DefaultResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CreateChatResponse> createChat(
      CreateChatRequest createChatRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createChatRequest.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CreateChatResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/chat',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CreateChatResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SendMessageResponse> sendMessage(
      SendMessageRequest sendMessageRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(sendMessageRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SendMessageResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/message',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = SendMessageResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetMessageResponse> getAllMessages(String chatId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<GetMessageResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/message/${chatId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = GetMessageResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DefaultResponse> submittingRating(
      RatingSubmitRequest ratingSubmitRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(ratingSubmitRequest.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<DefaultResponse>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/rate/driver',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DefaultResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PassengerHistoryRidesResponse> getPassengerHistory(
      String passengerId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PassengerHistoryRidesResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/passenger/history/${passengerId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = PassengerHistoryRidesResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DefaultResponse> cancelRide(
      CancelDriverRideRequest cancelDriverRideRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(cancelDriverRideRequest.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<DefaultResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/ride/cancel',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DefaultResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DriverDetailsListResponse> getDriverDetails(String driverId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DriverDetailsListResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/driver/${driverId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DriverDetailsListResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DefaultResponse> sendNotification(
      SendNotificationRequest sendNotificationRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(sendNotificationRequest.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<DefaultResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/notification',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DefaultResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<RatingsResponse> getRatings(String driverId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<RatingsResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/rating/${driverId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = RatingsResponse.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
