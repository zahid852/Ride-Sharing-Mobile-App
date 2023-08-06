import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';
import 'package:lift_app/presentations/home/passenger_requests/components/accepted_request_content.dart';
import 'package:lift_app/presentations/home/passenger_requests/passenger_request_view_model.dart';
import 'package:lift_app/presentations/utils/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../data/network/failure.dart';
import '../../resources/assets_manager.dart';
import '../../utils/socket.dart';
import '../../utils/utils.dart';
import 'components/decline_request_content.dart';
import 'components/pending_request_content.dart';

class PassengerRequestScreen extends StatefulWidget {
  final void Function() menuButtonFunction;
  final int index;
  const PassengerRequestScreen(
      {Key? key, required this.menuButtonFunction, required this.index})
      : super(key: key);

  @override
  State<PassengerRequestScreen> createState() => _PassengerRequestState();
}

class _PassengerRequestState extends State<PassengerRequestScreen> {
  late Future<void> _getRequests;

  late PassengerAllRequestsViewModel _passengerAllRequestsViewModel;
  void listenPassengerAcceptedRequest() {
    SocketImplementation.socket.on('myrequest received', (data) {
      _getRequests = _passengerAllRequestsViewModel.getAllRequestsData(
          UserDetailsRequest(CommonData.passengerDataModal.id));
    });
  }

  // void listenRideStatus() {
  //   SocketImplementation.socket.on('journey started', (data) {
  //     log('journey started');

  //     _getRequests = _passengerAllRequestsViewModel.getAllRequestsData(
  //         UserDetailsRequest(CommonData.passengerDataModal.id));
  //   });
  // }

  @override
  void initState() {
    // listenRideStatus();
    listenPassengerAcceptedRequest();
    _passengerAllRequestsViewModel =
        Provider.of<PassengerAllRequestsViewModel>(context, listen: false);
    _passengerAllRequestsViewModel.isGotData = false;
    _getRequests = _passengerAllRequestsViewModel.getAllRequestsData(
        UserDetailsRequest(CommonData.passengerDataModal.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getRequests,
        builder: (futureCtx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !_passengerAllRequestsViewModel.isGotData) {
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
                      onPressed: widget.menuButtonFunction,
                      icon: const Icon(
                        Icons.menu,
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
                      onPressed: widget.menuButtonFunction,
                      icon: const Icon(
                        Icons.menu,
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
            return DefaultTabController(
              initialIndex: widget.index,
              length: 3,
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
                                onPressed: widget.menuButtonFunction,
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 25,
                                )),
                          ),
                          bottom: TabBar(
                            indicatorColor: Colors.white,

                            labelStyle: GoogleFonts.nunito(
                                fontSize: 15, fontWeight: FontWeight.w700),
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
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 5,
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
                                    size: 19,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Accepted',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.undo_outlined,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Declined',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        body: Consumer<PassengerAllRequestsViewModel>(
                            builder: (ctx, viewModel, _) {
                          return TabBarView(
                            children: [
                              PassengerPendingRequestBody(
                                  passengerRequests: viewModel.requestsList),
                              PassengerAcceptedRequestBody(
                                  passengerRequests: viewModel.requestsList),
                              PassengerDeclineRequestBody(
                                  passengerRequests: viewModel.requestsList),
                            ],
                          );
                        })),
                  ),
                ],
              ),
            );
          }
        });
  }
}
