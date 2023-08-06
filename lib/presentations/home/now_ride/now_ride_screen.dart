import 'dart:convert';
import 'dart:developer';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/data/network/failure.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';
import 'package:lift_app/presentations/home/now_ride/now_ride_view_model.dart';
import 'package:lift_app/presentations/home/now_ride/requests_part.dart';
import 'package:lift_app/presentations/resources/routes_manager.dart';
import 'package:lift_app/presentations/utils/socket.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../resources/assets_manager.dart';
import '../../utils/notifications_service.dart';
import '../../utils/utils.dart';

class NowRideScreen extends StatefulWidget {
  final ScheduleRideDataModal data;
  const NowRideScreen({super.key, required this.data});

  @override
  State<NowRideScreen> createState() => _NowRideScreenState();
}

class _NowRideScreenState extends State<NowRideScreen>
    with SingleTickerProviderStateMixin {
  late CustomTimerController customTimerController = CustomTimerController(
    vsync: this,
    begin: const Duration(minutes: 20, seconds: 0),
    end: const Duration(seconds: 0),
  );

  late Future<void> _getRequests;
  bool cancelRide = false;
  bool isBackPressed = false;
  bool isStartRidePressed = false;
  bool isOnAnotherScreen = false;
  late NowRideViewModel nowRideViewModel;

  void listenPassengerRequest() {
    SocketImplementation.socket.on('request received', (data) {
      _getRequests = nowRideViewModel
          .getRequestsData(PassengerRequestsGetRequest(data['campaignId']));
    });
  }

  @override
  void initState() {
    listenPassengerRequest();
    nowRideViewModel = Provider.of<NowRideViewModel>(context, listen: false);
    nowRideViewModel.requestsList = [];
    nowRideViewModel.dataToSend = widget.data;
    _getRequests = nowRideViewModel
        .getRequestsData(PassengerRequestsGetRequest(widget.data.campaignId));

    Future.delayed(const Duration(seconds: 2), () {
      customTimerController.start();
    });
    super.initState();
  }

  @override
  void dispose() {
    customTimerController.dispose();

    super.dispose();
  }

  void isOnAnotherScreenfn(bool val) {
    setState(() {
      isOnAnotherScreen = val;
    });
  }

  Widget waitingPart(BuildContext ctx) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(
                top: getHeight(context: context) * 0.16,
                bottom: getHeight(context: context) * 0.04),
            child: ColorFiltered(
              colorFilter:
                  const ColorFilter.mode(Colors.lightGreen, BlendMode.srcATop),
              child: Lottie.asset(
                height: getHeight(context: context) * 0.5,
                width: getWidth(context: context) * 0.8,
                LottieAssets.waiting,
              ),
            ),
          ),
          Positioned(
            top: getHeight(context: context) * 0.05,
            child: Container(
              width: getWidth(context: context) * 0.62,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.lightGreen[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Time Remaining',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTimer(
                    controller: customTimerController,
                    builder: (CustomTimerState state,
                        CustomTimerRemainingTime remaining) {
                      if (state == CustomTimerState.finished) {
                        timeOver(ctx);
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${remaining.minutes} : ${remaining.seconds}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 32,
                                color: Colors.black87,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void timeOver(BuildContext ctx) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cancelRide = true;
      log('cancel ride $cancelRide');
      if (!isBackPressed && !isStartRidePressed && !isOnAnotherScreen) {
        Navigator.of(ctx).pushNamed(Routes.scheduleLaterRideRoute,
            arguments: [widget.data, nowRideViewModel]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          Container(
            height: getHeight(context: context) * 0.08,
            color: Colors.white,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: getWidth(context: context),
                ),
                Positioned(
                    left: 12,
                    child: IconButton(
                        // alignment: Alignment.topCenter,
                        onPressed: () {
                          isBackPressed = true;
                          Navigator.of(context)
                              .pushNamed(Routes.cancelRideRoute, arguments: [
                            widget.data.campaignId,
                            nowRideViewModel,
                          ]).then((value) {
                            if (cancelRide) {
                              Navigator.of(context).pushNamed(
                                  Routes.scheduleLaterRideRoute,
                                  arguments: [widget.data, nowRideViewModel]);
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.lightGreen,
                          size: 24,
                        ))),
                Padding(
                  padding: const EdgeInsets.only(left: 60, right: 40),
                  child: Text(
                    'Ride Requests',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                        fontSize: 24,
                        color: Colors.lightGreen,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getRequests,
                builder: (futureCtx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      nowRideViewModel.requestsList.isEmpty) {
                    return waitingPart(context);
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: getHeight(context: context) * 0.07),
                        child: Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                            width: getWidth(context: context) * 0.7,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Lottie.asset(
                                    LottieAssets.failure,
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  snapshot.error.runtimeType == Failure
                                      ? (snapshot.error as Failure).message
                                      : 'Something went wrong. Please try again later.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Consumer<NowRideViewModel>(
                        builder: (consumerCtx, viewModel, _) {
                      return viewModel.requestsList.isEmpty
                          ? waitingPart(context)
                          : Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(35, 10, 35, 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Transform.scale(
                                        scale: 2,
                                        child: LottieBuilder.asset(
                                          LottieAssets.timer,
                                          height: 25,
                                          width: 25,
                                        ),
                                      ),
                                      CustomTimer(
                                        controller: customTimerController,
                                        builder: (CustomTimerState state,
                                            CustomTimerRemainingTime
                                                remaining) {
                                          if (state ==
                                              CustomTimerState.finished) {
                                            timeOver(context);
                                          }
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${remaining.minutes} : ${remaining.seconds}",
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                    child: nowRideRequests(context, viewModel,
                                        isOnAnotherScreenfn)),
                                const SizedBox(
                                  height: 20,
                                ),
                                cancelRide
                                    ? const SizedBox.shrink()
                                    : const CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.transparent,
                                        child: CircularProgressIndicator(),
                                      ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            );
                    });
                  }
                }),
          ),
          Consumer<NowRideViewModel>(builder: (consumerCtx, viewModel, _) {
            return Container(
              margin: EdgeInsets.only(
                  bottom: viewModel.requestsList.isNotEmpty ? 10 : 15, top: 10),
              width: getWidth(context: context) * 0.9,
              height: viewModel.requestsList.isNotEmpty ? 50 : 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0, 1.5),
                      blurRadius: 0.4,
                      spreadRadius: 0.2),
                ],
              ),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: viewModel.requestsList
                          .where(
                              (element) => element.requestStatus == 'accepted')
                          .isEmpty
                      ? null
                      : () async {
                          try {
                            isStartRidePressed = true;
                            Navigator.of(context).pushNamed(Routes.loadingRoute,
                                arguments: 'Please wait');
                            await nowRideViewModel.startRide(
                                RideStatusRequest(widget.data.campaignId));

                            NotificationsService.sendPushNotification(
                                SendNotificationRequest(
                              nowRideViewModel.usersList,
                              'Notification',
                              '${CommonData.passengerDataModal.name} has started ride.',
                              <String, dynamic>{
                                'type': 'Start_ride',
                                'route': '1',
                                'title': 'Notification',
                                'body':
                                    '${CommonData.passengerDataModal.name} has started ride.',
                                'userImage':
                                    CommonData.passengerDataModal.profileImg,
                                'userId': nowRideViewModel.usersList
                              },
                            ));

                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, Routes.rideRoute, (route) => false,
                                  arguments: nowRideViewModel.dataToSend);
                            }
                          } on Failure catch (error) {
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .pushNamed(Routes.errorRoute,
                                    arguments: error.message)
                                .then((value) {
                              if (cancelRide) {
                                Navigator.of(context).pushNamed(
                                    Routes.scheduleLaterRideRoute,
                                    arguments: [widget.data, nowRideViewModel]);
                              }
                            });
                          } catch (error) {
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .pushNamed(Routes.errorRoute,
                                    arguments:
                                        'Something went wrong. Please try again.')
                                .then((value) {
                              if (cancelRide) {
                                Navigator.of(context).pushNamed(
                                    Routes.scheduleLaterRideRoute,
                                    arguments: [widget.data, nowRideViewModel]);
                              }
                            });
                          }
                        },
                  child: Text(
                    'Start Ride',
                    style: GoogleFonts.nunito(
                        fontSize:
                            nowRideViewModel.requestsList.isNotEmpty ? 17 : 18,
                        fontWeight: FontWeight.w700),
                  )),
            );
          }),
        ],
      )),
    );
  }
}
