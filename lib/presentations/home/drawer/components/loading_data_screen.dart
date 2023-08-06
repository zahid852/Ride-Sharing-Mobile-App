import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/app/app_preferences.dart';
import 'package:lift_app/data/network/failure.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';
import 'package:lift_app/presentations/resources/assets_manager.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../../app/di.dart';
import '../../../../data/request/request.dart';
import '../../../resources/routes_manager.dart';

class FetchingDataScreen extends StatefulWidget {
  const FetchingDataScreen({Key? key}) : super(key: key);

  @override
  State<FetchingDataScreen> createState() => _FetchingDataScreenState();
}

class _FetchingDataScreenState extends State<FetchingDataScreen> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  Future<void>? _getUserData;

  @override
  void initState() {
    _getUserData = Provider.of<DrawerViewModel>(context, listen: false)
        .getPassengerData(
            UserDetailsRequest(_appPreferences.getUserId()), context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _getUserData,
          builder: (getUserCtx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: getHeight(context: context),
                width: getWidth(context: context),
                color: Colors.lightGreen,
                child: Center(
                  child: Material(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
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
              );
            } else if (snapshot.hasError) {
              Failure failure = snapshot.error as Failure;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                    barrierDismissible: false,
                    barrierColor: Colors.lightGreen,
                    context: context,
                    builder: (dialogCtx) {
                      return AlertDialog(
                        content: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          decoration: BoxDecoration(
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
                                failure.message,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.nunito(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 10, bottom: 5),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4))),
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed(
                                      Routes.fetchingDataRoute);
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
                      );
                    });
              });

              return const SizedBox.shrink();
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed(Routes.homeRoute);
              });
              return const SizedBox.shrink();
            }
          }),
    );
  }
}
