import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/common/extension/marker.dart';
import 'package:app/common/extension/widget.dart';
import 'package:app/widgets/map/action.dart';
import 'package:app/widgets/map_find_marker.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../service/backend_service/house/rent_house.dart';
import '../service/backend_service/map_find_house.dart';
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
  /// 所有房源数据
  List<RentHouse> houses = [];

  /// 按照小区整理的房源数据
  Map<String, List<RentHouse>> residentialList = {};

  /// 正在画圈
  bool isDrawing = false;

  /// 地图上房源小区 Marker
  Map<String, ResidentialMapFindMarker> residentialMarkers = {};
  String focusingMarkerId = "";

  /// 筛选条件组件
  late Widget selection;
  bool selectionInitialized = false;
  Map<String, String>? filter;
  String district = "",
      rentType = "",
      rooms = "",
      metroLine = "",
      metroStation = "",
      price1 = "",
      price2 = "";

  /// 位置
  LatLng currentPosition = const LatLng(31.2382, 121.4913);

  void callback(
      int menuIndex,
      Map<String, String> filterParams,
      Map<String, String> customParams,
      BrnSetCustomSelectionMenuTitle setCustomTitleFunction) {
    setState(() {
      filter = filterParams;
      debugPrint(filterParams.toString());
      if (filter != null) {
        district = filter!["region"] ?? "";
        rooms = filter!["户型"] ?? "";
        metroLine = filter!["subway"] ?? "";
        if (filter!["price"] != null) {
          String s = filter!["price"]!;
          List<String> x = s.split(':');
          price1 = x[0];
          price2 = x[1];
        } else {
          price1 = "";
          price2 = "";
        }
      }
    });
  }

  updateFilteredHouse(Store<MapState> store) {
    residentialMarkers.forEach((key, value) {
      bool meetRequirement = true;


      store.dispatch(
        UpdateMarker(
          mapId: store.state.id,
          id: key,
          visibleParam: meetRequirement,
        ),
      );
    });
  }

  /// 发送请求拿取房源数据
  Future<void> getAllHouses() async {
    await fetchAllHouse(
      district,
      price1,
      price2,
      rentType,
      rooms,
      metroLine,
      metroStation,
    ).then((value) => {
          houses.clear(),
          houses.addAll(value),

          // debugPrint("fetchAllHouse: $page $_houseCards"),
        });
  }

  @override
  void initState() {
    super.initState();
    selectionView('assets/json/selection.json', callback).then(
      (value) => setState(
        () {
          selection = value;
          selectionInitialized = true;
        },
      ),
    );
  }

  Future<void> _initResidentialMarkers(Store<MapState> store) async {
    // 从后端拿取所有数据
    await getAllHouses();

    // 按照小区名将数据放入 map
    for (var house in houses) {
      // 小区名为空，暂时丢弃不进行渲染
      if (house.residential == "" || house.residential == null) continue;
      // 将该房源加入对应小区
      if (!residentialList.containsKey(house.residential)) {
        // 新建小区条目
        residentialList[house.residential ?? ''] = [];
      }
      residentialList[house.residential]?.add(house);
    }

    // 渲染小区 widget
    residentialList.forEach((key, value) {
      // 使用第一个房源信息的地理位置代表整个小区
      var house = value[0];
      var residentialMarkerWidget = ResidentialMapFindMarker(
        residential: house.residential ?? '',
        num: value.length,
      );
      Marker(
        onTap: (id) => _markerOnTap(id, store, context),
        position:
            LatLng(double.parse(house.latitude), double.parse(house.longitude)),
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
    _showHouseDetailListSheet(
        context, residentialMarkers[id]?.residential ?? '');
  }

  void _showHouseDetailListSheet(BuildContext context, String residential) {
    var housesList = residentialList[residential];
    var totalPrice = 0;
    var num = housesList?.length;
    housesList?.forEach((element) {
      totalPrice += element.price;
    });
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
                ListTile(
                  title: Text(
                    residential,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  subtitle: Text(
                      '均价${(totalPrice / num!).toStringAsFixed(2)}元/月 · 共$num套'),
                  trailing: const Icon(Icons.keyboard_arrow_down),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    controller: controller, // set this too
                    // 长度
                    itemCount: num,
                    itemBuilder: (_, i) => HouseCard(
                      houseDetail: toDetail(
                        housesList?[i].title ?? '',
                        housesList?[i].shi ?? -1,
                        housesList?[i].squares ?? -1,
                        housesList?[i].residential ?? '',
                        housesList?[i].price ?? -1,
                        housesList?[i].firstPicUrl ?? '',
                        housesList?[i].latitude ?? '0',
                        housesList?[i].longitude ?? '0',
                        housesList?[i].location ?? "",
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
    final set = store.state.markersInPolygon.map((e) => e.id).toSet();
    residentialMarkers.forEach(
      (key, value) {
        if (set.contains(key) != value.inPolygon) {
          value.inPolygon = set.contains(key);
          if (value.inPolygon == false) {
            value.toUint8List().then(
              (value) {
                store.dispatch(
                  UpdateMarker(
                    mapId: store.state.id,
                    id: key,
                    iconParam: BitmapDescriptor.fromBytes(value!),
                  ),
                );
              },
            );
          } else {
            value.toUint8List().then(
              (value) {
                store.dispatch(
                  UpdateMarker(
                    mapId: store.state.id,
                    id: key,
                    iconParam: BitmapDescriptor.fromBytes(value!),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }

  void _resetAllMarkers(Store<MapState> store) {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BrnIconButton(
          widgetHeight: 60,
          widgetWidth: 40,
          name: '重画',
          iconWidget: const Icon(Icons.gesture),
          onTap: () {
            // _resetAllMarkersInPolygon(store);
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
            // _resetAllMarkersInPolygon(store);
            store.dispatch(
              ClearPolygon(
                mapId: store.state.id,
              ),
            );
            store.dispatch(
              CheckPointsInPolygon(
                mapId: store.state.id,
              ),
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
    super.dispose(); // This will free the memory space allocated to the page
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StoreBuilder<MapState>(
          onInit: (store) {
            // store.dispatch(
            //   Clear(
            //     mapId: store.state.id,
            //   ),
            // );
            if(store.state.markers.isEmpty){
              _initResidentialMarkers(store);
            }
            store.dispatch(
              UpdateCameraPosition(
                mapId: store.state.id,
                cameraPosition: const CameraPosition(
                  // 初始化至上海市
                  target: LatLng(31.2382, 121.4913),
                  zoom: 15,
                ),
              ),
            );
          },
          builder: (context, store) {
            _updateMarkersInPolygon(store);
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
