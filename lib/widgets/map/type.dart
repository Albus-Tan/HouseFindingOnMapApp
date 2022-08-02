import 'dart:ui';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/service/backend_service/house/rent_house.dart';

class HouseMarker extends Marker {
  final List<RentHouse> houses;

  HouseMarker({
    required super.position,
    super.alpha,
    super.anchor,
    super.clickable,
    super.draggable,
    super.icon,
    super.infoWindow,
    super.infoWindowEnable,
    super.onDragEnd,
    super.onTap,
    super.rotation,
    super.visible,
    super.zIndex,
    required this.houses,
  });

  HouseMarker copyWithHouses({
    double? alphaParam,
    Offset? anchorParam,
    bool? clickableParam,
    bool? draggableParam,
    BitmapDescriptor? iconParam,
    bool? infoWindowEnableParam,
    InfoWindow? infoWindowParam,
    LatLng? positionParam,
    double? rotationParam,
    bool? visibleParam,
    ArgumentCallback<String?>? onTapParam,
    MarkerDragEndCallback? onDragEndParam,
    List<RentHouse>? housesParam,
  }) {
    HouseMarker copyMark = HouseMarker(
      alpha: alphaParam ?? alpha,
      anchor: anchorParam ?? anchor,
      clickable: clickableParam ?? clickable,
      draggable: draggableParam ?? draggable,
      icon: iconParam ?? icon,
      infoWindowEnable: infoWindowEnableParam ?? infoWindowEnable,
      infoWindow: infoWindowParam ?? infoWindow,
      position: positionParam ?? position,
      rotation: rotationParam ?? rotation,
      visible: visibleParam ?? visible,
      zIndex: zIndex,
      onTap: onTapParam ?? onTap,
      onDragEnd: onDragEndParam ?? onDragEnd,
      houses: housesParam ?? houses,
    );
    copyMark.setIdForCopy(id);
    return copyMark;
  }

  @override
  HouseMarker clone() {
    return copyWithHouses();
  }
}

Map<String, HouseMarker> keyByHouseMarkerId(Iterable<HouseMarker> markers) {
  return Map<String, HouseMarker>.fromEntries(
    markers.map(
      (HouseMarker marker) => MapEntry<String, HouseMarker>(
        marker.id,
        marker.clone(),
      ),
    ),
  );
}

enum MarkerType {
  origin,
  community,
  district,
}

enum MapStatus {
  normal,
  drawing,
  drawn,
  selecting,
  selected,
  recommending,
}
