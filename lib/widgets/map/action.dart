import 'dart:ui';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/service/backend_service/house/rent_house.dart';
import 'package:app/widgets/map/type.dart';

class MapAction {
  final String mapId;

  MapAction({
    required this.mapId,
  });
}

class AddMarker extends MapAction {
  final HouseMarker marker;
  final MarkerType markerType;

  AddMarker({
    required super.mapId,
    required this.marker,
    required this.markerType,
  });
}

class UpdateMarker extends MapAction {
  final String id;
  final MarkerType markerType;
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
  final List<RentHouse>? housesParam;

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
    this.housesParam,
    required super.mapId,
    required this.id,
    required this.markerType,
  });
}

class RemoveMarker extends MapAction {
  final String createId;
  final MarkerType markerType;
  RemoveMarker({
    required this.createId,
    required super.mapId,
    required this.markerType,
  });
}

class CheckCommunityMarkersInPolygon extends MapAction {
  CheckCommunityMarkersInPolygon({
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
  final CameraPosition cameraPosition;

  MoveCamera({
    required super.mapId,
    required this.cameraPosition,
  });
}

class Clear extends MapAction {
  Clear({
    required super.mapId,
  });
}

class UpdateWidgetSize extends MapAction {
  final Size widgetSize;

  UpdateWidgetSize({
    required this.widgetSize,
    required super.mapId,
  });
}
