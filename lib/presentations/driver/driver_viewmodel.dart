import 'dart:async';
import 'dart:developer';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/usecases/profile_usecases/register_driver_usecase.dart';
import '../../app/di.dart';

class DriverViewModel {
  final RegisterDriverUsecase _registerDriverUsecase =
      instance<RegisterDriverUsecase>();

  Future<void> registerDriver(
      RegisterDriverRequest registerDriverRequest) async {
    (await _registerDriverUsecase.execute(registerDriverRequest))
        .fold((failure) => throw failure, (data) => log('register ${data}'));
  }
}
