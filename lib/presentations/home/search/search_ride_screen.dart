import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/home/search/components/modal_bottom_sheet.dart';
import 'package:lift_app/presentations/home/search/search_ride_view_model.dart';
import 'package:lift_app/presentations/home/search/searches_view_model.dart';
import 'package:lift_app/presentations/resources/assets_manager.dart';
import 'package:lift_app/presentations/resources/routes_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../../data/network/failure.dart';
import '../../utils/utils.dart';
import 'components/filter_dialog.dart';

enum SearchByEnum {
  From,
  WhereTo,
}

enum VehicleEnum { Car, Bike, All }

class SearchRideScreen extends StatefulWidget {
  final void Function() menuButtonFunction;
  const SearchRideScreen({Key? key, required this.menuButtonFunction})
      : super(key: key);

  @override
  State<SearchRideScreen> createState() => _SearchRideScreenState();
}

class _SearchRideScreenState extends State<SearchRideScreen> {
  late FocusNode _searchFocusNode;
  String sortBy = SearchByEnum.From.name;
  String vehicleType = VehicleEnum.All.name;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchEditingController =
      TextEditingController();
  bool _isScrolledToTop = true;
  late Future<void> _getCampaignsData;
  late SearchViewModel _searchViewModel;
  bool _isSearchStringEmpty = true;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _getCampaignsData =
        Provider.of<SearchRidesViewModel>(context, listen: false)
            .getCampaignsData();
    Provider.of<SearchRidesViewModel>(context, listen: false).isGotData = false;
    _searchViewModel = Provider.of<SearchViewModel>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels <= 0) {
        setState(() {
          _isScrolledToTop = true;
        });
      } else if (_scrollController.position.pixels + 20 >=
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _isScrolledToTop = false;
        });
      }
    });

    // _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
    //   setState(() {
    //     _getCampaignsData =
    //         Provider.of<SearchRidesViewModel>(context, listen: false)
    //             .getCampaignsData();
    //   });
    // });
  }

  Widget searchRideAppBar(double topValue) {
    return Container(
      color: Colors.lightGreen,
      padding: EdgeInsets.only(top: topValue),
      height: getHeight(context: context) * 0.078,
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
              'Search Rides',
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _scrollController.dispose();
    // _timer.cancel();
    super.dispose();
  }

  void changeSearchLocationParameter(String searchParameter) {
    setState(() {
      _searchEditingController.clear();
      _isSearchStringEmpty = true;
      sortBy = searchParameter;
    });
  }

  void changeVehicleTypeParameter(String vehicle) {
    setState(() {
      _searchEditingController.clear();
      _isSearchStringEmpty = true;
      vehicleType = vehicle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getCampaignsData,
        builder: (futureCtx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              Provider.of<SearchRidesViewModel>(context, listen: false)
                      .isGotData ==
                  false) {
            return Scaffold(
              body: SafeArea(
                  child: Stack(
                children: [
                  searchRideAppBar(0),
                  Center(
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      elevation: 2,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
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
          } else if (snapshot.hasError) {
            return Scaffold(
              body: SafeArea(
                  child: Stack(
                children: [
                  searchRideAppBar(0),
                  Center(
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
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )),
            );
          }

          return Consumer<SearchRidesViewModel>(
              builder: (ctx, campaignsData, _) {
            if (campaignsData.campaignsList.isEmpty &&
                !campaignsData.isGotData) {
              return Scaffold(
                body: SafeArea(
                    child: Stack(
                  children: [
                    searchRideAppBar(0),
                    Center(
                      child: Material(
                        borderRadius: BorderRadius.circular(15),
                        elevation: 2,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
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
            } else if (campaignsData.campaignsList.isEmpty &&
                campaignsData.isGotData) {
              return Scaffold(
                body: SafeArea(
                    child: Stack(
                  children: [
                    searchRideAppBar(0),
                    Center(
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
                                'There are no rides available',
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
                    )
                  ],
                )),
              );
            } else {
              if (_isSearchStringEmpty && vehicleType == VehicleEnum.All.name) {
                _searchViewModel.campaignsList = campaignsData.campaignsList;
              } else if (_isSearchStringEmpty &&
                  vehicleType != VehicleEnum.All.name) {
                final List<CampaignsDataModal> tempData =
                    campaignsData.campaignsList;
                _searchViewModel.campaignsList = tempData
                    .where((location) => VehicleEnum.Car.name == vehicleType
                        ? location.vehicleType == vehicleType
                        : VehicleEnum.Bike.name == vehicleType
                            ? location.vehicleType == vehicleType
                            : true)
                    .toList();
              }

              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    if (_isScrolledToTop) {
                      // Scroll to the bottom
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent + 20,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    } else {
                      // Scroll to the top
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  child: Icon(
                    _isScrolledToTop
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: Colors.white,
                  ),
                ),
                body: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SizedBox(
                    height: getHeight(context: context),
                    width: getWidth(context: context),
                    child: CustomScrollView(
                      controller: _scrollController,
                      dragStartBehavior: DragStartBehavior.down,
                      slivers: [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          toolbarHeight: getHeight(context: context) * 0.078,
                          expandedHeight: 190,
                          floating: false,
                          elevation: 0,
                          pinned: true,
                          flexibleSpace: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  height: getHeight(context: context) * 0.07,
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
                                              onPressed:
                                                  widget.menuButtonFunction,
                                              icon: const Icon(
                                                Icons.menu,
                                                color: Colors.white,
                                                size: 28,
                                              ))),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 60, right: 40),
                                        child: Text(
                                          'Search Rides',
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
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 4, bottom: 10),
                                  width: getWidth(context: context) * 0.9,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: TextField(
                                    focusNode: _searchFocusNode,
                                    controller: _searchEditingController,
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        _isSearchStringEmpty = true;
                                      } else {
                                        _isSearchStringEmpty = false;
                                      }
                                      _searchViewModel.getSortedData(
                                          campaignsData.campaignsList,
                                          value,
                                          sortBy,
                                          vehicleType);
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 12),
                                      border: InputBorder.none,
                                      hintText: 'Search',
                                      hintStyle: GoogleFonts.nunito(
                                          color: Colors.grey[500],
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                      prefixIcon: Icon(Icons.search,
                                          color: _searchFocusNode.hasFocus
                                              ? Colors.lightGreen
                                              : Colors.grey[400]),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[200]!),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(12),
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[200]!),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(12),
                                          )),
                                    ),
                                  ),
                                ),
                                FilterDialog(
                                  changeSearchParameter:
                                      changeSearchLocationParameter,
                                  changeVehicleParameter:
                                      changeVehicleTypeParameter,
                                  removeFocus: () {
                                    _searchFocusNode.unfocus();
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Consumer<SearchViewModel>(
                            builder: (searchCtx, searchesdata, _) {
                          return SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            sliver: searchesdata.campaignsList.isEmpty
                                ? SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        childCount: 1, (context, index) {
                                      return SizedBox(
                                        height: 500,
                                        child: Center(
                                          child: Material(
                                            elevation: 2,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 20, 20, 16),
                                              width:
                                                  getWidth(context: context) *
                                                      0.8,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
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
                                                    'There are no rides available',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700),
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
                                    }),
                                  )
                                : SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      childCount:
                                          searchesdata.campaignsList.length,
                                      (BuildContext context, int index) {
                                        CampaignsDataModal campaignsDataModal =
                                            searchesdata.campaignsList[index];

                                        final String driverName =
                                            campaignsDataModal.name
                                                .toUpperCase();
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              top: index == 0 ? 24 : 5,
                                              bottom: campaignsData
                                                              .campaignsList
                                                              .length -
                                                          1 ==
                                                      index
                                                  ? 10
                                                  : 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 12,
                                                    top: index == 0 ? 0 : 12,
                                                    bottom: 3),
                                                child: Text(
                                                  '${isSameDaySearchRide(DateTime.parse(campaignsDataModal.date), campaignsData.currentDateTime) ? 'Today' : DateFormat('dd/MM/yyyy').format(DateTime.parse(campaignsDataModal.date))}, ${DateFormat('h:mm a').format(DateTime.parse(campaignsDataModal.time))}',
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 14),
                                                  child: SizedBox(
                                                    width: getWidth(
                                                        context: context),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            // ClipRRect(
                                                            //     borderRadius:
                                                            //         BorderRadius
                                                            //             .circular(
                                                            //                 5),
                                                            //     child:
                                                            //         CachedNetworkImage(
                                                            //       imageUrl:
                                                            //           campaignsDataModal
                                                            //               .profileImage,
                                                            //       height: 50,
                                                            //       width: 45,
                                                            //       fit: BoxFit
                                                            //           .cover,
                                                            //     )),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                        Routes
                                                                            .imageRoute,
                                                                        arguments:
                                                                            campaignsDataModal.profileImage);
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black45,
                                                                        width:
                                                                            0.6)),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl:
                                                                        campaignsDataModal
                                                                            .profileImage,
                                                                    height: 50,
                                                                    width: 45,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        image: DecorationImage(
                                                                            image:
                                                                                imageProvider,
                                                                            fit:
                                                                                BoxFit.cover),
                                                                      ),
                                                                    ),
                                                                    errorWidget: (_,
                                                                            url,
                                                                            error) =>
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        image:
                                                                            DecorationImage(
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          image:
                                                                              Image.asset(ImageAssets.profile).image,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    driverName,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.nunito(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Colors
                                                                            .yellow,
                                                                      ),
                                                                      Text(
                                                                        campaignsDataModal.totalReviewsGiven ==
                                                                                0
                                                                            ? '5'
                                                                            : (campaignsDataModal.totalRating / campaignsDataModal.totalReviewsGiven).toString(),
                                                                        style: GoogleFonts.nunito(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                      Text(
                                                                        '(${campaignsDataModal.totalReviewsGiven})',
                                                                        style: GoogleFonts.nunito(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 30,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  'Cost/Seat',
                                                                  style: GoogleFonts.nunito(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      campaignsDataModal
                                                                          .seatCost,
                                                                      style: GoogleFonts.nunito(
                                                                          fontSize:
                                                                              16,
                                                                          color: Colors
                                                                              .lightGreen,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                    Text(
                                                                      'PKR',
                                                                      style: GoogleFonts.nunito(
                                                                          fontSize:
                                                                              16,
                                                                          color: Colors
                                                                              .lightGreen,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 14,
                                                        ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const SizedBox(
                                                              width: 45,
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 2,
                                                                  ),
                                                                  Icon(
                                                                    IconlyBold
                                                                        .location,
                                                                    // color: Colors.red,
                                                                  ),
                                                                  Dash(
                                                                    direction: Axis
                                                                        .vertical,
                                                                    length: 68,
                                                                    dashColor:
                                                                        Colors
                                                                            .lightGreen,
                                                                  ),
                                                                  Icon(IconlyBold
                                                                      .location),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 81,
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          'From',
                                                                          style: GoogleFonts.nunito(
                                                                              fontSize: 14,
                                                                              color: Colors.grey,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                        Text(
                                                                          campaignsDataModal
                                                                              .startingLocation,
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: GoogleFonts.nunito(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 81,
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          'Where to',
                                                                          style: GoogleFonts.nunito(
                                                                              fontSize: 14,
                                                                              color: Colors.grey,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                        Text(
                                                                          campaignsDataModal
                                                                              .endingLocation,
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: GoogleFonts.nunito(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 14,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      14.5),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(campaignsDataModal
                                                                              .vehicleType ==
                                                                          'Car'
                                                                      ? MdiIcons
                                                                          .car
                                                                      : Icons
                                                                          .motorcycle),
                                                                  const SizedBox(
                                                                    width: 6,
                                                                  ),
                                                                  Text(
                                                                    campaignsDataModal
                                                                        .expectedRideDistance,
                                                                    style: GoogleFonts.nunito(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  const Icon(Icons
                                                                      .access_time),
                                                                  const SizedBox(
                                                                    width: 6,
                                                                  ),
                                                                  Text(
                                                                    campaignsDataModal
                                                                        .expectedRideTime,
                                                                    style: GoogleFonts.nunito(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Icon(MdiIcons
                                                                      .seatPassenger),
                                                                  const SizedBox(
                                                                    width: 6,
                                                                  ),
                                                                  Text(
                                                                    '${campaignsDataModal.bookedSeats}/${campaignsDataModal.availableSeats}',
                                                                    style: GoogleFonts.nunito(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            SizedBox(
                                                              height: 40,
                                                              width: getWidth(
                                                                      context:
                                                                          context) *
                                                                  0.4,
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    elevation:
                                                                        1,
                                                                    backgroundColor:
                                                                        Colors.grey[
                                                                            200],
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(6))),
                                                                onPressed: () {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushNamed(
                                                                          Routes
                                                                              .rideDetails,
                                                                          arguments: [
                                                                        campaignsDataModal,
                                                                        campaignsData
                                                                            .currentDateTime
                                                                      ]);
                                                                },
                                                                child: Text(
                                                                  'Detail',
                                                                  style: GoogleFonts.nunito(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .lightGreen,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 40,
                                                              width: getWidth(
                                                                      context:
                                                                          context) *
                                                                  0.4,
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    elevation:
                                                                        1,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(6))),
                                                                onPressed:
                                                                    () async {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                  if (campaignsDataModal
                                                                              .availableSeats -
                                                                          campaignsDataModal
                                                                              .bookedSeats >
                                                                      1) {
                                                                    await showSeatSelectionModal(
                                                                      context,
                                                                      campaignsDataModal,
                                                                      isIncrementPossible,
                                                                      isdeccrementPossible,
                                                                      seatCount,
                                                                    );
                                                                  } else {
                                                                    showModalBottomSheetForSendingRequest(
                                                                        context,
                                                                        campaignsDataModal.availableSeats -
                                                                            campaignsDataModal
                                                                                .bookedSeats,
                                                                        int.parse(campaignsDataModal
                                                                            .seatCost),
                                                                        campaignsDataModal
                                                                            .campaignId,
                                                                        campaignsDataModal
                                                                            .driverId,
                                                                        campaignsDataModal
                                                                            .isNowRide);
                                                                  }
                                                                },
                                                                child: Text(
                                                                  'Request',
                                                                  style: GoogleFonts.nunito(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 3,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              );
            }
          });
        });
  }

  int seatCount = 0;
  int passengerOfferPrice = 0;
  bool isIncrementPossible = false;
  bool isdeccrementPossible = false;
}
