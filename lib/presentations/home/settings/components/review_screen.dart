import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:intl/intl.dart';
import 'package:lift_app/data/network/failure.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';
import 'package:lift_app/presentations/home/settings/components/review_view_model.dart';
import 'package:lift_app/presentations/resources/assets_manager.dart';
import 'package:lift_app/presentations/utils/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../utils/utils.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({Key? key}) : super(key: key);

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  late ReviewViewModel _reviewViewModel;
  late Future<void> _getRatingsData;
  @override
  void initState() {
    _reviewViewModel = Provider.of<ReviewViewModel>(context, listen: false);
    _getRatingsData =
        _reviewViewModel.getRatings(CommonData.passengerDataModal.id);

    super.initState();
  }

  String formatDateTime(String dateTimeString) {
    // Format the DateTime object into "21 June at 10:30 am" format.
    DateTime dateTime = DateTime.parse(dateTimeString);
    return '${DateFormat('MMMM d').format(dateTime)} at ${DateFormat('hh:mm a').format(dateTime)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 28,
                    ))),
            Padding(
              padding: const EdgeInsets.only(left: 60, right: 40),
              child: Text(
                'Reviews',
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
              future: _getRatingsData,
              builder: (futureCtx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return getLoadingWidget(context);
                } else if (snapshot.hasError) {
                  return Center(
                    child: Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                        width: getWidth(context: context) * 0.7,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
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
                              height: 60,
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
                                      _getRatingsData =
                                          Provider.of<ReviewViewModel>(context,
                                                  listen: false)
                                              .getRatings(CommonData
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
                  );
                } else {
                  return Consumer<ReviewViewModel>(
                      builder: (consumerCtx, viewModel, _) {
                    if (viewModel.ratingsList.isEmpty && viewModel.isGotData) {
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
                                    'There are no reviews yet.',
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
                          itemCount: viewModel.ratingsList.length,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemBuilder: (ctx, index) {
                            final RatingDataModel rating =
                                viewModel.ratingsList[index];
                            return Column(
                              children: [
                                ListTile(
                                  titleAlignment: ListTileTitleAlignment.top,
                                  leading: CircleAvatar(
                                    radius: 24.5,
                                    backgroundColor: Colors.lightGreen,
                                    child: CircleAvatar(
                                      radius: 24,
                                      child: CachedNetworkImage(
                                        imageUrl: rating.passengerProfileImg,
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
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 16),
                                  title: Text(
                                    rating.passengerName,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        'You have been given rating of ${rating.rating}',
                                        style: GoogleFonts.nunito(
                                            color: Colors.grey[800],
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      RatingBar.builder(
                                          initialRating:
                                              rating.rating.toDouble(),
                                          itemSize: 25,
                                          allowHalfRating: true,
                                          unratedColor: Colors.black54,
                                          ignoreGestures: true,
                                          itemBuilder: (ctx, _) {
                                            return const DecoratedIcon(
                                              icon: Icon(Icons.star,
                                                  color: Colors.yellowAccent),
                                              decoration: IconDecoration(
                                                border: IconBorder(width: 1.5),
                                              ),
                                            );
                                          },
                                          onRatingUpdate: (_) {}),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        rating.comment,
                                        style: GoogleFonts.nunito(
                                            color: Colors.grey[800],
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        formatDateTime(rating.dateTime),
                                        style: GoogleFonts.nunito(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                const Column(
                                  children: [
                                    Divider(
                                      height: 0,
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                  ],
                                )
                              ],
                            );
                          });
                    }
                  });
                }
              }))
    ])));
  }
}
