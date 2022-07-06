import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/foundation.dart';

@immutable
class MapState {
  final String id;
  final List<Marker> markers;
  final bool drawing;
  final List<Polyline> polyLines;

  final List<Marker> markersInPolygon;
  final List<LatLng> polygon;
  final AMapController? controller;

  final CameraPosition cameraPosition;
  static int mapCount = 0;

  MapState({
    required this.polygon,
    required this.id,
    required this.markers,
    required this.drawing,
    required this.polyLines,
    required this.markersInPolygon,
    required this.cameraPosition,
    this.controller,
  });

  MapState copyWith({
    String? id,
    List<Marker>? markers,
    bool? drawing,
    List<Polyline>? polyLines,
    List<LatLng>? polygon,
    List<Marker>? markersInPolygon,
    AMapController? controller,
    CameraPosition? cameraPosition,
  }) =>
      MapState(
        id: id ?? this.id,
        markers: markers ?? this.markers,
        drawing: drawing ?? this.drawing,
        polyLines: polyLines ?? this.polyLines,
        polygon: polygon ?? this.polygon,
        markersInPolygon: markersInPolygon ?? this.markersInPolygon,
        controller: controller ?? this.controller,
        cameraPosition: cameraPosition ?? this.cameraPosition,
      );

  static MapState initialState() {
    mapCount++;
    return MapState(
        id: mapCount.toString(),
        markers: [],
        drawing: false,
        polyLines: [],
        markersInPolygon: [],
        polygon: [],
        cameraPosition: CameraPosition(
          target: LatLng(0, 0),
        ));
  }
}
