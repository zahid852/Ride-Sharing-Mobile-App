import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../data/mapper/mappers.dart';
import '../../../resources/assets_manager.dart';
import '../../../utils/utils.dart';
import '../../settings/components/theme_provider.dart';

class FullPageLocation extends StatefulWidget {
  final String address;
  const FullPageLocation({Key? key, required this.address}) : super(key: key);

  @override
  State<FullPageLocation> createState() => _FullPageLocationState();
}

class _FullPageLocationState extends State<FullPageLocation> {
  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  String mapTheme = EMPTY;
  late Future<LatLng?> _convertStringToAddress;
  final List<Marker> _markerList = [];
  @override
  void initState() {
    _convertStringToAddress = convertAddressToLatLng(widget.address);
    if (ThemeProvider.darkTheme) {
      DefaultAssetBundle.of(context)
          .loadString(MapAssets.darkTheme)
          .then((value) {
        mapTheme = value;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller = Completer();

    super.dispose();
  }

  Future<LatLng?> convertAddressToLatLng(String address) async {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      Location location = locations.first;

      final Uint8List markerIconPickUp =
          await getBytesFromAssets(ImageAssets.pickUpLocation, 100);
      _markerList.add(
        Marker(
          markerId: const MarkerId('pickupId'),
          icon: BitmapDescriptor.fromBytes(markerIconPickUp),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: const InfoWindow(title: 'Pick Up Location'),
        ),
      );
      return LatLng(location.latitude, location.longitude);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                // size: 20,
              ),
            ),
          ),
          title: Text(
            'Pick Up Location',
            softWrap: true,
            style: GoogleFonts.nunito(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ),
        body: FutureBuilder<LatLng?>(
            future: _convertStringToAddress,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Shimmer.fromColors(
                  baseColor: Utils(context: context).baseShimmerColor,
                  highlightColor: Utils(context: context).highlightShimmerColor,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Utils(context: context).widgetShimmerColor,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Something went wrong.',
                    softWrap: true,
                    style: GoogleFonts.nunito(
                        color: Colors.grey[800],
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                );
              } else if (snapshot.data == null) {
                return Center(
                  child: Text(
                    'No location found.',
                    softWrap: true,
                    style: GoogleFonts.nunito(
                        color: Colors.grey[800],
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                );
              } else {
                LatLng latLng = snapshot.data!;
                return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: snapshot.connectionState == ConnectionState.waiting
                        ? Shimmer.fromColors(
                            baseColor: Utils(context: context).baseShimmerColor,
                            highlightColor:
                                Utils(context: context).highlightShimmerColor,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color:
                                    Utils(context: context).widgetShimmerColor,
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Stack(
                              children: [
                                GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                        latLng.latitude,
                                        latLng.longitude,
                                      ),
                                      zoom: 16),
                                  myLocationEnabled: true,
                                  mapType: MapType.normal,
                                  myLocationButtonEnabled: false,
                                  zoomControlsEnabled: false,
                                  markers: Set<Marker>.of(_markerList),
                                  onMapCreated:
                                      (GoogleMapController controller) async {
                                    if (ThemeProvider.darkTheme) {
                                      controller.setMapStyle(mapTheme);
                                    }

                                    _controller.complete(controller);
                                  },
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: SizedBox(
                                    width: getWidth(context: context) * 0.9,
                                    child: Card(
                                      color: Colors.white,
                                      margin: const EdgeInsets.only(top: 12),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: BorderSide(
                                              color: Colors.grey[400]!,
                                              width: 0.3)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 14),
                                        child: Text(
                                          widget.address,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          softWrap: true,
                                          style: GoogleFonts.nunito(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: SizedBox(
                                      height: 50,
                                      width: getWidth(context: context) * 0.9,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12))),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Back',
                                            style: GoogleFonts.nunito(
                                                fontSize: 17,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ));
              }
            }),
      ),
    );
  }
}
