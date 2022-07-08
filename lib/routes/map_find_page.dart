import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/common/extension/marker.dart';
import 'package:app/common/extension/widget.dart';
import 'package:app/widgets/map/action.dart';
import 'package:app/widgets/map_find_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:bruno/bruno.dart';
import '../widgets/house_card.dart';
import '../widgets/house_list/house_data.dart';
import '../widgets/map.dart';
import '../widgets/map/state.dart';
import '../widgets/selection.dart';

class MapFindPage extends StatefulWidget {
  const MapFindPage({Key? key}) : super(key: key);

  @override
  State<MapFindPage> createState() => _MapFindPageState();
}

class _MapFindPageState extends State<MapFindPage> {
  /// 正在画圈
  bool isDrawing = false;

  /// 地图上房源小区 Marker
  Map<String, ResidentialMapFindMarker> residentialMarkers = {};
  String focusingMarkerId = "";

  /// 筛选条件组件
  late Widget selection;
  bool selectionInitialized = false;
  LatLng currentPosition = const LatLng(31.2382, 121.4913);

  void callback(int menuIndex,
      Map<String, String> filterParams,
      Map<String, String> customParams,
      BrnSetCustomSelectionMenuTitle setCustomTitleFunction){

  }

  @override
  void initState() {
    super.initState();
    AMapFlutterLocation().startLocation();
    AMapFlutterLocation().onLocationChanged().listen(
          (Map<String, Object> result) {
        print(result.toString());
        currentPosition = LatLng(
          double.parse(
            result['latitude'].toString(),
          ),
          double.parse(
            result['longitude'].toString(),
          ),
        );
      },
    );

    selectionView('assets/json/selection.json', callback).then(
      (value) => setState(
        () {
          selection = value;
          selectionInitialized = true;
        },
      ),
    );
  }

  void _initResidentialMarkers(Store<MapState> store) {
    var residentialMarkerWidget = ResidentialMapFindMarker(
      residential: '丽景大厦',
      num: 12,
    );
    Marker(
      onTap: (id) => _markerOnTap(id, store, context),
      position: const LatLng(31.2372, 121.4923),
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

  void _markerOnTap(String id, Store<MapState> store, BuildContext context) {
    /// 依据 id 从 residentialMarkers 中取出对应 widget
    print("onTap$id");
    residentialMarkers[focusingMarkerId]?.focus = false;
    residentialMarkers[id]?.focus = true;
    focusingMarkerId = id;
    residentialMarkers[id]?.toUint8List().then(
      (value) {
        store.dispatch(
          UpdateMarker(
            mapId: store.state.id,
            id: id,
            iconParam: BitmapDescriptor.fromBytes(value!),
          ),
        );
      },
    );
    _showHouseDetailListSheet(context);
  }

  void _showHouseDetailListSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // set this to true
      builder: (_) => DraggableScrollableSheet(
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
                    itemBuilder: (_, i) => HouseCard(
                      houseDetail: toDetail(
                        "整租 | 城市经典高迪 2室2厅1卫 10500元月 108平",
                        2,
                        108,
                        "城市经典高迪",
                        10500,
                        "https://pic4.58cdn.com.cn/anjuke_58/036b1dd7f06f0091bea434be71b8eb3b?w=240&h=180&ss=1&crop=1&cpos=middle&w=240&h=180&crop=1&t=1&srotate=1",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _updateMarkersInPolygon(Store<MapState> store) {
    for (final element in store.state.markersInPolygon) {
      residentialMarkers[element.id]?.inPolygon = true;
      residentialMarkers[element.id]?.toUint8List().then(
            (value) {
          store.dispatch(
            UpdateMarker(
              mapId: store.state.id,
              id: element.id,
              iconParam: BitmapDescriptor.fromBytes(value!),
            ),
          );
        },
      );
    }
  }

  void _resetAllMarkersInPolygon(Store<MapState> store){
    for (final element in store.state.markersInPolygon) {
      residentialMarkers[element.id]?.inPolygon = false;
      residentialMarkers[element.id]?.toUint8List().then(
            (value) {
          store.dispatch(
            UpdateMarker(
              mapId: store.state.id,
              id: element.id,
              iconParam: BitmapDescriptor.fromBytes(value!),
            ),
          );
        },
      );
    }
  }

  void _resetAllMarkers(Store<MapState> store){
    for (final element in store.state.markers) {
      residentialMarkers[element.id]?.inPolygon = false;
      residentialMarkers[element.id]?.toUint8List().then(
            (value) {
          store.dispatch(
            UpdateMarker(
              mapId: store.state.id,
              id: element.id,
              iconParam: BitmapDescriptor.fromBytes(value!),
            ),
          );
        },
      );
    }
  }

  Widget buildOperationsWhenDrawing(Store<MapState> store) {

    /// update Markers style In Polygon
    //_updateMarkersInPolygon(store);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BrnIconButton(
          widgetHeight: 60,
          widgetWidth: 40,
          name: '重画',
          iconWidget: const Icon(Icons.gesture),
          onTap: () {
            _resetAllMarkersInPolygon(store);
            store.dispatch(
              ClearPolygon(mapId: store.state.id),
            );
            store.dispatch(
              StartDrawPolygon(mapId: store.state.id),
            );
          },
        ),
        BrnIconButton(
          widgetHeight: 60,
          widgetWidth: 40,
          name: '退出',
          iconWidget: const Icon(Icons.arrow_back),
          onTap: () {
            _resetAllMarkersInPolygon(store);
            store.dispatch(
              ClearPolygon(mapId: store.state.id),
            );
            setState(() {
              isDrawing = false;
            });
          },
        ),
      ],
    );
  }

  Widget buildOperationsWhenNotDrawing(Store<MapState> store) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BrnIconButton(
          widgetHeight: 60,
          widgetWidth: 40,
          name: '画区域',
          iconWidget: const Icon(Icons.gesture),
          onTap: () {
            BrnToast.show('请在地图上绘制区域', context);
            store.dispatch(
              ClearPolygon(mapId: store.state.id),
            );
            store.dispatch(
              StartDrawPolygon(mapId: store.state.id),
            );
            setState(() {
              isDrawing = true;
            });
          },
        ),
        BrnIconButton(
          widgetHeight: 60,
          widgetWidth: 40,
          name: '定位',
          iconWidget: const Icon(Icons.my_location),
          onTap: () {
            store.dispatch(
              MoveCamera(
                mapId: store.state.id,
                cameraPosition: CameraPosition(
                  target: currentPosition,
                  zoom: store.state.cameraPosition.zoom,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    AMapFlutterLocation().stopLocation();
    super.dispose(); // This will free the memory space allocated to the page
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StoreBuilder<MapState>(
          onInit: (store) {
            store.dispatch(
              Clear(
                mapId: store.state.id,
              ),
            );

            _initResidentialMarkers(store);
            store.dispatch(
              UpdateCameraPosition(
                mapId: store.state.id,
                cameraPosition: const CameraPosition(
                  // 初始化至上海市
                  target: LatLng(31.2382, 121.4913),
                  zoom: 11,
                ),
              ),
            );
          },
          builder: (context, store) {
            return MaterialApp(
              home: Scaffold(
                appBar: isDrawing
                    ? AppBar(
                        backgroundColor: Colors.white,
                        title: const Text(
                          "画图找房",
                          style: TextStyle(color: Colors.black),
                        ),
                        centerTitle: true,
                        titleSpacing: 0.0,
                      )
                    : AppBar(
                        backgroundColor: Colors.white,
                        title: selectionInitialized ? selection : Container(),
                        centerTitle: true,
                        titleSpacing: 0.0,
                      ),
                body: StoreProvider(
                  store: store,
                  child: Stack(
                    children: [
                      MapWidget(),
                      Positioned(
                        top: 25,
                        right: 20,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: isDrawing
                              ? buildOperationsWhenDrawing(store)
                              : buildOperationsWhenNotDrawing(store),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
