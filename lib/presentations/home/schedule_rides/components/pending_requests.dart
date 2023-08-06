import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/home/schedule_rides/components/decline_request_view_model.dart';
import 'package:lift_app/presentations/home/schedule_rides/components/requests_view_model.dart';
import 'package:lift_app/presentations/home/schedule_rides/components/update_request_view_model.dart';
import 'package:lift_app/presentations/utils/notifications_service.dart';
import 'package:lift_app/presentations/utils/socket.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../data/network/failure.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/routes_manager.dart';
import '../../../utils/utils.dart';
import '../../drawer/drawer_view_model.dart';
import 'custom_location_section.dart';

class PendingRequests extends StatefulWidget {
  final List<PassengerDetailRequestResponseData> passengerRequests;

  const PendingRequests({Key? key, required this.passengerRequests})
      : super(key: key);

  @override
  State<PendingRequests> createState() => _PendingRequestsState();
}

class _PendingRequestsState extends State<PendingRequests> {
  @override
  Widget build(BuildContext context) {
    final UpdatePassengerRequestViewModel updatePassengerRequestViewModel =
        UpdatePassengerRequestViewModel();
    final DeclinePassengerRequestViewModel declinePassengerRequestViewModel =
        DeclinePassengerRequestViewModel();
    final PassengerRequestsViewModel passengerRequestsViewModel =
        PassengerRequestsViewModel();
    List<PassengerDetailRequestResponseData> requests =
        widget.passengerRequests.where((request) {
      return request.requestStatus == 'pending' ? true : false;
    }).toList();
    return requests.isEmpty
        ? Padding(
            padding:
                EdgeInsets.only(bottom: getHeight(context: context) * 0.07),
            child: Center(
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  width: getWidth(context: context) * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: Lottie.asset(
                          LottieAssets.empty,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        'There are no pending requests.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Column(
            children: [
              // const SizedBox(
              //   height: 10,
              // ),
              // LinearProgressIndicator(
              //   minHeight: 5,
              //   color: Colors.blue,
              //   backgroundColor: Colors.lightBlue[200],
              // ),
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                    itemCount: requests.length,
                    itemBuilder: (listCtx, index) {
                      final PassengerDetailRequestResponseData data =
                          requests[index];
                      return Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 26.5,
                                            backgroundColor: Colors.lightGreen,
                                            child: CircleAvatar(
                                              radius: 26,
                                              child: CachedNetworkImage(
                                                imageUrl: data.imageUrl,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                errorWidget: (_, url, error) =>
                                                    Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: Image.asset(
                                                                ImageAssets
                                                                    .profile)
                                                            .image,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.name,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.nunito(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              Text(
                                                data.city,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.nunito(
                                                    fontSize: 13,
                                                    color: Colors.grey[700],
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 2, left: 1),
                                          child: Icon(
                                            Icons.money,
                                            size: 24,
                                          )),
                                      const SizedBox(
                                        width: 13,
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Charges Offer',
                                              softWrap: true,
                                              style: GoogleFonts.nunito(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${data.costPerSeat}PKR',
                                              softWrap: true,
                                              style: GoogleFonts.nunito(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 2, left: 1),
                                          child: Icon(
                                            MdiIcons.seatPassenger,
                                            size: 24,
                                          )),
                                      const SizedBox(
                                        width: 13,
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Requested Seats',
                                              softWrap: true,
                                              style: GoogleFonts.nunito(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              data.requireSeats.toString(),
                                              softWrap: true,
                                              style: GoogleFonts.nunito(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  data.customPickUpLocation.isNotEmpty
                                      ? Column(
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            CustomMapSection(
                                                stringAddress:
                                                    data.customPickUpLocation)
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      data.customPickUpLocation.isEmpty
                                          ? const SizedBox.shrink()
                                          : GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    Routes
                                                        .fullPageLocationRoute,
                                                    arguments: data
                                                        .customPickUpLocation);
                                              },
                                              child: Text(
                                                'View Full Page',
                                                softWrap: true,
                                                style: GoogleFonts.nunito(
                                                    fontSize: 12,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.lightGreen,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                      Row(
                                        children: [
                                          Text(
                                            'Total bill',
                                            softWrap: true,
                                            style: GoogleFonts.nunito(
                                                fontSize: 15,
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '${data.requireSeats * data.costPerSeat}PKR',
                                            softWrap: true,
                                            style: GoogleFonts.nunito(
                                                color: Colors.lightGreen,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: 40,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    side: const BorderSide(
                                                        color: Colors.red),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8))),
                                            onPressed: () async {
                                              Navigator.of(context).pushNamed(
                                                  Routes.loadingRoute,
                                                  arguments: 'Please wait');
                                              try {
                                                await declinePassengerRequestViewModel
                                                    .declineRequestData(
                                                        DeclinePassengerRequest(
                                                            data.passengerResquestId));
                                                SocketImplementation
                                                    .passengerRequestAccepted(
                                                        passengerId:
                                                            data.passengerId);

                                                requests[index].requestStatus =
                                                    'decline';
                                                //notification part
                                                NotificationsService
                                                    .sendPushNotification(
                                                        SendNotificationRequest(
                                                  [data.passengerId],
                                                  'Notification',
                                                  '${CommonData.passengerDataModal.name} has rejected your request.',
                                                  <String, dynamic>{
                                                    'type': 'Rejected_request',
                                                    'route': '2',
                                                    'title': 'Notification',
                                                    'body':
                                                        '${CommonData.passengerDataModal.name} has rejected your request.',
                                                    'userImage': CommonData
                                                        .passengerDataModal
                                                        .profileImg,
                                                    'userId': [data.passengerId]
                                                  },
                                                ));

                                                passengerRequestsViewModel
                                                    .getUpdatedData(requests);
                                                setState(() {});
                                                if (context.mounted) {
                                                  Navigator.of(context).pop();
                                                }
                                              } on Failure catch (error) {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pushNamed(
                                                    Routes.errorRoute,
                                                    arguments: error.message);
                                              } catch (error) {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pushNamed(
                                                    Routes.errorRoute,
                                                    arguments:
                                                        'Something went wrong. Please try again.');
                                              }
                                            },
                                            child: Text(
                                              'Decline',
                                              softWrap: true,
                                              style: GoogleFonts.nunito(
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 40,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 1,
                                                backgroundColor:
                                                    Colors.lightGreen,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8))),
                                            onPressed: () async {
                                              Navigator.of(context).pushNamed(
                                                  Routes.loadingRoute,
                                                  arguments: 'Please wait');
                                              try {
                                                await updatePassengerRequestViewModel
                                                    .updateRequestData(
                                                        UpdatePassengerRequest(
                                                            data.campaignId,
                                                            data.passengerResquestId),
                                                        data);

                                                SocketImplementation
                                                    .passengerRequestAccepted(
                                                        passengerId:
                                                            data.passengerId);
                                                requests[index].requestStatus =
                                                    'accepted';
                                                //notification part
                                                NotificationsService
                                                    .sendPushNotification(
                                                        SendNotificationRequest(
                                                  [data.passengerId],
                                                  'Notification',
                                                  '${CommonData.passengerDataModal.name} has accepted your request.',
                                                  <String, dynamic>{
                                                    'type': 'Accept_request',
                                                    'route': '1',
                                                    'title': 'Notification',
                                                    'body':
                                                        '${CommonData.passengerDataModal.name} has accepted your request.',
                                                    'userImage': CommonData
                                                        .passengerDataModal
                                                        .profileImg,
                                                    'userId': [data.passengerId]
                                                  },
                                                ));

                                                if (context.mounted) {
                                                  Navigator.of(context).pop();
                                                }
                                                passengerRequestsViewModel
                                                    .getUpdatedData(requests);
                                                setState(() {});
                                              } on Failure catch (error) {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pushNamed(
                                                    Routes.errorRoute,
                                                    arguments: error.message);
                                              } catch (error) {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pushNamed(
                                                    Routes.errorRoute,
                                                    arguments:
                                                        'Something went wrong. Please try again.');
                                              }
                                            },
                                            child: Text(
                                              'Accept',
                                              softWrap: true,
                                              style: GoogleFonts.nunito(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 2.5,
                          ),
                        ],
                      );
                    }),
              ),
            ],
          );
  }
}
