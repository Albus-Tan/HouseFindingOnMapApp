import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';

import '../widgets/map.dart';
import '../widgets/navigation_card.dart';

class MapNavigationPage extends StatefulWidget {
  const MapNavigationPage({Key? key}) : super(key: key);

  @override
  State<MapNavigationPage> createState() => _MapNavigationPageState();
}

class _MapNavigationPageState extends State<MapNavigationPage> {

  String _polyline = "";
  List<LatLng> _polylinePoints = [];

  void _handleNavigation(String newPolyline) {
    _polylinePoints.clear();
    List<String> pointsStrs = newPolyline.split(";");
    for(int i = 0; i < pointsStrs.length; ++i){
      List<String> latlng = pointsStrs[i].split(",");
      double lat = double.parse(latlng[0]);
      double lng = double.parse(latlng[1]);
      _polylinePoints.add(LatLng(lat, lng));
    }
    setState(() {
      _polyline = newPolyline;
    });
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
          MapWidget(
            polyLines: _polylinePoints.isEmpty ? {} :{
              Polyline(
                  points: _polylinePoints,
                  color: Colors.red,
              )
            },
          ),
          NavigationCard(
            polyline: _polyline,
            onNavigate: _handleNavigation,
          ),
        ],
      ),
    );
  }
}
