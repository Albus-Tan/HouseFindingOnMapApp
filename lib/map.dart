import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/widget_to_image.dart';
import 'package:flutter/material.dart';

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

class MapWidget extends StatefulWidget {
  final bool scrollable;
  final bool drawable;
  final Iterable<WidgetMarker> markers;
  final Set<Polyline> polyLines;

  const MapWidget({
    Key? key,
    this.scrollable = true,
    this.drawable = false,
    this.markers = const <WidgetMarker>{},
    this.polyLines = const <Polyline>{},
  }) : super(key: key);

  @override
  State<MapWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapWidget> {
  final _markers = <String, Marker>{};
  final _polygonMarkers = <String, Marker>{};
  final _tags = <String, String>{};

  void _importExternalMarkers(Iterable<WidgetMarker> markers) {
    for (final element in markers) {
      final widget = element.widget;
      final onTap = element.onTap;
      final onTapConvert = onTap == null
          ? null
          : (String id) {
              String aid = _tags[id]!;
              onTap(aid);
            };
      final onDragEnd = element.onDragEnd;
      final onDragEndConvert = onDragEnd == null
          ? null
          : (String updateId, LatLng position) {
              String createId = _tags[updateId]!;
              final oldMarker = _markers[createId]!;
              final newMarker = Marker(
                position: position,
                clickable: oldMarker.clickable,
                draggable: oldMarker.draggable,
                icon: oldMarker.icon,
                onTap: oldMarker.onTap,
                onDragEnd: oldMarker.onDragEnd,
              );
              setState(() {
                _markers[createId] = newMarker;
                _tags.remove(updateId);
                _tags[_markers[createId]!.id] = createId;
              });

              onDragEnd(createId, position);
            };

      if (widget != null) {
        widgetToImage(widget: widget).then((value) {
          final marker = Marker(
            position: element.position,
            clickable: element.clickable,
            onTap: onTapConvert,
            draggable: element.draggable,
            onDragEnd: onDragEndConvert,
            icon: BitmapDescriptor.fromBytes(value!),
          );
          _tags[marker.id] = '${element.id}external';
          _markers['${element.id}external'] = marker;
        });
      } else {
        final marker = Marker(
          position: element.position,
          clickable: element.clickable,
          onTap: onTapConvert,
          draggable: element.draggable,
          onDragEnd: onDragEndConvert,
        );

        _tags[marker.id] = '${element.id}external';
        _markers['${element.id}external'] = marker;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _importExternalMarkers(widget.markers);
    final map = widget.drawable
        ? AMapWidget(
            scrollGesturesEnabled: widget.scrollable,
            markers: Set.of(_markers.values),
            onTap: (LatLng position) {
              final marker = Marker(
                position: position,
                draggable: true,
                onDragEnd: (String updateId, LatLng position) {
                  String createId = _tags[updateId]!;
                  final oldMarker = _markers[createId]!;
                  setState(() {
                    final newMarker = Marker(
                      position: position,
                      clickable: oldMarker.clickable,
                      draggable: oldMarker.draggable,
                      icon: oldMarker.icon,
                      onTap: oldMarker.onTap,
                      onDragEnd: oldMarker.onDragEnd,
                    );
                    if (_polygonMarkers.containsKey(createId)) {
                      _polygonMarkers[createId] = newMarker;
                    }
                    _markers[createId] = newMarker;

                    _tags.remove(createId);
                    _tags[_markers[createId]!.id] = createId;
                  });
                },
              );
              setState(() {
                _polygonMarkers[marker.id] = marker;
                _markers[marker.id] = marker;
                _tags[marker.id] = marker.id;
              });
            },
            polygons: _polygonMarkers.isEmpty
                ? {}
                : {
                    Polygon(
                      points: List.of(
                        _polygonMarkers.values.map((e) => e.position),
                      ),
                    ),
                  },
            polylines: widget.polyLines,
          )
        : AMapWidget(
            scrollGesturesEnabled: widget.scrollable,
            markers: Set.of(_markers.values),
            polylines: widget.polyLines,
          );
    return map;
  }
}
