import 'dart:math';

import 'package:app/widgets/house_detail_bottom_sheet_on_map.dart';
import 'package:flutter/material.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';

void main() {

  runApp(const App());
  AMapFlutterLocation.updatePrivacyAgree(true);
  AMapFlutterLocation.updatePrivacyShow(true, true);
  const AMapPrivacyStatement(hasContains: true, hasShow: true, hasAgree: true);

}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Stack(
          children: [
            const MapPage(title: 'Flutter Demo Home Page'),
            Column(
              children: [
                Text('111111'),
                HouseDetailBottomSheet(),
              ],
            ),

          ],
        ));
  }
}

class MapPage extends StatefulWidget {
  const MapPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Map<String, Marker> _initMarkerMap = <String, Marker>{};

  static const LatLng mapCenter = LatLng(39.909187, 116.397451);

  // @override
  // void initState() {
  //   super.initState();
  //   AMapFlutterLocation.setApiKey(
  //       '0f2a5fd4a1a5edf78a2207d69f0dd0c2', '0f2a5fd4a1a5edf78a2207d69f0dd0c2');
  // }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < 10; i++) {
      LatLng position = LatLng(mapCenter.latitude + sin(i * pi / 12.0) / 20.0,
          mapCenter.longitude + cos(i * pi / 12.0) / 20.0);
      Marker marker = Marker(position: position);
      _initMarkerMap[marker.id] = marker;
    }
    final map = AMapWidget(
      // apiKey: ConstConfig.amapApiKeys,
      markers: Set<Marker>.of(_initMarkerMap.values),
    );
    return Scaffold(
      body: Container(
        child: map,
      ),
    );
  }
}
