import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/widgets/map/action.dart';
import 'package:app/widgets/map/state.dart';
import 'package:redux/redux.dart';

import 'type.dart';

final Reducer<MapState> mapReducer = combineReducers(
  [
    TypedReducer(_addMarker),
    TypedReducer(_updateMarker),
    TypedReducer(_removeMarker),
    TypedReducer(_addOriMarker),
    TypedReducer(_updateOriMarker),
    TypedReducer(_removeOriMarker),
    TypedReducer(_checkPointsInPolygon),
    TypedReducer(_startDrawPolygon),
    TypedReducer(_addPolygonPoint),
    TypedReducer(_endDrawPolygon),
    TypedReducer(_setController),
    TypedReducer(_updateCameraPosition),
    TypedReducer(_moveCamera),
    TypedReducer(_clear),
    TypedReducer(_clearPolygon),
    TypedReducer(_updateWidgetSize),
  ],
);

MapState _addMarker(MapState state, AddMarker action) {
  if (state.id == action.mapId) {
    final markers = state.markers;
    markers.add(action.marker);
    return state.copyWith(
      markers: markers,
    );
  } else {
    return state;
  }
}

MapState _updateMarker(MapState state, UpdateMarker action) {
  if (state.id == action.mapId) {
    final markers = keyByHosueMarkerId(state.markers);
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

    return state.copyWith(
      markers: markers.values.toList(),
    );
  } else {
    return state;
  }
}

MapState _removeMarker(MapState state, RemoveMarker action) {
  if (state.id == action.mapId) {
    final markers = keyByHosueMarkerId(state.markers);
    markers.remove(action.createId);

    return state.copyWith(
      markers: markers.values.toList(),
    );
  } else {
    return state;
  }
}

MapState _addOriMarker(MapState state, AddOriMarker action) {
  if (state.id == action.mapId) {
    final markers = state.markers;
    markers.add(action.marker);
    return state.copyWith(
      markers: markers,
    );
  } else {
    return state;
  }
}

MapState _updateOriMarker(MapState state, UpdateOriMarker action) {
  if (state.id == action.mapId) {
    final markers = keyByHosueMarkerId(state.markers);
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

    return state.copyWith(
      markers: markers.values.toList(),
    );
  } else {
    return state;
  }
}

MapState _removeOriMarker(MapState state, RemoveOriMarker action) {
  if (state.id == action.mapId) {
    final markers = keyByHosueMarkerId(state.markers);
    markers.remove(action.createId);

    return state.copyWith(
      markers: markers.values.toList(),
    );
  } else {
    return state;
  }
}

MapState _checkPointsInPolygon(MapState state, CheckPointsInPolygon action) {
  if (state.id == action.mapId) {
    final markers = state.markers;
    final markersInPolygon = <HouseMarker>[];
    final polygon = state.polygon;
    for (var marker in markers) {
      if (AMapTools.latLngIsInPolygon(marker.position, polygon)) {
        markersInPolygon.add(marker);
      }
    }

    return state.copyWith(
      markersInPolygon: markersInPolygon,
    );
  } else {
    return state;
  }
}

MapState _startDrawPolygon(MapState state, StartDrawPolygon action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      drawing: true,
    );
  } else {
    return state;
  }
}

MapState _addPolygonPoint(MapState state, AddPolygonPoint action) {
  if (state.id == action.mapId) {
    final position = action.position;
    final polygon = state.polygon;

    polygon.add(position);

    return state.copyWith(
      polygon: polygon,
    );
  } else {
    return state;
  }
}

MapState _endDrawPolygon(MapState state, EndDrawPolygon action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      drawing: false,
    );
  } else {
    return state;
  }
}

MapState _clearPolygon(MapState state, ClearPolygon action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      polygon: [],
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
      polygon: [],
      markers: [],
      polyLines: [],
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
