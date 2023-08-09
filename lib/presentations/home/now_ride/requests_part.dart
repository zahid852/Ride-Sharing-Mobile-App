import 'package:cached_network_image/cached_network_image.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';
import 'package:lift_app/presentations/splash/splash_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../../../data/network/failure.dart';
import '../../resources/assets_manager.dart';
import '../../resources/routes_manager.dart';
import '../../utils/notifications_service.dart';
import '../../utils/socket.dart';
import '../messages/messages_view_model.dart';
import '../schedule_rides/components/custom_location_section.dart';
import '../schedule_rides/components/full_screen_error_dialog.dart';
import '../schedule_rides/components/full_screen_loading_dialog.dart';
import 'now_ride_view_model.dart';

Widget nowRideRequests(BuildContext context, NowRideViewModel nowRideViewModel,
    void Function(bool val) onAnotherScreen) {
  final ScrollController scrollController = ScrollController();
  return SizedBox(
    height: double.infinity,
    width: double.infinity,
    child: FadingEdgeScrollView.fromScrollView(
      child: ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
          physics: const BouncingScrollPhysics(),
          itemCount: nowRideViewModel.requestsList.length,
          itemBuilder: (listCtx, index) {
            final PassengerDetailRequestResponseData data =
                nowRideViewModel.requestsList[index];
            return Column(
              children: [
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey[100]!),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                          ImageAssets.profile)
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
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.nunito(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            data.city,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.nunito(
                                                fontSize: 13,
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Text(
                                data.requestStatus == 'accepted'
                                    ? 'ACCEPTED'
                                    : 'PENDING',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    color: data.requestStatus == 'pending'
                                        ? Colors.red
                                        : Colors.lightGreen,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                                padding: EdgeInsets.only(bottom: 2, left: 1),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 2, left: 1),
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
                                      stringAddress: data.customPickUpLocation)
                                ],
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            data.customPickUpLocation.isEmpty
                                ? const SizedBox.shrink()
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          Routes.fullPageLocationRoute,
                                          arguments: data.customPickUpLocation);
                                    },
                                    child: Text(
                                      'View Full Page',
                                      softWrap: true,
                                      style: GoogleFonts.nunito(
                                          fontSize: 12,
                                          decoration: TextDecoration.underline,
                                          color: Colors.lightGreen,
                                          fontWeight: FontWeight.w500),
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
                        data.requestStatus == 'accepted'
                            ? Row(
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
                                                    color: Colors.lightGreen),
                                                borderRadius:
                                                    BorderRadius.circular(8))),
                                        onPressed: () async {
                                          try {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) {
                                                    return fullScreenLoadingDialog(
                                                        'Please wait', context);
                                                  });
                                            });
                                            await Provider.of<
                                                        MessagesViewModel>(
                                                    context,
                                                    listen: false)
                                                .createChat(CreateChatRequest(
                                                    data.campaignId,
                                                    data.passengerId));

                                            if (context.mounted) {
                                              Navigator.of(context).pop();
                                              onAnotherScreen(true);
                                              await Navigator.of(context)
                                                  .pushNamed(
                                                      Routes.messageScreenRoute,
                                                      arguments: [
                                                    data.name,
                                                    data.imageUrl,
                                                    Provider.of<MessagesViewModel>(
                                                            context,
                                                            listen: false)
                                                        .chatObjectModel
                                                  ]).then((_) =>
                                                      onAnotherScreen(false));
                                            }
                                          } on Failure catch (error) {
                                            Navigator.of(context).pop();
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) {
                                                    return FullScreenErrorDialog(
                                                      message: error.message,
                                                    );
                                                  });
                                            });
                                          } catch (error) {
                                            Navigator.of(context).pop();
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) {
                                                    return const FullScreenErrorDialog(
                                                      message:
                                                          'Something went wrong. Please try again.',
                                                    );
                                                  });
                                            });
                                          }
                                        },
                                        child: Text(
                                          'Message',
                                          softWrap: true,
                                          style: GoogleFonts.nunito(
                                              color: Colors.lightGreen,
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
                                                  // side: const BorderSide(
                                                  //     color: Colors.lightGreen),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8))),
                                          onPressed: () {
                                            onAnotherScreen(true);
                                          },
                                          child: ZegoSendCallInvitationButton(
                                            iconVisible: false,
                                            text: 'Call',
                                            textStyle: GoogleFonts.nunito(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                            isVideoCall: false,

                                            resourceID:
                                                "zegouikit_call", // For offline call notification
                                            invitees: [
                                              ZegoUIKitUser(
                                                id: data.passengerId,
                                                name: data.name,
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
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
                                                    BorderRadius.circular(8))),
                                        onPressed: () async {
                                          Navigator.of(context).pushNamed(
                                              Routes.loadingRoute,
                                              arguments: 'Please wait');
                                          try {
                                            await nowRideViewModel
                                                .declineRequestData(
                                                    DeclinePassengerRequest(data
                                                        .passengerResquestId));
                                            SocketImplementation
                                                .passengerRequestAccepted(
                                                    passengerId: data
                                                        .passengerResquestId);

                                            nowRideViewModel.requestsList[index]
                                                .requestStatus = 'decline';

                                            //notification part
                                            NotificationsService
                                                .sendPushNotification(
                                                    SendNotificationRequest(
                                                        [data.passengerId],
                                                        'Notification',
                                                        '${CommonData.passengerDataModal.name} has rejected your request.',
                                                        <String, dynamic>{
                                                          'type':
                                                              'Rejected_request',
                                                          'route': '2',
                                                          'title':
                                                              'Notification',
                                                          'body':
                                                              '${CommonData.passengerDataModal.name} has rejected your request.',
                                                          'userImage': CommonData
                                                              .passengerDataModal
                                                              .profileImg,
                                                          'userId': [
                                                            data.passengerId
                                                          ]
                                                        },
                                                        globalAppPreferences
                                                            .getFCMToken()));

                                            nowRideViewModel.getUpdatedData(
                                                nowRideViewModel.requestsList);
                                            // setState(() {});
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
                                            backgroundColor: Colors.lightGreen,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8))),
                                        onPressed: () async {
                                          Navigator.of(context).pushNamed(
                                              Routes.loadingRoute,
                                              arguments: 'Please wait');
                                          try {
                                            await nowRideViewModel
                                                .updateRequestData(
                                                    UpdatePassengerRequest(
                                                        data.campaignId,
                                                        data.passengerResquestId),
                                                    data);

                                            SocketImplementation
                                                .passengerRequestAccepted(
                                                    passengerId:
                                                        data.passengerId);
                                            nowRideViewModel.requestsList[index]
                                                .requestStatus = 'accepted';

                                            //notification part
                                            NotificationsService
                                                .sendPushNotification(
                                                    SendNotificationRequest(
                                                        [data.passengerId],
                                                        'Notification',
                                                        '${CommonData.passengerDataModal.name} has accepted your request.',
                                                        <String, dynamic>{
                                                          'type':
                                                              'Accept_request',
                                                          'route': '1',
                                                          'title':
                                                              'Notification',
                                                          'body':
                                                              '${CommonData.passengerDataModal.name} has accepted your request.',
                                                          'userImage': CommonData
                                                              .passengerDataModal
                                                              .profileImg,
                                                          'userId': [
                                                            data.passengerId
                                                          ]
                                                        },
                                                        globalAppPreferences
                                                            .getFCMToken()));

                                            if (context.mounted) {
                                              Navigator.of(context).pop();
                                            }
                                            nowRideViewModel.getUpdatedData(
                                                nowRideViewModel.requestsList);
                                            // setState(() {});
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
  );
}
