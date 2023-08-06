import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../domain/model/models.dart';
import '../../../resources/assets_manager.dart';
import '../../../utils/utils.dart';

class PassengerPendingRequestBody extends StatefulWidget {
  final List<PassengerAllRequests> passengerRequests;
  const PassengerPendingRequestBody({Key? key, required this.passengerRequests})
      : super(key: key);

  @override
  State<PassengerPendingRequestBody> createState() =>
      _PassengerPendingRequestBodyState();
}

class _PassengerPendingRequestBodyState
    extends State<PassengerPendingRequestBody> {
  @override
  Widget build(BuildContext context) {
    List<PassengerAllRequests> requests =
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
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
            itemCount: requests.length,
            itemBuilder: (listCtx, index) {
              final PassengerAllRequests data = requests[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatDate(data.startDate),
                                style: GoogleFonts.nunito(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                formatTime(data.startTime),
                                style: GoogleFonts.nunito(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 2,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(top: 2.5),
                                    child: Image.asset(
                                      ImageAssets.startingLocationIcon,
                                      height: 25,
                                      width: 25,
                                      color: Colors.lightGreen,
                                      fit: BoxFit.cover,
                                    )),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(
                                    data.startingLocation,
                                    softWrap: true,
                                    style: GoogleFonts.nunito(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
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
                                    padding: const EdgeInsets.only(top: 2.5),
                                    child: Image.asset(
                                      ImageAssets.destinationLocationIcon,
                                      height: 25,
                                      width: 25,
                                      color: Colors.lightGreen,
                                      fit: BoxFit.cover,
                                    )),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(
                                    data.endingLocation,
                                    softWrap: true,
                                    style: GoogleFonts.nunito(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
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
                                    padding: const EdgeInsets.only(
                                        bottom: 2, left: 1),
                                    child: Icon(
                                      MdiIcons.car,
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
                                        'Distance',
                                        softWrap: true,
                                        style: GoogleFonts.nunito(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        data.expectedRideDistance,
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
                                    padding: const EdgeInsets.only(
                                        bottom: 2, left: 1),
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
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Duration',
                                        softWrap: true,
                                        style: GoogleFonts.nunito(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        data.expectedRideTime,
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
                                        'Booked/Total Seats',
                                        softWrap: true,
                                        style: GoogleFonts.nunito(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        '${data.bookedSeats}/${data.availableSeats}',
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
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 2, left: 1),
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
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
  }
}
