import 'dart:ui';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';

class MapAction {
  final String mapId;

  MapAction({
    required this.mapId,
  });
}

class AddMarker extends MapAction {
  final Marker marker;

  AddMarker({
    required super.mapId,
    required this.marker,
  });
}

class UpdateMarker extends MapAction {
  final String id;
  final double? alphaParam;
  final Offset? anchorParam;
  final bool? clickableParam;
  final bool? draggableParam;
  final BitmapDescriptor? iconParam;
  final bool? infoWindowEnableParam;
  final InfoWindow? infoWindowParam;
  final LatLng? positionParam;
  final double? rotationParam;
  final bool? visibleParam;
  final ArgumentCallback<String?>? onTapParam;
  final MarkerDragEndCallback? onDragEndParam;

  UpdateMarker({
    this.alphaParam,
    this.anchorParam,
    this.clickableParam,
    this.draggableParam,
    this.iconParam,
    this.infoWindowEnableParam,
    this.infoWindowParam,
    this.positionParam,
    this.rotationParam,
    this.visibleParam,
    this.onTapParam,
    this.onDragEndParam,
    required super.mapId,
    required this.id,
  });
}

class RemoveMarker extends MapAction {
  final String createId;

  RemoveMarker({
    required this.createId,
    required super.mapId,
  });
}

class CheckPointsInPolygon extends MapAction {
  CheckPointsInPolygon({
    required super.mapId,
  });
}

class StartDrawPolygon extends MapAction {
  StartDrawPolygon({
    required super.mapId,
  });
}

class AddPolygonPoint extends MapAction {
  final LatLng position;

  AddPolygonPoint({
    required super.mapId,
    required this.position,
  });
}

class EndDrawPolygon extends MapAction {
  EndDrawPolygon({
    required super.mapId,
  });
}

class ClearPolygon extends MapAction {
  ClearPolygon({
    required super.mapId,
  });
}

class SetController extends MapAction {
  final AMapController controller;

  SetController({
    required super.mapId,
    required this.controller,
  });
}

class UpdateCameraPosition extends MapAction {
  final CameraPosition cameraPosition;

  UpdateCameraPosition({
    required super.mapId,
    required this.cameraPosition,
  });
}

class MoveCamera extends MapAction {
  final CameraUpdate cameraUpdate;

  MoveCamera({
    required super.mapId,
    required this.cameraUpdate,
  });
}

class Clear extends MapAction {
  Clear({
    required super.mapId,
  });
}
