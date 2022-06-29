import 'package:flutter/material.dart';

import '../widgets/map.dart';
import '../widgets/navigation_card.dart';

class MapNavigationPage extends StatefulWidget {
  const MapNavigationPage({Key? key}) : super(key: key);

  @override
  State<MapNavigationPage> createState() => _MapNavigationPageState();
}

class _MapNavigationPageState extends State<MapNavigationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const MapWidget(),
          const NavigationCard(),
          IconButton(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            iconSize: 40.0,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.chevron_left),
          ),
        ],
      ),
    );
  }
}
