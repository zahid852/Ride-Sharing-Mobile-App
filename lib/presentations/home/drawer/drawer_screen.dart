import 'dart:math';
import 'dart:developer' as print;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:iconly/iconly.dart';
import 'package:lift_app/data/mapper/mappers.dart';
import 'package:lift_app/presentations/home/history/passenger/passenger_history_screen.dart';
import 'package:lift_app/presentations/home/share_ride/share_ride_campaign_screen.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';
import 'package:lift_app/presentations/home/passenger_requests/passenger_request_scree.dart';
import 'package:lift_app/presentations/home/schedule_rides/schedule_rides_screen.dart';
import 'package:lift_app/presentations/home/search/search_ride_screen.dart';
import 'package:lift_app/presentations/home/settings/setting_screen.dart';
import 'package:lift_app/presentations/home/history/driver/driver_history_screen.dart';
import 'package:lift_app/presentations/home/drawer/components/list_tile_widget.dart';
import 'package:lift_app/presentations/resources/assets_manager.dart';
import 'package:lift_app/presentations/utils/notifications_service.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../notification/notification_local_screen.dart';

List<String> drawerItems = [
  'city',
  'campaignRequest',
  'notification',
  'driver',
  'settings',
];

// ignore: must_be_immutable
class DrawerScreen extends StatefulWidget {
  bool? passengerRequestsCheck;
  int? index;

  DrawerScreen({
    Key? key,
    this.passengerRequestsCheck,
    this.index,
  }) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  // final AppPreferences _appPreferences = instance<AppPreferences>();
  // Future<void>? _getUserData;

  BuildContext? dialogContext;
  double value = 0;
  // bool _isFirstRun = true;
  int currentScreenIndex = 0;
  late String roleActivatorMain;
  late DrawerViewModel drawerViewModel;
  late String roleActivatorRequest;
  late String roleActivatorHistory;
  String selectedItem = drawerItems.first;
  late List<Widget> screensItems = [
    SharedRideCompaignScreen(
      menuButtonFunction: menuButton,
    ),
    ScheduleRidesScreen(menuButtonFunction: menuButton),
    NotificationScreen(menuButtonFunction: menuButton),
    DriverHistoryScreen(menuButtonFunction: menuButton),
    SettingsScreen(menuButtonFunction: menuButton),
  ];

  void menuButton() {
    setState(() {
      value = 1;
    });
  }

  final NotificationsService notificationsService = NotificationsService();
  @override
  void initState() {
    print.log('initing');
    if (widget.passengerRequestsCheck == true) {
      currentScreenIndex = 1;
      selectedItem = drawerItems[1];
    }
    drawerViewModel = Provider.of<DrawerViewModel>(context, listen: false);
    notificationsService.requestNotificationPermission();
    notificationsService.firebaseInit(context);
    notificationsService.setUpInteractMessage(context);
    roleActivatorMain = CommonData.isUserPassengerCurrently ? 'search' : 'city';
    roleActivatorRequest =
        CommonData.isUserPassengerCurrently ? 'rideRequest' : 'campaignRequest';
    roleActivatorHistory =
        CommonData.isUserPassengerCurrently ? 'passenger' : 'driver';
    drawerItems[0] = CommonData.isUserPassengerCurrently ? 'search' : 'city';
    screensItems[0] = CommonData.isUserPassengerCurrently
        ? SearchRideScreen(menuButtonFunction: menuButton)
        : SharedRideCompaignScreen(
            menuButtonFunction: menuButton,
          );
    drawerItems[1] =
        CommonData.isUserPassengerCurrently ? 'rideRequest' : 'campaignRequest';

    screensItems[1] = CommonData.isUserPassengerCurrently
        ? PassengerRequestScreen(
            menuButtonFunction: menuButton,
            index: widget.index ?? ZERO,
          )
        : ScheduleRidesScreen(menuButtonFunction: menuButton);

    drawerItems[3] =
        CommonData.isUserPassengerCurrently ? 'passenger' : 'driver';

    screensItems[3] = CommonData.isUserPassengerCurrently
        ? PassengerHistoryScreen(menuButtonFunction: menuButton)
        : DriverHistoryScreen(menuButtonFunction: menuButton);

    if (selectedItem == 'city' || selectedItem == 'search') {
      selectedItem = CommonData.isUserPassengerCurrently ? 'search' : 'city';
    }
    if (selectedItem == 'rideRequest' || selectedItem == 'campaignRequest') {
      selectedItem = CommonData.isUserPassengerCurrently
          ? 'rideRequest'
          : 'campaignRequest';
    }
    if (selectedItem == 'passenger' || selectedItem == 'driver') {
      selectedItem =
          CommonData.isUserPassengerCurrently ? 'passenger' : 'driver';
    }
    // if (CommonData.isDataFetched == false) {
    //   _getUserData = Provider.of<DrawerViewModel>(context, listen: false)
    //       .getPassengerData(
    //           UserDetailsRequest(_appPreferences.getUserId()), context);
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.lightGreen,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  image: DecorationImage(
                      image: Image.asset(ImageAssets.backgroundWithCar2).image,
                      fit: BoxFit.cover)),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
                Colors.black
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            ),

            SafeArea(
                child: Container(
              height: double.infinity,
              width: getWidth(context: context) * 0.69,
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: CircleAvatar(
                                  radius: 59,
                                  backgroundColor: Colors.lightGreen,
                                  child: CircleAvatar(
                                    radius: 58,
                                    child: CachedNetworkImage(
                                      imageUrl: CommonData.isDataFetched
                                          ? CommonData
                                              .passengerDataModal.profileImg
                                          : EMPTY,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      errorWidget: (_, url, error) => Container(
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
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, right: 15),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      value = 0;
                                    });
                                  },
                                  child: Container(
                                    height: 34,
                                    width: 34,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: const Center(
                                        child: Icon(
                                      Icons.close,
                                      size: 22,
                                      color: Colors.black,
                                    )),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Stack(
                              children: [
                                // Implement the stroke
                                Text(
                                  CommonData.isDataFetched
                                      ? CommonData.passengerDataModal.name
                                      : EMPTY,
                                  style: TextStyle(
                                      fontSize: 20,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 2
                                        ..color = Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                                // The text inside
                                Text(
                                  CommonData.isDataFetched
                                      ? CommonData.passengerDataModal.name
                                      : EMPTY,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.lightGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CommonData.isDataFetched
                              ? CommonData.passengerDataModal.isDriver
                                  ? CommonData.isUserPassengerCurrently
                                      ? const SizedBox(
                                          height: 30,
                                        )
                                      : Column(
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: RatingBar.builder(
                                                  initialRating: CommonData
                                                              .passengerDataModal
                                                              .totalReviewsGiven ==
                                                          0
                                                      ? 5
                                                      : (CommonData
                                                                  .passengerDataModal
                                                                  .totalRating /
                                                              CommonData
                                                                  .passengerDataModal
                                                                  .totalReviewsGiven)
                                                          .toDouble(),
                                                  itemSize: 25,
                                                  allowHalfRating: true,
                                                  unratedColor: Colors.black,
                                                  ignoreGestures: true,
                                                  itemBuilder: (ctx, _) {
                                                    return const DecoratedIcon(
                                                      icon: Icon(Icons.star,
                                                          color: Colors
                                                              .yellowAccent),
                                                      decoration:
                                                          IconDecoration(
                                                        border: IconBorder(
                                                            width: 1.5),
                                                      ),
                                                    );
                                                  },
                                                  onRatingUpdate: (_) {}),
                                            ),
                                          ],
                                        )
                                  : const SizedBox(
                                      height: 5,
                                    )
                              : const SizedBox(
                                  height: 5,
                                )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Stack(
                        children: [
                          // Implement the stroke
                          Text(
                            'BROWSE',
                            style: TextStyle(
                                fontSize: 16,
                                // letterSpacing: 0.9,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 2
                                  ..color = Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          // The text inside
                          Text(
                            'BROWSE',
                            style: TextStyle(
                              fontSize: 16,
                              // letterSpacing: 0.9,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[200]!,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 14.5,
                    ),
                    ListTileTheme(
                      data: const ListTileThemeData(
                        iconColor: Colors.white,
                        textColor: Colors.white,
                      ),
                      child: SizedBox(
                          height: getHeight(context: context) * 0.48,
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              const Divider(
                                height: 1,
                              ),

                              ListTileWidget(
                                label: CommonData.isUserPassengerCurrently
                                    ? 'Search'
                                    : 'City',
                                icon: CommonData.isUserPassengerCurrently
                                    ? Icons.search
                                    : Icons.location_city,
                                function: () {
                                  setState(() {
                                    selectedItem =
                                        CommonData.isUserPassengerCurrently
                                            ? 'search'
                                            : 'city';
                                    roleActivatorMain =
                                        CommonData.isUserPassengerCurrently
                                            ? 'search'
                                            : 'city';
                                    widget.index = 0;
                                    currentScreenIndex = 0;
                                    value = 0;
                                  });
                                },
                                isActive: selectedItem == roleActivatorMain,
                              ),
                              const Divider(),
                              ListTileWidget(
                                label: CommonData.isUserPassengerCurrently
                                    ? 'Requests'
                                    : 'Schedule Rides',
                                icon: CommonData.isUserPassengerCurrently
                                    ? IconlyBold.activity
                                    : MdiIcons.calendar,
                                function: () {
                                  setState(() {
                                    widget.index = 0;
                                    selectedItem =
                                        CommonData.isUserPassengerCurrently
                                            ? 'rideRequest'
                                            : 'campaignRequest';
                                    currentScreenIndex = 1;
                                    value = 0;
                                  });
                                },
                                isActive: selectedItem == roleActivatorRequest,
                              ),
                              const Divider(),
                              ListTileWidget(
                                label: 'Notifications',
                                icon: Icons.notifications,
                                function: () {
                                  setState(() {
                                    widget.index = 0;
                                    selectedItem = 'notification';
                                    currentScreenIndex = 2;
                                    value = 0;
                                  });
                                },
                                isActive: selectedItem == 'notification',
                              ),
                              const Divider(),
                              ListTileWidget(
                                label: 'History',
                                icon: Icons.history,
                                function: () {
                                  setState(() {
                                    widget.index = 0;
                                    selectedItem =
                                        CommonData.isUserPassengerCurrently
                                            ? 'passenger'
                                            : 'driver';
                                    currentScreenIndex = 3;
                                    value = 0;
                                  });
                                },
                                isActive: selectedItem == roleActivatorHistory,
                              ),
                              const Divider(),
                              ListTileWidget(
                                label: 'Settings',
                                icon: Icons.settings,
                                function: () {
                                  setState(() {
                                    widget.index = 0;
                                    selectedItem = 'settings';
                                    currentScreenIndex = 4;
                                    value = 0;
                                  });
                                },
                                isActive: selectedItem == 'settings',
                              ),

                              // const Divider(),
                              // SwitchListTile(
                              //     activeTrackColor: Colors.blue,
                              //     inactiveThumbColor: Colors.white,
                              //     inactiveTrackColor: Colors.blue,
                              //     activeColor: Colors.white,
                              //     title: Text(
                              //       themeProvider.getDarkTheme ? 'Dark' : 'Light',
                              //       style: GoogleFonts.nunito(
                              //         fontSize: 17,
                              //         fontWeight: FontWeight.w700,
                              //       ),
                              //     ),
                              //     secondary: Icon(
                              //       themeProvider.getDarkTheme
                              //           ? Icons.dark_mode
                              //           : Icons.light_mode,
                              //     ),
                              //     value: themeProvider.getDarkTheme,
                              //     onChanged: (bool value) {
                              //       themeProvider.setDarkTheme = value;
                              //     }),
                            ],
                          )),
                    )
                  ],
                ),
              ),
            )),
            CommonData.passengerDataModal.isDriver
                ? Positioned(
                    bottom: 30,
                    left: 10,
                    child: SizedBox(
                      height: 60,
                      width: getWidth(context: context) * 0.69 - 10,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: CommonData.isDataFetched
                              ? CommonData.isUserPassengerCurrently
                                  ? () {
                                      setState(() {
                                        CommonData.isUserPassengerCurrently =
                                            false;
                                        if (currentScreenIndex == 0) {
                                          selectedItem = 'city';
                                          roleActivatorMain = 'city';
                                        }
                                      });
                                    }
                                  : () {
                                      setState(() {
                                        CommonData.isUserPassengerCurrently =
                                            true;
                                        if (currentScreenIndex == 0) {
                                          selectedItem = 'search';
                                          roleActivatorMain = 'search';
                                        }
                                      });
                                    }
                              : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                CommonData.isUserPassengerCurrently
                                    ? 'Driver Mode'
                                    : 'Passenger Mode',
                                style: GoogleFonts.nunito(
                                    color: Colors.lightGreen,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.lightGreen,
                                size: 22,
                              ),
                            ],
                          )),
                    ))
                : const SizedBox.shrink(),

            SafeArea(
              child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: value),
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 0),
                  builder: (_, double val, __) {
                    return (Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..setEntry(
                            0, 3, (getWidth(context: context) * 0.7) * val)
                        ..rotateY((pi / 5) * val),
                      child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(value == 1 ? 24 : 0),
                          child: screensItems[currentScreenIndex]),
                    ));
                  }),
            ),
            // _isFirstRun == false
            //     ? const SizedBox.shrink()
            // : FutureBuilder(
            //     future: _getUserData,
            //     builder: (getUserCtx, snapshot) {
            //       _isFirstRun = false;
            //       if (snapshot.connectionState ==
            //           ConnectionState.waiting) {
            //         return Container(
            //           height: getHeight(context: context),
            //           width: getWidth(context: context),
            //           color: Colors.lightGreen,
            //           child: Center(
            //             child: Material(
            //               elevation: 2,
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(15)),
            //               child: Container(
            //                 padding: const EdgeInsets.all(20),
            //                 height: 200,
            //                 width: 200,
            //                 decoration: BoxDecoration(
            //                     color: Colors.white,
            //                     borderRadius: BorderRadius.circular(15)),
            //                 child: Column(
            //                   children: [
            //                     SizedBox(
            //                       height: 100,
            //                       width: 100,
            //                       child: Lottie.asset(
            //                         LottieAssets.loading,
            //                       ),
            //                     ),
            //                     const SizedBox(
            //                       height: 30,
            //                     ),
            //                     Text(
            //                       'Please wait',
            //                       style: GoogleFonts.nunito(
            //                           fontSize: 16,
            //                           color: Colors.black,
            //                           fontWeight: FontWeight.w700),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ),
            //         );
            //       } else if (snapshot.hasError) {
            //         Failure failure = snapshot.error as Failure;

            //         WidgetsBinding.instance.addPostFrameCallback((_) {
            //           showDialog(
            //               barrierDismissible: false,
            //               barrierColor: Colors.lightGreen,
            //               context: context,
            //               builder: (dialogCtx) {
            //                 return AlertDialog(
            //                   content: Container(
            //                     padding: const EdgeInsets.symmetric(
            //                         horizontal: 10, vertical: 20),
            //                     decoration: BoxDecoration(
            //                         borderRadius:
            //                             BorderRadius.circular(15)),
            //                     child: Column(
            //                       mainAxisSize: MainAxisSize.min,
            //                       children: [
            //                         SizedBox(
            //                           height: 100,
            //                           width: 100,
            //                           child: Lottie.asset(
            //                             LottieAssets.failure,
            //                           ),
            //                         ),
            //                         const SizedBox(
            //                           height: 30,
            //                         ),
            //                         Text(
            //                           failure.message,
            //                           textAlign: TextAlign.left,
            //                           style: GoogleFonts.nunito(
            //                               fontSize: 16,
            //                               fontWeight: FontWeight.w600),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                   actions: [
            //                     Padding(
            //                       padding: const EdgeInsets.only(
            //                           right: 10, bottom: 5),
            //                       child: ElevatedButton(
            //                           style: ElevatedButton.styleFrom(
            //                               shape: RoundedRectangleBorder(
            //                                   borderRadius:
            //                                       BorderRadius.circular(
            //                                           4))),
            //                           onPressed: () {
            //                             Navigator.of(context)
            //                                 .pushReplacementNamed(
            //                                     NavigationRoutes
            //                                         .Routes.homeRoute);
            //                           },
            //                           child: Text(
            //                             'Reload',
            //                             style: GoogleFonts.nunito(
            //                                 fontSize: 14,
            //                                 color: Colors.white,
            //                                 fontWeight: FontWeight.w600),
            //                           )),
            //                     ),
            //                   ],
            //                 );
            //               });
            //         });

            //         return const SizedBox.shrink();
            //       } else {
            //         return const SizedBox.shrink();
            //       }
            //     }),
            // GestureDetector(
            //   onHorizontalDragUpdate: (e) {
            //     if (e.delta.dx > 0) {
            //       setState(() {
            //         value = 1;
            //       });
            //     } else {
            //       setState(() {
            //         value = 0;
            //       });
            //     }
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
