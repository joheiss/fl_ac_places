import 'package:ac_places/l10n/l10n.dart';
import 'package:ac_places/pages/place_add_page.dart';
import 'package:ac_places/pages/place_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/places_list_page.dart';
import 'providers/places_provider.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      primarySwatch: Colors.indigo,
    );

    return ChangeNotifierProvider(
      create: (context) => PlacesProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale('de'),
        supportedLocales: L10n.all,
        localizationsDelegates: L10n.localizationsDelegates,
        title: 'Flutter Demo',
        theme: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              secondary: Colors.amber,
            ),
            textTheme: theme.textTheme.copyWith(
              button: const TextStyle(color: Colors.black),
            )),
        home: const PlacesListPage(),
        routes: {
          PlaceAddPage.routeName: (context) => const PlaceAddPage(),
          PlaceDetailsPage.routeName: (context) => const PlaceDetailsPage(),
        },
      ),
    );
  }
}
