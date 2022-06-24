
import 'dart:typed_data';

import 'package:app/WidgetIcon.dart';
import 'package:flutter/material.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'map.dart';

void main() {
  runApp(const App());
  AMapFlutterLocation.updatePrivacyAgree(true);
  AMapFlutterLocation.updatePrivacyShow(true, true);
  const AMapPrivacyStatement(hasContains: true, hasShow: true, hasAgree: true);
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const TestPage()
      home: TestPage(),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  var _pressed = false;
  late Uint8List bytes;
  var loaded = false;
  var end = false;

  @override
  void initState() {
    super.initState();
    // var window = const InfoWindow(title: "title", snippet: "body");
    widgetToImage(
      widget: const Directionality(
        textDirection: TextDirection.ltr,
        child: Text(
          "world",
          style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 50,
              backgroundColor: Color(0)),
        ),
      ),
    ).then((value) {
      setState(() {
        bytes = value!;
        loaded = true;
      });
    });
  }

  var markers = <String, Marker>{};

  @override
  Widget build(BuildContext context) {
    if (loaded && !end) {
      var marker = Marker(
        // position: const LatLng(39.909187, 116.397451),
        position: const LatLng(39.909187, 116.50),
        draggable: true,
        // icon: BitmapDescriptor.fromIconPath("assets/images.jpeg")
        icon: BitmapDescriptor.fromBytes(bytes),
        //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      );
      debugPrint(bytes.toString());
      markers[marker.id] = marker;
      end = true;
    }
    // var position = markers.toString();
    return loaded
        ? Stack(children: [
            // MapWidget(scrollable: _pressed),
            MapWidgetStateLess(
              scrollable: _pressed,
              markers: Set.of(markers.values),
            ),
            TextButton(
              onPressed: () => setState(() => _pressed = !_pressed),
              child: const Text("hello"),
            ),
            Center(
              child: Image.memory(bytes),
            ),
          ])
        : Stack(children: [
            // MapWidget(scrollable: _pressed),
            MapWidgetStateLess(
              scrollable: _pressed,
              markers: Set.of(markers.values),
            ),
            GestureDetector(
              onTap: () => setState(() => _pressed = !_pressed),
              child: const Text("hello"),
            )
          ]);
  }
}
