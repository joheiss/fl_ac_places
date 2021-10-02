import 'dart:convert';

import 'package:http/http.dart' as http;

const googleApiKey = 'AIzaSyCm-U0ndlszF88RL2I3F_QjoIeiZkMlAmk';

class LocationUtil {
  static String generateLocationPreviewImage({required double latitude, required double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$googleApiKey';
  }

  static Future<String> getLocationAddress(double lat, double lng) async {
    final uri = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleApiKey';
    final url = Uri.parse(uri);
    final response = await http.get(url);
    // print('[DEBUG] => response: ${jsonDecode(response.body)}');
    return jsonDecode(response.body)['results'][0]['formatted_address'];
  }
}
