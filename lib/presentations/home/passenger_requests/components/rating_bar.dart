import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/data/mapper/mappers.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';

import 'package:lift_app/presentations/home/passenger_requests/components/rating_view_model.dart';
import 'package:lift_app/presentations/utils/notifications_service.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:lottie/lottie.dart';

import '../../../../data/network/failure.dart';
import '../../../resources/assets_manager.dart';

class PassengerRatingBar extends StatefulWidget {
  final String driverId;
  final String campaignId;

  const PassengerRatingBar(
      {Key? key, required this.driverId, required this.campaignId})
      : super(key: key);

  @override
  State<PassengerRatingBar> createState() => _PassengerRatingBarState();
}

class _PassengerRatingBarState extends State<PassengerRatingBar> {
  final TextEditingController _commentEditingController =
      TextEditingController();
  double passengerRating = 0;
  bool isLoading = false;
  bool isError = false;
  String errorMessage = EMPTY;
  bool isSuccess = false;
  final RatingViewModel _ratingViewModel = RatingViewModel();

  @override
  void dispose() {
    _commentEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    isError || isLoading || isSuccess
                        ? const SizedBox.shrink()
                        : Container(
                            height: getHeight(context: context),
                            width: getWidth(context: context),
                            color: Colors.black87.withOpacity(0.7),
                            child: Center(
                              child: Container(
                                width: getWidth(context: context) * 0.8,
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0, 1.5),
                                          blurRadius: 0.4,
                                          spreadRadius: 0.2),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            icon: const Padding(
                                              padding: EdgeInsets.only(
                                                  right: 8, top: 5),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.black,
                                              ),
                                            )),
                                      ),
                                      Text(
                                        'Give Rating',
                                        style: GoogleFonts.nunito(
                                            color: Colors.lightGreen[400],
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      RatingBar.builder(
                                        initialRating: passengerRating,
                                        itemSize: 50,
                                        itemCount: 5,
                                        itemBuilder: (context, index) {
                                          switch (index) {
                                            case 0:
                                              return const Icon(
                                                Icons
                                                    .sentiment_very_dissatisfied,
                                                color: Colors.red,
                                              );
                                            case 1:
                                              return const Icon(
                                                Icons.sentiment_dissatisfied,
                                                color: Colors.redAccent,
                                              );
                                            case 2:
                                              return const Icon(
                                                Icons.sentiment_neutral,
                                                color: Colors.amber,
                                              );
                                            case 3:
                                              return const Icon(
                                                Icons.sentiment_satisfied,
                                                color: Colors.lightGreen,
                                              );
                                            case 4:
                                              return const Icon(
                                                Icons.sentiment_very_satisfied,
                                                color: Colors.green,
                                              );
                                          }
                                          return const SizedBox.shrink();
                                        },
                                        onRatingUpdate: (rating) {
                                          setState(() {
                                            passengerRating = rating;
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        passengerRating.toString(),
                                        style: GoogleFonts.rubik(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 7),
                                              child: Text(
                                                'Feedback',
                                                style: GoogleFonts.nunito(
                                                    color: Colors.lightGreen,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            TextField(
                                              controller:
                                                  _commentEditingController,
                                              maxLines: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      SizedBox(
                                        width:
                                            getWidth(context: context) * 0.8 -
                                                24,
                                        height: 40,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                          onPressed:
                                              passengerRating.toInt() == 0 ||
                                                      _commentEditingController
                                                          .text.isEmpty
                                                  ? null
                                                  : () async {
                                                      setState(() {
                                                        isLoading = true;
                                                        isError = false;
                                                        errorMessage = EMPTY;
                                                        isSuccess = false;
                                                      });
                                                      try {
                                                        await _ratingViewModel.submitRating(
                                                            RatingSubmitRequest(
                                                                widget.driverId,
                                                                passengerRating
                                                                    .toInt(),
                                                                widget
                                                                    .campaignId,
                                                                _commentEditingController
                                                                    .text,
                                                                DateTime.now()
                                                                    .toString()));
                                                        //notification part
                                                        NotificationsService
                                                            .sendPushNotification(
                                                                SendNotificationRequest(
                                                          [widget.driverId],
                                                          'Notification',
                                                          '${CommonData.passengerDataModal.name} has given you a rating of ${passengerRating.toInt()}.',
                                                          <String, dynamic>{
                                                            'type':
                                                                'Submit_rating',
                                                            'title':
                                                                'Notification',
                                                            'body':
                                                                '${CommonData.passengerDataModal.name} has given you a rating of ${passengerRating.toInt()}.',
                                                            'userImage': CommonData
                                                                .passengerDataModal
                                                                .profileImg,
                                                            'userId': [
                                                              widget.driverId
                                                            ]
                                                          },
                                                        ));

                                                        _commentEditingController
                                                            .text = EMPTY;

                                                        setState(() {
                                                          isLoading = false;
                                                          isError = false;
                                                          errorMessage = EMPTY;
                                                          isSuccess = true;
                                                        });
                                                      } on Failure catch (error) {
                                                        setState(() {
                                                          isLoading = false;
                                                          isSuccess = false;
                                                          isError = true;
                                                          errorMessage =
                                                              error.message;
                                                        });
                                                      } catch (error) {
                                                        setState(() {
                                                          isLoading = false;
                                                          isError = true;
                                                          isSuccess = false;
                                                          errorMessage =
                                                              'Something went wrong. Please try again later.';
                                                        });
                                                      }
                                                    },
                                          child: Text(
                                            'Submit',
                                            style: GoogleFonts.nunito(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                    !isSuccess
                        ? const SizedBox.shrink()
                        : Container(
                            height: getHeight(context: context),
                            width: getWidth(context: context),
                            color: Colors.black54,
                            child: Center(
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 30, 20, 15),
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
                                        LottieAssets.success,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      'You have successfully submitted the rating.',
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
                                                      BorderRadius.circular(
                                                          4))),
                                          onPressed: () {
                                            Navigator.of(context).pop();
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
                    !isError
                        ? const SizedBox.shrink()
                        : Container(
                            height: getHeight(context: context),
                            width: getWidth(context: context),
                            color: Colors.black54,
                            child: Center(
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 30, 20, 15),
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
                                                      BorderRadius.circular(
                                                          4))),
                                          onPressed: () {
                                            setState(() {
                                              isError = false;
                                              errorMessage = EMPTY;
                                              isLoading = false;
                                              isSuccess = false;
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
