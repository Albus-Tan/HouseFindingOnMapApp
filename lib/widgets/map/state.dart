import 'dart:ui';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/widgets/map/type.dart';
import 'package:flutter/foundation.dart';

@immutable
class MapState {
  final String id;
  final List<HouseMarker> oriMarkers;
  final List<HouseMarker> markers;
  final bool drawing;
  final List<Polyline> polyLines;

  final List<HouseMarker> markersInPolygon;
  final List<LatLng> polygon;
  final AMapController? controller;

  final CameraPosition cameraPosition;
  final Size widgetSize;

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
    required this.widgetSize,
    required this.oriMarkers,
  });

  MapState copyWith({
    String? id,
    List<HouseMarker>? markers,
    bool? drawing,
    List<Polyline>? polyLines,
    List<LatLng>? polygon,
    List<HouseMarker>? markersInPolygon,
    List<HouseMarker>? oriMarkers,
    AMapController? controller,
    CameraPosition? cameraPosition,
    Size? widgetSize,
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
        widgetSize: widgetSize ?? this.widgetSize,
        oriMarkers: oriMarkers ?? this.oriMarkers,
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
        target: LatLng(
          0,
          0,
        ),
      ),
      widgetSize: Size(0, 0),
      oriMarkers: [],
    );
  }
}
