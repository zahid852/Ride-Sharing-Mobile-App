import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/data/network/failure.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/presentations/home/now_ride/now_ride_view_model.dart';

import '../../resources/routes_manager.dart';
import '../../utils/utils.dart';

class CancelNowRideScreen extends StatefulWidget {
  final String campaignId;
  final NowRideViewModel nowRideViewModel;
  const CancelNowRideScreen(
      {Key? key, required this.campaignId, required this.nowRideViewModel})
      : super(key: key);

  @override
  State<CancelNowRideScreen> createState() => _CancelNowRideScreenState();
}

class _CancelNowRideScreenState extends State<CancelNowRideScreen> {
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
                                    'Cancel Ride',
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
                                  'Are you sure, you want to cancel your ride?',
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
                              TextButton(
                                onPressed: () async {
                                  try {
                                    // Navigator.of(context).pop();
                                    setState(() {
                                      performingAction = true;
                                    });
                                    Navigator.of(context).pushNamed(
                                        Routes.loadingRoute,
                                        arguments: 'Please wait');
                                    await widget.nowRideViewModel.cancelRide(
                                        CancelDriverRideRequest(
                                            widget.campaignId));
                                    // SocketImplementation.passengerRequestAccepted(
                                    //     passengerId: data.passengerId);

                                    // sendPushNotification(
                                    //   data: <String, dynamic>{
                                    //     'type': 'Rejected_request',
                                    //     'route': '2',
                                    //     'title': 'Information',
                                    //     'body':
                                    //         '${CommonData.passengerDataModal.name} has rejected your request.',
                                    //     'userImage': CommonData
                                    //         .passengerDataModal
                                    //         .profileImg,
                                    //     'userId': data.passengerId
                                    //   },
                                    // );
                                    // NotificationsService
                                    //     .sendPushNotification(
                                    //         SendNotificationRequest(
                                    //   [data.passengerId],
                                    //   'Notification',
                                    //   '${CommonData.passengerDataModal.name} has rejected your request.',
                                    //   <String, dynamic>{
                                    //     'type': 'Rejected_request',
                                    //     'route': '2',
                                    //     'title': 'Notification',
                                    //     'body':
                                    //         '${CommonData.passengerDataModal.name} has rejected your request.',
                                    //     'userImage': CommonData
                                    //         .passengerDataModal
                                    //         .profileImg,
                                    //     'userId': data.passengerId
                                    //   },
                                    // ));
                                    // setState(() {});

                                    if (context.mounted) {
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          Routes.homeRoute, (route) => false);
                                    }
                                  } on Failure catch (error) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context)
                                        .pushNamed(Routes.errorRoute,
                                            arguments: error.message)
                                        .then((value) => {
                                              setState(() {
                                                performingAction = false;
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
                                                performingAction = false;
                                              })
                                            });
                                  }
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 13),
                                      child: Text(
                                        'Cancel Ride',
                                        style: GoogleFonts.nunito(
                                            color: Colors.lightGreen,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 1,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      child: Text(
                                        'Back',
                                        style: GoogleFonts.nunito(
                                            color: Colors.grey[800],
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
