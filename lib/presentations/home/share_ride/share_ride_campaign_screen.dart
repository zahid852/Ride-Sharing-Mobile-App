import 'dart:developer';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:lift_app/data/mapper/mappers.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/home/share_ride/share_ride_view_model.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';
import 'package:lift_app/presentations/home/settings/components/theme_provider.dart';
import 'package:lift_app/presentations/home/share_ride/sub_screens/location_selection_screen.dart';
import 'package:lift_app/presentations/resources/assets_manager.dart';
import 'package:lift_app/presentations/resources/routes_manager.dart';
import 'package:lift_app/presentations/utils/notifications_service.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../data/network/failure.dart';
import '../../../data/request/request.dart';

// ignore: must_be_immutable
class SharedRideCompaignScreen extends StatefulWidget {
  final void Function() menuButtonFunction;

  const SharedRideCompaignScreen({
    Key? key,
    required this.menuButtonFunction,
  }) : super(key: key);

  @override
  State<SharedRideCompaignScreen> createState() =>
      _SharedRideCompaignScreenState();
}

class _SharedRideCompaignScreenState extends State<SharedRideCompaignScreen> {
  final _formKey = GlobalKey<FormState>();
  final NotificationsService _notificationsService = NotificationsService();
  final TextEditingController _totalAvailableSeatsEditingController =
      TextEditingController();
  final TextEditingController _costPerSeatEditingController =
      TextEditingController();
  final TextEditingController _rideDateEditingController =
      TextEditingController();
  final TextEditingController _rideTimeEditingController =
      TextEditingController();
  final TextEditingController _commentEditingController =
      TextEditingController();
  int _labelIndex = 0;
  bool _isSmokingAllowed = false;
  bool _isMusicAllowed = false;
  bool _haveACService = false;
  bool _showRideDetails = true;
  bool _isLoading = false;
  bool _isError = false;
  bool _isSuccess = false;
  bool rideTimeError = false;
  TimeOfDay? timeOfDay;
  String error = EMPTY;
  LocationEntries? _locationEntries;
  bool? _areLocationsAddedOnValidation;
  final SharedRideViewModel _sharedRideViewModel = SharedRideViewModel();
  void _bind() {
    _totalAvailableSeatsEditingController.addListener(() => _sharedRideViewModel
        .setAvailableSeats(_totalAvailableSeatsEditingController.text));
    _costPerSeatEditingController.addListener(() =>
        _sharedRideViewModel.setSeatCost(_costPerSeatEditingController.text));
    _rideDateEditingController.addListener(() =>
        _sharedRideViewModel.setScheduledDay(_rideDateEditingController.text));
    _rideTimeEditingController.addListener(() =>
        _sharedRideViewModel.setScheduledTime(_rideTimeEditingController.text));
  }

  @override
  void initState() {
    _bind();
    if (CommonData.scheduleRideDataModal != null) {
      _locationEntries = LocationEntries(
          pickUpLocation:
              Location(latitude: 0, longitude: 0, timestamp: DateTime.now()),
          pickLocationAddress:
              CommonData.scheduleRideDataModal!.startingLocation,
          destinationLocation:
              Location(latitude: 0, longitude: 0, timestamp: DateTime.now()),
          destinationLocationAddress:
              CommonData.scheduleRideDataModal!.endingLocation,
          distance: CommonData.scheduleRideDataModal!.expectedRideDistance,
          time: CommonData.scheduleRideDataModal!.expectedRideTime);

      _totalAvailableSeatsEditingController.text =
          CommonData.scheduleRideDataModal!.availableSeats.toString();
      _costPerSeatEditingController.text =
          CommonData.scheduleRideDataModal!.seatCost.toString();
      _rideTimeEditingController.text = EMPTY;
      _rideDateEditingController.text = EMPTY;
      _commentEditingController.text =
          CommonData.scheduleRideDataModal?.comment ?? EMPTY;

      _showRideDetails = true;
      _labelIndex = 1;

      _isSmokingAllowed = CommonData.scheduleRideDataModal!.rideRules.isSmoke;
      _isMusicAllowed = CommonData.scheduleRideDataModal!.rideRules.isMusic;
      _haveACService = CommonData.scheduleRideDataModal!.rideRules.isAc;
      CommonData.scheduleRideDataModal = null;
      _sharedRideViewModel.setLocations(true);
    }
    super.initState();
  }

  @override
  void dispose() {
    // _startLocationEditingController.dispose();
    // _destinationLocationEditingController.dispose();
    _totalAvailableSeatsEditingController.dispose();
    _costPerSeatEditingController.dispose();
    _rideTimeEditingController.dispose();
    _rideDateEditingController.dispose();
    _commentEditingController.dispose();
    _sharedRideViewModel.dispose();
    log('dispose');
    super.dispose();
  }

  DateTime _convertTimeStringToDateTime(DateTime currentDate, String time) {
    TimeOfDay timeOfDay = convertTimeStringToTimeOfDay(time);

    // Create a new DateTime object by combining the current date and TimeOfDay
    DateTime dateTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    return dateTime;
  }

  DateTime _convertTimeOfDayToDateTime(
      DateTime currentDate, TimeOfDay timeOfDay) {
    // Create a new DateTime object by combining the current date and TimeOfDay
    DateTime dateTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    return dateTime;
  }

  Future<void> _postCampaignCode(DateTime currentDate) async {
    await _sharedRideViewModel.postCompaign(SharedRideCompaignRequest(
        CommonData.passengerDataModal.id,
        _locationEntries!.pickLocationAddress,
        _locationEntries!.destinationLocationAddress,
        _labelIndex == 0
            ? currentDate.add(const Duration(minutes: 2)).toString()
            : _convertTimeStringToDateTime(
                    currentDate, _rideTimeEditingController.text)
                .toString(),
        _labelIndex == 0
            ? currentDate.toString()
            : convertDateStringToDateTime(_rideDateEditingController.text)
                .toString(),
        RideRules(_haveACService, _isSmokingAllowed, _isMusicAllowed),
        int.parse(_totalAvailableSeatsEditingController.text),
        double.parse(_costPerSeatEditingController.text),
        _commentEditingController.text,
        _locationEntries!.distance,
        _locationEntries!.time,
        _labelIndex == 0 ? true : false));
    if (_labelIndex == 1) {
      _notificationsService.scheduleNotification(
          convertDateStringToDateTime(_rideDateEditingController.text),
          _convertTimeStringToDateTime(
              DateTime.now(), _rideTimeEditingController.text));
    }

    // if (!mounted) return;
    // if (_profile == true) {
    //   _appPreferences.setUserAsDriver();
    //   Navigator.of(context).pushReplacementNamed(Routes.driverProfileRoute);
    // }
    _formKey.currentState!.reset();
    _commentEditingController.clear();
    _rideDateEditingController.clear();

    _rideTimeEditingController.clear();
    _costPerSeatEditingController.clear();
    _totalAvailableSeatsEditingController.clear();

    final int tempScheduleIndex = _labelIndex;
    final ScheduleRideDataModal sharedRideModelData =
        _sharedRideViewModel.scheduleRideDataModal!;
    setState(() {
      _isLoading = false;
      _locationEntries = null;
      _isSmokingAllowed = false;
      _isMusicAllowed = false;
      _haveACService = false;
      if (tempScheduleIndex == 0) {
        _isSuccess = false;
      } else if (tempScheduleIndex == 1) {
        _isSuccess = true;
      }
      _labelIndex = 0;
      timeOfDay = null;
      _sharedRideViewModel.setLocations(false);
      _sharedRideViewModel.setSchedule(0);
      _sharedRideViewModel.scheduleRideDataModal = null;
    });
    if (tempScheduleIndex == 0) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(Routes.nowRideRoute,
            arguments: sharedRideModelData);
      }
    }
  }

  void _postCompaign() async {
    setState(() {
      _isLoading = true;
    });
    try {
      DateTime currentDate = await NTP.now();

      if (_labelIndex == 1) {
        if (isSameDay(_rideDateEditingController.text, currentDate)) {
          if (isSelectedDateGreaterThanNow(
                  _convertTimeStringToDateTime(
                      DateFormat('dd/MM/yyyy')
                          .parse(_rideDateEditingController.text),
                      _rideTimeEditingController.text),
                  currentDate) &&
              isSelectedTimeGreaterThan15Minutes(
                  _convertTimeStringToDateTime(
                      DateFormat('dd/MM/yyyy')
                          .parse(_rideDateEditingController.text),
                      _rideTimeEditingController.text),
                  currentDate)) {
            await _postCampaignCode(currentDate);
          } else {
            setState(() {
              _isLoading = false;
              _isError = true;
              error =
                  'Please correct your scheduled ride time. It should be at least 15 minutes later than now';
            });
          }
        } else {
          await _postCampaignCode(currentDate);
        }
      } else {
        await _postCampaignCode(currentDate);
      }
    } on Failure catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
        error = e.message;
      });
    } catch (erro) {
      setState(() {
        _isLoading = false;
        _isError = true;
        error = 'Something went wrong. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Consumer<ThemeProvider>(builder: (ctx, themeProvider, _) {
          return SafeArea(
              child: Stack(
            children: [
              SizedBox(
                height: getHeight(context: context),
                width: getWidth(context: context),
                child: Column(children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Stack(
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
                                size: 28,
                              ))),
                      Text(
                        'Post Ride',
                        style: GoogleFonts.nunito(
                            fontSize: 24,
                            color: Colors.lightGreen,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Expanded(
                      child: SizedBox(
                    width: getWidth(context: context),
                    child: SingleChildScrollView(
                      // physics: BouncingScrollPhysics(),

                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 5, 14, 15),
                              child: SizedBox(
                                width: getWidth(context: context) * 0.85,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LocationSelectionScreen(),
                                          ),
                                        ).then((data) {
                                          if (data != null) {
                                            _locationEntries =
                                                data as LocationEntries;

                                            _showRideDetails = true;
                                            if (_areLocationsAddedOnValidation ==
                                                false) {
                                              _areLocationsAddedOnValidation =
                                                  true;
                                            }
                                            _sharedRideViewModel
                                                .setLocations(true);

                                            if (context.mounted) {
                                              setState(() {});
                                            }
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black38,
                                                offset: Offset(
                                                    0,
                                                    _locationEntries == null
                                                        ? 1.6
                                                        : 1.5),
                                                blurRadius: 0.4,
                                                spreadRadius:
                                                    _locationEntries == null
                                                        ? 0.4
                                                        : 0.2),
                                          ],
                                          color: Colors.lightGreen,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Flexible(
                                              flex: 2,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 2),
                                                child: Icon(
                                                  IconlyBold.location,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 11,
                                              child: Text(
                                                '${_locationEntries == null ? 'Enter' : 'Re-enter'} starting, destination locations',
                                                style: GoogleFonts.nunito(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2, right: 2),
                                                child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed(Routes
                                                              .locationSelectionRoute);
                                                    },
                                                    child: const Icon(
                                                      IconlyBold
                                                          .arrow_up_circle,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    _areLocationsAddedOnValidation == false
                                        ? SizedBox(
                                            width: getWidth(context: context),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Text(
                                                    'Enter locations',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    _locationEntries == null
                                        ? const SizedBox.shrink()
                                        : _showRideDetails == false
                                            ? Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        _showRideDetails = true;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          12, 2, 0, 2),
                                                      decoration: BoxDecoration(
                                                        boxShadow: const [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black38,
                                                              offset: Offset(
                                                                  0, 1.5),
                                                              blurRadius: 0.4,
                                                              spreadRadius:
                                                                  0.2),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color:
                                                            Colors.lightGreen,
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              const Icon(
                                                                IconlyBold
                                                                    .location,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              const SizedBox(
                                                                width: 14,
                                                              ),
                                                              Text(
                                                                'Selected locations',
                                                                style: GoogleFonts.nunito(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                          IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  _showRideDetails =
                                                                      true;
                                                                });
                                                              },
                                                              icon: SvgPicture
                                                                  .asset(
                                                                ImageAssets
                                                                    .arrowDownIcon,
                                                                color: Colors
                                                                    .white,
                                                                height: 18,
                                                                width: 18,
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          _showRideDetails =
                                                              false;
                                                        });
                                                      },
                                                      icon: SvgPicture.asset(
                                                        ImageAssets.arrowUpIcon,
                                                        color:
                                                            Colors.lightGreen,
                                                        height: 20,
                                                        width: 20,
                                                      )),
                                                  Column(
                                                    children: [
                                                      // const SizedBox(
                                                      //   height: 5,
                                                      // ),
                                                      Container(
                                                        // padding: const EdgeInsets.symmetric(
                                                        //     horizontal: 13),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: themeProvider
                                                                  .getDarkTheme
                                                              ? Colors.lightGreen[
                                                                  100]
                                                              : Colors
                                                                  .lightGreen
                                                                  .withOpacity(
                                                                      0.25),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      13),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 2),
                                                                    child: Icon(
                                                                      IconlyBold
                                                                          .location,
                                                                      color: Colors
                                                                              .lightGreen[
                                                                          700],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          'Pick Up Location',
                                                                          style: GoogleFonts.nunito(
                                                                              fontSize: 17,
                                                                              color: Colors.lightGreen[700],
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                        Text(
                                                                          _locationEntries!
                                                                              .pickLocationAddress,
                                                                          softWrap:
                                                                              true,
                                                                          style: GoogleFonts.nunito(
                                                                              fontSize: 16,
                                                                              color: Colors.black87,
                                                                              fontWeight: FontWeight.w600),
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
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      13),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 2),
                                                                    child: Icon(
                                                                      IconlyBold
                                                                          .location,
                                                                      color: Colors
                                                                              .lightGreen[
                                                                          700],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          'Destination Location',
                                                                          style: GoogleFonts.nunito(
                                                                              fontSize: 17,
                                                                              color: Colors.lightGreen[700],
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                        Text(
                                                                          _locationEntries!
                                                                              .destinationLocationAddress,
                                                                          softWrap:
                                                                              true,
                                                                          style: GoogleFonts.nunito(
                                                                              fontSize: 16,
                                                                              color: Colors.black87,
                                                                              fontWeight: FontWeight.w600),
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
                                                            const Divider(),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      13),
                                                              child: Text(
                                                                'The travel distance is ${_locationEntries!.distance} and travel time ~${_locationEntries!.time}',
                                                                style: GoogleFonts.nunito(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                            .lightGreen[
                                                                        800],
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                    const SizedBox(
                                      height: 28,
                                    ),
                                    TextFormField(
                                      controller:
                                          _totalAvailableSeatsEditingController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          MdiIcons.seatPassenger,
                                          size: 25,
                                        ),
                                        label: const Text('AVAILABLE SEATS'),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter available seats';
                                        } else if (value.isNotEmpty) {
                                          if ((CommonData.passengerDataModal
                                                      .vehicleType ==
                                                  'Car') &&
                                              (value != '3' &&
                                                  value != '2' &&
                                                  value != '1' &&
                                                  value != '0')) {
                                            return 'Enter seats less than or equal to 3';
                                          } else if (CommonData
                                                      .passengerDataModal
                                                      .vehicleType ==
                                                  'Motorbike' &&
                                              (value != '1' && value != '0')) {
                                            return 'Enter available seat 1';
                                          } else if (value == '0') {
                                            return "Available seat can't be 0";
                                          }
                                        }

                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 28,
                                    ),
                                    TextFormField(
                                      controller: _costPerSeatEditingController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.money,
                                          size: 25,
                                        ),
                                        label: Text('COST / SEAT (PKR)'),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter cost per seat';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 28,
                                    ),
                                    TextFormField(
                                      controller: _commentEditingController,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.comment,
                                          size: 25,
                                        ),
                                        label: Text('COMMENTS'),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Ride Rules',
                                              style: GoogleFonts.nunito(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              'Tap on the option below if you want to allow any or all of them',
                                              style: GoogleFonts.nunito(
                                                  fontSize: 14,
                                                  color:
                                                      themeProvider.getDarkTheme
                                                          ? Colors.grey[300]
                                                          : Colors.grey,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _isMusicAllowed =
                                                            !_isMusicAllowed;
                                                      });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'MUSIC',
                                                          style: GoogleFonts.nunito(
                                                              fontSize: 15,
                                                              color: _isMusicAllowed
                                                                  ? Colors.lightGreen
                                                                  : themeProvider.getDarkTheme
                                                                      ? Colors.grey[300]
                                                                      : Colors.grey,
                                                              fontWeight: FontWeight.w700),
                                                        ),
                                                        const Icon(
                                                          Icons.music_note,
                                                          color:
                                                              Colors.pinkAccent,
                                                        )
                                                      ],
                                                    )),
                                                TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _haveACService =
                                                            !_haveACService;
                                                      });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'AC',
                                                          style: GoogleFonts.nunito(
                                                              fontSize: 15,
                                                              color: _haveACService
                                                                  ? Colors.lightGreen
                                                                  : themeProvider.getDarkTheme
                                                                      ? Colors.grey[300]
                                                                      : Colors.grey,
                                                              fontWeight: FontWeight.w700),
                                                        ),
                                                        Icon(
                                                          MdiIcons
                                                              .airConditioner,
                                                          size: 20,
                                                          color: Colors.blue,
                                                        )
                                                      ],
                                                    )),
                                                TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _isSmokingAllowed =
                                                            !_isSmokingAllowed;
                                                      });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'SMOKING',
                                                          style: GoogleFonts.nunito(
                                                              fontSize: 15,
                                                              color: _isSmokingAllowed
                                                                  ? Colors.lightGreen
                                                                  : themeProvider.getDarkTheme
                                                                      ? Colors.grey[300]
                                                                      : Colors.grey,
                                                              fontWeight: FontWeight.w700),
                                                        ),
                                                        const Icon(
                                                          Icons.smoking_rooms,
                                                          color: Colors.orange,
                                                        )
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        'Will you start your journey now or later?',
                                        style: GoogleFonts.nunito(
                                          fontSize: 16,
                                          color: themeProvider.getDarkTheme
                                              ? Colors.grey[300]
                                              : Colors.black45,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black38,
                                              offset: Offset(0, 1.5),
                                              blurRadius: 0.4,
                                              spreadRadius: 0.2),
                                        ],
                                      ),
                                      child: ToggleSwitch(
                                        minWidth:
                                            getWidth(context: context) * 0.423,
                                        cornerRadius: 10,
                                        minHeight: 55,
                                        activeBgColors: const [
                                          [Colors.lightGreen],
                                          [Colors.lightGreen]
                                        ],
                                        activeFgColor: Colors.white,
                                        inactiveBgColor: Colors.grey[400],
                                        inactiveFgColor: Colors.white,
                                        initialLabelIndex: _labelIndex,
                                        totalSwitches: 2,
                                        labels: const ['Now', 'Schedule'],
                                        // radiusStyle: true,
                                        onToggle: (index) {
                                          _sharedRideViewModel
                                              .setSchedule(index ?? 0);

                                          setState(() {
                                            _labelIndex = index ?? 0;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: _labelIndex == 0 ? 15 : 28,
                                    ),
                                    _labelIndex == 0
                                        ? const SizedBox.shrink()
                                        : Column(
                                            children: [
                                              TextFormField(
                                                  controller:
                                                      _rideDateEditingController,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Enter ride date';
                                                    }

                                                    return null;
                                                  },
                                                  readOnly: true,
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                    prefixIcon: const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 3),
                                                      child: Icon(
                                                        Icons.date_range,
                                                        size: 25,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide: BorderSide(
                                                                color:
                                                                    Colors.grey[
                                                                        300]!)),
                                                    suffixIcon: IconButton(
                                                      icon: const Icon(
                                                        Icons.arrow_drop_down,
                                                        color:
                                                            //  _isBirthDateEmptyOnValidatio == true
                                                            //     ? Colors.red
                                                            // :
                                                            Colors.lightGreen,
                                                      ),
                                                      iconSize: 30,
                                                      onPressed: () async {
                                                        final DateTime? date =
                                                            await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    DateTime
                                                                        .now(),
                                                                firstDate:
                                                                    DateTime
                                                                        .now(),
                                                                lastDate:
                                                                    DateTime(
                                                                        2100));

                                                        if (date != null) {
                                                          _rideDateEditingController
                                                              .text = DateFormat(
                                                                  'dd/MM/yyyy')
                                                              .format(date);
                                                          setState(() {});
                                                        }
                                                      },
                                                    ),
                                                    label:
                                                        const Text('RIDE DATE'),
                                                  )),
                                              const SizedBox(
                                                height: 28,
                                              ),
                                              _rideDateEditingController
                                                      .text.isEmpty
                                                  ? const SizedBox.shrink()
                                                  : Column(
                                                      children: [
                                                        TextFormField(
                                                            controller:
                                                                _rideTimeEditingController,
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                // setState(() {
                                                                //   _isBirthDateEmptyOnValidation =
                                                                //       true;
                                                                // });
                                                                return 'Enter ride time';
                                                              }
                                                              // setState(() {
                                                              //   _isBirthDateEmptyOnValidation =
                                                              //       false;
                                                              // });
                                                              return null;
                                                            },
                                                            readOnly: true,
                                                            textAlignVertical:
                                                                TextAlignVertical
                                                                    .center,
                                                            decoration:
                                                                InputDecoration(
                                                              prefixIcon:
                                                                  const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            3),
                                                                child: Icon(
                                                                  Icons
                                                                      .schedule,
                                                                  size: 25,
                                                                ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.grey[300]!)),
                                                              suffixIcon:
                                                                  IconButton(
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_drop_down,
                                                                  color:
                                                                      //  _isBirthDateEmptyOnValidatio == true
                                                                      //     ? Colors.red
                                                                      // :
                                                                      Colors
                                                                          .lightGreen,
                                                                ),
                                                                iconSize: 30,
                                                                onPressed: _rideDateEditingController
                                                                        .text
                                                                        .isEmpty
                                                                    ? null
                                                                    : () async {
                                                                        DateTime
                                                                            d =
                                                                            DateTime.now();

                                                                        int minute =
                                                                            d.minute;
                                                                        int hour =
                                                                            d.hour;
                                                                        if (timeOfDay !=
                                                                            null) {
                                                                          d = _convertTimeOfDayToDateTime(
                                                                              d,
                                                                              timeOfDay!);
                                                                          minute =
                                                                              d.minute;
                                                                          hour =
                                                                              d.hour;
                                                                        } else {
                                                                          if ((d.minute >= 0 &&
                                                                              d.minute <
                                                                                  15)) {
                                                                            minute =
                                                                                30;
                                                                          } else if (d.minute >= 15 &&
                                                                              d.minute <
                                                                                  30) {
                                                                            minute =
                                                                                45;
                                                                          } else if (d.minute >= 30 &&
                                                                              d.minute <
                                                                                  45) {
                                                                            minute =
                                                                                0;
                                                                            hour +=
                                                                                1;
                                                                          } else if (d.minute >= 45 &&
                                                                              d.minute <= 59) {
                                                                            minute =
                                                                                15;
                                                                            hour +=
                                                                                1;
                                                                          }
                                                                        }
                                                                        // final TimeOfDay? time =
                                                                        //     await showTimePicker(
                                                                        //         context:
                                                                        //             context,
                                                                        //         initialTime:
                                                                        //             TimeOfDay
                                                                        //                 .now());

                                                                        await Navigator.of(context)
                                                                            .push(
                                                                          showPicker(
                                                                            iosStylePicker:
                                                                                true,
                                                                            context:
                                                                                context,

                                                                            value:
                                                                                Time(
                                                                              hour: hour,
                                                                              minute: minute,
                                                                              // second: DateTime
                                                                              //         .now()
                                                                              //     .second
                                                                            ),

                                                                            onChange:
                                                                                (Time time) {
                                                                              timeOfDay = Time(hour: time.hour, minute: time.minute, second: time.second);
                                                                            },
                                                                            minuteInterval:
                                                                                TimePickerInterval.FIFTEEN,
                                                                            // Optional onChange to receive value as DateTime
                                                                            onChangeDateTime:
                                                                                (DateTime dateTime) {
                                                                              // print(dateTime);
                                                                              // log("[debug datetime]:  $dateTime");
                                                                            },
                                                                          ),
                                                                        );

                                                                        if (!mounted) {
                                                                          return;
                                                                        }
                                                                        if (timeOfDay !=
                                                                            null) {
                                                                          _rideTimeEditingController.text =
                                                                              timeOfDay!.format(context);
                                                                        }
                                                                      },
                                                              ),
                                                              label: const Text(
                                                                  'RIDE TIME'),
                                                            )),
                                                        const SizedBox(
                                                          height: 28,
                                                        ),
                                                      ],
                                                    ),
                                            ],
                                          ),
                                    StreamBuilder(
                                        stream: _sharedRideViewModel
                                            .outputIsAllInputValid,
                                        builder: (context, snapshot) {
                                          return Container(
                                            width: double.infinity,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black38,
                                                    offset: Offset(0, 1.5),
                                                    blurRadius: 0.4,
                                                    spreadRadius: 0.2),
                                              ],
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                if (snapshot.data != true) {
                                                  _formKey.currentState!
                                                      .validate();
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                }
                                                if (_locationEntries == null) {
                                                  _formKey.currentState!
                                                      .validate();
                                                  setState(() {
                                                    _areLocationsAddedOnValidation =
                                                        false;
                                                  });
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                }
                                                if (_locationEntries != null) {
                                                  setState(() {
                                                    _areLocationsAddedOnValidation =
                                                        true;
                                                  });
                                                }
                                              },
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))),
                                                  onPressed: snapshot.data ==
                                                          true
                                                      ? () {
                                                          _formKey.currentState!
                                                              .validate();
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          _postCompaign();
                                                        }
                                                      : null,
                                                  child: Text(
                                                    'Post',
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  )),
                                            ),
                                          );
                                        })
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
                ]),
              ),
              !_isLoading
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
                                'Posting campaign',
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
              !_isError
                  ? const SizedBox.shrink()
                  : Container(
                      height: getHeight(context: context),
                      width: getWidth(context: context),
                      color: Colors.black54,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
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
                                error,
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
                                        _isError = false;
                                        error = EMPTY;
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
              !_isSuccess
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
                                child: Lottie.asset(
                                  LottieAssets.success,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                'You have successfully posted your campaign.',
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
                                        _isSuccess = false;
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
            ],
          ));
        }),
      ),
    );
  }
}
