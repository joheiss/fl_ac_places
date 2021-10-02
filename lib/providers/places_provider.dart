import 'dart:io';

import 'package:ac_places/utilities/db_utils.dart';
import 'package:ac_places/utilities/location_utils.dart';
import 'package:flutter/material.dart';
import '../models/place.dart';

class PlacesProvider with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items => _items;

  Place? findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> fetchPlaces() async {
    final data = await DBUtil.queryTable('places');
    _items = data
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
            location: PlaceLocation(
              latitude: item['loc_lat'],
              longitude: item['loc_lng'],
              address: item['loc_address'],
            ),
          ),
        )
        .toList();
    notifyListeners();
  }

  Future<void> addPlace(String title, File image, PlaceLocation location) async {
    final place = Place(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      location: PlaceLocation(
        latitude: location.latitude,
        longitude: location.longitude,
        address: await LocationUtil.getLocationAddress(location.latitude, location.longitude),
      ),
      image: image,
    );
    _items.add(place);
    notifyListeners();
    DBUtil.insert('places', {
      'id': place.id,
      'title': place.title,
      'image': place.image.path,
      'loc_lat': place.location.latitude,
      'loc_lng': place.location.longitude,
      'loc_address': place.location.address!,
    });
  }
}
