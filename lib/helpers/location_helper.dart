import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:lift_app/helpers/polyline_response_model.dart';

import 'dart:convert';
import '../app/constants.dart';

class LocationHelper {
  // static String mapImageUrl(
  //     {required double latitude, required double longitude}) {
  //   return "https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_MAP_API_KEY";
  // }

  static Future<List<dynamic>> getSuggestions(
      String input, double lat, double lng, String sessionToken) async {
    final requestUrl =
        '${Constants.googleMapPlacesUrl}?input=$input&location=$lat,$lng&radius=500&key=${Constants.googleMapApiKey}&sessiontoken=$sessionToken';
    final response = await http.get(Uri.parse(requestUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['predictions'];
    } else {
      throw Exception('Faild to load data');
    }
  }

  static Future<PolylineRoute> drawPolyline(Location pickUpLocation,
      Location destinationLocation, String sessionToken) async {
    final requestUrl =
        '${Constants.googleMapDirectionsUrl}?key=${Constants.googleMapApiKey}&units=metric&origin=${pickUpLocation.latitude},${pickUpLocation.longitude}&destination=${destinationLocation.latitude},${destinationLocation.longitude}&mode=driving&token=$sessionToken';
    try {
      final response = await http.post(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        PolylineRoute polylineRoute =
            PolylineRoute.fromJson(jsonDecode(response.body));

        return polylineRoute;
      } else {
        throw Exception('Something went wrong');
      }
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }

  static Future<String> getAddressFromLatLng(double lat, double lng) async {
    final url =
        '${Constants.convertLatLngToAddressString}?key=${Constants.googleMapApiKey}&language=en&latlng=$lat,$lng';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      String formattedAddress = data["results"][0]["formatted_address"];

      return formattedAddress;
    } else {
      throw 'Something went wrong.';
    }
  }
}
