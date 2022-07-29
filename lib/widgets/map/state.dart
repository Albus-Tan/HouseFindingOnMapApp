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
  final MapStatus mapStatus;

  final List<HouseMarker> markersInDrawingPolygon;
  final List<LatLng> drawnPolygon;

  final List<HouseMarker> markersInReachingPolygon;
  final List<LatLng> reachingPolygon;

  final AMapController? controller;

  final CameraPosition cameraPosition;
  final Size widgetSize;

  final double zoomSwitch;

  static int mapCount = 0;

  MapState({
    required this.zoomSwitch,
    required this.drawnPolygon,
    required this.id,
    required this.communityMarkers,
    required this.districtMarkers,
    required this.mapStatus,
    required this.markersInDrawingPolygon,
    required this.markersInReachingPolygon,
    required this.reachingPolygon,
    required this.cameraPosition,
    this.controller,
    required this.widgetSize,
    required this.oriMarkers,
  });

  MapState copyWith(
          {String? id,
          List<HouseMarker>? communityMarkers,
          List<HouseMarker>? districtMarkers,
          MapStatus? mapStatus,
          List<LatLng>? drawnPolygon,
          List<HouseMarker>? markersInDrawingPolygon,
          bool? selectingReachingCenter,
          List<LatLng>? reachingPolygon,
          List<HouseMarker>? markersInReachingPolygon,
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
        mapStatus: mapStatus ?? this.mapStatus,
        drawnPolygon: drawnPolygon ?? this.drawnPolygon,
        markersInDrawingPolygon:
            markersInDrawingPolygon ?? this.markersInDrawingPolygon,
        reachingPolygon: reachingPolygon ?? this.reachingPolygon,
        markersInReachingPolygon:
            markersInReachingPolygon ?? this.markersInReachingPolygon,
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
      mapStatus: MapStatus.normal,
      markersInDrawingPolygon: [],
      drawnPolygon: [],
      markersInReachingPolygon: [],
      reachingPolygon: [],
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
