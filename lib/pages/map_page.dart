import 'package:ac_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapPage extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;
  const MapPage({
    Key? key,
    this.initialLocation = const PlaceLocation(latitude: 37.422, longitude: -122.084),
    this.isSelecting = false,
  }) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.mapPageTitle ?? 'Your Map'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _pickedLocation == null ? null : () => Navigator.of(context).pop(_pickedLocation),
            ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.initialLocation.latitude, widget.initialLocation.longitude),
        zoom: 16,
      ),
      onTap: widget.isSelecting ? _selectLocation : null,
      markers: _pickedLocation == null && widget.isSelecting ? {} : _markSelectedLocation(),
    );
  }

  void _selectLocation(LatLng position) {
    setState(() => _pickedLocation = position);
  }

  Set<Marker> _markSelectedLocation() {
    print('[DEBUG] => picked location: ${_pickedLocation?.latitude} / ${_pickedLocation?.longitude}');
    return {
      Marker(
          markerId: const MarkerId('m1'),
          position: _pickedLocation ?? LatLng(widget.initialLocation.latitude, widget.initialLocation.longitude)),
    };
  }
}
