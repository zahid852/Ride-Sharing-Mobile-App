import 'dart:developer';

import 'package:lift_app/app/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../domain/model/models.dart';
import '../home/drawer/drawer_view_model.dart';

class SocketImplementation {
  static final IO.Socket socket = IO.io(Constants.baseUrl,
      IO.OptionBuilder().setTransports(['websocket']).build());
  static void connectSocket() {
    socket.onConnect((data) => log('Connect'));
    socket.onConnectError((data) => log('on connect error'));
    socket.onDisconnect((data) => log('disconnect'));
  }

  static void setUpData() {
    socket.emit('setup', {
      'userId': CommonData.passengerDataModal.id,
    });
    socket.on('connected', (_) => log('Socket connected'));
  }

  static void sendPassengerRequest(
      {required String driverId, required String campaignId}) {
    socket.emit('send passenger request',
        {'driverId': driverId, 'campaignId': campaignId});
  }

  static void passengerRequestAccepted({required String passengerId}) {
    socket.emit('action on request', {
      'passengerId': passengerId,
    });
  }

  static void sendMessageEmit({required String passengerId}) {
    socket.emit('action on request', {
      'passengerId': passengerId,
    });
  }

  static void createChatEmit({required String userId}) {
    socket.emit('join chat', userId);
  }

  static void newMessageEmit({required List<String> userList}) {
    socket.emit('new message', {'users': userList});
  }

  static void startRideEmit(
      {required List<PassengerRequestRideDetails> passsengersList}) {
    socket.emit('start ride', passsengersList);
  }

  static void endRideEmit(
      {required List<PassengerRequestRideDetails> passsengersList,
      required String driverId}) {
    socket.emit(
        'end ride', {'passengers': passsengersList, 'driverId': driverId});
  }
}
