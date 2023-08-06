import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/presentations/home/schedule_rides/components/accepted_requests.dart';
import 'package:lift_app/presentations/home/schedule_rides/components/pending_requests.dart';
import 'package:lift_app/presentations/home/schedule_rides/components/requests_view_model.dart';
import 'package:lift_app/presentations/utils/socket.dart';
import 'package:lift_app/presentations/utils/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../data/network/failure.dart';
import '../../../resources/assets_manager.dart';
import '../../../utils/utils.dart';

class DriverCampaignRequestScreen extends StatefulWidget {
  final String campaignId;
  const DriverCampaignRequestScreen({Key? key, required this.campaignId})
      : super(key: key);

  @override
  State<DriverCampaignRequestScreen> createState() =>
      _DriverCampaignRequestScreenState();
}

class _DriverCampaignRequestScreenState
    extends State<DriverCampaignRequestScreen> {
  late Future<void> _getRequests;

  late PassengerRequestsViewModel _passengerRequestsViewModel;
  void listenPassengerRequest() {
    SocketImplementation.socket.on('request received', (data) {
      _getRequests = _passengerRequestsViewModel
          .getRequestsData(PassengerRequestsGetRequest(data['campaignId']));
    });
  }

  @override
  void initState() {
    listenPassengerRequest();
    _passengerRequestsViewModel =
        Provider.of<PassengerRequestsViewModel>(context, listen: false);
    _passengerRequestsViewModel.isGotData = false;
    _getRequests = _passengerRequestsViewModel
        .getRequestsData(PassengerRequestsGetRequest(widget.campaignId));
    // _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
    //   setState(() {
    //     _getRequests = _passengerRequestsViewModel
    //         .getRequestsData(PassengerRequestsGetRequest(widget.campaignId));
    //   });
    // });
    super.initState();
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: FutureBuilder(
          future: _getRequests,
          builder: (futureCtx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !_passengerRequestsViewModel.isGotData) {
              return Scaffold(
                appBar: AppBar(
                  elevation: 1,
                  toolbarHeight: 70,
                  centerTitle: true,
                  title: Text(
                    'Requests',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 25,
                        )),
                  ),
                ),
                body: getLoadingWidget(context),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                appBar: AppBar(
                  elevation: 1,
                  toolbarHeight: 70,
                  centerTitle: true,
                  title: Text(
                    'Requests',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 25,
                        )),
                  ),
                ),
                body: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: getHeight(context: context) * 0.07),
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
                  ),
                ),
              );
            } else {
              return SafeArea(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        backgroundColor: Colors.grey[300],
                        minHeight: 3,
                        color: Colors.lightGreen,
                      ),
                      Expanded(
                        child: Scaffold(
                          appBar: AppBar(
                            elevation: 1,
                            toolbarHeight: 70,
                            centerTitle: true,
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Requests',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunito(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            leading: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, bottom: 10),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: 25,
                                  )),
                            ),
                            bottom: TabBar(
                              indicatorColor: Colors.white,
                              labelStyle: GoogleFonts.nunito(
                                  fontSize: 17, fontWeight: FontWeight.w700),
                              // unselectedLabelStyle:
                              //     GoogleFonts.nunito(fontSize: 17, fontWeight: FontWeight.w600),
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.grey[100],
                              indicatorWeight: 3,
                              labelPadding: const EdgeInsets.only(bottom: 12),
                              tabs: const [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.pending_actions,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Pending',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.done,
                                      size: 22,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Accepted',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          body: Consumer<PassengerRequestsViewModel>(
                              builder: (passengerCtx, viewModel, _) {
                            return TabBarView(
                              children: [
                                PendingRequests(
                                  passengerRequests: viewModel.requestsList,
                                ),
                                AcceptedRequests(
                                    passengerRequests: viewModel.requestsList)
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
