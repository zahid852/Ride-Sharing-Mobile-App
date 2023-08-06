import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lift_app/presentations/home/settings/components/theme_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lift_app/data/mapper/mappers.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/helpers/location_helper.dart';
import 'package:lift_app/presentations/resources/assets_manager.dart';
import 'package:lift_app/presentations/utils/utils.dart';

import 'package:geolocator/geolocator.dart';

class ChooseLocationOnMapScreen extends StatefulWidget {
  final LocationType whichLocation;
  final double currentLatitude;
  final double currentLongitude;
  const ChooseLocationOnMapScreen(
      {Key? key,
      required this.whichLocation,
      required this.currentLatitude,
      required this.currentLongitude})
      : super(key: key);

  @override
  State<ChooseLocationOnMapScreen> createState() =>
      _ChooseLocationOnMapScreenState();
}

class _ChooseLocationOnMapScreenState extends State<ChooseLocationOnMapScreen> {
  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  LatLng? location;
  final FToast _fToast = FToast();

  bool _internetConnection = true;
  String _address = EMPTY;
  bool _internetConnectionForMap = true;
  Future<void>? _getCurrentLocation;
  late CameraPosition cameraPosition;
  String mapTheme = EMPTY;
  @override
  void initState() {
    _fToast.init(context);

    if (widget.currentLatitude == ZERO.toDouble() ||
        widget.currentLongitude == ZERO.toDouble()) {
      _getCurrentLocation = getCurrentLatLng();
    } else {
      cameraPosition = CameraPosition(
          target: LatLng(widget.currentLatitude, widget.currentLongitude),
          zoom: 16);
      location = LatLng(widget.currentLatitude, widget.currentLongitude);

      getAddressFromLatLng();
    }
    if (ThemeProvider.darkTheme) {
      DefaultAssetBundle.of(context)
          .loadString(MapAssets.darkTheme)
          .then((value) {
        mapTheme = value;
      });
    }
    getConnectivity();

    super.initState();
  }

  void locationErrorDialogs({required title, required content}) async {
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
                  getCurrentLatLng();

                  Navigator.of(context).pop();
                },
                child: const Text('Ok'))
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller = Completer();
    _connectivitySubscription.cancel();

    super.dispose();
  }

  void setInitialLocation() async {
    Position position = await determinePosition();

    location = LatLng(position.latitude, position.longitude);
    cameraPosition = CameraPosition(
        target: LatLng(
          location!.latitude,
          location!.longitude,
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

      cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 16);
      location = LatLng(position.latitude, position.longitude);

      getAddressFromLatLng();
    } catch (error) {
      if (error.toString() ==
              LocationErrorType.locationServiceError.toString() ||
          error
              .toString()
              .contains('The location service on the device is disabled')) {
        locationErrorDialogs(
            title: 'Location Service Disabled',
            content:
                'Please enable location service to get your current location');
      } else if (error.toString() ==
          LocationErrorType.locationPermissionForeverError.toString()) {
        locationErrorDialogs(
            title: 'Location Permission Denied Forever',
            content:
                'Go to app permissions in the settings, allow location in lift app');
      } else {
        locationErrorDialogs(
            title: 'Location Permission Denied',
            content: 'Please allow location to be used in lift app');
      }
    }
  }

  void getConnectivity() async {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((event) async {
      final connection = await InternetConnectionChecker().hasConnection;
      if (!connection) {
        _fToast.showToast(
            gravity: ToastGravity.TOP,
            positionedToastBuilder: (context, child) {
              return Positioned(
                top: 100,
                left: 20,
                right: 20,
                child: child,
              );
            },
            toastDuration: const Duration(days: 365),
            child: buildMainToast(mes: 'No internet connection'));

        setState(() {
          _internetConnectionForMap = false;
        });
      }
      if (connection) {
        if (mounted) {
          setState(() {
            _internetConnection = true;
            _internetConnectionForMap = true;
            _fToast.removeQueuedCustomToasts();
          });
        }
      }
    });
  }

  Future<void> getAddressFromLatLng() async {
    try {
      _address = await LocationHelper.getAddressFromLatLng(
          location!.latitude, location!.longitude);
      setState(() {});
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _fToast.removeCustomToast();
        return true;
      },
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          body: SafeArea(
              child: SizedBox(
            height: getHeight(context: context),
            width: getWidth(context: context),
            child: Column(
              children: [
                Container(
                  height: getHeight(context: context) * 0.0653,
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
                                _fToast.removeCustomToast();
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 22,
                              ))),
                      Padding(
                        padding: const EdgeInsets.only(left: 60, right: 40),
                        child: Text(
                          'Choose ${widget.whichLocation == LocationType.pickUp ? 'pick up' : 'destination'} location',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                _internetConnection == false
                    ? noInternetConnectionWidget(
                        size: MediaQuery.of(context).size)
                    : Expanded(
                        child: FutureBuilder(
                            future: _getCurrentLocation,
                            builder: (ctx, snapshot) {
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 1500),
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
                                    : Stack(children: [
                                        GoogleMap(
                                          initialCameraPosition: cameraPosition,
                                          myLocationEnabled: true,
                                          myLocationButtonEnabled: false,
                                          zoomControlsEnabled: false,
                                          // myLocationButtonEnabled: true,
                                          // padding: EdgeInsets.only(
                                          //     bottom: getHeight(context: context) * 0.715),
                                          mapType: MapType.normal,

                                          onCameraMove: (position) {
                                            if (widget.currentLatitude !=
                                                    position.target.latitude ||
                                                widget.currentLongitude !=
                                                    position.target.longitude) {
                                              setState(() {
                                                location = position.target;

                                                _address = EMPTY;
                                              });
                                            }
                                          },
                                          onCameraIdle: () {
                                            getAddressFromLatLng();
                                          },
                                          onMapCreated: (GoogleMapController
                                              controller) async {
                                            if (ThemeProvider.darkTheme) {
                                              controller.setMapStyle(mapTheme);
                                            }

                                            _controller.complete(controller);
                                          },
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: 11,
                                              bottom:
                                                  getHeight(context: context) *
                                                      0.2),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              height: 54,
                                              width: 49,
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: FloatingActionButton(
                                                elevation: 1,
                                                backgroundColor:
                                                    ThemeProvider.darkTheme
                                                        ? Colors.black
                                                        : Colors.white,
                                                onPressed: () {
                                                  setInitialLocation();
                                                },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                    side: BorderSide(
                                                        color: ThemeProvider
                                                                .darkTheme
                                                            ? Colors.grey[600]!
                                                            : Colors
                                                                .grey[300]!)),
                                                child: const Icon(
                                                  Icons.my_location,
                                                  color: Colors.lightGreen,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: ((getHeight(context: context) *
                                                      0.7) /
                                                  2) +
                                              25,
                                          right: 11,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: SizedBox(
                                              width: 48.5,
                                              child: Card(
                                                elevation: 1,
                                                color: ThemeProvider.darkTheme
                                                    ? Colors.black
                                                    : Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    side: BorderSide(
                                                        color: ThemeProvider
                                                                .darkTheme
                                                            ? Colors.grey[600]!
                                                            : Colors
                                                                .grey[300]!)),
                                                child: Column(
                                                  children: <Widget>[
                                                    IconButton(
                                                        icon: const Icon(
                                                          Icons.add,
                                                        ),
                                                        onPressed: () async {
                                                          final GoogleMapController
                                                              controller =
                                                              await _controller
                                                                  .future;
                                                          var currentZoomLevel =
                                                              await controller
                                                                  .getZoomLevel();

                                                          currentZoomLevel =
                                                              currentZoomLevel +
                                                                  1;
                                                          if (location !=
                                                              null) {
                                                            controller
                                                                .animateCamera(
                                                              CameraUpdate
                                                                  .newCameraPosition(
                                                                CameraPosition(
                                                                  target:
                                                                      location!,
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
                                                      color: ThemeProvider
                                                              .darkTheme
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
                                                              currentZoomLevel -
                                                                  1;
                                                          if (currentZoomLevel <
                                                              0) {
                                                            currentZoomLevel =
                                                                0;
                                                          }
                                                          if (location !=
                                                              null) {
                                                            controller
                                                                .animateCamera(
                                                              CameraUpdate
                                                                  .newCameraPosition(
                                                                CameraPosition(
                                                                  target:
                                                                      location!,
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
                                        ),
                                        _address == EMPTY
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 120),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: CustomPaint(
                                                    painter: CustomStyleArrow(),
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10,
                                                          vertical: 14),
                                                      child: const CircleAvatar(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        radius: 12,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 3,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                        Align(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            height: 45,
                                            width: 45,
                                            child: Tooltip(
                                              preferBelow: false,
                                              decoration: BoxDecoration(
                                                  color: Colors.lightGreen,
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      9, 6, 9, 8),
                                              textStyle: GoogleFonts.nunito(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                              message:
                                                  'Your ${widget.whichLocation == LocationType.pickUp ? 'pick up' : 'destination'} location',
                                              triggerMode:
                                                  TooltipTriggerMode.tap,
                                              child: Image.asset(
                                                widget.whichLocation ==
                                                        LocationType.pickUp
                                                    ? ImageAssets.pickUpLocation
                                                    : ImageAssets
                                                        .destinationLocation,
                                              ),
                                            ),
                                          ),
                                        ),
                                        _address == EMPTY
                                            ? const SizedBox.shrink()
                                            : Align(
                                                alignment: Alignment.topCenter,
                                                child: SizedBox(
                                                  width: getWidth(
                                                          context: context) *
                                                      0.9,
                                                  child: Card(
                                                    color: Colors.white,
                                                    margin: EdgeInsets.only(
                                                        top:
                                                            !_internetConnectionForMap
                                                                ? 74
                                                                : 12),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .grey[400]!,
                                                                width: 0.3)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 15,
                                                          vertical: 14),
                                                      child: Text(
                                                        _address,
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 3,
                                                        softWrap: true,
                                                        style:
                                                            GoogleFonts.nunito(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child: SizedBox(
                                              height: 50,
                                              width:
                                                  getWidth(context: context) *
                                                      0.9,
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8))),
                                                  onPressed: _address == EMPTY
                                                      ? null
                                                      : () {
                                                          Navigator.of(context)
                                                              .pop(PickedLocation(
                                                                  widget
                                                                      .whichLocation,
                                                                  _address,
                                                                  location!));
                                                        },
                                                  child: Text(
                                                    'Done',
                                                    style: GoogleFonts.nunito(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ]),
                              );
                            }))
              ],
            ),
          )),
        ),
      ),
    );
  }
}
