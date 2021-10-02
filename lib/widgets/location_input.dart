import 'package:ac_places/models/place.dart';
import 'package:ac_places/pages/map_page.dart';
import 'package:ac_places/utilities/location_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelect;
  const LocationInput({Key? key, required this.onSelect}) : super(key: key);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewImageUrl == null
              ? Text(l10n?.noLocation ?? 'No location chosen!', textAlign: TextAlign.center)
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: const Icon(Icons.location_on),
              label: Text(l10n?.currentLocationButton ?? 'Current Location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: Text(l10n?.selectOnMapButton ?? 'Select on Map'),
            ),
          ],
        )
      ],
    );
  }

  Future<void> _getCurrentUserLocation() async {
    print('[DEBUG] => about to get current location via location service!');

    try {
      final latlng = await _getCurrentLocation();
      // print('[DEBUG] => Location coordinates: ${location.latitude} / ${location.longitude}');
      _generatePreview(latlng.latitude, latlng.longitude);
      widget.onSelect(latlng.latitude, latlng.longitude);
    } catch (e) {
      print('[DEBUG] => something went wrong: ${e.toString()}');
      return;
    }
  }

  Future<void> _selectOnMap() async {
    PlaceLocation initialLocation;
    try {
      final latlng = await _getCurrentLocation();
      initialLocation = PlaceLocation(latitude: latlng.latitude, longitude: latlng.longitude);
    } catch (e) {
      initialLocation = const PlaceLocation(latitude: 52.520008, longitude: 13.404954);
    }
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (context) => MapPage(
          isSelecting: true,
          initialLocation: initialLocation,
        ),
      ),
    );
    if (selectedLocation == null) return;
    _generatePreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelect(selectedLocation.latitude, selectedLocation.longitude);
  }

  void _generatePreview(double lat, double lng) {
    final mapUrl = LocationUtil.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() => _previewImageUrl = mapUrl);
  }

  Future<LatLng> _getCurrentLocation() async {
    final location = Location();
    // check if service is enabled
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('[DEBUG] => location service NOT enabled!');
        throw Exception('Location service not enabled');
      }
    }
    print('[DEBUG] => location service IS enabled!');

    // check if permission is granted
    PermissionStatus _permissionGranted;
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('[DEBUG] => location permission NOT granted!');
        throw Exception('Location service not enabled');
      }
    }
    print('[DEBUG] => location permission IS granted!');
    final locationData = await location.getLocation();
    return LatLng(locationData.latitude!, locationData.longitude!);
  }
}
