import 'dart:math';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'map/action.dart';
import 'map/state.dart';

class WidgetMarker {
  final String id;
  final LatLng position;
  final Widget? widget;
  final bool draggable;
  final void Function(String, LatLng)? onDragEnd;
  final void Function(String)? onTap;
  final bool clickable;

  WidgetMarker({
    required this.id,
    this.widget,
    required this.position,
    this.draggable = false,
    this.onDragEnd,
    this.onTap,
    this.clickable = false,
  });
}

class MapWidget extends StatelessWidget {
  const MapWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<MapState>(
      builder: (context, store) {
        final state = store.state;
        return Stack(
          children: [
            AMapWidget(
              polylines: Set.of(state.polyLines),
              polygons: state.polygon.isEmpty
                  ? <Polygon>{}
                  : <Polygon>{
                      Polygon(
                        points: state.polygon,
                      ),
                    },
              markers: Set.of(state.markers),
              onMapCreated: (controller) => store.dispatch(
                SetController(
                  mapId: state.id,
                  controller: controller,
                ),
              ),
              rotateGesturesEnabled: false,
              onCameraMoveEnd: (cameraPosition) {
                store.dispatch(
                  UpdateCameraPosition(
                    mapId: state.id,
                    cameraPosition: cameraPosition,
                  ),
                );
              },
            ),
            GestureDetector(
              onPanUpdate: state.drawing
                  ? (details) {
                      final screenPosition = details.localPosition;

                      final centerLatitude =
                          state.cameraPosition.target.latitude;
                      final centerLongitude =
                          state.cameraPosition.target.longitude;
                      final height = context.size!.height;
                      final width = context.size!.width;
                      final centerHeight = height / 2;
                      final centerWidth = width / 2;
                      final ratio = 1 / cos(centerLatitude * pi / 180);
                      final limitWidth = min(height, width);
                      // actualLatitude = pixel * a * exp( 2 * zoom )
                      final a = 2.0 - limitWidth / 2000;
                      store.dispatch(
                        AddPolygonPoint(
                          mapId: state.id,
                          position: LatLng(
                            (-a *
                                    (screenPosition.dy - centerHeight) *
                                    pow(2, -state.cameraPosition.zoom) /
                                    ratio +
                                centerLatitude),
                            (a *
                                    (screenPosition.dx - centerWidth) *
                                    pow(2, -state.cameraPosition.zoom) +
                                centerLongitude),
                          ),
                        ),
                      );
                    }
                  : null,
              onPanEnd: state.drawing
                  ? (detail) => store.dispatch(
                        EndDrawPolygon(
                          mapId: state.id,
                        ),
                      )
                  : null,
            )
          ],
        );
      },
    );
  }
}
