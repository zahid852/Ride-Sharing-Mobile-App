import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';
import 'package:lift_app/presentations/home/search/components/modal_bottom_sheet_view_model.dart';
import 'package:lift_app/presentations/resources/routes_manager.dart';
import 'package:lift_app/presentations/splash/splash_screen.dart';
import 'package:lift_app/presentations/utils/notifications_service.dart';
import 'package:lift_app/presentations/utils/socket.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import '../../../../data/mapper/mappers.dart';
import '../../../../data/network/failure.dart';
import '../../../../domain/model/models.dart';
import '../../../resources/assets_manager.dart';

Future<void> showSeatSelectionModal(
  BuildContext context,
  CampaignsDataModal campaignsDataModal,
  bool isIncrementPossible,
  bool isdeccrementPossible,
  int seatCount,
) async {
  final int seatsToOffer =
      campaignsDataModal.availableSeats - campaignsDataModal.bookedSeats;
  if (seatsToOffer > 0) {
    isIncrementPossible = true;
  }
  await showModalBottomSheet<void>(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30))),
    context: context,
    builder: (BuildContext ctx) {
      return StatefulBuilder(builder: (stCtx, StateSetter setModalBottomstate) {
        return Container(
          height: 310,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 5,
                    width: 35,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'How many seats do you want to book?',
                      style: GoogleFonts.nunito(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 54,
                        width: 54,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                            color: isdeccrementPossible
                                ? Colors.lightGreen
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(15)),
                        child: IconButton(
                          icon: const Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                          onPressed: !isdeccrementPossible
                              ? null
                              : () {
                                  if (seatCount > 0) {
                                    setModalBottomstate(() {
                                      seatCount--;
                                      if (seatCount > 0) {
                                        isdeccrementPossible = true;
                                        if (seatCount <
                                            campaignsDataModal.availableSeats -
                                                campaignsDataModal
                                                    .bookedSeats) {
                                          isIncrementPossible = true;
                                        }
                                      } else {
                                        isdeccrementPossible = false;
                                        if (seatCount <
                                            campaignsDataModal.availableSeats -
                                                campaignsDataModal
                                                    .bookedSeats) {
                                          isIncrementPossible = true;
                                        }
                                      }
                                    });
                                  }
                                },
                        ),
                      ),
                      Text(
                        seatCount.toString(),
                        style: GoogleFonts.nunito(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Container(
                        height: 54,
                        width: 54,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                            color: isIncrementPossible
                                ? Colors.lightGreen
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(15)),
                        child: IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: !isIncrementPossible
                              ? null
                              : () {
                                  if (campaignsDataModal.bookedSeats <
                                      campaignsDataModal.availableSeats) {
                                    setModalBottomstate(() {
                                      seatCount++;
                                      if (seatCount >=
                                          campaignsDataModal.availableSeats -
                                              campaignsDataModal.bookedSeats) {
                                        isdeccrementPossible = true;
                                        isIncrementPossible = false;
                                      } else {
                                        isdeccrementPossible = true;
                                        isIncrementPossible = true;
                                      }
                                    });
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
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
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: seatCount > 0
                        ? () {
                            Navigator.of(context).pop();
                            showModalBottomSheetForSendingRequest(
                                context,
                                seatCount,
                                int.parse(campaignsDataModal.seatCost),
                                campaignsDataModal.campaignId,
                                campaignsDataModal.driverId,
                                campaignsDataModal.isNowRide);
                          }
                        : null,
                    child: Text(
                      'Done',
                      style: GoogleFonts.nunito(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
    },
  );
}

void showModalBottomSheetForSendingRequest(
    BuildContext context,
    int selectedSeats,
    int offerPrice,
    String campaignId,
    String driverId,
    bool isNowRide) {
  int selectedSeatCostBoxIndex = 0;
  int selectedValue = 0;
  int passengerSeatCostOffer = offerPrice;
  CustomPassengerLocation? _customPassengerLocation;
  ModalBottomSheetViewModel modalBottomSheetViewModel =
      ModalBottomSheetViewModel();

  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(builder:
            (BuildContext setstateCtx, StateSetter setModalBottomstate) {
          return Container(
            // height: getHeight(context: context),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 5,
                    width: 35,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Image.asset(
                              ImageAssets.seatsToBook,
                              height: 28,
                              color: Colors.lightGreen,
                              width: 28,
                            ),
                          ),
                          const SizedBox(
                            width: 12.6,
                          ),
                          Text(
                            'Seats to book',
                            style: GoogleFonts.nunito(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Text(
                        selectedSeats.toString(),
                        style: GoogleFonts.nunito(
                            color: Colors.lightGreen,
                            fontSize: 17,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 0, right: 2),
                            child: Icon(
                              Icons.money,
                              size: 28,
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            "Cost/Seat",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.nunito(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Text(
                        '${offerPrice}PKR',
                        style: GoogleFonts.nunito(
                            color: Colors.lightGreen,
                            fontSize: 17,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Pick Up location',
                        style: GoogleFonts.nunito(
                            fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RadioListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        title: Text(
                          'Same as driver',
                          style: GoogleFonts.nunito(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        value: 0,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          setModalBottomstate(() {
                            selectedValue = value ?? 0;
                          });
                        },
                      ),
                      RadioListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        title: Text(
                          'Custom',
                          style: GoogleFonts.nunito(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        value: 1,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          setModalBottomstate(() {
                            selectedValue = value ?? 0;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                selectedValue == 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your offer',
                            style: GoogleFonts.nunito(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                                itemCount: 4,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, index) {
                                  return InkWell(
                                    onTap: () {
                                      setModalBottomstate(() {
                                        passengerSeatCostOffer = index == 0
                                            ? offerPrice
                                            : index == 1
                                                ? (offerPrice * 0.9).toInt()
                                                : index == 2
                                                    ? (offerPrice * 0.8).toInt()
                                                    : (offerPrice * 0.7)
                                                        .toInt();
                                        selectedSeatCostBoxIndex = index;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      decoration: BoxDecoration(
                                          color:
                                              selectedSeatCostBoxIndex == index
                                                  ? Colors.lightGreen
                                                  : Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Center(
                                        child: Text(
                                          '${index == 0 ? offerPrice : index == 1 ? (offerPrice * 0.9).toInt() : index == 2 ? (offerPrice * 0.8).toInt() : (offerPrice * 0.7).toInt()}PKR',
                                          style: GoogleFonts.nunito(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Total bill',
                                style: GoogleFonts.nunito(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${selectedSeats * passengerSeatCostOffer}PKR',
                                style: GoogleFonts.nunito(
                                    color: Colors.lightGreen,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40.0),
                        ],
                      )
                    : _customPassengerLocation != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Text(
                                    ' Pick up location',
                                    style: GoogleFonts.nunito(
                                        color: Colors.lightGreen,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: getWidth(context: context) * 0.85,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.grey)),
                                    child: Text(
                                      _customPassengerLocation!.pickUpLocation,
                                      style: GoogleFonts.nunito(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Your offer',
                                    style: GoogleFonts.nunito(
                                        color: Colors.lightGreen,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: getWidth(context: context) * 0.85,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.grey)),
                                    child: Text(
                                      '${_customPassengerLocation!.price} PKR',
                                      style: GoogleFonts.nunito(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Total bill',
                                      style: GoogleFonts.nunito(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '${selectedSeats * int.parse(_customPassengerLocation!.price)}PKR',
                                      style: GoogleFonts.nunito(
                                          color: Colors.lightGreen,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                              ])
                        : Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 55,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
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
                                      // backgroundColor: Colors.grey[200],
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  onPressed: () async {
                                    Navigator.of(context)
                                        .pushNamed(Routes.customRoute)
                                        .then((data) {
                                      if (data != null) {
                                        _customPassengerLocation =
                                            data as CustomPassengerLocation;
                                        setModalBottomstate(() {});
                                      }
                                    });
                                  },
                                  child: Text(
                                    'Enter pick up location',
                                    style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                            ],
                          ),
                Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
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
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: selectedValue == 1 &&
                            _customPassengerLocation == null
                        ? null
                        : () async {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushNamed(Routes.loadingRoute,
                                arguments: 'Posting request');
                            try {
                              await modalBottomSheetViewModel
                                  .passengerRideShareRequest(
                                      PassengerRideShareRequest(
                                          CommonData.passengerDataModal.id,
                                          campaignId,
                                          selectedSeats,
                                          _customPassengerLocation ==
                                                  null
                                              ? passengerSeatCostOffer
                                              : int.parse(
                                                  _customPassengerLocation!
                                                      .price),
                                          _customPassengerLocation == null
                                              ? EMPTY
                                              : _customPassengerLocation!
                                                  .pickUpLocation,
                                          driverId));
                              //notification part
                              if (isNowRide == false) {
                                NotificationsService.sendPushNotification(
                                    SendNotificationRequest(
                                        [driverId],
                                        'Notification',
                                        '${CommonData.passengerDataModal.name} has send you a request.',
                                        <String, dynamic>{
                                          'type': 'Send_request',
                                          'campaignId': campaignId,
                                          'title': 'Notification',
                                          'body':
                                              '${CommonData.passengerDataModal.name} has send you a request.',
                                          'userImage': CommonData
                                              .passengerDataModal.profileImg,
                                          'userId': [driverId],
                                        },
                                        globalAppPreferences.getFCMToken()));
                              }

                              if (context.mounted) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamed(
                                    Routes.successRoute,
                                    arguments:
                                        'You have successfully posted your request.');
                                SocketImplementation.sendPassengerRequest(
                                    driverId: driverId, campaignId: campaignId);
                              }
                            } on Failure catch (error) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed(Routes.errorRoute,
                                  arguments: error.message);
                            } catch (error) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed(Routes.errorRoute,
                                  arguments:
                                      'Something went wrong. Please try again.');
                            }
                          },
                    child: Text(
                      'Request',
                      style: GoogleFonts.nunito(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      });
}
