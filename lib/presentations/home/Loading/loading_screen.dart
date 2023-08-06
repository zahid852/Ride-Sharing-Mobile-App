import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:lottie/lottie.dart';

import '../../resources/assets_manager.dart';

class LoadingScreen extends StatelessWidget {
  final String message;
  const LoadingScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: getHeight(context: context),
          width: getWidth(context: context),
          color: Colors.black54,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
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
                    message,
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
      ),
    );
  }
}
