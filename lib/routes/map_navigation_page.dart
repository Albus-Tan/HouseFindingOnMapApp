import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';

import '../widgets/navigation_card.dart';

class MapNavigationPage extends StatefulWidget {
  MapNavigationPage({Key? key}) : super(key: key);

  /// 导航的起始点终止点经纬度
  final String _oriLng = "116.484307";
  final String _oriLat = "39.90909";
  final String _desLng = "116.434446";
  final String _desLat = "39.90816";

  /// 导航的起始点终止点名称
  final String _oriText = "天安门";
  final String _desText = "一个目的地名字";

  @override
  State<MapNavigationPage> createState() => _MapNavigationPageState();
}

class _MapNavigationPageState extends State<MapNavigationPage> {
  String _polyline = "";
  List<LatLng> _polylinePoints = [];

  final Map<String, Marker> _initMarkerMap = <String, Marker>{};
  bool _hasInitMarker = false;
  static final String _startIconPath = 'assets/map/start.png';
  static final String _endIconPath = 'assets/map/end.png';

  @override
  void initState() {
    _initMarker();
    super.initState();
  }

  void _initMarker() async {
    if (_hasInitMarker) {
      return;
    }
    final LatLng oriMarkerPosition =
        LatLng(double.parse(widget._oriLat), double.parse(widget._oriLng));
    final LatLng desMarkerPosition =
        LatLng(double.parse(widget._desLat), double.parse(widget._desLng));
    Marker oriMarker = Marker(
        position: oriMarkerPosition,
        icon: BitmapDescriptor.fromIconPath(_startIconPath));
    Marker desMarker = Marker(
        position: desMarkerPosition,
        icon: BitmapDescriptor.fromIconPath(_endIconPath));
    setState(() {
      _hasInitMarker = true;
      _initMarkerMap[oriMarker.id] = oriMarker;
      _initMarkerMap[desMarker.id] = desMarker;
    });
  }

  void _handleNavigation(String newPolyline) {
    _polylinePoints.clear();
    print("_handleNavigation: $newPolyline");
    List<String> pointsStrs = newPolyline.split(";");
    for (int i = 0; i < pointsStrs.length; ++i) {
      List<String> latlng = pointsStrs[i].split(",");
      double lng = double.parse(latlng[0]);
      double lat = double.parse(latlng[1]);
      _polylinePoints.add(LatLng(lat, lng));
    }
    print(_polylinePoints);
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
          AMapWidget(
            initialCameraPosition: CameraPosition(
              // TODO: calculate zoom and center pos
              zoom: 12,
                target: LatLng(
                    (double.parse(widget._oriLat) +
                            double.parse(widget._desLat)) /
                        2 - 0.05,
                    (double.parse(widget._oriLng) +
                            double.parse(widget._desLng)) /
                        2)),
            markers: Set<Marker>.of(_initMarkerMap.values),
            polylines: _polylinePoints.isEmpty
                ? {}
                : {
                    Polyline(
                      width: 20,
                      customTexture: BitmapDescriptor.fromIconPath(
                          'assets/map/texture_green.png'),
                      joinType: JoinType.round,
                      points: _polylinePoints,
                    )
                  },
          ),
          NavigationCard(
            polyline: _polyline,
            onNavigate: _handleNavigation,
            oriLat: widget._oriLat,
            oriLng: widget._oriLng,
            desLat: widget._desLat,
            desLng: widget._desLng,
            oriText: widget._oriText,
            desText: widget._desText,
          ),
        ],
      ),
    );
  }
}
