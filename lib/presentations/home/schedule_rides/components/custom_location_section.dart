import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../data/mapper/mappers.dart';
import '../../../resources/assets_manager.dart';
import '../../settings/components/theme_provider.dart';

class CustomMapSection extends StatefulWidget {
  final String stringAddress;

  const CustomMapSection({Key? key, required this.stringAddress})
      : super(key: key);

  @override
  State<CustomMapSection> createState() => _CustomMapSectionState();
}

class _CustomMapSectionState extends State<CustomMapSection> {
  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  String mapTheme = EMPTY;
  late Future<LatLng?> _convertStringToAddress;
  // final List<Marker> _markerList = [];
  @override
  void initState() {
    _convertStringToAddress = convertAddressToLatLng(widget.stringAddress);
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

      // final Uint8List markerIconPickUp =
      //     await getBytesFromAssets(ImageAssets.pinIcon, 100);
      // _markerList.add(
      //   Marker(
      //       markerId: const MarkerId('pickupId'),
      //       icon: BitmapDescriptor.fromBytes(markerIconPickUp),
      //       position: LatLng(location.latitude, location.longitude),
      //       infoWindow: InfoWindow(
      //           title: widget.stringAddress, snippet: 'Pick Up Location')),
      // );
      return LatLng(location.latitude, location.longitude);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(6)),
      height: getHeight(context: context) * 0.2,
      width: double.infinity,
      child: FutureBuilder<LatLng?>(
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
                              color: Utils(context: context).widgetShimmerColor,
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
                                    zoom: 14),
                                myLocationEnabled: true,
                                mapType: MapType.normal,
                                myLocationButtonEnabled: false,
                                zoomControlsEnabled: false,
                                // markers: Set<Marker>.of(_markerList),
                                onMapCreated:
                                    (GoogleMapController controller) async {
                                  if (ThemeProvider.darkTheme) {
                                    controller.setMapStyle(mapTheme);
                                  }

                                  _controller.complete(controller);
                                },
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Tooltip(
                                    preferBelow: false,
                                    decoration: BoxDecoration(
                                        color: Colors.lightGreen,
                                        borderRadius: BorderRadius.circular(4)),
                                    textStyle: GoogleFonts.nunito(
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                    message: 'Pick Up Location',
                                    triggerMode: TooltipTriggerMode.tap,
                                    child:
                                        Image.asset(ImageAssets.pickUpLocation),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ));
            }
          }),
    );
  }
}
