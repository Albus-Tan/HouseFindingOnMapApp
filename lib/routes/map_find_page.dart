import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/common/extension/marker.dart';
import 'package:app/common/extension/widget.dart';
import 'package:app/widgets/map/action.dart';
import 'package:app/widgets/map_find_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../widgets/house_card.dart';
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

  Map<String, ResidentialMapFindMarker> residentialMarkers = {};
  String focusingMarkerId = "";

  void _initResidentialMarkers(Store<MapState> store,BuildContext context) {
    var residentialMarkerWidget = ResidentialMapFindMarker(
      residential: '丽景大厦',
      num: 12,
    );
    final marker = Marker(
      onTap: (id) {
        /// 依据 id 从 residentialMarkers 中取出对应 widget
        print("onTap$id");
        residentialMarkers[id]?.focus = true;
        focusingMarkerId = id;
        residentialMarkers[id]?.toUint8List().then((value) {
          store.dispatch(
            UpdateMarker(
              mapId: store.state.id,
              id: id,
              iconParam: BitmapDescriptor.fromBytes(value!),
            ),
          );
          _showHouseDetailListSheet(context);
        });
      },
      position: const LatLng(
        40,
        116.397451,
      ),
      draggable: false,
    )
        .copyWithWidget(
      widget: residentialMarkerWidget,
    )
        .then((value) {
      store.dispatch(
        AddMarker(
          mapId: store.state.id,
          marker: value,
        ),
      );

      /// 依据 id 向 residentialMarkers 中添加对应 widget
      residentialMarkers[value.id] = residentialMarkerWidget;
    });
  }


  void _showHouseDetailListSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // set this to true
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          // 设置父容器的高度 1 ~ 0, initialChildSize必须 <= maxChildSize
          expand: false,
          builder: (_, controller) {
            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  const ListTile(
                    title: Text(
                      '小区名称',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    subtitle: Text('均价·房源套数等信息'),
                    trailing: Icon(Icons.keyboard_arrow_down),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      controller: controller, // set this too
                      // 长度
                      itemCount: 15,
                      itemBuilder: (_, i) => const HouseCard(
                        title: "title",
                        rooms: 3,
                        squares: 33,
                        community: "community",
                        price: 250,
                        url: '',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StoreBuilder<MapState>(
          onInit: (store) {
            _initResidentialMarkers(store,context);
          },
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


