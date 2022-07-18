import 'package:amap_flutter_base/amap_flutter_base.dart';
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
import '../utils/storage.dart';
import '../widgets/house_card.dart';
import '../widgets/house_list/house_data.dart';
import '../widgets/map.dart';
import '../widgets/map/state.dart';
import '../widgets/map/type.dart';
import '../widgets/selection.dart';

class MapFindPage extends StatefulWidget {
  const MapFindPage({Key? key}) : super(key: key);

  @override
  State<MapFindPage> createState() => _MapFindPageState();
}

class _MapFindPageState extends State<MapFindPage> {
  /// 所有房源数据
  List<RentHouse> houses = [];

  /// 正在画圈
  bool isDrawing = false;

  /// 地图上房源小区 Marker
  String focusingMarkerId = "";

  /// 在圈内的 markers 的 id
  Set<String> markersIdInPolygon = {};

  /// 被点击过的 markers id 与 相应小区及房源信息 map
  Map<String, HouseMarker?> tappedMarkers = {};

  /// 筛选条件组件
  bool selectionChanged = false;
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
  double currentPositionLat = 31.2382;
  double currentPositionLng = 121.4913;

  void callback(
      int menuIndex,
      Map<String, String> filterParams,
      Map<String, String> customParams,
      BrnSetCustomSelectionMenuTitle setCustomTitleFunction) {
    setState(
      () {
        filter = filterParams;
        print(filterParams.toString());
        if (filter != null) {
          district = filter!["region"] ?? "";
          rooms = filter!["户型"] ?? "";
          metroLine = filter!["subway"] ?? "";
          metroStation = filter?["station"] ?? "";
          rentType = filter?["类型"] ?? "";
          if (filter!["price"] != null) {
            String s = filter!["price"]!;
            List<String> x = s.split(':');
            price1 = x[0];
            price2 = x[1];
          } else {
            price1 = "";
            price2 = "";
          }
          selectionChanged = true;
        }
      },
    );
  }

  updateFilteredHouse(Store<MapState> store) {
    int priceLow = (price1 == '') ? -1 : int.parse(price1);
    int priceHigh = (price2 == '') ? -1 : int.parse(price2);

    int mLine = (metroLine == '') ? -1 : int.parse(metroLine);
    List<String> zhan = (metroStation == '') ? [] : metroStation.split(',');

    List<int> shi = [];
    List<String> x = (rooms == '') ? [] : rooms.split(',');
    for (final xi in x) {
      shi.add(int.parse(xi));
    }

    List<int> rType = [];
    List<String> y = (rentType == '') ? [] : rentType.split(',');
    for (final yi in y) {
      rType.add(int.parse(yi));
    }

    final residentialMarkers = keyByHosueMarkerId(store.state.markers);

    for (final marker in store.state.oriMarkers) {
      var housesList = marker.houses;
      var filteredHousesList = <RentHouse>[];
      bool residentialHasMeetRequirement = false;
      // 遍历检查是否有符合条件的
      for (final house in housesList) {
        bool houseMeetRequirement = true;

        // region
        if (district != '' && house.district != district) {
          houseMeetRequirement = false;
        }

        // price
        if (priceLow != -1 &&
            (house.price < priceLow || house.price > priceHigh)) {
          houseMeetRequirement = false;
        }

        // shi
        if (shi.isNotEmpty) {
          houseMeetRequirement =
              houseMeetRequirement && shi.any((e) => e == house.shi);
        }

        // type
        if (rType.isNotEmpty) {
          houseMeetRequirement =
              houseMeetRequirement && rType.any((e) => e == house.rentType);
        }

        // metro
        if (mLine != -1 && mLine != house.metroLine) {
          houseMeetRequirement = false;
        }

        if (houseMeetRequirement) {
          filteredHousesList.add(house);
        }
      }

      residentialHasMeetRequirement = (filteredHousesList.isNotEmpty);

      if (residentialHasMeetRequirement &&
          filteredHousesList.length !=
              residentialMarkers[marker.id]?.houses.length) {
        var residentialMapFindMarker = ResidentialMapFindMarker(
          residential: filteredHousesList[0].residential ?? '',
          num: filteredHousesList.length,
        );
        residentialMapFindMarker.toUint8List().then(
          (value) {
            store.dispatch(
              UpdateMarker(
                iconParam: BitmapDescriptor.fromBytes(value!),
                mapId: store.state.id,
                id: marker.id,
                visibleParam: residentialHasMeetRequirement,
                housesParam: residentialHasMeetRequirement
                    ? filteredHousesList
                    : housesList,
              ),
            );
          },
        );
      } else {
        store.dispatch(
          UpdateMarker(
            mapId: store.state.id,
            id: marker.id,
            visibleParam: residentialHasMeetRequirement,
            housesParam:
                residentialHasMeetRequirement ? filteredHousesList : housesList,
          ),
        );
      }
    }
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

  Future _updatePos() async {
    await StorageUtil.getDoubleItem('lat').then((res) async => {
          currentPositionLat = res,
        });
    await StorageUtil.getDoubleItem('lng').then((res) async => {
          currentPositionLng = res,
        });
  }

  Future<void> _updateResidentialMarkersOnTap(Store<MapState> store) async {
    for (var m in store.state.markers) {
      store.dispatch(
        UpdateMarker(
          id: m.id,
          onTapParam: (id) => _markerOnTap(id!, store, context),
          mapId: store.state.id,
        ),
      );
    }
  }

  Future<void> _initResidentialMarkers(Store<MapState> store) async {
    // 从后端拿取所有数据
    await getAllHouses();

    // 按照小区名将数据放入 map
    /// 按照小区整理的房源数据
    Map<String, List<RentHouse>> residentialList = {};

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
      HouseMarker(
        onTap: (id) => _markerOnTap(id, store, context),
        position:
            LatLng(double.parse(house.latitude), double.parse(house.longitude)),
        draggable: false,
        houses: value,
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
        store.dispatch(
          AddOriMarker(
            mapId: store.state.id,
            marker: value,
          ),
        );
      });
    });
  }

  void _markerOnTap(String id, Store<MapState> store, BuildContext context) {
    /// 依据 id 从 residentialMarkers 中取出对应 widget
    print("onTap$id");

    /// 建立索引
    final residentialMarkers = keyByHosueMarkerId(store.state.markers);

    tappedMarkers[id] = residentialMarkers[id];
    focusingMarkerId = id;
    var residentialMapFindMarker = ResidentialMapFindMarker(
      residential: residentialMarkers[id]?.houses[0].residential ?? '',
      num: residentialMarkers[id]?.houses.length ?? 0,
    );
    residentialMapFindMarker.focus = true;
    residentialMapFindMarker.toUint8List().then(
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
    _showHouseDetailListSheet(context, residentialMarkers[id]);
  }

  void _showHouseDetailListSheet(
    BuildContext context,
    HouseMarker? houseMarker,
  ) {
    var housesList = houseMarker?.houses;
    var totalPrice = 0;
    var num = housesList?.length;
    var residential = housesList?[0].residential;
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
                    residential ?? '',
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
                        housesList?[i].id ?? "",
                        housesList?[i].layout ?? "nothing",
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
    // 建立本次多边形中 markers 的 id 与 相关信息的索引
    final markersInPolygonMap =
        keyByHosueMarkerId(store.state.markersInPolygon);

    /// 建立索引
    final residentialMarkers = keyByHosueMarkerId(store.state.markers);

    // 将上一次在圈内，这一次不在圈内的恢复原样
    for (final id in markersIdInPolygon) {
      if (!markersInPolygonMap.containsKey(id)) {
        final residentialMapFindMarker = ResidentialMapFindMarker(
          residential: residentialMarkers[id]?.houses[0].residential ?? '',
          num: residentialMarkers[id]?.houses.length ?? 0,
        );
        residentialMapFindMarker.inPolygon = false;
        residentialMapFindMarker.toUint8List().then(
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
      }
    }

    // 遍历这一次在圈内的
    markersInPolygonMap.forEach((residentialMarkerId, value) {
      // 上一次不在圈内
      if (!markersIdInPolygon.contains(residentialMarkerId)) {
        var residentialMapFindMarker = ResidentialMapFindMarker(
          residential:
              markersInPolygonMap[residentialMarkerId]?.houses[0].residential ??
                  '',
          num: markersInPolygonMap[residentialMarkerId]?.houses.length ?? 0,
        );
        residentialMapFindMarker.inPolygon = true;
        residentialMapFindMarker.toUint8List().then(
          (value) {
            store.dispatch(
              UpdateMarker(
                mapId: store.state.id,
                id: residentialMarkerId,
                iconParam: BitmapDescriptor.fromBytes(value!),
              ),
            );
          },
        );
      }
    });

    // 更新圈内 id 集合
    markersIdInPolygon.clear();
    markersInPolygonMap.forEach((residentialMarkerId, value) {
      markersIdInPolygon.add(residentialMarkerId);
    });
  }

  // void _resetAllMarkers(Store<MapState> store) {
  //   for (final element in store.state.markers) {
  //     residentialMarkers[element.id]?.inPolygon = false;
  //     residentialMarkers[element.id]?.toUint8List().then(
  //       (value) {
  //         store.dispatch(
  //           UpdateMarker(
  //             mapId: store.state.id,
  //             id: element.id,
  //             iconParam: BitmapDescriptor.fromBytes(value!),
  //           ),
  //         );
  //       },
  //     );
  //   }
  // }

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
          onTap: () async {
            await _updatePos();
            store.dispatch(
              MoveCamera(
                mapId: store.state.id,
                cameraPosition: CameraPosition(
                  target: LatLng(currentPositionLat, currentPositionLng),
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
    super.dispose();
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
            if (store.state.markers.isEmpty) {
              _initResidentialMarkers(store);
            } else {
              _updateResidentialMarkersOnTap(store);
              selectionChanged = true;
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
          onDispose: (store) {
            store.dispatch(
              EndDrawPolygon(
                mapId: store.state.id,
              ),
            );
          },
          builder: (context, store) {
            _updateMarkersInPolygon(store);
            if (selectionChanged) {
              updateFilteredHouse(store);
              selectionChanged = false;
            }
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
