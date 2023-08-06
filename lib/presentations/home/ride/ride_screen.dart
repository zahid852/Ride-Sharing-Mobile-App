import 'dart:async';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/helpers/polyline_response_model.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';
import 'package:lift_app/presentations/home/ride/ride_view_model.dart';
import 'package:lift_app/presentations/resources/routes_manager.dart'
    as navigationRoutes;

import 'package:lottie/lottie.dart' as lottie;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../data/mapper/mappers.dart';
import '../../../data/network/failure.dart';
import '../../../helpers/location_helper.dart';
import '../../resources/assets_manager.dart';

import '../../utils/notifications_service.dart';
import '../../utils/utils.dart';

import '../messages/messages_view_model.dart';
import '../settings/components/theme_provider.dart';

class RideScreen extends StatefulWidget {
  final ScheduleRideDataModal scheduleRideDataModal;

  const RideScreen({Key? key, required this.scheduleRideDataModal})
      : super(key: key);

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  String sessionToken = EMPTY;
  String mapTheme = EMPTY;
  late Future<void> _drawRoute;
  bool isEndRide = false;
  late RideViewModel _rideViewModel;
  late CameraPosition cameraPosition;
  bool isLoading = false;
  bool isError = false;
  String errorMessage = EMPTY;
  LatLng? _latLngForZooming;
  bool isFormClosed = false;
  List<Marker> _markerList = [];
  LatLng? _location;
  var uuid = const Uuid();
  late GoogleMapController ontroller;
  List<Polyline> _polyLines = [];
  PolylineRoute _polylineRoute = PolylineRoute();
  double minLat = 0;
  double minLong = 0;
  double maxLat = 0;
  double maxLong = 0;
  @override
  void initState() {
    _rideViewModel = Provider.of<RideViewModel>(context, listen: false);
    _drawRoute = drawPolyLine();
    if (ThemeProvider.darkTheme) {
      DefaultAssetBundle.of(context)
          .loadString(MapAssets.darkTheme)
          .then((value) {
        mapTheme = value;
      });
    }
    super.initState();
  }

  void setInitialLocation() async {
    Position position = await determinePosition();

    _location = LatLng(position.latitude, position.longitude);
    cameraPosition = CameraPosition(
        target: LatLng(
          _location!.latitude,
          _location!.longitude,
        ),
        zoom: 16);
    setState(() {});

    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition))
        .then((value) {
      setState(() {});
    });
  }

  Future<void> getCurrentLatLng() async {
    try {
      Position position = await determinePosition();
      _location = LatLng(position.latitude, position.longitude);

      cameraPosition = CameraPosition(
          target: LatLng(
            _location!.latitude,
            _location!.longitude,
          ),
          zoom: 16);
      _latLngForZooming = _location;
    } catch (error) {
      if (error.toString() ==
              LocationErrorType.locationServiceError.toString() ||
          error
              .toString()
              .contains('The location service on the device is disabled')) {
        await locationErrorDialogs(
            title: 'Location Service Disabled',
            content:
                'Please enable location service to get your current location');
        throw 'error';
      } else if (error.toString() ==
          LocationErrorType.locationPermissionForeverError.toString()) {
        await locationErrorDialogs(
            title: 'Location Permission Denied Forever',
            content:
                'Go to app permissions in the settings, allow location in lift app');
        throw 'error';
      } else {
        await locationErrorDialogs(
            title: 'Location Permission Denied',
            content: 'Please allow location to be used in lift app');
        throw 'error';
      }
    }
  }

  Future<void> locationErrorDialogs({required title, required content}) async {
    if (mounted) {
      return await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text(
            content,
            style: GoogleFonts.nunito(),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  _drawRoute = getCurrentLatLng();
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'))
          ],
        ),
      );
    }
  }

  Future<void> drawPolyLine() async {
    _polyLines = [];

    List<Location> startingLocations = await locationFromAddress(
        widget.scheduleRideDataModal.startingLocation);

    Location pickUpLocation = startingLocations.first;
    List<Location> endingLocations =
        await locationFromAddress(widget.scheduleRideDataModal.endingLocation);

    Location destinationLocation = endingLocations.first;

    _polylineRoute = await LocationHelper.drawPolyline(
        pickUpLocation, destinationLocation, '123');

    List<LatLng> latlngList = [];

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLineResultsLists = polylinePoints
        .decodePolyline(_polylineRoute.routes![0].overviewPolyline!.points!);
    if (decodedPolyLineResultsLists.isNotEmpty) {
      for (var pointLatLng in decodedPolyLineResultsLists) {
        latlngList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }
    Polyline polyline = Polyline(
        polylineId: const PolylineId('polylineId'),
        points: latlngList,
        color: Colors.lightGreen,
        width: 3,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap);
    _polyLines.add(polyline);
    List<Polyline> polyLinesForCentring = [];
    for (int i = 0; i < _polylineRoute.routes![0].legs![0].steps!.length; i++) {
      polyLinesForCentring.add(Polyline(
          polylineId: PolylineId(
              _polylineRoute.routes![0].legs![0].steps![i].polyline!.points!),
          points: [
            LatLng(
                _polylineRoute
                    .routes![0].legs![0].steps![i].startLocation!.lat!,
                _polylineRoute
                    .routes![0].legs![0].steps![i].startLocation!.lng!),
            LatLng(
                _polylineRoute.routes![0].legs![0].steps![i].endLocation!.lat!,
                _polylineRoute.routes![0].legs![0].steps![i].endLocation!.lng!),
          ],
          width: 3,
          color: Colors.lightGreen));
    }

    minLat = _polyLines.first.points.first.latitude;
    minLong = _polyLines.first.points.first.longitude;
    maxLat = _polyLines.first.points.first.latitude;
    maxLong = _polyLines.first.points.first.longitude;

    for (var poly in _polyLines) {
      for (var point in poly.points) {
        if (point.latitude < minLat) {
          minLat = point.latitude;
        }
        if (point.latitude > maxLat) {
          maxLat = point.latitude;
        }
        if (point.longitude < minLong) {
          minLong = point.longitude;
        }
        if (point.longitude > maxLong) {
          maxLong = point.longitude;
        }
      }
    }
    cameraPosition = CameraPosition(
        target: LatLng(pickUpLocation.latitude, pickUpLocation.longitude),
        zoom: 14);
    _markerList = [];
    final Uint8List markerIconDestination =
        await getBytesFromAssets(ImageAssets.destinationLocation, 100);
    final Uint8List markerIconPickUp =
        await getBytesFromAssets(ImageAssets.pickUpLocation, 100);
    _markerList.add(
      Marker(
          markerId: const MarkerId('pickupId'),
          icon: BitmapDescriptor.fromBytes(markerIconPickUp),
          position: LatLng(pickUpLocation.latitude, pickUpLocation.longitude),
          infoWindow: InfoWindow(
              title: widget.scheduleRideDataModal.startingLocation,
              snippet: 'Pick Up Location')),
    );
    _markerList.add(
      Marker(
          markerId: const MarkerId('destinationId'),
          icon: BitmapDescriptor.fromBytes(markerIconDestination),
          position: LatLng(
              destinationLocation.latitude, destinationLocation.longitude),
          infoWindow: InfoWindow(
              title: widget.scheduleRideDataModal.endingLocation,
              snippet: 'Destination Location')),
    );
  }

  @override
  void dispose() {
    _controller = Completer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
            body: SizedBox(
          height: getHeight(context: context),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: getHeight(context: context),
                width: getWidth(context: context),
                color: Colors.lightGreen,
                alignment: Alignment.topCenter,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: getWidth(context: context),
                      height: getHeight(context: context) * 0.1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        'Enroute Destination',
                        softWrap: true,
                        style: GoogleFonts.nunito(
                            color: Colors.white,
                            letterSpacing: 0.3,
                            fontSize: 21,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: getHeight(context: context) * 0.86,
                child: FutureBuilder(
                    future: _drawRoute,
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                          baseColor: Utils(context: context).baseShimmerColor,
                          highlightColor:
                              Utils(context: context).highlightShimmerColor,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                              color: Utils(context: context).widgetShimmerColor,
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)),
                          ),
                          child: Center(
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
                                        child: lottie.Lottie.asset(
                                          LottieAssets.failure,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        'Something went wrong. Please ty again.',
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
                                                _drawRoute = drawPolyLine();
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
                          ),
                        );
                      } else {
                        return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? Shimmer.fromColors(
                                    baseColor: Utils(context: context)
                                        .baseShimmerColor,
                                    highlightColor: Utils(context: context)
                                        .highlightShimmerColor,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Utils(context: context)
                                            .widgetShimmerColor,
                                      ),
                                    ),
                                  )
                                : Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30)),
                                        child: GoogleMap(
                                          initialCameraPosition: cameraPosition,
                                          myLocationEnabled: true,
                                          onCameraMove: (position) {
                                            _latLngForZooming = LatLng(
                                                position.target.latitude,
                                                position.target.longitude);
                                          },
                                          mapType: MapType.normal,
                                          polylines:
                                              Set<Polyline>.of(_polyLines),
                                          myLocationButtonEnabled: false,
                                          zoomControlsEnabled: false,
                                          markers: Set<Marker>.of(_markerList),
                                          onMapCreated: (GoogleMapController
                                              controller) async {
                                            if (ThemeProvider.darkTheme) {
                                              controller.setMapStyle(mapTheme);
                                            }

                                            _controller.complete(controller);
                                            controller.moveCamera(
                                                CameraUpdate.newLatLngBounds(
                                                    LatLngBounds(
                                                        southwest: LatLng(
                                                            minLat, minLong),
                                                        northeast: LatLng(
                                                            maxLat, maxLong)),
                                                    100));
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        top: 36,
                                        right: 10.5,
                                        child: Container(
                                          height: 54,
                                          width: 49,
                                          padding: const EdgeInsets.all(4.0),
                                          child: FloatingActionButton(
                                            elevation: 2,
                                            backgroundColor:
                                                ThemeProvider.darkTheme
                                                    ? Colors.black
                                                    : Colors.white,
                                            onPressed: () {
                                              setInitialLocation();
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                                side: BorderSide(
                                                    color: ThemeProvider
                                                            .darkTheme
                                                        ? Colors.grey[600]!
                                                        : Colors.grey[300]!)),
                                            child: const Icon(
                                              Icons.my_location,
                                              color: Colors.lightGreen,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 90,
                                        right: 11,
                                        child: SizedBox(
                                          width: 48.5,
                                          child: Card(
                                            elevation: 2,
                                            color: ThemeProvider.darkTheme
                                                ? Colors.black
                                                : Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                side: BorderSide(
                                                    color: ThemeProvider
                                                            .darkTheme
                                                        ? Colors.grey[600]!
                                                        : Colors.grey[300]!)),
                                            child: Column(
                                              children: <Widget>[
                                                IconButton(
                                                    icon: const Icon(Icons.add),
                                                    onPressed: () async {
                                                      final GoogleMapController
                                                          controller =
                                                          await _controller
                                                              .future;
                                                      var currentZoomLevel =
                                                          await controller
                                                              .getZoomLevel();

                                                      currentZoomLevel =
                                                          currentZoomLevel + 1;
                                                      if (_latLngForZooming !=
                                                          null) {
                                                        controller
                                                            .animateCamera(
                                                          CameraUpdate
                                                              .newCameraPosition(
                                                            CameraPosition(
                                                              target:
                                                                  _latLngForZooming!,
                                                              zoom:
                                                                  currentZoomLevel,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }),

                                                // const SizedBox(height: 2),
                                                Divider(
                                                  height: 2,
                                                  color: ThemeProvider.darkTheme
                                                      ? Colors.grey
                                                      : Colors.grey[300],
                                                ),
                                                IconButton(
                                                    icon: const Icon(
                                                        Icons.remove),
                                                    onPressed: () async {
                                                      final GoogleMapController
                                                          controller =
                                                          await _controller
                                                              .future;
                                                      var currentZoomLevel =
                                                          await controller
                                                              .getZoomLevel();
                                                      currentZoomLevel =
                                                          currentZoomLevel - 1;
                                                      if (currentZoomLevel <
                                                          0) {
                                                        currentZoomLevel = 0;
                                                      }
                                                      if (_latLngForZooming !=
                                                          null) {
                                                        controller
                                                            .animateCamera(
                                                          CameraUpdate
                                                              .newCameraPosition(
                                                            CameraPosition(
                                                              target:
                                                                  _latLngForZooming!,
                                                              zoom:
                                                                  currentZoomLevel,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          bottom: !isFormClosed ? 0 : 15,
                                          left: !isFormClosed ? 0 : 15,
                                          right: !isFormClosed ? 0 : 15,
                                          child: isFormClosed
                                              ? InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isFormClosed = false;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 2,
                                                        horizontal: 10),
                                                    decoration: BoxDecoration(
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            color:
                                                                Colors.black38,
                                                            offset:
                                                                Offset(0, 1.5),
                                                            blurRadius: 1,
                                                            spreadRadius: 0.1),
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: Colors.lightGreen,
                                                    ),
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: Text(
                                                              'Ride details',
                                                              style: GoogleFonts.nunito(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                          IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  isFormClosed =
                                                                      false;
                                                                });
                                                              },
                                                              icon: const Icon(
                                                                IconlyBold
                                                                    .arrow_up_circle,
                                                                size: 28,
                                                                color: Colors
                                                                    .white,
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Stack(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 30),
                                                      child: Material(
                                                          elevation: 20,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    30),
                                                            topRight:
                                                                Radius.circular(
                                                                    30),
                                                          ),
                                                          child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 1),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: ThemeProvider
                                                                        .darkTheme
                                                                    ? Colors.grey[
                                                                        800]
                                                                    : Colors.grey[
                                                                        300],
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          30),
                                                                ),
                                                              ),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            30),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            30),
                                                                  ),
                                                                  color: ThemeProvider
                                                                          .darkTheme
                                                                      ? Colors.grey[
                                                                          900]
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        15,
                                                                        5,
                                                                        15,
                                                                        12),
                                                                constraints:
                                                                    BoxConstraints(
                                                                  maxHeight:
                                                                      getHeight(
                                                                              context: context) *
                                                                          0.425,
                                                                ),
                                                                width: getWidth(
                                                                    context:
                                                                        context),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            const SizedBox(
                                                                              width: 50,
                                                                            ),
                                                                            IconButton(
                                                                                onPressed: () {
                                                                                  setState(() {
                                                                                    isFormClosed = true;
                                                                                  });
                                                                                },
                                                                                icon: const Icon(
                                                                                  IconlyBold.arrow_down_circle,
                                                                                  size: 28,
                                                                                )),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        ListView.builder(
                                                                            shrinkWrap: true,
                                                                            physics: const BouncingScrollPhysics(),
                                                                            itemCount: widget.scheduleRideDataModal.passengerRequestRide.length,
                                                                            itemBuilder: (ctx, index) {
                                                                              PassengerRequestRideDetails passengerRequestRideDetails = widget.scheduleRideDataModal.passengerRequestRide[index];
                                                                              return Padding(
                                                                                padding: const EdgeInsets.only(bottom: 10),
                                                                                child: GestureDetector(
                                                                                  onTap: () async {
                                                                                    final isReloadData = await Navigator.of(context).pushNamed(navigationRoutes.Routes.passengerDetailsPopUpScreenRoute, arguments: [
                                                                                      widget.scheduleRideDataModal.campaignId,
                                                                                      passengerRequestRideDetails
                                                                                    ]);
                                                                                    if (isReloadData == true) {
                                                                                      setState(() {
                                                                                        widget.scheduleRideDataModal.passengerRequestRide[index].passengerRideStatus = 1;
                                                                                      });
                                                                                    }
                                                                                  },
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                                                                    decoration: BoxDecoration(color: passengerRequestRideDetails.passengerRideStatus != 0 ? Colors.lightGreen.withOpacity(0.12) : Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        CircleAvatar(
                                                                                          radius: 20,
                                                                                          backgroundColor: Colors.lightGreen,
                                                                                          child: CircleAvatar(
                                                                                            radius: 19.5,
                                                                                            child: CachedNetworkImage(
                                                                                              imageUrl: passengerRequestRideDetails.profileImg,
                                                                                              imageBuilder: (context, imageProvider) => Container(
                                                                                                decoration: BoxDecoration(
                                                                                                  shape: BoxShape.circle,
                                                                                                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                                                                ),
                                                                                              ),
                                                                                              errorWidget: (_, url, error) => Container(
                                                                                                decoration: BoxDecoration(
                                                                                                  shape: BoxShape.circle,
                                                                                                  image: DecorationImage(image: Image.asset(ImageAssets.profile).image, fit: BoxFit.cover),
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
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                passengerRequestRideDetails.name,
                                                                                                overflow: TextOverflow.fade,
                                                                                                softWrap: false,
                                                                                                style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700),
                                                                                              ),
                                                                                              passengerRequestRideDetails.pickUpLocation == EMPTY
                                                                                                  ? const SizedBox.shrink()
                                                                                                  : Text(
                                                                                                      passengerRequestRideDetails.pickUpLocation,
                                                                                                      softWrap: false,
                                                                                                      overflow: TextOverflow.fade,
                                                                                                      style: GoogleFonts.nunito(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
                                                                                                    ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        passengerRequestRideDetails.passengerRideStatus != 0
                                                                                            ? Row(
                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                children: [
                                                                                                  const SizedBox(
                                                                                                    width: 30,
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'Picked',
                                                                                                    style: GoogleFonts.nunito(fontSize: 15, color: Colors.lightGreen, fontWeight: FontWeight.w700),
                                                                                                  ),
                                                                                                  const SizedBox(
                                                                                                    width: 2,
                                                                                                  ),
                                                                                                  Image.asset(
                                                                                                    ImageAssets.done,
                                                                                                    height: 25,
                                                                                                    width: 25,
                                                                                                  )
                                                                                                ],
                                                                                              )
                                                                                            : Row(
                                                                                                children: [
                                                                                                  const SizedBox(
                                                                                                    width: 30,
                                                                                                  ),
                                                                                                  InkWell(
                                                                                                    onTap: () {
                                                                                                      // makePhoneCall(passengerRequestRideDetails.);
                                                                                                    },
                                                                                                    child: Card(
                                                                                                      color: Colors.white,
                                                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                                                                                      child: CircleAvatar(
                                                                                                        backgroundColor: Colors.white,
                                                                                                        radius: 17,
                                                                                                        child: ZegoSendCallInvitationButton(
                                                                                                          isVideoCall: false,
                                                                                                          buttonSize: const Size(25, 25),
                                                                                                          iconSize: const Size(25, 25),
                                                                                                          icon: ButtonIcon(
                                                                                                              backgroundColor: Colors.white,
                                                                                                              icon: const Icon(
                                                                                                                Icons.call,
                                                                                                                color: Colors.lightGreen,
                                                                                                                size: 22,
                                                                                                              )),
                                                                                                          resourceID: "zegouikit_call", // For offline call notification
                                                                                                          invitees: [
                                                                                                            ZegoUIKitUser(
                                                                                                              id: passengerRequestRideDetails.userId,
                                                                                                              name: passengerRequestRideDetails.name,
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
                                                                                                        isLoading = true;
                                                                                                        isError = false;
                                                                                                        errorMessage = EMPTY;
                                                                                                      });
                                                                                                      try {
                                                                                                        await Provider.of<MessagesViewModel>(context, listen: false).createChat(CreateChatRequest(widget.scheduleRideDataModal.campaignId, passengerRequestRideDetails.userId));
                                                                                                        setState(() {
                                                                                                          isLoading = false;
                                                                                                          isError = false;
                                                                                                          errorMessage = EMPTY;
                                                                                                        });
                                                                                                        if (context.mounted) {
                                                                                                          Navigator.of(context).pushNamed(navigationRoutes.Routes.messageScreenRoute, arguments: [
                                                                                                            passengerRequestRideDetails.name,
                                                                                                            passengerRequestRideDetails.profileImg,
                                                                                                            Provider.of<MessagesViewModel>(context, listen: false).chatObjectModel
                                                                                                          ]);
                                                                                                        }
                                                                                                      } on Failure catch (error) {
                                                                                                        setState(() {
                                                                                                          isLoading = false;
                                                                                                          isError = true;
                                                                                                          errorMessage = error.message;
                                                                                                        });
                                                                                                      } catch (error) {
                                                                                                        setState(() {
                                                                                                          isLoading = false;
                                                                                                          isError = true;
                                                                                                          errorMessage = 'Something went wrong. Please try again later';
                                                                                                        });
                                                                                                      }
                                                                                                    },
                                                                                                    child: Card(
                                                                                                      color: Colors.white,
                                                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                                                                                      child: const Padding(
                                                                                                        padding: EdgeInsets.all(6.0),
                                                                                                        child: Icon(
                                                                                                          Icons.message,
                                                                                                          color: Colors.lightGreen,
                                                                                                          size: 22,
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
                                                                                                        isLoading = true;
                                                                                                        isError = false;
                                                                                                        errorMessage = EMPTY;
                                                                                                      });
                                                                                                      try {
                                                                                                        await _rideViewModel.pickingPassenger(PickingPassengerRequest(widget.scheduleRideDataModal.campaignId, passengerRequestRideDetails.userId));
                                                                                                        setState(() {
                                                                                                          isLoading = false;
                                                                                                          isError = false;
                                                                                                          errorMessage = EMPTY;
                                                                                                          widget.scheduleRideDataModal.passengerRequestRide[index].passengerRideStatus = 1;
                                                                                                        });
                                                                                                      } on Failure catch (error) {
                                                                                                        setState(() {
                                                                                                          isLoading = false;
                                                                                                          isError = true;
                                                                                                          errorMessage = error.message;
                                                                                                        });
                                                                                                      } catch (error) {
                                                                                                        setState(() {
                                                                                                          isLoading = false;
                                                                                                          isError = true;
                                                                                                          errorMessage = 'Something went wrong. Please try again later';
                                                                                                        });
                                                                                                      }
                                                                                                    },
                                                                                                    child: Card(
                                                                                                      color: Colors.white,
                                                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                                                                                      child: Padding(
                                                                                                        padding: const EdgeInsets.all(6.0),
                                                                                                        child: Icon(
                                                                                                          MdiIcons.seatPassenger,
                                                                                                          size: 22,
                                                                                                          color: Colors.lightGreen,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  )
                                                                                                ],
                                                                                              )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }),
                                                                        SizedBox(
                                                                          height: widget.scheduleRideDataModal.passengerRequestRide.length == 1
                                                                              ? 10
                                                                              : widget.scheduleRideDataModal.passengerRequestRide.isEmpty
                                                                                  ? 0
                                                                                  : 15,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          50,
                                                                      width: getWidth(
                                                                          context:
                                                                              context),
                                                                      child: ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                                                                          onPressed: () async {
                                                                            setState(() {
                                                                              isEndRide = true;
                                                                            });
                                                                          },
                                                                          child: Text(
                                                                            'End Ride',
                                                                            style:
                                                                                GoogleFonts.nunito(
                                                                              fontSize: 17,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          )),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ))),
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      left: 15,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          setState(() {
                                                            isLoading = true;
                                                            isError = false;
                                                          });
                                                          try {
                                                            // List<Location>
                                                            //     startingLocations =
                                                            //     await locationFromAddress(widget
                                                            //         .scheduleRideDataModal
                                                            //         .startingLocation);

                                                            // List<Location>
                                                            //     endingLocations =
                                                            //     await locationFromAddress(widget
                                                            //         .scheduleRideDataModal
                                                            //         .endingLocation);

                                                            // Location
                                                            //     startingLocation =
                                                            //     startingLocations
                                                            //         .first;
                                                            // Location
                                                            //     endingLocation =
                                                            //     endingLocations
                                                            //         .first;
                                                            final String
                                                                googleMapsUrl =
                                                                // 'https://www.google.com/maps/search/?saddr=${startingLocation.latitude},${startingLocation.longitude}&daddr=${endingLocation.latitude},${endingLocation.longitude}';
                                                                'https://www.google.com/maps?saddr=${widget.scheduleRideDataModal.startingLocation}&daddr=${widget.scheduleRideDataModal.endingLocation}';
                                                            await launchUrl(
                                                                Uri.parse(
                                                                    googleMapsUrl));
                                                            setState(() {
                                                              isLoading = false;
                                                              isError = false;
                                                              errorMessage =
                                                                  EMPTY;
                                                            });
                                                          } catch (error) {
                                                            setState(() {
                                                              isLoading = false;
                                                              isError = true;
                                                              errorMessage =
                                                                  'Something went wrong. Please try again later';
                                                            });
                                                          }
                                                        },
                                                        child: Material(
                                                          elevation: 2,
                                                          color: Colors.black12,
                                                          shape:
                                                              const CircleBorder(),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0.5),
                                                            child: CircleAvatar(
                                                                radius: 28,
                                                                backgroundImage:
                                                                    Image.asset(
                                                                  ImageAssets
                                                                      .mapIconImage,
                                                                ).image),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                    ],
                                  ));
                      }
                    }),
              ),
              !isEndRide
                  ? const SizedBox.shrink()
                  : Container(
                      height: getHeight(context: context),
                      width: getWidth(context: context),
                      color: Colors.black87.withOpacity(0.8),
                      child: Center(
                        child: Container(
                          width: getWidth(context: context) * 0.8,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Colors.lightGreen,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 20, bottom: 17),
                                  child: Text(
                                    'Ending Ride',
                                    style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 12, 20),
                                child: Text(
                                  'Are you sure, you want to end your ride?',
                                  style: GoogleFonts.nunito(
                                      color: Colors.grey[800],
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Divider(
                                height: 1,
                              ),
                              TextButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                    isError = false;
                                    isEndRide = false;
                                    errorMessage = EMPTY;
                                  });
                                  try {
                                    await Provider.of<RideViewModel>(context,
                                            listen: false)
                                        .endRide(RideStatusRequest(widget
                                            .scheduleRideDataModal.campaignId));

                                    // SocketImplementation.endRideEmit(
                                    //     passsengersList: widget
                                    //         .scheduleRideDataModal
                                    //         .passengerRequestRide,
                                    //     driverId: widget
                                    //         .scheduleRideDataModal.driverId);

//notification part
                                    NotificationsService.sendPushNotification(
                                        SendNotificationRequest(
                                      _rideViewModel.usersList,
                                      'Notification',
                                      '${CommonData.passengerDataModal.name} has ended ride.',
                                      <String, dynamic>{
                                        'type': 'End_ride',
                                        'campaignId': widget
                                            .scheduleRideDataModal.campaignId,
                                        'driverId': widget
                                            .scheduleRideDataModal.driverId,
                                        'route': '1',
                                        'title': 'Notification',
                                        'body':
                                            '${CommonData.passengerDataModal.name} has ended ride.',
                                        'userImage': CommonData
                                            .passengerDataModal.profileImg,
                                        'userId': _rideViewModel.usersList
                                      },
                                    ));
                                    if (context.mounted) {
                                      Navigator.of(context)
                                          .pushReplacementNamed(navigationRoutes
                                              .Routes.homeRoute);
                                    }
                                  } on Failure catch (error) {
                                    setState(() {
                                      isLoading = false;
                                      isError = true;
                                      isEndRide = false;
                                      errorMessage = error.message;
                                    });
                                  } catch (error) {
                                    setState(() {
                                      isLoading = false;
                                      isError = true;
                                      isEndRide = false;
                                      isEndRide = false;
                                      errorMessage =
                                          'Something went wrong. Please try again later';
                                    });
                                  }
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 13),
                                      child: Text(
                                        'End Ride',
                                        style: GoogleFonts.nunito(
                                            color: Colors.lightGreen,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 1,
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isEndRide = false;
                                  });
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      child: Text(
                                        'Cancel',
                                        style: GoogleFonts.nunito(
                                            color: Colors.grey[800],
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
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
                                child: lottie.Lottie.asset(
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
                                child: lottie.Lottie.asset(
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
        )),
      ),
    );
  }
}
