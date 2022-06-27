import 'dart:typed_data';

// import 'package:app/WidgetIcon.dart';
import 'package:flutter/material.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'map.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() {
  final store = Store(
      combineReducers([TypedReducer(addReducer), TypedReducer(moveReducer)]),
      initialState: AppState(markers: {}, tags: {}));
  runApp(App(
    title: 'Flutter Redux Demo',
    store: store,
  ));
  AMapFlutterLocation.updatePrivacyAgree(true);
  AMapFlutterLocation.updatePrivacyShow(true, true);
  const AMapPrivacyStatement(hasContains: true, hasShow: true, hasAgree: true);
}

class App extends StatelessWidget {
  final Store<AppState> store;
  final String title;

  const App({Key? key, required this.store, required this.title})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
          title: title,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: StoreBuilder<AppState>(
            builder: (BuildContext context, Store<AppState> store) =>
                TestReduxPage(
              key: key,
              store: store,
              context: context,
            ),
          ),
        ));
  }
}

//State
class AppState {
  late final Map<String, Marker> markers;
  late final Map<String, String> tags;

  AppState({required this.markers, required this.tags});
}

//Actions
class MoveAction {
  late final LatLng position;
  late final String id;

  MoveAction({required this.id, required this.position});
}

class AddAction {
  late final LatLng position;
  late final void Function(String id, LatLng position) dragEnd;

  AddAction({required this.position, required this.dragEnd});
}

//Reducers
AppState addReducer(AppState mapState, AddAction action) {
  final markers = mapState.markers;
  final marker = Marker(
      position: action.position, draggable: true, onDragEnd: action.dragEnd);

  var tags = mapState.tags;
  markers[marker.id] = marker;
  tags[marker.id] = marker.id;
  return AppState(markers: markers, tags: tags);
}

AppState moveReducer(AppState mapState, MoveAction action) {
  var tags = mapState.tags;
  var markers = mapState.markers;

  final createId = tags[action.id]!;
  final modifyId = action.id;
  final marker = markers[createId];

  final newMarker = Marker(
      position: action.position,
      onDragEnd: marker?.onDragEnd,
      draggable: marker!.draggable);

  markers[createId] = newMarker;
  tags.remove(modifyId);
  tags[newMarker.id] = createId;
  return AppState(markers: markers, tags: tags);
}

//Pages
class TestReduxPage extends StatefulWidget {
  const TestReduxPage({Key? key, required this.context, required this.store})
      : super(key: key);
  final Store<AppState> store;
  final BuildContext context;

  @override
  createState() => _TestReduxPageState();
}

class _TestReduxPageState extends State<TestReduxPage> {
  var _pressed = false;
  late Uint8List bytes;
  var loaded = false;
  var end = false;

  @override
  void initState() {
    super.initState();
    // var window = const InfoWindow(title: "title", snippet: "body");
    // widgetToImage(
    //   widget: const Directionality(
    //     textDirection: TextDirection.ltr,
    //     child: Text(
    //       "world",
    //       style: TextStyle(
    //           color: Color(0xFF000000),
    //           fontSize: 50,
    //           backgroundColor: Color(0x00000000)),
    //     ),
    //   ),
    // ).then((value) {
    //   setState(() {
    //     bytes = value!;
    //     loaded = true;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    // if (loaded && !end) {
    //   var marker = Marker(
    //     // position: const LatLng(39.909187, 116.397451),
    //     position: const LatLng(39.909187, 116.50),
    //     draggable: true,
    //     // icon: BitmapDescriptor.fromIconPath("assets/images.jpeg")
    //     icon: BitmapDescriptor.fromBytes(bytes),
    //     //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    //   );
    //   debugPrint(bytes.toString());
    //   markers[marker.id] = marker;
    //   end = true;
    // }
    // var position = markers.toString();
    return StoreProvider(
        store: widget.store,
        child: Stack(children: [
          StoreConnector<AppState, Map<String, Marker>>(
              builder: (context, markers) => MapWidgetStateLess(
                    scrollable: _pressed,
                    markers: Set.of(markers.values),
                    onTap: (LatLng position) {
                      widget.store.dispatch(AddAction(
                          position: position,
                          dragEnd: (String id, LatLng position) {
                            widget.store.dispatch(
                                MoveAction(position: position, id: id));
                          }));
                    },
                  ),
              converter: (store) => store.state.markers),
          TextButton(
            onPressed: () => setState(() => _pressed = !_pressed),
            child: const Text("hello"),
          ),
          // Center(
          //   child: Image.memory(bytes),
          // ),
        ]));
  }
}
