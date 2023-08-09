import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/data/network/failure.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';
import 'package:lift_app/presentations/home/now_ride/now_ride_view_model.dart';
import 'package:lift_app/presentations/splash/splash_screen.dart';

import '../../resources/routes_manager.dart';
import '../../utils/notifications_service.dart';
import '../../utils/utils.dart';

class ScheduleLaterRideScreen extends StatefulWidget {
  final ScheduleRideDataModal scheduleRideDataModel;
  final NowRideViewModel nowRideViewModel;

  const ScheduleLaterRideScreen({
    Key? key,
    required this.scheduleRideDataModel,
    required this.nowRideViewModel,
  }) : super(key: key);

  @override
  State<ScheduleLaterRideScreen> createState() =>
      _ScheduleLaterRideScreenState();
}

class _ScheduleLaterRideScreenState extends State<ScheduleLaterRideScreen> {
  bool performingAction = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: performingAction
              ? const SizedBox.shrink()
              : Stack(
                  children: [
                    Container(
                      height: getHeight(context: context),
                      width: getWidth(context: context),
                      color: Colors.black54,
                      child: Center(
                        child: Container(
                          width: getWidth(context: context) * 0.8,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Colors.lightGreen,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 20, bottom: 17),
                                  child: Text(
                                    widget.nowRideViewModel.requestsList
                                            .where((element) =>
                                                element.requestStatus ==
                                                'accepted')
                                            .isEmpty
                                        ? 'Time Over'
                                        : 'Start Ride',
                                    style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 12, 20),
                                child: Text(
                                  widget.nowRideViewModel.requestsList
                                          .where((element) =>
                                              element.requestStatus ==
                                              'accepted')
                                          .isEmpty
                                      ? "Your waiting time is over. Want to schedule it later?"
                                      : 'Your waiting time is over. Want to start ride?',
                                  style: GoogleFonts.nunito(
                                      color: Colors.grey[800],
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Divider(
                                height: 1,
                              ),
                              widget.nowRideViewModel.requestsList
                                      .where((element) =>
                                          element.requestStatus == 'accepted')
                                      .isEmpty
                                  ? Column(
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              setState(() {
                                                performingAction = true;
                                              });
                                              Navigator.of(context).pushNamed(
                                                  Routes.loadingRoute,
                                                  arguments: 'Please wait');
                                              await widget.nowRideViewModel
                                                  .cancelRide(
                                                      CancelDriverRideRequest(widget
                                                          .scheduleRideDataModel
                                                          .campaignId));
                                              CommonData.scheduleRideDataModal =
                                                  widget.scheduleRideDataModel;

                                              if (context.mounted) {
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        Routes.homeRoute,
                                                        (route) => false);
                                              }
                                            } on Failure catch (error) {
                                              Navigator.of(context).pop();
                                              Navigator.of(context)
                                                  .pushNamed(Routes.errorRoute,
                                                      arguments: error.message)
                                                  .then((value) => {
                                                        setState(() {
                                                          performingAction =
                                                              false;
                                                        })
                                                      });
                                            } catch (error) {
                                              Navigator.of(context).pop();
                                              Navigator.of(context)
                                                  .pushNamed(Routes.errorRoute,
                                                      arguments:
                                                          'Something went wrong. Please try again.')
                                                  .then((value) => {
                                                        setState(() {
                                                          performingAction =
                                                              false;
                                                        })
                                                      });
                                            }
                                          },
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 13),
                                                child: Text(
                                                  'Yes',
                                                  style: GoogleFonts.nunito(
                                                      color: Colors.lightGreen,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          height: 1,
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              setState(() {
                                                performingAction = true;
                                              });
                                              Navigator.of(context).pushNamed(
                                                  Routes.loadingRoute,
                                                  arguments: 'Please wait');
                                              await widget.nowRideViewModel
                                                  .cancelRide(
                                                      CancelDriverRideRequest(widget
                                                          .scheduleRideDataModel
                                                          .campaignId));

                                              if (context.mounted) {
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        Routes.homeRoute,
                                                        (route) => false);
                                              }
                                            } on Failure catch (error) {
                                              Navigator.of(context).pop();
                                              Navigator.of(context)
                                                  .pushNamed(Routes.errorRoute,
                                                      arguments: error.message)
                                                  .then((value) => {
                                                        setState(() {
                                                          performingAction =
                                                              false;
                                                        })
                                                      });
                                            } catch (error) {
                                              Navigator.of(context).pop();
                                              Navigator.of(context)
                                                  .pushNamed(Routes.errorRoute,
                                                      arguments:
                                                          'Something went wrong. Please try again.')
                                                  .then((value) => {
                                                        setState(() {
                                                          performingAction =
                                                              false;
                                                        })
                                                      });
                                            }
                                          },
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 14),
                                                child: Text(
                                                  'No',
                                                  style: GoogleFonts.nunito(
                                                      color: Colors.grey[800],
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              setState(() {
                                                performingAction = true;
                                              });
                                              Navigator.of(context).pushNamed(
                                                  Routes.loadingRoute,
                                                  arguments: 'Please wait');
                                              await widget.nowRideViewModel
                                                  .startRide(RideStatusRequest(
                                                      widget
                                                          .scheduleRideDataModel
                                                          .campaignId));
                                              //notification part

                                              NotificationsService
                                                  .sendPushNotification(
                                                      SendNotificationRequest(
                                                          widget
                                                              .nowRideViewModel
                                                              .usersList,
                                                          'Notification',
                                                          '${CommonData.passengerDataModal.name} has started ride.',
                                                          <String, dynamic>{
                                                            'type':
                                                                'Start_ride',
                                                            'route': '1',
                                                            'title':
                                                                'Notification',
                                                            'body':
                                                                '${CommonData.passengerDataModal.name} has started ride.',
                                                            'userImage': CommonData
                                                                .passengerDataModal
                                                                .profileImg,
                                                            'userId': widget
                                                                .nowRideViewModel
                                                                .usersList
                                                          },
                                                          globalAppPreferences
                                                              .getFCMToken()));

                                              if (context.mounted) {
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        Routes.rideRoute,
                                                        (route) => false,
                                                        arguments: widget
                                                            .nowRideViewModel
                                                            .dataToSend);
                                              }
                                            } on Failure catch (error) {
                                              Navigator.of(context).pop();
                                              Navigator.of(context)
                                                  .pushNamed(Routes.errorRoute,
                                                      arguments: error.message)
                                                  .then((value) => {
                                                        setState(() {
                                                          performingAction =
                                                              false;
                                                        })
                                                      });
                                            } catch (error) {
                                              Navigator.of(context).pop();
                                              Navigator.of(context)
                                                  .pushNamed(Routes.errorRoute,
                                                      arguments:
                                                          'Something went wrong. Please try again.')
                                                  .then((value) => {
                                                        setState(() {
                                                          performingAction =
                                                              false;
                                                        })
                                                      });
                                            }
                                          },
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 13),
                                                child: Text(
                                                  'Start Ride',
                                                  style: GoogleFonts.nunito(
                                                      color: Colors.lightGreen,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          height: 1,
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              setState(() {
                                                performingAction = true;
                                              });
                                              Navigator.of(context).pushNamed(
                                                  Routes.loadingRoute,
                                                  arguments: 'Please wait');
                                              await widget.nowRideViewModel
                                                  .cancelRide(
                                                      CancelDriverRideRequest(widget
                                                          .scheduleRideDataModel
                                                          .campaignId));

                                              if (context.mounted) {
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        Routes.homeRoute,
                                                        (route) => false);
                                              }
                                            } on Failure catch (error) {
                                              Navigator.of(context).pop();
                                              Navigator.of(context)
                                                  .pushNamed(Routes.errorRoute,
                                                      arguments: error.message)
                                                  .then((value) => {
                                                        setState(() {
                                                          performingAction =
                                                              false;
                                                        })
                                                      });
                                            } catch (error) {
                                              Navigator.of(context).pop();
                                              Navigator.of(context)
                                                  .pushNamed(Routes.errorRoute,
                                                      arguments:
                                                          'Something went wrong. Please try again.')
                                                  .then((value) => {
                                                        setState(() {
                                                          performingAction =
                                                              false;
                                                        })
                                                      });
                                            }
                                          },
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 14),
                                                child: Text(
                                                  'Cancel Ride',
                                                  style: GoogleFonts.nunito(
                                                      color: Colors.grey[800],
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }
}
