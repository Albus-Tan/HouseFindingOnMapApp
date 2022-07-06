import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/common/extension/marker.dart';
import 'package:app/widgets/map/action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../widgets/house_detail_bottom_sheet_on_map.dart';
import '../widgets/map.dart';
import '../widgets/map/reducer.dart';
import '../widgets/map/state.dart';

class MapFindPage extends StatefulWidget {
  const MapFindPage({Key? key}) : super(key: key);

  @override
  State<MapFindPage> createState() => _MapFindPageState();
}

class _MapFindPageState extends State<MapFindPage> {
  late Store<MapState> store;

  @override
  void initState() {
    super.initState();
    store = Store(mapReducer, initialState: MapState.initialState());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StoreBuilder<MapState>(
          builder: (context, store) {
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
            )
                .copyWithWidget(
                  widget: Container(
                    child: Text(
                      '111',
                      style: TextStyle(fontSize: 100),
                    ),
                  ),
                )
                .then(
                  (value) => store.dispatch(
                    AddMarker(
                      mapId: store.state.id,
                      marker: value,
                    ),
                  ),
                );

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
                              for (final element
                                  in store.state.markersInPolygon) {
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
                            child: Text("Check"),
                          ),
                          TextButton(
                            onPressed: () {
                              store.dispatch(
                                StartDrawPolygon(mapId: store.state.id),
                              );
                            },
                            child: Text("Draw"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        Column(
          children: const [
            Text('这是为了占用空间的一行字'),
            HouseDetailBottomSheet(),
          ],
        ),
      ],
    );
  }
}
