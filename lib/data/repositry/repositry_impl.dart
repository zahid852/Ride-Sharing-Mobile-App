import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:lift_app/data/data_source/remote_data_source.dart';
import 'package:lift_app/data/mapper/mappers.dart';
import 'package:lift_app/data/network/error_handler.dart';
import 'package:lift_app/data/network/network_info.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/data/network/failure.dart';
import 'package:lift_app/domain/repositry/repositry.dart';

class RepositryImpl implements Repositry {
  final RemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  RepositryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, DefaultMessageModel>> getOtp(String phone) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response = await _remoteDataSource.getOtp(phone);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(
                  response.success ?? ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, AuthModel>> verifyOtp(
      VerifyOtpRequest verifyOtpRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response = await _remoteDataSource.verifyOtp(verifyOtpRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure

          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, DefaultMessageModel>> registerPassenger(
      RegisterPassengerRequest registerPassengerRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response =
            await _remoteDataSource.registerPassenger(registerPassengerRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        log('error ');

        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, DefaultMessageModel>> registerDriver(
      RegisterDriverRequest registerDriverRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response =
            await _remoteDataSource.registerDriver(registerDriverRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, ProfileDataModal>> getPassengerData(
      UserDetailsRequest userDetailsRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response =
            await _remoteDataSource.getPassengerData(userDetailsRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, ScheduleRideDataModal>> driverPostCompaign(
      SharedRideCompaignRequest sharedRideCompaignRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response = await _remoteDataSource
            .driverPostCompaign(sharedRideCompaignRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, CampaignsModal>> getCampaignsData() async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response = await _remoteDataSource.getCampaignsData();

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, PassengerRequestResponseData>>
      passengerRideShareRequestToDriver(
          PassengerRideShareRequest passengerRideShareRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response = await _remoteDataSource
            .passengerRideShareRequest(passengerRideShareRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, PassengerRequests>> getPassengerRequests(
      PassengerRequestsGetRequest passengerRequestsGetRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response = await _remoteDataSource
            .getPassengerRequests(passengerRequestsGetRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, DefaultMessageModel>> updatePassengerRequest(
      UpdatePassengerRequest updatePassengerRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response = await _remoteDataSource
            .updatePassengerRequests(updatePassengerRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, DefaultMessageModel>> declinePassengerRequest(
      DeclinePassengerRequest declinePassengerRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response = await _remoteDataSource
            .declinePassengerRequest(declinePassengerRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, PassengerAllRequestsData>>
      getPassengerAllRequests() async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response = await _remoteDataSource.getPassengerAllRequests();

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, ScheduleRides>> getDriverScheduleRides(
      DriverScheduleRidesRequest driverScheduleRidesRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response = await _remoteDataSource
            .getDriverScheduleRides(driverScheduleRidesRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, DefaultMessageModel>> pickingPassenger(
      PickingPassengerRequest pickingPassengerRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response =
            await _remoteDataSource.pickingPassenger(pickingPassengerRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, DefaultMessageModel>> rideEnd(
      RideStatusRequest rideStatusRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response = await _remoteDataSource.endRide(rideStatusRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, StartRideModel>> rideStart(
      RideStatusRequest rideStatusRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response = await _remoteDataSource.startRide(rideStatusRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, CreateChatModel>> createChatRoom(
      CreateChatRequest createChatRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response = await _remoteDataSource.createChat(createChatRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, GetMessagesModel>> getAllMessages(
      GetMessagesRequest getMessagesRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response =
            await _remoteDataSource.getMessages(getMessagesRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, SendMessageModel>> sendMessage(
      SendMessageRequest sendMessageRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response =
            await _remoteDataSource.sendMessage(sendMessageRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, DefaultMessageModel>> submittingRating(
      RatingSubmitRequest ratingSubmitRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response =
            await _remoteDataSource.submittingRating(ratingSubmitRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, ScheduleRides>> getPassengerHistory(
      PassengerDataRequest passengerDataRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response =
            await _remoteDataSource.getPassengerHistory(passengerDataRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, DefaultMessageModel>> cancelDriverRide(
      CancelDriverRideRequest cancelDriverRideRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response =
            await _remoteDataSource.cancelRide(cancelDriverRideRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, DriverDetailsList>> getDriverDetails(
      String driverId) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response = await _remoteDataSource.getDriverDetails(driverId);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, DefaultMessageModel>> sendNotification(
      SendNotificationRequest sendNotificationRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response =
            await _remoteDataSource.sendNotification(sendNotificationRequest);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, RatingsModel>> getRatings(String driverId) async {
    if (await _networkInfo.isConnected) {
      try {
        //connection success
        final response = await _remoteDataSource.getRatings(driverId);

        if (response.success == true) {
          //Internet Api Sucess
          return Right(response.toDomain());
        } else {
          //Internel Api Failure
          return Left(Failure(
              ApiInternalSuccessCodes.getCode(ApiInternelSuccess.FAILURE),
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //Response Error
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      //error connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
