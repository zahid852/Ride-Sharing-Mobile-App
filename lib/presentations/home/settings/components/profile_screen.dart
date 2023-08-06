import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';
import 'package:lift_app/presentations/home/settings/components/driver_profile_part.dart';
import 'package:lift_app/presentations/home/settings/components/passenger_profile_part.dart';
import 'package:lift_app/presentations/home/settings/components/profile_view_model.dart';
import 'package:lift_app/presentations/utils/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../../data/network/failure.dart';
import '../../../resources/assets_manager.dart';
import '../../../utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ProfileScreen> {
  late ShowProfileViewModel _showProfileViewModel;
  late Future<void> _getDriverData;
  @override
  void initState() {
    if (CommonData.passengerDataModal.isDriver) {
      _showProfileViewModel =
          Provider.of<ShowProfileViewModel>(context, listen: false);
      _getDriverData = _showProfileViewModel
          .getDriverDetails(CommonData.passengerDataModal.id);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (CommonData.passengerDataModal.isDriver) {
      _showProfileViewModel.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonData.passengerDataModal.isDriver == false
        ? passengerProfileData(context)
        : WillPopScope(
            onWillPop: onWillPop,
            child: FutureBuilder(
                future: _getDriverData,
                builder: (futureCtx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      body: SafeArea(
                          child: Stack(
                        children: [
                          showProfileAppBar(context),
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
                          showProfileAppBar(context),
                          Center(
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
                  } else {
                    return Consumer<ShowProfileViewModel>(
                        builder: (consumerCtx, viewModel, _) {
                      return DriverProfilePart(
                        driverDetailsModel: viewModel.driverDetailsModel,
                        showProfileViewModel: viewModel,
                      );
                    });
                  }
                }),
          );
  }
}
