import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/map.dart';
import 'package:flutter/material.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';


void main() {
  runApp(const App(
    title: 'Flutter Redux Demo',
  ));
  AMapFlutterLocation.updatePrivacyAgree(true);
  AMapFlutterLocation.updatePrivacyShow(true, true);
  const AMapPrivacyStatement(hasContains: true, hasShow: true, hasAgree: true);
}

class App extends StatelessWidget {
  final String title;

  const App({Key? key, required this.title}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final marker = WidgetMarker(
        position: const LatLng(40, 116.397451),
        id: '123',
        widget: const Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            "world",
            style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 100,
                backgroundColor: Color(0)),
          ),
        ),
        draggable: true,
        onDragEnd: (String id, LatLng position) {
          debugPrint("${id}dragged to $position");
        });

    return MaterialApp(
      title: title,
      home: MapWidget(
        markers: {marker},
        polyLines: {
          Polyline(
              points: [const LatLng(40, 116.397451), const LatLng(40, 117)],
              color: Colors.red)
        },
      ),
    );
  }
}
