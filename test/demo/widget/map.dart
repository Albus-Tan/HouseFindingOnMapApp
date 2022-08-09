import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/widgets/map.dart';
import 'package:app/widgets/map/action.dart';
import 'package:app/widgets/map/reducer.dart';
import 'package:app/widgets/map/state.dart';
import 'package:app/widgets/map/type.dart';
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
                            CheckCommunityMarkersInPolygon(
                                mapId: store.state.id),
                          );
                          for (final element in store.state.markersInDrawingPolygon) {
                            store.dispatch(
                              UpdateMarker(
                                mapId: store.state.id,
                                markerType: MarkerType.community,
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
                            SetMapStatus(mapId: store.state.id,mapStatus: MapStatus.drawing),
                          );
                        },
                        child: Text(
                          "Draw",
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          final marker = HouseMarker(
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
                            houses: [],
                          );
                          store.dispatch(
                            AddMarker(
                              mapId: store.state.id,
                              markerType: MarkerType.community,
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
