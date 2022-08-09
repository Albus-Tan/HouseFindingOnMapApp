import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/widgets/map/action.dart';
import 'package:app/widgets/map/state.dart';
import 'package:redux/redux.dart';

import 'type.dart';

final Reducer<MapState> mapReducer = combineReducers(
  [
    TypedReducer(_setMapStatus),
    TypedReducer(_addMarker),
    TypedReducer(_updateMarker),
    TypedReducer(_removeMarker),
    TypedReducer(_checkCommunityMarkersInPolygon),
    TypedReducer(_setReachingCenter),
    TypedReducer(_setReachingPolygon),
    TypedReducer(_addDrawingPolygonPoint),
    TypedReducer(_setController),
    TypedReducer(_updateCameraPosition),
    TypedReducer(_moveCamera),
    TypedReducer(_clear),
    TypedReducer(_clearDrawingPolygon),
    TypedReducer(_updateWidgetSize),
  ],
);

MapState _setMapStatus(MapState state, SetMapStatus action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      mapStatus: action.mapStatus,
    );
  } else {
    return state;
  }
}

MapState _addMarker(MapState state, AddMarker action) {
  if (state.id == action.mapId) {
    late final List<HouseMarker> markers;
    switch (action.markerType) {
      case MarkerType.community:
        markers = state.communityMarkers;
        break;
      case MarkerType.origin:
        markers = state.oriMarkers;
        break;
      case MarkerType.district:
        markers = state.districtMarkers;
        break;
    }
    markers.add(action.marker);
    switch (action.markerType) {
      case MarkerType.community:
        return state.copyWith(
          communityMarkers: markers,
        );
      case MarkerType.origin:
        return state.copyWith(
          oriMarkers: markers,
        );
      case MarkerType.district:
        return state.copyWith(
          districtMarkers: markers,
        );
    }
  } else {
    return state;
  }
}

MapState _updateMarker(MapState state, UpdateMarker action) {
  if (state.id == action.mapId) {
    late final Map<String, HouseMarker> markers;
    switch (action.markerType) {
      case MarkerType.community:
        markers = keyByHouseMarkerId(state.communityMarkers);
        break;
      case MarkerType.origin:
        markers = keyByHouseMarkerId(state.oriMarkers);
        break;
      case MarkerType.district:
        markers = keyByHouseMarkerId(state.districtMarkers);
        break;
    }

    markers[action.id] = markers[action.id]!.copyWithHouses(
      alphaParam: action.alphaParam,
      anchorParam: action.anchorParam,
      clickableParam: action.clickableParam,
      draggableParam: action.draggableParam,
      iconParam: action.iconParam,
      infoWindowEnableParam: action.infoWindowEnableParam,
      infoWindowParam: action.infoWindowParam,
      onDragEndParam: action.onDragEndParam,
      onTapParam: action.onTapParam,
      positionParam: action.positionParam,
      rotationParam: action.rotationParam,
      visibleParam: action.visibleParam,
      housesParam: action.housesParam,
    );
    switch (action.markerType) {
      case MarkerType.community:
        return state.copyWith(
          communityMarkers: markers.values.toList(),
        );
      case MarkerType.origin:
        return state.copyWith(
          oriMarkers: markers.values.toList(),
        );
      case MarkerType.district:
        return state.copyWith(
          districtMarkers: markers.values.toList(),
        );
    }
  } else {
    return state;
  }
}

MapState _setReachingCenter(MapState state, SetReachingCenter action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      reachingCenter: action.reachingCenter,
    );
  } else {
    return state;
  }
}

MapState _removeMarker(MapState state, RemoveMarker action) {
  if (state.id == action.mapId) {
    late final Map<String, HouseMarker> markers;
    switch (action.markerType) {
      case MarkerType.community:
        markers = keyByHouseMarkerId(state.communityMarkers);
        break;
      case MarkerType.origin:
        markers = keyByHouseMarkerId(state.oriMarkers);
        break;
      case MarkerType.district:
        markers = keyByHouseMarkerId(state.districtMarkers);
        break;
    }
    markers.remove(action.createId);
    switch (action.markerType) {
      case MarkerType.community:
        return state.copyWith(
          communityMarkers: markers.values.toList(),
        );
      case MarkerType.origin:
        return state.copyWith(
          oriMarkers: markers.values.toList(),
        );
      case MarkerType.district:
        return state.copyWith(
          districtMarkers: markers.values.toList(),
        );
    }
  } else {
    return state;
  }
}

MapState _checkCommunityMarkersInPolygon(
    MapState state, CheckCommunityMarkersInPolygon action) {
  if (state.id == action.mapId) {
    final markers = state.communityMarkers;
    final markersInPolygon = <HouseMarker>[];

    late final Set<Polygon> polygons;

    switch (state.mapStatus) {
      case MapStatus.drawn:
        polygons = state.drawnPolygon.isEmpty
            ? {}
            : {
                Polygon(
                  points: state.drawnPolygon,
                ),
              };
        break;
      case MapStatus.selected:
      case MapStatus.recommending:
        polygons = state.reachingPolygon.toSet();
        break;
      default:
        return state;
    }

    for (final marker in markers) {
      for (final polygon in polygons) {
        if (AMapTools.latLngIsInPolygon(
          marker.position,
          polygon.points,
        )) {
          markersInPolygon.add(marker);
          break;
        }
      }
    }

    switch (state.mapStatus) {
      case MapStatus.drawn:
        return state.copyWith(
          markersInDrawingPolygon: markersInPolygon,
        );
      case MapStatus.selected:
      case MapStatus.recommending:
        return state.copyWith(
          markersInReachingPolygon: markersInPolygon,
        );
      case MapStatus.normal:
      case MapStatus.drawing:
      case MapStatus.selecting:
        return state;
    }
  } else {
    return state;
  }
}

MapState _addDrawingPolygonPoint(MapState state, AddDrawnPolygonPoint action) {
  if (state.id == action.mapId) {
    final position = action.position;
    final drawingPolygon = state.drawnPolygon;

    drawingPolygon.add(position);

    return state.copyWith(
      drawnPolygon: drawingPolygon,
    );
  } else {
    return state;
  }
}

MapState _clearDrawingPolygon(MapState state, ClearDrawingPolygon action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      drawnPolygon: [],
    );
  } else {
    return state;
  }
}

MapState _setReachingPolygon(MapState state, SetReachingPolygon action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      reachingPolygon: action.reachingPolygon,
    );
  } else {
    return state;
  }
}

MapState _setController(MapState state, SetController action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      controller: action.controller,
    );
  } else {
    return state;
  }
}

MapState _updateCameraPosition(MapState state, UpdateCameraPosition action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      cameraPosition: action.cameraPosition,
    );
  } else {
    return state;
  }
}

MapState _moveCamera(MapState state, MoveCamera action) {
  if (state.id == action.mapId) {
    state.controller?.moveCamera(
      CameraUpdate.newCameraPosition(
        action.cameraPosition,
      ),
    );
    return state.copyWith(cameraPosition: action.cameraPosition);
  }
  return state;
}

MapState _clear(MapState state, Clear action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      drawnPolygon: [],
      communityMarkers: [],
      reachingPolygon: [],
    );
  } else {
    return state;
  }
}

MapState _updateWidgetSize(MapState state, UpdateWidgetSize action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      widgetSize: action.widgetSize,
    );
  } else {
    return state;
  }
}
