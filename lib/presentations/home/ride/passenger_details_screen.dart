import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/home/ride/ride_view_model.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../../../data/mapper/mappers.dart';
import '../../../data/network/failure.dart';
import '../../../data/request/request.dart';
import '../../resources/assets_manager.dart';
import '../../resources/routes_manager.dart';
import '../messages/messages_view_model.dart';

class PassengerDetailsPopUpScreen extends StatefulWidget {
  final String campaignId;
  final PassengerRequestRideDetails passengerRequestRideDetails;
  const PassengerDetailsPopUpScreen({
    Key? key,
    required this.campaignId,
    required this.passengerRequestRideDetails,
  }) : super(key: key);

  @override
  State<PassengerDetailsPopUpScreen> createState() =>
      _PassengerDetailsPopUpScreenState();
}

class _PassengerDetailsPopUpScreenState
    extends State<PassengerDetailsPopUpScreen> {
  bool isLoading = false;
  bool isError = false;
  bool isConnecting = false;
  String errorMessage = EMPTY;
  late int val;
  @override
  void initState() {
    val = widget.passengerRequestRideDetails.passengerRideStatus;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Stack(
          children: [
            !isError
                ? Container(
                    color: Colors.black87.withOpacity(0.8),
                    height: getHeight(context: context),
                    width: getWidth(context: context),
                    child: Center(
                      child: Container(
                        width: getWidth(context: context) * 0.8,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 14),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 41,
                                          backgroundColor: Colors.lightGreen,
                                          child: CircleAvatar(
                                            radius: 40,
                                            child: CachedNetworkImage(
                                              imageUrl: widget
                                                  .passengerRequestRideDetails
                                                  .profileImg,
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
                                        Positioned(
                                            right: 0,
                                            top: 0,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop(widget
                                                            .passengerRequestRideDetails
                                                            .passengerRideStatus ==
                                                        val
                                                    ? false
                                                    : true);
                                              },
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.black,
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    widget.passengerRequestRideDetails.name,
                                    style: GoogleFonts.nunito(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  widget.passengerRequestRideDetails
                                              .passengerRideStatus !=
                                          0
                                      ? const SizedBox.shrink()
                                      : isConnecting
                                          ? Column(
                                              children: [
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                AnimatedDefaultTextStyle(
                                                  style: GoogleFonts.nunito(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.lightGreen,
                                                  ),
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.easeInOut,
                                                  child: const Text(
                                                      'Please wait...'),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    // makePhoneCall('');
                                                  },
                                                  child: Card(
                                                    color:
                                                        Colors.lightGreen[50],
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.lightGreen[50],
                                                      radius: 18,
                                                      child:
                                                          ZegoSendCallInvitationButton(
                                                        isVideoCall: false,
                                                        buttonSize:
                                                            const Size(25, 25),
                                                        iconSize:
                                                            const Size(25, 25),
                                                        icon: ButtonIcon(
                                                            backgroundColor:
                                                                Colors.lightGreen[
                                                                    50],
                                                            icon: const Icon(
                                                              Icons.call,
                                                              color: Colors
                                                                  .lightGreen,
                                                              size: 22,
                                                            )),
                                                        resourceID:
                                                            "zegouikit_call", // For offline call notification
                                                        invitees: [
                                                          ZegoUIKitUser(
                                                            id: widget
                                                                .passengerRequestRideDetails
                                                                .userId,
                                                            name: widget
                                                                .passengerRequestRideDetails
                                                                .name,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      isConnecting = true;
                                                      isError = false;
                                                      isLoading = false;
                                                      errorMessage = EMPTY;
                                                    });
                                                    try {
                                                      await Provider.of<
                                                                  MessagesViewModel>(
                                                              context,
                                                              listen: false)
                                                          .createChat(
                                                              CreateChatRequest(
                                                                  widget
                                                                      .campaignId,
                                                                  widget
                                                                      .passengerRequestRideDetails
                                                                      .userId));

                                                      setState(() {
                                                        isConnecting = false;
                                                        isLoading = false;
                                                        isError = false;
                                                        errorMessage = EMPTY;
                                                      });
                                                      if (context.mounted) {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                Routes
                                                                    .messageScreenRoute,
                                                                arguments: [
                                                              widget
                                                                  .passengerRequestRideDetails
                                                                  .name,
                                                              widget
                                                                  .passengerRequestRideDetails
                                                                  .profileImg,
                                                              Provider.of<MessagesViewModel>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .chatObjectModel
                                                            ]);
                                                      }
                                                    } on Failure catch (error) {
                                                      setState(() {
                                                        isConnecting = false;
                                                        isError = true;
                                                        isLoading = false;
                                                        errorMessage =
                                                            error.message;
                                                      });
                                                    } catch (error) {
                                                      setState(() {
                                                        isConnecting = false;
                                                        isLoading = false;
                                                        isError = true;
                                                        errorMessage =
                                                            'Something went wrong. Please try again later';
                                                      });
                                                    }
                                                  },
                                                  child: Card(
                                                    color:
                                                        Colors.lightGreen[50],
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Icon(
                                                        Icons.message,
                                                        color:
                                                            Colors.lightGreen,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                  widget.passengerRequestRideDetails
                                          .pickUpLocation.isEmpty
                                      ? const SizedBox.shrink()
                                      : Column(
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Pick Up Location',
                                                    style: GoogleFonts.nunito(
                                                        color: Colors.grey[400],
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    widget
                                                        .passengerRequestRideDetails
                                                        .pickUpLocation,
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Cost/Seat',
                                          style: GoogleFonts.nunito(
                                              color: Colors.grey[400],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          '${widget.passengerRequestRideDetails.fareOffered}PKR',
                                          style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Booked Seats',
                                          style: GoogleFonts.nunito(
                                              color: Colors.grey[400],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          widget.passengerRequestRideDetails
                                              .requiredSeats
                                              .toString(),
                                          style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Total Bill ',
                                          style: GoogleFonts.nunito(
                                              color: Colors.lightGreen[200],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          '${widget.passengerRequestRideDetails.fareOffered * widget.passengerRequestRideDetails.requiredSeats}PKR',
                                          style: GoogleFonts.nunito(
                                              color: Colors.lightGreen,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                  widget.passengerRequestRideDetails
                                              .passengerRideStatus !=
                                          0
                                      ? const SizedBox(
                                          height: 5,
                                        )
                                      : const SizedBox(
                                          height: 20,
                                        ),
                                ],
                              ),
                            ),
                            widget.passengerRequestRideDetails
                                        .passengerRideStatus !=
                                    0
                                ? const SizedBox.shrink()
                                : SizedBox(
                                    width:
                                        getWidth(context: context) * 0.8 - 24,
                                    height: 40,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: isLoading
                                              ? Colors.lightGreen[100]
                                              : Colors.lightGreen,
                                          elevation: isLoading ? 0 : 2,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      onPressed: () async {
                                        setState(() {
                                          isLoading = true;
                                          isConnecting = false;
                                          isError = false;
                                          errorMessage = EMPTY;
                                        });
                                        try {
                                          await Provider.of<RideViewModel>(
                                                  context,
                                                  listen: false)
                                              .pickingPassenger(
                                                  PickingPassengerRequest(
                                                      widget.campaignId,
                                                      widget
                                                          .passengerRequestRideDetails
                                                          .userId));
                                          setState(() {
                                            isLoading = false;
                                            isConnecting = false;
                                            isError = false;
                                            errorMessage = EMPTY;
                                            widget.passengerRequestRideDetails
                                                .passengerRideStatus = 1;
                                          });
                                        } on Failure catch (error) {
                                          setState(() {
                                            isLoading = false;
                                            isConnecting = false;
                                            isError = true;
                                            errorMessage = error.message;
                                          });
                                        } catch (error) {
                                          setState(() {
                                            isLoading = false;
                                            isConnecting = false;
                                            isError = true;
                                            errorMessage =
                                                'Something went wrong. Please try again later';
                                          });
                                        }
                                      },
                                      child: isLoading
                                          ? CircleAvatar(
                                              radius: 10,
                                              backgroundColor:
                                                  Colors.lightGreen[100],
                                              child: CircularProgressIndicator(
                                                backgroundColor:
                                                    Colors.lightGreen[100],
                                                strokeWidth: 3,
                                              ),
                                            )
                                          : Text(
                                              'Picked ${widget.passengerRequestRideDetails.name}?',
                                              style: GoogleFonts.nunito(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: getHeight(context: context),
                    width: getWidth(context: context),
                    color: Colors.black54,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
                        width: getWidth(context: context) * 0.75,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                              errorMessage,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4))),
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text(
                                    'Ok',
                                    style: GoogleFonts.nunito(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        )),
      ),
    );
  }
}
