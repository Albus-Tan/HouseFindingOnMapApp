import 'dart:ui';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/widgets/map/type.dart';
import 'package:flutter/foundation.dart';

@immutable
class MapState {
  final String id;
  final List<HouseMarker> oriMarkers;
  final List<HouseMarker> communityMarkers;
  final List<HouseMarker> districtMarkers;
  final bool drawing;
  final List<Polyline> polyLines;

  final List<HouseMarker> markersInPolygon;
  final List<LatLng> polygon;
  final AMapController? controller;

  final CameraPosition cameraPosition;
  final Size widgetSize;

  final double zoomSwitch;

  static int mapCount = 0;

  MapState({
    required this.zoomSwitch,
    required this.polygon,
    required this.id,
    required this.communityMarkers,
    required this.districtMarkers,
    required this.drawing,
    required this.polyLines,
    required this.markersInPolygon,
    required this.cameraPosition,
    this.controller,
    required this.widgetSize,
    required this.oriMarkers,
  });

  MapState copyWith(
          {String? id,
          List<HouseMarker>? communityMarkers,
          List<HouseMarker>? districtMarkers,
          bool? drawing,
          List<Polyline>? polyLines,
          List<LatLng>? polygon,
          List<HouseMarker>? markersInPolygon,
          List<HouseMarker>? oriMarkers,
          AMapController? controller,
          CameraPosition? cameraPosition,
          Size? widgetSize,
          double? zoomSwitch}) =>
      MapState(
        id: id ?? this.id,
        zoomSwitch: zoomSwitch ?? this.zoomSwitch,
        communityMarkers: communityMarkers ?? this.communityMarkers,
        districtMarkers: districtMarkers ?? this.districtMarkers,
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
      zoomSwitch: 13.0,
      communityMarkers: [],
      districtMarkers: [],
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
