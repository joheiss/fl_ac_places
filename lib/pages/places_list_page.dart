import 'package:ac_places/pages/place_details_page.dart';
import 'package:ac_places/providers/places_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'place_add_page.dart';

class PlacesListPage extends StatelessWidget {
  const PlacesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.placesListTitle ?? 'Your Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed(PlaceAddPage.routeName),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder(
      future: Provider.of<PlacesProvider>(context, listen: false).fetchPlaces(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        return Consumer<PlacesProvider>(
          child: Center(child: Text(l10n?.noData ?? 'No data.')),
          builder: (context, places, child) => places.items.isEmpty
              ? child!
              : ListView.builder(
                  itemCount: places.items.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: FileImage(places.items[index].image),
                    ),
                    title: Text(places.items[index].title),
                    subtitle: Text(places.items[index].location.address ?? 'No address found'),
                    onTap: () =>
                        Navigator.of(context).pushNamed(PlaceDetailsPage.routeName, arguments: places.items[index].id),
                  ),
                ),
        );
      },
    );
  }
}
