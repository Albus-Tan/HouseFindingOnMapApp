import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import '../widgets/map.dart';
import '../widgets/map/reducer.dart';
import '../widgets/map/state.dart';
import '../widgets/navigation_card.dart';

class MapNavigationPage extends StatefulWidget {
  const MapNavigationPage({Key? key}) : super(key: key);

  @override
  State<MapNavigationPage> createState() => _MapNavigationPageState();
}

class _MapNavigationPageState extends State<MapNavigationPage> {
  late Store<MapState> store;

  @override
  void initState() {
    super.initState();
    store = Store(mapReducer, initialState: MapState.initialState());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "导航",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          //padding: const EdgeInsets.symmetric(vertical: 24.0),

          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          MapWidget(),
          NavigationCard(),
        ],
      ),
    );
  }
}
