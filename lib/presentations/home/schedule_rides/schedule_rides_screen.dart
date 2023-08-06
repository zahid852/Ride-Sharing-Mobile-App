import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/home/schedule_rides/components/update_request_view_model.dart';
import 'package:lift_app/presentations/home/schedule_rides/schedule_rides_view_model.dart';
import 'package:lift_app/presentations/resources/assets_manager.dart';
import 'package:lift_app/presentations/resources/routes_manager.dart';
import 'package:lift_app/presentations/utils/notifications_service.dart';
import 'package:lift_app/presentations/utils/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../../data/mapper/mappers.dart';
import '../../../data/network/failure.dart';
import '../../utils/utils.dart';
import '../drawer/drawer_view_model.dart';

class ScheduleRidesScreen extends StatefulWidget {
  final void Function() menuButtonFunction;
  const ScheduleRidesScreen({Key? key, required this.menuButtonFunction})
      : super(key: key);

  @override
  State<ScheduleRidesScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleRidesScreen> {
  late Future<void> _getScheduleRides;
  bool isLoading = false;
  bool isError = false;
  String errorMessage = EMPTY;

  @override
  void initState() {
    _getScheduleRides =
        Provider.of<ScheduleRidesViewModel>(context, listen: false)
            .getScheduleRidesData(CommonData.passengerDataModal.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: getHeight(context: context) * 0.07,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: getWidth(context: context),
                    ),
                    Positioned(
                        left: 15,
                        child: IconButton(
                            onPressed: widget.menuButtonFunction,
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.lightGreen,
                              size: 28,
                            ))),
                    Padding(
                      padding: const EdgeInsets.only(left: 60, right: 40),
                      child: Text(
                        'Schedule Rides',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                            fontSize: 22,
                            color: Colors.lightGreen,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: FutureBuilder(
                      future: _getScheduleRides,
                      builder: (futureCtx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return getLoadingWidget(context);
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: getHeight(context: context) * 0.07),
                              child: Material(
                                elevation: 2,
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 20, 20, 16),
                                  width: getWidth(context: context) * 0.7,
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
                                        snapshot.error.runtimeType == Failure
                                            ? (snapshot.error as Failure)
                                                .message
                                            : 'Something went wrong. Please try again later.',
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 2),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4))),
                                            onPressed: () {
                                              setState(() {
                                                _getScheduleRides = Provider.of<
                                                            ScheduleRidesViewModel>(
                                                        context,
                                                        listen: false)
                                                    .getScheduleRidesData(
                                                        CommonData
                                                            .passengerDataModal
                                                            .id);
                                              });
                                            },
                                            child: Text(
                                              'Reload',
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
                          );
                        } else {
                          return Consumer<ScheduleRidesViewModel>(
                              builder: (consumerCtx, scheduleRideModel, _) {
                            if (scheduleRideModel.scheduleRidesList.isEmpty &&
                                !scheduleRideModel.isGotData) {
                              return getLoadingWidget(context);
                            }
                            if (scheduleRideModel.scheduleRidesList.isEmpty &&
                                scheduleRideModel.isGotData) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          getHeight(context: context) * 0.07),
                                  child: Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 20, 20, 16),
                                      width: getWidth(context: context) * 0.8,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                                            'There are no campaigns scheduled.',
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
                              );
                            } else {
                              return ListView.builder(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 5),
                                  itemCount: scheduleRideModel
                                      .scheduleRidesList.length,
                                  itemBuilder: (ctx, index) {
                                    bool dateTimeValid = false;
                                    final ScheduleRideDataModal
                                        scheduleRideDataModal =
                                        scheduleRideModel
                                            .scheduleRidesList[index];
                                    DateTime date = DateTime.parse(
                                        scheduleRideDataModal.date);
                                    DateTime nowDateTime = DateTime.now();
                                    DateTime time = DateTime.parse(
                                        scheduleRideDataModal.time);
                                    DateTime combineDateTime = DateTime(
                                        date.year,
                                        date.month,
                                        date.day,
                                        time.hour,
                                        time.minute,
                                        time.second);
                                    if (combineDateTime.isAfter(nowDateTime)) {
                                      dateTimeValid = false;
                                    } else {
                                      dateTimeValid = true;
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Card(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.lightGreen,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  12),
                                                          topRight:
                                                              Radius.circular(
                                                                  12))),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 12),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    formatDate(
                                                        scheduleRideDataModal
                                                            .date),
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    formatTime(
                                                        scheduleRideDataModal
                                                            .time),
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 15),
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    dateTimeValid &&
                                                            scheduleRideDataModal
                                                                    .bookedSeats >
                                                                0
                                                        ? Column(
                                                            children: [
                                                              Text(
                                                                "Please start your trip. After 15 minutes of your scheduled ride time, you ride will be canceled.",
                                                                style: GoogleFonts.nunito(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    Text(
                                                      'TRIP',
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 15,
                                                          color:
                                                              Colors.lightGreen,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 2.5),
                                                            child: Image.asset(
                                                              ImageAssets
                                                                  .startingLocationIcon,
                                                              height: 25,
                                                              width: 25,
                                                              color: Colors
                                                                  .lightGreen,
                                                              fit: BoxFit.cover,
                                                            )),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            scheduleRideDataModal
                                                                .startingLocation,
                                                            softWrap: true,
                                                            style: GoogleFonts
                                                                .nunito(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 2.5),
                                                            child: Image.asset(
                                                              ImageAssets
                                                                  .destinationLocationIcon,
                                                              height: 25,
                                                              width: 25,
                                                              color: Colors
                                                                  .lightGreen,
                                                              fit: BoxFit.cover,
                                                            )),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            scheduleRideDataModal
                                                                .endingLocation,
                                                            softWrap: true,
                                                            style: GoogleFonts
                                                                .nunito(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 2,
                                                                    left: 1),
                                                            child: Icon(
                                                              CommonData.passengerDataModal
                                                                          .vehicleType ==
                                                                      'Car'
                                                                  ? MdiIcons.car
                                                                  : MdiIcons
                                                                      .motorbike,
                                                              size: 24,
                                                            )),
                                                        const SizedBox(
                                                          width: 13,
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Distance',
                                                                softWrap: true,
                                                                style: GoogleFonts.nunito(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Text(
                                                                scheduleRideDataModal
                                                                    .expectedRideDistance,
                                                                softWrap: true,
                                                                style: GoogleFonts.nunito(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 2,
                                                                    left: 1),
                                                            child: Icon(
                                                              MdiIcons.clock,
                                                              size: 24,
                                                            )),
                                                        const SizedBox(
                                                          width: 13,
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Duration',
                                                                softWrap: true,
                                                                style: GoogleFonts.nunito(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Text(
                                                                scheduleRideDataModal
                                                                    .expectedRideTime,
                                                                softWrap: true,
                                                                style: GoogleFonts.nunito(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 2,
                                                                    left: 1),
                                                            child: Icon(
                                                              MdiIcons
                                                                  .seatPassenger,
                                                              size: 24,
                                                            )),
                                                        const SizedBox(
                                                          width: 13,
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Booked/Total Seats',
                                                                softWrap: true,
                                                                style: GoogleFonts.nunito(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Text(
                                                                '${scheduleRideDataModal.bookedSeats}/${scheduleRideDataModal.availableSeats}',
                                                                softWrap: true,
                                                                style: GoogleFonts.nunito(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 2,
                                                                    left: 1),
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
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Seat/Cost',
                                                                softWrap: true,
                                                                style: GoogleFonts.nunito(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Text(
                                                                scheduleRideDataModal
                                                                    .seatCost,
                                                                softWrap: true,
                                                                style: GoogleFonts.nunito(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    scheduleRideDataModal
                                                            .comment.isEmpty
                                                        ? const SizedBox
                                                            .shrink()
                                                        : Column(
                                                            children: [
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              2,
                                                                          top:
                                                                              2),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .comment,
                                                                        size:
                                                                            24,
                                                                      )),
                                                                  const SizedBox(
                                                                    width: 13,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      scheduleRideDataModal
                                                                          .comment,
                                                                      softWrap:
                                                                          true,
                                                                      style: GoogleFonts.nunito(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
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
                                                            child:
                                                                ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  elevation: 0,
                                                                  shape: RoundedRectangleBorder(
                                                                      side: const BorderSide(
                                                                          color: Colors
                                                                              .lightGreen),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8))),
                                                              onPressed:
                                                                  () async {
                                                                await Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                        Routes
                                                                            .campaignRequestRoute,
                                                                        arguments:
                                                                            scheduleRideDataModal.campaignId);
                                                                setState(() {
                                                                  _getScheduleRides = Provider.of<
                                                                              ScheduleRidesViewModel>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .getScheduleRidesData(CommonData
                                                                          .passengerDataModal
                                                                          .id);
                                                                });
                                                              },
                                                              child: Text(
                                                                'Requests',
                                                                softWrap: true,
                                                                style: GoogleFonts.nunito(
                                                                    color: Colors
                                                                        .lightGreen,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
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
                                                            child:
                                                                ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  elevation: 0,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  shape: RoundedRectangleBorder(
                                                                      side: const BorderSide(
                                                                          color: Colors
                                                                              .red),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8))),
                                                              onPressed:
                                                                  () async {
                                                                setState(() {
                                                                  isLoading =
                                                                      true;
                                                                  isError =
                                                                      false;
                                                                  errorMessage =
                                                                      EMPTY;
                                                                });
                                                                try {
                                                                  await Provider.of<
                                                                              ScheduleRidesViewModel>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .cancelRide(
                                                                          CancelDriverRideRequest(
                                                                              scheduleRideDataModal.campaignId));

                                                                  setState(() {
                                                                    isLoading =
                                                                        false;
                                                                    isError =
                                                                        false;
                                                                    errorMessage =
                                                                        EMPTY;
                                                                  });
                                                                } on Failure catch (error) {
                                                                  setState(() {
                                                                    isLoading =
                                                                        false;
                                                                    isError =
                                                                        true;
                                                                    errorMessage =
                                                                        error
                                                                            .message;
                                                                  });
                                                                } catch (error) {
                                                                  setState(() {
                                                                    isLoading =
                                                                        false;
                                                                    isError =
                                                                        true;
                                                                    errorMessage =
                                                                        'Something went wrong. Please try again later';
                                                                  });
                                                                }
                                                              },
                                                              child: Text(
                                                                'Cancel',
                                                                softWrap: true,
                                                                style: GoogleFonts.nunito(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(height: 15),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black38,
                                                              offset: Offset(
                                                                  0, 1.5),
                                                              blurRadius: 0.4,
                                                              spreadRadius:
                                                                  0.2),
                                                        ],
                                                      ),
                                                      height: 40,
                                                      width: double.infinity,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            elevation: 0,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8))),
                                                        onPressed: dateTimeValid ==
                                                                    false ||
                                                                scheduleRideDataModal
                                                                        .bookedSeats ==
                                                                    0
                                                            ? null
                                                            : () async {
                                                                setState(() {
                                                                  isLoading =
                                                                      true;
                                                                  isError =
                                                                      false;
                                                                  errorMessage =
                                                                      EMPTY;
                                                                });
                                                                try {
                                                                  await Provider.of<
                                                                              ScheduleRidesViewModel>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .startRide(
                                                                          RideStatusRequest(
                                                                              scheduleRideDataModal.campaignId));

                                                                  // SocketImplementation.startRideEmit(
                                                                  //     passsengersList:
                                                                  //         scheduleRideModel
                                                                  //             .scheduleRidesList[
                                                                  //                 index]
                                                                  //             .passengerRequestRide);

                                                                  //notificaiton part

                                                                  NotificationsService
                                                                      .sendPushNotification(
                                                                          SendNotificationRequest(
                                                                    UpdatePassengerRequestViewModel
                                                                        .userList,
                                                                    'Notification',
                                                                    '${CommonData.passengerDataModal.name} has started ride.',
                                                                    <String,
                                                                        dynamic>{
                                                                      'type':
                                                                          'Start_ride',
                                                                      'route':
                                                                          '1',
                                                                      'title':
                                                                          'Notification',
                                                                      'body':
                                                                          '${CommonData.passengerDataModal.name} has started ride.',
                                                                      'userImage': CommonData
                                                                          .passengerDataModal
                                                                          .profileImg,
                                                                      'userId':
                                                                          UpdatePassengerRequestViewModel
                                                                              .userList
                                                                    },
                                                                  ));
                                                                  if (context
                                                                      .mounted) {
                                                                    Navigator.of(context).pushNamed(
                                                                        Routes
                                                                            .rideRoute,
                                                                        arguments:
                                                                            scheduleRideDataModal);
                                                                  }
                                                                } on Failure catch (error) {
                                                                  setState(() {
                                                                    isLoading =
                                                                        false;
                                                                    isError =
                                                                        true;
                                                                    errorMessage =
                                                                        error
                                                                            .message;
                                                                  });
                                                                } catch (error) {
                                                                  setState(() {
                                                                    isLoading =
                                                                        false;
                                                                    isError =
                                                                        true;
                                                                    errorMessage =
                                                                        'Something went wrong. Please try again later';
                                                                  });
                                                                }
                                                              },
                                                        child: Text(
                                                          'Start Ride',
                                                          softWrap: true,
                                                          style: GoogleFonts
                                                              .nunito(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }
                          });
                        }
                      }))
            ],
          ),
          !isError
              ? const SizedBox.shrink()
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
                                  setState(() {
                                    isError = false;
                                    errorMessage = EMPTY;
                                  });
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
          !isLoading
              ? const SizedBox.shrink()
              : Container(
                  height: getHeight(context: context),
                  width: getWidth(context: context),
                  color: Colors.black54,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: Lottie.asset(
                              LottieAssets.loading,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Please wait',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
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
