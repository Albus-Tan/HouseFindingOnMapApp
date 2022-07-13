import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';

import '../utils/storage.dart';
import '../widgets/navigation_card.dart';

class MapNavigationPage extends StatefulWidget {
  MapNavigationPage(
      {Key? key,
      required this.oriLng,
      required this.oriLat,
      required this.desLng,
      required this.desLat,
      required this.oriText,
      required this.desText})
      : super(key: key);

  /// 导航的起始点终止点经纬度
  final String oriLng;
  final String oriLat;
  final String desLng;
  final String desLat;

  /// 导航的起始点终止点名称
  final String oriText;
  final String desText;

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

  late Future<void> _futureBuilderFuture;
  late String _oriLat;
  late String _oriLng;
  late String _oriText;

  @override
  void initState() {
    _oriLat = widget.oriLat;
    _oriLng = widget.oriLng;
    _oriText = widget.oriText;
    _futureBuilderFuture = initData();
    super.initState();

  }

  Future<void> _initMarker() async {
    if (_hasInitMarker) {
      return;
    }
    final LatLng oriMarkerPosition =
        LatLng(double.parse(_oriLat), double.parse(_oriLng));
    final LatLng desMarkerPosition =
        LatLng(double.parse(widget.desLat), double.parse(widget.desLng));
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

  Future<void> getPos() async {
    if(_oriLat == '' || _oriLng == ''){
      await StorageUtil.getDoubleItem('lat').then((res) async => {
        print(res),
        _oriLat = res.toString(),
      });
      await StorageUtil.getDoubleItem('lng').then((res) async => {
        print(res),
        _oriLng = res.toString(),
      });
      await StorageUtil.getStringItem('address').then((res) async => {
        print(res),
        _oriText = res.toString(),
      });
    }
    await _initMarker();
  }

  Future<void> initData() async {
    await getPos();
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
      body: FutureBuilder(
          future: _futureBuilderFuture,
          builder: (BuildContext context, AsyncSnapshot snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.redAccent,
                ),
              );
            } else if (snapShot.connectionState == ConnectionState.done) {
              print(snapShot.hasError);
              return Stack(
                children: [
                  AMapWidget(
                    initialCameraPosition: CameraPosition(
                      // TODO: calculate zoom and center pos
                      zoom: 12,
                      target: LatLng(
                          (double.parse(_oriLat) +
                                      double.parse(widget.desLat)) /
                                  2 -
                              0.05,
                          (double.parse(_oriLng) +
                                  double.parse(widget.desLng)) /
                              2),
                    ),
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
                    oriLat: _oriLat,
                    oriLng: _oriLng,
                    desLat: widget.desLat,
                    desLng: widget.desLng,
                    oriText: _oriText,
                    desText: widget.desText,
                  ),
                ],
              );
            } else {
              return Text('Error: ${snapShot.error}');
            }
          }),
    );
  }
}
