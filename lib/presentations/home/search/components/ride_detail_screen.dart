import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:lift_app/presentations/home/search/components/modal_bottom_sheet.dart';
import 'package:lift_app/presentations/resources/assets_manager.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:lift_app/presentations/utils/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../domain/model/models.dart';
import '../../../resources/routes_manager.dart';

class SharedRideDetailScreen extends StatefulWidget {
  final CampaignsDataModal campaignsDataModal;
  final DateTime currentDate;
  const SharedRideDetailScreen(
      {Key? key, required this.campaignsDataModal, required this.currentDate})
      : super(key: key);

  @override
  State<SharedRideDetailScreen> createState() => _SharedRideDetailScreenState();
}

class _SharedRideDetailScreenState extends State<SharedRideDetailScreen> {
  bool _showVehicleDetails = false;
  bool _showSeatDetails = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: getHeight(context: context) * 0.52,
              pinned: true,
              toolbarHeight: 70,
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Padding(
                    padding: EdgeInsets.only(left: 15, bottom: 2.5),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.lightGreen,
                      size: 28,
                    ),
                  )),
              stretch: false,
              title: InvisibleExpandedHeader(
                  child: Text(
                'Ride Details',
                style: GoogleFonts.nunito(
                    color: Colors.lightGreen,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              )),
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.none,
                background: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            SizedBox(
                              height: getHeight(context: context) * 0.425 - 40,
                              width: getWidth(context: context),
                            ),
                            ClipPath(
                              clipper: ProfileClipper(),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      Routes.imageRoute,
                                      arguments: widget
                                          .campaignsDataModal.vehicleImage);
                                },
                                child:
                                    // CachedNetworkImage(
                                    //     height:
                                    //         getHeight(context: context) * 0.4 - 35,
                                    //     width: double.infinity,
                                    //     fit: BoxFit.cover,
                                    //     imageUrl:
                                    //         widget.campaignsDataModal.vehicleImage),
                                    CachedNetworkImage(
                                  imageUrl:
                                      widget.campaignsDataModal.vehicleImage,
                                  height:
                                      getHeight(context: context) * 0.4 - 35,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  errorWidget: (_, url, error) => Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: Image.asset(
                                                ImageAssets.carPaceholder)
                                            .image,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        Routes.imageRoute,
                                        arguments: widget
                                            .campaignsDataModal.profileImage);
                                  },
                                  child: CircleAvatar(
                                    radius: 59,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 55,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(65),
                                        child: CachedNetworkImage(
                                          imageUrl: widget
                                              .campaignsDataModal.profileImage,
                                          fit: BoxFit.cover,
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
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: Image.asset(
                                                        ImageAssets.profile)
                                                    .image,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: getWidth(context: context) * 0.7,
                          child: Center(
                            child: Text(
                              widget.campaignsDataModal.name,
                              softWrap: true,
                              style: GoogleFonts.nunito(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        RatingBar.builder(
                            initialRating:
                                widget.campaignsDataModal.totalReviewsGiven == 0
                                    ? 5
                                    : (widget.campaignsDataModal.totalRating /
                                            widget.campaignsDataModal
                                                .totalReviewsGiven)
                                        .toDouble(),
                            itemSize: 25,
                            allowHalfRating: true,
                            unratedColor: Colors.black,
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
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.campaignsDataModal.totalReviewsGiven == 0
                                  ? '5'
                                  : (widget.campaignsDataModal.totalRating /
                                          widget.campaignsDataModal
                                              .totalReviewsGiven)
                                      .toStringAsFixed(2),
                              style: GoogleFonts.nunito(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '(${widget.campaignsDataModal.totalReviewsGiven})',
                              style: GoogleFonts.nunito(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              const SizedBox(
                height: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      ' Starting location',
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
                          border: Border.all(color: Colors.grey[300]!)),
                      child: Text(
                        widget.campaignsDataModal.startingLocation,
                        style: GoogleFonts.nunito(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      ' Destination location',
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
                          border: Border.all(color: Colors.grey[300]!)),
                      child: Text(
                        widget.campaignsDataModal.endingLocation,
                        style: GoogleFonts.nunito(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: getWidth(context: context) * 0.85,
                        child: _showSeatDetails == false
                            ? Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _showSeatDetails = true;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 3),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.grey[300]!)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Seat Details',
                                                style: GoogleFonts.nunito(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _showSeatDetails = true;
                                                });
                                              },
                                              icon: SvgPicture.asset(
                                                ImageAssets.arrowDownIcon,
                                                height: 18,
                                                color: Colors.lightGreen,
                                                width: 18,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _showSeatDetails = false;
                                        });
                                      },
                                      icon: SvgPicture.asset(
                                        ImageAssets.arrowUpIcon,
                                        color: Colors.lightGreen,
                                        height: 20,
                                        width: 20,
                                      )),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          Colors.lightGreen.withOpacity(0.25),
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 13),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Icon(
                                                  MdiIcons.seatPassenger,
                                                  color: Colors.lightGreen[700],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Total seats offered',
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 16,
                                                          color: Colors
                                                              .lightGreen[700],
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      widget.campaignsDataModal
                                                          .availableSeats
                                                          .toString(),
                                                      softWrap: true,
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 15,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Divider(
                                            // height: 8,
                                            ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 13),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2),
                                                  child: SvgPicture.asset(
                                                    ImageAssets.doneSvg,
                                                    color:
                                                        Colors.lightGreen[700],
                                                    width: 23,
                                                    height: 23,
                                                  )),
                                              const SizedBox(
                                                width: 11,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Booked Seats',
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 16,
                                                          color: Colors
                                                              .lightGreen[700],
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      widget.campaignsDataModal
                                                          .bookedSeats
                                                          .toString(),
                                                      softWrap: true,
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 15,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Divider(
                                            // height: 8,
                                            ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 13),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Image.asset(
                                                  ImageAssets.seatsToBook,
                                                  color: Colors.lightGreen[700],
                                                  width: 25,
                                                  height: 25,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 11,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Remaining',
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 16,
                                                          color: Colors
                                                              .lightGreen[700],
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      '${widget.campaignsDataModal.availableSeats - widget.campaignsDataModal.bookedSeats}',
                                                      softWrap: true,
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 15,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),

                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: getWidth(context: context) * 0.80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.blue[100]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    widget.campaignsDataModal.vehicleType ==
                                            'Car'
                                        ? MdiIcons.car
                                        : MdiIcons.motorbike,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    widget.campaignsDataModal
                                        .expectedRideDistance,
                                    style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.blue[100]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    widget.campaignsDataModal.expectedRideTime,
                                    style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: getWidth(context: context) * 0.85,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.lightGreen.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "The ride is scheduled for ${'${isSameDaySearchRide(DateTime.parse(widget.campaignsDataModal.date), widget.currentDate) ? 'Today' : convertDateToDateStringWithDay(DateTime.parse(widget.campaignsDataModal.date))} at ${DateFormat('h:mm a').format(DateTime.parse(widget.campaignsDataModal.time))}'}",
                        style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: getWidth(context: context) * 0.85,
                        child: _showVehicleDetails == false
                            ? Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _showVehicleDetails = true;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 3),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.grey[300]!)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Vehicle Details',
                                                style: GoogleFonts.nunito(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _showVehicleDetails = true;
                                                });
                                              },
                                              icon: SvgPicture.asset(
                                                ImageAssets.arrowDownIcon,
                                                height: 18,
                                                color: Colors.lightGreen,
                                                width: 18,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _showVehicleDetails = false;
                                        });
                                      },
                                      icon: SvgPicture.asset(
                                        ImageAssets.arrowUpIcon,
                                        color: Colors.lightGreen,
                                        height: 20,
                                        width: 20,
                                      )),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          Colors.lightGreen.withOpacity(0.25),
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 13),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Icon(
                                                  MdiIcons.car,
                                                  color: Colors.lightGreen[700],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Vehicle Type',
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 16,
                                                          color: Colors
                                                              .lightGreen[700],
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      widget.campaignsDataModal
                                                          .vehicleType,
                                                      softWrap: true,
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 15,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Divider(
                                            // height: 8,
                                            ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 13),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Icon(
                                                  IconlyBold.bookmark,
                                                  color: Colors.lightGreen[700],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Vehicle Brand',
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 16,
                                                          color: Colors
                                                              .lightGreen[700],
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      widget.campaignsDataModal
                                                          .vehicleBrand,
                                                      softWrap: true,
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 15,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Divider(
                                            // height: 8,
                                            ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 13),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Icon(
                                                  Icons.numbers,
                                                  color: Colors.lightGreen[700],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Vehicle Number',
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 16,
                                                          color: Colors
                                                              .lightGreen[700],
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      widget.campaignsDataModal
                                                          .vehicleNumber,
                                                      softWrap: true,
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 15,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),

                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: getWidth(context: context) * 0.85,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Ride Rules',
                              style: GoogleFonts.nunito(
                                  color: Colors.lightGreen,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(
                            height: 2.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "The driver's rules and facilities are",
                              style: GoogleFonts.nunito(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                      color: widget.campaignsDataModal.rideRules
                                              .isMusic
                                          ? Colors.lightGreen
                                          : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      widget.campaignsDataModal.rideRules
                                              .isMusic
                                          ? SvgPicture.asset(
                                              ImageAssets.doneSvg,
                                              color: Colors.white,
                                              width: 25,
                                              height: 25,
                                            )
                                          : const SizedBox.shrink(),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'MUSIC',
                                        style: GoogleFonts.nunito(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                      color: widget
                                              .campaignsDataModal.rideRules.isAc
                                          ? Colors.lightGreen
                                          : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        widget.campaignsDataModal.rideRules.isAc
                                            ? SvgPicture.asset(
                                                ImageAssets.doneSvg,
                                                color: Colors.white,
                                                width: 25,
                                                height: 25,
                                              )
                                            : const SizedBox.shrink(),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'AC',
                                          style: GoogleFonts.nunito(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: widget.campaignsDataModal.rideRules
                                              .isSmoke
                                          ? Colors.lightGreen
                                          : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(6)),
                                  height: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        widget.campaignsDataModal.rideRules
                                                .isSmoke
                                            ? SvgPicture.asset(
                                                ImageAssets.doneSvg,
                                                color: Colors.white,
                                                width: 25,
                                                height: 25,
                                              )
                                            : const SizedBox.shrink(),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'SMOKING',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.nunito(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  widget.campaignsDataModal.comment.isEmpty
                      ? const SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(
                                ' Comment',
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
                                    border:
                                        Border.all(color: Colors.grey[300]!)),
                                child: Text(
                                  widget.campaignsDataModal.comment,
                                  style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      ' Seat/Cost',
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
                          border: Border.all(color: Colors.grey[300]!)),
                      child: Text(
                        '${widget.campaignsDataModal.seatCost} PKR',
                        style: GoogleFonts.nunito(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ]))
          ],
        )),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: FractionallySizedBox(
              widthFactor: 0.85,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
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
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () async {
                      if (widget.campaignsDataModal.availableSeats -
                              widget.campaignsDataModal.bookedSeats >
                          1) {
                        await showSeatSelectionModal(
                          context,
                          widget.campaignsDataModal,
                          isIncrementPossible,
                          isdeccrementPossible,
                          seatCount,
                        );
                      } else {
                        showModalBottomSheetForSendingRequest(
                            context,
                            widget.campaignsDataModal.availableSeats -
                                widget.campaignsDataModal.bookedSeats,
                            int.parse(widget.campaignsDataModal.seatCost),
                            widget.campaignsDataModal.campaignId,
                            widget.campaignsDataModal.driverId,
                            widget.campaignsDataModal.isNowRide);
                      }
                    },
                    child: Text(
                      'Make Request',
                      style: GoogleFonts.nunito(
                          fontSize: 17, fontWeight: FontWeight.w700),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int seatCount = 0;
  int passengerOfferPrice = 0;
  bool isIncrementPossible = false;
  bool isdeccrementPossible = false;
}
