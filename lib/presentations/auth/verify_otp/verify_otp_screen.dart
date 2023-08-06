import 'dart:developer';

import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/auth/get_otp/get_otp_viewmodel.dart';
import 'package:lift_app/presentations/auth/verify_otp/verify_otp_viewmodel.dart';
import 'package:pinput/pinput.dart';
import '../../../data/network/failure.dart';
import '../../resources/assets_manager.dart';

import '../../utils/notifications_service.dart';
import '../../utils/utils.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String phoneNumber;
  const VerifyOtpScreen({super.key, required this.phoneNumber});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen>
    with SingleTickerProviderStateMixin {
  final VerifyOtpViewModel _verifyOtpViewModel = VerifyOtpViewModel();
  final GetOtpViewModel _getOtpViewModel = GetOtpViewModel();
  final NotificationsService notificationsService = NotificationsService();
  bool isResendCode = false;
  late final CustomTimerController _customTimerController =
      CustomTimerController(
    vsync: this,
    begin: const Duration(minutes: 2, seconds: 0),
    end: const Duration(seconds: 0),
  );
  final TextEditingController _pinEditingController = TextEditingController();
  final FToast _fToast = FToast();
  bool isVerifyLoading = false;
  bool isResendCodeLoading = false;

  void _bind() {
    _pinEditingController.addListener(() =>
        _verifyOtpViewModel.setVerificationCode(_pinEditingController.text));
    _verifyOtpViewModel.isUserloggedInSuccesfullyStreamController.stream
        .listen((route) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(route);
    });
  }

  @override
  void initState() {
    _bind();
    _fToast.init(context);
    notificationsService.getDeviceToken();
    Future.delayed(const Duration(seconds: 2), () {
      _customTimerController.start();
    });

    super.initState();
  }

  @override
  void dispose() {
    _verifyOtpViewModel.dispose();
    _customTimerController.dispose();
    _pinEditingController.dispose();

    super.dispose();
  }

  void verifyOtp() async {
    try {
      if (PushNotificationCredentials.token.isNotEmpty) {
        setState(() {
          isVerifyLoading = true;
        });

        await _verifyOtpViewModel.verifyOtp(VerifyOtpRequest(widget.phoneNumber,
            _pinEditingController.text, PushNotificationCredentials.token));
      } else {
        _fToast.showToast(
            child: buildToast(
                type: ToastMessageType.failure,
                mes: "Could'nt get your device token. Please try again."));
      }
    } on Failure catch (error) {
      setState(() {
        isVerifyLoading = false;
      });
      _fToast.showToast(
          child:
              buildToast(type: ToastMessageType.failure, mes: error.message));
    } catch (error) {
      log('error $error');
      setState(() {
        isVerifyLoading = false;
      });
      _fToast.showToast(
          child: buildToast(
              type: ToastMessageType.failure,
              mes: "Something went wrong.Please try again!"));
    }
  }

  void resendCode() async {
    try {
      await _getOtpViewModel.getOtp(widget.phoneNumber);

      setState(() {
        isResendCodeLoading = false;
        isResendCode = false;
        // _customTimerController.start();
      });
    } on Failure catch (error) {
      setState(() {
        isResendCodeLoading = false;
      });
      _fToast.showToast(
          child:
              buildToast(type: ToastMessageType.failure, mes: error.message));
    } catch (error) {
      setState(() {
        isResendCodeLoading = false;
      });
      _fToast.showToast(
          child: buildToast(
              type: ToastMessageType.failure,
              mes: "Something went wrong.Please try again!"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    bool isKeyboard = viewInsetsBottom != 0;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            height: getHeight(context: context),
            width: getWidth(context: context),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        isKeyboard
                            ? const SizedBox.shrink()
                            : Image.asset(
                                ImageAssets.otpImage,
                                height: getHeight(context: context) * 0.3,
                                width: getWidth(context: context) * 0.8,
                              ),
                        isKeyboard
                            ? const SizedBox.shrink()
                            : const SizedBox(
                                height: 30,
                              ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'OTP Verification',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Container(
                          width: getWidth(context: context),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Text(
                            'Enter OTP sent to ${widget.phoneNumber}',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.nunito(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                            width: double.infinity,
                            child: Pinput(
                              length: 4,
                              controller: _pinEditingController,
                              keyboardType: TextInputType.number,
                              closeKeyboardWhenCompleted: true,
                              pinAnimationType: PinAnimationType.fade,
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        isResendCode
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: isResendCodeLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : SizedBox(
                                        width: getWidth(context: context),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text("Didn't receive code?"),
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    resendCode();

                                                    isResendCodeLoading = true;
                                                  });
                                                },
                                                child: const Text(
                                                  'Resend Code',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Colors.lightGreen),
                                                )),
                                          ],
                                        ),
                                      ),
                              )
                            : const SizedBox.shrink(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: CustomTimer(
                            controller: _customTimerController,
                            builder: (CustomTimerState customTimerState,
                                CustomTimerRemainingTime remaining) {
                              if (customTimerState ==
                                  CustomTimerState.finished) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  setState(() {
                                    isResendCode = true;
                                  });
                                });
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Resend Code',
                                    style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(width: 28),
                                  Text(
                                    "${remaining.minutes} : ${remaining.seconds}",
                                    style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: isVerifyLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox(
                          height: 50,
                          width: getWidth(context: context),
                          child: StreamBuilder(
                              stream: _verifyOtpViewModel.outputIsCodeValid,
                              builder: (context, snapshot) {
                                return GestureDetector(
                                  onTap: () {
                                    if (snapshot.data == false) {
                                      _fToast.showToast(
                                          child: buildToast(
                                              type: ToastMessageType.failure,
                                              mes:
                                                  "Please enter OTP sent to ${widget.phoneNumber}"));
                                    }
                                  },
                                  child: ElevatedButton(
                                      onPressed: (snapshot.data ??
                                              false ||
                                                  _pinEditingController
                                                          .text.length ==
                                                      4)
                                          ? () {
                                              verifyOtp();
                                            }
                                          : null,
                                      child: const Text(
                                        'Verify OTP',
                                        style: TextStyle(fontSize: 15),
                                      )),
                                );
                              })),
                ),
                !isKeyboard
                    ? const SizedBox.shrink()
                    : const SizedBox(
                        height: 5,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
