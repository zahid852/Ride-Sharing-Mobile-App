import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:lottie/lottie.dart';

import '../../resources/assets_manager.dart';

class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({Key? key, required this.error}) : super(key: key);

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
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
              width: getWidth(context: context) * 0.75,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
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
                                borderRadius: BorderRadius.circular(4))),
                        onPressed: () {
                          Navigator.of(context).pop();
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
      ),
    );
  }
}
