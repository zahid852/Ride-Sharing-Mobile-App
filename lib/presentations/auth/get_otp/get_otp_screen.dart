import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/data/network/failure.dart';
import 'package:lift_app/presentations/auth/get_otp/get_otp_viewmodel.dart';
import 'package:lift_app/presentations/resources/assets_manager.dart';
import 'package:lift_app/presentations/resources/routes_manager.dart';
import '../../utils/utils.dart';

class GetOtpScreen extends StatefulWidget {
  const GetOtpScreen({Key? key}) : super(key: key);
  @override
  State<GetOtpScreen> createState() => _GetOtpScreenState();
}

class _GetOtpScreenState extends State<GetOtpScreen> {
  final GetOtpViewModel _getOtpViewModel = GetOtpViewModel();
  final CountryCode _countryCode = CountryCode();
  final TextEditingController _phoneEditingController = TextEditingController();
  final FToast _fToast = FToast();

  bool isLoading = false;
  void _bind() {
    _phoneEditingController.addListener(() {
      _getOtpViewModel.setPhoneNumber(_phoneEditingController.text);
    });
  }

  @override
  void initState() {
    _bind();
    _fToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    _getOtpViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    bool isKeyboard = viewInsetsBottom != 0;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
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
                                  height: 25,
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
                            height: 10,
                          ),
                          Container(
                            width: getWidth(context: context),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Text(
                              'We will send you one-time password to this number',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.nunito(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            width: getWidth(context: context),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Text(
                              'Enter phone number',
                              style: GoogleFonts.nunito(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(
                            height: 2.5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: TextField(
                              controller: _phoneEditingController,
                              keyboardType: TextInputType.number,
                              textAlignVertical: TextAlignVertical.center,
                              maxLength: 10,
                              style: const TextStyle(fontSize: 17),
                              decoration: InputDecoration(
                                hintText: "3235786327",
                                // contentPadding: const EdgeInsets.only(),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.5),
                                  child: _countryCode.pickCountryCode(context),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox(
                            height: 50,
                            width: getWidth(context: context),
                            child: StreamBuilder(
                                stream: _getOtpViewModel.outputIsNumberValid,
                                builder: (context, snapshot) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (snapshot.data == false) {
                                        _fToast.showToast(
                                            child: buildToast(
                                                type: ToastMessageType.failure,
                                                mes:
                                                    "Please enter your phone number to be able to get OTP"));
                                      }
                                    },
                                    child: ElevatedButton(
                                        onPressed: (snapshot.data ??
                                                false ||
                                                    _phoneEditingController
                                                            .text.length ==
                                                        10)
                                            ? () {
                                                getOtp();
                                              }
                                            : null,
                                        child: const Text(
                                          'Get OTP',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
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
      ),
    );
  }

  void getOtp() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });
    String phoneNumber =
        '${_countryCode.countryCode}${_phoneEditingController.text}';
    try {
      await _getOtpViewModel.getOtp(phoneNumber);
      // setState(() {
      //   isLoading = false;
      // });

      if (!mounted) return;
      Navigator.of(context)
          .pushReplacementNamed(Routes.verifyOtpRoute, arguments: phoneNumber);
    } on Failure catch (_) {
      setState(() {
        isLoading = false;
      });

      // Navigator.of(context)
      //     .pushReplacementNamed(Routes.verifyOtpRoute, arguments: phoneNumber);
      _fToast.showToast(
          child: buildToast(
              type: ToastMessageType.failure,
              mes: 'Something went wrong. Please try again!'));
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      //only error to be handle later in get otp
      // Navigator.of(context)
      //     .pushReplacementNamed(Routes.verifyOtpRoute, arguments: phoneNumber);
      _fToast.showToast(
          child: buildToast(
              type: ToastMessageType.failure,
              mes: "Something went wrong.Please try again!"));
    }
  }
}
