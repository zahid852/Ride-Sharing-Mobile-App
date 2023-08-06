import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/helpers/location_helper.dart';
import 'package:lift_app/presentations/home/settings/components/theme_provider.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:uuid/uuid.dart';
import '../../../../data/mapper/mappers.dart';
import '../../../../helpers/polyline_response_model.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/routes_manager.dart' as navigationRoutes;

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({Key? key}) : super(key: key);

  @override
  State<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final TextEditingController _pickUpLocationController =
      TextEditingController();
  final TextEditingController _destinationLocationController =
      TextEditingController();
  LatLng? _location;
  final FToast _fToast = FToast();
  final FToast _fToastRequest = FToast();
  bool isFormClosed = false;
  final FocusNode _pickUpLocationFocusNode = FocusNode();
  final FocusNode _destinationLocationFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  Future<void>? _getCurrentLocation;
  final Key _pickKey = GlobalKey<FormFieldState>();
  final Key _destinationKey = GlobalKey<FormFieldState>();
  Future<List<dynamic>>? getSuggestions;
  bool _internetConnection = true;
  String? distance;
  String? time;
  late CameraPosition cameraPosition;
  List<Marker> _markerList = [];
  var uuid = const Uuid();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  List<Polyline> _polyLines = [];
  late Future getData;
  String mapTheme = EMPTY;
  bool isKeyboard = false;
  Location? pickUpLocation;
  Location? destinationLocation;
  LatLng? _latLngForZooming;
  PolylineRoute _polylineRoute = PolylineRoute();
  bool _internetConnectionForMap = true;
  String sessionToken = EMPTY;
  LocationEntries? _locationEntries;

  @override
  void initState() {
    _fToast.init(context);
    _fToastRequest.init(context);

    getConnectivity();
    _pickUpLocationController.addListener(() {
      _onChange(input: _pickUpLocationController.text);
    });
    _destinationLocationController.addListener(() {
      _onChange(input: _destinationLocationController.text);
    });
    _getCurrentLocation = getCurrentLatLng();

    if (ThemeProvider.darkTheme) {
      DefaultAssetBundle.of(context)
          .loadString(MapAssets.darkTheme)
          .then((value) {
        mapTheme = value;
      });
    }
    super.initState();
  }

  void _onChange({required String input}) {
    if (sessionToken == EMPTY) {
      setState(() {
        sessionToken = uuid.v4();
      });
    }

    getSuggestions = LocationHelper.getSuggestions(
        input,
        _location?.latitude ?? ZERO.toDouble(),
        _location?.longitude ?? ZERO.toDouble(),
        sessionToken);
    setState(() {});
  }

  @override
  void dispose() {
    _controller = Completer();
    _connectivitySubscription.cancel();
    _pickUpLocationController.dispose();
    _destinationLocationController.dispose();
    _pickUpLocationFocusNode.dispose();
    _destinationLocationFocusNode.dispose();

    super.dispose();
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
      setState(() {});
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

  Future<bool> _checkingInternetConnection() async {
    return await InternetConnectionChecker().hasConnection;
  }

  void getConnectivity() async {
    final connection = await _checkingInternetConnection();
    if (!connection) {
      setState(() {
        _internetConnection = false;
        _internetConnectionForMap = false;
      });
    }

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
                  _getCurrentLocation = getCurrentLatLng();
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'))
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    isKeyboard = viewInsetsBottom != 0;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
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
                                _fToast.removeQueuedCustomToasts();
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 22,
                              ))),
                      Text(
                        'Select locations',
                        style: GoogleFonts.nunito(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                _internetConnection == false
                    ? noInternetConnectionWidget(
                        size: MediaQuery.of(context).size)
                    : Expanded(
                        child: Stack(
                          children: [
                            FutureBuilder(
                                future: _getCurrentLocation,
                                builder: (ctx, snapshot) {
                                  if (snapshot.hasError) {
                                    return Shimmer.fromColors(
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
                                    );
                                  }
                                  return AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: snapshot.connectionState ==
                                              ConnectionState.waiting
                                          ? Shimmer.fromColors(
                                              baseColor: Utils(context: context)
                                                  .baseShimmerColor,
                                              highlightColor:
                                                  Utils(context: context)
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
                                          : GoogleMap(
                                              initialCameraPosition:
                                                  cameraPosition,
                                              myLocationEnabled: true,
                                              onCameraMove: (position) {
                                                setState(() {
                                                  _latLngForZooming = LatLng(
                                                      position.target.latitude,
                                                      position
                                                          .target.longitude);
                                                });
                                              },
                                              // padding: EdgeInsets.only(
                                              //     bottom: getHeight(context: context) * 0.715),
                                              mapType: MapType.normal,

                                              polylines:
                                                  Set<Polyline>.of(_polyLines),
                                              myLocationButtonEnabled: false,
                                              zoomControlsEnabled: false,
                                              markers:
                                                  Set<Marker>.of(_markerList),

                                              onMapCreated: (GoogleMapController
                                                  controller) async {
                                                if (ThemeProvider.darkTheme) {
                                                  controller
                                                      .setMapStyle(mapTheme);
                                                }

                                                _controller
                                                    .complete(controller);
                                              },
                                            ));
                                }),
                            (distance == null || time == null)
                                ? const SizedBox.shrink()
                                : Positioned(
                                    top: 1.5,
                                    left: 15,
                                    child: Card(
                                      color: Colors.white,
                                      margin: EdgeInsets.only(
                                          top: !_internetConnectionForMap
                                              ? 74
                                              : 12),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: BorderSide(
                                              color: Colors.grey[400]!,
                                              width: 0.3)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Distance : ',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  distance ?? '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 15,
                                                      color: Colors.lightGreen,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    'Time : ',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  time ?? '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 15,
                                                      color: Colors.lightGreen,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            Positioned(
                              top: _internetConnectionForMap ? 9 : 71,
                              right: 10.5,
                              child: Container(
                                height: 54,
                                width: 49,
                                padding: const EdgeInsets.all(4.0),
                                child: FloatingActionButton(
                                  elevation: 2,
                                  backgroundColor: ThemeProvider.darkTheme
                                      ? Colors.black
                                      : Colors.white,
                                  onPressed: () {
                                    setInitialLocation();
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      side: BorderSide(
                                          color: ThemeProvider.darkTheme
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
                              top: _internetConnectionForMap ? 63 : 125,
                              right: 11,
                              child: SizedBox(
                                width: 48.5,
                                child: Card(
                                  elevation: 2,
                                  color: ThemeProvider.darkTheme
                                      ? Colors.black
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      side: BorderSide(
                                          color: ThemeProvider.darkTheme
                                              ? Colors.grey[600]!
                                              : Colors.grey[300]!)),
                                  child: Column(
                                    children: <Widget>[
                                      IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () async {
                                            final GoogleMapController
                                                controller =
                                                await _controller.future;
                                            var currentZoomLevel =
                                                await controller.getZoomLevel();

                                            currentZoomLevel =
                                                currentZoomLevel + 1;
                                            if (_latLngForZooming != null) {
                                              controller.animateCamera(
                                                CameraUpdate.newCameraPosition(
                                                  CameraPosition(
                                                    target: _latLngForZooming!,
                                                    zoom: currentZoomLevel,
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
                                          icon: const Icon(Icons.remove),
                                          onPressed: () async {
                                            final GoogleMapController
                                                controller =
                                                await _controller.future;
                                            var currentZoomLevel =
                                                await controller.getZoomLevel();
                                            currentZoomLevel =
                                                currentZoomLevel - 1;
                                            if (currentZoomLevel < 0) {
                                              currentZoomLevel = 0;
                                            }
                                            if (_latLngForZooming != null) {
                                              controller.animateCamera(
                                                CameraUpdate.newCameraPosition(
                                                  CameraPosition(
                                                    target: _latLngForZooming!,
                                                    zoom: currentZoomLevel,
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
                              bottom: !isFormClosed ? 0 : 10,
                              left: !isFormClosed ? 0 : 15,
                              right: !isFormClosed ? 0 : 15,
                              child: isFormClosed
                                  ? _locationEntries != null
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isFormClosed = false;
                                                  });
                                                },
                                                icon: const Icon(
                                                  IconlyBold.arrow_up_circle,
                                                  size: 40,
                                                )),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: 50,
                                              width: getWidth(context: context),
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8))),
                                                  onPressed: () {
                                                    _fToast
                                                        .removeQueuedCustomToasts();
                                                    Navigator.of(context)
                                                        .pop(_locationEntries);
                                                  },
                                                  child: Text(
                                                    'Done',
                                                    style: GoogleFonts.nunito(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        )
                                      : InkWell(
                                          onTap: () {
                                            setState(() {
                                              isFormClosed = false;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 10),
                                            decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black38,
                                                    offset: Offset(0, 1.5),
                                                    blurRadius: 1,
                                                    spreadRadius: 0.1),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.lightGreen,
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Text(
                                                      'Pick Locations',
                                                      style: GoogleFonts.nunito(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          isFormClosed = false;
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        IconlyBold
                                                            .arrow_up_circle,
                                                        size: 28,
                                                        color: Colors.white,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                  : Material(
                                      elevation: 20,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                            isKeyboard ? 0 : 30),
                                        topRight: Radius.circular(
                                            isKeyboard ? 0 : 30),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.only(top: 1),
                                        decoration: BoxDecoration(
                                          color: ThemeProvider.darkTheme
                                              ? Colors.grey[800]
                                              : Colors.grey[300],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                isKeyboard ? 0 : 30),
                                            topRight: Radius.circular(
                                                isKeyboard ? 0 : 30),
                                          ),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // border: Border.all(
                                            //     color: Colors.grey[300]!),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  isKeyboard ? 0 : 30),
                                              topRight: Radius.circular(
                                                  isKeyboard ? 0 : 30),
                                            ),
                                            color: ThemeProvider.darkTheme
                                                ? Colors.grey[900]
                                                : Colors.white,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          height: isKeyboard
                                              ? getHeight(context: context) -
                                                  viewInsetsBottom -
                                                  getHeight(context: context) *
                                                      0.1
                                              : getHeight(context: context) *
                                                  0.36,
                                          width: getWidth(context: context),
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                              children: [
                                                !_internetConnectionForMap &&
                                                        isKeyboard
                                                    ? const SizedBox(
                                                        height: 60,
                                                      )
                                                    : const SizedBox.shrink(),
                                                Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          !isKeyboard
                                                              ? {
                                                                  setState(() {
                                                                    isFormClosed =
                                                                        true;
                                                                  })
                                                                }
                                                              : FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                        },
                                                        icon: const Icon(
                                                          IconlyBold
                                                              .arrow_down_circle,
                                                          size: 28,
                                                        ))),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                (!_pickUpLocationFocusNode
                                                            .hasFocus &&
                                                        isKeyboard)
                                                    ? const SizedBox.shrink()
                                                    : TextFormField(
                                                        key: _pickKey,
                                                        controller:
                                                            _pickUpLocationController,
                                                        focusNode:
                                                            _pickUpLocationFocusNode,
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return "Enter name";
                                                          }

                                                          return null;
                                                        },
                                                        decoration:
                                                            const InputDecoration(
                                                          prefixIcon: Icon(
                                                            Icons.location_on,
                                                            size: 25,
                                                          ),
                                                          label: Text(
                                                            'PICK UP LOCATION',
                                                          ),
                                                        ),
                                                      ),
                                                isKeyboard
                                                    ? const SizedBox.shrink()
                                                    : const SizedBox(
                                                        height: 25,
                                                      ),
                                                (!_destinationLocationFocusNode
                                                            .hasFocus &&
                                                        isKeyboard)
                                                    ? const SizedBox.shrink()
                                                    : TextFormField(
                                                        key: _destinationKey,
                                                        controller:
                                                            _destinationLocationController,
                                                        focusNode:
                                                            _destinationLocationFocusNode,
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return "Enter name";
                                                          }

                                                          return null;
                                                        },
                                                        decoration:
                                                            const InputDecoration(
                                                          prefixIcon: Icon(
                                                            Icons.location_on,
                                                            size: 25,
                                                          ),
                                                          label: Text(
                                                            'DESTINATION LOCATION',
                                                          ),
                                                        ),
                                                      ),
                                                !isKeyboard
                                                    ? const SizedBox.shrink()
                                                    : Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              6))),
                                                                  onPressed:
                                                                      !_internetConnectionForMap
                                                                          ? null
                                                                          : () {
                                                                              _chooseOnGoogleMap(context: context);
                                                                            },
                                                                  child: Text(
                                                                    'Choose on map',
                                                                    style: GoogleFonts
                                                                        .nunito(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                !isKeyboard
                                                    ? const SizedBox.shrink()
                                                    : Expanded(
                                                        child:
                                                            !_internetConnectionForMap
                                                                ? Center(
                                                                    child:
                                                                        SizedBox(
                                                                    width: getWidth(
                                                                            context:
                                                                                context) *
                                                                        0.7,
                                                                    child: Text(
                                                                      'Please check your internet connection.',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: GoogleFonts
                                                                          .nunito(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ))
                                                                : FutureBuilder(
                                                                    future:
                                                                        getSuggestions,
                                                                    builder: (ctx,
                                                                        snapshot) {
                                                                      if (ConnectionState
                                                                              .waiting ==
                                                                          snapshot
                                                                              .connectionState) {
                                                                        return ListView.builder(
                                                                            padding: const EdgeInsets.only(bottom: 5, top: 5),
                                                                            physics: const NeverScrollableScrollPhysics(),
                                                                            itemCount: 10,
                                                                            itemBuilder: (ctx, index) {
                                                                              return Column(
                                                                                children: [
                                                                                  const SizedBox(
                                                                                    height: 8,
                                                                                  ),
                                                                                  Shimmer.fromColors(
                                                                                    baseColor: Utils(context: context).baseShimmerColor,
                                                                                    highlightColor: Utils(context: context).highlightShimmerColor,
                                                                                    child: Container(
                                                                                      width: getWidth(context: context) * 0.9,
                                                                                      height: 70,
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(6),
                                                                                        color: Utils(context: context).widgetShimmerColor,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            });
                                                                        // return const Center(
                                                                        //   child:
                                                                        //       CircularProgressIndicator(),
                                                                        // );
                                                                      }
                                                                      if (snapshot
                                                                          .hasError) {
                                                                        return Center(
                                                                            child:
                                                                                SizedBox(
                                                                          width:
                                                                              getWidth(context: context) * 0.7,
                                                                          child:
                                                                              Text(
                                                                            'Failed to load data. Please try again.',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                GoogleFonts.nunito(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ));
                                                                      }
                                                                      if (snapshot
                                                                              .data ==
                                                                          null) {
                                                                        return const SizedBox
                                                                            .shrink();
                                                                      } else if (snapshot
                                                                              .data !=
                                                                          null) {
                                                                        if (snapshot
                                                                            .data!
                                                                            .isEmpty) {
                                                                          return const SizedBox
                                                                              .shrink();
                                                                        }
                                                                      }
                                                                      return ListView.builder(
                                                                          physics: const BouncingScrollPhysics(),
                                                                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                                                                          itemCount: snapshot.data!.length,
                                                                          itemBuilder: (contxt, index) {
                                                                            //city filtering later
                                                                            return Column(
                                                                              children: [
                                                                                Divider(
                                                                                  color: ThemeProvider.darkTheme ? Colors.grey[700] : Colors.grey[300],
                                                                                ),
                                                                                ListTile(
                                                                                    onTap: () {
                                                                                      _tapOnListTile(snapshot: snapshot, index: index);
                                                                                    },
                                                                                    title: Text(
                                                                                      snapshot.data![index]['description'],
                                                                                      style: GoogleFonts.nunito(
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                    )),
                                                                              ],
                                                                            );
                                                                          });
                                                                    }),
                                                      ),
                                                isKeyboard
                                                    ? const SizedBox.shrink()
                                                    : Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            SizedBox(
                                                              height: 50,
                                                              width: getWidth(
                                                                  context:
                                                                      context),
                                                              child:
                                                                  ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(
                                                                                  8))),
                                                                      onPressed: _locationEntries ==
                                                                              null
                                                                          ? null
                                                                          : () {
                                                                              _fToast.removeQueuedCustomToasts();
                                                                              Navigator.of(context).pop(_locationEntries);
                                                                            },
                                                                      child:
                                                                          Text(
                                                                        'Done',
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      )),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            )
                          ],
                        ),
                      ),
              ],
            ),
          )),
        ),
      ),
    );
  }

  void _tapOnListTile(
      {required AsyncSnapshot<List<dynamic>> snapshot,
      required int index}) async {
    FocusScope.of(context).unfocus();
    if (_pickUpLocationFocusNode.hasFocus) {
      _pickUpLocationController.text = snapshot.data![index]['description'];
      try {
        List<Location> pickUpLocationList =
            await locationFromAddress(snapshot.data![index]['description']);

        pickUpLocation = pickUpLocationList.last;
        if (context.mounted) {
          _pickUpLocationCode(context: context);
        }
      } catch (e) {
        _pickUpLocationController.clear();
        setState(() {
          pickUpLocation = null;
        });
      }
    } else {
      _destinationLocationController.text =
          snapshot.data![index]['description'];
      try {
        List<Location> destinationLocationList =
            await locationFromAddress(_destinationLocationController.text);

        destinationLocation = destinationLocationList.last;

        _destinationLocationCode();
      } catch (e) {
        _destinationLocationController.clear();
        setState(() {
          destinationLocation = null;
        });
      }
    }
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

  void _moveCamera(LatLng latLng) async {
    CameraPosition cameraPositio = CameraPosition(target: latLng, zoom: 16);

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPositio));
  }

  void _chooseOnGoogleMap({required BuildContext context}) {
    if (_pickUpLocationFocusNode.hasFocus && pickUpLocation != null) {
      _location = LatLng(pickUpLocation!.latitude, pickUpLocation!.longitude);
    } else if (_destinationLocationFocusNode.hasFocus &&
        destinationLocation != null) {
      _location =
          LatLng(destinationLocation!.latitude, destinationLocation!.longitude);
    } else {
      _location = LatLng(ZERO.toDouble(), ZERO.toDouble());
    }
    Navigator.of(context)
        .pushNamed(navigationRoutes.Routes.chooseLocationOnMap, arguments: [
      _pickUpLocationFocusNode.hasFocus
          ? LocationType.pickUp
          : LocationType.destination,
      _location?.latitude ?? ZERO.toDouble(),
      _location?.longitude ?? ZERO.toDouble()
    ]).then((data) async {
      if (data != null) {
        PickedLocation pickedLocation = data as PickedLocation;

        if (pickedLocation.locationType == LocationType.pickUp) {
          _pickUpLocationController.text = pickedLocation.address;
          try {
            List<Location> pickUpLocationList =
                await locationFromAddress(_pickUpLocationController.text);

            pickUpLocation = pickUpLocationList.last;

            _location =
                LatLng(pickUpLocation!.latitude, pickUpLocation!.longitude);
            if (context.mounted) {
              _pickUpLocationCode(context: context);
            }
          } catch (e) {
            _pickUpLocationController.clear();
            setState(() {
              pickUpLocation = null;
            });
          }
        } else {
          _destinationLocationController.text = pickedLocation.address;
          try {
            List<Location> destinationLocationList =
                await locationFromAddress(_destinationLocationController.text);

            destinationLocation = destinationLocationList.last;
            _location = LatLng(
                destinationLocation!.latitude, destinationLocation!.longitude);

            _destinationLocationCode();
          } catch (e) {
            _destinationLocationController.clear();
            setState(() {
              destinationLocation = null;
            });
          }
        }
      }
    });
  }

  void _pickUpLocationCode({required BuildContext context}) async {
    if (pickUpLocation != null && destinationLocation == null) {
      _markerList = [];
      final Uint8List markerIcon =
          await getBytesFromAssets(ImageAssets.pickUpLocation, 100);
      _markerList.add(
        Marker(
            markerId: const MarkerId('pickUpId'),
            icon: BitmapDescriptor.fromBytes(markerIcon),
            position:
                LatLng(pickUpLocation!.latitude, pickUpLocation!.longitude),
            infoWindow: InfoWindow(
                title: _pickUpLocationController.text,
                snippet: 'Pick Up Location')),
      );
      _moveCamera(LatLng(pickUpLocation!.latitude, pickUpLocation!.longitude));
      setState(() {});
    }
    if (pickUpLocation != null && destinationLocation != null) {
      late BuildContext contx;

      if (context.mounted) {
        showDialog(
            context: context,
            builder: (ctx) {
              contx = ctx;
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
      }

      _polyLines = [];

      try {
        _polylineRoute = await LocationHelper.drawPolyline(
            pickUpLocation!, destinationLocation!, sessionToken);
        if (contx.mounted) {
          Navigator.of(contx).pop();
        }
      } on Exception catch (_) {
        WidgetsBinding.instance.addPersistentFrameCallback((_) {
          if (contx.mounted) {
            Navigator.of(contx).pop();
          }
        });
        _fToastRequest.showToast(
            child: buildToast(
                type: ToastMessageType.failure,
                mes: "Could'nt draw the route. Something went wrong."));
        return;
      }

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
      for (int i = 0;
          i < _polylineRoute.routes![0].legs![0].steps!.length;
          i++) {
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
                  _polylineRoute
                      .routes![0].legs![0].steps![i].endLocation!.lat!,
                  _polylineRoute
                      .routes![0].legs![0].steps![i].endLocation!.lng!),
            ],
            width: 3,
            color: Colors.lightGreen));
      }

      double minLat = _polyLines.first.points.first.latitude;
      double minLong = _polyLines.first.points.first.longitude;
      double maxLat = _polyLines.first.points.first.latitude;
      double maxLong = _polyLines.first.points.first.longitude;

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
      final GoogleMapController controller = await _controller.future;

      // controller.animateCamera(CameraUpdate.newCameraPosition(cameraPositio));
      controller.moveCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(
              southwest: LatLng(minLat, minLong),
              northeast: LatLng(maxLat, maxLong)),
          60));
      _markerList = [];
      final Uint8List markerIconDestination =
          await getBytesFromAssets(ImageAssets.destinationLocation, 100);
      final Uint8List markerIconPickUp =
          await getBytesFromAssets(ImageAssets.pickUpLocation, 100);
      _markerList.add(
        Marker(
            markerId: const MarkerId('pickupId'),
            icon: BitmapDescriptor.fromBytes(markerIconPickUp),
            position:
                LatLng(pickUpLocation!.latitude, pickUpLocation!.longitude),
            infoWindow: InfoWindow(
                title: _pickUpLocationController.text,
                snippet: 'Pick Up Location')),
      );
      _markerList.add(
        Marker(
            markerId: const MarkerId('destinationId'),
            icon: BitmapDescriptor.fromBytes(markerIconDestination),
            position: LatLng(
                destinationLocation!.latitude, destinationLocation!.longitude),
            infoWindow: InfoWindow(
                title: _destinationLocationController.text,
                snippet: 'Destination Location')),
      );
      distance = _polylineRoute.routes![0].legs![0].distance!.text;
      time = _polylineRoute.routes![0].legs![0].duration!.text;
      _locationEntries = LocationEntries(
          pickUpLocation: pickUpLocation!,
          pickLocationAddress: _pickUpLocationController.text,
          destinationLocation: destinationLocation!,
          destinationLocationAddress: _destinationLocationController.text,
          distance: distance!,
          time: time!);
      isFormClosed = true;
      setState(() {});
    }
  }

  void _destinationLocationCode() async {
    if (pickUpLocation == null && destinationLocation != null) {
      _markerList = [];

      final Uint8List markerIcon =
          await getBytesFromAssets(ImageAssets.destinationLocation, 100);
      _markerList.add(
        Marker(
            markerId: const MarkerId('destinationId'),
            icon: BitmapDescriptor.fromBytes(markerIcon),
            position: LatLng(
                destinationLocation!.latitude, destinationLocation!.longitude),
            infoWindow: InfoWindow(
                title: _destinationLocationController.text,
                snippet: 'Destination Location')),
      );
      _moveCamera(LatLng(
          destinationLocation!.latitude, destinationLocation!.longitude));

      setState(() {});
    }
    if (pickUpLocation != null && destinationLocation != null) {
      _polyLines = [];
      late BuildContext contx;
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (ctx) {
              contx = ctx;

              return const Center(
                child: CircularProgressIndicator(),
              );
            });
      }
      try {
        _polylineRoute = await LocationHelper.drawPolyline(
            pickUpLocation!, destinationLocation!, sessionToken);

        if (contx.mounted) {
          Navigator.of(contx).pop();
        }
      } on Exception catch (_) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (contx.mounted) {
            Navigator.of(contx).pop();
          }
        });
        _fToastRequest.showToast(
            child: buildToast(
                type: ToastMessageType.failure,
                mes: "Could'nt draw the route. Something went wrong."));

        return;
      }
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
      for (int i = 0;
          i < _polylineRoute.routes![0].legs![0].steps!.length;
          i++) {
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
                  _polylineRoute
                      .routes![0].legs![0].steps![i].endLocation!.lat!,
                  _polylineRoute
                      .routes![0].legs![0].steps![i].endLocation!.lng!),
            ],
            width: 3,
            color: Colors.lightGreen));
      }

      double minLat = polyLinesForCentring.first.points.first.latitude;
      double minLong = polyLinesForCentring.first.points.first.longitude;
      double maxLat = polyLinesForCentring.first.points.first.latitude;
      double maxLong = polyLinesForCentring.first.points.first.longitude;

      for (var poly in polyLinesForCentring) {
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
      final GoogleMapController controller = await _controller.future;

      // controller.animateCamera(CameraUpdate.newCameraPosition(cameraPositio));
      controller.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(
              southwest: LatLng(minLat, minLong),
              northeast: LatLng(maxLat, maxLong)),
          60));
      _markerList = [];
      final Uint8List markerIconDestination =
          await getBytesFromAssets(ImageAssets.destinationLocation, 100);
      final Uint8List markerIconPickUp =
          await getBytesFromAssets(ImageAssets.pickUpLocation, 100);
      _markerList.add(
        Marker(
            markerId: const MarkerId('pickupId'),
            icon: BitmapDescriptor.fromBytes(markerIconPickUp),
            position:
                LatLng(pickUpLocation!.latitude, pickUpLocation!.longitude),
            infoWindow: InfoWindow(
                title: _pickUpLocationController.text,
                snippet: 'Pick Up  Location')),
      );
      _markerList.add(
        Marker(
            markerId: const MarkerId('destinationId'),
            icon: BitmapDescriptor.fromBytes(markerIconDestination),
            position: LatLng(
                destinationLocation!.latitude, destinationLocation!.longitude),
            infoWindow: InfoWindow(
                title: _destinationLocationController.text,
                snippet: 'Destination  Location')),
      );

      distance = _polylineRoute.routes![0].legs![0].distance!.text;
      time = _polylineRoute.routes![0].legs![0].duration!.text;
      _locationEntries = LocationEntries(
          pickUpLocation: pickUpLocation!,
          pickLocationAddress: _pickUpLocationController.text,
          destinationLocation: destinationLocation!,
          destinationLocationAddress: _destinationLocationController.text,
          distance: distance!,
          time: time!);
      isFormClosed = true;
      setState(() {});
    }
  }
}
