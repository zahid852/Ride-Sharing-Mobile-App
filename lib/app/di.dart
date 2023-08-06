import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lift_app/app/app_preferences.dart';
import 'package:lift_app/data/data_source/local_data_source.dart';
import 'package:lift_app/data/data_source/remote_data_source.dart';
import 'package:lift_app/data/network/app_api.dart';
import 'package:lift_app/data/network/dio_factory.dart';
import 'package:lift_app/data/network/network_info.dart';
import 'package:lift_app/data/repositry/repositry_impl.dart';
import 'package:lift_app/domain/repositry/repositry.dart';
import 'package:lift_app/domain/usecases/auth_usecases/get_otp_usecase.dart';
import 'package:lift_app/domain/usecases/campaigns_usecases/campaign_usecases.dart';
import 'package:lift_app/domain/usecases/campaigns_usecases/cancel_ride_usecase.dart';
import 'package:lift_app/domain/usecases/campaigns_usecases/decline_passenger_request_usecase.dart';
import 'package:lift_app/domain/usecases/campaigns_usecases/end_campaign_usecase.dart';
import 'package:lift_app/domain/usecases/campaigns_usecases/submitting_rating_usecase.dart';
import 'package:lift_app/domain/usecases/driver_usecases/driver_post_compaign_usecase.dart';
import 'package:lift_app/domain/usecases/messages_usecases/create_chat_usecase.dart';
import 'package:lift_app/domain/usecases/messages_usecases/get_messages_usecase.dart';
import 'package:lift_app/domain/usecases/messages_usecases/send_message_usecase.dart';
import 'package:lift_app/domain/usecases/notification_usecases/send_notification_usecase.dart';
import 'package:lift_app/domain/usecases/profile_usecases/get_passenger_data_usecase.dart';
import 'package:lift_app/domain/usecases/profile_usecases/register_driver_usecase.dart';
import 'package:lift_app/domain/usecases/profile_usecases/register_passenger_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/usecases/auth_usecases/verify_otp_usecase.dart';
import '../domain/usecases/campaigns_usecases/get_driver_schedule_rides_usecase.dart';
import '../domain/usecases/campaigns_usecases/get_passenger_all_request_usecase.dart';
import '../domain/usecases/campaigns_usecases/get_passenger_requests_usecase.dart';
import '../domain/usecases/campaigns_usecases/passenger_history_usecase.dart';
import '../domain/usecases/campaigns_usecases/passenger_request_usecase.dart';
import '../domain/usecases/campaigns_usecases/picking_passenger_usecase.dart';
import '../domain/usecases/campaigns_usecases/rating_usecase.dart';
import '../domain/usecases/campaigns_usecases/start_campaign_usecase.dart';
import '../domain/usecases/campaigns_usecases/update_request_usecase.dart';
import '../domain/usecases/driver_usecases/get_driver_details_usecase.dart';

final instance = GetIt.instance;
Future<void> initAppModule() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  //shared prefs instance
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  //apps prefs instance
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));
  //network info
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));
  //dio factory
  instance.registerLazySingleton<DioFactory>(() => DioFactory());
  //app service client
  final dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));
  //remote data source
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance()));
  // local data source
  instance.registerLazySingleton<LocalDataSource>(
      () => LocalDataSource(instance()));
  //repositry
  instance.registerLazySingleton<Repositry>(
      () => RepositryImpl(instance(), instance()));
}

//getOtp usecase
initGetOtpModule() {
  if (!GetIt.I.isRegistered<GetOtpUsecase>()) {
    instance.registerFactory<GetOtpUsecase>(() => GetOtpUsecase(instance()));
  }
}

//verifyOtp usecase
initVerifyOtpModule() {
  if (!GetIt.I.isRegistered<VerifyOtpUsecase>()) {
    instance
        .registerFactory<VerifyOtpUsecase>(() => VerifyOtpUsecase(instance()));
  }
}

//registerPassenger usecase
initRegisterPassengerModule() {
  if (!GetIt.I.isRegistered<RegisterPassengerUsecase>()) {
    instance.registerLazySingleton<RegisterPassengerUsecase>(
        () => RegisterPassengerUsecase(instance()));
  }
}

//registerDriver usecase
initRegisterDriverModule() {
  if (!GetIt.I.isRegistered<RegisterDriverUsecase>()) {
    instance.registerLazySingleton<RegisterDriverUsecase>(
        () => RegisterDriverUsecase(instance()));
  }
}

//home usecase
initHomeModule() {
  if (!GetIt.I.isRegistered<GetPassengerDataUsecase>()) {
    instance.registerFactory<GetPassengerDataUsecase>(
        () => GetPassengerDataUsecase(instance()));
    instance.registerFactory<DriverPostCompaignUsecase>(
        () => DriverPostCompaignUsecase(instance()));
    instance.registerFactory<GetCampaignsDataUsecase>(
        () => GetCampaignsDataUsecase(instance()));
    instance.registerFactory<PassengerRideShareRequestUsecase>(
        () => PassengerRideShareRequestUsecase(instance()));
    instance.registerFactory<GetPassengerRequestsUsecase>(
        () => GetPassengerRequestsUsecase(instance()));
    instance.registerFactory<UpdatePassengerRequestUsecase>(
        () => UpdatePassengerRequestUsecase(instance()));
    instance.registerFactory<DeclinePassengerRequestUsecase>(
        () => DeclinePassengerRequestUsecase(instance()));
    instance.registerFactory<GetPassengerAllRequestsUsecase>(
        () => GetPassengerAllRequestsUsecase(instance()));
    instance.registerFactory<GetDriverScheduleRidesDataUsecase>(
        () => GetDriverScheduleRidesDataUsecase(instance()));
    instance.registerFactory<PickingPassengerRequestUsecase>(
        () => PickingPassengerRequestUsecase(instance()));
    instance.registerFactory<EndRideUsecase>(() => EndRideUsecase(instance()));
    instance
        .registerFactory<StartRideUsecase>(() => StartRideUsecase(instance()));
    instance.registerFactory<CreateChatUsecase>(
        () => CreateChatUsecase(instance()));
    instance.registerFactory<SendMessageUsecase>(
        () => SendMessageUsecase(instance()));
    instance.registerFactory<GetMessagesUsecase>(
        () => GetMessagesUsecase(instance()));
    instance.registerFactory<SubmittingRatingUsecase>(
        () => SubmittingRatingUsecase(instance()));
    instance.registerFactory<GetPassengerHistoryUsecase>(
        () => GetPassengerHistoryUsecase(instance()));
    instance.registerFactory<CancelRideUsecase>(
        () => CancelRideUsecase(instance()));
    instance.registerFactory<GetDriverDetailsUsecase>(
        () => GetDriverDetailsUsecase(instance()));
    instance.registerFactory<SendNotificationUsecase>(
        () => SendNotificationUsecase(instance()));
    instance.registerFactory<GetRatingsUsecase>(
        () => GetRatingsUsecase(instance()));
  }
}

resetAllModules() {
  instance.reset(dispose: false);
  initAppModule();
  initGetOtpModule();
  initVerifyOtpModule();
  initRegisterPassengerModule();
  initRegisterDriverModule();
  initHomeModule();
}
