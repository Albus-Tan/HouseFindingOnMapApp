import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/widgets/map.dart';
import 'package:app/widgets/map/action.dart';
import 'package:app/widgets/map/reducer.dart';
import 'package:app/widgets/map/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() {
  final store = Store(
    mapReducer,
    initialState: MapState.initialState(),
  );

  runApp(
    StoreProvider(
      store: store,
      child: App(),
    ),
  );
  AMapFlutterLocation.updatePrivacyAgree(true);
  AMapFlutterLocation.updatePrivacyShow(true, true);
  const AMapPrivacyStatement(
    hasContains: true,
    hasShow: true,
    hasAgree: true,
  );
}

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(
          key: key,
        );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<MapState>(
      builder: (context, store) {
        return MaterialApp(
          home: Scaffold(
            body: StoreProvider(
              store: store,
              child: Stack(
                children: [
                  MapWidget(),
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          store.dispatch(
                            CheckPointsInPolygon(mapId: store.state.id),
                          );
                          for (final element in store.state.markersInPolygon) {
                            store.dispatch(
                              UpdateMarker(
                                mapId: store.state.id,
                                id: element.id,
                                iconParam:
                                    BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueOrange,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Check",
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          store.dispatch(
                            StartDrawPolygon(mapId: store.state.id),
                          );
                        },
                        child: Text(
                          "Draw",
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          final marker = Marker(
                            position: const LatLng(
                              40,
                              116.397451,
                            ),
                            draggable: true,
                            onDragEnd: (
                              String id,
                              LatLng position,
                            ) {
                              debugPrint("${id}dragged to $position");
                            },
                          );
                          store.dispatch(
                            AddMarker(
                              mapId: store.state.id,
                              marker: marker,
                            ),
                          );
                        },
                        child: Text(
                          "Add Point",
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
