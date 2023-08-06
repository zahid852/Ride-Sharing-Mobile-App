import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/presentations/home/history/driver/driver_history_view_model.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../data/network/failure.dart';
import '../../../../domain/model/models.dart';
import '../../../resources/assets_manager.dart';
import '../../../utils/widgets.dart';
import '../../drawer/drawer_view_model.dart';

class DriverHistoryScreen extends StatefulWidget {
  final void Function() menuButtonFunction;
  const DriverHistoryScreen({Key? key, required this.menuButtonFunction})
      : super(key: key);

  @override
  State<DriverHistoryScreen> createState() => _DriverHistoryScreenState();
}

class _DriverHistoryScreenState extends State<DriverHistoryScreen> {
  late Future<void> _getRidesHistory;

  @override
  void initState() {
    _getRidesHistory =
        Provider.of<DriverHistoryRidesViewModel>(context, listen: false)
            .getScheduleRidesData(CommonData.passengerDataModal.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            height: getHeight(context: context) * 0.07,
            color: Colors.lightGreen,
            alignment: Alignment.center,
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
                          color: Colors.white,
                          size: 28,
                        ))),
                Padding(
                  padding: const EdgeInsets.only(left: 60, right: 40),
                  child: Text(
                    'History',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: FutureBuilder(
                  future: _getRidesHistory,
                  builder: (futureCtx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                                        ? (snapshot.error as Failure).message
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 2),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4))),
                                        onPressed: () {
                                          setState(() {
                                            _getRidesHistory = Provider.of<
                                                        DriverHistoryRidesViewModel>(
                                                    context,
                                                    listen: false)
                                                .getScheduleRidesData(CommonData
                                                    .passengerDataModal.id);
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
                      return Consumer<DriverHistoryRidesViewModel>(
                          builder: (consumerCtx, viewModel, _) {
                        if (viewModel.historyRidesList.isEmpty &&
                            !viewModel.isGotData) {
                          return getLoadingWidget(context);
                        }
                        if (viewModel.historyRidesList.isEmpty &&
                            viewModel.isGotData) {
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
                                        'You have no campaigns in history.',
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
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                              itemCount: viewModel.historyRidesList.length,
                              itemBuilder: (ctx, index) {
                                final ScheduleRideDataModal
                                    scheduleRideDataModal =
                                    viewModel.historyRidesList[index];
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
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  topRight:
                                                      Radius.circular(12))),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                formatDate(
                                                    scheduleRideDataModal.date),
                                                style: GoogleFonts.nunito(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                formatTime(
                                                    scheduleRideDataModal.time),
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
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 15, 15, 20),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'TRIP',
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 15,
                                                          color:
                                                              Colors.lightGreen,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    Text(
                                                      scheduleRideDataModal
                                                                  .status ==
                                                              2
                                                          ? 'COMPLETED'
                                                          : 'CANCELED',
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 16,
                                                          color: scheduleRideDataModal
                                                                      .status ==
                                                                  2
                                                              ? Colors
                                                                  .lightGreen
                                                              : Colors.red,
                                                          fontWeight:
                                                              FontWeight.w700),
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
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2.5),
                                                        child: Image.asset(
                                                          ImageAssets
                                                              .startingLocationIcon,
                                                          height: 25,
                                                          width: 25,
                                                          color:
                                                              Colors.lightGreen,
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
                                                        style:
                                                            GoogleFonts.nunito(
                                                                fontSize: 15,
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2.5),
                                                        child: Image.asset(
                                                          ImageAssets
                                                              .destinationLocationIcon,
                                                          height: 25,
                                                          width: 25,
                                                          color:
                                                              Colors.lightGreen,
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
                                                        style:
                                                            GoogleFonts.nunito(
                                                                fontSize: 15,
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
                                                      CrossAxisAlignment.start,
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
                                                            style: GoogleFonts
                                                                .nunito(
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
                                                            style: GoogleFonts
                                                                .nunito(
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
                                                      CrossAxisAlignment.start,
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
                                                            style: GoogleFonts
                                                                .nunito(
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
                                                            style: GoogleFonts
                                                                .nunito(
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
                                                      CrossAxisAlignment.start,
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
                                                            style: GoogleFonts
                                                                .nunito(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          ),
                                                          Text(
                                                            '${scheduleRideDataModal.bookedSeats}/${scheduleRideDataModal.availableSeats}',
                                                            softWrap: true,
                                                            style: GoogleFonts
                                                                .nunito(
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
                                                      CrossAxisAlignment.start,
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
                                                            style: GoogleFonts
                                                                .nunito(
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
                                                            style: GoogleFonts
                                                                .nunito(
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
                                                    ? const SizedBox.shrink()
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
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              2,
                                                                          top:
                                                                              2),
                                                                  child: Icon(
                                                                    Icons
                                                                        .comment,
                                                                    size: 24,
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
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
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
                  })),
        ],
      ),
    ));
  }
}
