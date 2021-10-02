import 'dart:io';

import 'package:ac_places/models/place.dart';
import 'package:ac_places/providers/places_provider.dart';
import 'package:ac_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../widgets/image_input.dart';

class PlaceAddPage extends StatefulWidget {
  static const routeName = '/place-add';

  const PlaceAddPage({Key? key}) : super(key: key);

  @override
  _PlaceAddPageState createState() => _PlaceAddPageState();
}

class _PlaceAddPageState extends State<PlaceAddPage> {
  final _titleController = TextEditingController();
  File? _pickedImage;
  PlaceLocation? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.placeAddTitle ?? 'Add a New Place'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: l10n?.titleInputLabel ?? 'title',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ImageInput(onSelectImage: _selectImage),
                  const SizedBox(height: 10),
                  LocationInput(onSelect: _selectLocation),
                ],
              ),
            ),
          ),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: Text(l10n?.addPlaceButtonLabel ?? 'Add Place'),
          onPressed: _savePlace,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            primary: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectLocation(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
  }

  void _savePlace() {
    if (_titleController.text.isEmpty || _pickedImage == null || _pickedLocation == null) return;
    Provider.of<PlacesProvider>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage!, _pickedLocation!);
    Navigator.of(context).pop();
  }
}
