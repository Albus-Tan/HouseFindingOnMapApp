import 'dart:math';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/widgets/map/type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../service/amap_api_service/amap_api_service.dart';
import '../utils/amap.dart';
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
  const MapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<MapState>(
      builder: (context, store) => LayoutBuilder(
        builder: (context, constrains) {
          final state = store.state;
          final markers = <Marker>[];
          late final List<Marker> pool;
          if (state.cameraPosition.zoom < state.zoomSwitch) {
            pool = state.districtMarkers.toList();
          } else {
            pool = state.communityMarkers.toList();
          }

          if (state.mapStatus == MapStatus.selected) {
            pool.add(
              HouseMarker(
                position: state.reachingCenter,
                icon: BitmapDescriptor.fromIconPath(
                  'assets/map/point.png',
                ),
                houses: [],
              ),
            );
          }

          switch (state.mapStatus) {
            case MapStatus.selected:
            case MapStatus.drawn:
            case MapStatus.normal:
            case MapStatus.recommending:
              for (var e in pool) {
                if (_getLatLngBound(
                  Size(
                    constrains.maxWidth,
                    constrains.maxHeight,
                  ),
                  store.state.cameraPosition,
                ).contains(
                  e.position,
                )) {
                  markers.add(e);
                }
              }
              break;
            case MapStatus.drawing:
            case MapStatus.selecting:
              break;
          }
          late final Set<Polygon> polygons;
          switch (state.mapStatus) {
            case MapStatus.drawing:
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
              polygons = state.reachingPolygon.toSet();
              break;
            default:
              polygons = {};
          }

          return Stack(
            children: [
              AMapWidget(
                minMaxZoomPreference: const MinMaxZoomPreference(
                  10.0,
                  20.0,
                ),
                initialCameraPosition: state.cameraPosition,
                polylines: {},
                polygons: polygons,
                markers: Set.of(markers),
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
                onTap: state.mapStatus == MapStatus.selecting
                    ? (position) {
                        store.dispatch(
                          SetMapStatus(
                            mapId: state.id,
                            mapStatus: MapStatus.selected,
                          ),
                        );
                        store.dispatch(
                          SetReachingCenter(
                            mapId: state.id,
                            reachingCenter: position,
                          ),
                        );
                        fetchReachCircle(centerPosition: position).then(
                          (reachCircle) {
                            store.dispatch(
                              SetReachingPolygon(
                                mapId: state.id,
                                reachingPolygon: reachCircle.polylines
                                    .map(
                                      (e) => Polygon(
                                        points: convertPolylineStr2Points(
                                          e.outer,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                            store.dispatch(
                              CheckCommunityMarkersInPolygon(
                                mapId: state.id,
                              ),
                            );
                          },
                        );
                      }
                    : (position) {},
              ),
              GestureDetector(
                onPanUpdate: state.mapStatus == MapStatus.drawing
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
                          AddDrawnPolygonPoint(
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
                onPanEnd: state.mapStatus == MapStatus.drawing
                    ? (detail) {
                        store.dispatch(
                          SetMapStatus(
                            mapId: state.id,
                            mapStatus: MapStatus.drawn,
                          ),
                        );
                        store.dispatch(
                          CheckCommunityMarkersInPolygon(
                            mapId: state.id,
                          ),
                        );
                      }
                    : null,
              )
            ],
          );
        },
      ),
    );
  }
}

LatLngBounds _getLatLngBound(Size size, CameraPosition cameraPosition) {
  final centerLatitude = cameraPosition.target.latitude;
  final centerLongitude = cameraPosition.target.longitude;
  final height = size.height;
  final width = size.width;
  final centerHeight = height / 2;
  final centerWidth = width / 2;
  final ratio = 1 /
      cos(
        centerLatitude * pi / 180,
      );
  final limitWidth = min(
    height,
    width,
  );
  // actualLatitude = pixel * a * exp( 2 * zoom )
  final a = 2.0 - limitWidth / 2000;
  final zoom = cameraPosition.zoom;
  return LatLngBounds(
    southwest: LatLng(
      centerLatitude -
          centerHeight *
              a *
              pow(
                2,
                -zoom,
              ) /
              ratio,
      centerLongitude -
          centerWidth *
              a *
              pow(
                2,
                -zoom,
              ),
    ),
    northeast: LatLng(
      centerLatitude +
          centerHeight *
              a *
              pow(
                2,
                -zoom,
              ) /
              ratio,
      centerLongitude +
          centerWidth *
              a *
              pow(
                2,
                -zoom,
              ),
    ),
  );
}
