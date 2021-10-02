import 'package:ac_places/models/place.dart';
import 'package:ac_places/pages/map_page.dart';
import 'package:ac_places/providers/places_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlaceDetailsPage extends StatelessWidget {
  static const routeName = '/place-details';

  const PlaceDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;
    final place = Provider.of<PlacesProvider>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(place?.title ?? 'No place found'),
      ),
      body: _buildBody(context, place!),
    );
  }

  Widget _buildBody(BuildContext context, Place place) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        SizedBox(
          height: 250,
          width: double.infinity,
          child: Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          place.location.address ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => MapPage(
                initialLocation: place.location,
                isSelecting: false,
              ),
            ),
          ),
          child: Text(l10n?.showMapButton ?? 'View on Map'),
          style: TextButton.styleFrom(
            primary: Theme.of(context).primaryColor,
          ),
        )
      ],
    );
  }
}
