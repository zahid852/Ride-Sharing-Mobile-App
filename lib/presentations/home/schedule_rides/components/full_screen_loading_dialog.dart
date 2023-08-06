import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../resources/assets_manager.dart';
import '../../../utils/utils.dart';

Widget fullScreenLoadingDialog(String message, BuildContext context) {
  return WillPopScope(
    onWillPop: onWillPop,
    child: Container(
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
              DefaultTextStyle(
                style: const TextStyle(),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
