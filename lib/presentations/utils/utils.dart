import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:lift_app/presentations/home/settings/components/theme_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../resources/assets_manager.dart';

// void showMessage(BuildContext context, String message, Color color) {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       backgroundColor: color,
//       duration: const Duration(seconds: 3),
//       content: Text(message)));
// }
enum ToastMessageType { success, failure }

enum LocationErrorType {
  locationServiceError,
  locationPermissionError,
  locationPermissionForeverError
}

enum LocationType { pickUp, destination }

class Utils {
  BuildContext context;
  Utils({required this.context});

  bool get getTheme => ThemeProvider().getDarkTheme;
  Color get getThemeTextColor => getTheme ? Colors.white : Colors.black;

  Color get baseShimmerColor =>
      getTheme ? Colors.grey.shade500 : Colors.grey.shade200;

  Color get highlightShimmerColor =>
      getTheme ? Colors.grey.shade700 : Colors.grey.shade400;

  Color get widgetShimmerColor =>
      getTheme ? Colors.grey.shade600 : Colors.grey.shade100;
}

Widget buildToast({required ToastMessageType type, required String mes}) {
  return Container(
      decoration: BoxDecoration(
          color: ToastMessageType.success == type ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(6)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Text(
        mes,
        style: GoogleFonts.nunito(color: Colors.white, fontSize: 15),
      ));
}

Widget buildMainToast({required String mes}) {
  return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey[600], borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      alignment: Alignment.center,
      child: Text(
        mes,
        style: GoogleFonts.nunito(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      ));
}

class CountryCode {
  String countryCode = '+92';

  String getCountryCode() {
    return countryCode;
  }

  Widget pickCountryCode(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (ctx, themeProvider, _) {
      return CountryCodePicker(
        padding: const EdgeInsets.only(top: 10),
        onChanged: (code) {
          countryCode = code as String;
        },
        dialogSize: MediaQuery.of(context).size,
        initialSelection: '+92',
        enabled: false,
        textStyle: TextStyle(
            fontSize: 16,
            color: themeProvider.getDarkTheme ? Colors.white : Colors.black),
        showFlagDialog: true,
        showDropDownButton: true,
        favorite: const ['+92'],
      );
    });
  }
}

Future<Uint8List> getBytesFromAssets(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

double getHeight({required BuildContext context}) {
  return MediaQuery.of(context).size.height;
}

double getWidth({required BuildContext context}) {
  return MediaQuery.of(context).size.width;
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    final result = await Geolocator.openLocationSettings();

    if (!result) {
      return Future.error(LocationErrorType.locationServiceError);
      //Location services are disabled.
    }
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error(LocationErrorType.locationPermissionError);
      //Location permissions are denied
    }
  }

  if (permission == LocationPermission.deniedForever) {
    log('in denied forever');
    // Permissions are denied forever, handle appropriately.
    return Future.error(LocationErrorType.locationPermissionForeverError);
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

// Future<List<Placemark>> getAddressFromLatLong(
//     {required Position postion}) async {
//   List<Placemark> placemark =
//       await placemarkFromCoordinates(postion.latitude, postion.longitude);
//   return placemark;
// }

class CustomStyleArrow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.lightGreen
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
    const double triangleH = 10;
    const double triangleW = 12.0;
    final double width = size.width;
    final double height = size.height;

    final Path trianglePath = Path()
      ..moveTo(width / 2 - triangleW / 2, height)
      ..lineTo(width / 2, triangleH + height)
      ..lineTo(width / 2 + triangleW / 2, height)
      ..lineTo(width / 2 - triangleW / 2, height);
    canvas.drawPath(trianglePath, paint);
    final BorderRadius borderRadius = BorderRadius.circular(15);
    final Rect rect = Rect.fromLTRB(0, 0, width, height);
    final RRect outer = borderRadius.toRRect(rect);
    canvas.drawRRect(outer, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Widget noInternetConnectionWidget({required Size size}) {
  return SizedBox(
    height: size.height * 0.8,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            child: Lottie.asset(
          LottieAssets.internetError,
        )),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          width: size.width * 0.7,
          child: Text(
            'Please check your internet connection.',
            textAlign: TextAlign.center,
            style:
                GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        )
      ],
    ),
  );
}

Future<File?> cropImage({required File imageFile}) async {
  CroppedFile? croppedImage =
      await ImageCropper().cropImage(sourcePath: imageFile.path, uiSettings: [
    AndroidUiSettings(activeControlsWidgetColor: Colors.lightGreen),
  ]);
  if (croppedImage == null) {
    return null;
  }
  return File(croppedImage.path);
}

TimeOfDay convertTimeStringToTimeOfDay(String timeString) {
  final format = DateFormat("h:mm a"); // Create a time format object
  final time = format.parse(timeString); // Parse the time string

  return TimeOfDay.fromDateTime(time); // Convert to TimeOfDay object
}

DateTime convertDateStringToDateTime(String dateString) {
  final format = DateFormat('dd/MM/yyyy'); // Create a date format object
  final date = format.parse(dateString); // Parse the date string
  return date; // Return as DateTime object
}

bool isSameDay(String selectedDateString, DateTime nowDate) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final String nowDateString = formatter.format(nowDate);
  return selectedDateString == nowDateString;
}

bool isSameDaySearchRide(DateTime selectedDate, DateTime nowDate) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final String nowDateString = formatter.format(nowDate);
  final String selectedDateString = formatter.format(selectedDate);
  return selectedDateString == nowDateString;
}

bool isSelectedDateGreaterThanNow(DateTime selectedDate, DateTime nowDate) {
  return selectedDate.isAfter(nowDate);
}

bool isSelectedTimeGreaterThan15Minutes(DateTime time, DateTime nowTime) {
  Duration difference = time.difference(nowTime);
  int minutesDifference = difference.inMinutes;

  return minutesDifference > 15;
}

String convertDateToDateStringWithDay(DateTime dateTime) {
  String formattedDate = DateFormat('EEEE MMMM d, y').format(dateTime);

  return formattedDate;
}

String formatTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  DateFormat timeFormat =
      DateFormat.jm(); // Format for hours and minutes (e.g., 1:30 am)

  String formattedTime = timeFormat.format(dateTime); // Format the time

  return formattedTime;
}

String formatDate(String dateString) {
  DateTime date = DateTime.parse(dateString);
  DateFormat dayFormat = DateFormat.EEEE();
  DateFormat dateFormat = DateFormat.d();
  DateFormat monthFormat = DateFormat.MMMM();

  String dayOfWeek = dayFormat.format(date);
  String day = dateFormat.format(date);
  String month = monthFormat.format(date);

  return '$dayOfWeek - $day $month';
}

String formatDateToMonthDay(DateTime dateTime) {
  // Define the desired formats
  final monthFormat = DateFormat.MMMM(); // Full month name
  final dayFormat = DateFormat.d(); // Day of the month

  // Format the DateTime to the desired format
  String month = monthFormat.format(dateTime);
  String day = dayFormat.format(dateTime);

  return '$month $day';
}

String formatTimeToTimeString(DateTime dateTime) {
  // Define the desired format
  final timeFormat = DateFormat('h:mm a');

  // Format the DateTime to the desired format
  return timeFormat.format(dateTime);
}

void makePhoneCall(String phoneString) async {
  final String phoneNumber =
      'tel:$phoneString'; // Replace with the desired phone number
  if (await canLaunch(phoneNumber)) {
    await launch(phoneNumber);
  } else {
    throw 'Could not launch $phoneNumber';
  }
}

Future<bool> onWillPop() async {
  return false;
}
